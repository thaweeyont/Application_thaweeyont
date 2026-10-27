import 'package:application_thaweeyont/utility/my_constant.dart';
import 'package:flutter/material.dart';

import 'stock_count_common.dart';
import 'stock_item_api.dart';

/// ค่าตัวกรองที่ใช้ร่วมกันทั้งสองแท็บ (เก็บไว้ที่หน้าแม่)
class StockFilter {
  List<PickItem> branchList = []; // รายการสาขา (โหลดจาก API ตอนเปิดหน้า)
  PickItem? branch; // สาขา = dropdown (ไม่มีค่าเริ่มต้น)
  PickItem? warehouse; // คลัง      ← ต้องเลือก สาขา ก่อน
  PickItem? group; // กลุ่ม
  PickItem? category; // ประเภท     ← ต้องเลือก กลุ่ม ก่อน
  PickItem? brand; // ยี่ห้อ     ← ต้องเลือก กลุ่ม + ประเภท ก่อน
  PickItem? model; // รุ่น       ← ต้องเลือก กลุ่ม + ประเภท + ยี่ห้อ ก่อน

  // id สำหรับส่งเป็นพารามิเตอร์ API (ชื่อตรงกับที่ใช้ในเมนูอื่น)
  String? get branchId => branch?.id;
  String? get itemGroupId => group?.id;
  String? get itemTypeId => category?.id;
  String? get itemBrandId => brand?.id;
  String? get itemModelId => model?.id;

  // คืนข้อความแจ้งเตือนถ้ายังเลือกไม่ได้ (null = เลือกได้)
  String? get warehouseBlock => branch == null ? 'กรุณาเลือกสาขาก่อน' : null;
  String? get categoryBlock => group == null ? 'กรุณาเลือกกลุ่มก่อน' : null;
  String? get brandBlock => group == null
      ? 'กรุณาเลือกกลุ่มก่อน'
      : category == null
          ? 'กรุณาเลือกประเภทก่อน'
          : null;
  String? get modelBlock => group == null
      ? 'กรุณาเลือกกลุ่มก่อน'
      : category == null
          ? 'กรุณาเลือกประเภทก่อน'
          : brand == null
              ? 'กรุณาเลือกยี่ห้อก่อน'
              : null;

  // เปลี่ยนหรือล้างค่าตัวแรก → ล้างตัวที่ขึ้นกับมันทั้งหมด (กันค่าตกค้างไม่ตรงกัน)
  void setBranch(PickItem? v) {
    branch = v;
    warehouse = null;
  }

  void setGroup(PickItem? v) {
    group = v;
    category = null;
    brand = null;
    model = null;
  }

  void setCategory(PickItem? v) {
    category = v;
    brand = null;
    model = null;
  }

  void setBrand(PickItem? v) {
    brand = v;
    model = null;
  }
}

/// กล่องตัวกรอง: สาขา (dropdown) + คลัง/กลุ่ม/ประเภท/ยี่ห้อ/รุ่น (แตะ → หน้าค้นหา)
class StockFilterPanel extends StatelessWidget {
  final StockFilter filter;
  final VoidCallback onChanged; // เรียกหลังค่าเปลี่ยน ให้หน้าแม่ setState

  const StockFilterPanel({
    super.key,
    required this.filter,
    required this.onChanged,
  });

  // สาขา: dropdown ที่โหลดรายการจาก API (กว้างเท่าแถวที่มีปุ่มค้นหา)
  Widget _branchRow() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<String>(
              key: ValueKey(
                  filter.branchList.length), // รีเฟรชเมื่อโหลดรายการเสร็จ
              initialValue: filter.branch?.id,
              isExpanded: true,
              style: appText(),
              hint: Text('สาขา',
                  style: appText(color: kNavy.withValues(alpha: 0.5))),
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
              items: filter.branchList
                  .map((e) => DropdownMenuItem(
                      value: e.id, child: Text(e.name, style: appText())))
                  .toList(),
              onChanged: (id) {
                final item =
                    filter.branchList.where((e) => e.id == id).firstOrNull;
                filter.setBranch(item);
                onChanged();
              },
            ),
          ),
          const SizedBox(width: 56), // เว้นให้เท่าแถวที่มีปุ่มค้นหา
        ],
      ),
    );
  }

  Widget _pickRow(
    BuildContext context,
    String label,
    String idHeader,
    String nameHeader,
    PickItem? value,
    ValueChanged<PickItem?> assign,
    PickSearch search, {
    String? blockedMessage, // มีค่า = ยังเลือกไม่ได้ → แตะแล้วขึ้นแจ้งเตือน
  }) {
    return PickerField(
      label: label,
      valueText: value?.name,
      onClear: () {
        assign(null);
        onChanged();
      },
      onTap: () async {
        FocusScope.of(context).unfocus();
        if (blockedMessage != null) {
          showAppAlert(context, 'แจ้งเตือน', blockedMessage);
          return;
        }
        final picked = await Navigator.of(context).push<PickItem>(
          MaterialPageRoute(
            builder: (_) => SearchPickerPage(
              title: 'ค้นหา$label',
              idHeader: idHeader,
              nameHeader: nameHeader,
              onSearch: search,
            ),
          ),
        );
        if (picked != null && context.mounted) {
          assign(picked);
          onChanged();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // สาขา/คลัง/กลุ่ม/ประเภท/ยี่ห้อ/รุ่น ต่อ API จริงแล้ว (stock_item_api.dart)
    return Panel(
      child: Column(
        children: [
          _branchRow(),
          _pickRow(
              context,
              'คลัง',
              'รหัส',
              'ชื่อคลังสินค้า',
              filter.warehouse,
              (v) => filter.warehouse = v,
              (kw) => StockItemApi.warehouseList(context, kw,
                  branchId: filter.branchId ?? ''),
              blockedMessage: filter.warehouseBlock),
          _pickRow(
              context,
              'กลุ่ม',
              'รหัส',
              'ชื่อกลุ่มสินค้า',
              filter.group,
              (v) => filter.setGroup(v),
              (kw) => StockItemApi.groupList(context, kw)),
          _pickRow(
              context,
              'ประเภท',
              'รหัส',
              'ชื่อประเภทสินค้า',
              filter.category,
              (v) => filter.setCategory(v),
              (kw) => StockItemApi.typeList(context, kw,
                  itemGroupId: filter.itemGroupId ?? ''),
              blockedMessage: filter.categoryBlock),
          _pickRow(
              context,
              'ยี่ห้อ',
              'รหัส',
              'ชื่อยี่ห้อ',
              filter.brand,
              (v) => filter.setBrand(v),
              (kw) => StockItemApi.brandList(context, kw,
                  itemGroupId: filter.itemGroupId ?? '',
                  itemTypeId: filter.itemTypeId ?? ''),
              blockedMessage: filter.brandBlock),
          _pickRow(
              context,
              'รุ่น',
              'รหัส',
              'ชื่อรุ่น',
              filter.model,
              (v) => filter.model = v,
              (kw) => StockItemApi.modelList(context, kw,
                  itemGroupId: filter.itemGroupId ?? '',
                  itemTypeId: filter.itemTypeId ?? '',
                  itemBrandId: filter.itemBrandId ?? ''),
              blockedMessage: filter.modelBlock),
        ],
      ),
    );
  }
}
