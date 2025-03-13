import 'dart:convert';

import 'package:application_thaweeyont/utility/my_constant.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../api.dart';
import '../../widgets/custom_appbar.dart';
import '../authen.dart';

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
      selectedtargetType;
  late List<String> selectedSaleItems;
  List saleBranchList = [];
  Map<String, dynamic>? branchName;
  dynamic dataSaleList;
  double totalTarget = 0.0, totalAmount = 0.0, percentage = 0.0;
  List<Map<String, dynamic>> dataSale = [];

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

    // print("🔍 Request Body: ${jsonEncode(requestBody)}");
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
          saleBranchList = dataSaleList['detail'][0];

          // for (var i = 0; i < saleBranchList.length; i++) {
          //   print(saleBranchList[i]['branchName']);
          //   print(saleBranchList[i]['branchAreaName']);
          //   var dailyTotal =
          //       Map<String, dynamic>.from(saleBranchList[i]['dailyTotal']);
          //   for (var entry in dailyTotal.entries) {
          //     print('วันที่ ${entry.key} => ${entry.value}');
          //   }
          // }
          for (var i = 0; i < saleBranchList.length; i++) {
            print('data> ${saleBranchList[i]['targetTotal']}');
            totalTarget = saleBranchList.fold(
                0, (sum, item) => sum + (item['targetTotal'] ?? 0.0));
            totalAmount = saleBranchList.fold(
                0, (sum, item) => sum + (item['branchTotal'] ?? 0.0));

            // dataSale.add({
            //   "branchName": saleBranchList[i]['branchName'],
            //   "branchAreaName": saleBranchList[i]['branchAreaName'],
            //   "branchTotal": saleBranchList[i]['branchTotal'],
            //   "targetTotal": saleBranchList[i]['targetTotal'],
            //   "percent": saleBranchList[i]['percent'],
            // });
          }
          print('เป้ารวม : $totalTarget');
          print('ยอดรวมทั้งหมด : $totalAmount');
          percentage = calculatePercentage(totalTarget, totalAmount);
          print("ทำได้: ${percentage.toStringAsFixed(2)}%");
          // sumtotal();
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
          // statusLoading = true;
          // statusLoad404 = true;
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
    return Scaffold(
      appBar: const CustomAppbar(title: 'ยอดขายสินค้ารวมสาขาในแต่ละวัน'),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        behavior: HitTestBehavior.opaque,
        child: Column(
          children: [
            SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(180),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'ยอดขายสินค้าเดือน มกราคม 2568',
                            style: MyContant().h4normalStyle(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(180),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'ผู้จำหน่าย : ทั้งหมด',
                            style: MyContant().h4normalStyle(),
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
              padding:
                  const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 10),
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
                      const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
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
                              'ช่องทางการขาย : ขายหน้าร้าน, ขาย Event, ขาย Expo',
                              style: MyContant().h4normalStyle(),
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
            Expanded(
              child: ListView.builder(
                padding:
                    const EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 8),
                itemCount: saleBranchList.length + 2, // จำนวนรายการ
                itemBuilder: (context, index) {
                  if (index == saleBranchList.length) {
                    // ✅ แสดง Container ยอดรวมที่รายการสุดท้าย
                    return Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
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
                          padding: const EdgeInsets.symmetric(
                              vertical: 2, horizontal: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(180),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'เป้ารวม : ${formatter.format(totalTarget)}',
                                    style: MyContant().h4normalStyle(),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'ยอดรวม : ${formatter.format(totalAmount)}',
                                    style: MyContant().h4normalStyle(),
                                  ),
                                  Text(
                                    'ทำได้ : ${percentage.toStringAsFixed(2)} %',
                                    style: MyContant().h4normalStyle(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else if (index == saleBranchList.length + 1) {
                    // ✅ Container ใหม่ (Container 2)
                    return Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 50),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
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
                          padding: const EdgeInsets.symmetric(
                              vertical: 2, horizontal: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(180),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'ดูยอดขายสินค้ารวมทุกสาขา เขตสาขา 4',
                                    style: MyContant().h4normalStyle(),
                                    textAlign: TextAlign.start,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  final data = saleBranchList[index];
                  return GestureDetector(
                    onTap: () {
                      print(
                          "ตำแหน่งที่: $index | ข้อมูล: ${saleBranchList[index]}");
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
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
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'เขตสาขา : ${data["branchAreaName"]}',
                                  style: MyContant().h4normalStyle(),
                                ),
                                Text(
                                  'สาขา : ${data["branchName"]}',
                                  style: MyContant().h4normalStyle(),
                                ),
                              ],
                            ),
                            const SizedBox(height: 3),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 8),
                              decoration: BoxDecoration(
                                color: Colors.white.withAlpha(180),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'เป้า : ${formatter.format(data["targetTotal"])}',
                                        style: MyContant().h4normalStyle(),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'ยอดรวม : ${formatter.format(data["branchTotal"])}',
                                        style: MyContant().h4normalStyle(),
                                      ),
                                      Text(
                                        'ทำได้ : ${data["percent"]} %',
                                        style: MyContant().h4normalStyle(),
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
            // Expanded(
            //   child: ListView(
            //     shrinkWrap: true,
            //     children: [
            //       Padding(
            //         padding: const EdgeInsets.all(8.0),
            //         child: Container(
            //           padding: const EdgeInsets.all(8),
            //           decoration: BoxDecoration(
            //             borderRadius:
            //                 const BorderRadius.all(Radius.circular(10)),
            //             boxShadow: [
            //               BoxShadow(
            //                 color: Colors.grey.withAlpha(130),
            //                 spreadRadius: 0.2,
            //                 blurRadius: 2,
            //                 offset: const Offset(0, 1),
            //               )
            //             ],
            //             color: const Color.fromRGBO(239, 191, 239, 1),
            //           ),
            //           child: Column(
            //             children: [
            //               Row(
            //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                 children: [
            //                   Text(
            //                     'เขตสาขา : 4',
            //                     style: MyContant().h4normalStyle(),
            //                     textAlign: TextAlign.left,
            //                   ),
            //                   Text(
            //                     'สาขา : NG',
            //                     style: MyContant().h4normalStyle(),
            //                     textAlign: TextAlign.left,
            //                   ),
            //                 ],
            //               ),
            //               SizedBox(height: 3),
            //               Container(
            //                 padding: const EdgeInsets.symmetric(
            //                     vertical: 4, horizontal: 8),
            //                 decoration: BoxDecoration(
            //                   color: Colors.white.withAlpha(180),
            //                   borderRadius: BorderRadius.circular(10),
            //                 ),
            //                 child: Column(
            //                   children: [
            //                     Row(
            //                       children: [
            //                         Text(
            //                           'เป้า : 1,000,000',
            //                           style: MyContant().h4normalStyle(),
            //                           textAlign: TextAlign.left,
            //                         ),
            //                       ],
            //                     ),
            //                     Row(
            //                       mainAxisAlignment:
            //                           MainAxisAlignment.spaceBetween,
            //                       children: [
            //                         Text(
            //                           'ยอดรวม : 1,007,461.69',
            //                           style: MyContant().h4normalStyle(),
            //                           textAlign: TextAlign.left,
            //                         ),
            //                         Text(
            //                           'ทำได้ : 100.75 %',
            //                           style: MyContant().h4normalStyle(),
            //                         ),
            //                       ],
            //                     ),
            //                   ],
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
