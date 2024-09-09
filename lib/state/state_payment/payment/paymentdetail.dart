import 'package:application_thaweeyont/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

import '../../../utility/my_constant.dart';

class PaymentDetail extends StatefulWidget {
  const PaymentDetail({super.key});

  @override
  State<PaymentDetail> createState() => _PaymentDetailState();
}

class _PaymentDetailState extends State<PaymentDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: 'ข้อมูลการจ่ายเงิน'),
      body: GestureDetector(
        child: ListView(
          shrinkWrap: true,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
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
                      buildInfoRow('เลขที่ใบสำคัญจ่าย :', ''),
                      buildInfoRow('วันที่ :', ''),
                      buildInfoRow('ผู้จำหน่าย :', ''),
                      buildInfoRow('ชื้อผู้จำหน่าย :', ''),
                      buildInfoRow('ประเภท :', ''),
                      buildInfoRow('เพื่อชำระค่า :', ''),
                      buildInfoRow('หมายเหตุ :', ''),
                      buildInfoRow('อ้างอิง :', ''),
                      buildInfoRow('วันที่หัก ณ ที่จ่าย :', ''),
                      buildInfoRow('ผู้ออก ณ ที่จ่าย :', ''),
                      buildInfoRow('จำนวนเงินรวม :', ''),
                      buildInfoRow('ผู้จัดทำ :', ''),
                      buildInfoRow('ผู้อนุมัติ :', ''),
                      buildInfoRow('ผู้จ่ายเงิน :', ''),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
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
                child: Column(
                  children: [
                    buildInfoRow('รายการจ่ายเงิน', ''),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 3, horizontal: 8),
                        child: Column(
                          children: [
                            buildInfoRow('รายการ :', ''),
                            buildInfoRow('เอกสารอ้างอิง :', ''),
                            buildInfoRow('จำนวนเงิน :', ''),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    buildInfoRow('ภาษีมูลค่าเพิ่ม', ''),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 3, horizontal: 8),
                        child: Column(
                          children: [
                            buildInfoRow('ประเภท :', ''),
                            buildInfoRow('ภาษี :', ''),
                            buildInfoRow('ก่อนภาษี :', ''),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    buildInfoRow('ภาษีหัก ณ ที่จ่าย', ''),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 3, horizontal: 8),
                        child: Column(
                          children: [
                            buildInfoRow('อัตรา :', ''),
                            buildInfoRow('จำนวนเงิน :', ''),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget buildInfoRow(String text, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 0,
            child: Text(
              text,
              style: MyContant().h4normalStyle(),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: MyContant().h4normalStyle(),
            ),
          ),
        ],
      ),
    );
  }
}
