import 'dart:convert';

import 'package:application_thaweeyont/state/state_sale/credit_approval/page_check_blacklist.dart';
import 'package:application_thaweeyont/utility/my_constant.dart';
import 'package:flutter/material.dart';
import 'package:loading_gifs/loading_gifs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../api.dart';
import '../../../widgets/custom_appbar.dart';
import '../../authen.dart';
import 'credit_debtordetail.dart';
import 'data_list_quarantee.dart';

class ApproveCreditQuarantee extends StatefulWidget {
  final String? tranId;
  const ApproveCreditQuarantee(this.tranId, {super.key});

  @override
  State<ApproveCreditQuarantee> createState() => _ApproveCreditQuaranteeState();
}

class _ApproveCreditQuaranteeState extends State<ApproveCreditQuarantee> {
  String userId = '', empId = '', firstName = '', lastName = '', tokenId = '';
  bool? allowApproveStatus;
  List ListCreditquarantee = [];
  bool statusLoading = false, statusLoadNotdata = false;

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
      allowApproveStatus = preferences.getBool('allowApproveStatus');
    });
    getDataCreditQuarantee();
  }

  Future<void> getDataCreditQuarantee() async {
    try {
      var respose = await http.post(
        Uri.parse('${api}credit/approveCreditQuarantee'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
        body: jsonEncode(<String, String>{
          'tranApproveId': widget.tranId.toString(),
        }),
      );
      if (respose.statusCode == 200) {
        Map<String, dynamic> dataCreditQuarantee =
            Map<String, dynamic>.from(json.decode(respose.body));

        setState(() {
          ListCreditquarantee = dataCreditQuarantee['data'][0];
        });
        statusLoading = true;
      } else if (respose.statusCode == 400) {
        setState(() {
          statusLoadNotdata = true;
          statusLoading = true;
        });
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
          statusLoadNotdata = true;
          statusLoading = true;
        });
      } else if (respose.statusCode == 405) {
        showProgressDialog_405(
            context, 'แจ้งเตือน', 'ไม่พบข้อมูล (${respose.statusCode})');
      } else if (respose.statusCode == 500) {
        showProgressDialog_500(
            context, 'แจ้งเตือน', 'ข้อมูลผิดพลาด (${respose.statusCode})');
      } else {
        showProgressDialog(context, 'แจ้งเตือน', 'กรุณาติดต่อผู้ดูแลระบบ!');
      }
    } catch (e) {
      showProgressDialogNotdata(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
      print("ไม่มีข้อมูล $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: 'ผู้ค้ำประกัน'),
      body: statusLoading == false
          ? Center(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 24, 24, 24).withAlpha(230),
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
          : statusLoadNotdata == true
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
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              : GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  child: ListView(
                    children: [
                      const SizedBox(
                        height: 8,
                      ),
                      for (var i = 0; i < ListCreditquarantee.length; i++) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 8),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(5),
                              ),
                              color: const Color.fromRGBO(251, 173, 55, 1),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withAlpha(130),
                                  spreadRadius: 0.2,
                                  blurRadius: 2,
                                  offset: const Offset(0, 1),
                                )
                              ],
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'ผู้ค้ำที่ ${i + 1}',
                                      style: MyContant().h4normalStyle(),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                    color: Colors.white.withAlpha(180),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'รหัสลูกค้า : ${ListCreditquarantee[i]['custId']}',
                                            style: MyContant().h4normalStyle(),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'ชื่อลูกค้า : ',
                                            style: MyContant().h4normalStyle(),
                                          ),
                                          Expanded(
                                            child: Text(
                                              '${ListCreditquarantee[i]['custName']}',
                                              style:
                                                  MyContant().h4normalStyle(),
                                              overflow: TextOverflow.clip,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'บัตรประชาชน : ${ListCreditquarantee[i]['smartId']}',
                                            style: MyContant().h4normalStyle(),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'ที่อยู่ : ',
                                            style: MyContant().h4normalStyle(),
                                          ),
                                          Expanded(
                                            child: Text(
                                              '${ListCreditquarantee[i]['address']}',
                                              style:
                                                  MyContant().h4normalStyle(),
                                              overflow: TextOverflow.clip,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'เบอร์โทร : ${ListCreditquarantee[i]['tel']}',
                                            style: MyContant().h4normalStyle(),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'อาชีพ : ',
                                            style: MyContant().h4normalStyle(),
                                          ),
                                          Expanded(
                                            child: Text(
                                              '${ListCreditquarantee[i]['career']}',
                                              style:
                                                  MyContant().h4normalStyle(),
                                              overflow: TextOverflow.clip,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'สถานะทางทะเบียนบ้าน : ${ListCreditquarantee[i]['govAddrStatus']}',
                                            style: MyContant().h4normalStyle(),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'วันเกิด : ${ListCreditquarantee[i]['birthDate']}',
                                            style: MyContant().h4normalStyle(),
                                          ),
                                          Text(
                                            'อายุ : ${ListCreditquarantee[i]['age']} ปี',
                                            style: MyContant().h4normalStyle(),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                if (allowApproveStatus == true) ...[
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.08,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 4),
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(5),
                                      ),
                                      color: Colors.white.withAlpha(180),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: SizedBox(
                                                height: 35,
                                                // width: 112,
                                                child: ElevatedButton(
                                                  style: MyContant()
                                                      .myButtonQuaranteeStyle(),
                                                  onPressed: () {
                                                    if (ListCreditquarantee[i]
                                                                ['custId'] !=
                                                            "" &&
                                                        ListCreditquarantee[i]
                                                                ['custId'] !=
                                                            "NO") {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              CreditDebtorDetail(
                                                                  ListCreditquarantee[
                                                                          i][
                                                                      'custId']),
                                                        ),
                                                      );
                                                    }
                                                  },
                                                  child: FittedBox(
                                                    fit: BoxFit.scaleDown,
                                                    child: const Text(
                                                        'ตรวจสอบหนี้สิน'),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: SizedBox(
                                                height: 35,
                                                // width: 112,
                                                child: ElevatedButton(
                                                  style: MyContant()
                                                      .myButtonQuaranteeStyle(),
                                                  onPressed: () {
                                                    if (ListCreditquarantee[i]
                                                                ['custId'] !=
                                                            "" &&
                                                        ListCreditquarantee[i]
                                                                ['custId'] !=
                                                            "NO") {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              DataListQuarantee(
                                                            ListCreditquarantee[
                                                                i]['custId'],
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                  },
                                                  child: FittedBox(
                                                    fit: BoxFit.scaleDown,
                                                    child: const Text(
                                                        'รายละเอียดผู้ค้ำ'),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: SizedBox(
                                                height: 35,
                                                // width: 112,
                                                child: ElevatedButton(
                                                  style: MyContant()
                                                      .myButtonQuaranteeStyle(),
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            Page_Check_Blacklist(
                                                                ListCreditquarantee[
                                                                        i][
                                                                    'smartId']),
                                                      ),
                                                    );
                                                  },
                                                  child: FittedBox(
                                                    fit: BoxFit.scaleDown,
                                                    child: const Text(
                                                        'เช็ค Blacklist'),
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
                              ],
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
    );
  }
}
