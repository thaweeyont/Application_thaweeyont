import 'package:application_thaweeyont/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../../utility/my_constant.dart';

class PaymentReportList extends StatefulWidget {
  const PaymentReportList({super.key});

  @override
  State<PaymentReportList> createState() => _PaymentReportListState();
}

class _PaymentReportListState extends State<PaymentReportList> {
  double totalAmount = 0;
  List<Map<String, dynamic>> transactions = [
    {
      'date': '17/08/2567',
      'item': 'ชำระค่าโทรศัพท์มือถือและอินเทอร์เน็ต',
      'amount': 9650.50
    },
    {'date': '17/08/2567', 'item': 'ค่าธรรมเนียมธนาคาร', 'amount': 310.00},
    {
      'date': '17/08/2567',
      'item': 'ชำระค่าไฟฟ้าประจำเดือนมกราคม',
      'amount': 12500.00
    },
    {
      'date': '17/08/2567',
      'item': 'เจ้าหนี้การค้า-กรุงเทพ',
      'amount': 951583.41
    },
    {'date': '17/08/2567', 'item': 'เงินมัดจำซื้อสินค้า', 'amount': 6400.00},
    {
      'date': '17/08/2567',
      'item': 'เติมน้ำมันรถยนต์เต็มถัง',
      'amount': 4500.75
    },
    {'date': '17/08/2567', 'item': 'เงินยืมสำรองจ่าย', 'amount': 1565.50},
    {'date': '17/08/2567', 'item': 'ค่าใช้จ่ายอื่นๆ', 'amount': 1716000.00},
    {'date': '17/08/2567', 'item': 'ค่าเบี้ยเลี้ยง', 'amount': 2890.00},
    {'date': '17/08/2567', 'item': 'ค่าใช้จ่ายอื่นๆ', 'amount': 515.25},
  ];
  @override
  void initState() {
    super.initState();
    main();
  }

  // ใช้ NumberFormat เพื่อจัดรูปแบบตัวเลข
  var formatter = NumberFormat('#,##0.00'); // รูปแบบที่แสดงทศนิยม 2 ตำแหน่ง

  void main() {
    // ใช้ map เพื่อดึงค่า amount และ reduce เพื่อรวมยอดเงิน
    totalAmount = transactions
        .map((transaction) =>
            transaction['amount'] as double) // ดึงค่า amount ออกมา
        .reduce((sum, amount) => sum + amount); // รวมยอดเงินทั้งหมด

    print('Total Amount: $totalAmount');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: 'รายงานการจ่ายเงิน'),
      body: GestureDetector(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 0.2,
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    )
                  ],
                  color: const Color.fromRGBO(226, 199, 132, 1),
                ),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'วันที่ 17/08/2567 - 17/08/2567',
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
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 0.2,
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    )
                  ],
                  color: const Color.fromRGBO(226, 199, 132, 1),
                ),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'วันที่',
                            style: MyContant().h4normalStyle(),
                          ),
                          Text(
                            'รายการ',
                            style: MyContant().h4normalStyle(),
                          ),
                          Text(
                            'จำนวนเงิน',
                            style: MyContant().h4normalStyle(),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 0.2,
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    )
                  ],
                  color: const Color.fromRGBO(226, 199, 132, 1),
                ),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for (var i = 0; i < transactions.length; i++)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              Row(
                                // mainAxisAlignment:
                                //     MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 6),
                                    child: Column(
                                      children: [
                                        Text(
                                          '${transactions[i]['date']}',
                                          style: MyContant().h4normalStyle(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                '${transactions[i]['item']}',
                                                style:
                                                    MyContant().h4normalStyle(),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 6),
                                    child: Column(
                                      children: [
                                        Text(
                                          formatter.format(
                                              transactions[i]['amount']),
                                          style: MyContant().h4normalStyle(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 0.2,
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    )
                  ],
                  color: const Color.fromRGBO(226, 199, 132, 1),
                ),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'รวมทั้งหมด ${formatter.format(totalAmount)}',
                            style: MyContant().h4normalStyle(),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
