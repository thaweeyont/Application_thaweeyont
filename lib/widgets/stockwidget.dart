import 'package:application_thaweeyont/utility/my_constant.dart';
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
                size: 13,
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

// ───────────── ช่องเลือกแบบพิมพ์ค้นหาได้ ─────────────
/// ช่องกรอกที่พิมพ์เพื่อกรองรายการได้ (ไม่ต้องใช้แพ็กเกจเพิ่ม)
/// - แตะที่ช่อง = แสดงตัวเลือกทั้งหมด, พิมพ์ = กรองตามข้อความ (ไม่สนตัวพิมพ์เล็ก/ใหญ่)
/// - ต้องแตะเลือกจากรายการเท่านั้นจึงเปลี่ยนค่า ถ้าพิมพ์แล้วไม่เลือก จะคืนเป็นค่าเดิมตอนออกจากช่อง
class SearchableField extends StatefulWidget {
  final String? value;
  final List<String> options;
  final String hint;
  final ValueChanged<String?> onChanged;
  const SearchableField({
    super.key,
    required this.value,
    required this.options,
    required this.onChanged,
    this.hint = 'พิมพ์เพื่อค้นหา',
  });

  @override
  State<SearchableField> createState() => _SearchableFieldState();
}

class _SearchableFieldState extends State<SearchableField> {
  late final TextEditingController _ctrl =
      TextEditingController(text: widget.value ?? '');
  final FocusNode _focus = FocusNode();
  String? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.value;
    _focus.addListener(() {
      if (!_focus.hasFocus && _ctrl.text != (_selected ?? '')) {
        _ctrl.text = _selected ?? ''; // ออกจากช่องโดยไม่เลือก → คืนค่าเดิม
      }
    });
  }

  @override
  void didUpdateWidget(covariant SearchableField old) {
    super.didUpdateWidget(old);
    if (widget.value != _selected && !_focus.hasFocus) {
      _selected = widget.value;
      _ctrl.text = widget.value ?? '';
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _pick(String? v) {
    _selected = v;
    _ctrl.text = v ?? '';
    widget.onChanged(v);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, box) => RawAutocomplete<String>(
        textEditingController: _ctrl,
        focusNode: _focus,
        optionsBuilder: (TextEditingValue tv) {
          final q = tv.text.trim().toLowerCase();
          // ว่าง หรือแสดงค่าที่เลือกอยู่ → โชว์ทั้งหมด
          if (q.isEmpty || tv.text == (_selected ?? '')) return widget.options;
          return widget.options.where((o) => o.toLowerCase().contains(q));
        },
        onSelected: (s) {
          _pick(s);
          _focus.unfocus();
        },
        fieldViewBuilder: (context, ctrl, focus, onSubmit) => TextField(
          controller: ctrl,
          focusNode: focus,
          style: appText(),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: appText(color: kNavy.withValues(alpha: 0.4)),
            filled: true,
            fillColor: Colors.white,
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            suffixIcon: _selected != null
                ? IconButton(
                    icon: const Icon(Icons.close, size: 18, color: kNavy),
                    onPressed: () => _pick(null),
                  )
                : const Icon(Icons.search, size: 20, color: kNavy),
          ),
        ),
        optionsViewBuilder: (context, onSelected, options) => Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(10),
            child: ConstrainedBox(
              constraints:
                  BoxConstraints(maxHeight: 200, maxWidth: box.maxWidth),
              child: options.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(14),
                      child: Text('ไม่พบข้อมูล',
                          style: appText(color: Colors.grey)),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: options.length,
                      itemBuilder: (_, i) {
                        final o = options.elementAt(i);
                        return InkWell(
                          onTap: () => onSelected(o),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 12),
                            child: Text(o, style: appText()),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
