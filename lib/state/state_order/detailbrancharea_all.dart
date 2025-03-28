import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../utility/my_constant.dart';
import '../../widgets/custom_appbar.dart';

class DetailBranchAreaAll extends StatefulWidget {
  final dynamic dataSaleList;
  const DetailBranchAreaAll({super.key, this.dataSaleList});

  @override
  State<DetailBranchAreaAll> createState() => _DetailBranchAreaAllState();
}

class _DetailBranchAreaAllState extends State<DetailBranchAreaAll> {
  List<Map<String, dynamic>>? dailyList;
  List<dynamic>? dailyTotalList;
  Map<String, double> totalDaily = {};
  Map<String, double> dailySum = {};
  List<Map<String, dynamic>> flattenedData = [];
  double totalSum = 0;
  var dataSaleHead;
  var formatter = NumberFormat('#,##0.00');

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
    print('Daily Sales Total: $totalDaily');
    print('Daily Sales Total Type: ${totalDaily.runtimeType}');
  }

  double sumBranchTotal() {
    for (var branch in flattenedData) {
      if (branch.containsKey("branchTotal") && branch["branchTotal"] is num) {
        totalSum += branch["branchTotal"];
      }
    }

    print('Total Branch Sales: $totalSum');
    return totalSum;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: 'ยอดขายสินค้ารวมสาขาในแต่ละวัน'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
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
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
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
                          'เดือน ${dataSaleHead['month']} พ.ศ. ${dataSaleHead['year']}',
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
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    children: [
                      // แสดงวันที่จาก keys ของ branch["dailyTotal"]
                      Row(
                        children: [
                          // คอลัมน์แรกที่แสดงชื่อสาขา
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 8),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.22,
                              padding: const EdgeInsets.all(8),
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
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 8),
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
                                          'วันที่', // ส่วนนี้คือส่วนหัวของคอลัมน์แรก
                                          style: MyContant().h4normalStyle(),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // แสดงวันที่จาก keys ของ branch["dailyTotal"]
                          for (var date in flattenedData.isNotEmpty &&
                                  flattenedData[0]["dailyTotal"] != null
                              ? flattenedData[0]["dailyTotal"]?.keys ?? []
                              : [])
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 4, bottom: 4, right: 8),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.35,
                                padding: const EdgeInsets.all(8),
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
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 8),
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
                                            date.toString(), // แสดงวันที่จาก keys ของ dailyTotal
                                            style: MyContant().h4normalStyle(),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          // 📌 คอลัมน์สุดท้าย: เพิ่มหัวข้อ "รวม"
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 4, bottom: 4, right: 8),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.35,
                              padding: const EdgeInsets.all(8),
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
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 8),
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
                                          "รวม",
                                          style: MyContant().h4normalStyle(),
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
                      // แสดงข้อมูลสำหรับแต่ละ branch
                      for (var branch in flattenedData)
                        Row(
                          children: [
                            // แสดงชื่อสาขาในคอลัมน์แรกที่ไม่เลื่อน
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 8),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.22,
                                padding: const EdgeInsets.all(8),
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
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 8),
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
                                            branch[
                                                "branchName"], // แสดงชื่อสาขา
                                            style: MyContant().h4normalStyle(),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // แสดงค่า dailyTotal ของแต่ละสาขา
                            for (var dailyTotal in branch["dailyTotal"].values)
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 4, bottom: 4, right: 8),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.35,
                                  padding: const EdgeInsets.all(8),
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
                                    color:
                                        const Color.fromRGBO(239, 191, 239, 1),
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withAlpha(180),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              formatter.format(
                                                  dailyTotal), // แสดงค่า dailyTotal
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
                            // 📌 คอลัมน์สุดท้าย: แสดง `branchTotal` ของแต่ละสาขา
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 4, bottom: 4, right: 8),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.35,
                                padding: const EdgeInsets.all(8),
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
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withAlpha(180),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            formatter.format(branch[
                                                "branchTotal"]), // แสดงยอดรวมสาขา
                                            style: MyContant().h4normalStyle(),
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
                      // แถวรวมยอดขายต่อวัน (แถวล่างสุด)
                      Row(
                        children: [
                          // คอลัมน์แรก (แสดง "รวมทั้งหมด")
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 8),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.22,
                              padding: const EdgeInsets.all(8),
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
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 8),
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
                                          'รวม',
                                          style: MyContant().h4normalStyle(),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // วนลูปแสดงผลรวมของแต่ละวัน โดยเรียงตามวันที่จาก branchDetails[0]
                          for (var date in flattenedData.isNotEmpty &&
                                  flattenedData[0]["dailyTotal"] != null
                              ? flattenedData[0]["dailyTotal"].keys
                              : [])
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 4, bottom: 4, right: 8),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.35,
                                padding: const EdgeInsets.all(8),
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
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withAlpha(180),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            formatter.format(totalDaily[date] ??
                                                0), // ใช้ totalDaily ตามลำดับ
                                            style: MyContant().h4normalStyle(),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          // 📌 คอลัมน์สุดท้าย: รวม branchTotal ทุกสาขา
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 4, bottom: 4, right: 8),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.35,
                              padding: const EdgeInsets.all(8),
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
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withAlpha(180),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          formatter.format(
                                              totalSum), // แสดงผลรวม branchTotal
                                          style: MyContant().h4normalStyle(),
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
                      SizedBox(height: 30),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
