import 'package:application_thaweeyont/utility/my_constant.dart';
import 'package:application_thaweeyont/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'stock_count_common.dart';
import 'stock_filter_panel.dart';
import 'stock_item_api.dart';

// ═════════════ แท็บ 2: นับจำนวนสินค้า (ไม่มีเลขเครื่อง) ═════════════
/// เนื้อหาใต้กล่องตัวกรอง: ช่องค้นหาสินค้า (แบบเดิม) + ปุ่ม "ค้นหา" แสดงรายการสินค้าต่อด้านล่าง
/// แตะรายการเพื่อไปหน้าบันทึกจำนวน
class QtyCountTab extends StatefulWidget {
  final StockFilter filter;

  /// เปลี่ยนค่าเมื่อตัวกรองเปลี่ยน → ล้างผลการค้นหาเดิม
  final int resetToken;

  const QtyCountTab({super.key, required this.filter, this.resetToken = 0});

  @override
  State<QtyCountTab> createState() => _QtyCountTabState();
}

class _QtyCountTabState extends State<QtyCountTab> {
  PickItem? _product; // สินค้าที่เลือกจากช่องค้นหา (ปุ่มวงกลมแว่นขยาย)
  List<StockItem> _results = [];
  bool _searched = false;

  @override
  void didUpdateWidget(covariant QtyCountTab old) {
    super.didUpdateWidget(old);
    if (old.resetToken != widget.resetToken) {
      _results = [];
      _searched = false;
    }
  }

  // ปุ่ม "ค้นหา": ค้นหาสินค้าตามตัวกรอง (id) แล้วแสดงรายการต่อด้านล่าง
  Future<void> _search() async {
    FocusScope.of(context).unfocus();
    showProgressLoading(context);

    final f = widget.filter;
    List<StockItem>? items;
    Object? error;
    try {
      items = await StockItemApi.itemList(
        context,
        stockType:
            kStockTypeSerial, // ใช้ API/ค่าเดียวกับแท็บสแกน (ต่างกันแค่การแสดงผล)
        whId: [if (f.warehouse != null) f.warehouse!.id],
        groupId: f.itemGroupId ?? '',
        itemTypeId: f.itemTypeId ?? '',
        brandId: f.itemBrandId ?? '',
        modelId: f.itemModelId ?? '',
      );
    } catch (e) {
      error = e;
    }

    if (error is SessionExpiredException) return; // ไปหน้า Login แล้ว
    if (!mounted) return;
    Navigator.pop(context); // ปิด loading

    if (error != null) {
      final msg =
          error is ApiException ? error.message : 'กรุณาแจ้งผู้ดูแลระบบ';
      showAppAlert(context, 'แจ้งเตือน', msg, type: AlertType.error);
      return;
    }
    setState(() {
      _results = items ?? [];
      _searched = true;
      _product = null;
    });
  }

  // ───── ช่องค้นหาสินค้าแบบเดิม (ปุ่มวงกลมแว่นขยาย) ─────
  // TODO: ข้อมูลตัวอย่าง — รอทำการค้นหาแบบนี้ต่อ (เปลี่ยนเป็น API จริง)
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
    if (picked != null && mounted) {
      setState(() {
        _product = picked;
        _results = []; // แสดงอย่างใดอย่างหนึ่ง: สินค้าที่เลือก หรือ ผลการค้นหา
        _searched = false;
      });
    }
  }

  StockItem _toStockItem(PickItem p) => StockItem(
        branchId: '',
        whId: '',
        branchName: '',
        whName: '',
        itemId: p.id,
        itemTypeName: p.name,
        brandName: '${p.data['brand'] ?? ''}',
        modelName: '${p.data['model'] ?? ''}',
        qty: int.tryParse('${p.data['qty']}') ?? 0,
        serialType: 0,
      );

  List<Widget> _detailSection(PickItem p) {
    return [
      Panel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('รายละเอียดสินค้า',
                style: appText(weight: FontWeight.w700, size: 16)),
            const SizedBox(height: 6),
            _kv('รหัสสินค้า', p.id),
            _kv('ชื่อสินค้า', p.name),
            _kv('ยี่ห้อ', '${p.data['brand'] ?? ''}'),
            _kv('รุ่น', '${p.data['model'] ?? ''}'),
          ],
        ),
      ),
      const SizedBox(height: 12),
      PrimaryButton(
        label: 'บันทึกจำนวน',
        onPressed: () => _goRecord(_toStockItem(p)),
      ),
    ];
  }

  Future<void> _goRecord(StockItem it) async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => QtyRecordPage(item: it)),
    );
    if (saved == true && mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('บันทึกจำนวนเรียบร้อย')));
    }
  }

  Widget _kv(String k, String v) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 90, child: Text(k, style: appText(size: 14))),
            Text(': ', style: appText(size: 14)),
            Expanded(
              child: Text(v.isEmpty ? '-' : v,
                  style: appText(size: 14, color: Colors.black)),
            ),
          ],
        ),
      );

  // การ์ดรายการสินค้า (สาขา / คลัง / ชื่อสินค้า / ยี่ห้อ / รุ่น)
  Widget _itemCard(StockItem it) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: kPanel.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => _goRecord(it),
          child: Container(
            padding: const EdgeInsets.fromLTRB(14, 8, 8, 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: kBlue.withValues(alpha: 0.18)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      _kv('สาขา', it.branchName),
                      _kv('คลัง', it.whName),
                      _kv('ชื่อสินค้า', it.itemTypeName),
                      _kv('ยี่ห้อ', it.brandName),
                      _kv('รุ่น', it.modelName),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: kBlue),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _resultSection() {
    if (!_searched && _product != null) return _detailSection(_product!);
    if (!_searched) {
      return [
        Panel(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(Icons.info_outline, color: kBlue),
              const SizedBox(width: 12),
              Expanded(
                child:
                    Text('กรุณาเลือกสินค้าเพื่อบันทึกจำนวน', style: appText()),
              ),
            ],
          ),
        ),
      ];
    }
    if (_results.isEmpty) {
      return [
        Padding(
          padding: const EdgeInsets.only(top: 24),
          child: Center(
              child: Text('ไม่พบข้อมูลสินค้า', style: MyContant().h5NotData())),
        ),
      ];
    }
    return [
      Row(
        children: [
          const Icon(Icons.list_alt_rounded, color: kNavy, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text('รายการสินค้าที่ค้นหา',
                style: appText(weight: FontWeight.w700, size: 15)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: kPanel,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text('จำนวน ${_results.length} รายการ',
                style: appText(color: kBlue, size: 12.5)),
          ),
        ],
      ),
      const SizedBox(height: 10),
      for (final it in _results) _itemCard(it),
    ];
  }

  @override
  Widget build(BuildContext context) {
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
                valueText: _product == null
                    ? null
                    : '${_product!.id}  ${_product!.name}',
                onTap: _pickProduct,
                onClear: () => setState(() => _product = null),
              ),
              const SizedBox(height: 2),
              PrimaryButton(
                label: 'ค้นหา',
                icon: Icons.search,
                onPressed: _search,
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        ..._resultSection(),
      ],
    );
  }
}

// ═════════════ หน้าบันทึกจำนวนสินค้า ═════════════
class QtyRecordPage extends StatefulWidget {
  final StockItem item; // มี itemId สำหรับส่งบันทึกกับ API
  const QtyRecordPage({super.key, required this.item});

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
    // TODO: เรียก API บันทึก
    //   itemId: widget.item.itemId
    //   จำนวนในระบบ: widget.item.qty
    //   จำนวนที่ตรวจจริง: int.parse(_qtyCtrl.text)
    //   หมายเหตุ: _noteCtrl.text.trim()
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
              child: Text(v.isEmpty ? '-' : v,
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
    final p = widget.item;
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
                  _kv('สินค้า', p.itemTypeName, bold: true),
                  _kv('รหัสสินค้า', p.itemId),
                  _kv('ยี่ห้อ', p.brandName),
                  _kv('รุ่น', p.modelName),
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
                child: Text('${p.qty}', style: appText()),
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
