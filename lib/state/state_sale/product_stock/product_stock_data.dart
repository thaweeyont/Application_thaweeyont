import 'dart:convert';

import 'package:application_thaweeyont/api.dart';
import 'package:application_thaweeyont/state/authen.dart';
import 'package:application_thaweeyont/state/state_sale/product_stock/stock_product_list.dart';
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
  TextEditingController itemFree = TextEditingController();
  TextEditingController idGroup = TextEditingController();
  TextEditingController idType = TextEditingController();
  TextEditingController idBrand = TextEditingController();
  TextEditingController idModel = TextEditingController();
  TextEditingController idStyle = TextEditingController();
  TextEditingController idSize = TextEditingController();
  TextEditingController idColor = TextEditingController();
  TextEditingController idWareHouse = TextEditingController();
  TextEditingController idFree = TextEditingController();
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
  List dropdownStockType = [], dropdownBranch = [], dropdownGroupFree = [];
  bool isCheckedPR = false;
  bool statusLoading = false,
      itemGroupLoad = false,
      itemTypeLoad = false,
      itemBrandLoad = false,
      itemModelLoad = false,
      itemStyleLoad = false,
      itemSizeLoad = false,
      itemColorLoad = false,
      itemWarehouseLoad = false,
      itemFreeLoad = false;
  var indexWareHouse = 1;

  var selectStockTypeList,
      selectBranchList,
      selectGroupFreeList,
      idItemGroup = '',
      idItemType = '',
      idItemBrand = '',
      idItemModel = '',
      idItemStyle = '',
      idItemSize = '',
      idItemColor = '',
      idItemWareHouse = '',
      idItemFree = '';

  var apiGroup = '', itemStatus = '';
  List itemGroupList = [],
      itemTypeList = [],
      itemBrandList = [],
      itemModelList = [],
      itemStyleList = [],
      itemSizeList = [],
      itemColorList = [],
      itemWarehouseList = [],
      itemFreeList = [],
      itemList_m = [],
      myListJson = [];

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
    // await Future.delayed(const Duration(milliseconds: 100));
    if (mounted) {
      setState(() {
        getSelectStockType();
        getSelectBranch();
        getSelectGroupFree();
      });
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
        print('stock>> $selectStockTypeList');
        if (selectStockTypeList == 1 || selectStockTypeList == 3) {
          itemStatus = '1';
        } else if (selectStockTypeList == 2 || selectStockTypeList == 4) {
          itemStatus = '2';
        }
        print('status>> $itemStatus');
        getDataApi();
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

  Future<void> getDataApi() async {
    if (mounted) {
      setState(() {
        showProgressLoading(context);
        getDataItemGroupList('use');
        showProgressLoading(context);
        getDataItemColorList('use');
        showProgressLoading(context);
        getDataItemFreeList('use');
      });
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
          // dropdownBranch = dataBranch['data'];
          List df = [
            {'id': 99, 'name': "กรุณาเลือกสาขา"}
          ];
          myListJson = List.from(df)..addAll(dataBranch['data']);
          print('myList>>$myListJson');
          dropdownBranch = myListJson;
        });
        // print(df);
        print(dropdownBranch);
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

  clearDataInputStock() {
    itemGroup.clear();
    itemType.clear();
    itemBrand.clear();
    itemModel.clear();
    itemStyle.clear();
    itemSize.clear();
    itemColor.clear();
    itemWareHouse.clear();
    nameProduct.clear();
    idItemGroup = '';
    idItemType = '';
    idItemBrand = '';
    idItemModel = '';
    idItemStyle = '';
    idItemSize = '';
    idItemColor = '';
    idItemWareHouse = '';
    idItemFree = '';
    setState(() {
      selectBranchList = null;
    });
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
                          value: isCheckedPR,
                          checkColor: const Color.fromARGB(255, 0, 0, 0),
                          activeColor: const Color.fromARGB(255, 255, 255, 255),
                          onChanged: (bool? value) {
                            setState(() {
                              isCheckedPR = value!;
                            });
                            if (isCheckedPR == true) {
                              var promotion = 'pr';
                              idItemWareHouse = promotion;
                            } else {
                              var promotion = '';
                              idItemWareHouse = promotion;
                            }
                            print(isCheckedPR);
                            print(idItemWareHouse);
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
                            width: MediaQuery.of(context).size.width * 0.14,
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
                          // SizedBox(
                          //   width: MediaQuery.of(context).size.width * 0.17,
                          //   child: Text(
                          //     'คลัง : ',
                          //     style: MyContant().h4normalStyle(),
                          //     textAlign: TextAlign.right,
                          //   ),
                          // ),
                          inputIditem(context, idWareHouse, '1'),
                          inputProductStock(itemWareHouse, 'true', 'คลัง'),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              backgroundColor:
                                  const Color.fromARGB(255, 56, 162, 255),
                            ),
                            onPressed: () {
                              if (selectBranchList == '' ||
                                  selectBranchList == null ||
                                  selectBranchList == 99) {
                                showProgressDialog(
                                    context, 'แจ้งเตือน', 'กรุณาเลือกสาขา');
                              } else {
                                searchSetupItemWarehouse(searchNameWareHouse);
                              }
                            },
                            child: const Icon(
                              Icons.search,
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          // SizedBox(
                          //   width: MediaQuery.of(context).size.width * 0.17,
                          //   child:
                          // Text(
                          //   'กลุ่ม : ',
                          //   style: MyContant().h4normalStyle(),
                          //   textAlign: TextAlign.right,
                          // ),
                          // ),
                          inputIditem(context, idGroup, '2'),
                          inputProductStock(itemGroup, 'true', 'กลุ่ม'),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              backgroundColor:
                                  const Color.fromARGB(255, 56, 162, 255),
                            ),
                            onPressed: () async {
                              searchSetupItemGroup(searchNameGroup);
                            },
                            child: const Icon(
                              Icons.search,
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          // SizedBox(
                          //   width: MediaQuery.of(context).size.width * 0.17,
                          //   child:
                          // Text(
                          //   'ประเภท : ',
                          //   style: MyContant().h4normalStyle(),
                          //   textAlign: TextAlign.right,
                          // ),
                          // ),
                          inputIditem(context, idType, '3'),
                          inputProductStock(itemType, 'true', 'ประเภท'),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              backgroundColor:
                                  const Color.fromARGB(255, 56, 162, 255),
                            ),
                            onPressed: () async {
                              if (itemGroup.text.isEmpty) {
                                showProgressDialog(context, 'แจ้งเตือน',
                                    'กรุณาเลือกกลุ่มสินค้า');
                              } else {
                                searchSetupItemType(searchNameType);
                              }
                            },
                            child: const Icon(
                              Icons.search,
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          // SizedBox(
                          //   width: MediaQuery.of(context).size.width * 0.17,
                          //   child:
                          // Text(
                          //   'ยี่ห้อ : ',
                          //   style: MyContant().h4normalStyle(),
                          //   textAlign: TextAlign.right,
                          // ),
                          // ),
                          inputIditem(context, idBrand, '4'),
                          inputProductStock(itemBrand, 'true', 'ยี่ห้อ'),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              backgroundColor:
                                  const Color.fromARGB(255, 56, 162, 255),
                            ),
                            onPressed: () {
                              if (itemGroup.text.isEmpty &&
                                  itemType.text.isEmpty) {
                                showProgressDialog(context, 'แจ้งเตือน',
                                    'กรุณาเลือกกลุ่มสินค้าและประเภทสินค้า');
                              } else if (itemType.text.isEmpty) {
                                showProgressDialog(context, 'แจ้งเตือน',
                                    'กรุณาเลือกประเภทสินค้า');
                              } else {
                                searchSetupItemBrand(searchNameBrand);
                              }
                            },
                            child: const Icon(
                              Icons.search,
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          // SizedBox(
                          //   width: MediaQuery.of(context).size.width * 0.17,
                          //   child: Text(
                          //     'รุ่น : ',
                          //     style: MyContant().h4normalStyle(),
                          //     textAlign: TextAlign.right,
                          //   ),
                          // ),
                          inputIditem(context, idModel, '5'),
                          inputProductStock(itemModel, 'true', 'รุ่น'),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              backgroundColor:
                                  const Color.fromARGB(255, 56, 162, 255),
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
                                searchSetupItemModel(searchNameModel);
                              }
                            },
                            child: const Icon(
                              Icons.search,
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          // SizedBox(
                          //   width: MediaQuery.of(context).size.width * 0.17,
                          //   child: Text(
                          //     'แบบ : ',
                          //     style: MyContant().h4normalStyle(),
                          //     textAlign: TextAlign.right,
                          //   ),
                          // ),
                          inputIditem(context, idStyle, '6'),
                          inputProductStock(itemStyle, 'true', 'แบบ'),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              backgroundColor:
                                  const Color.fromARGB(255, 56, 162, 255),
                            ),
                            onPressed: () {
                              if (itemType.text.isEmpty) {
                                showProgressDialog(context, 'แจ้งเตือน',
                                    'กรุณาเลือกประเภทสินค้า');
                              } else {
                                searchSetupItemStyle(searchNameStyle);
                              }
                            },
                            child: const Icon(
                              Icons.search,
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          // SizedBox(
                          //   width: MediaQuery.of(context).size.width * 0.17,
                          //   child: Text(
                          //     'ขนาด : ',
                          //     style: MyContant().h4normalStyle(),
                          //     textAlign: TextAlign.right,
                          //   ),
                          // ),
                          inputIditem(context, idSize, '7'),
                          inputProductStock(itemSize, 'true', 'ขนาด'),
                          SizedBox(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: const CircleBorder(),
                                backgroundColor:
                                    const Color.fromARGB(255, 56, 162, 255),
                              ),
                              onPressed: () {
                                if (itemType.text.isEmpty) {
                                  showProgressDialog(context, 'แจ้งเตือน',
                                      'กรุณาเลือกประเภทสินค้า');
                                } else {
                                  searchSetupItemSize(searchNameSize);
                                }
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
                          // SizedBox(
                          //   width: MediaQuery.of(context).size.width * 0.17,
                          //   child: Text(
                          //     'สี : ',
                          //     style: MyContant().h4normalStyle(),
                          //     textAlign: TextAlign.right,
                          //   ),
                          // ),
                          inputIditem(context, idColor, '8'),
                          inputProductStock(itemColor, 'true', 'สี'),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              backgroundColor:
                                  const Color.fromARGB(255, 56, 162, 255),
                            ),
                            onPressed: () {
                              searchSetupItemColor(searchNameColor);
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
                          inputProductStock(nameProduct, 'false', 'ชื่อสินค้า'),
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
                            width: MediaQuery.of(context).size.width * 0.14,
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
                          // SizedBox(
                          //   width: MediaQuery.of(context).size.width * 0.17,
                          //   child: Text(
                          //     'คลัง : ',
                          //     style: MyContant().h4normalStyle(),
                          //     textAlign: TextAlign.right,
                          //   ),
                          // ),
                          inputIditem(context, idWareHouse, '1'),
                          inputProductStock(itemWareHouse, 'true', 'คลัง'),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              backgroundColor:
                                  const Color.fromARGB(255, 56, 162, 255),
                            ),
                            onPressed: () {
                              searchSetupItemWarehouse(searchNameWareHouse);
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
                          inputProductStock(nameProduct, 'false', 'ชื่อสินค้า'),
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
                          ),
                          selectGroupFree(sizeIcon, border),
                        ],
                      ),
                      Row(
                        children: [
                          // SizedBox(
                          //   width: MediaQuery.of(context).size.width * 0.18,
                          //   child: Text(
                          //     'ของแถม :',
                          //     style: MyContant().h4normalStyle(),
                          //     textAlign: TextAlign.right,
                          //   ),
                          // ),
                          inputIditem(context, idFree, '9'),
                          inputProductStock(itemFree, 'true', 'ของแถม'),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              backgroundColor:
                                  const Color.fromARGB(255, 56, 162, 255),
                            ),
                            onPressed: () {
                              searchSetupItemFree(searchNameItemFree);
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
                      onPressed: () {
                        var branch, groupFree;
                        if (selectBranchList == null ||
                            selectBranchList == 99) {
                          branch = '';
                        } else {
                          branch = selectBranchList;
                        }
                        if (selectGroupFreeList == null) {
                          groupFree = '';
                        } else {
                          groupFree = selectGroupFreeList;
                        }

                        if (selectStockTypeList == 1 ||
                            selectStockTypeList == 2) {
                          print('id_g>>$idItemGroup ${itemGroup.text}');
                          print('id_ty>>$idItemType ${itemType.text}');
                          print('id_b>>$idItemBrand ${itemBrand.text}');
                          print('id_m>>$idItemModel ${itemModel.text}');
                          print('id_st>>$idItemStyle ${itemStyle.text}');
                          print('id_si>>$idItemSize ${itemSize.text}');
                          print('id_c>>$idItemColor ${itemColor.text}');
                          print('id_branch>>$branch');
                          print(
                              'id_ware>>$idItemWareHouse ${itemWareHouse.text}');
                          print('id_nameP>>${nameProduct.text}');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StockProductList(
                                  selectStockTypeList.toString(),
                                  branch,
                                  idItemWareHouse,
                                  nameProduct.text,
                                  groupFree,
                                  idItemFree,
                                  idItemGroup,
                                  idItemType,
                                  idItemBrand,
                                  idItemModel,
                                  idItemStyle,
                                  idItemSize,
                                  idItemColor),
                            ),
                          );
                        } else if (selectStockTypeList == 3 ||
                            selectStockTypeList == 4) {
                          print('id_g>>$idItemGroup ${itemGroup.text}');
                          print('id_ty>>$idItemType ${itemType.text}');
                          print('id_b>>$idItemBrand ${itemBrand.text}');
                          print('id_m>>$idItemModel ${itemModel.text}');
                          print('id_st>>$idItemStyle ${itemStyle.text}');
                          print('id_si>>$idItemSize ${itemSize.text}');
                          print('id_c>>$idItemColor ${itemColor.text}');
                          print(
                              'id_ware>>$idItemWareHouse ${itemWareHouse.text}');
                          print('id_nameP>>${nameProduct.text}');
                          print('id_branch>>$branch');
                          print('id_groupfree>>$groupFree');
                          print('id_itemfree>>$idItemFree');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StockProductList(
                                selectStockTypeList.toString(),
                                branch,
                                idItemWareHouse,
                                nameProduct.text,
                                groupFree,
                                idItemFree,
                                '',
                                '',
                                '',
                                '',
                                '',
                                '',
                                '',
                              ),
                            ),
                          );
                        }
                      },
                      child: const Text('ค้นหา'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.038,
                    width: MediaQuery.of(context).size.width * 0.22,
                    child: ElevatedButton(
                      style: MyContant().myButtonCancelStyle(),
                      onPressed: () {
                        clearDataInputStock();
                      },
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
                  print('stock.1>> $selectStockTypeList');
                  if (selectStockTypeList == 1 || selectStockTypeList == 3) {
                    itemStatus = '1';
                  } else if (selectStockTypeList == 2 ||
                      selectStockTypeList == 4) {
                    itemStatus = '2';
                  }
                  print('status.1>> $itemStatus');
                });
              },
              value: selectStockTypeList,
              isExpanded: true,
              underline: const SizedBox(),
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
            child: DropdownButton(
              items: dropdownBranch
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
              onChanged: (newvalue) async {
                setState(() {
                  selectBranchList = newvalue;
                  print('$selectBranchList');
                });
                // api warehouse
                if (selectBranchList != 99) {
                  getDataItemWarehouseList('no');
                } else {
                  dropdownBranch.clear();
                  itemWarehouseList.clear();
                  getSelectBranch();
                }

                print(selectBranchList);
              },
              value: selectBranchList,
              isExpanded: true,
              underline: const SizedBox(),
              hint: Align(
                child: Text(
                  'กรุณาเลือกสาขา',
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
            child: DropdownButton(
              items: dropdownGroupFree
                  .map(
                    (value) => DropdownMenuItem(
                      value: value,
                      child: Text(
                        value,
                        style: MyContant().TextInputStyle(),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (newvalue) {
                setState(() {
                  selectGroupFreeList = newvalue;
                });
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

  Expanded inputNameProduct(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8, left: 8),
        child: TextField(
          controller: nameProduct,
          onChanged: (keyword) {},
          decoration: InputDecoration(
            counterText: "",
            contentPadding: const EdgeInsets.all(6),
            isDense: true,
            enabledBorder: border,
            focusedBorder: border,
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

// ItemGroupLIst
  Future<void> getDataItemGroupList(nav) async {
    itemGroupList = [];
    try {
      var respose = await http.get(
        Uri.parse(
            '${api}setup/itemGroupList?searchName=${searchNameGroup.text}&page=1&limit=100'),
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
        if (nav == 'use') {
          Navigator.pop(context);
        }
        itemGroupLoad = false;
        print('data_g>> $itemGroupList');
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
          Navigator.pop(context);
          itemGroupLoad = true;
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
      print("ไม่มีข้อมูล $e");
      showProgressDialog(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
  }

  Future<void> searchSetupItemGroup(searchName) async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        behavior: HitTestBehavior.opaque,
        child: StatefulBuilder(
          builder: (context, setStateSB) => Container(
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
                                        'ค้นหากลุ่มสินค้า',
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
                                onTap: () async {
                                  searchNameGroup.clear();
                                  getDataItemGroupList('no');
                                  Navigator.pop(context);
                                  itemGroupLoad = false;
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
                              color: const Color.fromARGB(255, 130, 196, 255),
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
                                    inputProductStock(searchName, 'false', ''),
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
                                  onPressed: () {
                                    showProgressLoading(context);
                                    getDataItemGroupList('use');
                                  },
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
                          child: itemGroupLoad == true
                              ? Center(
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    height: MediaQuery.of(context).size.height *
                                        0.15,
                                    child: Column(
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  'images/Nodata.png',
                                                  width: 55,
                                                  height: 55,
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'ไม่พบรายการข้อมูล',
                                                  style:
                                                      MyContant().h5NotData(),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(5),
                                          ),
                                          color: const Color.fromARGB(
                                              255, 130, 196, 255),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                              spreadRadius: 0.2,
                                              blurRadius: 2,
                                              offset: const Offset(0, 1),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  '  รหัส      ชื่อกลุ่มสินค้า',
                                                  style: MyContant()
                                                      .h4normalStyle(),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Scrollbar(
                                        child: ListView(
                                          shrinkWrap: true,
                                          children: [
                                            Column(
                                              children: [
                                                if (itemGroupList
                                                    .isNotEmpty) ...[
                                                  for (var i = 0;
                                                      i < itemGroupList.length;
                                                      i++) ...[
                                                    InkWell(
                                                      onTap: () async {
                                                        setState(() {
                                                          itemGroup.text =
                                                              itemGroupList[i]
                                                                  ['name'];
                                                          idGroup.text =
                                                              itemGroupList[i]
                                                                  ['id'];
                                                          idItemGroup =
                                                              itemGroupList[i]
                                                                  ['id'];
                                                        });
                                                        getDataItemTypeList(
                                                            'no');
                                                        searchNameGroup.clear();
                                                        getDataItemGroupList(
                                                            'no');
                                                        Navigator.pop(context);
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 4,
                                                                horizontal: 8),
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  5),
                                                            ),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors
                                                                    .grey
                                                                    .withOpacity(
                                                                        0.5),
                                                                spreadRadius:
                                                                    0.2,
                                                                blurRadius: 2,
                                                                offset:
                                                                    const Offset(
                                                                        0, 1),
                                                              )
                                                            ],
                                                            color: const Color
                                                                    .fromRGBO(
                                                                176,
                                                                218,
                                                                255,
                                                                1),
                                                          ),
                                                          child: Column(
                                                            children: [
                                                              Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Container(
                                                                    color: const Color
                                                                            .fromRGBO(
                                                                        176,
                                                                        218,
                                                                        255,
                                                                        1),
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.18,
                                                                    child: Text(
                                                                      '  ${itemGroupList[i]['id']}',
                                                                      style: MyContant()
                                                                          .h4normalStyle(),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child: Text(
                                                                      '${itemGroupList[i]['name']}',
                                                                      overflow:
                                                                          TextOverflow
                                                                              .clip,
                                                                      style: MyContant()
                                                                          .h4normalStyle(),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              // Row(
                                                              //   children: [
                                                              //     Text(
                                                              //       'ชื่อ : ${itemGroupList[i]['name']}',
                                                              //       style: MyContant()
                                                              //           .h4normalStyle(),
                                                              //     )
                                                              //   ],
                                                              // )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ],
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
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

// ItemTypeList
  Future<void> getDataItemTypeList(nav) async {
    print('stock_t>> $selectStockTypeList');
    print('status_t>> $itemStatus');
    itemTypeList = [];
    try {
      var respose = await http.get(
        Uri.parse(
            '${api}setup/itemTypeList?searchName=${searchNameType.text}&page=1&limit=100&itemGroupId=$idItemGroup&itemStatus=$itemStatus'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> dataItemType =
            Map<String, dynamic>.from(json.decode(respose.body));
        setState(() {
          itemTypeList = dataItemType['data'];
        });
        if (nav == 'use') {
          Navigator.pop(context);
        }
        itemTypeLoad = false;
        print('data_t>> $itemTypeList');
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
        print('no data555');
        setState(() {
          if (nav == 'use') {
            Navigator.pop(context);
          }
          itemTypeLoad = true;
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
      print("ไม่มีข้อมูล $e");
      showProgressDialog(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
  }

  Future<void> searchSetupItemType(searchName) async {
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
                                        'ค้นหาประเภทสินค้า',
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
                                  searchNameType.clear();
                                  getDataItemTypeList('no');
                                  Navigator.pop(context);
                                  itemTypeLoad = false;
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
                              color: const Color.fromARGB(255, 130, 196, 255),
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
                                    inputProductStock(searchName, 'false', ''),
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
                                  onPressed: () {
                                    showProgressLoading(context);
                                    getDataItemTypeList('use');
                                  },
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
                          child: itemTypeLoad == true
                              ? Center(
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    height: MediaQuery.of(context).size.height *
                                        0.15,
                                    child: Column(
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  'images/Nodata.png',
                                                  width: 55,
                                                  height: 55,
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'ไม่พบรายการข้อมูล',
                                                  style:
                                                      MyContant().h5NotData(),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(5),
                                          ),
                                          color: const Color.fromARGB(
                                              255, 130, 196, 255),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                              spreadRadius: 0.2,
                                              blurRadius: 2,
                                              offset: const Offset(0, 1),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  '  รหัส      ชื่อประเภทสินค้า',
                                                  style: MyContant()
                                                      .h4normalStyle(),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Scrollbar(
                                        child: ListView(
                                          shrinkWrap: true,
                                          children: [
                                            Column(
                                              children: [
                                                if (itemTypeList
                                                    .isNotEmpty) ...[
                                                  for (var i = 0;
                                                      i < itemTypeList.length;
                                                      i++) ...[
                                                    InkWell(
                                                      onTap: () async {
                                                        setState(() {
                                                          itemType.text =
                                                              itemTypeList[i]
                                                                  ['name'];
                                                          idType.text =
                                                              itemTypeList[i]
                                                                  ['id'];
                                                          idItemType =
                                                              itemTypeList[i]
                                                                  ['id'];
                                                        });
                                                        getDataItemBrandList(
                                                            'no');
                                                        getDataItemStyleList(
                                                            'no');
                                                        getDataItemSizeList(
                                                            'no');
                                                        searchNameType.clear();
                                                        getDataItemTypeList(
                                                            'no');
                                                        Navigator.pop(context);
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 4,
                                                                horizontal: 8),
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  5),
                                                            ),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors
                                                                    .grey
                                                                    .withOpacity(
                                                                        0.5),
                                                                spreadRadius:
                                                                    0.2,
                                                                blurRadius: 2,
                                                                offset:
                                                                    const Offset(
                                                                        0, 1),
                                                              )
                                                            ],
                                                            color: const Color
                                                                    .fromRGBO(
                                                                176,
                                                                218,
                                                                255,
                                                                1),
                                                          ),
                                                          child: Column(
                                                            children: [
                                                              Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Container(
                                                                    color: const Color
                                                                            .fromRGBO(
                                                                        176,
                                                                        218,
                                                                        255,
                                                                        1),
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.18,
                                                                    child: Text(
                                                                      '  ${itemTypeList[i]['id']}',
                                                                      style: MyContant()
                                                                          .h4normalStyle(),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child: Text(
                                                                      '${itemTypeList[i]['name']}',
                                                                      overflow:
                                                                          TextOverflow
                                                                              .clip,
                                                                      style: MyContant()
                                                                          .h4normalStyle(),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              // Row(
                                                              //   crossAxisAlignment:
                                                              //       CrossAxisAlignment
                                                              //           .start,
                                                              //   children: [
                                                              //     Text(
                                                              //       'ชื่อ : ',
                                                              //       style: MyContant()
                                                              //           .h4normalStyle(),
                                                              //     ),
                                                              //     Expanded(
                                                              //       child: Text(
                                                              //         '',
                                                              //         overflow:
                                                              //             TextOverflow
                                                              //                 .clip,
                                                              //         style: MyContant()
                                                              //             .h4normalStyle(),
                                                              //       ),
                                                              //     )
                                                              //   ],
                                                              // )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ],
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
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

// ItemBrandList
  Future<void> getDataItemBrandList(nav) async {
    print('stock_b>> $selectStockTypeList');
    print('status_b>> $itemStatus');
    itemBrandList = [];
    try {
      var respose = await http.get(
        Uri.parse(
            '${api}setup/itemBrandList?searchName=${searchNameBrand.text}&page=1&limit=100&itemGroupId=$idItemGroup&itemTypeId=$idItemType&itemStatus=$itemStatus'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> dataItemBrand =
            Map<String, dynamic>.from(json.decode(respose.body));
        setState(() {
          itemBrandList = dataItemBrand['data'];
        });
        if (nav == 'use') {
          Navigator.pop(context);
        }
        itemBrandLoad = false;
        print('data_b>> $itemBrandList');
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
        print('no data444');
        setState(() {
          Navigator.pop(context);
          itemBrandLoad = true;
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
      print("ไม่มีข้อมูล $e");
      showProgressDialog(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
  }

  Future<void> searchSetupItemBrand(searchName) async {
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
                                        'ค้นหายี่ห้อสินค้า',
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
                                  searchNameBrand.clear();
                                  getDataItemBrandList('no');
                                  Navigator.pop(context);
                                  itemBrandLoad = false;
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
                              color: const Color.fromARGB(255, 130, 196, 255),
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
                                    inputProductStock(searchName, 'false', ''),
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
                                  onPressed: () {
                                    showProgressLoading(context);
                                    getDataItemBrandList('use');
                                  },
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
                          child: itemBrandLoad == true
                              ? Center(
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    height: MediaQuery.of(context).size.height *
                                        0.15,
                                    child: Column(
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  'images/Nodata.png',
                                                  width: 55,
                                                  height: 55,
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'ไม่พบรายการข้อมูล',
                                                  style:
                                                      MyContant().h5NotData(),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(5),
                                          ),
                                          color: const Color.fromARGB(
                                              255, 130, 196, 255),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                              spreadRadius: 0.2,
                                              blurRadius: 2,
                                              offset: const Offset(0, 1),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  '  รหัส      ชื่อยี่ห้อสินค้า',
                                                  style: MyContant()
                                                      .h4normalStyle(),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Scrollbar(
                                        child: ListView(
                                          shrinkWrap: true,
                                          children: [
                                            Column(
                                              children: [
                                                if (itemBrandList
                                                    .isNotEmpty) ...[
                                                  for (var i = 0;
                                                      i < itemBrandList.length;
                                                      i++) ...[
                                                    InkWell(
                                                      onTap: () async {
                                                        setState(() {
                                                          itemBrand.text =
                                                              itemBrandList[i]
                                                                  ['name'];
                                                          idBrand.text =
                                                              itemBrandList[i]
                                                                  ['id'];
                                                          idItemBrand =
                                                              itemBrandList[i]
                                                                  ['id'];
                                                        });
                                                        getDataItemModelList(
                                                            'no', 'noload');
                                                        searchNameBrand.clear();
                                                        getDataItemBrandList(
                                                            'no');
                                                        Navigator.pop(context);
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 4,
                                                                horizontal: 8),
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  5),
                                                            ),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors
                                                                    .grey
                                                                    .withOpacity(
                                                                        0.5),
                                                                spreadRadius:
                                                                    0.2,
                                                                blurRadius: 2,
                                                                offset:
                                                                    const Offset(
                                                                        0, 1),
                                                              )
                                                            ],
                                                            color: const Color
                                                                    .fromRGBO(
                                                                176,
                                                                218,
                                                                255,
                                                                1),
                                                          ),
                                                          child: Column(
                                                            children: [
                                                              Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Container(
                                                                    color: const Color
                                                                            .fromRGBO(
                                                                        176,
                                                                        218,
                                                                        255,
                                                                        1),
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.18,
                                                                    child: Text(
                                                                      '  ${itemBrandList[i]['id']}',
                                                                      style: MyContant()
                                                                          .h4normalStyle(),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child: Text(
                                                                      '${itemBrandList[i]['name']}',
                                                                      overflow:
                                                                          TextOverflow
                                                                              .clip,
                                                                      style: MyContant()
                                                                          .h4normalStyle(),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              // Row(
                                                              //   children: [
                                                              //     Text(
                                                              //       'รหัส : ${itemBrandList[i]['id']}',
                                                              //       style: MyContant()
                                                              //           .h4normalStyle(),
                                                              //     )
                                                              //   ],
                                                              // ),
                                                              // Row(
                                                              //   children: [
                                                              //     Text(
                                                              //       'ชื่อ : ${itemBrandList[i]['name']}',
                                                              //       style: MyContant()
                                                              //           .h4normalStyle(),
                                                              //     )
                                                              //   ],
                                                              // )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ],
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
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

// ItemModelList
  Future<void> getDataItemModelList(nav, load) async {
    print('stock_m>> $selectStockTypeList');
    print('status_m>> $itemStatus');
    itemModelList = [];
    try {
      var respose = await http.get(
        Uri.parse(
            '${api}setup/itemModelList?searchName=${searchNameModel.text}&page=1&limit=100&itemGroupId=$idItemGroup&itemTypeId=$idItemType&itemBrandId=$idItemBrand&itemStatus=$itemStatus'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> dataItemModel =
            Map<String, dynamic>.from(json.decode(respose.body));
        setState(() {
          itemModelList = dataItemModel['data'];
        });
        if (nav == 'use') {
          Navigator.pop(context);
        }
        itemModelLoad = false;
        print('data_model>> $itemModelList');
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
        print('no data');
        setState(() {
          if (load == 'load') {
            Navigator.pop(context);
          }
          itemModelLoad = true;
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
      print("ไม่มีข้อมูล $e");
      showProgressDialog(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
  }

  Future<void> searchSetupItemModel(searchName) async {
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
                                        'ค้นหารุ่นสินค้า',
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
                                  searchNameModel.clear();
                                  getDataItemModelList('no', 'noload');
                                  Navigator.pop(context);
                                  itemModelLoad = false;
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
                              color: const Color.fromARGB(255, 130, 196, 255),
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
                                    inputProductStock(searchName, 'false', ''),
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
                                  onPressed: () {
                                    showProgressLoading(context);
                                    getDataItemModelList('use', 'load');
                                  },
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
                          child: itemModelLoad == true
                              ? Center(
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    height: MediaQuery.of(context).size.height *
                                        0.15,
                                    child: Column(
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  'images/Nodata.png',
                                                  width: 55,
                                                  height: 55,
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'ไม่พบรายการข้อมูล',
                                                  style:
                                                      MyContant().h5NotData(),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(5),
                                          ),
                                          color: const Color.fromARGB(
                                              255, 130, 196, 255),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                              spreadRadius: 0.2,
                                              blurRadius: 2,
                                              offset: const Offset(0, 1),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  '  รหัส      ชื่อรุ่นสินค้า',
                                                  style: MyContant()
                                                      .h4normalStyle(),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Scrollbar(
                                        child: ListView(
                                          shrinkWrap: true,
                                          children: [
                                            Column(
                                              children: [
                                                if (itemModelList
                                                    .isNotEmpty) ...[
                                                  for (var i = 0;
                                                      i < itemModelList.length;
                                                      i++) ...[
                                                    InkWell(
                                                      onTap: () async {
                                                        setState(() {
                                                          itemModel.text =
                                                              itemModelList[i]
                                                                  ['name'];
                                                          idModel.text =
                                                              idItemModel =
                                                                  itemModelList[
                                                                      i]['id'];
                                                          itemModelList[i]
                                                              ['id'];
                                                        });
                                                        searchNameModel.clear();
                                                        getDataItemModelList(
                                                            'no', 'noload');
                                                        Navigator.pop(context);
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 4,
                                                                horizontal: 8),
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  5),
                                                            ),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors
                                                                    .grey
                                                                    .withOpacity(
                                                                        0.5),
                                                                spreadRadius:
                                                                    0.2,
                                                                blurRadius: 2,
                                                                offset:
                                                                    const Offset(
                                                                        0, 1),
                                                              )
                                                            ],
                                                            color: const Color
                                                                    .fromRGBO(
                                                                176,
                                                                218,
                                                                255,
                                                                1),
                                                          ),
                                                          child: Column(
                                                            children: [
                                                              Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Container(
                                                                    color: const Color
                                                                            .fromRGBO(
                                                                        176,
                                                                        218,
                                                                        255,
                                                                        1),
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.18,
                                                                    child: Text(
                                                                      '  ${itemModelList[i]['id']}',
                                                                      style: MyContant()
                                                                          .h4normalStyle(),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child: Text(
                                                                      '${itemModelList[i]['name']}',
                                                                      overflow:
                                                                          TextOverflow
                                                                              .clip,
                                                                      style: MyContant()
                                                                          .h4normalStyle(),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              // Row(
                                                              //   children: [
                                                              //     Text(
                                                              //       'รหัส : ${itemModelList[i]['id']}',
                                                              //       style: MyContant()
                                                              //           .h4normalStyle(),
                                                              //     )
                                                              //   ],
                                                              // ),
                                                              // Row(
                                                              //   children: [
                                                              //     Text(
                                                              //       'ชื่อ : ${itemModelList[i]['name']}',
                                                              //       style: MyContant()
                                                              //           .h4normalStyle(),
                                                              //     )
                                                              //   ],
                                                              // )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ],
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
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

// ItemStyleList
  Future<void> getDataItemStyleList(nav) async {
    itemStyleList = [];
    try {
      var respose = await http.get(
        Uri.parse(
            '${api}setup/itemStyleList?searchName=${searchNameStyle.text}&page=1&limit=100&itemTypeId=$idItemType'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> dataItemStyle =
            Map<String, dynamic>.from(json.decode(respose.body));
        setState(() {
          itemStyleList = dataItemStyle['data'];
        });
        if (nav == 'use') {
          Navigator.pop(context);
        }
        itemStyleLoad = false;
        print('data_st>> $itemStyleList');
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
        print('no data333');
        setState(() {
          if (nav == 'use') {
            Navigator.pop(context);
          }
          itemStyleLoad = true;
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
      print("ไม่มีข้อมูล $e");
      showProgressDialog(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
  }

  Future<void> searchSetupItemStyle(searchName) async {
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
                                        'ค้นหาแบบสินค้า',
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
                                  searchNameStyle.clear();
                                  getDataItemStyleList('no');
                                  Navigator.pop(context);
                                  itemStyleLoad = false;
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
                              color: const Color.fromARGB(255, 130, 196, 255),
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
                                    inputProductStock(searchName, 'false', ''),
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
                                  onPressed: () {
                                    showProgressLoading(context);
                                    getDataItemStyleList('use');
                                  },
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
                          child: itemStyleLoad == true
                              ? Center(
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    height: MediaQuery.of(context).size.height *
                                        0.15,
                                    child: Column(
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  'images/Nodata.png',
                                                  width: 55,
                                                  height: 55,
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'ไม่พบรายการข้อมูล',
                                                  style:
                                                      MyContant().h5NotData(),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(5),
                                          ),
                                          color: const Color.fromARGB(
                                              255, 130, 196, 255),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                              spreadRadius: 0.2,
                                              blurRadius: 2,
                                              offset: const Offset(0, 1),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  '  รหัส      ชื่อแบบสินค้า',
                                                  style: MyContant()
                                                      .h4normalStyle(),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Scrollbar(
                                        child: ListView(
                                          shrinkWrap: true,
                                          children: [
                                            Column(
                                              children: [
                                                if (itemStyleList
                                                    .isNotEmpty) ...[
                                                  for (var i = 0;
                                                      i < itemStyleList.length;
                                                      i++) ...[
                                                    InkWell(
                                                      onTap: () async {
                                                        setState(() {
                                                          itemStyle.text =
                                                              itemStyleList[i]
                                                                  ['name'];
                                                          idStyle.text =
                                                              itemStyleList[i]
                                                                  ['id'];
                                                          idItemStyle =
                                                              itemStyleList[i]
                                                                  ['id'];
                                                        });
                                                        searchNameStyle.clear();
                                                        getDataItemStyleList(
                                                            'no');
                                                        Navigator.pop(context);
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 4,
                                                                horizontal: 8),
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  5),
                                                            ),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors
                                                                    .grey
                                                                    .withOpacity(
                                                                        0.5),
                                                                spreadRadius:
                                                                    0.2,
                                                                blurRadius: 2,
                                                                offset:
                                                                    const Offset(
                                                                        0, 1),
                                                              )
                                                            ],
                                                            color: const Color
                                                                    .fromRGBO(
                                                                176,
                                                                218,
                                                                255,
                                                                1),
                                                          ),
                                                          child: Column(
                                                            children: [
                                                              Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Container(
                                                                    color: const Color
                                                                            .fromRGBO(
                                                                        176,
                                                                        218,
                                                                        255,
                                                                        1),
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.18,
                                                                    child: Text(
                                                                      '  ${itemStyleList[i]['id']}',
                                                                      style: MyContant()
                                                                          .h4normalStyle(),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child: Text(
                                                                      '${itemStyleList[i]['name']}',
                                                                      overflow:
                                                                          TextOverflow
                                                                              .clip,
                                                                      style: MyContant()
                                                                          .h4normalStyle(),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              // Row(
                                                              //   children: [
                                                              //     Text(
                                                              //       'รหัส : ${itemStyleList[i]['id']}',
                                                              //       style: MyContant()
                                                              //           .h4normalStyle(),
                                                              //     )
                                                              //   ],
                                                              // ),
                                                              // Row(
                                                              //   children: [
                                                              //     Text(
                                                              //       'ชื่อ : ${itemStyleList[i]['name']}',
                                                              //       style: MyContant()
                                                              //           .h4normalStyle(),
                                                              //     )
                                                              //   ],
                                                              // )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ],
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
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

// ItemSizeList
  Future<void> getDataItemSizeList(nav) async {
    itemSizeList = [];
    try {
      var respose = await http.get(
        Uri.parse(
            '${api}setup/itemSizeList?searchName=${searchNameSize.text}&page=1&limit=100&itemTypeId=$idItemType'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> dataItemSize =
            Map<String, dynamic>.from(json.decode(respose.body));
        setState(() {
          itemSizeList = dataItemSize['data'];
        });
        if (nav == 'use') {
          Navigator.pop(context);
        }
        itemSizeLoad = false;
        print('data_si>> $itemSizeList');
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
        print('no data');
        setState(() {
          if (nav == 'use') {
            Navigator.pop(context);
          }
          itemSizeLoad = true;
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
      print("ไม่มีข้อมูล $e");
      showProgressDialog(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
  }

  Future<void> searchSetupItemSize(searchName) async {
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
                                        'ค้นหาขนาดสินค้า',
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
                                  searchNameSize.clear();
                                  getDataItemSizeList('no');
                                  Navigator.pop(context);
                                  itemSizeLoad = false;
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
                              color: const Color.fromARGB(255, 130, 196, 255),
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
                                    inputProductStock(searchName, 'false', ''),
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
                                  onPressed: () {
                                    showProgressLoading(context);
                                    getDataItemSizeList('use');
                                  },
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
                          child: itemSizeLoad == true
                              ? Center(
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    height: MediaQuery.of(context).size.height *
                                        0.15,
                                    child: Column(
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  'images/Nodata.png',
                                                  width: 55,
                                                  height: 55,
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'ไม่พบรายการข้อมูล',
                                                  style:
                                                      MyContant().h5NotData(),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(5),
                                          ),
                                          color: const Color.fromARGB(
                                              255, 130, 196, 255),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                              spreadRadius: 0.2,
                                              blurRadius: 2,
                                              offset: const Offset(0, 1),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  '  รหัส      ชื่อขนาดสินค้า',
                                                  style: MyContant()
                                                      .h4normalStyle(),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Scrollbar(
                                        child: ListView(
                                          shrinkWrap: true,
                                          children: [
                                            Column(
                                              children: [
                                                if (itemSizeList
                                                    .isNotEmpty) ...[
                                                  for (var i = 0;
                                                      i < itemSizeList.length;
                                                      i++) ...[
                                                    InkWell(
                                                      onTap: () async {
                                                        setState(() {
                                                          itemSize.text =
                                                              itemSizeList[i]
                                                                  ['name'];
                                                          idSize.text =
                                                              itemSizeList[i]
                                                                  ['id'];
                                                          idItemSize =
                                                              itemSizeList[i]
                                                                  ['id'];
                                                        });
                                                        searchNameSize.clear();
                                                        getDataItemSizeList(
                                                            'no');
                                                        Navigator.pop(context);
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 4,
                                                                horizontal: 8),
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  5),
                                                            ),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors
                                                                    .grey
                                                                    .withOpacity(
                                                                        0.5),
                                                                spreadRadius:
                                                                    0.2,
                                                                blurRadius: 2,
                                                                offset:
                                                                    const Offset(
                                                                        0, 1),
                                                              )
                                                            ],
                                                            color: const Color
                                                                    .fromRGBO(
                                                                176,
                                                                218,
                                                                255,
                                                                1),
                                                          ),
                                                          child: Column(
                                                            children: [
                                                              Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Container(
                                                                    color: const Color
                                                                            .fromRGBO(
                                                                        176,
                                                                        218,
                                                                        255,
                                                                        1),
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.18,
                                                                    child: Text(
                                                                      '  ${itemSizeList[i]['id']}',
                                                                      style: MyContant()
                                                                          .h4normalStyle(),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child: Text(
                                                                      '${itemSizeList[i]['name']}',
                                                                      overflow:
                                                                          TextOverflow
                                                                              .clip,
                                                                      style: MyContant()
                                                                          .h4normalStyle(),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              // Row(
                                                              //   children: [
                                                              //     Text(
                                                              //       'รหัส : ${itemSizeList[i]['id']}',
                                                              //       style: MyContant()
                                                              //           .h4normalStyle(),
                                                              //     )
                                                              //   ],
                                                              // ),
                                                              // Row(
                                                              //   children: [
                                                              //     Text(
                                                              //       'ชื่อ : ${itemSizeList[i]['name']}',
                                                              //       style: MyContant()
                                                              //           .h4normalStyle(),
                                                              //     )
                                                              //   ],
                                                              // )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ],
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
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

// ItemColorList
  Future<void> getDataItemColorList(nav) async {
    itemColorList = [];
    try {
      var respose = await http.get(
        Uri.parse(
            '${api}setup/itemColorList?searchName=${searchNameColor.text}&page=1&limit=100'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> dataItemColor =
            Map<String, dynamic>.from(json.decode(respose.body));
        setState(() {
          itemColorList = dataItemColor['data'];
        });
        if (nav == 'use') {
          Navigator.pop(context);
        }
        itemColorLoad = false;
        print('data_c>> $itemColorList');
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
          if (nav == 'use') {
            Navigator.pop(context);
          }
          itemColorLoad = true;
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
      print("ไม่มีข้อมูล $e");
      showProgressDialog(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
  }

  Future<void> searchSetupItemColor(searchName) async {
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
                                  searchNameColor.clear();
                                  getDataItemColorList('no');
                                  Navigator.pop(context);
                                  itemColorLoad = false;
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
                              color: const Color.fromARGB(255, 130, 196, 255),
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
                                    inputProductStock(searchName, 'false', ''),
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
                                  onPressed: () {
                                    showProgressLoading(context);
                                    getDataItemColorList('use');
                                  },
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
                          child: itemColorLoad == true
                              ? Center(
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    height: MediaQuery.of(context).size.height *
                                        0.15,
                                    child: Column(
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  'images/Nodata.png',
                                                  width: 55,
                                                  height: 55,
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'ไม่พบรายการข้อมูล',
                                                  style:
                                                      MyContant().h5NotData(),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(5),
                                          ),
                                          color: const Color.fromARGB(
                                              255, 130, 196, 255),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                              spreadRadius: 0.2,
                                              blurRadius: 2,
                                              offset: const Offset(0, 1),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  '  รหัส      ชื่อสีสินค้า',
                                                  style: MyContant()
                                                      .h4normalStyle(),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Scrollbar(
                                        child: ListView(
                                          shrinkWrap: true,
                                          children: [
                                            Column(
                                              children: [
                                                if (itemColorList
                                                    .isNotEmpty) ...[
                                                  for (var i = 0;
                                                      i < itemColorList.length;
                                                      i++) ...[
                                                    InkWell(
                                                      onTap: () async {
                                                        setState(() {
                                                          itemColor.text =
                                                              itemColorList[i]
                                                                  ['name'];
                                                          idColor.text =
                                                              itemColorList[i]
                                                                  ['id'];
                                                          idItemColor =
                                                              itemColorList[i]
                                                                  ['id'];
                                                        });
                                                        searchNameColor.clear();
                                                        getDataItemColorList(
                                                            'no');
                                                        Navigator.pop(context);
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 4,
                                                                horizontal: 8),
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  5),
                                                            ),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors
                                                                    .grey
                                                                    .withOpacity(
                                                                        0.5),
                                                                spreadRadius:
                                                                    0.2,
                                                                blurRadius: 2,
                                                                offset:
                                                                    const Offset(
                                                                        0, 1),
                                                              )
                                                            ],
                                                            color: const Color
                                                                    .fromRGBO(
                                                                176,
                                                                218,
                                                                255,
                                                                1),
                                                          ),
                                                          child: Column(
                                                            children: [
                                                              Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Container(
                                                                    color: const Color
                                                                            .fromRGBO(
                                                                        176,
                                                                        218,
                                                                        255,
                                                                        1),
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.18,
                                                                    child: Text(
                                                                      '  ${itemColorList[i]['id']}',
                                                                      style: MyContant()
                                                                          .h4normalStyle(),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child: Text(
                                                                      '${itemColorList[i]['name']}',
                                                                      overflow:
                                                                          TextOverflow
                                                                              .clip,
                                                                      style: MyContant()
                                                                          .h4normalStyle(),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              // Row(
                                                              //   children: [
                                                              //     Text(
                                                              //       'รหัส : ${itemColorList[i]['id']}',
                                                              //       style: MyContant()
                                                              //           .h4normalStyle(),
                                                              //     )
                                                              //   ],
                                                              // ),
                                                              // Row(
                                                              //   children: [
                                                              //     Text(
                                                              //       'ชื่อ : ${itemColorList[i]['name']}',
                                                              //       style: MyContant()
                                                              //           .h4normalStyle(),
                                                              //     )
                                                              //   ],
                                                              // )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ],
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
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

// ItemWarehouseList
  Future<void> getDataItemWarehouseList(nav) async {
    itemWarehouseList = [];
    try {
      var respose = await http.get(
        Uri.parse(
            '${api}setup/warehouseList?searchName=${searchNameWareHouse.text}&page=1&limit=100&branchId=$selectBranchList'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> dataItemWarehouse =
            Map<String, dynamic>.from(json.decode(respose.body));
        setState(() {
          itemWarehouseList = dataItemWarehouse['data'];
        });
        if (nav == 'use') {
          Navigator.pop(context);
        }
        itemWarehouseLoad = false;

        print('data_w>> $itemWarehouseList');
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
        print("dddddddddddddddddd");
        setState(() {
          if (nav == 'use') {
            Navigator.pop(context);
          }
          itemWarehouseLoad = true;
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
      print("ไม่มีข้อมูล $e");
      showProgressDialog(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
  }

  Future<void> searchSetupItemWarehouse(searchName) async {
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
                                  searchNameWareHouse.clear();
                                  getDataItemWarehouseList('no');
                                  Navigator.pop(context);
                                  itemWarehouseLoad = false;
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
                              color: const Color.fromARGB(255, 130, 196, 255),
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
                                    inputProductStock(searchName, 'false', ''),
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
                                  onPressed: () {
                                    showProgressLoading(context);
                                    getDataItemWarehouseList('use');
                                  },
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
                          child: itemWarehouseLoad == true
                              ? Center(
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    height: MediaQuery.of(context).size.height *
                                        0.15,
                                    child: Column(
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  'images/Nodata.png',
                                                  width: 55,
                                                  height: 55,
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'ไม่พบรายการข้อมูล',
                                                  style:
                                                      MyContant().h5NotData(),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(5),
                                          ),
                                          color: const Color.fromARGB(
                                              255, 130, 196, 255),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                              spreadRadius: 0.2,
                                              blurRadius: 2,
                                              offset: const Offset(0, 1),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  '  รหัส      ชื่อคลังสินค้า',
                                                  style: MyContant()
                                                      .h4normalStyle(),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Scrollbar(
                                        child: ListView(
                                          shrinkWrap: true,
                                          children: [
                                            Column(
                                              children: [
                                                if (itemWarehouseList
                                                    .isNotEmpty) ...[
                                                  for (var i = 0;
                                                      i <
                                                          itemWarehouseList
                                                              .length;
                                                      i++) ...[
                                                    InkWell(
                                                      onTap: () async {
                                                        setState(() {
                                                          itemWareHouse.text =
                                                              itemWarehouseList[
                                                                  i]['name'];
                                                          idWareHouse.text =
                                                              itemWarehouseList[
                                                                  i]['id'];
                                                          idItemWareHouse =
                                                              itemWarehouseList[
                                                                  i]['id'];
                                                        });
                                                        searchNameWareHouse
                                                            .clear();
                                                        getDataItemWarehouseList(
                                                            'no');
                                                        Navigator.pop(context);
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 4,
                                                                horizontal: 8),
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  5),
                                                            ),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors
                                                                    .grey
                                                                    .withOpacity(
                                                                        0.5),
                                                                spreadRadius:
                                                                    0.2,
                                                                blurRadius: 2,
                                                                offset:
                                                                    const Offset(
                                                                        0, 1),
                                                              )
                                                            ],
                                                            color: const Color
                                                                    .fromRGBO(
                                                                176,
                                                                218,
                                                                255,
                                                                1),
                                                          ),
                                                          child: Column(
                                                            children: [
                                                              Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Container(
                                                                    color: const Color
                                                                            .fromRGBO(
                                                                        176,
                                                                        218,
                                                                        255,
                                                                        1),
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.18,
                                                                    child: Text(
                                                                      '  ${itemWarehouseList[i]['id']}',
                                                                      style: MyContant()
                                                                          .h4normalStyle(),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child: Text(
                                                                      '${itemWarehouseList[i]['name']}',
                                                                      overflow:
                                                                          TextOverflow
                                                                              .clip,
                                                                      style: MyContant()
                                                                          .h4normalStyle(),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              // Row(
                                                              //   children: [
                                                              //     Text(
                                                              //       'รหัส : ${itemWarehouseList[i]['id']}',
                                                              //       style: MyContant()
                                                              //           .h4normalStyle(),
                                                              //     )
                                                              //   ],
                                                              // ),
                                                              // Row(
                                                              //   children: [
                                                              //     Text(
                                                              //       'ชื่อ : ${itemWarehouseList[i]['name']}',
                                                              //       style: MyContant()
                                                              //           .h4normalStyle(),
                                                              //     )
                                                              //   ],
                                                              // )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ],
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
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

// ItemFreeList
  Future<void> getDataItemFreeList(nav) async {
    itemFreeList = [];
    try {
      var respose = await http.get(
        Uri.parse(
            '${api}setup/itemFreeList?searchName=${searchNameItemFree.text}&page=1&limit=100&itemStatus=$itemStatus'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> dataItemFree =
            Map<String, dynamic>.from(json.decode(respose.body));
        setState(() {
          itemFreeList = dataItemFree['data'];
        });
        if (nav == 'use') {
          Navigator.pop(context);
        }
        itemFreeLoad = false;
        print('data_f>> $itemFreeList');
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
          if (nav == 'use') {
            Navigator.pop(context);
          }
          itemFreeLoad = true;
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
      print("ไม่มีข้อมูล $e");
      showProgressDialog(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
  }

  Future<void> searchSetupItemFree(searchName) async {
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
                                  searchNameItemFree.clear();
                                  getDataItemFreeList('no');
                                  Navigator.pop(context);
                                  itemFreeLoad = false;
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
                              color: const Color.fromARGB(255, 130, 196, 255),
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
                                    inputProductStock(searchName, 'false', ''),
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
                                  onPressed: () {
                                    showProgressLoading(context);
                                    getDataItemFreeList('use');
                                  },
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
                          child: itemFreeLoad == true
                              ? Center(
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    height: MediaQuery.of(context).size.height *
                                        0.15,
                                    child: Column(
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  'images/Nodata.png',
                                                  width: 55,
                                                  height: 55,
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'ไม่พบรายการข้อมูล',
                                                  style:
                                                      MyContant().h5NotData(),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(5),
                                          ),
                                          color: const Color.fromARGB(
                                              255, 130, 196, 255),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                              spreadRadius: 0.2,
                                              blurRadius: 2,
                                              offset: const Offset(0, 1),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  '  รหัส      ชื่อของแถม',
                                                  style: MyContant()
                                                      .h4normalStyle(),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Scrollbar(
                                        child: ListView(
                                          shrinkWrap: true,
                                          children: [
                                            Column(
                                              children: [
                                                if (itemFreeList
                                                    .isNotEmpty) ...[
                                                  for (var i = 0;
                                                      i < itemFreeList.length;
                                                      i++) ...[
                                                    InkWell(
                                                      onTap: () async {
                                                        setState(() {
                                                          itemFree.text =
                                                              '(${itemFreeList[i]['code']})${itemFreeList[i]['name']}';
                                                          idFree.text =
                                                              itemFreeList[i]
                                                                  ['id'];
                                                          idItemFree =
                                                              itemFreeList[i]
                                                                  ['id'];
                                                        });
                                                        searchNameItemFree
                                                            .clear();
                                                        getDataItemFreeList(
                                                            'no');
                                                        Navigator.pop(context);
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 4,
                                                                horizontal: 8),
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  5),
                                                            ),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors
                                                                    .grey
                                                                    .withOpacity(
                                                                        0.5),
                                                                spreadRadius:
                                                                    0.2,
                                                                blurRadius: 2,
                                                                offset:
                                                                    const Offset(
                                                                        0, 1),
                                                              )
                                                            ],
                                                            color: const Color
                                                                    .fromRGBO(
                                                                176,
                                                                218,
                                                                255,
                                                                1),
                                                          ),
                                                          child: Column(
                                                            children: [
                                                              Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Container(
                                                                    color: const Color
                                                                            .fromRGBO(
                                                                        176,
                                                                        218,
                                                                        255,
                                                                        1),
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.18,
                                                                    child: Text(
                                                                      '  ${itemFreeList[i]['id']}',
                                                                      style: MyContant()
                                                                          .h4normalStyle(),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child: Text(
                                                                      '(${itemFreeList[i]['code']})${itemFreeList[i]['name']}',
                                                                      overflow:
                                                                          TextOverflow
                                                                              .clip,
                                                                      style: MyContant()
                                                                          .h4normalStyle(),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              // Row(
                                                              //   children: [
                                                              //     Text(
                                                              //       'รหัส : ${itemFreeList[i]['id']}',
                                                              //       style: MyContant()
                                                              //           .h4normalStyle(),
                                                              //     )
                                                              //   ],
                                                              // ),
                                                              // Row(
                                                              //   crossAxisAlignment:
                                                              //       CrossAxisAlignment
                                                              //           .start,
                                                              //   children: [
                                                              //     Text(
                                                              //       'ชื่อ : ',
                                                              //       style: MyContant()
                                                              //           .h4normalStyle(),
                                                              //     ),
                                                              //     Expanded(
                                                              //       child: Text(
                                                              //         '${itemFreeList[i]['name']}',
                                                              //         style: MyContant()
                                                              //             .h4normalStyle(),
                                                              //         overflow:
                                                              //             TextOverflow
                                                              //                 .clip,
                                                              //       ),
                                                              //     )
                                                              //   ],
                                                              // )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ],
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
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

  Expanded inputProductStock(
    TextEditingController textEditingController,
    String textInput,
    String nameHint,
  ) {
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
          readOnly: textInput == 'true' ? true : false,
          controller: textEditingController,
          onChanged: (key) {},
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
            hintText: nameHint,
          ),
          style: MyContant().TextInputStyle(),
        ),
      ),
    );
  }

  Future<void> getIdItemList(
      keyId, TextEditingController controllerName, index) async {
    print('index>>$index');
    var nameApi = '', callBack = TextEditingController(), idlog;

    switch (index) {
      case "1":
        if (selectBranchList == '' || selectBranchList == null) {
          nameApi =
              'warehouseList?searchId=${keyId.toString()}&page=1&limit=1&branchId=01';
        } else {
          nameApi =
              'warehouseList?searchId=${keyId.toString()}&page=1&limit=1&branchId=$selectBranchList';
          callBack = itemWareHouse;
          idlog = idItemWareHouse;
        }
        break;
      case "2":
        nameApi = 'itemGroupList?searchId=${keyId.toString()}&page=1&limit=1';
        callBack = itemGroup;
        idlog = idItemGroup;
        break;
      case "3":
        nameApi =
            'itemTypeList?searchId=${keyId.toString()}&page=1&limit=1&itemGroupId=$idItemGroup&itemStatus=$itemStatus';
        callBack = itemType;
        idlog = idItemType;
        break;
      case "4":
        nameApi =
            'itemBrandList?searchId=${keyId.toString()}&page=1&limit=1&itemGroupId=$idItemGroup&itemTypeId=$idItemType&itemStatus=$itemStatus';
        callBack = itemBrand;
        idlog = idItemBrand;
        break;
      case "5":
        nameApi =
            'itemModelList?searchId=${keyId.toString()}&page=1&limit=1&itemGroupId=$idItemGroup&itemTypeId=$idItemType&itemBrandId=$idItemBrand&itemStatus=$itemStatus';
        callBack = itemModel;
        idlog = idItemModel;
        break;
      case "6":
        nameApi =
            'itemStyleList?searchId=${keyId.toString()}&page=1&limit=1&itemTypeId=$idItemType';
        callBack = itemStyle;
        idlog = idItemStyle;
        break;
      case "7":
        nameApi =
            'itemSizeList?searchId=${keyId.toString()}&page=1&limit=1&itemTypeId=$idItemType';
        callBack = itemSize;
        idlog = idItemSize;
        break;
      case "8":
        nameApi = 'itemColorList?searchId=${keyId.toString()}&page=1&limit=1';
        callBack = itemColor;
        idlog = idItemColor;
        break;
      case "9":
        nameApi =
            'itemFreeList?searchId=${keyId.toString()}&page=1&limit=1&itemStatus=$itemStatus';
        callBack = itemFree;
        idlog = idItemFree;
        break;
      default:
        break;
    }
    try {
      var respose = await http
          .get(Uri.parse('${api}setup/$nameApi'), headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': tokenId.toString(),
      });

      if (respose.statusCode == 200) {
        Map<String, dynamic> dataItem_m =
            Map<String, dynamic>.from(json.decode(respose.body));

        if (controllerName.text.isNotEmpty) {
          itemList_m = dataItem_m['data'];

          var check = itemList_m.where(
              (oldValue) => keyId.toString() == (oldValue['id'].toString()));
          if (check.isEmpty) {
            // print("null------------->$check");
            switch (index) {
              case "1":
                itemWareHouse.clear();
                idItemWareHouse = '';
                break;
              case "2":
                itemGroup.clear();
                idItemGroup = '';
                break;
              case "3":
                itemType.clear();
                idItemType = '';
                break;
              case "4":
                itemBrand.clear();
                idItemBrand = '';
                break;
              case "5":
                itemModel.clear();
                idItemModel = '';
                break;
              case "6":
                itemStyle.clear();
                idItemStyle = '';
                break;
              case "7":
                itemSize.clear();
                idItemSize = '';
                break;
              case "8":
                itemColor.clear();
                idItemColor = '';
                break;
              case "9":
                itemFree.clear();
                idItemFree = '';
                break;
              default:
                break;
            }
          } else {
            // print("success------------->$check");
            setState(() {
              callBack.text = itemList_m[0]['name'];
              if (index == '9') {
                callBack.text =
                    '(${itemList_m[0]['code']})${itemList_m[0]['name']}';
              }

              switch (index) {
                case "1":
                  idItemWareHouse = itemList_m[0]['id'];
                  break;
                case "2":
                  idItemGroup = itemList_m[0]['id'];
                  getDataItemTypeList('no');
                  break;
                case "3":
                  idItemType = itemList_m[0]['id'];
                  getDataItemBrandList('no');
                  getDataItemStyleList('no');
                  getDataItemSizeList('no');
                  break;
                case "4":
                  idItemBrand = itemList_m[0]['id'];
                  getDataItemModelList('no', 'noload');
                  break;
                case "5":
                  idItemModel = itemList_m[0]['id'];
                  break;
                case "6":
                  idItemStyle = itemList_m[0]['id'];
                  break;
                case "7":
                  idItemSize = itemList_m[0]['id'];
                  break;
                case "8":
                  idItemColor = itemList_m[0]['id'];
                  break;
                case "9":
                  idItemFree = itemList_m[0]['id'];
                  break;
                default:
                  break;
              }
            });
          }
        } else {
          setState(() {});
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
        // print("404");
        switch (index) {
          case "1":
            itemWareHouse.clear();
            idItemWareHouse = '';
            break;
          case "2":
            itemGroup.clear();
            idItemGroup = '';
            break;
          case "3":
            itemType.clear();
            idItemType = '';
            break;
          case "4":
            itemBrand.clear();
            idItemBrand = '';
            break;
          case "5":
            itemModel.clear();
            idItemModel = '';
            break;
          case "6":
            itemStyle.clear();
            idItemStyle = '';
            break;
          case "7":
            itemSize.clear();
            idItemSize = '';
            break;
          case "8":
            itemColor.clear();
            idItemColor = '';
            break;
          case "9":
            itemFree.clear();
            idItemFree = '';
            break;
          default:
            break;
        }
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
      print("ไม่มีข้อมูล $e");
      showProgressDialog(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
  }

  SizedBox inputIditem(BuildContext context,
      TextEditingController textEditingController, String index) {
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
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.14,
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8, left: 8),
        child: TextField(
          controller: textEditingController,
          keyboardType: TextInputType.number,
          onChanged: (key) async {
            switch (index) {
              case "1":
                if (selectBranchList == '' || selectBranchList == null) {
                  showProgressDialog(context, 'แจ้งเตือน', 'กรุณาเลือกสาขา');
                  textEditingController.clear();
                  itemWareHouse.clear();
                  idItemWareHouse = '';
                } else {
                  if (textEditingController.text.isNotEmpty) {
                    getIdItemList(key, textEditingController, index);
                  } else {
                    textEditingController.clear();
                    itemWareHouse.clear();
                    idItemWareHouse = '';
                  }
                }
                break;
              case "2":
                if (textEditingController.text.isNotEmpty) {
                  getIdItemList(key, textEditingController, index);
                } else {
                  textEditingController.clear();
                  itemGroup.clear();
                  idItemGroup = '';
                }
                break;
              case "3":
                if (itemGroup.text.isEmpty) {
                  showProgressDialog(context, 'แจ้งเตือน', 'กรุณาเลือกกลุ่ม');
                  textEditingController.clear();
                  itemType.clear();
                  idItemType = '';
                } else {
                  if (textEditingController.text.isNotEmpty) {
                    getIdItemList(key, textEditingController, index);
                  } else {
                    print('empty');
                    setState(() {
                      textEditingController.clear();
                      itemType.clear();
                      idItemType = '';
                    });
                  }
                }

                break;
              case "4":
                if (itemGroup.text.isEmpty && itemType.text.isEmpty) {
                  showProgressDialog(
                      context, 'แจ้งเตือน', 'กรุณาเลือกกลุ่มและประเภท');
                  textEditingController.clear();
                  itemBrand.clear();
                  idItemBrand = '';
                } else {
                  if (textEditingController.text.isNotEmpty) {
                    getIdItemList(key, textEditingController, index);
                  } else {
                    textEditingController.clear();
                    itemBrand.clear();
                    idItemBrand = '';
                  }
                }
                break;
              case "5":
                if (itemGroup.text.isEmpty &&
                    itemType.text.isEmpty &&
                    itemBrand.text.isEmpty) {
                  showProgressDialog(context, 'แจ้งเตือน',
                      'กรุณาเลือกกลุ่มสินค้า ประเภทสินค้า ยี่ห้อสินค้า');
                  textEditingController.clear();
                  itemModel.clear();
                  idItemModel = '';
                } else if (itemType.text.isEmpty && itemBrand.text.isEmpty) {
                  showProgressDialog(context, 'แจ้งเตือน',
                      'กรุณาเลือกประเภทสินค้าและยี่ห้อสินค้า');
                  textEditingController.clear();
                  itemModel.clear();
                  idItemModel = '';
                } else if (itemBrand.text.isEmpty) {
                  showProgressDialog(
                      context, 'แจ้งเตือน', 'กรุณาเลือกยี่ห้อสินค้า');
                  textEditingController.clear();
                  itemModel.clear();
                  idItemModel = '';
                } else {
                  if (textEditingController.text.isNotEmpty) {
                    getIdItemList(key, textEditingController, index);
                  } else {
                    textEditingController.clear();
                    itemModel.clear();
                    idItemModel = '';
                  }
                }
                break;
              case "6":
                if (itemType.text.isEmpty) {
                  showProgressDialog(context, 'แจ้งเตือน', 'กรุณาเลือกกลุ่ม');
                  textEditingController.clear();
                  itemStyle.clear();
                  idItemStyle = '';
                } else {
                  if (textEditingController.text.isNotEmpty) {
                    getIdItemList(key, textEditingController, index);
                  } else {
                    print('empty');
                    setState(() {
                      textEditingController.clear();
                      itemStyle.clear();
                      idItemStyle = '';
                    });
                  }
                }
                break;
              case "7":
                if (itemType.text.isEmpty) {
                  showProgressDialog(context, 'แจ้งเตือน', 'กรุณาเลือกกลุ่ม');
                  textEditingController.clear();
                  itemSize.clear();
                  idItemSize = '';
                } else {
                  if (textEditingController.text.isNotEmpty) {
                    getIdItemList(key, textEditingController, index);
                  } else {
                    print('empty');
                    setState(() {
                      textEditingController.clear();
                      itemSize.clear();
                      idItemSize = '';
                    });
                  }
                }
                break;
              case "8":
                if (textEditingController.text.isNotEmpty) {
                  getIdItemList(key, textEditingController, index);
                } else {
                  setState(() {
                    textEditingController.clear();
                    itemColor.clear();
                    idItemColor = '';
                  });
                }
                break;
              case "9":
                if (textEditingController.text.isNotEmpty) {
                  getIdItemList(key, textEditingController, index);
                } else {
                  setState(() {
                    textEditingController.clear();
                    itemFree.clear();
                    idItemFree = '';
                  });
                }
                break;
              default:
                break;
            }
          },
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
            hintText: 'รหัส',
          ),
          style: MyContant().TextInputStyle(),
        ),
      ),
    );
  }
}
