import 'package:application_thaweeyont/utility/my_constant.dart';
import 'package:application_thaweeyont/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'stock_count_common.dart';
import 'stock_filter_panel.dart';

// ═════════════ แท็บ 2: นับจำนวนสินค้า (ไม่มีเลขเครื่อง) ═════════════
/// เนื้อหาใต้กล่องตัวกรอง: เลือกสินค้า → ดูรายละเอียด → ไปหน้าบันทึกจำนวน
class QtyCountTab extends StatefulWidget {
  final StockFilter filter; // TODO: ส่ง id ของตัวกรองไปกับ API ค้นหาสินค้า
  const QtyCountTab({super.key, required this.filter});

  @override
  State<QtyCountTab> createState() => _QtyCountTabState();
}

class _QtyCountTabState extends State<QtyCountTab> {
  PickItem? _product;

  // TODO: ลบทิ้งแล้วเปลี่ยนเป็นเรียก API จริง (ส่ง kw + widget.filter เป็นพารามิเตอร์)
  Future<List<PickItem>> _searchProduct(String kw) async {
    await Future.delayed(const Duration(milliseconds: 400));
    const all = [
      PickItem('PRD-0001', 'พัดลมตั้งพื้น 16"',
          {'brand': 'SAMSUNG', 'model': 'F16', 'qty': 120}),
      PickItem('PRD-0002', 'พัดลมโคจร 18"',
          {'brand': 'SAMSUNG', 'model': 'F18', 'qty': 45}),
    ];
    final q = kw.toLowerCase();
    return q.isEmpty
        ? all
        : all
            .where((e) =>
                e.name.toLowerCase().contains(q) ||
                e.id.toLowerCase().contains(q))
            .toList();
  }

  Future<void> _pickProduct() async {
    FocusScope.of(context).unfocus();
    final picked = await Navigator.of(context).push<PickItem>(
      MaterialPageRoute(
        builder: (_) => SearchPickerPage(
          title: 'ค้นหาสินค้า',
          idHeader: 'รหัสสินค้า',
          nameHeader: 'ชื่อสินค้า',
          onSearch: _searchProduct,
        ),
      ),
    );
    if (picked != null && mounted) setState(() => _product = picked);
  }

  Future<void> _goRecord() async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => QtyRecordPage(product: _product!)),
    );
    if (saved == true && mounted) {
      setState(() => _product = null);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('บันทึกจำนวนเรียบร้อย')));
    }
  }

  Widget _kv(String k, String v) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 90, child: Text(k, style: appText(size: 14))),
            Text(': ', style: appText(size: 14)),
            Expanded(child: Text(v, style: appText(size: 14))),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final p = _product;
    return Column(
      children: [
        Panel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('เลือกสินค้า',
                  style: appText(weight: FontWeight.w700, size: 16)),
              const SizedBox(height: 10),
              PickerField(
                label: 'ค้นหาสินค้า หรือรหัสสินค้า',
                valueText: p == null ? null : '${p.id}  ${p.name}',
                onTap: _pickProduct,
                onClear: () => setState(() => _product = null),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        if (p == null)
          Panel(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: kBlue),
                const SizedBox(width: 12),
                Expanded(
                  child: Text('กรุณาเลือกสินค้าเพื่อบันทึกจำนวน',
                      style: appText()),
                ),
              ],
            ),
          )
        else ...[
          Panel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('รายละเอียดสินค้า',
                    style: appText(weight: FontWeight.w700, size: 16)),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      _kv('รหัสสินค้า', p.id),
                      _kv('ชื่อสินค้า', p.name),
                      _kv('ยี่ห้อ', '${p.data['brand'] ?? '-'}'),
                      _kv('รุ่น', '${p.data['model'] ?? '-'}'),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD3E6FA),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text('จำนวนในระบบ : ${p.data['qty'] ?? 0} ชิ้น',
                      style: appText(size: 14)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          PrimaryButton(label: 'บันทึกจำนวน', onPressed: _goRecord),
        ],
      ],
    );
  }
}

// ═════════════ หน้าบันทึกจำนวนสินค้า ═════════════
class QtyRecordPage extends StatefulWidget {
  final PickItem product;
  const QtyRecordPage({super.key, required this.product});

  @override
  State<QtyRecordPage> createState() => _QtyRecordPageState();
}

class _QtyRecordPageState extends State<QtyRecordPage> {
  final _qtyCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();

  @override
  void dispose() {
    _qtyCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  void _save() {
    FocusScope.of(context).unfocus();
    if (_qtyCtrl.text.trim().isEmpty) {
      showAppAlert(context, 'แจ้งเตือน', 'กรุณากรอกจำนวนที่ตรวจจริง');
      return;
    }
    // TODO: เรียก API บันทึก (รหัสสินค้า, จำนวนในระบบ, จำนวนที่ตรวจจริง, หมายเหตุ)
    //   productId: widget.product.id
    //   actualQty: int.parse(_qtyCtrl.text)
    //   note: _noteCtrl.text.trim()
    Navigator.pop(context, true);
  }

  OutlineInputBorder get _border => OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: kBlue.withValues(alpha: 0.25)),
      );

  Widget _kv(String k, String v, {bool bold = false}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 90, child: Text('$k :', style: appText())),
            Expanded(
              child: Text(v,
                  style: appText(
                      color: Colors.black,
                      weight: bold ? FontWeight.w700 : null)),
            ),
          ],
        ),
      );

  Widget _qtyRow(Widget label, Widget field) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Row(
          children: [
            Expanded(flex: 5, child: label),
            Expanded(flex: 4, child: field),
            const SizedBox(width: 8),
            SizedBox(width: 28, child: Text('ชิ้น', style: appText())),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    return Scaffold(
      appBar: const CustomAppbar(title: 'บันทึกจำนวนสินค้า'),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Panel(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  _kv('สินค้า', p.name, bold: true),
                  _kv('รหัสสินค้า', p.id),
                  _kv('ยี่ห้อ', '${p.data['brand'] ?? '-'}'),
                  _kv('รุ่น', '${p.data['model'] ?? '-'}'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _qtyRow(
              Text('จำนวนในระบบ',
                  style: appText(weight: FontWeight.w600, size: 16)),
              Container(
                height: 46,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: kPanel,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text('${p.data['qty'] ?? 0}', style: appText()),
              ),
            ),
            _qtyRow(
              Text.rich(TextSpan(
                text: 'จำนวนที่ตรวจจริง ',
                style: appText(weight: FontWeight.w600, size: 16),
                children: [
                  TextSpan(text: '*', style: appText(color: kErrFg, size: 16)),
                ],
              )),
              TextField(
                controller: _qtyCtrl,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: appText(),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  isDense: true,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  border: _border,
                  enabledBorder: _border,
                ),
              ),
            ),
            Text('หมายเหตุ (ถ้ามี)',
                style: appText(weight: FontWeight.w600, size: 16)),
            const SizedBox(height: 8),
            TextField(
              controller: _noteCtrl,
              maxLines: 4,
              style: appText(),
              decoration: InputDecoration(
                hintText: 'ระบุเพิ่มเติม (ถ้ามี)',
                hintStyle: appText(color: kNavy.withValues(alpha: 0.4)),
                filled: true,
                fillColor: Colors.white,
                border: _border,
                enabledBorder: _border,
              ),
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              label: 'บันทึก',
              icon: Icons.save_outlined,
              onPressed: _save,
            ),
          ],
        ),
      ),
    );
  }
}
