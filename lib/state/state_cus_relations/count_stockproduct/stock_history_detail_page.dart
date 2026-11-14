import 'dart:convert';

import 'package:application_thaweeyont/utility/my_constant.dart';
import 'package:application_thaweeyont/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

import 'stock_count_common.dart';
import 'stock_history_models.dart';
import 'stock_item_api.dart';

/// หน้า "รายละเอียดการตรวจนับ" ของแต่ละรอบ
/// - แบบสแกนเลขเครื่อง: ลำดับ / เลขเครื่อง / สถานะ / หมายเหตุ
/// - แบบนับจำนวน: ลำดับ / สินค้า / จำนวนในระบบ / จำนวนที่ตรวจจริง / หมายเหตุ
class StockHistoryDetailPage extends StatefulWidget {
  final HistorySession session;
  const StockHistoryDetailPage({super.key, required this.session});

  @override
  State<StockHistoryDetailPage> createState() => _StockHistoryDetailPageState();
}

class _StockHistoryDetailPageState extends State<StockHistoryDetailPage> {
  bool _showAll = false;

  @override
  void initState() {
    super.initState();
    if (widget.session.tranId.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadDetail());
    }
  }

  // เรียก API รายละเอียดด้วย tranId
  // TODO: แปลง response เป็นรายการในตาราง (รอรูปแบบ response เมื่อพบข้อมูล)
  Future<void> _loadDetail() async {
    showProgressLoading(context);
    Map<String, dynamic>? res;
    Object? error;
    try {
      res = await StockItemApi.checkHistoryDetail(context,
          tranId: widget.session.tranId);
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
    debugPrint(
        '[รายละเอียดประวัติ] ${res == null ? 'ไม่พบข้อมูล' : jsonEncode(res)}');
  }

  Widget _kv(String k, String v) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 80, child: Text(k, style: appText(size: 14))),
            Text(': ', style: appText(size: 14)),
            Expanded(
              child: Text(v.isEmpty ? '-' : v,
                  style: appText(size: 14, color: Colors.black)),
            ),
          ],
        ),
      );

  Widget _head(String t, {TextAlign align = TextAlign.left}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(t,
            textAlign: align,
            style: appText(weight: FontWeight.w600, size: 12.5)),
      );

  Widget _cell(String t, {TextAlign align = TextAlign.left}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(t.isEmpty ? '-' : t,
            textAlign: align, style: appText(size: 13, color: Colors.black)),
      );

  Widget _statusChip(bool found) => Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: found ? kOkBg : kErrBg,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(found ? 'พบในระบบ' : 'ไม่พบในระบบ',
              style: appText(
                  color: found ? kOkFg : kErrFg,
                  weight: FontWeight.w600,
                  size: 12)),
        ),
      );

  BoxDecoration get _rowLine => BoxDecoration(
        border: Border(top: BorderSide(color: kBlue.withValues(alpha: 0.12))),
      );

  Widget _serialTable(List<HistoryLine> rows) {
    return Table(
      columnWidths: const {
        0: FixedColumnWidth(40),
        1: FlexColumnWidth(3),
        2: FlexColumnWidth(2.8),
        3: FlexColumnWidth(1.4),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(children: [
          _head('ลำดับ'),
          _head('เลขเครื่อง'),
          _head('สถานะ'),
          _head('หมายเหตุ', align: TextAlign.center),
        ]),
        for (var i = 0; i < rows.length; i++)
          TableRow(decoration: _rowLine, children: [
            _cell('${i + 1}'),
            _cell(rows[i].serial),
            _statusChip(rows[i].found),
            _cell(rows[i].note, align: TextAlign.center),
          ]),
      ],
    );
  }

  Widget _qtyTable(List<HistoryLine> rows) {
    return Table(
      columnWidths: const {
        0: FixedColumnWidth(36),
        1: FlexColumnWidth(3),
        2: FlexColumnWidth(1.7),
        3: FlexColumnWidth(1.7),
        4: FlexColumnWidth(1.4),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(children: [
          _head('ลำดับ'),
          _head('สินค้า'),
          _head('จำนวนใน\nระบบ', align: TextAlign.center),
          _head('จำนวนที่\nตรวจจริง', align: TextAlign.center),
          _head('หมายเหตุ', align: TextAlign.center),
        ]),
        for (var i = 0; i < rows.length; i++)
          TableRow(decoration: _rowLine, children: [
            _cell('${i + 1}'),
            _cell(rows[i].product),
            _cell('${rows[i].systemQty}', align: TextAlign.center),
            _cell('${rows[i].actualQty}', align: TextAlign.center),
            _cell(rows[i].note, align: TextAlign.center),
          ]),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.session;
    final rows = _showAll ? s.lines : s.lines.take(5).toList();
    final isSerial = s.type == CountType.serial;

    return Scaffold(
      appBar: const CustomAppbar(title: 'รายละเอียดการตรวจนับ'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Panel(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 2),
                  child: Icon(Icons.calendar_month_outlined,
                      color: kBlue, size: 26),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(TextSpan(
                        text: formatBeLong(s.date),
                        style: appText(weight: FontWeight.w700, size: 16),
                        children: [
                          TextSpan(
                            text: '  (รอบที่ ${s.round})',
                            style:
                                appText(color: Colors.grey.shade700, size: 14),
                          ),
                        ],
                      )),
                      const SizedBox(height: 6),
                      _kv('ประเภท', s.type.label),
                      _kv('คลัง', s.whName),
                      _kv('ผู้ตรวจ', s.inspector),
                      _kv('เวลา', s.timeText),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Panel(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 4, bottom: 10),
                  child: Text('รายการที่ตรวจนับ (${s.count} รายการ)',
                      style: appText(weight: FontWeight.w700, size: 16)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: isSerial ? _serialTable(rows) : _qtyTable(rows),
                ),
                if (s.lines.length > 5) ...[
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () => setState(() => _showAll = !_showAll),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(_showAll ? 'ย่อรายการ' : 'ดูเพิ่มเติม',
                              style: appText(
                                  color: kBlue, weight: FontWeight.w600)),
                          Icon(
                              _showAll
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              color: kBlue),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
