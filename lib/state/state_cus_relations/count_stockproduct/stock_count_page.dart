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
  final _serialCtrl = TextEditingController();
  final _filter = StockFilter();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadBranches());
  }

  @override
  void dispose() {
    _serialCtrl.dispose();
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

  void _search() {
    FocusScope.of(context).unfocus();
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => StockScanPage(
        product:
            '${_filter.brand?.name ?? ''} ${_filter.model?.name ?? ''}'.trim(),
        brand: _filter.brand?.name ?? '-',
        model: _filter.model?.name ?? '-',
        initialSerial: _serialCtrl.text.trim(),
      ),
    ));
  }

  // แท็บ 1: สแกนเลขเครื่อง / บาร์โค้ด
  List<Widget> _serialTab() => [
        Panel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('เลขเครื่อง / บาร์โค้ด :',
                  style: appText(weight: FontWeight.w700, size: 16)),
              const SizedBox(height: 10),
              SerialField(
                controller: _serialCtrl,
                hint: 'กรอกเลขเครื่อง หรือสแกน',
                onScanTap: () {
                  // TODO: เปิดกล้องสแกน (mobile_scanner)
                },
              ),
              const SizedBox(height: 12),
              PrimaryButton(
                label: 'สแกน / ค้นหา',
                icon: Icons.document_scanner_outlined,
                onPressed: _search,
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Panel(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(Icons.info_outline, color: kBlue),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'กรุณาเลือกสินค้าและสแกนเลขเครื่อง\nเพื่อเริ่มตรวจนับสต๊อก',
                  style: appText().copyWith(height: 1.5),
                ),
              ),
            ],
          ),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: 'ตรวจนับสต็อคสินค้า'),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SegmentTabs(
                index: _tab, onChanged: (i) => setState(() => _tab = i)),
            const SizedBox(height: 16),
            StockFilterPanel(
              filter: _filter,
              onChanged: () => setState(() {}),
            ),
            const SizedBox(height: 14),
            if (_tab == 0) ..._serialTab() else QtyCountTab(filter: _filter),
          ],
        ),
      ),
    );
  }
}
