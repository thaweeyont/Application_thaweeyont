import 'package:application_thaweeyont/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

import 'stock_count_common.dart';

/// หน้าที่ 2: บันทึกการสแกนของสินค้าที่เลือกจากหน้าค้นหา
/// รับ [item] ทั้งก้อน → ใช้ item.itemId ส่งให้ API บันทึกการสแกน
class StockScanPage extends StatefulWidget {
  final StockItem item;
  const StockScanPage({super.key, required this.item});

  @override
  State<StockScanPage> createState() => _StockScanPageState();
}

class _StockScanPageState extends State<StockScanPage> {
  final _ctrl = TextEditingController();

  // จำนวนรายการที่สแกนในรอบนี้ (ยังไม่มีข้อมูล รอต่อ API)
  int _scannedCount = 0;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _save() {
    FocusScope.of(context).unfocus();
    // TODO: เรียก API บันทึกการสแกน โดยส่ง
    //   itemId: widget.item.itemId
    //   เลขเครื่องที่สแกน: _ctrl.text.trim()
    // แล้วอัปเดต _scannedCount
  }

  String _v(String s) => s.isEmpty ? '-' : s;

  @override
  Widget build(BuildContext context) {
    final it = widget.item;
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
              onScanTap: () {
                // TODO: เปิดกล้องสแกน
              },
            ),
            const SizedBox(height: 12),
            PrimaryButton(label: 'บันทึกการสแกน', onPressed: _save),
            const SizedBox(height: 16),
            // เก็บเฉพาะหัวรายการและจำนวน (ยังไม่แสดงรายการ)
            Panel(
              color: Colors.white,
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  const Icon(Icons.assignment_outlined, color: kNavy),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text('รายการที่สแกนในรอบนี้',
                        style: appText(weight: FontWeight.w700, size: 15)),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: kPanel,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text('จำนวน $_scannedCount รายการ',
                        style: appText(color: kBlue, size: 12.5)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
