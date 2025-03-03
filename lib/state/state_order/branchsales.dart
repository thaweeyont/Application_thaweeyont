import 'dart:convert';
import 'dart:io';

import 'package:application_thaweeyont/state/authen.dart';
import 'package:application_thaweeyont/state/state_order/branchsaleslist.dart';
import 'package:flutter/material.dart';
import 'package:loading_gifs/loading_gifs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../api.dart';
import '../../utility/my_constant.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/endpage.dart';
import '../../widgets/loaddata.dart';

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
      dropdownFrom = [],
      myListJson = [],
      myBranchAreaJson = [];
  bool isLoadingBranch = false;
  String? selectAreaBranchlist,
      selectBranchlist,
      selectSaleTypelist,
      selectInterestlist,
      selectMonthlist,
      selectYearlist,
      selectSortBylist,
      selectFromlist;
  // var selectBranchlist;
  int? selectedtargetType;
  dynamic valueGrouplist,
      valueTypelist,
      valueBrandlist,
      valueModellist,
      valueStylelist,
      valueSizelist,
      valueItemlist,
      valueEmployeelist,
      valueSupplylist;

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
  List targetType = [];
  // Map<String, dynamic> dataTargetType = {};

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
    if (mounted) {
      showProgressLoading(context);
      getSelectBranch();
      getSelectBranchArea();
      getSelectTargetType();
    }
  }

  Future<void> getSelectBranchArea() async {
    try {
      var respose = await http.get(
        Uri.parse('${api}setup/branchAreaList'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> dataBranchArea =
            Map<String, dynamic>.from(json.decode(respose.body));
        setState(() {
          List df = [
            {'id': 99, 'name': "กรุณาเลือกเขตสาขา"}
          ];
          myBranchAreaJson = List.from(df)..addAll(dataBranchArea['data']);
          dropdownAreaBranch = dataBranchArea['data'];
        });
      } else if (respose.statusCode == 401) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.clear();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const Authen(),
          ),
          (Route<dynamic> route) => false,
        );
        showProgressDialog_401(
            context, 'แจ้งเตือน', 'กรุณา Login เข้าสู่ระบบใหม่');
      } else {
        print(respose.statusCode);
      }
    } catch (e) {
      print("ไม่มีข้อมูล $e");
      showProgressDialog(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
  }

  Future<void> getSelectBranch() async {
    try {
      var respose = await http.get(
        Uri.parse('${api}setup/branchList'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> dataBranch =
            Map<String, dynamic>.from(json.decode(respose.body));
        setState(() {
          List df = [
            {'id': "99", 'name': "เลือกสาขา"}
          ];
          myListJson = List.from(df)..addAll(dataBranch['data']);
          dropdownbranch = myListJson;
        });
        Navigator.pop(context);
        isLoadingBranch = true;
      } else if (respose.statusCode == 401) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.clear();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const Authen(),
          ),
          (Route<dynamic> route) => false,
        );
        showProgressDialog_401(
            context, 'แจ้งเตือน', 'กรุณา Login เข้าสู่ระบบใหม่');
      } else {
        print(respose.statusCode);
      }
    } catch (e) {
      print("ไม่มีข้อมูล $e");
      showProgressDialog(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
  }

  Future<void> getSelectTargetType() async {
    try {
      var respose = await http.get(
        Uri.parse('${api}setup/targetTypeList'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> dataTargetType =
            Map<String, dynamic>.from(json.decode(respose.body));
        setState(() {
          targetType = dataTargetType['data'];
          selectedtargetType = 1;
        });
      } else if (respose.statusCode == 401) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.clear();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const Authen(),
          ),
          (Route<dynamic> route) => false,
        );
        showProgressDialog_401(
            context, 'แจ้งเตือน', 'กรุณา Login เข้าสู่ระบบใหม่');
      } else {
        print(respose.statusCode);
      }
    } catch (e) {
      print("ไม่มีข้อมูล $e");
      showProgressDialog(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
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
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ItemGroupList(),
                                ),
                              ).then((result) {
                                if (result != null) {
                                  setState(() {
                                    itemGroup.text = result['name'];
                                    valueGrouplist = result['id'];
                                  });
                                }
                              });
                            },
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
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ItemTypeList(
                                    valueGrouplist: valueGrouplist,
                                  ),
                                ),
                              ).then((result) {
                                if (result != null) {
                                  setState(() {
                                    itemType.text = result['name'];
                                    valueTypelist = result['id'];
                                  });
                                }
                              });
                            },
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
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ItemBrandList(
                                    valueGrouplist: valueGrouplist,
                                    valueTypelist: valueTypelist,
                                  ),
                                ),
                              ).then((result) {
                                if (result != null) {
                                  setState(() {
                                    itemBrand.text = result['name'];
                                    valueBrandlist = result['id'];
                                  });
                                }
                              });
                            },
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
                            onPressed: () {
                              if (itemGroup.text.isEmpty &&
                                  itemType.text.isEmpty &&
                                  itemBrand.text.isEmpty) {
                                showProgressDialog(context, 'แจ้งเตือน',
                                    'กรุณาเลือกกลุ่มสินค้า ประเภทสินค้า ยี่ห้อสินค้า');
                              } else if (itemType.text.isEmpty &&
                                  itemBrand.text.isEmpty) {
                                showProgressDialog(context, 'แจ้งเตือน',
                                    'กรุณาเลือกประเภทสินค้าและยี่ห้อสินค้า');
                              } else if (itemBrand.text.isEmpty) {
                                showProgressDialog(context, 'แจ้งเตือน',
                                    'กรุณาเลือกยี่ห้อสินค้า');
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ItemModelList(
                                      valueGrouplist: valueGrouplist,
                                      valueTypelist: valueTypelist,
                                      valueBrandlist: valueBrandlist,
                                    ),
                                  ),
                                ).then((result) {
                                  if (result != null) {
                                    setState(() {
                                      itemModel.text = result['name'];
                                      valueModellist = result['id'];
                                    });
                                  }
                                });
                              }
                            },
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
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SupplyList(),
                                ),
                              ).then((result) {
                                if (result != null) {
                                  setState(() {
                                    supplyList.text = result['name'];
                                    valueSupplylist = result['id'];
                                  });
                                }
                              });
                            },
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
                            textAlign: TextAlign.right,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: targetType.map((item) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  child: Radio(
                                    value: item["id"],
                                    groupValue: selectedtargetType,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedtargetType = value;
                                      });
                                    },
                                    fillColor:
                                        WidgetStateProperty.resolveWith<Color>(
                                      (Set<WidgetState> states) {
                                        if (states
                                            .contains(WidgetState.selected)) {
                                          return Colors
                                              .black; // สีเมื่อถูกเลือก
                                        }
                                        return Colors.black; // สีปกติ
                                      },
                                    ),
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
            SizedBox(height: 20),
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

                        // Debug list ที่ได้
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
                        print('เขตสาขา : ${selectAreaBranchlist ?? ""}');
                        print(
                            'สาขา : ${selectBranchlist == "99" ? "" : selectBranchlist}');
                        print('กลุ่มสินค้า : ${valueGrouplist ?? ""}');
                        print('ประเภทสินค้า : ${valueTypelist ?? ""}');
                        print('ยี่ห้อสินค้า : ${valueBrandlist ?? ""}');
                        print('รุ่น : ${valueModellist ?? ""}');
                        print('แบบ : ${valueStylelist ?? ""}');
                        print('ขนาด : ${valueSizelist ?? ""}');
                        print('รหัสสินค้า : ${valueItemlist ?? ""}');
                        print('ประเภทการขาย : ${selectSaleTypelist ?? ""}');
                        print('ช่องทางขาย : "${selectedItems ?? ""}"');
                        print('ดอกเบี้ย : ${selectInterestlist ?? ""}');
                        print('พนักงานขาย : ${valueEmployeelist ?? ""}');
                        print('เดือน : ${selectMonthlist ?? ""}');
                        print('ปี พ.ศ. : ${selectYearlist ?? ""}');
                        print('ผู้จำหน่าย : ${valueSupplylist ?? ""}');
                        print('เรียงตาม : ${selectSortBylist ?? ""}');
                        print('จาก : ${selectFromlist ?? ""}');
                        print('เป้าหมาย : ${selectedtargetType ?? ""}');

                        // setState(() {
                        //   Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) => BranchSalesList(),
                        //     ),
                        //   );
                        // });
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

  final _border = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.transparent, width: 0),
    borderRadius: BorderRadius.all(Radius.circular(5.0)),
  );

  final _sizeIcon = BoxConstraints(minWidth: 40, minHeight: 40);

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
                        value: value['id'].toString(),
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
                  .map(
                    (value) => DropdownMenuItem<String>(
                      value: value['id'].toString(),
                      child: Text(
                        value['name'].toString(),
                        style: value['id'] == "99"
                            ? MyContant().TextInputSelect()
                            : MyContant().textInputStyle(),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (String? newvalue) {
                setState(() {
                  selectBranchlist = newvalue;
                });
                // if (selectBranchlist == "99") {
                //   dropdownbranch.clear();
                //   selectBranchlist = null;
                //   getSelectBranch();
                // }
              },
              value: selectBranchlist,
              isExpanded: true,
              underline: const SizedBox(),
              hint: Align(
                alignment: Alignment.center,
                child: Text(
                  'เลือกสาขา',
                  style: MyContant().TextInputSelect(),
                ),
              ),
              selectedItemBuilder: (BuildContext context) {
                return dropdownbranch.map<Widget>((value) {
                  return Align(
                    alignment: value['id'] == "99"
                        ? Alignment.center
                        : Alignment.centerLeft,
                    child: Text(
                      value['name'],
                      style: value['id'] == "99"
                          ? MyContant().TextInputSelect()
                          : MyContant().textInputStyle(),
                      textAlign: value['id'] == "99"
                          ? TextAlign.center
                          : TextAlign.left,
                    ),
                  );
                }).toList();
              },
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
          readOnly: true,
          controller: itemGroup,
          decoration: InputDecoration(
            suffixIcon: itemGroup.text.isEmpty
                ? null
                : GestureDetector(
                    onTap: () {
                      setState(() {
                        itemGroup.clear();
                        valueGrouplist = null;
                      });
                    },
                    child: const Icon(Icons.close),
                  ),
            contentPadding: const EdgeInsets.all(8),
            isDense: true,
            enabledBorder: _border,
            focusedBorder: _border,
            prefixIconConstraints: _sizeIcon,
            suffixIconConstraints: _sizeIcon,
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
          readOnly: true,
          controller: itemType,
          decoration: InputDecoration(
            suffixIcon: itemType.text.isEmpty
                ? null
                : GestureDetector(
                    onTap: () {
                      setState(() {
                        itemType.clear();
                        valueTypelist = null;
                      });
                    },
                    child: const Icon(Icons.close),
                  ),
            contentPadding: const EdgeInsets.all(8),
            isDense: true,
            enabledBorder: _border,
            focusedBorder: _border,
            prefixIconConstraints: _sizeIcon,
            suffixIconConstraints: _sizeIcon,
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
          readOnly: true,
          decoration: InputDecoration(
            suffixIcon: itemBrand.text.isEmpty
                ? null
                : GestureDetector(
                    onTap: () {
                      setState(() {
                        itemBrand.clear();
                        valueBrandlist = null;
                      });
                    },
                    child: const Icon(Icons.close),
                  ),
            contentPadding: const EdgeInsets.all(8),
            isDense: true,
            enabledBorder: _border,
            focusedBorder: _border,
            prefixIconConstraints: _sizeIcon,
            suffixIconConstraints: _sizeIcon,
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
          readOnly: true,
          decoration: InputDecoration(
            suffixIcon: itemModel.text.isEmpty
                ? null
                : GestureDetector(
                    onTap: () {
                      setState(() {
                        itemModel.clear();
                        valueModellist = null;
                      });
                    },
                    child: const Icon(Icons.close),
                  ),
            contentPadding: const EdgeInsets.all(8),
            isDense: true,
            enabledBorder: _border,
            focusedBorder: _border,
            prefixIconConstraints: _sizeIcon,
            suffixIconConstraints: _sizeIcon,
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
          readOnly: true,
          decoration: InputDecoration(
            suffixIcon: itemStyle.text.isEmpty
                ? null
                : GestureDetector(
                    onTap: () {
                      setState(() {
                        itemStyle.clear();
                        valueStylelist = null;
                      });
                    },
                    child: const Icon(Icons.close),
                  ),
            contentPadding: const EdgeInsets.all(8),
            isDense: true,
            enabledBorder: _border,
            focusedBorder: _border,
            prefixIconConstraints: _sizeIcon,
            suffixIconConstraints: _sizeIcon,
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
          readOnly: true,
          decoration: InputDecoration(
            suffixIcon: itemSize.text.isEmpty
                ? null
                : GestureDetector(
                    onTap: () {
                      setState(() {
                        itemSize.clear();
                        valueSizelist = null;
                      });
                    },
                    child: const Icon(Icons.close),
                  ),
            contentPadding: const EdgeInsets.all(8),
            isDense: true,
            enabledBorder: _border,
            focusedBorder: _border,
            prefixIconConstraints: _sizeIcon,
            suffixIconConstraints: _sizeIcon,
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
          readOnly: true,
          decoration: InputDecoration(
            suffixIcon: itemList.text.isEmpty
                ? null
                : IconButton(
                    onPressed: () {
                      setState(() {
                        itemList.clear();
                        valueItemlist = null;
                      });
                    },
                    icon: const Icon(Icons.close),
                  ),
            contentPadding: const EdgeInsets.all(8),
            isDense: true,
            enabledBorder: _border,
            focusedBorder: _border,
            prefixIconConstraints: _sizeIcon,
            suffixIconConstraints: _sizeIcon,
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
                    onPressed: () {
                      setState(() {
                        employeeList.clear();
                        valueEmployeelist = null;
                      });
                    },
                    icon: const Icon(Icons.close),
                  ),
            contentPadding: const EdgeInsets.all(8),
            isDense: true,
            enabledBorder: _border,
            focusedBorder: _border,
            prefixIconConstraints: _sizeIcon,
            suffixIconConstraints: _sizeIcon,
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
          readOnly: true,
          controller: supplyList,
          decoration: InputDecoration(
            suffixIcon: supplyList.text.isEmpty
                ? null
                : GestureDetector(
                    onTap: () {
                      setState(() {
                        supplyList.clear();
                        valueSupplylist = null;
                      });
                    },
                    child: const Icon(Icons.close),
                  ),
            contentPadding: const EdgeInsets.all(8),
            isDense: true,
            enabledBorder: _border,
            focusedBorder: _border,
            prefixIconConstraints: _sizeIcon,
            suffixIconConstraints: _sizeIcon,
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

class SupplyList extends StatefulWidget {
  const SupplyList({super.key});

  @override
  State<SupplyList> createState() => _SupplyListState();
}

class _SupplyListState extends State<SupplyList> {
  String userId = '', empId = '', firstName = '', lastName = '', tokenId = '';
  TextEditingController supplynamelist = TextEditingController();
  List<dynamic> dropdownsupplylist = [];
  bool statusLoading = false,
      statusLoad404 = false,
      isLoading = false,
      isLoadScroll = false,
      isLoadendPage = false;
  final scrollControll = TrackingScrollController();
  int offset = 50, stquery = 0;

  @override
  void initState() {
    super.initState();
    getdata();
    supplynamelist.addListener(() {
      setState(() {}); // อัปเดต UI ทุกครั้งที่ค่าของ TextField เปลี่ยน
    });
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
    if (mounted) {
      getSelectSupplyList(offset);
    }
    myScroll(scrollControll, offset);
  }

  void myScroll(ScrollController scrollController, int offset) {
    scrollController.addListener(() async {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        setState(() {
          isLoadScroll = true;
        });
        await Future.delayed(const Duration(seconds: 1), () {
          offset = offset + 20;
          getSelectSupplyList(offset);
        });
      }
    });
  }

  Future<void> getSelectSupplyList(offset) async {
    try {
      var respose = await http.get(
        Uri.parse(
            '${api}setup/supplyList?searchName=${supplynamelist.text}&page=1&limit=$offset'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> dataSupplylist =
            Map<String, dynamic>.from(json.decode(respose.body));
        setState(() {
          dropdownsupplylist = dataSupplylist['data'];
        });
        statusLoading = true;
        isLoadScroll = false;
        if (stquery > 0) {
          if (offset > dropdownsupplylist.length) {
            isLoadendPage = true;
          }
          stquery = 1;
        } else {
          stquery = 1;
        }
      } else if (respose.statusCode == 400) {
        showProgressDialog_400(
            context, 'แจ้งเตือน', 'ไม่พบข้อมูล (${respose.statusCode})');
      } else if (respose.statusCode == 401) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.clear();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const Authen(),
          ),
          (Route<dynamic> route) => false,
        );
        showProgressDialog_401(
            context, 'แจ้งเตือน', 'กรุณา Login เข้าสู่ระบบใหม่');
      } else if (respose.statusCode == 404) {
        setState(() {
          statusLoading = true;
          statusLoad404 = true;
        });
      } else if (respose.statusCode == 405) {
        showProgressDialog_405(
            context, 'แจ้งเตือน', 'ไม่พบข้อมูล (${respose.statusCode})');
      } else if (respose.statusCode == 500) {
        showProgressDialog_500(
            context, 'แจ้งเตือน', 'ข้อมูลผิดพลาด (${respose.statusCode})');
      } else {
        showProgressDialog(context, 'แจ้งเตือน', 'กรุณาติดต่อผู้ดูแลระบบ');
      }
    } catch (e) {
      showProgressDialog(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
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
      appBar: const CustomAppbar(title: 'ค้นหาผู้จำหน่าย'),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        behavior: HitTestBehavior.opaque,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withAlpha(130),
                      spreadRadius: 0.2,
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    )
                  ],
                  color: const Color.fromRGBO(239, 191, 239, 1),
                ),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'ผู้จำหน่าย : ',
                            style: MyContant().h4normalStyle(),
                          ),
                          inputSupplyNamelist(sizeIcon, border),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            groupBtnsearch(),
            Expanded(
              child: statusLoading == false
                  ? Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 24, 24, 24)
                              .withValues(alpha: 0.9),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 30),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(cupertinoActivityIndicator, scale: 4),
                            Text(
                              'กำลังโหลด',
                              style: MyContant().textLoading(),
                            ),
                          ],
                        ),
                      ),
                    )
                  : statusLoad404 == true
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(40.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'images/noresults.png',
                                      color: const Color.fromARGB(
                                          255, 158, 158, 158),
                                      width: 60,
                                      height: 60,
                                    )
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'ไม่พบรายการข้อมูล',
                                      style: MyContant().h5NotData(),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      : SingleChildScrollView(
                          controller: scrollControll,
                          physics: const BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics(),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 6),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withAlpha(130),
                                        spreadRadius: 0.2,
                                        blurRadius: 2,
                                        offset: const Offset(0, 1),
                                      )
                                    ],
                                    color:
                                        const Color.fromRGBO(239, 191, 239, 1),
                                  ),
                                  child: Column(
                                    children: [
                                      for (var i = 0;
                                          i < dropdownsupplylist.length;
                                          i++) ...[
                                        InkWell(
                                          onTap: () {
                                            Navigator.pop(context, {
                                              'id':
                                                  '${dropdownsupplylist[i]['id']}',
                                              'name':
                                                  '${dropdownsupplylist[i]['name']}',
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 3),
                                            child: Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: Colors.white
                                                    .withValues(alpha: 0.7),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      dropdownsupplylist[i]
                                                          ['name'],
                                                      style: MyContant()
                                                          .h4normalStyle(),
                                                      overflow:
                                                          TextOverflow.clip,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                              if (isLoadScroll == true &&
                                  isLoadendPage == false) ...[
                                const LoadData(),
                              ] else if (isLoadendPage == true) ...[
                                const EndPage(),
                              ],
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
            ),
          ],
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
                          getSelectSupplyList(offset);
                          statusLoading = false;
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
                        setState(() {
                          supplynamelist.clear();
                          getSelectSupplyList(offset);
                          statusLoading = false;
                          statusLoad404 = false;
                        });
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

  Expanded inputSupplyNamelist(BoxConstraints sizeIcon, InputBorder border) {
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
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: TextField(
          controller: supplynamelist,
          decoration: InputDecoration(
            suffixIcon: supplynamelist.text.isEmpty
                ? null
                : GestureDetector(
                    onTap: () {
                      setState(() {
                        supplynamelist.clear();
                        getSelectSupplyList(offset);
                        statusLoading = false;
                        statusLoad404 = false;
                      });
                    },
                    child: const Icon(Icons.close),
                  ),
            counterText: "",
            contentPadding: const EdgeInsets.all(8),
            isDense: true,
            enabledBorder: border,
            focusedBorder: border,
            prefixIconConstraints: sizeIcon,
            suffixIconConstraints: sizeIcon,
            filled: true,
            fillColor: Colors.white,
          ),
          style: MyContant().textInputStyle(),
        ),
      ),
    );
  }
}

class ItemGroupList extends StatefulWidget {
  const ItemGroupList({super.key});

  @override
  State<ItemGroupList> createState() => _ItemGroupListState();
}

class _ItemGroupListState extends State<ItemGroupList> {
  String userId = '', empId = '', firstName = '', lastName = '', tokenId = '';
  TextEditingController itemgrouplist = TextEditingController();
  List<dynamic> dropdowngrouplist = [];
  bool statusLoading = false,
      statusLoad404 = false,
      isLoading = false,
      isLoadScroll = false,
      isLoadendPage = false;
  final scrollControll = TrackingScrollController();
  int offset = 50, stquery = 0;

  @override
  void initState() {
    super.initState();
    getdata();
    itemgrouplist.addListener(() {
      setState(() {}); // อัปเดต UI ทุกครั้งที่ค่าของ TextField เปลี่ยน
    });
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
    if (mounted) {
      getSelectGroupList(offset);
    }
    myScroll(scrollControll, offset);
  }

  void myScroll(ScrollController scrollController, int offset) {
    scrollController.addListener(() async {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        setState(() {
          isLoadScroll = true;
        });
        await Future.delayed(const Duration(seconds: 1), () {
          offset = offset + 20;
          getSelectGroupList(offset);
        });
      }
    });
  }

  Future<void> getSelectGroupList(offset) async {
    try {
      var respose = await http.get(
        Uri.parse(
            '${api}setup/itemGroupList?searchName=${itemgrouplist.text}&page=1&limit=$offset'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> dataGrouplist =
            Map<String, dynamic>.from(json.decode(respose.body));
        setState(() {
          dropdowngrouplist = dataGrouplist['data'];
        });
        statusLoading = true;
        isLoadScroll = false;
        if (stquery > 0) {
          if (offset > dropdowngrouplist.length) {
            isLoadendPage = true;
          }
          stquery = 1;
        } else {
          stquery = 1;
        }
      } else if (respose.statusCode == 400) {
        showProgressDialog_400(
            context, 'แจ้งเตือน', 'ไม่พบข้อมูล (${respose.statusCode})');
      } else if (respose.statusCode == 401) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.clear();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const Authen(),
          ),
          (Route<dynamic> route) => false,
        );
        showProgressDialog_401(
            context, 'แจ้งเตือน', 'กรุณา Login เข้าสู่ระบบใหม่');
      } else if (respose.statusCode == 404) {
        setState(() {
          statusLoading = true;
          statusLoad404 = true;
        });
      } else if (respose.statusCode == 405) {
        showProgressDialog_405(
            context, 'แจ้งเตือน', 'ไม่พบข้อมูล (${respose.statusCode})');
      } else if (respose.statusCode == 500) {
        showProgressDialog_500(
            context, 'แจ้งเตือน', 'ข้อมูลผิดพลาด (${respose.statusCode})');
      } else {
        showProgressDialog(context, 'แจ้งเตือน', 'กรุณาติดต่อผู้ดูแลระบบ');
      }
    } catch (e) {
      showProgressDialog(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
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
      appBar: const CustomAppbar(title: 'ค้นหากลุ่มสินค้า'),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        behavior: HitTestBehavior.opaque,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withAlpha(130),
                      spreadRadius: 0.2,
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    )
                  ],
                  color: const Color.fromRGBO(239, 191, 239, 1),
                ),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'กลุ่มสินค้า : ',
                            style: MyContant().h4normalStyle(),
                          ),
                          inputGroupNamelist(sizeIcon, border),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            groupBtnsearch(),
            Expanded(
              child: statusLoading == false
                  ? Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 24, 24, 24)
                              .withValues(alpha: 0.9),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 30),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(cupertinoActivityIndicator, scale: 4),
                            Text(
                              'กำลังโหลด',
                              style: MyContant().textLoading(),
                            ),
                          ],
                        ),
                      ),
                    )
                  : statusLoad404 == true
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(40.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'images/noresults.png',
                                      color: const Color.fromARGB(
                                          255, 158, 158, 158),
                                      width: 60,
                                      height: 60,
                                    )
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'ไม่พบรายการข้อมูล',
                                      style: MyContant().h5NotData(),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      : SingleChildScrollView(
                          controller: scrollControll,
                          physics: const BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics(),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 6),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withAlpha(130),
                                        spreadRadius: 0.2,
                                        blurRadius: 2,
                                        offset: const Offset(0, 1),
                                      )
                                    ],
                                    color:
                                        const Color.fromRGBO(239, 191, 239, 1),
                                  ),
                                  child: Column(
                                    children: [
                                      for (var i = 0;
                                          i < dropdowngrouplist.length;
                                          i++) ...[
                                        InkWell(
                                          onTap: () {
                                            Navigator.pop(context, {
                                              'id':
                                                  '${dropdowngrouplist[i]['id']}',
                                              'name':
                                                  '${dropdowngrouplist[i]['name']}',
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 3),
                                            child: Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: Colors.white
                                                    .withValues(alpha: 0.7),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      dropdowngrouplist[i]
                                                          ['name'],
                                                      style: MyContant()
                                                          .h4normalStyle(),
                                                      overflow:
                                                          TextOverflow.clip,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                              if (isLoadScroll == true &&
                                  isLoadendPage == false) ...[
                                const LoadData(),
                              ] else if (isLoadendPage == true) ...[
                                const EndPage(),
                              ],
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
            ),
          ],
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
                          getSelectGroupList(offset);
                          statusLoading = false;
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
                        setState(() {
                          itemgrouplist.clear();
                          getSelectGroupList(offset);
                          statusLoading = false;
                          statusLoad404 = false;
                        });
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

  Expanded inputGroupNamelist(BoxConstraints sizeIcon, InputBorder border) {
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
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: TextField(
          controller: itemgrouplist,
          decoration: InputDecoration(
            suffixIcon: itemgrouplist.text.isEmpty
                ? null
                : GestureDetector(
                    onTap: () {
                      setState(() {
                        itemgrouplist.clear();
                        getSelectGroupList(offset);
                        statusLoading = false;
                        statusLoad404 = false;
                      });
                    },
                    child: const Icon(Icons.close),
                  ),
            counterText: "",
            contentPadding: const EdgeInsets.all(8),
            isDense: true,
            enabledBorder: border,
            focusedBorder: border,
            prefixIconConstraints: sizeIcon,
            suffixIconConstraints: sizeIcon,
            filled: true,
            fillColor: Colors.white,
          ),
          style: MyContant().textInputStyle(),
        ),
      ),
    );
  }
}

class ItemTypeList extends StatefulWidget {
  final String? valueGrouplist;
  const ItemTypeList({super.key, this.valueGrouplist});

  @override
  State<ItemTypeList> createState() => _ItemTypeListState();
}

class _ItemTypeListState extends State<ItemTypeList> {
  String userId = '', empId = '', firstName = '', lastName = '', tokenId = '';
  TextEditingController itemtypelist = TextEditingController();
  List<dynamic> dropdowntypelist = [];
  bool statusLoading = false,
      statusLoad404 = false,
      isLoading = false,
      isLoadScroll = false,
      isLoadendPage = false;
  final scrollControll = TrackingScrollController();
  int offset = 50, stquery = 0;
  String? valGroupList = '';

  @override
  void initState() {
    super.initState();
    getdata();
    itemtypelist.addListener(() {
      setState(() {}); // อัปเดต UI ทุกครั้งที่ค่าของ TextField เปลี่ยน
    });

    widget.valueGrouplist == null
        ? valGroupList = ''
        : valGroupList = widget.valueGrouplist;
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
    if (mounted) {
      getSelectTypeList(offset);
    }
    myScroll(scrollControll, offset);
  }

  void myScroll(ScrollController scrollController, int offset) {
    scrollController.addListener(() async {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        setState(() {
          isLoadScroll = true;
        });
        await Future.delayed(const Duration(seconds: 1), () {
          offset = offset + 20;
          getSelectTypeList(offset);
        });
      }
    });
  }

  Future<void> getSelectTypeList(offset) async {
    try {
      var respose = await http.get(
        Uri.parse(
            '${api}setup/itemTypeList?searchName=${itemtypelist.text}&page=1&limit=$offset&itemGroupId=$valGroupList&itemStatus=1'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> dataTypelist =
            Map<String, dynamic>.from(json.decode(respose.body));
        setState(() {
          dropdowntypelist = dataTypelist['data'];
        });
        statusLoading = true;
        isLoadScroll = false;
        if (stquery > 0) {
          if (offset > dropdowntypelist.length) {
            isLoadendPage = true;
          }
          stquery = 1;
        } else {
          stquery = 1;
        }
      } else if (respose.statusCode == 400) {
        showProgressDialog_400(
            context, 'แจ้งเตือน', 'ไม่พบข้อมูล (${respose.statusCode})');
      } else if (respose.statusCode == 401) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.clear();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const Authen(),
          ),
          (Route<dynamic> route) => false,
        );
        showProgressDialog_401(
            context, 'แจ้งเตือน', 'กรุณา Login เข้าสู่ระบบใหม่');
      } else if (respose.statusCode == 404) {
        setState(() {
          statusLoading = true;
          statusLoad404 = true;
        });
      } else if (respose.statusCode == 405) {
        showProgressDialog_405(
            context, 'แจ้งเตือน', 'ไม่พบข้อมูล (${respose.statusCode})');
      } else if (respose.statusCode == 500) {
        showProgressDialog_500(
            context, 'แจ้งเตือน', 'ข้อมูลผิดพลาด (${respose.statusCode})');
      } else {
        showProgressDialog(context, 'แจ้งเตือน', 'กรุณาติดต่อผู้ดูแลระบบ');
      }
    } catch (e) {
      showProgressDialog(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
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
      appBar: const CustomAppbar(title: 'ค้นหาประเภทสินค้า'),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        behavior: HitTestBehavior.opaque,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withAlpha(130),
                      spreadRadius: 0.2,
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    )
                  ],
                  color: const Color.fromRGBO(239, 191, 239, 1),
                ),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'ประเภทสินค้า : ',
                            style: MyContant().h4normalStyle(),
                          ),
                          inputTypeNamelist(sizeIcon, border),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            groupBtnsearch(),
            Expanded(
              child: statusLoading == false
                  ? Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 24, 24, 24)
                              .withValues(alpha: 0.9),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 30),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(cupertinoActivityIndicator, scale: 4),
                            Text(
                              'กำลังโหลด',
                              style: MyContant().textLoading(),
                            ),
                          ],
                        ),
                      ),
                    )
                  : statusLoad404 == true
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(40.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'images/noresults.png',
                                      color: const Color.fromARGB(
                                          255, 158, 158, 158),
                                      width: 60,
                                      height: 60,
                                    )
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'ไม่พบรายการข้อมูล',
                                      style: MyContant().h5NotData(),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      : SingleChildScrollView(
                          controller: scrollControll,
                          physics: const BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics(),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 6),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withAlpha(130),
                                        spreadRadius: 0.2,
                                        blurRadius: 2,
                                        offset: const Offset(0, 1),
                                      )
                                    ],
                                    color:
                                        const Color.fromRGBO(239, 191, 239, 1),
                                  ),
                                  child: Column(
                                    children: [
                                      for (var i = 0;
                                          i < dropdowntypelist.length;
                                          i++) ...[
                                        InkWell(
                                          onTap: () {
                                            Navigator.pop(context, {
                                              'id':
                                                  '${dropdowntypelist[i]['id']}',
                                              'name':
                                                  '${dropdowntypelist[i]['name']}',
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 3),
                                            child: Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: Colors.white
                                                    .withValues(alpha: 0.7),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      dropdowntypelist[i]
                                                          ['name'],
                                                      style: MyContant()
                                                          .h4normalStyle(),
                                                      overflow:
                                                          TextOverflow.clip,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                              if (isLoadScroll == true &&
                                  isLoadendPage == false) ...[
                                const LoadData(),
                              ] else if (isLoadendPage == true) ...[
                                const EndPage(),
                              ],
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
            ),
          ],
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
                          getSelectTypeList(offset);
                          statusLoading = false;
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
                        setState(() {
                          itemtypelist.clear();
                          getSelectTypeList(offset);
                          statusLoading = false;
                          statusLoad404 = false;
                        });
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

  Expanded inputTypeNamelist(BoxConstraints sizeIcon, InputBorder border) {
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
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: TextField(
          controller: itemtypelist,
          decoration: InputDecoration(
            suffixIcon: itemtypelist.text.isEmpty
                ? null
                : GestureDetector(
                    onTap: () {
                      setState(() {
                        itemtypelist.clear();
                        getSelectTypeList(offset);
                        statusLoading = false;
                        statusLoad404 = false;
                      });
                    },
                    child: const Icon(Icons.close),
                  ),
            counterText: "",
            contentPadding: const EdgeInsets.all(8),
            isDense: true,
            enabledBorder: border,
            focusedBorder: border,
            prefixIconConstraints: sizeIcon,
            suffixIconConstraints: sizeIcon,
            filled: true,
            fillColor: Colors.white,
          ),
          style: MyContant().textInputStyle(),
        ),
      ),
    );
  }
}

class ItemBrandList extends StatefulWidget {
  final String? valueGrouplist, valueTypelist;
  const ItemBrandList({super.key, this.valueGrouplist, this.valueTypelist});

  @override
  State<ItemBrandList> createState() => _ItemBrandListState();
}

class _ItemBrandListState extends State<ItemBrandList> {
  String userId = '', empId = '', firstName = '', lastName = '', tokenId = '';
  TextEditingController itembrandlist = TextEditingController();
  List<dynamic> dropdownbrandlist = [];
  bool statusLoading = false,
      statusLoad404 = false,
      isLoading = false,
      isLoadScroll = false,
      isLoadendPage = false;
  final scrollControll = TrackingScrollController();
  int offset = 50, stquery = 0;
  String? valGroupList = '', valTypeList = '';

  @override
  void initState() {
    super.initState();
    getdata();
    itembrandlist.addListener(() {
      setState(() {}); // อัปเดต UI ทุกครั้งที่ค่าของ TextField เปลี่ยน
    });
    widget.valueGrouplist == null
        ? valGroupList = ''
        : valGroupList = widget.valueGrouplist;
    widget.valueTypelist == null
        ? valTypeList = ''
        : valTypeList = widget.valueTypelist;
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
    if (mounted) {
      getSelectBrandList(offset);
    }
    myScroll(scrollControll, offset);
  }

  void myScroll(ScrollController scrollController, int offset) {
    scrollController.addListener(() async {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        setState(() {
          isLoadScroll = true;
        });
        await Future.delayed(const Duration(seconds: 1), () {
          offset = offset + 20;
          getSelectBrandList(offset);
        });
      }
    });
  }

  Future<void> getSelectBrandList(offset) async {
    try {
      var respose = await http.get(
        Uri.parse(
            '${api}setup/itemBrandList?searchName=${itembrandlist.text}&page=1&limit=$offset&itemGroupId=$valGroupList&itemTypeId=$valTypeList&itemStatus=1'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> dataBrandlist =
            Map<String, dynamic>.from(json.decode(respose.body));
        setState(() {
          dropdownbrandlist = dataBrandlist['data'];
        });
        statusLoading = true;
        isLoadScroll = false;
        if (stquery > 0) {
          if (offset > dropdownbrandlist.length) {
            isLoadendPage = true;
          }
          stquery = 1;
        } else {
          stquery = 1;
        }
      } else if (respose.statusCode == 400) {
        showProgressDialog_400(
            context, 'แจ้งเตือน', 'ไม่พบข้อมูล (${respose.statusCode})');
      } else if (respose.statusCode == 401) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.clear();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const Authen(),
          ),
          (Route<dynamic> route) => false,
        );
        showProgressDialog_401(
            context, 'แจ้งเตือน', 'กรุณา Login เข้าสู่ระบบใหม่');
      } else if (respose.statusCode == 404) {
        setState(() {
          statusLoading = true;
          statusLoad404 = true;
        });
      } else if (respose.statusCode == 405) {
        showProgressDialog_405(
            context, 'แจ้งเตือน', 'ไม่พบข้อมูล (${respose.statusCode})');
      } else if (respose.statusCode == 500) {
        showProgressDialog_500(
            context, 'แจ้งเตือน', 'ข้อมูลผิดพลาด (${respose.statusCode})');
      } else {
        showProgressDialog(context, 'แจ้งเตือน', 'กรุณาติดต่อผู้ดูแลระบบ');
      }
    } catch (e) {
      showProgressDialog(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
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
      appBar: const CustomAppbar(title: 'ค้นหาประเภทสินค้า'),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        behavior: HitTestBehavior.opaque,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withAlpha(130),
                      spreadRadius: 0.2,
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    )
                  ],
                  color: const Color.fromRGBO(239, 191, 239, 1),
                ),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'ยี่ห้อสินค้า : ',
                            style: MyContant().h4normalStyle(),
                          ),
                          inputBrandNamelist(sizeIcon, border),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            groupBtnsearch(),
            Expanded(
              child: statusLoading == false
                  ? Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 24, 24, 24)
                              .withValues(alpha: 0.9),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 30),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(cupertinoActivityIndicator, scale: 4),
                            Text(
                              'กำลังโหลด',
                              style: MyContant().textLoading(),
                            ),
                          ],
                        ),
                      ),
                    )
                  : statusLoad404 == true
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(40.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'images/noresults.png',
                                      color: const Color.fromARGB(
                                          255, 158, 158, 158),
                                      width: 60,
                                      height: 60,
                                    )
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'ไม่พบรายการข้อมูล',
                                      style: MyContant().h5NotData(),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      : SingleChildScrollView(
                          controller: scrollControll,
                          physics: const BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics(),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 6),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withAlpha(130),
                                        spreadRadius: 0.2,
                                        blurRadius: 2,
                                        offset: const Offset(0, 1),
                                      )
                                    ],
                                    color:
                                        const Color.fromRGBO(239, 191, 239, 1),
                                  ),
                                  child: Column(
                                    children: [
                                      for (var i = 0;
                                          i < dropdownbrandlist.length;
                                          i++) ...[
                                        InkWell(
                                          onTap: () {
                                            Navigator.pop(context, {
                                              'id':
                                                  '${dropdownbrandlist[i]['id']}',
                                              'name':
                                                  '${dropdownbrandlist[i]['name']}',
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 3),
                                            child: Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: Colors.white
                                                    .withValues(alpha: 0.7),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      dropdownbrandlist[i]
                                                          ['name'],
                                                      style: MyContant()
                                                          .h4normalStyle(),
                                                      overflow:
                                                          TextOverflow.clip,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                              if (isLoadScroll == true &&
                                  isLoadendPage == false) ...[
                                const LoadData(),
                              ] else if (isLoadendPage == true) ...[
                                const EndPage(),
                              ],
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
            ),
          ],
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
                          getSelectBrandList(offset);
                          statusLoading = false;
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
                        setState(() {
                          itembrandlist.clear();
                          getSelectBrandList(offset);
                          statusLoading = false;
                          statusLoad404 = false;
                        });
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

  Expanded inputBrandNamelist(BoxConstraints sizeIcon, InputBorder border) {
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
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: TextField(
          controller: itembrandlist,
          decoration: InputDecoration(
            suffixIcon: itembrandlist.text.isEmpty
                ? null
                : GestureDetector(
                    onTap: () {
                      setState(() {
                        itembrandlist.clear();
                        getSelectBrandList(offset);
                        statusLoading = false;
                        statusLoad404 = false;
                      });
                    },
                    child: const Icon(Icons.close),
                  ),
            counterText: "",
            contentPadding: const EdgeInsets.all(8),
            isDense: true,
            enabledBorder: border,
            focusedBorder: border,
            prefixIconConstraints: sizeIcon,
            suffixIconConstraints: sizeIcon,
            filled: true,
            fillColor: Colors.white,
          ),
          style: MyContant().textInputStyle(),
        ),
      ),
    );
  }
}

class ItemModelList extends StatefulWidget {
  final String? valueGrouplist, valueTypelist, valueBrandlist;
  const ItemModelList(
      {super.key,
      this.valueGrouplist,
      this.valueTypelist,
      this.valueBrandlist});

  @override
  State<ItemModelList> createState() => _ItemModelListState();
}

class _ItemModelListState extends State<ItemModelList> {
  String userId = '', empId = '', firstName = '', lastName = '', tokenId = '';
  TextEditingController itemmodellist = TextEditingController();
  List<dynamic> dropdownmodellist = [];
  bool statusLoading = false,
      statusLoad404 = false,
      isLoading = false,
      isLoadScroll = false,
      isLoadendPage = false;
  final scrollControll = TrackingScrollController();
  int offset = 50, stquery = 0;
  String? valGroupList = '', valTypeList = '', valBrandList = '';

  @override
  void initState() {
    super.initState();
    getdata();
    itemmodellist.addListener(() {
      setState(() {}); // อัปเดต UI ทุกครั้งที่ค่าของ TextField เปลี่ยน
    });
    widget.valueGrouplist == null
        ? valGroupList = ''
        : valGroupList = widget.valueGrouplist;
    widget.valueTypelist == null
        ? valTypeList = ''
        : valTypeList = widget.valueTypelist;
    widget.valueBrandlist == null
        ? valBrandList = ''
        : valBrandList = widget.valueBrandlist;
    print(widget.valueGrouplist);
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
    if (mounted) {
      getSelectModelList(offset);
    }
    myScroll(scrollControll, offset);
  }

  void myScroll(ScrollController scrollController, int offset) {
    scrollController.addListener(() async {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        setState(() {
          isLoadScroll = true;
        });
        await Future.delayed(const Duration(seconds: 1), () {
          offset = offset + 20;
          getSelectModelList(offset);
        });
      }
    });
  }

  Future<void> getSelectModelList(offset) async {
    try {
      var respose = await http.get(
        Uri.parse(
            '${api}setup/itemModelList?searchName=${itemmodellist.text}&page=1&limit=$offset&itemGroupId=$valGroupList&itemTypeId=$valTypeList&itemBrandId=$valBrandList&itemStatus=1'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> dataModellist =
            Map<String, dynamic>.from(json.decode(respose.body));
        setState(() {
          dropdownmodellist = dataModellist['data'];
        });
        statusLoading = true;
        isLoadScroll = false;
        if (stquery > 0) {
          if (offset > dropdownmodellist.length) {
            isLoadendPage = true;
          }
          stquery = 1;
        } else {
          stquery = 1;
        }
      } else if (respose.statusCode == 400) {
        showProgressDialog_400(
            context, 'แจ้งเตือน', 'ไม่พบข้อมูล (${respose.statusCode})');
      } else if (respose.statusCode == 401) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.clear();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const Authen(),
          ),
          (Route<dynamic> route) => false,
        );
        showProgressDialog_401(
            context, 'แจ้งเตือน', 'กรุณา Login เข้าสู่ระบบใหม่');
      } else if (respose.statusCode == 404) {
        setState(() {
          statusLoading = true;
          statusLoad404 = true;
        });
      } else if (respose.statusCode == 405) {
        showProgressDialog_405(
            context, 'แจ้งเตือน', 'ไม่พบข้อมูล (${respose.statusCode})');
      } else if (respose.statusCode == 500) {
        showProgressDialog_500(
            context, 'แจ้งเตือน', 'ข้อมูลผิดพลาด (${respose.statusCode})');
      } else {
        showProgressDialog(context, 'แจ้งเตือน', 'กรุณาติดต่อผู้ดูแลระบบ');
      }
    } catch (e) {
      showProgressDialog(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
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
      appBar: const CustomAppbar(title: 'ค้นหารุ่นสินค้า'),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        behavior: HitTestBehavior.opaque,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withAlpha(130),
                      spreadRadius: 0.2,
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    )
                  ],
                  color: const Color.fromRGBO(239, 191, 239, 1),
                ),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'รุ่นสินค้า : ',
                            style: MyContant().h4normalStyle(),
                          ),
                          inputModelNamelist(sizeIcon, border),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            groupBtnsearch(),
            Expanded(
              child: statusLoading == false
                  ? Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 24, 24, 24)
                              .withValues(alpha: 0.9),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 30),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(cupertinoActivityIndicator, scale: 4),
                            Text(
                              'กำลังโหลด',
                              style: MyContant().textLoading(),
                            ),
                          ],
                        ),
                      ),
                    )
                  : statusLoad404 == true
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(40.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'images/noresults.png',
                                      color: const Color.fromARGB(
                                          255, 158, 158, 158),
                                      width: 60,
                                      height: 60,
                                    )
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'ไม่พบรายการข้อมูล',
                                      style: MyContant().h5NotData(),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      : SingleChildScrollView(
                          controller: scrollControll,
                          physics: const BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics(),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 6),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withAlpha(130),
                                        spreadRadius: 0.2,
                                        blurRadius: 2,
                                        offset: const Offset(0, 1),
                                      )
                                    ],
                                    color:
                                        const Color.fromRGBO(239, 191, 239, 1),
                                  ),
                                  child: Column(
                                    children: [
                                      for (var i = 0;
                                          i < dropdownmodellist.length;
                                          i++) ...[
                                        InkWell(
                                          onTap: () {
                                            Navigator.pop(context, {
                                              'id':
                                                  '${dropdownmodellist[i]['id']}',
                                              'name':
                                                  '${dropdownmodellist[i]['name']}',
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 3),
                                            child: Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: Colors.white
                                                    .withValues(alpha: 0.7),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      dropdownmodellist[i]
                                                          ['name'],
                                                      style: MyContant()
                                                          .h4normalStyle(),
                                                      overflow:
                                                          TextOverflow.clip,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                              if (isLoadScroll == true &&
                                  isLoadendPage == false) ...[
                                const LoadData(),
                              ] else if (isLoadendPage == true) ...[
                                const EndPage(),
                              ],
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
            ),
          ],
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
                          getSelectModelList(offset);
                          statusLoading = false;
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
                        setState(() {
                          itemmodellist.clear();
                          getSelectModelList(offset);
                          statusLoading = false;
                          statusLoad404 = false;
                        });
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

  Expanded inputModelNamelist(BoxConstraints sizeIcon, InputBorder border) {
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
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: TextField(
          controller: itemmodellist,
          decoration: InputDecoration(
            suffixIcon: itemmodellist.text.isEmpty
                ? null
                : GestureDetector(
                    onTap: () {
                      setState(() {
                        itemmodellist.clear();
                        getSelectModelList(offset);
                        statusLoading = false;
                        statusLoad404 = false;
                      });
                    },
                    child: const Icon(Icons.close),
                  ),
            counterText: "",
            contentPadding: const EdgeInsets.all(8),
            isDense: true,
            enabledBorder: border,
            focusedBorder: border,
            prefixIconConstraints: sizeIcon,
            suffixIconConstraints: sizeIcon,
            filled: true,
            fillColor: Colors.white,
          ),
          style: MyContant().textInputStyle(),
        ),
      ),
    );
  }
}
