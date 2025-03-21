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
  final List<dynamic> branchDetails = [
    {
      "branchName": "PY",
      "branchAreaName": "เขต 4",
      "branchTotal": 3528743.95,
      "targetTotal": 4500000,
      "percent": 78.42,
      "dailyTotal": {
        "01": 222651.4,
        "02": 124207.48,
        "03": 148094.39,
        "04": 124537.38,
        "05": 145005.61,
        "06": 82209.35,
        "07": 163617.76,
        "08": 54359.81,
        "09": 101250.47,
        "10": 196401.87,
      }
    },
    {
      "branchName": "CC",
      "branchAreaName": "เขต 4",
      "branchTotal": 3352647.66,
      "targetTotal": 3000000,
      "percent": 111.75,
      "dailyTotal": {
        "01": 199612.15,
        "02": 204182.24,
        "03": 157294.39,
        "04": 71416.82,
        "05": 70624.3,
        "06": 105157.01,
        "07": 223571.96,
        "08": 78508.41,
        "09": 30820.56,
        "10": 170843.93,
      }
    },
    {
      "branchName": "DK",
      "branchAreaName": "เขต 4",
      "branchTotal": 2000591.6,
      "targetTotal": 2000000,
      "percent": 100.03,
      "dailyTotal": {
        "01": 91920.56,
        "02": 76779.44,
        "03": 55346.73,
        "04": 47737.38,
        "05": 76070.09,
        "06": 86050.47,
        "07": 82642.99,
        "08": 53800.93,
        "09": 35598.13,
        "10": 83269.16,
      }
    },
    {
      "branchName": "YP",
      "branchAreaName": "เขต 4",
      "branchTotal": 1863655.14,
      "targetTotal": 1550000,
      "percent": 120.24,
      "dailyTotal": {
        "01": 132866.36,
        "02": 106745.79,
        "03": 102812.15,
        "04": 42401.87,
        "05": 51414.95,
        "06": 36502.8,
        "07": 134557.94,
        "08": 62148.6,
        "09": 63829.91,
        "10": 60237.38,
      }
    },
    {
      "branchName": "CH",
      "branchAreaName": "เขต 4",
      "branchTotal": 1501174.79,
      "targetTotal": 1500000,
      "percent": 100.08,
      "dailyTotal": {
        "01": 63026.17,
        "02": 29501.87,
        "03": 29425.23,
        "04": 51988.79,
        "05": 89629.91,
        "06": 41914.95,
        "07": 70920.56,
        "08": 35295.33,
        "09": 27307.48,
        "10": 107546.73,
      }
    },
    {
      "branchName": "PO",
      "branchAreaName": "เขต 4",
      "branchTotal": 1477834.59,
      "targetTotal": 1900000,
      "percent": 77.78,
      "dailyTotal": {
        "01": 63427.1,
        "02": 154025.23,
        "03": 107052.34,
        "04": 9626.17,
        "05": 55329.91,
        "06": 28326.17,
        "07": 26614.95,
        "08": 39371.03,
        "09": 7542.06,
        "10": 10271.03,
      }
    },
    {
      "branchName": "NG",
      "branchAreaName": "เขต 4",
      "branchTotal": 911259.82,
      "targetTotal": 900000,
      "percent": 101.25,
      "dailyTotal": {
        "01": 57355.14,
        "02": 44503.74,
        "03": 53232.71,
        "04": 0,
        "05": 11858.88,
        "06": 6073.83,
        "07": 94279.44,
        "08": 26971.96,
        "09": 25985.05,
        "10": 29597.2,
      }
    },
    {
      "branchName": "MO",
      "branchAreaName": "เขต 4",
      "branchTotal": 815434.6,
      "targetTotal": 1000000,
      "percent": 81.54,
      "dailyTotal": {
        "01": 24950.47,
        "02": 6671.96,
        "03": 61069.16,
        "04": 0,
        "05": 53342.06,
        "06": 37976.64,
        "07": 8410.28,
        "08": 7746.73,
        "09": 42970.09,
        "10": 29212.15,
      }
    },
    {
      "branchName": "PE",
      "branchAreaName": "เขต 4",
      "branchTotal": 762349.55,
      "targetTotal": 5000000,
      "percent": 15.25,
      "dailyTotal": {
        "01": 0,
        "02": 0,
        "03": 0,
        "04": 0,
        "05": 15877.57,
        "06": 0,
        "07": 13261.68,
        "08": 27000,
        "09": 0,
        "10": 8410.28,
      }
    },
    {
      "branchName": "MN",
      "branchAreaName": "เขต 4",
      "branchTotal": 519755.16,
      "targetTotal": 400000,
      "percent": 129.94,
      "dailyTotal": {
        "01": 0,
        "02": 0,
        "03": 0,
        "04": 0,
        "05": 36558.88,
        "06": 34906.54,
        "07": 19044.86,
        "08": 16531.78,
        "09": 45148.6,
        "10": 62035.51,
      }
    }
  ];

  var dataSaleHead;
  var formatter = NumberFormat('#,##0.00');

  @override
  void initState() {
    super.initState();
    buildDataSaleList();
    sumDailySales(branchDetails);
    // print('dataSaleList: ${widget.dataSaleList}');
    // print('dataType: ${widget.dataSaleList.runtimeType}');
  }

  void buildDataSaleList() {
    Map<String, dynamic> dailyTotalMap =
        Map<String, dynamic>.from(widget.dataSaleList);

    // dataSaleHead = dailyTotalMap['head'];
    dataSaleHead = dailyTotalMap['head'];
    dailyTotalList = dailyTotalMap['detail'];
    print('dailyTotalList: ${dailyTotalList.runtimeType}');
    print('dailyTotalList: $dailyTotalList');
    print('dataSaleHead: ${dataSaleHead['month']}');
    List<Map<String, dynamic>> flattenedData = [];

    // ใช้การวนลูปเพื่อเพิ่มข้อมูลจากแต่ละ List
    for (var branchList in dailyTotalMap['detail']) {
      if (branchList is List<Map<String, dynamic>>) {
        flattenedData.addAll(branchList);
      }
    }
    print('flattenedData: $flattenedData');
  }

  void sumDailySales(List<dynamic> branchDataList) {
    // สร้าง Map สำหรับเก็บผลรวมยอดขายตามวันที่
    Map<String, double> dailySum = {};

    // วน loop ผ่านแต่ละสาขา
    for (var branch in branchDataList) {
      // เข้าถึง dailyTotal ของแต่ละสาขา
      Map<String, dynamic> dailyTotal = branch['dailyTotal'];

      // วน loop ผ่านแต่ละวันที่ใน dailyTotal
      dailyTotal.forEach((date, amount) {
        // ถ้าวันที่นั้นมีใน dailySum แล้ว ให้บวกค่า amount เพิ่ม
        if (dailySum.containsKey(date)) {
          dailySum[date] = dailySum[date]! + amount;
        } else {
          // ถ้าไม่มีก็เพิ่มเข้าไปใน dailySum
          dailySum[date] = amount;
        }
      });
    }

    // แสดงผลรวมยอดขายแต่ละวัน
    print('Daily Sales Total: $dailySum');
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
                          for (var date in branchDetails.isNotEmpty &&
                                  branchDetails[0]["dailyTotal"] != null
                              ? branchDetails[0]["dailyTotal"]?.keys ?? []
                              : [])
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 4),
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
                        ],
                      ),
                      // แสดงข้อมูลสำหรับแต่ละ branch
                      for (var branch in branchDetails)
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
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 4),
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
                          ],
                        ),
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
