import 'package:application_thaweeyont/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

import 'stock_count_common.dart';

// ───────────── Page 2: บันทึกการสแกน ─────────────
class StockScanPage extends StatefulWidget {
  final String product;
  final String brand;
  final String model;
  final String initialSerial;
  const StockScanPage({
    super.key,
    required this.product,
    required this.brand,
    required this.model,
    this.initialSerial = '',
  });

  @override
  State<StockScanPage> createState() => _StockScanPageState();
}

class _StockScanPageState extends State<StockScanPage> {
  late final TextEditingController _ctrl =
      TextEditingController(text: widget.initialSerial);
  bool _showAll = false;

  // ข้อมูลตัวอย่าง — TODO: ดึงจาก API
  final List<ScanItem> _items = [
    ScanItem('T2207331962', true, DateTime(2025, 8, 23, 9, 12)),
    ScanItem('T2207331963', true, DateTime(2025, 8, 23, 9, 15)),
    ScanItem('T2207331964', false, DateTime(2025, 8, 23, 9, 18)),
    ScanItem('T2207331965', true, DateTime(2025, 8, 23, 9, 21)),
    ScanItem('T2207331966', true, DateTime(2025, 8, 23, 9, 25)),
  ];

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _save() {
    final serial = _ctrl.text.trim();
    if (serial.isEmpty) return;
    // TODO: เรียก API ตรวจว่าเลขเครื่องมีในระบบหรือไม่
    const knownSerials = <String>{};
    setState(() {
      _items.add(
          ScanItem(serial, knownSerials.contains(serial), DateTime.now()));
      _ctrl.clear();
    });
  }

  Widget _statusChip(bool found) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: found ? kOkBg : kErrBg,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          found ? 'พบในระบบ' : 'ไม่พบในระบบ',
          style: appText(
              color: found ? kOkFg : kErrFg,
              weight: FontWeight.w600,
              size: 12.5),
        ),
      );

  Widget _cell(Widget child) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: child,
      );

  @override
  Widget build(BuildContext context) {
    final visible = _showAll ? _items : _items.take(5).toList();

    return Scaffold(
      appBar: const CustomAppbar(title: 'ตรวจนับสต็อคสินค้า'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SegmentTabs(index: 0, onChanged: (_) {}),
          const SizedBox(height: 16),
          Panel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  SizedBox(width: 56, child: Text('สินค้า :', style: appText())),
                  Text(widget.product,
                      style: appText(weight: FontWeight.w700)),
                ]),
                const SizedBox(height: 8),
                Row(children: [
                  SizedBox(width: 56, child: Text('ยี่ห้อ :', style: appText())),
                  Text(widget.brand, style: appText()),
                  const SizedBox(width: 24),
                  Text('รุ่น : ${widget.model}', style: appText()),
                ]),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SerialField(
            controller: _ctrl,
            hint: 'สแกนเลขเครื่อง หรือกรอกเอง',
            onScanTap: () {
              // TODO: เปิดกล้องสแกน
            },
          ),
          const SizedBox(height: 12),
          PrimaryButton(label: 'บันทึกการสแกน', onPressed: _save),
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
                      child: Text('จำนวน ${_items.length} รายการ',
                          style: appText(color: kBlue, size: 12.5)),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Table(
                  columnWidths: const {
                    0: FixedColumnWidth(44),
                    1: FlexColumnWidth(3),
                    2: FlexColumnWidth(2.6),
                    3: FlexColumnWidth(2.6),
                  },
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    TableRow(
                      children: ['ลำดับ', 'เลขเครื่อง', 'สถานะ:', 'วันที่/เวลา']
                          .map((t) => _cell(Text(t, style: appText(size: 12.5))))
                          .toList(),
                    ),
                    for (var i = 0; i < visible.length; i++)
                      TableRow(
                        decoration: BoxDecoration(
                          border: Border(
                              top: BorderSide(
                                  color: kBlue.withValues(alpha: 0.12))),
                        ),
                        children: [
                          _cell(Text('${i + 1}', style: appText(size: 12.5))),
                          _cell(Text(visible[i].serial,
                              style: appText(size: 12.5))),
                          _cell(Align(
                            alignment: Alignment.centerLeft,
                            child: _statusChip(visible[i].found),
                          )),
                          _cell(Text(formatThaiDate(visible[i].time),
                              style: appText(size: 12.5))),
                        ],
                      ),
                  ],
                ),
                if (_items.length > 5) ...[
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () => setState(() => _showAll = !_showAll),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: kPanel,
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