import 'dart:convert';

import 'package:application_thaweeyont/api.dart';
import 'package:application_thaweeyont/state/authen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../utility/my_constant.dart';

class ProductStockData extends StatefulWidget {
  const ProductStockData({Key? key}) : super(key: key);

  @override
  State<ProductStockData> createState() => _ProductStockDataState();
}

class _ProductStockDataState extends State<ProductStockData> {
  TextEditingController itemGroup = TextEditingController();
  TextEditingController itemType = TextEditingController();
  TextEditingController itemBrand = TextEditingController();
  TextEditingController itemModel = TextEditingController();
  TextEditingController itemStyle = TextEditingController();
  TextEditingController itemSize = TextEditingController();
  TextEditingController itemColor = TextEditingController();
  TextEditingController itemWareHouse = TextEditingController();
  TextEditingController itemFreeList = TextEditingController();
  TextEditingController nameProduct = TextEditingController();
  TextEditingController searchNameGroup = TextEditingController();
  TextEditingController searchNameType = TextEditingController();
  TextEditingController searchNameBrand = TextEditingController();
  TextEditingController searchNameModel = TextEditingController();
  TextEditingController searchNameStyle = TextEditingController();
  TextEditingController searchNameSize = TextEditingController();
  TextEditingController searchNameColor = TextEditingController();
  TextEditingController searchNameWareHouse = TextEditingController();
  TextEditingController searchNameItemFree = TextEditingController();

  String userId = '',
      empId = '',
      firstName = '',
      lastName = '',
      tokenId = '',
      branchId = '',
      branchName = '';
  bool? allowApproveStatus;
  List dropdownStockType = [],
      dropdownBranch = [],
      dropdownGroupFree = [],
      valueColl = [];
  bool isChecked = false;
  String? selectBranchList, selectGroupFreeList;
  var selectStockTypeList;
  var apiGroup, itemStatus;
  late Map<String, dynamic> dataItemGroup,
      dataItemType,
      dataItemBrand,
      dataItemModel,
      dataItemStyle,
      dataItemSize,
      dataItemColor,
      dataItemWareHouse;
  List itemGroupList = [],
      itemTypeList = [],
      itemBrandList = [],
      itemModelList = [],
      itemStyleList = [],
      itemSizeList = [],
      itemColorList = [],
      itemWarehouseList = [];

  @override
  void initState() {
    super.initState();
    getdata();
  }

  Future<void> getdata() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      userId = preferences.getString('userId')!;
      empId = preferences.getString('empId')!;
      firstName = preferences.getString('firstName')!;
      lastName = preferences.getString('lastName')!;
      tokenId = preferences.getString('tokenId')!;
      branchId = preferences.getString('branchId')!;
      branchName = preferences.getString('branchName')!;
      allowApproveStatus = preferences.getBool('allowApproveStatus');
    });
    await Future.delayed(const Duration(milliseconds: 100));
    if (mounted) {
      getSelectStockType();
      getSelectBranch();
      getSelectGroupFree();
    }
  }

  Future<void> getSelectStockType() async {
    try {
      var respose = await http.get(
        Uri.parse('${api}setup/stockTypeList'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> dataStockType =
            Map<String, dynamic>.from(json.decode(respose.body));
        setState(() {
          dropdownStockType = dataStockType['data'];
          selectStockTypeList = dropdownStockType[0]['id'];
        });
      } else if (respose.statusCode == 401) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.clear();
        if (mounted) return;
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
          dropdownBranch = dataBranch['data'];
        });
      } else if (respose.statusCode == 401) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.clear();
        if (mounted) return;
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

  Future<void> getSelectGroupFree() async {
    try {
      var respose = await http.get(
        Uri.parse('${api}setup/groupFree?page=1&limit=100'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> dataGroupFree =
            Map<String, dynamic>.from(json.decode(respose.body));
        setState(() {
          dropdownGroupFree = dataGroupFree['data'];
        });
      } else if (respose.statusCode == 401) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.clear();
        if (mounted) return;
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
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(5),
                  ),
                  color: const Color.fromRGBO(176, 218, 255, 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
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
                        selectStcokType(sizeIcon, border),
                        Checkbox(
                          side: MaterialStateBorderSide.resolveWith(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.selected)) {
                                return const BorderSide(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    width: 1.7);
                              }
                              return const BorderSide(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  width: 1.7);
                            },
                          ),
                          value: isChecked,
                          checkColor: const Color.fromARGB(255, 0, 0, 0),
                          activeColor: const Color.fromARGB(255, 255, 255, 255),
                          onChanged: (bool? value) {
                            setState(() {
                              isChecked = value!;
                            });
                            print(isChecked);
                          },
                        ),
                        Text(
                          'โปรโมชั่น (PR)',
                          style: MyContant().h4normalStyle(),
                        ),
                        const SizedBox(width: 8)
                      ],
                    ),
                    if (selectStockTypeList == 1 ||
                        selectStockTypeList == 2) ...[
                      Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.17,
                            child: Text(
                              'กลุ่ม : ',
                              style: MyContant().h4normalStyle(),
                              textAlign: TextAlign.right,
                            ),
                          ),
                          InputProductStock(textEditingController: itemGroup),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              backgroundColor:
                                  const Color.fromARGB(255, 56, 162, 255),
                            ),
                            onPressed: () {
                              print('selectStock>$selectStockTypeList');
                              checkDataStock('group');
                            },
                            child: const Icon(
                              Icons.search,
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.17,
                            child: Text(
                              'ประเภท : ',
                              style: MyContant().h4normalStyle(),
                              textAlign: TextAlign.right,
                            ),
                          ),
                          InputProductStock(textEditingController: itemType),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              backgroundColor:
                                  const Color.fromARGB(255, 56, 162, 255),
                            ),
                            onPressed: () {
                              // searchSetup(searchNameType);
                              checkDataStock('type');
                            },
                            child: const Icon(
                              Icons.search,
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.17,
                            child: Text(
                              'ยี่ห้อ : ',
                              style: MyContant().h4normalStyle(),
                              textAlign: TextAlign.right,
                            ),
                          ),
                          InputProductStock(textEditingController: itemBrand),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              backgroundColor:
                                  const Color.fromARGB(255, 56, 162, 255),
                            ),
                            onPressed: () {
                              // searchSetup(searchNameBrand);
                              checkDataStock('brand');
                            },
                            child: const Icon(
                              Icons.search,
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.17,
                            child: Text(
                              'รุ่น : ',
                              style: MyContant().h4normalStyle(),
                              textAlign: TextAlign.right,
                            ),
                          ),
                          InputProductStock(textEditingController: itemModel),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              backgroundColor:
                                  const Color.fromARGB(255, 56, 162, 255),
                            ),
                            onPressed: () {
                              // searchSetup(searchNameModel);
                              checkDataStock('model');
                            },
                            child: const Icon(
                              Icons.search,
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.17,
                            child: Text(
                              'แบบ : ',
                              style: MyContant().h4normalStyle(),
                              textAlign: TextAlign.right,
                            ),
                          ),
                          InputProductStock(textEditingController: itemStyle),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              backgroundColor:
                                  const Color.fromARGB(255, 56, 162, 255),
                            ),
                            onPressed: () {
                              // searchSetup(searchNameStyle);
                              checkDataStock('style');
                            },
                            child: const Icon(
                              Icons.search,
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.17,
                            child: Text(
                              'ขนาด : ',
                              style: MyContant().h4normalStyle(),
                              textAlign: TextAlign.right,
                            ),
                          ),
                          InputProductStock(textEditingController: itemSize),
                          SizedBox(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: const CircleBorder(),
                                backgroundColor:
                                    const Color.fromARGB(255, 56, 162, 255),
                              ),
                              onPressed: () {
                                // searchSetup(itemSize);
                                checkDataStock('size');
                              },
                              child: const Icon(
                                Icons.search,
                              ),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.17,
                            child: Text(
                              'สี : ',
                              style: MyContant().h4normalStyle(),
                              textAlign: TextAlign.right,
                            ),
                          ),
                          InputProductStock(textEditingController: itemColor),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              backgroundColor:
                                  const Color.fromARGB(255, 56, 162, 255),
                            ),
                            onPressed: () {
                              // searchSetup(itemColor);
                              checkDataStock('color');
                            },
                            child: const Icon(
                              Icons.search,
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.17,
                            child: Text(
                              'สาขา : ',
                              style: MyContant().h4normalStyle(),
                              textAlign: TextAlign.right,
                            ),
                          ),
                          selectBranch(sizeIcon, border),
                          const Padding(
                            padding: EdgeInsets.all(13.0),
                            child: SizedBox(width: 30),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.17,
                            child: Text(
                              'คลัง : ',
                              style: MyContant().h4normalStyle(),
                              textAlign: TextAlign.right,
                            ),
                          ),
                          InputProductStock(
                              textEditingController: itemWareHouse),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              backgroundColor:
                                  const Color.fromARGB(255, 56, 162, 255),
                            ),
                            onPressed: () {
                              // searchSetup(itemWareHouse);
                              checkDataStock('warehouse');
                            },
                            child: const Icon(
                              Icons.search,
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.17,
                            child: Text(
                              'ชื่อสินค้า : ',
                              style: MyContant().h4normalStyle(),
                              textAlign: TextAlign.right,
                            ),
                          ),
                          InputProductStock(textEditingController: nameProduct),
                          const Padding(
                            padding: EdgeInsets.all(17.0),
                            child: SizedBox(width: 30),
                          )
                        ],
                      ),
                    ] else if (selectStockTypeList == 3 ||
                        selectStockTypeList == 4) ...[
                      Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.17,
                            child: Text(
                              'สาขา : ',
                              style: MyContant().h4normalStyle(),
                              textAlign: TextAlign.right,
                            ),
                          ),
                          selectBranch(sizeIcon, border),
                          const Padding(
                            padding: EdgeInsets.all(13.0),
                            child: SizedBox(width: 30),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.17,
                            child: Text(
                              'คลัง : ',
                              style: MyContant().h4normalStyle(),
                              textAlign: TextAlign.right,
                            ),
                          ),
                          InputProductStock(
                              textEditingController: itemWareHouse),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              backgroundColor:
                                  const Color.fromARGB(255, 56, 162, 255),
                            ),
                            onPressed: () {
                              print('selectStock>$selectStockTypeList');
                              // searchSetup(itemWareHouse);
                              checkDataStock('warehouse');
                            },
                            child: const Icon(
                              Icons.search,
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.17,
                            child: Text(
                              'ชื่อสินค้า : ',
                              style: MyContant().h4normalStyle(),
                              textAlign: TextAlign.right,
                            ),
                          ),
                          InputProductStock(textEditingController: nameProduct),
                          const Padding(
                            padding: EdgeInsets.all(17.0),
                            child: SizedBox(width: 30),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'หมวดของแถม : ',
                            style: MyContant().h4normalStyle(),
                            textAlign: TextAlign.left,
                          ),
                          selectGroupFree(sizeIcon, border),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.18,
                            child: Text(
                              'ของแถม :',
                              style: MyContant().h4normalStyle(),
                              textAlign: TextAlign.right,
                            ),
                          ),
                          InputProductStock(
                              textEditingController: itemFreeList),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              backgroundColor:
                                  const Color.fromARGB(255, 56, 162, 255),
                            ),
                            onPressed: () {
                              print('selectStock>$selectStockTypeList');
                              // searchSetup(searchNameItemFree);
                              checkDataStock('itemfree');
                            },
                            child: const Icon(
                              Icons.search,
                            ),
                          )
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            groupBtnSearch(),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Future<void> checkDataStock(id) async {
    print(id);
    if (selectStockTypeList == 1 || selectStockTypeList == 3) {
      itemStatus = 1;
    } else if (selectStockTypeList == 2 || selectStockTypeList == 4) {
      itemStatus = 2;
    }
    switch (id) {
      case 'group':
        apiGroup =
            "setup/itemGroupList?searchName=${searchNameGroup.text}&page=1&limit=30";
        getDataItem(apiGroup);
        break;
      case 'type':
        apiGroup =
            "setup/itemTypeList?searchName=${searchNameType.text}&page=1&limit=10&itemGroupId=01&itemStatus=$itemStatus";
        break;
      case 'brand':
        apiGroup =
            "setup/itemBrandList?searchName=${searchNameBrand.text}&page=1&limit=10&itemGroupId=01&itemTypeId=154&itemStatus=$itemStatus";
        break;
      case 'model':
        apiGroup =
            "setup/itemModelList?searchName=${searchNameModel.text}&page=1&limit=10&itemGroupId=01&itemTypeId=154&itemBrandId=006&itemStatus=$itemStatus";
        break;
      case 'style':
        apiGroup =
            "setup/itemStyleList?searchName=${searchNameStyle.text}&page=1&limit=10&itemTypeId=154";
        break;
      case 'size':
        apiGroup =
            "setup/itemSizeList?searchName=${searchNameSize.text}&page=1&limit=100&itemTypeId=154";
        break;
      case 'color':
        apiGroup =
            "setup/itemColorList?searchName=${searchNameColor.text}&page=1&limit=100";
        break;
      case 'warehouse':
        apiGroup = "setup/warehouseStatus";
        break;
      case 'itemfree':
        apiGroup =
            "setup/itemFreeList?searchName=${searchNameItemFree.text}&page=1&limit=100&itemStatus=$itemStatus";
        break;
    }
    // print('testAPI>> $api$apiGroup');
    // getDataItem(apiGroup);

    return;
  }

  Future<void> getDataItem(stockapi) async {
    print('11>>$api$stockapi');
    try {
      var respose = await http.get(
        Uri.parse('$api$stockapi'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> dataItem =
            Map<String, dynamic>.from(json.decode(respose.body));
        setState(() {
          itemGroupList = dataItem['data'];
        });
        searchSetup(searchNameGroup, itemGroupList);
        print('data>> $itemGroupList');
      } else if (respose.statusCode == 400) {
        if (mounted) return;
        showProgressDialog_400(
            context, 'แจ้งเตือน', 'ไม่พบข้อมูล (${respose.statusCode})');
      } else if (respose.statusCode == 401) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.clear();
        if (mounted) return;
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
          // status_loading = true;
          // status_load404 = true;
        });
      } else if (respose.statusCode == 405) {
        if (mounted) return;
        showProgressDialog_405(
            context, 'แจ้งเตือน', 'ไม่พบข้อมูล (${respose.statusCode})');
      } else if (respose.statusCode == 500) {
        if (mounted) return;
        showProgressDialog_500(
            context, 'แจ้งเตือน', 'ข้อมูลผิดพลาด (${respose.statusCode})');
      } else {
        if (mounted) return;
        showProgressDialog(context, 'แจ้งเตือน', 'กรุณาติดต่อผู้ดูแลระบบ');
      }
    } catch (e) {
      print("ไม่มีข้อมูล $e");
      showProgressDialog(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
  }

  Future<void> searchSetup(searchName, List dataItem) async {
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

    double size = MediaQuery.of(context).size.width;
    showDialog(
      context: context,
      builder: (context) => GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        behavior: HitTestBehavior.opaque,
        child: StatefulBuilder(
          builder: (context, setState) => Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(5),
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 0,
                    color: Colors.white,
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 12, bottom: 6),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'ค้นหาข้อมูล',
                                        style: MyContant().h4normalStyle(),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              right: 0,
                              child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 4),
                                  child: Icon(
                                    Icons.close,
                                    size: 30,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(
                          color: Color.fromARGB(255, 185, 185, 185),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(5),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 0.2,
                                  blurRadius: 2,
                                  offset: const Offset(0, 1),
                                )
                              ],
                              color: const Color.fromRGBO(176, 218, 255, 1),
                            ),
                            padding: const EdgeInsets.all(8),
                            width: double.infinity,
                            child: Column(
                              children: [
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Text(
                                      'ชื่อที่ต้องการค้นหา :',
                                      style: MyContant().h4normalStyle(),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    InputProductStock(
                                      textEditingController: searchName,
                                    ),
                                    const SizedBox(width: 8),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.034,
                                width: MediaQuery.of(context).size.width * 0.22,
                                child: ElevatedButton(
                                  style: MyContant().myButtonSearchStyle(),
                                  onPressed: () {},
                                  child: const Text('ค้นหา'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            children: [
                              Text(
                                'รายการที่ค้นหา',
                                style: MyContant().h2Style(),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: Scrollbar(
                            child: ListView(
                              children: [
                                Column(
                                  children: [
                                    if (dataItem.isNotEmpty) ...[
                                      for (var i = 0;
                                          i < dataItem.length;
                                          i++) ...[
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 4, horizontal: 8),
                                          child: Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(5),
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
                                                  spreadRadius: 0.2,
                                                  blurRadius: 2,
                                                  offset: const Offset(0, 1),
                                                )
                                              ],
                                              color: const Color.fromRGBO(
                                                  176, 218, 255, 1),
                                            ),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      'รหัส : ${dataItem[i]['id']}',
                                                      style: MyContant()
                                                          .h4normalStyle(),
                                                    )
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      'ชื่อ : ${dataItem[i]['name']}',
                                                      style: MyContant()
                                                          .h4normalStyle(),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ]
                                    ]
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Padding groupBtnSearch() {
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
                    height: MediaQuery.of(context).size.height * 0.038,
                    width: MediaQuery.of(context).size.width * 0.22,
                    child: ElevatedButton(
                      style: MyContant().myButtonSearchStyle(),
                      onPressed: () {},
                      child: const Text('ค้นหา'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.038,
                    width: MediaQuery.of(context).size.width * 0.22,
                    child: ElevatedButton(
                      style: MyContant().myButtonCancelStyle(),
                      onPressed: () {},
                      child: const Text('ยกเลิก'),
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

  Expanded inputItemGroup(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8, left: 8),
        child: TextField(
          controller: itemGroup,
          onChanged: (keyword) {},
          decoration: InputDecoration(
            counterText: "",
            contentPadding: const EdgeInsets.all(6),
            isDense: true,
            enabledBorder: border,
            focusedBorder: border,
            hintStyle: const TextStyle(
              fontSize: 14,
            ),
            prefixIconConstraints: sizeIcon,
            suffixIconConstraints: sizeIcon,
            filled: true,
            fillColor: Colors.white,
          ),
          style: MyContant().TextInputStyle(),
        ),
      ),
    );
  }

  Expanded selectStcokType(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: MediaQuery.of(context).size.width * 0.09,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 4),
            child: DropdownButton(
              items: dropdownStockType
                  .map(
                    (value) => DropdownMenuItem(
                      value: value['id'],
                      child: Text(
                        value['name'],
                        style: MyContant().TextInputStyle(),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (newvalue) {
                setState(() {
                  selectStockTypeList = newvalue;
                });
              },
              value: selectStockTypeList,
              isExpanded: true,
              underline: const SizedBox(),
              // hint: Align(
              //   child: Text(
              //     'ประเภทสต็อค',
              //     style: MyContant().TextInputSelect(),
              //   ),
              // ),
            ),
          ),
        ),
      ),
    );
  }

  Expanded selectBranch(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: MediaQuery.of(context).size.width * 0.09,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 4),
            child: DropdownButton<String>(
              items: dropdownBranch.isEmpty
                  ? []
                  : dropdownBranch
                      .map(
                        (value) => DropdownMenuItem<String>(
                          value: value['id'].toString(),
                          child: Text(
                            value['name'],
                            style: MyContant().TextInputStyle(),
                          ),
                        ),
                      )
                      .toList(),
              onChanged: (String? newvalue) {
                setState(() {
                  selectBranchList = newvalue;
                });
                print(selectBranchList);
              },
              value: selectBranchList,
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

  Expanded selectGroupFree(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: MediaQuery.of(context).size.width * 0.09,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 4),
            child: DropdownButton<String>(
              items: dropdownGroupFree.isEmpty
                  ? []
                  : dropdownGroupFree
                      .map(
                        (value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: MyContant().TextInputStyle(),
                          ),
                        ),
                      )
                      .toList(),
              onChanged: (String? newvalue) {
                setState(() {
                  selectGroupFreeList = newvalue;
                });
                print(selectGroupFreeList);
              },
              value: selectGroupFreeList,
              isExpanded: true,
              underline: const SizedBox(),
              hint: Align(
                child: Text(
                  'เลือกหมวดของแถม',
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

class InputProductStock extends StatelessWidget {
  final TextEditingController textEditingController;
  const InputProductStock({Key? key, required this.textEditingController})
      : super(key: key);

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
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8, left: 8),
        child: TextField(
          controller: textEditingController,
          onChanged: (keyword) {},
          decoration: const InputDecoration(
            counterText: "",
            contentPadding: EdgeInsets.all(6),
            isDense: true,
            enabledBorder: border,
            focusedBorder: border,
            hintStyle: TextStyle(
              fontSize: 14,
            ),
            prefixIconConstraints: sizeIcon,
            suffixIconConstraints: sizeIcon,
            filled: true,
            fillColor: Colors.white,
          ),
          style: MyContant().TextInputStyle(),
        ),
      ),
    );
  }
}
