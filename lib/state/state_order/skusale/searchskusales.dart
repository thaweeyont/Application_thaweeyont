import 'package:application_thaweeyont/utility/my_constant.dart';
import 'package:application_thaweeyont/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchSKUSale extends StatefulWidget {
  const SearchSKUSale({super.key});

  @override
  State<SearchSKUSale> createState() => _SearchSKUSaleState();
}

class _SearchSKUSaleState extends State<SearchSKUSale> {
  String userId = '',
      empId = '',
      firstName = '',
      lastName = '',
      tokenId = '',
      branchId = '',
      branchAreaId = '',
      branchAreaName = '',
      appGroupId = '';
  List dropdownAreaBranch = [],
      dropdownBranchGroup = [],
      dropdownProvinbranch = [];
  String? selectBranchgrouplist, selectProvinbranchlist, selectAreaBranchlist;
  DateTime selectedDate = DateTime.now();

  TextEditingController itemGroup = TextEditingController();
  TextEditingController itemType = TextEditingController();
  TextEditingController itemBrand = TextEditingController();
  TextEditingController itemModel = TextEditingController();
  TextEditingController itemStyle = TextEditingController();
  TextEditingController itemSize = TextEditingController();
  TextEditingController itemColor = TextEditingController();
  TextEditingController startdate = TextEditingController();
  TextEditingController startdatePO = TextEditingController();
  TextEditingController enddatePO = TextEditingController();
  TextEditingController startDatesale = TextEditingController();
  TextEditingController endDatesale = TextEditingController();

  @override
  void initState() {
    super.initState();
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
      branchAreaId = preferences.getString('branchAreaId')!;
      branchAreaName = preferences.getString('branchAreaName')!;
      appGroupId = preferences.getString('appGroupId')!;
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
      appBar: CustomAppbar(title: "รายงาน SKU Sale"),
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
                            'กลุ่ม : ',
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
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => const ItemGroupList(
                              //       source: "GroupList",
                              //     ),
                              //   ),
                              // ).then((result) {
                              //   if (result != null) {
                              //     setState(() {
                              //       itemGroup.text = result['name'];
                              //       valueGrouplist = result['id'];
                              //     });
                              //   }
                              // });
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
                            'ประเภท : ',
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
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => ItemTypeList(
                              //       valueGrouplist: valueGrouplist,
                              //       source: "TypeList",
                              //     ),
                              //   ),
                              // ).then((result) {
                              //   if (result != null) {
                              //     setState(() {
                              //       itemType.text = result['name'];
                              //       valueTypelist = result['id'];
                              //     });
                              //   }
                              // });
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
                            'ยี่ห้อ : ',
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
                              if (itemGroup.text.isEmpty &&
                                  itemType.text.isEmpty) {
                                showProgressDialog(context, 'แจ้งเตือน',
                                    'กรุณาเลือกกลุ่มสินค้าและประเภทสินค้า');
                              } else if (itemType.text.isEmpty) {
                                showProgressDialog(context, 'แจ้งเตือน',
                                    'กรุณาเลือกประเภทสินค้า');
                              } else {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => ItemBrandList(
                                //       valueGrouplist: valueGrouplist,
                                //       valueTypelist: valueTypelist,
                                //       source: "BrandList",
                                //     ),
                                //   ),
                                // ).then((result) {
                                //   if (result != null) {
                                //     setState(() {
                                //       itemBrand.text = result['name'];
                                //       valueBrandlist = result['id'];
                                //     });
                                //   }
                                // });
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
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => ItemModelList(
                                //       valueGrouplist: valueGrouplist,
                                //       valueTypelist: valueTypelist,
                                //       valueBrandlist: valueBrandlist,
                                //       source: "ModelList",
                                //     ),
                                //   ),
                                // ).then((result) {
                                //   if (result != null) {
                                //     setState(() {
                                //       itemModel.text = result['name'];
                                //       valueModellist = result['id'];
                                //     });
                                //   }
                                // });
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
                            onPressed: () {
                              if (itemType.text.isEmpty) {
                                showProgressDialog(context, 'แจ้งเตือน',
                                    'กรุณาเลือกประเภทสินค้า');
                              } else {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => ItemStyleList(
                                //       valueTypelist: valueTypelist,
                                //     ),
                                //   ),
                                // ).then((result) {
                                //   if (result != null) {
                                //     setState(() {
                                //       itemStyle.text = result['name'];
                                //       valueStylelist = result['id'];
                                //     });
                                //   }
                                // });
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
                            onPressed: () {
                              if (itemType.text.isEmpty) {
                                showProgressDialog(context, 'แจ้งเตือน',
                                    'กรุณาเลือกประเภทสินค้า');
                              } else {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => ItemSizeList(
                                //       valueTypelist: valueTypelist,
                                //     ),
                                //   ),
                                // ).then((result) {
                                //   if (result != null) {
                                //     setState(() {
                                //       itemSize.text = result['name'];
                                //       valueSizelist = result['id'];
                                //     });
                                //   }
                                // });
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
                            'สี : ',
                            style: MyContant().h4normalStyle(),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        inputItemColor(),
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
                              if (itemType.text.isEmpty) {
                                showProgressDialog(
                                    context, 'แจ้งเตือน', 'กรุณาเลือกสีสินค้า');
                              } else {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => ItemSizeList(
                                //       valueTypelist: valueTypelist,
                                //     ),
                                //   ),
                                // ).then((result) {
                                //   if (result != null) {
                                //     setState(() {
                                //       itemSize.text = result['name'];
                                //       valueSizelist = result['id'];
                                //     });
                                //   }
                                // });
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
                            'สาขาจังหวัด : ',
                            style: MyContant().h4normalStyle(),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        selectProvinbranch(sizeIcon, border),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.22,
                          child: Text(
                            'กลุ่มสาขา : ',
                            style: MyContant().h4normalStyle(),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        selectBranchGroup(sizeIcon, border),
                      ],
                    ),
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
                            'วันที่ : ',
                            style: MyContant().h4normalStyle(),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        inputStartdate(),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.22,
                          child: Text(
                            'วันที่ PO : ',
                            style: MyContant().h4normalStyle(),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        inputStartdate(),
                      ],
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
                          if (selectAreaBranchlist != null &&
                              selectAreaBranchlist != "99") {
                            // // Navigator.push(
                            // //   context,
                            // //   MaterialPageRoute(
                            // //     builder: (context) => BranchSalesList(
                            // //       selectAreaBranchlist: selectAreaBranchlist,
                            // //       selectBranchlist: selectBranchlist,
                            // //       valueGrouplist: valueGrouplist,
                            // //       valueTypelist: valueTypelist,
                            // //       valueBrandlist: valueBrandlist,
                            // //       valueModellist: valueModellist,
                            // //       valueStylelist: valueStylelist,
                            // //       valueSizelist: valueSizelist,
                            // //       valueItemlist: valueItemlist,
                            // //       selectSaleTypelist: selectSaleTypelist,
                            // //       selectInterestlist: selectInterestlist,
                            // //       valueEmployeelist: valueEmployeelist,
                            // //       selectMonthlist: selectMonthlist,
                            // //       selectYearlist: selectYearlist,
                            // //       valueSupplylist: valueSupplylist,
                            // //       selectOrderBylist: selectOrderBylist,
                            // //       selectSortlist: selectSortlist,
                            // //       selectedtargetType: selectedtargetType,
                            // //       selectedSaleItems: selectedSaleItems,
                            // //     ),
                            // //   ),
                            // );
                          } else {
                            showProgressDialog(
                                context, 'แจ้งเตือน', 'กรุณาเลือกเขตสาขา');
                          }
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
                          // clearInputSelect();
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

  final _border = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.transparent, width: 0),
    borderRadius: BorderRadius.all(Radius.circular(5.0)),
  );

  final _sizeIcon = BoxConstraints(minWidth: 40, minHeight: 40);

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
                        // itemGroup.clear();
                        // valueGrouplist = null;
                        // itemType.clear();
                        // valueTypelist = null;
                        // itemBrand.clear();
                        // valueBrandlist = null;
                        // itemModel.clear();
                        // valueModellist = null;
                        // itemStyle.clear();
                        // valueStylelist = null;
                        // itemSize.clear();
                        // valueSizelist = null;
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
                        // itemType.clear();
                        // valueTypelist = null;
                        // itemBrand.clear();
                        // valueBrandlist = null;
                        // itemModel.clear();
                        // valueModellist = null;
                        // itemStyle.clear();
                        // valueStylelist = null;
                        // itemSize.clear();
                        // valueSizelist = null;
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
                        // itemBrand.clear();
                        // valueBrandlist = null;
                        // itemModel.clear();
                        // valueModellist = null;
                        // itemStyle.clear();
                        // valueStylelist = null;
                        // itemSize.clear();
                        // valueSizelist = null;
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
                        // itemModel.clear();
                        // valueModellist = null;
                        // itemStyle.clear();
                        // valueStylelist = null;
                        // itemSize.clear();
                        // valueSizelist = null;
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
                        // itemStyle.clear();
                        // valueStylelist = null;
                        // itemSize.clear();
                        // valueSizelist = null;
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
                        // valueSizelist = null;
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

  Expanded inputItemColor() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: TextField(
          controller: itemColor,
          readOnly: true,
          decoration: InputDecoration(
            suffixIcon: itemColor.text.isEmpty
                ? null
                : GestureDetector(
                    onTap: () {
                      setState(() {
                        itemColor.clear();
                        // valueColorlist = null;
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

  Expanded selectProvinbranch(sizeIcon, border) {
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
              items: dropdownProvinbranch
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
                  selectProvinbranchlist = newvalue;
                });
              },
              value: selectProvinbranchlist,
              isExpanded: true,
              underline: const SizedBox(),
              hint: Align(
                alignment: Alignment.center,
                child: Text(
                  'เลือกสาขาจังหวัด',
                  style: MyContant().TextInputSelect(),
                ),
              ),
              selectedItemBuilder: (BuildContext context) {
                return dropdownProvinbranch.map<Widget>((value) {
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

  Expanded selectBranchGroup(sizeIcon, border) {
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
              items: dropdownBranchGroup
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
                  selectBranchgrouplist = newvalue;
                });
              },
              value: selectBranchgrouplist,
              isExpanded: true,
              underline: const SizedBox(),
              hint: Align(
                alignment: Alignment.center,
                child: Text(
                  'เลือกกลุ่มสาขา',
                  style: MyContant().TextInputSelect(),
                ),
              ),
              selectedItemBuilder: (BuildContext context) {
                return dropdownBranchGroup.map<Widget>((value) {
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
                  selectAreaBranchlist = newvalue;
                });
              },
              value: selectAreaBranchlist,
              isExpanded: true,
              underline: const SizedBox(),
              hint: Align(
                alignment: Alignment.center,
                child: Text(
                  'เลือกเขตสาขา',
                  style: MyContant().TextInputSelect(),
                ),
              ),
              selectedItemBuilder: (BuildContext context) {
                return dropdownAreaBranch.map<Widget>((value) {
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

  Expanded inputStartdate() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: TextField(
          controller: startdate,
          onChanged: (keyword) {},
          readOnly: true,
          decoration: InputDecoration(
            suffixIcon: const Icon(
              Icons.calendar_today,
              color: Colors.black,
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
          style: MyContant().TextInputDate(),
          onTap: () async {
            DateTime? pickeddate = await showDatePicker(
              context: context,
              locale: const Locale("th", "TH"),
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );
            if (pickeddate != null) {
              var formattedDate = DateFormat('-MM-dd').format(pickeddate);
              var formattedyear = DateFormat('yyyy').format(pickeddate);
              var year = int.parse(formattedyear);
              final newYear =
                  [year, 543].reduce((value, element) => value + element);

              setState(() {
                startdate.text =
                    '$newYear$formattedDate'; //set output date to TextField value.
              });
            } else {}
          },
        ),
      ),
    );
  }

  Expanded inputStartdatePO() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: TextField(
          controller: startdatePO,
          onChanged: (keyword) {},
          readOnly: true,
          decoration: InputDecoration(
            suffixIcon: const Icon(
              Icons.calendar_today,
              color: Colors.black,
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
          style: MyContant().TextInputDate(),
          onTap: () async {
            DateTime? pickeddate = await showDatePicker(
              context: context,
              locale: const Locale("th", "TH"),
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );
            if (pickeddate != null) {
              var formattedDate = DateFormat('-MM-dd').format(pickeddate);
              var formattedyear = DateFormat('yyyy').format(pickeddate);
              var year = int.parse(formattedyear);
              final newYear =
                  [year, 543].reduce((value, element) => value + element);

              setState(() {
                startdate.text =
                    '$newYear$formattedDate'; //set output date to TextField value.
              });
            } else {}
          },
        ),
      ),
    );
  }
}
