import 'dart:convert';

import 'package:application_thaweeyont/state/state_credit/credit_approval/page_check_blacklist.dart';
import 'package:application_thaweeyont/utility/my_constant.dart';
import 'package:flutter/material.dart';
import 'package:loading_gifs/loading_gifs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../api.dart';
import '../../authen.dart';
import 'credit_debtordetail.dart';
import 'data_list_quarantee.dart';

class ApproveCreditQuarantee extends StatefulWidget {
  // const ApproveCreditQuarantee({Key? key}) : super(key: key);
  final String? tranId;
  ApproveCreditQuarantee(this.tranId);

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
    print('tranId>>${widget.tranId}');
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
        print('data>>${ListCreditquarantee}');
      } else if (respose.statusCode == 400) {
        print(respose.statusCode);
        setState(() {
          statusLoadNotdata = true;
          statusLoading = true;
        });
        // showProgressDialog_400(
        //     context, 'แจ้งเตือน', 'ไม่พบข้อมูล (${respose.statusCode})');
      } else if (respose.statusCode == 401) {
        print(respose.statusCode);
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
        print(respose.statusCode);
        setState(() {
          statusLoadNotdata = true;
          statusLoading = true;
        });
        // showProgressDialog_404(context, 'แจ้งเตือน', 'ไม่พบข้อมูลที่ค้นหา');
      } else if (respose.statusCode == 405) {
        print(respose.statusCode);
        showProgressDialog_405(
            context, 'แจ้งเตือน', 'ไม่พบข้อมูล (${respose.statusCode})');
      } else if (respose.statusCode == 500) {
        print(respose.statusCode);
        showProgressDialog_500(
            context, 'แจ้งเตือน', 'ข้อมูลผิดพลาด (${respose.statusCode})');
      } else {
        print(respose.statusCode);
        showProgressDialog(context, 'แจ้งเตือน', 'กรุณาติดต่อผู้ดูแลระบบ!');
      }
    } catch (e) {
      showProgressDialog_Notdata(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
      print("ไม่มีข้อมูล $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'ผู้ค้ำประกัน',
          style: MyContant().TitleStyle(),
        ),
      ),
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
                    // CircularProgressIndicator(),
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
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                              color: Color.fromRGBO(251, 173, 55, 1),
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
                                    color: Colors.white.withOpacity(0.7),
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
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(5),
                                      ),
                                      color: Colors.white.withOpacity(0.7),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: 35,
                                              width: 112,
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
                                                        ));
                                                    print('Yes');
                                                  } else {
                                                    print('No');
                                                  }
                                                },
                                                child: const Text(
                                                    'ตรวจสอบหนี้สิน'),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            SizedBox(
                                              height: 35,
                                              width: 112,
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
                                                          ListCreditquarantee[i]
                                                              ['custId'],
                                                        ),
                                                      ),
                                                    );
                                                    print('Yes');
                                                  } else {
                                                    print('No');
                                                  }
                                                },
                                                child: const Text(
                                                    'รายละเอียดผู้ค้ำ'),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            SizedBox(
                                              height: 35,
                                              width: 112,
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
                                                                      i]
                                                                  ['smartId']),
                                                    ),
                                                  );
                                                },
                                                child: const Text(
                                                    'เช็ค Blacklist'),
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
