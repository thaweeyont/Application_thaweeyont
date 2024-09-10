import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:loading_gifs/loading_gifs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../utility/my_constant.dart';
import '../../../widgets/custom_appbar.dart';
import '../../authen.dart';
import 'package:application_thaweeyont/api.dart';

class Pay_installment extends StatefulWidget {
  var signId, list_payDetail;
  List<dynamic> period;
  Pay_installment(this.signId, this.list_payDetail, this.period, {Key? key})
      : super(key: key);

  @override
  State<Pay_installment> createState() => _Pay_installmentState();
}

class _Pay_installmentState extends State<Pay_installment> {
  String userId = '', empId = '', firstName = '', lastName = '', tokenId = '';
  String dropdownValue = '1';
  var payDetail, debtorStatuscode;
  bool statusLoading200 = false, statusLoad404 = false;
  List datapayDetail = [];
  List<String> datalist = [];

  @override
  void initState() {
    super.initState();
    getdata();
    setListdropdown();
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
    getDataPayDetail(widget.signId, widget.list_payDetail);
  }

  setListdropdown() {
    List<dynamic> no = widget.period.map((e) => e["periodNo"]).toList();
    for (var element in no) {
      datalist.add(element);
    }
    setState(() {
      datalist = datalist;
      dropdownValue =
          datalist.firstWhere((element) => element == widget.list_payDetail);
    });
  }

  Future<void> getDataPayDetail(signId, String period) async {
    try {
      var respose = await http.post(
        Uri.parse('${api}debtor/payDetail'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
        body: jsonEncode(<String, String>{
          'signId': signId,
          'periodId': period,
        }),
      );

      if (respose.statusCode == 200) {
        payDetail = '';
        Map<String, dynamic> dataPayDetail =
            Map<String, dynamic>.from(json.decode(respose.body));

        setState(() {
          datapayDetail = dataPayDetail['data'];
          statusLoading200 = true;
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
          statusLoading200 = true;
          statusLoad404 = true;
        });
      } else if (respose.statusCode == 405) {
        showProgressDialog_405(
            context, 'แจ้งเตือน', 'ไม่พบข้อมูล (${respose.statusCode})');
      } else if (respose.statusCode == 500) {
        showProgressDialog_500(
            context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด (${respose.statusCode})');
      } else {
        showProgressDialog(context, 'แจ้งเตือน', 'กรุณาติดต่อผู้ดูแลระบบ!');
      }
    } catch (e) {
      print("ไม่มีข้อมูล $e");
      showProgressDialog_Notdata(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
  }

  @override
  Widget build(BuildContext context) {
    const sizeIcon = BoxConstraints(minWidth: 20, minHeight: 20);
    const border = OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.transparent,
        width: 0,
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(4.0),
      ),
    );
    return Scaffold(
      appBar: const CustomAppbar(title: 'รายการชำระค่างวด'),
      body: Column(
        children: [
          const SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
                color: const Color.fromRGBO(255, 203, 246, 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 0.2,
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'งวดที่ : ',
                    style: MyContant().h4normalStyle(),
                  ),
                  inputPayInstallment(sizeIcon, border),
                ],
              ),
            ),
          ),
          Expanded(
            child: statusLoading200 == false
                ? Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 24, 24, 24)
                            .withOpacity(0.9),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 30),
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
                        child: Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          height: MediaQuery.of(context).size.height * 0.15,
                          child: Column(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'images/Nodata.png',
                                        width: 55,
                                        height: 55,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'ไม่พบรายการข้อมูล',
                                        style: MyContant().h5NotData(),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    : ListView(
                        shrinkWrap: true,
                        children: [
                          for (var i = 0; i < datapayDetail.length; i++) ...[
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 6, bottom: 2, left: 8, right: 8),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(255, 203, 246, 1),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 0.2,
                                      blurRadius: 2,
                                      offset: const Offset(0, 1),
                                    )
                                  ],
                                ),
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    const SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'งวดที่ : $dropdownValue',
                                          style: MyContant().h4normalStyle(),
                                        ),
                                        Text(
                                          'วันที่ใบเสร็จ : ${datapayDetail[i]['payDate']}',
                                          style: MyContant().h4normalStyle(),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.2,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.7),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'เลขที่ใบเสร็จ : ${datapayDetail[i]['receiptTranId']}',
                                                  style: MyContant()
                                                      .h4normalStyle(),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'จำนวนเงิน : ${datapayDetail[i]['payPrice']}',
                                                  style: MyContant()
                                                      .h4normalStyle(),
                                                ),
                                                Text(
                                                  'ค่าปรับ : ${datapayDetail[i]['payFine']}',
                                                  style: MyContant()
                                                      .h4normalStyle(),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    'ประเภทการรับ : ${datapayDetail[i]['payBy']}',
                                                    style: MyContant()
                                                        .h4normalStyle(),
                                                    overflow: TextOverflow.clip,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                          const SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
          ),
        ],
      ),
    );
  }

  Expanded inputPayInstallment(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: MediaQuery.of(context).size.width * 0.08,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: Padding(
            padding: const EdgeInsets.only(left: 5),
            child: DropdownButton(
              items: datalist
                  .map((value) => DropdownMenuItem(
                        value: value,
                        child: Text(
                          value,
                          style: MyContant().textInputStyle(),
                        ),
                      ))
                  .toList(),
              onChanged: (String? newValue) {
                setState(() {
                  dropdownValue = newValue!;
                  statusLoading200 = false;
                  statusLoad404 = false;
                  getDataPayDetail(widget.signId, dropdownValue);
                });
              },
              value: dropdownValue,
              isExpanded: true,
              underline: const SizedBox(),
              hint: Align(
                child: Text(
                  '',
                  style: MyContant().TextInputSelect(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
