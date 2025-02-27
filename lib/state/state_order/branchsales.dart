import 'dart:io';

import 'package:application_thaweeyont/state/state_order/branchsaleslist.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../utility/my_constant.dart';

class BranchSales extends StatefulWidget {
  const BranchSales({super.key});

  @override
  State<BranchSales> createState() => _BranchSalesState();
}

class _BranchSalesState extends State<BranchSales> {
  String userId = '', empId = '', firstName = '', lastName = '', tokenId = '';
  List dropdownAreaBranch = [],
      dropdownbranch = [],
      dropdownSaleType = [],
      dropdownInterest = [],
      dropdownMonth = [],
      dropdownYear = [],
      dropdownSortBy = [],
      dropdownFrom = [];
  bool isLoadingBranch = false;
  String? selectAreaBranchlist,
      selectBranchlist,
      selectSaleTypelist,
      selectInterestlist,
      selectMonthlist,
      selectYearlist,
      selectSortBylist,
      selectFromlist;
  int? selectedValue;

  TextEditingController itemGroup = TextEditingController();
  TextEditingController itemType = TextEditingController();
  TextEditingController itemBrand = TextEditingController();
  TextEditingController itemModel = TextEditingController();
  TextEditingController itemStyle = TextEditingController();
  TextEditingController itemSize = TextEditingController();
  TextEditingController itemList = TextEditingController();
  TextEditingController employeeList = TextEditingController();
  TextEditingController supplyList = TextEditingController();

  List<Map<String, dynamic>> data = [
    {"id": "01", "name": "ขายหน้าร้าน"},
    {"id": "02", "name": "ขาย Project"},
    {"id": "03", "name": "ขาย Event"},
    {"id": "04", "name": "ขายส่ง"},
    {"id": "06", "name": "Live สด"},
    {"id": "08", "name": "Website"},
    {"id": "09", "name": "Marketplace"},
    {"id": "10", "name": "Line"},
    {"id": "11", "name": "Facebook"},
    {"id": "12", "name": "ขายส่งบริษัทในเครือ"},
    {"id": "13", "name": "ขาย Expo"},
  ];

  List<Map<String, dynamic>> datatarget = [
    {"id": 1, "name": "เทียบเป้าหมาย"},
    {"id": 2, "name": "ไม่เทียบเป้าหมาย"},
  ];

  Map<String, bool> checkedItems = {}; // เก็บสถานะของ checkbox
  List<String> selectedItems = [];

  @override
  void initState() {
    super.initState();
    getdata();
    for (var item in data) {
      checkedItems[item["id"]] = false; // ค่าเริ่มต้นเป็น false
    }
  }

  Future<void> getdata() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      userId = preferences.getString('userId')!;
      empId = preferences.getString('empId')!;
      firstName = preferences.getString('firstName')!;
      lastName = preferences.getString('lastName')!;
      tokenId = preferences.getString('tokenId')!;
    });
    if (mounted) {}
  }

  @override
  Widget build(BuildContext context) {
    const sizeIcon = BoxConstraints(minWidth: 40, minHeight: 40);
    const border = OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.transparent,
        width: 0,
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(4.0),
      ),
    );
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        behavior: HitTestBehavior.opaque,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(5),
                  ),
                  color: const Color.fromRGBO(239, 191, 239, 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withAlpha(130),
                      spreadRadius: 0.2,
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.22,
                          child: Text(
                            'เขตสาขา : ',
                            style: MyContant().h4normalStyle(),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        selectAreaBranch(sizeIcon, border),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.22,
                          child: Text(
                            'สาขา : ',
                            style: MyContant().h4normalStyle(),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        selectBranch(sizeIcon, border),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.22,
                          child: Text(
                            'กลุ่มสินค้า : ',
                            style: MyContant().h4normalStyle(),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        inputItemGroup(),
                        const SizedBox(width: 3),
                        SizedBox(
                          width: 35,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              shape: const CircleBorder(),
                              backgroundColor:
                                  const Color.fromARGB(255, 223, 132, 223),
                            ),
                            onPressed: () {},
                            child: const Icon(
                              Icons.search,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 3)
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.22,
                          child: Text(
                            'ประเภทสินค้า : ',
                            style: MyContant().h4normalStyle(),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        inputItemType(),
                        const SizedBox(width: 3),
                        SizedBox(
                          width: 35,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              shape: const CircleBorder(),
                              backgroundColor:
                                  const Color.fromARGB(255, 223, 132, 223),
                            ),
                            onPressed: () {},
                            child: const Icon(
                              Icons.search,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 3)
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.22,
                          child: Text(
                            'ยี่ห้อสินค้า : ',
                            style: MyContant().h4normalStyle(),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        inputItemBrand(),
                        const SizedBox(width: 3),
                        SizedBox(
                          width: 35,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              shape: const CircleBorder(),
                              backgroundColor:
                                  const Color.fromARGB(255, 223, 132, 223),
                            ),
                            onPressed: () {},
                            child: const Icon(
                              Icons.search,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 3)
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.22,
                          child: Text(
                            'รุ่น : ',
                            style: MyContant().h4normalStyle(),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        inputItemModel(),
                        const SizedBox(width: 3),
                        SizedBox(
                          width: 35,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              shape: const CircleBorder(),
                              backgroundColor:
                                  const Color.fromARGB(255, 223, 132, 223),
                            ),
                            onPressed: () {},
                            child: const Icon(
                              Icons.search,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 3)
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.22,
                          child: Text(
                            'แบบ : ',
                            style: MyContant().h4normalStyle(),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        inputItemStyle(),
                        const SizedBox(width: 3),
                        SizedBox(
                          width: 35,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              shape: const CircleBorder(),
                              backgroundColor:
                                  const Color.fromARGB(255, 223, 132, 223),
                            ),
                            onPressed: () {},
                            child: const Icon(
                              Icons.search,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 3)
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.22,
                          child: Text(
                            'ขนาด : ',
                            style: MyContant().h4normalStyle(),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        inputItemSize(),
                        const SizedBox(width: 3),
                        SizedBox(
                          width: 35,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              shape: const CircleBorder(),
                              backgroundColor:
                                  const Color.fromARGB(255, 223, 132, 223),
                            ),
                            onPressed: () {},
                            child: const Icon(
                              Icons.search,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 3)
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.22,
                          child: Text(
                            'รหัสสินค้า : ',
                            style: MyContant().h4normalStyle(),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        inputItemList(),
                        const SizedBox(width: 3),
                        SizedBox(
                          width: 35,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              shape: const CircleBorder(),
                              backgroundColor:
                                  const Color.fromARGB(255, 223, 132, 223),
                            ),
                            onPressed: () {},
                            child: const Icon(
                              Icons.search,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 3)
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.22,
                          child: Text(
                            'ประเภทการขาย : ',
                            style: MyContant().h4normalStyle(),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        selectSaleType(sizeIcon, border),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.22,
                          child: Text(
                            'ช่องทางขาย : ',
                            style: MyContant().h4normalStyle(),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        salesChannels(),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.22,
                          child: Text(
                            'ดอกเบี้ย : ',
                            style: MyContant().h4normalStyle(),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        selectInterest(sizeIcon, border),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.22,
                          child: Text(
                            'พนักงานขาย : ',
                            style: MyContant().h4normalStyle(),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        inputEmployeeList(),
                        const SizedBox(width: 3),
                        SizedBox(
                          width: 35,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              shape: const CircleBorder(),
                              backgroundColor:
                                  const Color.fromARGB(255, 223, 132, 223),
                            ),
                            onPressed: () {},
                            child: const Icon(
                              Icons.search,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 3)
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.22,
                          child: Text(
                            'เดือน : ',
                            style: MyContant().h4normalStyle(),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        selectMonth(sizeIcon, border),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.22,
                          child: Text(
                            'ปี พ.ศ. : ',
                            style: MyContant().h4normalStyle(),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        selectYear(sizeIcon, border),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.22,
                          child: Text(
                            'ผู้จำหน่าย : ',
                            style: MyContant().h4normalStyle(),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        inputSupplyList(),
                        const SizedBox(width: 3),
                        SizedBox(
                          width: 35,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              shape: const CircleBorder(),
                              backgroundColor:
                                  const Color.fromARGB(255, 223, 132, 223),
                            ),
                            onPressed: () {},
                            child: const Icon(
                              Icons.search,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 3)
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.22,
                          child: Text(
                            'เรียงตาม : ',
                            style: MyContant().h4normalStyle(),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        selectSortBy(sizeIcon, border),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.22,
                          child: Text(
                            'จาก : ',
                            style: MyContant().h4normalStyle(),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        selectFrom(sizeIcon, border),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.22,
                          child: Text(
                            '',
                            style: MyContant().h4normalStyle(),
                            textAlign: TextAlign.right, // ชิดขวา
                          ),
                        ),
                        Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start, // จัดให้ชิดซ้ายเท่ากัน
                          children: datatarget.map((item) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment
                                  .center, // จัดให้อยู่ตรงกลางแนวตั้ง
                              children: [
                                SizedBox(
                                  // width: 40, // กำหนดขนาด Radio ให้เท่ากันทุกอัน
                                  child: Radio<int>(
                                    value: item["id"],
                                    groupValue: selectedValue,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedValue = value;
                                      });
                                      print(selectedValue);
                                    },
                                    visualDensity: VisualDensity
                                        .compact, // ลด padding รอบ Radio
                                    materialTapTargetSize: MaterialTapTargetSize
                                        .shrinkWrap, // ลดขนาด hitbox
                                  ),
                                ),
                                Text(
                                  item["name"],
                                  style: MyContant().h4normalStyle(),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            groupBtnsearch(),
          ],
        ),
      ),
    );
  }

  Expanded salesChannels() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(5),
          ),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: data.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 คอลัมน์
              childAspectRatio: 4.0, // ปรับให้ดูดี
            ),
            itemBuilder: (context, index) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Checkbox(
                    side: WidgetStateBorderSide.resolveWith(
                      (Set<WidgetState> states) {
                        if (states.contains(WidgetState.selected)) {
                          return const BorderSide(
                              color: Color.fromARGB(255, 0, 0, 0), width: 1.7);
                        }
                        return const BorderSide(
                            color: Color.fromARGB(255, 0, 0, 0), width: 1.7);
                      },
                    ),
                    value: checkedItems[data[index]["id"]],
                    checkColor: const Color.fromARGB(255, 0, 0, 0),
                    activeColor: const Color.fromARGB(255, 255, 255, 255),
                    onChanged: (bool? value) {
                      setState(() {
                        checkedItems[data[index]["id"]] = value!;

                        selectedItems = checkedItems.entries
                            .where((entry) => entry.value)
                            .map((entry) =>
                                entry.key.toString()) // บังคับให้เป็น String
                            .toList();

                        print(
                            "selectedItems: $selectedItems"); // Debug list ที่ได้
                      });
                    },
                    visualDensity: VisualDensity.compact, // ลดขนาด Checkbox
                    materialTapTargetSize:
                        MaterialTapTargetSize.shrinkWrap, // ลด Padding
                  ),
                  Expanded(
                    child: Text(
                      data[index]["name"],
                      style: MyContant().TextInputDate(),
                      overflow: TextOverflow.ellipsis, // ป้องกันข้อความยาวเกิน
                      maxLines: 1, // จำกัด 1 บรรทัด
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Padding groupBtnsearch() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.040,
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: ElevatedButton(
                      style: MyContant().myButtonSearchStyle(),
                      onPressed: () {
                        setState(() {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BranchSalesList(),
                            ),
                          );
                        });
                      },
                      child: const Text('ค้นหา'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.040,
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: ElevatedButton(
                      style: MyContant().myButtonCancelStyle(),
                      onPressed: () {
                        setState(() {});
                      },
                      child: const Text('ล้างข้อมูล'),
                    ),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  final _border = const OutlineInputBorder(
    borderSide: BorderSide.none,
    borderRadius: BorderRadius.all(Radius.circular(5.0)),
  );

  Expanded selectAreaBranch(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Container(
          height: 42,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: Padding(
            padding: const EdgeInsets.only(left: 4),
            child: DropdownButton<String>(
              items: dropdownAreaBranch
                  .map((value) => DropdownMenuItem<String>(
                        value: value['id'],
                        child: Text(
                          value['name'],
                          style: MyContant().textInputStyle(),
                        ),
                      ))
                  .toList(),
              onChanged: (String? newvalue) {
                setState(() {
                  selectAreaBranchlist = newvalue;
                });
              },
              value: selectAreaBranchlist,
              isExpanded: true,
              underline: const SizedBox(),
              hint: Align(
                child: Text(
                  'เลือกเขตสาขา',
                  style: MyContant().TextInputSelect(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Expanded selectBranch(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Container(
          height: 42,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: Padding(
            padding: const EdgeInsets.only(left: 4),
            child: DropdownButton<String>(
              items: dropdownbranch
                  .map((value) => DropdownMenuItem<String>(
                        value: value['id'],
                        child: Text(
                          value['name'],
                          style: MyContant().textInputStyle(),
                        ),
                      ))
                  .toList(),
              onChanged: (String? newvalue) {
                setState(() {
                  selectBranchlist = newvalue;
                });
              },
              value: selectBranchlist,
              isExpanded: true,
              underline: const SizedBox(),
              hint: Align(
                child: Text(
                  'เลือกสาขา',
                  style: MyContant().TextInputSelect(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Expanded inputItemGroup() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: TextField(
          controller: itemGroup,
          decoration: InputDecoration(
            suffixIcon: itemGroup.text.isEmpty
                ? null
                : IconButton(
                    onPressed: () => setState(() => itemGroup.clear()),
                    icon: const Icon(Icons.close),
                  ),
            contentPadding: const EdgeInsets.all(8),
            isDense: true,
            enabledBorder: _border,
            focusedBorder: _border,
            filled: true,
            fillColor: Colors.white,
          ),
          style: MyContant().textInputStyle(),
        ),
      ),
    );
  }

  Expanded inputItemType() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: TextField(
          controller: itemType,
          decoration: InputDecoration(
            suffixIcon: itemType.text.isEmpty
                ? null
                : IconButton(
                    onPressed: () => setState(() => itemType.clear()),
                    icon: const Icon(Icons.close),
                  ),
            contentPadding: const EdgeInsets.all(8),
            isDense: true,
            enabledBorder: _border,
            focusedBorder: _border,
            filled: true,
            fillColor: Colors.white,
          ),
          style: MyContant().textInputStyle(),
        ),
      ),
    );
  }

  Expanded inputItemBrand() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: TextField(
          controller: itemBrand,
          decoration: InputDecoration(
            suffixIcon: itemBrand.text.isEmpty
                ? null
                : IconButton(
                    onPressed: () => setState(() => itemBrand.clear()),
                    icon: const Icon(Icons.close),
                  ),
            contentPadding: const EdgeInsets.all(8),
            isDense: true,
            enabledBorder: _border,
            focusedBorder: _border,
            filled: true,
            fillColor: Colors.white,
          ),
          style: MyContant().textInputStyle(),
        ),
      ),
    );
  }

  Expanded inputItemModel() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: TextField(
          controller: itemModel,
          decoration: InputDecoration(
            suffixIcon: itemModel.text.isEmpty
                ? null
                : IconButton(
                    onPressed: () => setState(() => itemModel.clear()),
                    icon: const Icon(Icons.close),
                  ),
            contentPadding: const EdgeInsets.all(8),
            isDense: true,
            enabledBorder: _border,
            focusedBorder: _border,
            filled: true,
            fillColor: Colors.white,
          ),
          style: MyContant().textInputStyle(),
        ),
      ),
    );
  }

  Expanded inputItemStyle() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: TextField(
          controller: itemStyle,
          decoration: InputDecoration(
            suffixIcon: itemStyle.text.isEmpty
                ? null
                : IconButton(
                    onPressed: () => setState(() => itemStyle.clear()),
                    icon: const Icon(Icons.close),
                  ),
            contentPadding: const EdgeInsets.all(8),
            isDense: true,
            enabledBorder: _border,
            focusedBorder: _border,
            filled: true,
            fillColor: Colors.white,
          ),
          style: MyContant().textInputStyle(),
        ),
      ),
    );
  }

  Expanded inputItemSize() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: TextField(
          controller: itemSize,
          decoration: InputDecoration(
            suffixIcon: itemSize.text.isEmpty
                ? null
                : IconButton(
                    onPressed: () => setState(() => itemSize.clear()),
                    icon: const Icon(Icons.close),
                  ),
            contentPadding: const EdgeInsets.all(8),
            isDense: true,
            enabledBorder: _border,
            focusedBorder: _border,
            filled: true,
            fillColor: Colors.white,
          ),
          style: MyContant().textInputStyle(),
        ),
      ),
    );
  }

  Expanded inputItemList() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: TextField(
          controller: itemList,
          decoration: InputDecoration(
            suffixIcon: itemList.text.isEmpty
                ? null
                : IconButton(
                    onPressed: () => setState(() => itemList.clear()),
                    icon: const Icon(Icons.close),
                  ),
            contentPadding: const EdgeInsets.all(8),
            isDense: true,
            enabledBorder: _border,
            focusedBorder: _border,
            filled: true,
            fillColor: Colors.white,
          ),
          style: MyContant().textInputStyle(),
        ),
      ),
    );
  }

  Expanded selectSaleType(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Container(
          height: 42,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: Padding(
            padding: const EdgeInsets.only(left: 4),
            child: DropdownButton<String>(
              items: dropdownSaleType
                  .map((value) => DropdownMenuItem<String>(
                        value: value['id'],
                        child: Text(
                          value['name'],
                          style: MyContant().textInputStyle(),
                        ),
                      ))
                  .toList(),
              onChanged: (String? newvalue) {
                setState(() {
                  selectSaleTypelist = newvalue;
                });
              },
              value: selectSaleTypelist,
              isExpanded: true,
              underline: const SizedBox(),
              hint: Align(
                child: Text(
                  'เลือกประเภทการขาย',
                  style: MyContant().TextInputSelect(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Expanded selectInterest(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Container(
          height: 42,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: Padding(
            padding: const EdgeInsets.only(left: 4),
            child: DropdownButton<String>(
              items: dropdownInterest
                  .map((value) => DropdownMenuItem<String>(
                        value: value['id'],
                        child: Text(
                          value['name'],
                          style: MyContant().textInputStyle(),
                        ),
                      ))
                  .toList(),
              onChanged: (String? newvalue) {
                setState(() {
                  selectInterestlist = newvalue;
                });
              },
              value: selectInterestlist,
              isExpanded: true,
              underline: const SizedBox(),
              hint: Align(
                child: Text(
                  'เลือกดอกเบี้ย',
                  style: MyContant().TextInputSelect(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Expanded inputEmployeeList() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: TextField(
          controller: employeeList,
          decoration: InputDecoration(
            suffixIcon: employeeList.text.isEmpty
                ? null
                : IconButton(
                    onPressed: () => setState(() => employeeList.clear()),
                    icon: const Icon(Icons.close),
                  ),
            contentPadding: const EdgeInsets.all(8),
            isDense: true,
            enabledBorder: _border,
            focusedBorder: _border,
            filled: true,
            fillColor: Colors.white,
          ),
          style: MyContant().textInputStyle(),
        ),
      ),
    );
  }

  Expanded selectMonth(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Container(
          height: 42,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: Padding(
            padding: const EdgeInsets.only(left: 4),
            child: DropdownButton<String>(
              items: dropdownMonth
                  .map((value) => DropdownMenuItem<String>(
                        value: value['id'],
                        child: Text(
                          value['name'],
                          style: MyContant().textInputStyle(),
                        ),
                      ))
                  .toList(),
              onChanged: (String? newvalue) {
                setState(() {
                  selectMonthlist = newvalue;
                });
              },
              value: selectMonthlist,
              isExpanded: true,
              underline: const SizedBox(),
              hint: Align(
                child: Text(
                  'เลือกเดือน',
                  style: MyContant().TextInputSelect(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Expanded selectYear(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Container(
          height: 42,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: Padding(
            padding: const EdgeInsets.only(left: 4),
            child: DropdownButton<String>(
              items: dropdownYear
                  .map((value) => DropdownMenuItem<String>(
                        value: value['id'],
                        child: Text(
                          value['name'],
                          style: MyContant().textInputStyle(),
                        ),
                      ))
                  .toList(),
              onChanged: (String? newvalue) {
                setState(() {
                  selectYearlist = newvalue;
                });
              },
              value: selectYearlist,
              isExpanded: true,
              underline: const SizedBox(),
              hint: Align(
                child: Text(
                  'เลือกปี พ.ศ.',
                  style: MyContant().TextInputSelect(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Expanded inputSupplyList() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: TextField(
          controller: supplyList,
          decoration: InputDecoration(
            suffixIcon: supplyList.text.isEmpty
                ? null
                : IconButton(
                    onPressed: () => setState(() => supplyList.clear()),
                    icon: const Icon(Icons.close),
                  ),
            contentPadding: const EdgeInsets.all(8),
            isDense: true,
            enabledBorder: _border,
            focusedBorder: _border,
            filled: true,
            fillColor: Colors.white,
          ),
          style: MyContant().textInputStyle(),
        ),
      ),
    );
  }

  Expanded selectSortBy(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Container(
          height: 42,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: Padding(
            padding: const EdgeInsets.only(left: 4),
            child: DropdownButton<String>(
              items: dropdownSortBy
                  .map((value) => DropdownMenuItem<String>(
                        value: value['id'],
                        child: Text(
                          value['name'],
                          style: MyContant().textInputStyle(),
                        ),
                      ))
                  .toList(),
              onChanged: (String? newvalue) {
                setState(() {
                  selectSortBylist = newvalue;
                });
              },
              value: selectSortBylist,
              isExpanded: true,
              underline: const SizedBox(),
              hint: Align(
                child: Text(
                  'เลือก',
                  style: MyContant().TextInputSelect(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Expanded selectFrom(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Container(
          height: 42,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: Padding(
            padding: const EdgeInsets.only(left: 4),
            child: DropdownButton<String>(
              items: dropdownFrom
                  .map((value) => DropdownMenuItem<String>(
                        value: value['id'],
                        child: Text(
                          value['name'],
                          style: MyContant().textInputStyle(),
                        ),
                      ))
                  .toList(),
              onChanged: (String? newvalue) {
                setState(() {
                  selectFromlist = newvalue;
                });
              },
              value: selectFromlist,
              isExpanded: true,
              underline: const SizedBox(),
              hint: Align(
                child: Text(
                  'เลือก',
                  style: MyContant().TextInputSelect(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
