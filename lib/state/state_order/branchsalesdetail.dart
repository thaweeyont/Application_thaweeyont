import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../utility/my_constant.dart';
import '../../widgets/custom_appbar.dart';

class BranchSalesDetail extends StatefulWidget {
  const BranchSalesDetail({super.key});

  @override
  State<BranchSalesDetail> createState() => _BranchSalesDetailState();
}

class _BranchSalesDetailState extends State<BranchSalesDetail> {
  List<Map<String, dynamic>> dataList = [
    {
      "branchName": "TH",
      "branchAreaName": "เขต 1",
      "branchTotal": 1937440.18,
      "targetTotal": 2000000,
      "percent": 96.87,
      "dailyTotal": {
        "01": 108247.66,
        "02": 27479.44,
        "03": 82132.71,
        "04": 32602.8,
        "05": 108928.04,
        "06": 11147.66,
        "07": 46143.93,
        "08": 64548.6,
        "09": 102259.81,
        "10": 67258.88,
      }
    },
    {
      "branchName": "CN",
      "branchAreaName": "เขต 2",
      "branchTotal": 1589302.45,
      "targetTotal": 1800000,
      "percent": 88.29,
      "dailyTotal": {
        "01": 97258.32,
        "02": 25149.11,
        "03": 73102.77,
        "04": 28901.44,
        "05": 103204.65,
        "06": 8741.33,
        "07": 42983.12,
        "08": 59834.57,
        "09": 95230.43,
        "10": 61049.28,
      }
    },
    {
      "branchName": "US",
      "branchAreaName": "เขต 3",
      "branchTotal": 2458120.98,
      "targetTotal": 2500000,
      "percent": 98.32,
      "dailyTotal": {
        "01": 127589.33,
        "02": 32894.77,
        "03": 90238.12,
        "04": 39821.65,
        "05": 120504.23,
        "06": 13249.67,
        "07": 50123.55,
        "08": 72034.88,
        "09": 114509.99,
        "10": 76458.32,
      }
    },
    {
      "branchName": "US",
      "branchAreaName": "เขต 3",
      "branchTotal": 2458120.98,
      "targetTotal": 2500000,
      "percent": 98.32,
      "dailyTotal": {
        "01": 127589.33,
        "02": 32894.77,
        "03": 90238.12,
        "04": 39821.65,
        "05": 120504.23,
        "06": 13249.67,
        "07": 50123.55,
        "08": 72034.88,
        "09": 114509.99,
        "10": 76458.32,
      }
    },
    {
      "branchName": "US",
      "branchAreaName": "เขต 3",
      "branchTotal": 2458120.98,
      "targetTotal": 2500000,
      "percent": 98.32,
      "dailyTotal": {
        "01": 127589.33,
        "02": 32894.77,
        "03": 90238.12,
        "04": 39821.65,
        "05": 120504.23,
        "06": 13249.67,
        "07": 50123.55,
        "08": 72034.88,
        "09": 114509.99,
        "10": 76458.32,
      }
    },
    {
      "branchName": "US",
      "branchAreaName": "เขต 3",
      "branchTotal": 2458120.98,
      "targetTotal": 2500000,
      "percent": 98.32,
      "dailyTotal": {
        "01": 127589.33,
        "02": 32894.77,
        "03": 90238.12,
        "04": 39821.65,
        "05": 120504.23,
        "06": 13249.67,
        "07": 50123.55,
        "08": 72034.88,
        "09": 114509.99,
        "10": 76458.32,
      }
    }
  ];

  var formatter = NumberFormat('#,##0.00');

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
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
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
                          'ยอดขายสินค้าเดือน',
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
            padding: const EdgeInsets.only(left: 8, right: 8, bottom: 6),
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
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(180),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'เขต 2',
                          style: MyContant().h4normalStyle(),
                        ),
                        Text(
                          'สาขา MS',
                          style: MyContant().h4normalStyle(),
                        ),
                        Text(
                          'เป้า ${formatter.format(1000000)}',
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
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(8.0),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final items = dataList[index];
                        return Container(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'วันที่ : ${index + 1}',
                                    style: MyContant().h4normalStyle(),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withAlpha(180),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          formatter.format(114509.99),
                                          style: MyContant().h4normalStyle(),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      childCount: dataList.length, // ✅ บวก 1 เพื่อรวมยอด
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // ✅ ตั้งค่าให้มี 2 คอลัมน์
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 2.25,
                    ),
                  ),
                ),

                // ✅ ใช้ SliverToBoxAdapter เพื่อให้ Container อยู่ใน GridView
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 8.0),
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
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(180),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'ยอดรวม : ${formatter.format(999999.99)}',
                              style: MyContant().h4normalStyle(),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'ทำได้ : %',
                              style: MyContant().h4normalStyle(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
