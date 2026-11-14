import 'package:application_thaweeyont/utility/my_constant.dart';
import 'package:application_thaweeyont/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

import 'stock_count_common.dart';
import 'stock_scan_draft.dart';
import 'stock_scanner_page.dart';

/// หน้าที่ 2: สแกนเลขเครื่องของสินค้าที่เลือกจากหน้าค้นหา
/// รับ [item] (มี itemId, whId) และ [draft] (ฉบับร่างที่เก็บรายการสแกนทั้งหมด)
class StockScanPage extends StatefulWidget {
  final StockItem item;
  final ScanDraft draft;
  const StockScanPage({super.key, required this.item, required this.draft});

  @override
  State<StockScanPage> createState() => _StockScanPageState();
}

class _StockScanPageState extends State<StockScanPage> {
  final _ctrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.draft.addListener(_onDraftChanged);
    // ตรวจสอบว่าหน้านี้ได้รับ itemId จากหน้าค้นหาแล้ว (ดูใน Debug Console)
    debugPrint('StockScanPage รับ itemId: ${widget.item.itemId} '
        '(whId: ${widget.item.whId}, branchId: ${widget.item.branchId})');
  }

  @override
  void dispose() {
    widget.draft.removeListener(_onDraftChanged);
    _ctrl.dispose();
    super.dispose();
  }

  void _onDraftChanged() {
    if (mounted) setState(() {});
  }

  // เปิดกล้องสแกน แล้วนำค่าที่อ่านได้ไปใส่ในช่องเลขเครื่อง
  Future<void> _scan() async {
    FocusScope.of(context).unfocus();
    final code = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (_) => const StockScannerPage()),
    );
    debugPrint('[หน้าบันทึกสแกน] ได้รับค่าจากกล้อง: $code');
    if (code != null && mounted) {
      setState(() {
        _ctrl.value = TextEditingValue(
          text: code,
          selection: TextSelection.collapsed(offset: code.length),
        );
      });
    }
  }

  // กดไอคอนเช็คถูก (หรือ Enter) → เพิ่มเลขเครื่องลงฉบับร่าง
  void _addSerial() {
    final serial = _ctrl.text.trim();
    if (serial.isEmpty) return;

    final ok = widget.draft.add(widget.item, serial);
    if (!ok) {
      showAppAlert(context, 'แจ้งเตือน', 'เลขเครื่อง $serial ถูกสแกนแล้ว');
      return;
    }
    _ctrl.clear();
    debugPrint('[หน้าบันทึกสแกน] เพิ่มเลขเครื่อง: $serial '
        '(itemId: ${widget.item.itemId}, whId: ${widget.item.whId}) '
        'ฉบับร่างรวม ${widget.draft.serialCount} เลขเครื่อง '
        '/ ${widget.draft.itemCount} สินค้า');
  }

  String _v(String s) => s.isEmpty ? '-' : s;

  String _hm(DateTime t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  Widget _entryRow(int index, int total, DraftSerial e) {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: kBlue.withValues(alpha: 0.12))),
      ),
      padding: const EdgeInsets.only(left: 4),
      child: Row(
        children: [
          SizedBox(
            width: 32,
            child: Text('${total - index}', style: appText(size: 12.5)),
          ),
          Expanded(
            child:
                Text(e.serial, style: appText(size: 13, color: Colors.black)),
          ),
          Text(_hm(e.time),
              style: appText(size: 12, color: Colors.grey.shade600)),
          IconButton(
            visualDensity: VisualDensity.compact,
            tooltip: 'ลบ',
            icon: Icon(Icons.close, size: 18, color: Colors.grey.shade600),
            onPressed: () => widget.draft.remove(widget.item, e.serial),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final it = widget.item;
    final scanned = widget.draft.serialsOf(it);
    return Scaffold(
      appBar: const CustomAppbar(title: 'ตรวจนับสต็อคสินค้า'),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SegmentTabs(index: 0, onChanged: (_) {}),
            const SizedBox(height: 16),
            Panel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    SizedBox(
                        width: 56, child: Text('สินค้า :', style: appText())),
                    Expanded(
                        child: Text(_v(it.itemTypeName),
                            style: appText(weight: FontWeight.w700))),
                  ]),
                  const SizedBox(height: 8),
                  Row(children: [
                    SizedBox(
                        width: 56, child: Text('ยี่ห้อ :', style: appText())),
                    Text(_v(it.brandName), style: appText()),
                    const SizedBox(width: 24),
                    Expanded(
                        child: Text('รุ่น : ${_v(it.modelName)}',
                            style: appText())),
                  ]),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SerialField(
              controller: _ctrl,
              hint: 'สแกนเลขเครื่อง หรือกรอกเอง',
              onScanTap: _scan,
              onSubmit: _addSerial,
            ),
            const SizedBox(height: 12),
            // บันทึกฉบับร่างทั้งหมด (ทุกสินค้า ทุกคลังที่สแกนไว้) ในครั้งเดียว
            PrimaryButton(
              label: 'บันทึกการสแกน',
              onPressed: () => saveScanDraft(context, widget.draft),
            ),
            const SizedBox(height: 16),
            Panel(
              color: Colors.white,
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.assignment_outlined, color: kNavy),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text('รายการที่สแกนในรอบนี้',
                            style: appText(weight: FontWeight.w700, size: 15)),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: kPanel,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text('จำนวน ${scanned.length} รายการ',
                            style: appText(color: kBlue, size: 12.5)),
                      ),
                    ],
                  ),
                  if (scanned.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    for (var i = 0; i < scanned.length; i++)
                      _entryRow(i, scanned.length, scanned[i]),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
