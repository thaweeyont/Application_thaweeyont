import 'dart:convert';

import 'package:application_thaweeyont/state/state_order/detailbrancharea_all.dart';
import 'package:application_thaweeyont/utility/my_constant.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_gifs/loading_gifs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../api.dart';
import '../../widgets/custom_appbar.dart';
import '../authen.dart';
import 'branchsalesdetail.dart';

class BranchSalesList extends StatefulWidget {
  final String? selectAreaBranchlist,
      selectBranchlist,
      valueGrouplist,
      valueTypelist,
      valueBrandlist,
      valueModellist,
      valueStylelist,
      valueSizelist,
      valueItemlist,
      selectSaleTypelist,
      selectInterestlist,
      valueEmployeelist,
      selectMonthlist,
      selectYearlist,
      valueSupplylist,
      selectOrderBylist,
      selectSortlist,
      selectedtargetType;
  final List<String> selectedSaleItems;
  const BranchSalesList({
    super.key,
    this.selectAreaBranchlist,
    this.selectBranchlist,
    this.valueGrouplist,
    this.valueTypelist,
    this.valueBrandlist,
    this.valueModellist,
    this.valueStylelist,
    this.valueSizelist,
    this.valueItemlist,
    this.selectSaleTypelist,
    this.selectInterestlist,
    this.valueEmployeelist,
    this.selectMonthlist,
    this.selectYearlist,
    this.valueSupplylist,
    this.selectOrderBylist,
    this.selectSortlist,
    this.selectedtargetType,
    required this.selectedSaleItems,
  });

  @override
  State<BranchSalesList> createState() => _BranchSalesListState();
}

class _BranchSalesListState extends State<BranchSalesList> {
  String userId = '', empId = '', firstName = '', lastName = '', tokenId = '';
  String? selectAreaBranchlist,
      selectBranchlist,
      valueGrouplist,
      valueTypelist,
      valueBrandlist,
      valueModellist,
      valueStylelist,
      valueSizelist,
      valueItemlist,
      selectSaleTypelist,
      selectInterestlist,
      valueEmployeelist,
      selectMonthlist,
      selectYearlist,
      valueSupplylist,
      selectOrderBylist,
      selectSortlist,
      selectedtargetType,
      areaBranchName;
  late List<String> selectedSaleItems;
  List saleBranchList = [];
  Map<String, dynamic>? branchName;
  dynamic dataSaleList, saleBranchHead;
  double totalTarget = 0.0, totalAmount = 0.0, percentage = 0.0;
  List<Map<String, dynamic>> dataSale = [];
  bool isScrolled = false;
  bool statusLoading = false, statusLoad404 = false;
  final GlobalKey _containerKey = GlobalKey();
  double _containerHeight = 0; // เก็บค่าความสูง

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
    });

    if (mounted) {
      checkValueparameter();
    }
  }

  void checkValueparameter() {
    setState(() {
      widget.selectAreaBranchlist == null || widget.selectAreaBranchlist == "99"
          ? selectAreaBranchlist = ""
          : selectAreaBranchlist = widget.selectAreaBranchlist;
      widget.selectBranchlist == null || widget.selectBranchlist == "99"
          ? selectBranchlist = ""
          : selectBranchlist = widget.selectBranchlist;
      valueGrouplist = widget.valueGrouplist ?? '';
      valueTypelist = widget.valueTypelist ?? '';
      valueBrandlist = widget.valueBrandlist ?? '';
      valueModellist = widget.valueModellist ?? '';
      valueStylelist = widget.valueStylelist ?? '';
      valueSizelist = widget.valueSizelist ?? '';
      valueItemlist = widget.valueItemlist ?? '';
      widget.selectSaleTypelist == null || widget.selectSaleTypelist == "99"
          ? selectSaleTypelist = ""
          : selectSaleTypelist = widget.selectSaleTypelist;
      selectedSaleItems = widget.selectedSaleItems;
      widget.selectInterestlist == null || widget.selectInterestlist == "99"
          ? selectInterestlist = ""
          : selectInterestlist = widget.selectInterestlist;
      valueEmployeelist = widget.valueEmployeelist ?? '';
      selectMonthlist = widget.selectMonthlist ?? '';
      selectYearlist = widget.selectYearlist ?? '';
      valueSupplylist = widget.valueSupplylist ?? '';
      selectOrderBylist = widget.selectOrderBylist ?? '';
      selectSortlist = widget.selectSortlist ?? '';
      selectedtargetType = widget.selectedtargetType ?? '';
      getSelectSaleBranch();
    });
  }

  Future<void> getSelectSaleBranch() async {
    print("branchArea: ${selectAreaBranchlist.toString()}");
    print("branchId: $selectBranchlist");
    print("itemGroupId: $valueGrouplist");
    print("itemTypeId: $valueTypelist");
    print("itemBrandId: $valueBrandlist");
    print("itemModel: $valueModellist");
    print("itemStyleId: $valueStylelist");
    print("itemSizeId: $valueSizelist");
    print("itemId: $valueItemlist");
    print("saleTypeId: $selectSaleTypelist");
    print("channelSaleId: $selectedSaleItems");
    print("interestType: $selectInterestlist");
    print("saleId: $valueEmployeelist");
    print("monthId: $selectMonthlist");
    print("yearId: $selectYearlist");
    print("supplyId: $valueSupplylist");
    print("orderBy: $selectOrderBylist");
    print("orderSort: $selectSortlist");
    print("targetType: $selectedtargetType");

    try {
      var respose = await http.post(
        Uri.parse('${api}sale/saleBranch'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
        body: jsonEncode(<String, dynamic>{
          'branchArea': selectAreaBranchlist.toString(),
          'branchId': selectBranchlist.toString(),
          'itemGroupId': valueGrouplist.toString(),
          'itemTypeId': valueTypelist.toString(),
          'itemBrandId': valueBrandlist.toString(),
          'itemModel': valueModellist.toString(),
          'itemStyleId': valueStylelist.toString(),
          'itemSizeId': valueSizelist.toString(),
          'itemId': valueItemlist.toString(),
          'saleTypeId': selectSaleTypelist.toString(),
          'channelSaleId': selectedSaleItems.isNotEmpty
              ? selectedSaleItems.map((item) => item.toString()).toList()
              : [],
          'interestType': selectInterestlist.toString(),
          'saleId': valueEmployeelist.toString(),
          'monthId': selectMonthlist.toString(),
          'yearId': selectYearlist.toString(),
          'supplyId': valueSupplylist.toString(),
          'orderBy': selectOrderBylist.toString(),
          'orderSort': selectSortlist.toString(),
          'targetType': selectedtargetType.toString()
        }),
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> dataSaleBranch =
            Map<String, dynamic>.from(json.decode(respose.body));

        setState(() {
          dataSaleList = dataSaleBranch['data'];
          saleBranchHead = dataSaleList['head'];
          print('data>> $dataSaleList');
          saleBranchList = dataSaleList['detail'][0];
          areaBranchName = (saleBranchList[0]['branchAreaName'] as String)
              .replaceAll("เขต ", "เขตสาขา ");
          for (var i = 0; i < saleBranchList.length; i++) {
            totalTarget = saleBranchList.fold(
                0, (sum, item) => sum + (item['targetTotal'] ?? 0.0));
            totalAmount = saleBranchList.fold(
                0, (sum, item) => sum + (item['branchTotal'] ?? 0.0));
          }

          percentage = calculatePercentage(totalTarget, totalAmount);
          statusLoading = true;
        });
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
      print("ไม่มีข้อมูล $e");
      showProgressDialog(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
  }

  var formatter = NumberFormat('#,##0.00');

  void sumtotal() {
    totalTarget = saleBranchList
        .map((item) => double.parse(item["targetTotal"].replaceAll(",", "")))
        .reduce((a, b) => a + b);
    totalAmount = saleBranchList
        .map((item) => double.parse(item["branchTotal"].replaceAll(",", "")))
        .reduce((a, b) => a + b);

    print("ยอดรวมเป้า: $totalTarget");
    print("ยอดรวมยอดขาย: $totalAmount");
    double percentage = calculatePercentage(totalTarget, totalAmount);

    print("ทำได้: ${percentage.toStringAsFixed(2)}%");
  }

  double calculatePercentage(double totalTarget, double totalAmount) {
    if (totalTarget == 0) return 0; // ป้องกันการหารด้วย 0
    return (totalAmount / totalTarget) * 100;
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _getContainerHeight());

    return Scaffold(
      appBar: const CustomAppbar(title: 'ยอดขายสินค้ารวมสาขาในแต่ละวัน'),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        behavior: HitTestBehavior.opaque,
        child: statusLoading == false
            ? Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 24, 24, 24).withAlpha(230),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
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
                                color: const Color.fromARGB(255, 158, 158, 158),
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
                : Stack(
                    children: [
                      Positioned.fill(
                        child: Column(
                          children: [
                            SizedBox(
                                height:
                                    _containerHeight), // ✅ ปรับขนาดอัตโนมัติ
                            Expanded(
                              child: NotificationListener<ScrollNotification>(
                                onNotification: (scrollInfo) {
                                  setState(() {
                                    isScrolled = scrollInfo.metrics.pixels > 0;
                                  });
                                  return true;
                                },
                                child: ListView.builder(
                                  padding: const EdgeInsets.only(
                                      left: 8, right: 8, top: 2, bottom: 8),
                                  itemCount:
                                      saleBranchList.length + 2, // จำนวนรายการ
                                  itemBuilder: (context, index) {
                                    if (index == saleBranchList.length) {
                                      // ✅ แสดง Container ยอดรวมที่รายการสุดท้าย
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10)),
                                            boxShadow: [
                                              BoxShadow(
                                                color:
                                                    Colors.grey.withAlpha(130),
                                                spreadRadius: 0.2,
                                                blurRadius: 2,
                                                offset: const Offset(0, 1),
                                              )
                                            ],
                                            color: const Color.fromRGBO(
                                                239, 191, 239, 1),
                                          ),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 2, horizontal: 8),
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.white.withAlpha(180),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      'เป้ารวม : ${formatter.format(totalTarget)}',
                                                      style: MyContant()
                                                          .h4normalStyle(),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      'ยอดรวม : ${formatter.format(totalAmount)}',
                                                      style: MyContant()
                                                          .h4normalStyle(),
                                                    ),
                                                    Text(
                                                      'ทำได้ : ${percentage.toStringAsFixed(2)} %',
                                                      style: MyContant()
                                                          .h4normalStyle(),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    } else if (index ==
                                        saleBranchList.length + 1) {
                                      // ✅ Container ใหม่ (Container 2)
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  DetailBranchAreaAll(
                                                      dataSaleList:
                                                          dataSaleList),
                                            ),
                                          );
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 8, bottom: 50),
                                          child: Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(10),
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withAlpha(130),
                                                  spreadRadius: 0.2,
                                                  blurRadius: 2,
                                                  offset: const Offset(0, 1),
                                                )
                                              ],
                                              color: const Color.fromRGBO(
                                                  239, 191, 239, 1),
                                            ),
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8),
                                              decoration: BoxDecoration(
                                                color:
                                                    Colors.white.withAlpha(180),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      SizedBox(
                                                        width: 30,
                                                        child: ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    vertical:
                                                                        8),
                                                            shape:
                                                                const CircleBorder(),
                                                            backgroundColor:
                                                                const Color
                                                                    .fromARGB(
                                                                    255,
                                                                    223,
                                                                    132,
                                                                    223),
                                                          ),
                                                          onPressed: () {},
                                                          child: const Icon(
                                                            Icons.search,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(width: 5),
                                                      Text(
                                                        'ดูยอดขายสินค้ารวมทุกสาขา $areaBranchName',
                                                        style: MyContant()
                                                            .h4normalStyle(),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                    final data = saleBranchList[index];
                                    return GestureDetector(
                                      onTap: () {
                                        print(
                                            "ตำแหน่งที่: $index | ข้อมูล: ${saleBranchList[index]} | หัวข้อ : $saleBranchHead");
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                BranchSalesDetail(
                                              saleBranchList:
                                                  saleBranchList[index],
                                              saleBranchHead: saleBranchHead,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8.0),
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            boxShadow: [
                                              BoxShadow(
                                                color:
                                                    Colors.grey.withAlpha(130),
                                                spreadRadius: 0.2,
                                                blurRadius: 2,
                                                offset: const Offset(0, 1),
                                              )
                                            ],
                                            color: const Color.fromRGBO(
                                                239, 191, 239, 1),
                                          ),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'เขตสาขา : ${data["branchAreaName"]}',
                                                    style: MyContant()
                                                        .h4normalStyle(),
                                                  ),
                                                  Text(
                                                    'สาขา : ${data["branchName"]}',
                                                    style: MyContant()
                                                        .h4normalStyle(),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 3),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 5,
                                                        horizontal: 8),
                                                decoration: BoxDecoration(
                                                  color: Colors.white
                                                      .withAlpha(180),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'เป้า : ${formatter.format(data["targetTotal"])}',
                                                          style: MyContant()
                                                              .h4normalStyle(),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          'ยอดรวม : ${formatter.format(data["branchTotal"])}',
                                                          style: MyContant()
                                                              .h4normalStyle(),
                                                        ),
                                                        Text(
                                                          'ทำได้ : ${data?["percent"] ?? '-'} %',
                                                          style: MyContant()
                                                              .h4normalStyle(),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: AnimatedContainer(
                          key: _containerKey, // ✅ ใส่ key เพื่อนำไปวัดขนาด
                          duration: Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: isScrolled
                                ? [
                                    BoxShadow(
                                      color: Colors.black.withAlpha(130),
                                      blurRadius: 12,
                                      spreadRadius: 5,
                                      offset: Offset(0, 5),
                                    )
                                  ]
                                : [],
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8, right: 8, top: 8, bottom: 4),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
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
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withAlpha(180),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'ยอดขายสินค้าเดือน ${saleBranchHead?['month'] ?? '-'} พ.ศ. ${saleBranchHead?['year'] ?? '-'}',
                                              style:
                                                  MyContant().h4normalStyle(),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
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
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withAlpha(180),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              'ผู้จำหน่าย : ${saleBranchHead?['supplyname'] ?? '-'}',
                                              style:
                                                  MyContant().h4normalStyle(),
                                              textAlign: TextAlign.left,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8, right: 8, top: 4, bottom: 10),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
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
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withAlpha(180),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                'ช่องทางการขาย : ${saleBranchHead?['channelName'] ?? '-'}',
                                                style:
                                                    MyContant().h4normalStyle(),
                                                textAlign: TextAlign.left,
                                                overflow: TextOverflow.clip,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
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

  void _getContainerHeight() {
    final RenderBox? renderBox =
        _containerKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      double newHeight = renderBox.size.height;
      if (_containerHeight != newHeight) {
        setState(() {
          _containerHeight = newHeight;
          print('สูง>>$_containerHeight');
        });
      }
    }
  }
}
