import 'package:application_thaweeyont/utility/my_constant.dart';
import 'package:application_thaweeyont/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

// ───────────── Design tokens ─────────────
const kNavy = Color(0xFF0B2C63);
const kBlue = Color(0xFF1470E0);
const kPanel = Color(0xFFE3EFFC);
const kOkBg = Color(0xFFDDF3E2);
const kOkFg = Color(0xFF1E7B3A);
const kErrBg = Color(0xFFFBDADA);
const kErrFg = Color(0xFFD32F2F);

/// สไตล์ข้อความของแอป (h4normalStyle) ปรับสี/ขนาด/น้ำหนักได้
TextStyle appText({
  Color color = kNavy,
  FontWeight? weight,
  double? size,
}) {
  return MyContant().h4normalStyle().copyWith(
        color: color,
        fontWeight: weight,
        fontSize: size,
      );
}

// ───────────── Model ─────────────
class ScanItem {
  final String serial;
  final bool found;
  final DateTime time;
  const ScanItem(this.serial, this.found, this.time);
}

/// รายการที่ได้จากการค้นหา (คลัง/กลุ่ม/ประเภท/ยี่ห้อ/รุ่น)
class PickItem {
  final String id;
  final String name;

  /// data = ข้อมูลเพิ่มเติมที่ API ส่งกลับมา เช่น {'brand': .., 'model': .., 'qty': ..}
  final Map<String, dynamic> data;
  const PickItem(this.id, this.name, [this.data = const {}]);
}

/// ข้อผิดพลาดจาก API พร้อมข้อความที่จะแสดงให้ผู้ใช้
class ApiException implements Exception {
  final String message;
  const ApiException(this.message);
}

/// Token หมดอายุ (401): ตัวเรียก API พาไปหน้า Login ไปแล้ว หน้าค้นหาไม่ต้องทำอะไรต่อ
class SessionExpiredException implements Exception {}

/// ฟังก์ชันค้นหา: รับคำค้น → ยิง API → คืนรายการ
typedef PickSearch = Future<List<PickItem>> Function(String keyword);

String formatThaiDate(DateTime d) {
  String two(int n) => n.toString().padLeft(2, '0');
  final yy = (d.year + 543) % 100;
  return '${two(d.day)}/${two(d.month)}/${two(yy)} ${two(d.hour)}:${two(d.minute)}';
}

// ───────────── Shared widgets ─────────────
class SegmentTabs extends StatelessWidget {
  final int index;
  final ValueChanged<int> onChanged;
  const SegmentTabs({super.key, required this.index, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    Widget tab(int i, String text) {
      final selected = index == i;
      return Expanded(
        child: GestureDetector(
          onTap: () => onChanged(i),
          child: Container(
            height: 42,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: selected ? kBlue : kPanel.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: appText(
                color: selected ? Colors.white : kNavy,
                weight: FontWeight.w600,
                size: 14,
              ),
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        tab(0, 'สแกนเลขเครื่อง / บาร์โค้ด'),
        const SizedBox(width: 8),
        tab(1, 'นับจำนวนสินค้า(ไม่มีเลขเครื่อง)'),
      ],
    );
  }
}

class Panel extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color color;
  const Panel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(14),
    this.color = kPanel,
  });

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: padding,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: child,
      );
}

class PrimaryButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onPressed;
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: FilledButton.icon(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: kBlue,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        icon: icon == null ? const SizedBox.shrink() : Icon(icon),
        label: Text(label,
            style: appText(
                color: Colors.white, weight: FontWeight.w600, size: 16)),
      ),
    );
  }
}

class SerialField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final VoidCallback onScanTap;
  const SerialField({
    super.key,
    required this.controller,
    required this.hint,
    required this.onScanTap,
  });

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: kBlue.withValues(alpha: 0.25)),
    );
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            style: appText(),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: appText(color: kNavy.withValues(alpha: 0.4)),
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              border: border,
              enabledBorder: border,
            ),
          ),
        ),
        const SizedBox(width: 8),
        InkWell(
          onTap: onScanTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.qr_code_scanner, color: kBlue, size: 28),
          ),
        ),
      ],
    );
  }
}

// ───────────── ช่องเลือก + ปุ่มค้นหา (แตะแล้วเปิดหน้าค้นหา) ─────────────
class PickerField extends StatelessWidget {
  final String label;
  final String? valueText;
  final VoidCallback onTap;
  final VoidCallback onClear;
  const PickerField({
    super.key,
    required this.label,
    required this.valueText,
    required this.onTap,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final hasValue = valueText != null;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                height: 46,
                padding: const EdgeInsets.only(left: 12, right: 8),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        valueText ?? label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: hasValue
                            ? appText()
                            : appText(color: kNavy.withValues(alpha: 0.5)),
                      ),
                    ),
                    if (hasValue)
                      InkResponse(
                        onTap: onClear,
                        child: const Padding(
                          padding: EdgeInsets.all(4),
                          child: Icon(Icons.close, size: 18, color: kNavy),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Material(
            color: kBlue,
            shape: const CircleBorder(),
            child: IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: onTap,
            ),
          ),
        ],
      ),
    );
  }
}

// ───────────── หน้าค้นหา (เปิดมาโหลดรายการทันที → พิมพ์/กดค้นหาเพื่อกรอง → เลือก) ─────────────
/// เปิดด้วย Navigator.push<PickItem>() แล้วรับค่าที่เลือกกลับมา
class SearchPickerPage extends StatefulWidget {
  final String title;
  final String idHeader;
  final String nameHeader;
  final PickSearch onSearch;
  const SearchPickerPage({
    super.key,
    required this.title,
    required this.idHeader,
    required this.nameHeader,
    required this.onSearch,
  });

  @override
  State<SearchPickerPage> createState() => _SearchPickerPageState();
}

class _SearchPickerPageState extends State<SearchPickerPage> {
  final _ctrl = TextEditingController();
  List<PickItem> _items = [];
  bool _searched = false;

  @override
  void initState() {
    super.initState();
    // เปิดหน้ามาแล้วโหลดรายการทันที (ค้นหาด้วยคำค้นว่าง) ไม่ต้องกดค้นหาก่อน
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _doSearch();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _doSearch() async {
    FocusScope.of(context).unfocus();
    showProgressLoading(context);

    List<PickItem>? result;
    Object? error;
    try {
      result = await widget.onSearch(_ctrl.text.trim());
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
      _items = result ?? [];
      _searched = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: widget.title),
      // คีย์บอร์ดเปิดแล้วไม่ดันเลย์เอาต์ (ช่องค้นหาอยู่บนสุดอยู่แล้ว)
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.all(16),
          // ส่วนบน (ช่องค้นหา/ปุ่ม/หัวตาราง) อยู่กับที่ — เลื่อนเฉพาะรายการด้านล่าง
          child: Column(
            children: [
              Panel(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ชื่อที่ต้องการค้นหา :', style: appText()),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _ctrl,
                      style: appText(),
                      textInputAction: TextInputAction.search,
                      onSubmitted: (_) => _doSearch(),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    PrimaryButton(
                      label: 'ค้นหา',
                      icon: Icons.search,
                      onPressed: _doSearch,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('รายการที่ค้นหา',
                    style: appText(color: Colors.grey.shade700, size: 15)),
              ),
              const SizedBox(height: 8),
              Panel(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Row(
                  children: [
                    SizedBox(
                        width: 90,
                        child: Text(widget.idHeader,
                            style: appText(weight: FontWeight.w600))),
                    Expanded(
                      child: Text(widget.nameHeader,
                          style: appText(weight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
              // เลื่อนเฉพาะส่วนนี้
              Expanded(
                child: (_searched && _items.isEmpty)
                    ? Center(
                        child:
                            Text('ไม่พบข้อมูล', style: MyContant().h5NotData()))
                    : ListView.separated(
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        padding: EdgeInsets.zero,
                        itemCount: _items.length,
                        separatorBuilder: (_, __) => Divider(
                            height: 1, color: kBlue.withValues(alpha: 0.15)),
                        itemBuilder: (_, i) {
                          final it = _items[i];
                          return InkWell(
                            onTap: () => Navigator.pop(context, it),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 12),
                              child: Row(
                                children: [
                                  SizedBox(
                                      width: 90,
                                      child: Text(it.id,
                                          style: appText(color: Colors.black))),
                                  Expanded(
                                      child: Text(it.name,
                                          style: appText(color: Colors.black))),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
