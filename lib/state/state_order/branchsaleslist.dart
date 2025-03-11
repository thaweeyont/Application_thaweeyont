import 'package:application_thaweeyont/utility/my_constant.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/custom_appbar.dart';

class BranchSalesList extends StatefulWidget {
  const BranchSalesList({super.key});

  @override
  State<BranchSalesList> createState() => _BranchSalesListState();
}

class _BranchSalesListState extends State<BranchSalesList> {
  String userId = '', empId = '', firstName = '', lastName = '', tokenId = '';

  double totalTarget = 0.0, totalAmount = 0.0;
  List<Map<String, dynamic>> dataList = [
    {
      "area": "4",
      "branch": "NG",
      "target": "1,000,000",
      "total": "1,007,461.69",
      "percentage": "100.75",
    },
    {
      "area": "4",
      "branch": "YP",
      "target": "2,100,000",
      "total": "1,885,399.99",
      "percentage": "89.78",
    },
    {
      "area": "4",
      "branch": "MC",
      "target": "1,300,000",
      "total": "1,152,451.41",
      "percentage": "86.65",
    },
    {
      "area": "4",
      "branch": "DK",
      "target": "2,500,000",
      "total": "2,181,179.43",
      "percentage": "87.25",
    },
  ];

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
      sumtotal();
    }
  }

  var formatter = NumberFormat('#,##0.00');

  double calculatePercentage(double totalTarget, double totalAmount) {
    if (totalTarget == 0) return 0; // ป้องกันการหารด้วย 0
    return (totalAmount / totalTarget) * 100;
  }

  void sumtotal() {
    totalTarget = dataList
        .map((item) => double.parse(item["target"].replaceAll(",", "")))
        .reduce((a, b) => a + b);
    totalAmount = dataList
        .map((item) => double.parse(item["total"].replaceAll(",", "")))
        .reduce((a, b) => a + b);

    print("ยอดรวมเป้า: $totalTarget");
    print("ยอดรวมยอดขาย: $totalAmount");
    double percentage = calculatePercentage(totalTarget, totalAmount);

    print("ทำได้: ${percentage.toStringAsFixed(2)}%");
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
                itemCount: dataList.length + 2, // จำนวนรายการ
                itemBuilder: (context, index) {
                  if (index == dataList.length) {
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
                                    'ทำได้ : %',
                                    style: MyContant().h4normalStyle(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else if (index == dataList.length + 1) {
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
                  final data = dataList[index];
                  return GestureDetector(
                    onTap: () {
                      print("ตำแหน่งที่: $index | ข้อมูล: ${dataList[index]}");
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
                                  'เขตสาขา : ${data["area"]}',
                                  style: MyContant().h4normalStyle(),
                                ),
                                Text(
                                  'สาขา : ${data["branch"]}',
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
                                        'เป้า : ${data["target"]}',
                                        style: MyContant().h4normalStyle(),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'ยอดรวม : ${data["total"]}',
                                        style: MyContant().h4normalStyle(),
                                      ),
                                      Text(
                                        'ทำได้ : ${data["percentage"]} %',
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
