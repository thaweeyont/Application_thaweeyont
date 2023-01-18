import 'dart:convert';

import 'package:application_thaweeyont/api.dart';
import 'package:application_thaweeyont/state/authen.dart';
import 'package:application_thaweeyont/utility/my_constant.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Blacklist_Detail extends StatefulWidget {
  // const Blacklist_Detail({Key? key}) : super(key: key);
  final String? blId;
  Blacklist_Detail(this.blId);

  @override
  State<Blacklist_Detail> createState() => _Blacklist_DetailState();
}

class _Blacklist_DetailState extends State<Blacklist_Detail> {
  String userId = '', empId = '', firstName = '', lastName = '', tokenId = '';
  var status_data = false;
  List list_detail_bl = [], list_detail = [];

  @override
  void initState() {
    super.initState();
    getdata();
  }

  Future<Null> getdata() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      userId = preferences.getString('userId')!;
      empId = preferences.getString('empId')!;
      firstName = preferences.getString('firstName')!;
      lastName = preferences.getString('lastName')!;
      tokenId = preferences.getString('tokenId')!;
    });
    getData_detail_bl();
  }

  Future<void> getData_detail_bl() async {
    print(widget.blId);
    try {
      var respose = await http.post(
        Uri.parse('${api}credit/blacklistDetail'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
        body: jsonEncode(<String, String>{
          'blId': widget.blId.toString(),
        }),
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> data_detail =
            new Map<String, dynamic>.from(json.decode(respose.body));

        setState(() {
          status_data = true;
          list_detail_bl = data_detail['data'];
          list_detail = list_detail_bl[0]['detail'];
        });

        // Navigator.pop(context);
        // Navigator.pop(context);
        print('ข้อมูล => $list_detail');
      } else if (respose.statusCode == 400) {
        print(respose.statusCode);
        showProgressDialog_400(
            context, 'แจ้งเตือน', 'Error ${respose.statusCode} ไม่พบข้อมูล!');
      } else if (respose.statusCode == 401) {
        print(respose.statusCode);
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.clear();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => Authen(),
          ),
          (Route<dynamic> route) => false,
        );
        showProgressDialog_401(
            context, 'แจ้งเตือน', 'กรุณา Login เข้าสู่ระบบใหม่');
      } else if (respose.statusCode == 404) {
        print(respose.statusCode);
        showProgressDialog_404(
            context, 'แจ้งเตือน', '${respose.statusCode} ไม่พบข้อมูล!');
      } else if (respose.statusCode == 405) {
        print(respose.statusCode);
        showProgressDialog_405(context, 'แจ้งเตือน', 'ไม่พบข้อมูล!');
      } else if (respose.statusCode == 500) {
        print(respose.statusCode);
        showProgressDialog_500(
            context, 'แจ้งเตือน', '${respose.statusCode} ข้อมูลผิดพลาด!');
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'รายละเอียดข้อมูล BlackList',
          style: MyContant().TitleStyle(),
        ),
      ),
      body: status_data == false
          ? Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade400.withOpacity(0.6),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                padding: EdgeInsets.all(80),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    Text(
                      'Loading....',
                      style: MyContant().h4normalStyle(),
                    ),
                  ],
                ),
              ),
            )
          : GestureDetector(
              behavior: HitTestBehavior.opaque,
              child: ListView(
                children: [
                  if (list_detail_bl.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(162, 181, 252, 1),
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  'รหัส Blacklist : ${list_detail_bl[0]['blId']}',
                                  style: MyContant().h4normalStyle(),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text(
                                  'รหัสลูกค้า : ${list_detail_bl[0]['custId']}',
                                  style: MyContant().h4normalStyle(),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text(
                                  'เลขที่บัตรประชาชน : ${list_detail_bl[0]['smartId']}',
                                  style: MyContant().h4normalStyle(),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text(
                                  'ชื่อลูกค้า : ${list_detail_bl[0]['custName']}',
                                  style: MyContant().h4normalStyle(),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ที่อยู่ลูกค้า : ',
                                  style: MyContant().h4normalStyle(),
                                ),
                                Expanded(
                                  child: Text(
                                    '${list_detail_bl[0]['custAddress']}',
                                    style: MyContant().h4normalStyle(),
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text(
                                  'เบอร์โทรศัพท์ : ${list_detail_bl[0]['telephone']}',
                                  style: MyContant().h4normalStyle(),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text(
                                  'เบอร์มือถือ : ${list_detail_bl[0]['mobile']}',
                                  style: MyContant().h4normalStyle(),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 8, right: 8, bottom: 2),
                    child: Row(
                      children: [
                        Text(
                          'รายละเอียดของลูกค้า Blacklist',
                          style: MyContant().h2Style(),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.53,
                    child: Scrollbar(
                      child: ListView(
                        children: [
                          if (list_detail.isNotEmpty) ...[
                            for (var i = 0; i < list_detail.length; i++) ...[
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(162, 181, 252, 1),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'รายละเอียด : ',
                                            style: MyContant().h4normalStyle(),
                                          ),
                                          Expanded(
                                            child: Text(
                                              '${list_detail[i]['blDetail']}',
                                              style:
                                                  MyContant().h4normalStyle(),
                                              overflow: TextOverflow.clip,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'เลขที่สัญญา : ${list_detail[i]['signId']}',
                                            style: MyContant().h4normalStyle(),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'วันที่บันทึก : ${list_detail[i]['createDate']}',
                                            style: MyContant().h4normalStyle(),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'ฝ่ายที่บันทึก : ${list_detail[i]['createDepart']}',
                                            style: MyContant().h4normalStyle(),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'ผู้บันทึกข้อมูล : ',
                                            style: MyContant().h4normalStyle(),
                                          ),
                                          Expanded(
                                            child: Text(
                                              '${list_detail[i]['createName']}',
                                              style:
                                                  MyContant().h4normalStyle(),
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
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
