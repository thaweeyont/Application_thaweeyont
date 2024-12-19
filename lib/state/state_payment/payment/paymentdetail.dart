import 'dart:convert';

import 'package:application_thaweeyont/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_gifs/loading_gifs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../api.dart';
import '../../../utility/my_constant.dart';
import '../../authen.dart';

class PaymentDetail extends StatefulWidget {
  final String? paymentTranId;
  const PaymentDetail(this.paymentTranId, {super.key});

  @override
  State<PaymentDetail> createState() => _PaymentDetailState();
}

class _PaymentDetailState extends State<PaymentDetail> {
  String userId = '', empId = '', firstName = '', lastName = '', tokenId = '';
  List listpaydetail = [], listpayTran = [];
  var paymentDetail;
  bool statusLoading = false, statusLoad404 = false;
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
    getPaymentList();
  }

  var formatter = NumberFormat('#,##0.00'); // รูปแบบที่แสดงทศนิยม 2 ตำแหน่ง

  Future<void> getPaymentList() async {
    // print(
    //     '1<${widget.selectBranchlist}> 2<${widget.selectSupplylist}> 3<${widget.valueStartDate}> 4<${widget.valueEndDate}> 5<${widget.selectEmployeelist}> 6<${widget.paydetail}> 7<$newPaymentType> 8<${widget.supplyName}>');
    try {
      var respose = await http.post(
        Uri.parse('${api}payment/detail'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
        body: jsonEncode(<String, String>{
          'paymentTranId': widget.paymentTranId.toString(),
        }),
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> dataPaymentDetail =
            Map<String, dynamic>.from(json.decode(respose.body));

        paymentDetail = dataPaymentDetail['data'];
        setState(() {
          listpaydetail = paymentDetail['detail'];
          listpayTran = paymentDetail['payTranDetail'];
        });
        statusLoading = true;
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
      showProgressDialogNotdata(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: 'ข้อมูลการจ่าย'),
      body: statusLoading == false
          ? Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 24, 24, 24).withValues(alpha: 0.9),
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
              : GestureDetector(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withValues(alpha: 0.5),
                                spreadRadius: 0.2,
                                blurRadius: 2,
                                offset: const Offset(0, 1),
                              )
                            ],
                            color: const Color.fromRGBO(226, 199, 132, 1),
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 6, horizontal: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.7),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  children: [
                                    buildInfoRow('เลขที่ใบสำคัญจ่าย :',
                                        '${paymentDetail['paymentTranId']}'),
                                    buildInfoRow('วันที่จัดทำ :',
                                        '${paymentDetail['payDate']}'),
                                    buildInfoRow('วันที่กำหนดจ่ายเงิน :',
                                        '${paymentDetail['dueDate']}'),
                                    buildInfoRow('ชื่อผู้จำหน่าย :',
                                        '${paymentDetail['supplyName']}'),
                                    buildInfoRow('ประเภท :',
                                        '${paymentDetail['payTypeName']}'),
                                    buildInfoRow('เพื่อชำระค่า :',
                                        '${paymentDetail['payDetail']}'),
                                    buildInfoRow(
                                        'ธนาคาร :', '${paymentDetail['note']}'),
                                    buildInfoRow('เลขที่บัญชี :',
                                        '${paymentDetail['tranRefId']}'),
                                    buildInfoRow(
                                        'เงินโอน :',
                                        formatter.format(
                                            paymentDetail['transferAmt'])),
                                    buildInfoRow(
                                        'ค่าธรรมเนียม :',
                                        formatter
                                            .format(paymentDetail['feeAmt'])),
                                    buildInfoRow(
                                        'จำนวนเงินรวม :',
                                        formatter
                                            .format(paymentDetail['totalAmt'])),
                                    buildInfoRow('วันที่หัก ณ ที่จ่าย :',
                                        '${paymentDetail['whDate']}'),
                                    buildInfoRow('ผู้ออก ณ ที่จ่าย :',
                                        '${paymentDetail['whIssue']}'),
                                    buildInfoRow('ผู้จัดทำ :',
                                        '${paymentDetail['createName']}'),
                                    buildInfoRow('ผู้อนุมัติ :',
                                        '${paymentDetail['approveName']}'),
                                    buildInfoRow('ผู้จ่ายเงิน :',
                                        '${paymentDetail['payName']}'),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 6, horizontal: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.7),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  children: [
                                    buildInfoRow('ผู้ Approve :',
                                        '${paymentDetail['approveTranName']}'),
                                    buildInfoRow('วันที่ Approve :',
                                        '${paymentDetail['approveDate']}'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 6),
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withValues(alpha: 0.5),
                                spreadRadius: 0.2,
                                blurRadius: 2,
                                offset: const Offset(0, 1),
                              )
                            ],
                            color: const Color.fromRGBO(226, 199, 132, 1),
                          ),
                          child: Column(
                            children: [
                              buildInfoRow('รายการ', ''),
                              if (listpaydetail.isNotEmpty)
                                for (var i = 0;
                                    i < listpaydetail.length;
                                    i++) ...[
                                  Container(
                                    decoration: BoxDecoration(
                                      color:
                                          Colors.white.withValues(alpha: 0.7),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(5),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 3, horizontal: 8),
                                      child: Column(
                                        children: [
                                          buildInfoRow('รายการ :',
                                              '${listpaydetail[i]['expenseName']}'),
                                          buildInfoRow('เอกสารอ้างอิง :',
                                              '${listpaydetail[i]['refTran']}'),
                                          buildInfoRow(
                                              'จำนวนเงิน :',
                                              formatter.format(listpaydetail[i]
                                                  ['priceAmt'])),
                                          buildInfoRow('ประเภท :',
                                              '${listpaydetail[i]['taxType']}'),
                                          buildInfoRow(
                                              'ภาษี :',
                                              formatter.format(
                                                  listpaydetail[i]['taxAmt'])),
                                          buildInfoRow(
                                              'ก่อนภาษี :',
                                              formatter.format(
                                                  listpaydetail[i]['netAmt'])),
                                          buildInfoRow('อัตรา :',
                                              '${listpaydetail[i]['whRate']}'),
                                          buildInfoRow(
                                              'จำนวนเงิน :',
                                              formatter.format(
                                                  listpaydetail[i]['whPrice'])),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5)
                                ],
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 6),
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withValues(alpha: 0.5),
                                spreadRadius: 0.2,
                                blurRadius: 2,
                                offset: const Offset(0, 1),
                              )
                            ],
                            color: const Color.fromRGBO(226, 199, 132, 1),
                          ),
                          child: Column(
                            children: [
                              buildInfoRow('รายละเอียดการจ่าย', ''),
                              if (listpayTran.isNotEmpty)
                                for (var c = 0;
                                    c < listpayTran.length;
                                    c++) ...[
                                  Container(
                                    decoration: BoxDecoration(
                                      color:
                                          Colors.white.withValues(alpha: 0.7),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(5),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 3, horizontal: 8),
                                      child: Column(
                                        children: [
                                          buildInfoRow('ประเภทการจ่าย :',
                                              '${listpayTran[c]['payTypeName']}'),
                                          buildInfoRow('เลขที่เช็ค :',
                                              '${listpayTran[c]['payTranId']}'),
                                          buildInfoRow(
                                              'จำนวนเงิน :',
                                              formatter.format(
                                                  listpayTran[c]['payTotal'])),
                                          buildInfoRow(
                                              'ค่าธรรมเนียม :',
                                              formatter.format(
                                                  listpayTran[c]['feeTotal'])),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                ],
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
