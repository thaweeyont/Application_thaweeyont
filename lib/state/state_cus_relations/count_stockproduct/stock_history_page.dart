import 'dart:convert';

import 'package:application_thaweeyont/utility/my_constant.dart';
import 'package:application_thaweeyont/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'stock_count_common.dart';
import 'stock_history_detail_page.dart';
import 'stock_history_models.dart';
import 'stock_item_api.dart';

/// หน้า "ประวัติการตรวจนับ": ตัวกรอง (ช่วงวันที่ / คลัง / ประเภท) + รายการรอบที่ตรวจนับ
class StockHistoryPage extends StatefulWidget {
  const StockHistoryPage({super.key});

  @override
  State<StockHistoryPage> createState() => _StockHistoryPageState();
}

class _StockHistoryPageState extends State<StockHistoryPage> {
  final _scroll = ScrollController();

  late DateTimeRange _range;
  PickItem? _warehouse; // null = ทั้งหมด
  String _typeKey = 'all'; // all / serial / qty
  String _branchId = ''; // สาขาของผู้ใช้ (ใช้ตอนค้นหาคลัง)

  List<HistorySession> _results = [];
  bool _searched = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _range = DateTimeRange(
      start: DateTime(now.year, now.month, 1),
      end: DateTime(now.year, now.month + 1, 0),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _init());
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  // โหลดสาขาของผู้ใช้ (ใช้ตอนค้นหาคลัง) — ไม่ค้นหาอัตโนมัติ ให้ผู้ใช้กดค้นหาเอง
  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    _branchId = prefs.getString('branchId') ?? '';
  }

  // เปลี่ยนตัวกรองแล้วล้างผลเดิม (กลับไปแสดงข้อความแนะนำ)
  void _resetResult() {
    _results = [];
    _searched = false;
  }

  // TODO: ยืนยันค่า stockType ของแต่ละประเภทใน API checkHistory
  // (ทั้งหมด = "" / สแกนเลขเครื่อง = "1" / นับจำนวนสินค้า = "2")
  String get _stockType => _typeKey == 'serial'
      ? '1'
      : _typeKey == 'qty'
          ? '2'
          : '';

  Future<void> _pickRange() async {
    FocusScope.of(context).unfocus();
    final r = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(DateTime.now().year + 1, 12, 31),
      initialDateRange: _range,
      helpText: 'เลือกช่วงวันที่',
      saveText: 'ตกลง',
    );
    if (r != null && mounted) {
      setState(() {
        _range = r;
        _resetResult();
      });
    }
  }

  Future<void> _pickWarehouse() async {
    FocusScope.of(context).unfocus();
    if (_branchId.isEmpty) {
      showAppAlert(context, 'แจ้งเตือน', 'ไม่พบข้อมูลสาขาของผู้ใช้');
      return;
    }
    final picked = await Navigator.of(context).push<PickItem>(
      MaterialPageRoute(
        builder: (_) => SearchPickerPage(
          title: 'ค้นหาคลัง',
          idHeader: 'รหัส',
          nameHeader: 'ชื่อคลังสินค้า',
          onSearch: (kw) =>
              StockItemApi.warehouseList(context, kw, branchId: _branchId),
        ),
      ),
    );
    if (picked != null && mounted) {
      setState(() {
        _warehouse = picked;
        _resetResult();
      });
    }
  }

  Future<void> _search() async {
    FocusScope.of(context).unfocus();
    showProgressLoading(context);

    Map<String, dynamic>? res;
    Object? error;
    try {
      res = await StockItemApi.checkHistory(
        context,
        stockType: _stockType,
        startDate: formatBeApiDate(_range.start),
        endDate: formatBeApiDate(_range.end),
        whId: [if (_warehouse != null) _warehouse!.id],
      );
    } catch (e) {
      error = e;
    }

    if (error is SessionExpiredException) return;
    if (!mounted) return;
    Navigator.pop(context); // ปิด loading

    if (error != null) {
      final msg =
          error is ApiException ? error.message : 'กรุณาแจ้งผู้ดูแลระบบ';
      showAppAlert(context, 'แจ้งเตือน', msg, type: AlertType.error);
      return;
    }

    if (res == null) {
      // "ไม่พบข้อมูล"
      setState(() {
        _results = [];
        _searched = true;
      });
      return;
    }

    // พบข้อมูล แต่ยังไม่ทราบรูปแบบ response → พิมพ์ไว้ให้ดูก่อน
    // TODO: แปลง res เป็น List<HistorySession> (ต้องมี tranId สำหรับหน้ารายละเอียด)
    debugPrint('[ประวัติ] พบข้อมูล: ${jsonEncode(res)}');
    setState(() {
      _results = [];
      _searched = false;
    });
    showAppAlert(
      context,
      'แจ้งเตือน',
      'พบข้อมูลแล้ว แต่ยังไม่ได้กำหนดรูปแบบการแสดงผล\n(พิมพ์ข้อมูลไว้ใน Debug Console แล้ว)',
      type: AlertType.info,
    );
  }

  void _open(HistorySession s) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => StockHistoryDetailPage(session: s)),
    );
  }

  // แถวตัวกรอง: ไอคอน + ชื่อ + ช่อง
  Widget _row(IconData icon, String label, Widget field) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
            height: 46,
            child: Center(child: Icon(icon, color: kBlue, size: 22))),
        const SizedBox(width: 8),
        SizedBox(
          width: 84,
          height: 46,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(label, style: appText(size: 14)),
          ),
        ),
        Expanded(child: field),
      ],
    );
  }

  Widget _filterPanel() {
    final dateField = Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: _pickRange,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: 46,
          padding: const EdgeInsets.only(left: 12, right: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '${formatBeDate(_range.start)} - ${formatBeDate(_range.end)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: appText(size: 14),
                ),
              ),
              const Icon(Icons.arrow_drop_down, color: kNavy),
            ],
          ),
        ),
      ),
    );

    final typeField = Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: DropdownButtonFormField<String>(
        initialValue: _typeKey,
        isExpanded: true,
        style: appText(),
        icon: const Icon(Icons.arrow_drop_down, color: kNavy),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          isDense: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
        items: [
          DropdownMenuItem(
              value: 'all', child: Text('ทั้งหมด', style: appText())),
          DropdownMenuItem(
              value: 'serial',
              child: Text(CountType.serial.label, style: appText())),
          DropdownMenuItem(
              value: 'qty', child: Text(CountType.qty.label, style: appText())),
        ],
        onChanged: (v) => setState(() {
          _typeKey = v ?? 'all';
          _resetResult();
        }),
      ),
    );

    return Panel(
      child: Column(
        children: [
          _row(Icons.calendar_month_outlined, 'ช่วงวันที่', dateField),
          _row(
            Icons.warehouse_outlined,
            'คลัง',
            PickerField(
              label: 'ทั้งหมด',
              valueText: _warehouse?.name,
              onTap: _pickWarehouse,
              onClear: () => setState(() {
                _warehouse = null;
                _resetResult();
              }),
            ),
          ),
          _row(Icons.qr_code_2, 'ประเภทสินค้า', typeField),
        ],
      ),
    );
  }

  Widget _card(HistorySession s) {
    final isSerial = s.type == CountType.serial;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => _open(s),
          child: Container(
            padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: kBlue.withValues(alpha: 0.18)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_month_outlined,
                        color: kBlue, size: 22),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text.rich(TextSpan(
                        text: formatBeLong(s.date),
                        style: appText(weight: FontWeight.w700, size: 15),
                        children: [
                          TextSpan(
                            text: '  (รอบที่ ${s.round})',
                            style:
                                appText(color: Colors.grey.shade700, size: 13),
                          ),
                        ],
                      )),
                    ),
                    const Icon(Icons.chevron_right, color: kBlue),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30, top: 6),
                  child: Text('ผู้ตรวจ : ${s.inspector}',
                      style: appText(size: 14)),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: isSerial ? Colors.white : kPanel,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color:
                                kBlue.withValues(alpha: isSerial ? 0.7 : 0.2)),
                      ),
                      child: Text(s.type.shortLabel,
                          style: appText(
                              color: isSerial ? kBlue : kNavy, size: 12.5)),
                    ),
                    Expanded(
                      child: Center(
                        child:
                            Text('${s.count} รายการ', style: appText(size: 13)),
                      ),
                    ),
                    SizedBox(
                      height: 36,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: kBlue,
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () => _open(s),
                        child: Text('ดูรายละเอียด',
                            style: appText(color: Colors.white, size: 13)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // การ์ดข้อความแนะนำ (แสดงก่อนกดค้นหา)
  Widget _hintCard() {
    return Panel(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: kBlue),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'กรุณาเลือกข้อมูลที่ต้องการค้นหา',
              style: appText().copyWith(height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  // การ์ด "ไม่พบข้อมูล" (แสดงเฉพาะเมื่อกดค้นหาแล้วไม่พบ)
  Widget _notFoundCard() {
    return Panel(
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: kBlue.withValues(alpha: 0.2)),
            ),
            child: const Icon(Icons.search_off_rounded, color: kBlue, size: 34),
          ),
          const SizedBox(height: 14),
          Text('ไม่พบข้อมูล',
              style: appText(weight: FontWeight.w700, size: 17)),
          const SizedBox(height: 6),
          Text(
            'ลองเปลี่ยนช่วงวันที่ คลัง หรือประเภทสินค้า\nแล้วค้นหาอีกครั้ง',
            textAlign: TextAlign.center,
            style: appText(size: 13.5, color: Colors.grey.shade700)
                .copyWith(height: 1.5),
          ),
        ],
      ),
    );
  }

  List<Widget> _resultSection() {
    if (!_searched) return [_hintCard()];
    if (_results.isEmpty) return [_notFoundCard()];
    return [for (final s in _results) _card(s)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: 'ประวัติการตรวจนับ'),
      floatingActionButton: BackToTopButton(controller: _scroll),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: ListView(
          controller: _scroll,
          padding: const EdgeInsets.all(16),
          children: [
            _filterPanel(),
            const SizedBox(height: 12),
            PrimaryButton(
                label: 'ค้นหา', icon: Icons.search, onPressed: _search),
            const SizedBox(height: 16),
            ..._resultSection(),
          ],
        ),
      ),
    );
  }
}
