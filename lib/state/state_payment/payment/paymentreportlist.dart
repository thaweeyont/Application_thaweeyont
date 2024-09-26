import 'dart:convert';

import 'package:application_thaweeyont/state/state_payment/payment/paymentdetail.dart';
import 'package:application_thaweeyont/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_gifs/loading_gifs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../api.dart';
import '../../../utility/my_constant.dart';
import '../../authen.dart';

class PaymentReportList extends StatefulWidget {
  final String? selectBranchlist,
      startdate,
      enddate,
      selectSupplylist,
      supplyName,
      selectEmployeelist,
      paydetail,
      valueStartDate,
      valueEndDate,
      selectpaymentTypelist;
  const PaymentReportList(
      this.selectBranchlist,
      this.startdate,
      this.enddate,
      this.selectSupplylist,
      this.supplyName,
      this.selectEmployeelist,
      this.paydetail,
      this.selectpaymentTypelist,
      this.valueStartDate,
      this.valueEndDate,
      {super.key});

  @override
  State<PaymentReportList> createState() => _PaymentReportListState();
}

class _PaymentReportListState extends State<PaymentReportList> {
  String userId = '', empId = '', firstName = '', lastName = '', tokenId = '';
  double totalAmount = 0;
  var total = 0.0, totalPrice, newPaymentType;
  bool statusLoading = false, statusLoad404 = false;
  List listPayment = [];
  List<dynamic> listPrice = [];
  String convertStartDate = '',
      convertEndDate = '',
      newStartDate = '',
      newEndDate = '';
  bool isCheckAll = false; // ตัวแปรสำหรับ CheckBox All
  List<bool> isCheckedList = []; // ตัวแปรสำหรับเช็คบ็อกซ์รายการแต่ละอัน
  List<Map<String, dynamic>> selectedPayments = [];

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
    convertDate();
  }

// ฟังก์ชันสำหรับเลือกหรือยกเลิก CheckBox All
  void toggleCheckAll(bool? value) {
    setState(() {
      isCheckAll = value ?? false;
      for (int i = 0; i < isCheckedList.length; i++) {
        isCheckedList[i] = isCheckAll;
        if (isCheckAll) {
          selectedPayments = List.from(listPayment);
        } else {
          selectedPayments.clear();
        }
        sendSelectedPayments();
      }
    });
  }

// ฟังก์ชันสำหรับเลือกหรือยกเลิกเช็คบ็อกซ์แต่ละรายการ
  void toggleCheckItem(int index, bool? value) {
    setState(() {
      isCheckedList[index] = value ?? false;
      if (isCheckedList[index]) {
        selectedPayments.add(listPayment[index]);
      } else {
        selectedPayments.removeWhere(
          (item) =>
              item['paymentTranId'] == listPayment[index]['paymentTranId'],
        );
      }
    });
    sendSelectedPayments();
    // print('index>$index');
    // print('value>${isCheckedList[index]}');
  }

  // ฟังก์ชันสำหรับส่งข้อมูลทั้งหมดที่เลือก
  void sendSelectedPayments() {
    if (selectedPayments.isNotEmpty) {
      // ส่งหรือใช้งานค่าที่เก็บไว้ทั้งหมดใน selectedPayments
      for (var payment in selectedPayments) {
        print('----------v');
        print('เลขที่ใบจ่าย: ${payment['paymentTranId']}');
        print('วันที่จ่าย: ${payment['payDate']}');
        print('รายละเอียดการจ่าย: ${payment['payDetail']}');
        print('จำนวนเงิน: ${payment['payPrice']}');
      }
    } else {
      print('ไม่มีข้อมูลที่เลือก');
    }
  }

  var formatter = NumberFormat('#,##0.00'); // รูปแบบที่แสดงทศนิยม 2 ตำแหน่ง

  void convertDate() {
    convertStartDate = '${widget.startdate}';
    convertEndDate = '${widget.enddate}';

    // Remove the hyphens from start date
    String formattedStartDate = convertStartDate.replaceAll('-', '');

    // Rearrange start date to DD/MM/YYYY
    String sDay = formattedStartDate.substring(6, 8);
    String sMonth = formattedStartDate.substring(4, 6);
    String sYear = formattedStartDate.substring(0, 4);
    newStartDate = '$sDay/$sMonth/$sYear';

    if (convertEndDate.isNotEmpty) {
      // Remove the hyphens from end date
      String formattedEndDate = convertEndDate.replaceAll('-', '');

      // Rearrange end date to DD/MM/YYYY
      String eDay = formattedEndDate.substring(6, 8);
      String eMonth = formattedEndDate.substring(4, 6);
      String eYear = formattedEndDate.substring(0, 4);
      newEndDate = '$eDay/$eMonth/$eYear';
    }
  }

  Future<void> getPaymentList() async {
    widget.selectpaymentTypelist != null
        ? newPaymentType = widget.selectpaymentTypelist
        : newPaymentType = '';
    print(
        '1<${widget.selectBranchlist}> 2<${widget.selectSupplylist}> 3<${widget.valueStartDate}> 4<${widget.valueEndDate}> 5<${widget.selectEmployeelist}> 6<${widget.paydetail}> 7<$newPaymentType> 8<${widget.supplyName}>');
    try {
      var respose = await http.post(
        Uri.parse('${api}payment/list'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
        body: jsonEncode(<String, String>{
          'branchId': widget.selectBranchlist.toString(),
          'startDate': widget.valueStartDate.toString(),
          'endDate': widget.valueEndDate.toString(),
          'supplyId': widget.selectSupplylist.toString(),
          'supplyName': widget.supplyName.toString(),
          'payerId': widget.selectEmployeelist.toString(),
          'payDetail': widget.paydetail.toString(),
          'payTypeId': newPaymentType.toString(),
          'page': '1',
          'limit': '100'
        }),
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> dataPayment =
            Map<String, dynamic>.from(json.decode(respose.body));

        setState(() {
          listPayment = dataPayment['data'];
          isCheckedList = List<bool>.filled(listPayment.length, false);
        });

        statusLoading = true;
        toatalAmount();
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
      showProgressDialog_Notdata(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
  }

  void toatalAmount() {
    // รวมค่าของ payPrice ทั้งหมดและแปลงเป็น double พร้อมคำนวณ total ในขั้นตอนเดียว
    total = listPayment
        .map((e) => double.parse(e['payPrice'].toString()))
        .fold(0.0, (sum, element) => sum + element);

    // ฟอร์แมตผลรวม
    totalPrice = NumberFormat('###,###.00', 'en_US').format(total);
  }

  // void toatalAmount() {
  //   List amountTotal = listPayment.map((e) => e['payPrice']).toList();
  //   listPrice.clear();
  //   for (var element in amountTotal) {
  //     listPrice.add(element);
  //   }
  //   total = 0.0;
  //   for (var c = 0; c < listPrice.length; c++) {
  //     total += double.parse(listPrice[c].toString());
  //   }
  //   var f = NumberFormat('###,###.00', 'en_US');
  //   totalPrice = f.format(total);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: 'รายงานการจ่ายเงิน'),
      body: statusLoading == false
          ? Center(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 24, 24, 24).withOpacity(0.9),
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
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
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
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 8),
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
                                    'วันที่ $newStartDate${newEndDate.isNotEmpty ? ' - $newEndDate' : ''}',
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
                      padding:
                          const EdgeInsets.only(left: 8, right: 8, bottom: 6),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
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
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      //CheckBoxAll
                                      Checkbox(
                                        value: isCheckAll,
                                        onChanged: toggleCheckAll,
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 3),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8, right: 8, bottom: 6),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
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
                                  if (listPayment.isNotEmpty) ...[
                                    for (var i = 0;
                                        i < listPayment.length;
                                        i++) ...[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 4),
                                        child: Row(
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.all(0.5),
                                              decoration: BoxDecoration(
                                                color: Colors.white
                                                    .withOpacity(0.7),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      //CheckBoxList
                                                      Checkbox(
                                                        value: isCheckedList[i],
                                                        onChanged:
                                                            (bool? value) {
                                                          setState(() {
                                                            toggleCheckItem(
                                                                i, value);
                                                          });
                                                        },
                                                        materialTapTargetSize:
                                                            MaterialTapTargetSize
                                                                .shrinkWrap,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 3),
                                            Expanded(
                                              child: InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          PaymentDetail(
                                                              listPayment[i][
                                                                  'paymentTranId']),
                                                    ),
                                                  );
                                                },
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white
                                                        .withOpacity(0.7),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            listPayment[i]
                                                                ['payDate'],
                                                            style: MyContant()
                                                                .h5normalStyle(),
                                                          ),
                                                          Expanded(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          8.0),
                                                              child: Text(
                                                                listPayment[i][
                                                                    'payDetail'],
                                                                style: MyContant()
                                                                    .h4normalStyle(),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            ),
                                                          ),
                                                          Text(
                                                            formatter.format(
                                                                listPayment[i][
                                                                    'payPrice']),
                                                            style: MyContant()
                                                                .h5normalStyle(),
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
                                    ],
                                  ],
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
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
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 8),
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
                                          'รวมทั้งหมด $totalPrice',
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
                  ],
                ),
    );
  }
}
