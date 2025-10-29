import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_gifs/loading_gifs.dart';

import '../../../utility/my_constant.dart';
import '../../../widgets/custom_appbar.dart';

class DetailBranchAreaAll extends StatefulWidget {
  final dynamic dataSaleList, areaBranchName;
  const DetailBranchAreaAll(
      {super.key, this.dataSaleList, this.areaBranchName});

  @override
  State<DetailBranchAreaAll> createState() => _DetailBranchAreaAllState();
}

class _DetailBranchAreaAllState extends State<DetailBranchAreaAll> {
  List<Map<String, dynamic>>? dailyList;
  List<dynamic>? dailyTotalList;
  Map<String, double> totalDaily = {};
  Map<String, double> dailySum = {};
  List<Map<String, dynamic>> flattenedData = [];
  double totalSum = 0, totalQty = 0;
  var dataSaleHead, dataBranch;
  bool statusLoading = false, statusLoad404 = false;
  var formatter = NumberFormat('#,##0.00');
  var formatterAmount = NumberFormat('#,##0');

  @override
  void initState() {
    super.initState();
    buildDataSaleList();
  }

  void buildDataSaleList() {
    Map<String, dynamic> dailyTotalMap =
        Map<String, dynamic>.from(widget.dataSaleList);

    dataSaleHead = dailyTotalMap['head'];
    dailyTotalList = dailyTotalMap['detail'];
    statusLoading = true;
    // ตรวจสอบว่า dailyTotalList ไม่เป็น null และมีข้อมูล
    if (dailyTotalList != null && dailyTotalList!.isNotEmpty) {
      // ดึงค่าออกจากชั้นแรกก่อน
      List<Map<String, dynamic>> extractedList =
          List<Map<String, dynamic>>.from(dailyTotalList![0]);

      for (var element in extractedList) {
        Map<String, dynamic> branchData = Map<String, dynamic>.from(element);
        branchData['dailyTotal'] =
            Map<String, dynamic>.from(branchData['dailyTotal']);
        flattenedData.add(branchData);
      }
    }
    sumDailySales(flattenedData);
    sumBranchTotal();
    sumqtyTotal();
    // print('flattenedData: $flattenedData');
    // print('flattenedDataType: ${flattenedData.runtimeType}');
    // if (flattenedData.isNotEmpty) {
    //   for (var branch in flattenedData) {
    //     print('📍 สาขา: ${branch["branchName"]}');
    //     print('📌 เขต: ${branch["branchAreaName"]}');
    //     print('🎯 เป้ายอดรวม: ${branch["targetTotal"]}');
    //     print('💰 ยอดรวม: ${branch["branchTotal"]}');
    //     print('📊 % บรรลุเป้า: ${branch["percent"]}%');
    //     print('📅 ยอดขายรายวัน:');

    //     // แสดงยอดขายรายวันแบบเรียงวัน
    //     Map<String, dynamic> dailyTotal = branch["dailyTotal"];
    //     dailyTotal.forEach((day, amount) {
    //       print('   📆 วันที่ $day : $amount');
    //     });

    //     print('-----------------------------------');
    //   }
    // }
  }

  void sumDailySales(List<dynamic> flattenedData) {
    for (var branch in flattenedData) {
      Map<String, dynamic> dailyTotal = branch['dailyTotal'];

      dailyTotal.forEach((date, amount) {
        dailySum[date] = (dailySum[date] ?? 0) + amount;
      });
    }

    setState(() {
      totalDaily = dailySum;
    });
  }

  double sumBranchTotal() {
    for (var branch in flattenedData) {
      if (branch.containsKey("branchTotal") && branch["branchTotal"] is num) {
        totalSum += branch["branchTotal"];
      }
    }
    return totalSum;
  }

  double sumqtyTotal() {
    for (var branch in flattenedData) {
      if (branch.containsKey("qtyTotal") && branch["qtyTotal"] is num) {
        totalQty += branch["qtyTotal"];
      }
    }
    // print('totalQty: $totalQty');
    return totalQty;
  }

  @override
  Widget build(BuildContext context) {
    final dateList = flattenedData.isNotEmpty
        ? (flattenedData.first['dailyTotal']?.keys.toList() ?? [])
        : [];
    return Scaffold(
      appBar: const CustomAppbar(title: 'ยอดขายสินค้ารวมสาขาในแต่ละวัน'),
      body: statusLoading == false
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
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: const EdgeInsets.all(4),
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
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(180),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'เดือน ${dataSaleHead['month']} พ.ศ. ${dataSaleHead['year']}   ${widget.areaBranchName}',
                                    style: MyContant().h4normalStyle(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          Row(
                            children: [
                              // ✅ Column แรก: ชื่อสาขา (Fix แนวตั้ง)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  buildTextStyle(
                                    'วันที่',
                                    MediaQuery.of(context).size.width * 0.24,
                                    const EdgeInsets.only(
                                        top: 4, bottom: 4, right: 5, left: 8),
                                    MainAxisAlignment.center,
                                  ),
                                  for (var branch in flattenedData)
                                    buildTextStyle(
                                      branch['branchShortName'] ?? '-',
                                      MediaQuery.of(context).size.width * 0.24,
                                      const EdgeInsets.only(
                                          top: 4, bottom: 4, right: 5, left: 8),
                                      MainAxisAlignment.center,
                                    ),
                                  buildTextStyle(
                                    'รวม',
                                    MediaQuery.of(context).size.width * 0.24,
                                    const EdgeInsets.only(
                                        top: 4, bottom: 4, right: 5, left: 8),
                                    MainAxisAlignment.center,
                                  ),
                                ],
                              ),
                              // ✅ ส่วน Scroll แนวนอน: วันที่ + ข้อมูลยอดขาย
                              Expanded(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // ✅ หัวตาราง: วันที่
                                      Row(
                                        children: [
                                          for (var date in dateList)
                                            buildTextStyle(
                                              date,
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.35,
                                              const EdgeInsets.symmetric(
                                                  vertical: 4, horizontal: 3),
                                              MainAxisAlignment.center,
                                            ),
                                          // ✅ หัว "จำนวนรวม"
                                          buildTextStyle(
                                            'จำนวนรวม',
                                            MediaQuery.of(context).size.width *
                                                0.28,
                                            const EdgeInsets.symmetric(
                                                vertical: 4, horizontal: 3),
                                            MainAxisAlignment.center,
                                          ),
                                          // ✅ หัว "รวม"
                                          buildTextStyle(
                                            'รวม',
                                            MediaQuery.of(context).size.width *
                                                0.35,
                                            const EdgeInsets.only(
                                              top: 4,
                                              bottom: 4,
                                              right: 8,
                                              left: 3,
                                            ),
                                            MainAxisAlignment.center,
                                          ),
                                        ],
                                      ),
                                      // ✅ ข้อมูลยอดขายแต่ละวัน
                                      for (var branch in flattenedData)
                                        Row(
                                          children: [
                                            for (var date in dateList)
                                              buildTextStyle(
                                                formatter.format(
                                                  branch['dailyTotal']?[date] ??
                                                      0,
                                                ),
                                                MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.35,
                                                const EdgeInsets.symmetric(
                                                    vertical: 4, horizontal: 3),
                                                MainAxisAlignment.end,
                                              ),

                                            // ✅ คอลัมน์ "จำนวนรวม"
                                            buildTextStyle(
                                              formatterAmount.format(
                                                branch['qtyTotal'] ?? 0,
                                              ),
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.28,
                                              const EdgeInsets.symmetric(
                                                  vertical: 4, horizontal: 3),
                                              MainAxisAlignment.center,
                                            ),
                                            // ✅ คอลัมน์ "รวม"
                                            buildTextStyle(
                                              formatter.format(
                                                  branch['branchTotal'] ?? 0),
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.35,
                                              const EdgeInsets.only(
                                                top: 4,
                                                bottom: 4,
                                                right: 8,
                                                left: 3,
                                              ),
                                              MainAxisAlignment.end,
                                            ),
                                          ],
                                        ),

                                      Row(
                                        children: [
                                          // Loop รายวัน
                                          for (var date in dateList)
                                            buildTextStyle(
                                              formatter.format(
                                                totalDaily[date] ?? 0,
                                              ),
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.35,
                                              const EdgeInsets.symmetric(
                                                  vertical: 4, horizontal: 3),
                                              MainAxisAlignment.end,
                                            ),
                                          // ✅ รวมจำนวนทั้งหมด
                                          buildTextStyle(
                                            formatterAmount.format(
                                              totalQty,
                                            ),
                                            MediaQuery.of(context).size.width *
                                                0.28,
                                            const EdgeInsets.symmetric(
                                                vertical: 4, horizontal: 3),
                                            MainAxisAlignment.center,
                                          ),
                                          // ✅ รวมยอดทั้งหมด
                                          buildTextStyle(
                                            formatter.format(totalSum),
                                            MediaQuery.of(context).size.width *
                                                0.35,
                                            const EdgeInsets.only(
                                              top: 4,
                                              bottom: 4,
                                              right: 8,
                                              left: 3,
                                            ),
                                            MainAxisAlignment.end,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    )
                    // Expanded(
                    //   child: ListView(
                    //     shrinkWrap: true,
                    //     children: [
                    //       SingleChildScrollView(
                    //         scrollDirection: Axis.horizontal,
                    //         child: Column(
                    //           children: [
                    //             // แสดงวันที่จาก keys ของ branch["dailyTotal"]
                    //             Row(
                    //               children: [
                    //                 // คอลัมน์แรกที่แสดงชื่อสาขา
                    //                 Padding(
                    //                   padding: const EdgeInsets.symmetric(
                    //                       vertical: 4, horizontal: 8),
                    //                   child: Container(
                    //                     width:
                    //                         MediaQuery.of(context).size.width *
                    //                             0.22,
                    //                     padding: const EdgeInsets.all(6),
                    //                     decoration: BoxDecoration(
                    //                       borderRadius:
                    //                           BorderRadius.circular(10),
                    //                       boxShadow: [
                    //                         BoxShadow(
                    //                           color: Colors.grey.withAlpha(130),
                    //                           spreadRadius: 0.2,
                    //                           blurRadius: 2,
                    //                           offset: const Offset(0, 1),
                    //                         ),
                    //                       ],
                    //                       color: const Color.fromRGBO(
                    //                           239, 191, 239, 1),
                    //                     ),
                    //                     child: Container(
                    //                       padding: const EdgeInsets.symmetric(
                    //                           vertical: 8, horizontal: 8),
                    //                       decoration: BoxDecoration(
                    //                         color: Colors.white.withAlpha(180),
                    //                         borderRadius:
                    //                             BorderRadius.circular(8),
                    //                       ),
                    //                       child: Column(
                    //                         children: [
                    //                           Row(
                    //                             mainAxisAlignment:
                    //                                 MainAxisAlignment.center,
                    //                             children: [
                    //                               Text(
                    //                                 'วันที่', // ส่วนนี้คือส่วนหัวของคอลัมน์แรก
                    //                                 style: MyContant()
                    //                                     .h4normalStyle(),
                    //                               ),
                    //                             ],
                    //                           ),
                    //                         ],
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 ),
                    //                 // แสดงวันที่จาก keys ของ branch["dailyTotal"]
                    //                 for (var date in flattenedData.isNotEmpty &&
                    //                         flattenedData[0]["dailyTotal"] !=
                    //                             null
                    //                     ? flattenedData[0]["dailyTotal"]
                    //                             ?.keys ??
                    //                         []
                    //                     : [])
                    //                   Padding(
                    //                     padding: const EdgeInsets.only(
                    //                         top: 4, bottom: 4, right: 8),
                    //                     child: Container(
                    //                       width: MediaQuery.of(context)
                    //                               .size
                    //                               .width *
                    //                           0.38,
                    //                       padding: const EdgeInsets.all(6),
                    //                       decoration: BoxDecoration(
                    //                         borderRadius:
                    //                             BorderRadius.circular(10),
                    //                         boxShadow: [
                    //                           BoxShadow(
                    //                             color:
                    //                                 Colors.grey.withAlpha(130),
                    //                             spreadRadius: 0.2,
                    //                             blurRadius: 2,
                    //                             offset: const Offset(0, 1),
                    //                           ),
                    //                         ],
                    //                         color: const Color.fromRGBO(
                    //                             239, 191, 239, 1),
                    //                       ),
                    //                       child: Container(
                    //                         padding: const EdgeInsets.symmetric(
                    //                             vertical: 8, horizontal: 8),
                    //                         decoration: BoxDecoration(
                    //                           color:
                    //                               Colors.white.withAlpha(180),
                    //                           borderRadius:
                    //                               BorderRadius.circular(8),
                    //                         ),
                    //                         child: Column(
                    //                           children: [
                    //                             Row(
                    //                               mainAxisAlignment:
                    //                                   MainAxisAlignment.center,
                    //                               children: [
                    //                                 Text(
                    //                                   date.toString(), // แสดงวันที่จาก keys ของ dailyTotal
                    //                                   style: MyContant()
                    //                                       .h4normalStyle(),
                    //                                 ),
                    //                               ],
                    //                             ),
                    //                           ],
                    //                         ),
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 Padding(
                    //                   padding: const EdgeInsets.only(
                    //                       top: 4, bottom: 4, right: 8),
                    //                   child: Container(
                    //                     width:
                    //                         MediaQuery.of(context).size.width *
                    //                             0.38,
                    //                     padding: const EdgeInsets.all(6),
                    //                     decoration: BoxDecoration(
                    //                       borderRadius:
                    //                           BorderRadius.circular(10),
                    //                       boxShadow: [
                    //                         BoxShadow(
                    //                           color: Colors.grey.withAlpha(130),
                    //                           spreadRadius: 0.2,
                    //                           blurRadius: 2,
                    //                           offset: const Offset(0, 1),
                    //                         ),
                    //                       ],
                    //                       color: const Color.fromRGBO(
                    //                           239, 191, 239, 1),
                    //                     ),
                    //                     child: Container(
                    //                       padding: const EdgeInsets.symmetric(
                    //                           vertical: 8, horizontal: 8),
                    //                       decoration: BoxDecoration(
                    //                         color: Colors.white.withAlpha(180),
                    //                         borderRadius:
                    //                             BorderRadius.circular(8),
                    //                       ),
                    //                       child: Column(
                    //                         children: [
                    //                           Row(
                    //                             mainAxisAlignment:
                    //                                 MainAxisAlignment.center,
                    //                             children: [
                    //                               Text(
                    //                                 "จำนวนรวม",
                    //                                 style: MyContant()
                    //                                     .h4normalStyle(),
                    //                               ),
                    //                             ],
                    //                           ),
                    //                         ],
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 ),
                    //                 // 📌 คอลัมน์สุดท้าย: เพิ่มหัวข้อ "รวม"
                    //                 Padding(
                    //                   padding: const EdgeInsets.only(
                    //                       top: 4, bottom: 4, right: 8),
                    //                   child: Container(
                    //                     width:
                    //                         MediaQuery.of(context).size.width *
                    //                             0.38,
                    //                     padding: const EdgeInsets.all(6),
                    //                     decoration: BoxDecoration(
                    //                       borderRadius:
                    //                           BorderRadius.circular(10),
                    //                       boxShadow: [
                    //                         BoxShadow(
                    //                           color: Colors.grey.withAlpha(130),
                    //                           spreadRadius: 0.2,
                    //                           blurRadius: 2,
                    //                           offset: const Offset(0, 1),
                    //                         ),
                    //                       ],
                    //                       color: const Color.fromRGBO(
                    //                           239, 191, 239, 1),
                    //                     ),
                    //                     child: Container(
                    //                       padding: const EdgeInsets.symmetric(
                    //                           vertical: 8, horizontal: 8),
                    //                       decoration: BoxDecoration(
                    //                         color: Colors.white.withAlpha(180),
                    //                         borderRadius:
                    //                             BorderRadius.circular(8),
                    //                       ),
                    //                       child: Column(
                    //                         children: [
                    //                           Row(
                    //                             mainAxisAlignment:
                    //                                 MainAxisAlignment.center,
                    //                             children: [
                    //                               Text(
                    //                                 "รวม",
                    //                                 style: MyContant()
                    //                                     .h4normalStyle(),
                    //                               ),
                    //                             ],
                    //                           ),
                    //                         ],
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 ),
                    //               ],
                    //             ),
                    //             // แสดงข้อมูลสำหรับแต่ละ branch
                    //             for (var branch in flattenedData)
                    //               Row(
                    //                 children: [
                    //                   // แสดงชื่อสาขาในคอลัมน์แรกที่ไม่เลื่อน
                    //                   Padding(
                    //                     padding: const EdgeInsets.symmetric(
                    //                         vertical: 4, horizontal: 8),
                    //                     child: Container(
                    //                       width: MediaQuery.of(context)
                    //                               .size
                    //                               .width *
                    //                           0.22,
                    //                       padding: const EdgeInsets.all(6),
                    //                       decoration: BoxDecoration(
                    //                         borderRadius:
                    //                             BorderRadius.circular(10),
                    //                         boxShadow: [
                    //                           BoxShadow(
                    //                             color:
                    //                                 Colors.grey.withAlpha(130),
                    //                             spreadRadius: 0.2,
                    //                             blurRadius: 2,
                    //                             offset: const Offset(0, 1),
                    //                           ),
                    //                         ],
                    //                         color: const Color.fromRGBO(
                    //                             239, 191, 239, 1),
                    //                       ),
                    //                       child: Container(
                    //                         padding: const EdgeInsets.symmetric(
                    //                             vertical: 8, horizontal: 8),
                    //                         decoration: BoxDecoration(
                    //                           color:
                    //                               Colors.white.withAlpha(180),
                    //                           borderRadius:
                    //                               BorderRadius.circular(8),
                    //                         ),
                    //                         child: Column(
                    //                           children: [
                    //                             Row(
                    //                               mainAxisAlignment:
                    //                                   MainAxisAlignment.center,
                    //                               children: [
                    //                                 Text(
                    //                                   branch[
                    //                                       "branchShortName"], // แสดงชื่อสาขา
                    //                                   style: MyContant()
                    //                                       .h4normalStyle(),
                    //                                 ),
                    //                               ],
                    //                             ),
                    //                           ],
                    //                         ),
                    //                       ),
                    //                     ),
                    //                   ),
                    //                   // แสดงค่า dailyTotal ของแต่ละสาขา
                    //                   for (var dailyTotal
                    //                       in branch["dailyTotal"].values)
                    //                     Padding(
                    //                       padding: const EdgeInsets.only(
                    //                           top: 4, bottom: 4, right: 8),
                    //                       child: Container(
                    //                         width: MediaQuery.of(context)
                    //                                 .size
                    //                                 .width *
                    //                             0.38,
                    //                         padding: const EdgeInsets.all(6),
                    //                         decoration: BoxDecoration(
                    //                           borderRadius:
                    //                               BorderRadius.circular(10),
                    //                           boxShadow: [
                    //                             BoxShadow(
                    //                               color: Colors.grey
                    //                                   .withAlpha(130),
                    //                               spreadRadius: 0.2,
                    //                               blurRadius: 2,
                    //                               offset: const Offset(0, 1),
                    //                             ),
                    //                           ],
                    //                           color: const Color.fromRGBO(
                    //                               239, 191, 239, 1),
                    //                         ),
                    //                         child: Container(
                    //                           padding:
                    //                               const EdgeInsets.symmetric(
                    //                                   vertical: 8,
                    //                                   horizontal: 8),
                    //                           decoration: BoxDecoration(
                    //                             color:
                    //                                 Colors.white.withAlpha(180),
                    //                             borderRadius:
                    //                                 BorderRadius.circular(8),
                    //                           ),
                    //                           child: Column(
                    //                             children: [
                    //                               Row(
                    //                                 mainAxisAlignment:
                    //                                     MainAxisAlignment.end,
                    //                                 children: [
                    //                                   Text(
                    //                                     formatter.format(
                    //                                         dailyTotal), // แสดงค่า dailyTotal
                    //                                     style: MyContant()
                    //                                         .h4normalStyle(),
                    //                                   ),
                    //                                 ],
                    //                               ),
                    //                             ],
                    //                           ),
                    //                         ),
                    //                       ),
                    //                     ),
                    //                   Padding(
                    //                     padding: const EdgeInsets.only(
                    //                         top: 4, bottom: 4, right: 8),
                    //                     child: Container(
                    //                       width: MediaQuery.of(context)
                    //                               .size
                    //                               .width *
                    //                           0.38,
                    //                       padding: const EdgeInsets.all(6),
                    //                       decoration: BoxDecoration(
                    //                         borderRadius:
                    //                             BorderRadius.circular(10),
                    //                         boxShadow: [
                    //                           BoxShadow(
                    //                             color:
                    //                                 Colors.grey.withAlpha(130),
                    //                             spreadRadius: 0.2,
                    //                             blurRadius: 2,
                    //                             offset: const Offset(0, 1),
                    //                           ),
                    //                         ],
                    //                         color: const Color.fromRGBO(
                    //                             239, 191, 239, 1),
                    //                       ),
                    //                       child: Container(
                    //                         padding: const EdgeInsets.symmetric(
                    //                             vertical: 8, horizontal: 8),
                    //                         decoration: BoxDecoration(
                    //                           color:
                    //                               Colors.white.withAlpha(180),
                    //                           borderRadius:
                    //                               BorderRadius.circular(8),
                    //                         ),
                    //                         child: Column(
                    //                           children: [
                    //                             Row(
                    //                               mainAxisAlignment:
                    //                                   MainAxisAlignment.end,
                    //                               children: [
                    //                                 Text(
                    //                                   formatterAmount.format(branch[
                    //                                       "qtyTotal"]), // แสดงจำนวนรวม
                    //                                   style: MyContant()
                    //                                       .h4normalStyle(),
                    //                                 ),
                    //                               ],
                    //                             ),
                    //                           ],
                    //                         ),
                    //                       ),
                    //                     ),
                    //                   ),
                    //                   // 📌 คอลัมน์สุดท้าย: แสดง `branchTotal` ของแต่ละสาขา
                    //                   Padding(
                    //                     padding: const EdgeInsets.only(
                    //                         top: 4, bottom: 4, right: 8),
                    //                     child: Container(
                    //                       width: MediaQuery.of(context)
                    //                               .size
                    //                               .width *
                    //                           0.38,
                    //                       padding: const EdgeInsets.all(6),
                    //                       decoration: BoxDecoration(
                    //                         borderRadius:
                    //                             BorderRadius.circular(10),
                    //                         boxShadow: [
                    //                           BoxShadow(
                    //                             color:
                    //                                 Colors.grey.withAlpha(130),
                    //                             spreadRadius: 0.2,
                    //                             blurRadius: 2,
                    //                             offset: const Offset(0, 1),
                    //                           ),
                    //                         ],
                    //                         color: const Color.fromRGBO(
                    //                             239, 191, 239, 1),
                    //                       ),
                    //                       child: Container(
                    //                         padding: const EdgeInsets.symmetric(
                    //                             vertical: 8, horizontal: 8),
                    //                         decoration: BoxDecoration(
                    //                           color:
                    //                               Colors.white.withAlpha(180),
                    //                           borderRadius:
                    //                               BorderRadius.circular(8),
                    //                         ),
                    //                         child: Column(
                    //                           children: [
                    //                             Row(
                    //                               mainAxisAlignment:
                    //                                   MainAxisAlignment.end,
                    //                               children: [
                    //                                 Text(
                    //                                   formatter.format(branch[
                    //                                       "branchTotal"]), // แสดงยอดรวมสาขา
                    //                                   style: MyContant()
                    //                                       .h4normalStyle(),
                    //                                 ),
                    //                               ],
                    //                             ),
                    //                           ],
                    //                         ),
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 ],
                    //               ),
                    //             // แถวรวมยอดขายต่อวัน (แถวล่างสุด)
                    //             Row(
                    //               children: [
                    //                 // คอลัมน์แรก (แสดง "รวมทั้งหมด")
                    //                 Padding(
                    //                   padding: const EdgeInsets.symmetric(
                    //                       vertical: 4, horizontal: 8),
                    //                   child: Container(
                    //                     width:
                    //                         MediaQuery.of(context).size.width *
                    //                             0.22,
                    //                     padding: const EdgeInsets.all(6),
                    //                     decoration: BoxDecoration(
                    //                       borderRadius:
                    //                           BorderRadius.circular(10),
                    //                       boxShadow: [
                    //                         BoxShadow(
                    //                           color: Colors.grey.withAlpha(130),
                    //                           spreadRadius: 0.2,
                    //                           blurRadius: 2,
                    //                           offset: const Offset(0, 1),
                    //                         ),
                    //                       ],
                    //                       color: const Color.fromRGBO(
                    //                           239, 191, 239, 1),
                    //                     ),
                    //                     child: Container(
                    //                       padding: const EdgeInsets.symmetric(
                    //                           vertical: 8, horizontal: 8),
                    //                       decoration: BoxDecoration(
                    //                         color: Colors.white.withAlpha(180),
                    //                         borderRadius:
                    //                             BorderRadius.circular(8),
                    //                       ),
                    //                       child: Column(
                    //                         children: [
                    //                           Row(
                    //                             mainAxisAlignment:
                    //                                 MainAxisAlignment.center,
                    //                             children: [
                    //                               Text(
                    //                                 'รวม',
                    //                                 style: MyContant()
                    //                                     .h4normalStyle(),
                    //                               ),
                    //                             ],
                    //                           ),
                    //                         ],
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 ),

                    //                 // วนลูปแสดงผลรวมของแต่ละวัน โดยเรียงตามวันที่จาก branchDetails[0]
                    //                 for (var date in flattenedData.isNotEmpty &&
                    //                         flattenedData[0]["dailyTotal"] !=
                    //                             null
                    //                     ? flattenedData[0]["dailyTotal"].keys
                    //                     : [])
                    //                   Padding(
                    //                     padding: const EdgeInsets.only(
                    //                         top: 4, bottom: 4, right: 8),
                    //                     child: Container(
                    //                       width: MediaQuery.of(context)
                    //                               .size
                    //                               .width *
                    //                           0.38,
                    //                       padding: const EdgeInsets.all(6),
                    //                       decoration: BoxDecoration(
                    //                         borderRadius:
                    //                             BorderRadius.circular(10),
                    //                         boxShadow: [
                    //                           BoxShadow(
                    //                             color:
                    //                                 Colors.grey.withAlpha(130),
                    //                             spreadRadius: 0.2,
                    //                             blurRadius: 2,
                    //                             offset: const Offset(0, 1),
                    //                           ),
                    //                         ],
                    //                         color: const Color.fromRGBO(
                    //                             239, 191, 239, 1),
                    //                       ),
                    //                       child: Container(
                    //                         padding: const EdgeInsets.symmetric(
                    //                             vertical: 8, horizontal: 8),
                    //                         decoration: BoxDecoration(
                    //                           color:
                    //                               Colors.white.withAlpha(180),
                    //                           borderRadius:
                    //                               BorderRadius.circular(8),
                    //                         ),
                    //                         child: Column(
                    //                           children: [
                    //                             Row(
                    //                               mainAxisAlignment:
                    //                                   MainAxisAlignment.end,
                    //                               children: [
                    //                                 Text(
                    //                                   formatter.format(totalDaily[
                    //                                           date] ??
                    //                                       0), // ใช้ totalDaily ตามลำดับ
                    //                                   style: MyContant()
                    //                                       .h4normalStyle(),
                    //                                 ),
                    //                               ],
                    //                             ),
                    //                           ],
                    //                         ),
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 Padding(
                    //                   padding: const EdgeInsets.only(
                    //                       top: 4, bottom: 4, right: 8),
                    //                   child: Container(
                    //                     width:
                    //                         MediaQuery.of(context).size.width *
                    //                             0.38,
                    //                     padding: const EdgeInsets.all(6),
                    //                     decoration: BoxDecoration(
                    //                       borderRadius:
                    //                           BorderRadius.circular(10),
                    //                       boxShadow: [
                    //                         BoxShadow(
                    //                           color: Colors.grey.withAlpha(130),
                    //                           spreadRadius: 0.2,
                    //                           blurRadius: 2,
                    //                           offset: const Offset(0, 1),
                    //                         ),
                    //                       ],
                    //                       color: const Color.fromRGBO(
                    //                           239, 191, 239, 1),
                    //                     ),
                    //                     child: Container(
                    //                       padding: const EdgeInsets.symmetric(
                    //                           vertical: 8, horizontal: 8),
                    //                       decoration: BoxDecoration(
                    //                         color: Colors.white.withAlpha(180),
                    //                         borderRadius:
                    //                             BorderRadius.circular(8),
                    //                       ),
                    //                       child: Column(
                    //                         children: [
                    //                           Row(
                    //                             mainAxisAlignment:
                    //                                 MainAxisAlignment.end,
                    //                             children: [
                    //                               Text(
                    //                                 formatterAmount.format(
                    //                                     totalQty), // แสดงผลรวม branchTotal
                    //                                 style: MyContant()
                    //                                     .h4normalStyle(),
                    //                               ),
                    //                             ],
                    //                           ),
                    //                         ],
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 ),
                    //                 // 📌 คอลัมน์สุดท้าย: รวม branchTotal ทุกสาขา
                    //                 Padding(
                    //                   padding: const EdgeInsets.only(
                    //                       top: 4, bottom: 4, right: 8),
                    //                   child: Container(
                    //                     width:
                    //                         MediaQuery.of(context).size.width *
                    //                             0.38,
                    //                     padding: const EdgeInsets.all(6),
                    //                     decoration: BoxDecoration(
                    //                       borderRadius:
                    //                           BorderRadius.circular(10),
                    //                       boxShadow: [
                    //                         BoxShadow(
                    //                           color: Colors.grey.withAlpha(130),
                    //                           spreadRadius: 0.2,
                    //                           blurRadius: 2,
                    //                           offset: const Offset(0, 1),
                    //                         ),
                    //                       ],
                    //                       color: const Color.fromRGBO(
                    //                           239, 191, 239, 1),
                    //                     ),
                    //                     child: Container(
                    //                       padding: const EdgeInsets.symmetric(
                    //                           vertical: 8, horizontal: 8),
                    //                       decoration: BoxDecoration(
                    //                         color: Colors.white.withAlpha(180),
                    //                         borderRadius:
                    //                             BorderRadius.circular(8),
                    //                       ),
                    //                       child: Column(
                    //                         children: [
                    //                           Row(
                    //                             mainAxisAlignment:
                    //                                 MainAxisAlignment.end,
                    //                             children: [
                    //                               Text(
                    //                                 formatter.format(
                    //                                     totalSum), // แสดงผลรวม branchTotal
                    //                                 style: MyContant()
                    //                                     .h4normalStyle(),
                    //                               ),
                    //                             ],
                    //                           ),
                    //                         ],
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 ),
                    //               ],
                    //             ),
                    //             SizedBox(height: 30),
                    //           ],
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // )
                  ],
                ),
    );
  }

  Widget buildTextStyle(
    String text,
    double width,
    EdgeInsets padding,
    MainAxisAlignment alignment,
  ) {
    return Padding(
      padding: padding, // ✅ ใช้ padding ที่รับเข้ามา
      child: Container(
        width: width,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withAlpha(130),
              spreadRadius: 0.2,
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
          color: const Color.fromRGBO(239, 191, 239, 1),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(180),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: alignment,
                children: [
                  Text(
                    text,
                    style: MyContant().h4normalStyle(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
