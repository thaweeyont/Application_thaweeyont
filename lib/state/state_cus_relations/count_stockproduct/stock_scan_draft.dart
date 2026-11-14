import 'dart:convert';

import 'package:application_thaweeyont/utility/my_constant.dart';
import 'package:flutter/material.dart';

import 'stock_count_common.dart';

// ═════════════ ฉบับร่างการสแกน (ยังไม่บันทึก) ═════════════

/// เลขเครื่องหนึ่งตัวที่สแกน/กรอกแล้ว
class DraftSerial {
  final String serial;
  final DateTime time;
  const DraftSerial(this.serial, this.time);
}

/// สินค้าหนึ่งรายการ (itemId + whId) พร้อมเลขเครื่องที่สแกนไว้
class DraftEntry {
  final StockItem item;
  final List<DraftSerial> serials = []; // เรียงเก่า → ใหม่
  DraftEntry(this.item);
}

/// เก็บรายการที่สแกนไว้ทั้งหมดก่อนกดบันทึกครั้งเดียว (สแกนได้หลายสินค้า หลายคลัง)
/// อยู่ที่หน้าหลักของเมนู ส่งต่อให้หน้าสแกนผ่าน constructor
class ScanDraft extends ChangeNotifier {
  final Map<String, DraftEntry> _entries = {};

  String _key(StockItem it) => '${it.whId}|${it.itemId}';

  /// เลขเครื่องของสินค้านี้ (เรียกใหม่สุดก่อน)
  List<DraftSerial> serialsOf(StockItem it) {
    final e = _entries[_key(it)];
    return e == null ? [] : e.serials.reversed.toList();
  }

  int countOf(StockItem it) => _entries[_key(it)]?.serials.length ?? 0;

  bool get hasUnsaved => _entries.values.any((e) => e.serials.isNotEmpty);
  int get itemCount =>
      _entries.values.where((e) => e.serials.isNotEmpty).length;
  int get serialCount =>
      _entries.values.fold(0, (sum, e) => sum + e.serials.length);

  bool _exists(String serial) =>
      _entries.values.any((e) => e.serials.any((s) => s.serial == serial));

  /// เพิ่มเลขเครื่อง — คืน false ถ้าซ้ำกับที่สแกนไว้แล้ว (ทั้งฉบับร่าง ไม่เฉพาะสินค้านี้)
  bool add(StockItem it, String serial) {
    if (_exists(serial)) return false;
    final e = _entries.putIfAbsent(_key(it), () => DraftEntry(it));
    e.serials.add(DraftSerial(serial, DateTime.now()));
    notifyListeners();
    return true;
  }

  void remove(StockItem it, String serial) {
    final k = _key(it);
    final e = _entries[k];
    if (e == null) return;
    e.serials.removeWhere((s) => s.serial == serial);
    if (e.serials.isEmpty) _entries.remove(k);
    notifyListeners();
  }

  void clear() {
    _entries.clear();
    notifyListeners();
  }

  String _hhmm(DateTime t) =>
      '${t.hour.toString().padLeft(2, '0')}${t.minute.toString().padLeft(2, '0')}';

  /// สร้าง body ตามรูปแบบตัวอย่างของ API บันทึก:
  /// { note, stockArrs: [ { whId, time: "HHmm", items: [ {id, serials:[...]} ] } ] }
  Map<String, dynamic> toBody({String note = ''}) {
    final byWh = <String, List<DraftEntry>>{};
    for (final e in _entries.values) {
      if (e.serials.isEmpty) continue;
      byWh.putIfAbsent(e.item.whId, () => []).add(e);
    }
    return {
      'note': note,
      'stockArrs': [
        for (final wh in byWh.entries)
          {
            'whId': wh.key,
            // เวลาที่สแกนรายการแรกของคลังนั้น
            'time': _hhmm(wh.value
                .expand((e) => e.serials)
                .map((s) => s.time)
                .reduce((a, b) => a.isBefore(b) ? a : b)),
            'items': [
              for (final e in wh.value)
                {
                  'id': e.item.itemId,
                  'serials': e.serials.map((s) => s.serial).toList(),
                }
            ],
          }
      ],
    };
  }
}

// ═════════════ กล่องข้อความ 2 ปุ่ม (ยืนยัน/ยกเลิก) ═════════════
/// กล่องยืนยันหน้าตาเดียวกับ showAppAlert แต่มี 2 ปุ่ม คืน true เมื่อกดปุ่มยืนยัน
Future<bool?> showAppConfirm(
  BuildContext context,
  String title,
  String message, {
  String confirmText = 'ตกลง',
  String cancelText = 'ยกเลิก',
  Color confirmColor = kBlue,
}) {
  final base = MyContant().h4normalStyle();
  const accent = Color(0xFFF5A623);
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => Dialog(
      backgroundColor: Colors.white,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 36),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.14),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Container(
                  width: 58,
                  height: 58,
                  decoration: const BoxDecoration(
                      color: accent, shape: BoxShape.circle),
                  child: const Icon(Icons.priority_high_rounded,
                      color: Colors.white, size: 34),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text(title,
                textAlign: TextAlign.center,
                style: base.copyWith(
                    fontSize: 20, fontWeight: FontWeight.w600, color: kNavy)),
            const SizedBox(height: 8),
            Text(message,
                textAlign: TextAlign.center,
                style: base.copyWith(
                    fontSize: 15, height: 1.5, color: Colors.grey.shade700)),
            const SizedBox(height: 22),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 46,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey.shade400),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () => Navigator.of(ctx).pop(false),
                      child: Text(cancelText,
                          style: base.copyWith(
                              fontSize: 16, color: Colors.grey.shade800)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 46,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: confirmColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () => Navigator.of(ctx).pop(true),
                      child: Text(confirmText,
                          style: base.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

// ═════════════ บันทึกทั้งหมด (หน้าหลักและหน้าสแกนเรียกใช้ร่วมกัน) ═════════════
class _NoteDialog extends StatefulWidget {
  const _NoteDialog();

  @override
  State<_NoteDialog> createState() => _NoteDialogState();
}

class _NoteDialogState extends State<_NoteDialog> {
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text('บันทึกการสแกน',
          style: appText(weight: FontWeight.w600, size: 18)),
      content: TextField(
        controller: _ctrl,
        maxLines: 3,
        style: appText(),
        decoration: InputDecoration(
          hintText: 'หมายเหตุ (ถ้ามี)',
          hintStyle: appText(color: kNavy.withValues(alpha: 0.4)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('ยกเลิก', style: appText(color: Colors.grey.shade700)),
        ),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: kBlue),
          onPressed: () => Navigator.pop(context, _ctrl.text.trim()),
          child: Text('บันทึก', style: appText(color: Colors.white)),
        ),
      ],
    );
  }
}

/// กดบันทึกทั้งหมด: ถามหมายเหตุ แล้วสร้าง body ตามรูปแบบ API
/// TODO: ยังไม่ได้เชื่อม API บันทึก — ตอนนี้พิมพ์ body ใน Debug Console เท่านั้น
/// เมื่อต่อ API แล้ว: เรียก API ด้วย body นี้ ถ้าสำเร็จให้ draft.clear()
Future<void> saveScanDraft(BuildContext context, ScanDraft draft) async {
  FocusScope.of(context).unfocus();
  if (!draft.hasUnsaved) {
    showAppAlert(context, 'แจ้งเตือน', 'ยังไม่มีรายการที่สแกน',
        type: AlertType.info);
    return;
  }

  final note = await showDialog<String>(
    context: context,
    builder: (_) => const _NoteDialog(),
  );
  if (note == null || !context.mounted) return; // กดยกเลิก

  final body = draft.toBody(note: note);
  debugPrint('[บันทึกสแกน] body: ${jsonEncode(body)}');

  showAppAlert(
    context,
    'แจ้งเตือน',
    'ยังไม่ได้เชื่อม API บันทึก\n(พิมพ์ข้อมูลที่จะส่งไว้ใน Debug Console แล้ว)',
    type: AlertType.info,
  );
}
