import 'package:application_thaweeyont/utility/my_constant.dart';
import 'package:application_thaweeyont/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

import 'stock_count_common.dart';
import 'stock_filter_panel.dart';
import 'stock_item_api.dart';
import 'stock_qty_page.dart';
import 'stock_scan_page.dart';

/// หน้าหลักของเมนู "ตรวจนับสต็อคสินค้า" (2 แท็บ ใช้ตัวกรองชุดเดียวกัน)
class StockSearchPage extends StatefulWidget {
  const StockSearchPage({super.key});

  @override
  State<StockSearchPage> createState() => _StockSearchPageState();
}

class _StockSearchPageState extends State<StockSearchPage> {
  int _tab = 0;
  final _filter = StockFilter();
  final _scroll = ScrollController();

  // ผลการค้นหา (แสดงต่อใต้ปุ่มค้นหา)
  List<StockItem> _results = [];
  bool _searched = false;
  int _filterVersion =
      0; // เพิ่มทุกครั้งที่ตัวกรองเปลี่ยน → ให้แท็บ 2 ล้างผลเดิม

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadBranches());
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  // โหลดรายการสาขาสำหรับ dropdown
  Future<void> _loadBranches() async {
    showProgressLoading(context);

    List<PickItem>? list;
    Object? error;
    try {
      list = await StockItemApi.branchList(context);
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
    setState(() => _filter.branchList = list ?? []);
  }

  // แท็บ 1: ค้นหาสินค้า (API inventorycount/itemList) แล้วไปแสดงผลอีกหน้า
  Future<void> _search() async {
    FocusScope.of(context).unfocus();
    showProgressLoading(context);

    List<StockItem>? items;
    Object? error;
    try {
      items = await StockItemApi.itemList(
        context,
        stockType: kStockTypeSerial,
        // ไม่เลือกคลัง = [] / เลือกแล้วส่ง id ของคลัง
        whId: [if (_filter.warehouse != null) _filter.warehouse!.id],
        // ช่องที่ไม่ได้เลือกส่งเป็น "" (สาขายังไม่มี field ใน API จึงไม่ส่ง)
        groupId: _filter.itemGroupId ?? '',
        itemTypeId: _filter.itemTypeId ?? '',
        brandId: _filter.itemBrandId ?? '',
        modelId: _filter.itemModelId ?? '',
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
    });
  }

  // แตะการ์ด → ไปหน้าที่ 2 พร้อมส่ง itemId (อยู่ใน StockItem) ไปด้วย
  void _openItem(StockItem it) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => StockScanPage(item: it)),
    );
  }

  Widget _infoLine(IconData icon, String text) => Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Row(
          children: [
            Icon(icon, size: 16, color: kNavy.withValues(alpha: 0.6)),
            const SizedBox(width: 6),
            Expanded(
              child: Text(text.isEmpty ? '-' : text,
                  style: appText(size: 13, color: Colors.grey.shade700)),
            ),
          ],
        ),
      );

  Widget _itemCard(StockItem it) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => _openItem(it),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: kBlue.withValues(alpha: 0.15)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: kPanel,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.inventory_2_outlined, color: kBlue),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${it.brandName} ${it.modelName}'.trim(),
                        style: appText(weight: FontWeight.w700, size: 15),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: kPanel,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                            it.itemTypeName.isEmpty ? '-' : it.itemTypeName,
                            style: appText(color: kBlue, size: 12)),
                      ),
                      const SizedBox(height: 4),
                      _infoLine(Icons.storefront_outlined, it.branchName),
                      _infoLine(Icons.warehouse_outlined, it.whName),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Icon(Icons.chevron_right, color: kBlue),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _resultSection() {
    // ยังไม่ได้ค้นหา → แสดงการ์ดข้อความแนะนำ
    if (!_searched) {
      return [
        Panel(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(Icons.info_outline, color: kBlue),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'กรุณาเลือกสินค้าและสแกนเลขเครื่อง\nเพื่อเริ่มตรวจนับสต็อก',
                  style: appText().copyWith(height: 1.5),
                ),
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
            child: Text('ผลการค้นหา',
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
    return Scaffold(
      appBar: const CustomAppbar(title: 'ตรวจนับสต็อคสินค้า'),
      floatingActionButton: BackToTopButton(controller: _scroll),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: ListView(
          controller: _scroll,
          padding: const EdgeInsets.all(16),
          children: [
            SegmentTabs(
                index: _tab, onChanged: (i) => setState(() => _tab = i)),
            const SizedBox(height: 16),
            StockFilterPanel(
              filter: _filter,
              // เปลี่ยนตัวกรองแล้วล้างผลเดิม กันเข้าใจผิดว่าตรงกับตัวกรองใหม่
              onChanged: () => setState(() {
                _results = [];
                _searched = false;
                _filterVersion++;
              }),
            ),
            const SizedBox(height: 14),
            if (_tab == 0) ...[
              PrimaryButton(
                label: 'ค้นหา',
                icon: Icons.search,
                onPressed: _search,
              ),
              const SizedBox(height: 16),
              ..._resultSection(),
            ] else
              QtyCountTab(filter: _filter, resetToken: _filterVersion),
          ],
        ),
      ),
    );
  }
}
