import 'dart:convert';

import 'package:application_thaweeyont/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:loading_gifs/loading_gifs.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api.dart';
import '../../utility/my_constant.dart';
import '../authen.dart';
import 'package:http/http.dart' as http;

import 'mechanicaldetail.dart';

class MechanicalList extends StatefulWidget {
  final String? changeDate, saleTranId, workReqTranId;
  const MechanicalList(this.changeDate, this.saleTranId, this.workReqTranId,
      {super.key});

  @override
  State<MechanicalList> createState() => _MechanicalListState();
}

class _MechanicalListState extends State<MechanicalList> {
  String userId = '', empId = '', firstName = '', lastName = '', tokenId = '';
  bool statusLoading = false, statusLoad404 = false;
  List workReqList = [];
  var listdata;

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
    workRequestList();
  }

  Future<void> workRequestList() async {
    try {
      var respose = await http.post(
        Uri.parse('${api}sev/workRequestList'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
        body: jsonEncode(
          <String, String>{
            'saleTranId': widget.saleTranId.toString(),
            'workReqTranId': widget.workReqTranId.toString(),
            'requestDate': widget.changeDate.toString(),
            'page': '1',
            'limit': '100'
          },
        ),
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> dataworklist =
            Map<String, dynamic>.from(json.decode(respose.body));

        listdata = dataworklist['data'];
        setState(() {
          workReqList = listdata;
          statusLoading = true;
        });
      } else if (respose.statusCode == 400) {
        showProgressDialog_400(context, 'แจ้งเตือน', 'ละติจูด ลองติจูด ซ้ำ');
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
          statusLoad404 = true;
          statusLoading = true;
        });
        // showProgressDialog_404(context, 'แจ้งเตือน', 'เกืดข้อผิดพลาด');
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
      appBar: const CustomAppbar(title: 'รายการที่ค้นหา'),
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
                    const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(cupertinoActivityIndicator, scale: 4),
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
              : ListView(
                  children: [
                    const SizedBox(height: 10),
                    for (var i = 0; i < workReqList.length; i++)
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MechanicalDetail(
                                workReqList[i]['workReqTranId'],
                              ),
                            ),
                          ).then((value) => getdata());
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 8),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 241, 209, 89),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withAlpha(130),
                                      spreadRadius: 0.5,
                                      blurRadius: 2,
                                      offset: const Offset(0, 1),
                                    )
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'เลขที่ใบเปิด Job : ${workReqList[i]['jobTranId']}',
                                          style: MyContant().h6Style(),
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        if (workReqList[i]['jobTranId'] !=
                                            workReqList[i]
                                                ['workReqTranId']) ...[
                                          Text(
                                            'เลขที่ใบขอช่าง : ${workReqList[i]['workReqTranId']}',
                                            style: MyContant().h6Style(),
                                          ),
                                        ] else ...[
                                          Text(
                                            'เลขที่ใบขอช่าง : - ',
                                            style: MyContant().h6Style(),
                                          ),
                                        ],
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        Text(
                                          'เลขที่ใบขาย : ${workReqList[i]['saleTranId']}',
                                          style: MyContant().h6Style(),
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'ชื่อ-สกุล : ',
                                          style: MyContant().h6Style(),
                                        ),
                                        Expanded(
                                          child: Text(
                                            '${workReqList[i]['custName']}',
                                            style: MyContant().h6Style(),
                                            overflow: TextOverflow.clip,
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'วันที่จัดส่ง : ',
                                          style: MyContant().h6Style(),
                                        ),
                                        Expanded(
                                          child: Text(
                                            '${workReqList[i]['sendDateTime']}',
                                            style: MyContant().h6Style(),
                                            overflow: TextOverflow.clip,
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'ช่างติดตั้ง : ',
                                          style: MyContant().h6Style(),
                                        ),
                                        if (workReqList[i]['empName']
                                                .toString() !=
                                            "[]") ...[
                                          Expanded(
                                            child: Text(
                                              '${workReqList[i]['empName'][0]}',
                                              style: MyContant().h6Style(),
                                              overflow: TextOverflow.clip,
                                            ),
                                          ),
                                        ] else ...[
                                          Expanded(
                                            child: Text(
                                              ' ',
                                              style: MyContant().h6Style(),
                                              overflow: TextOverflow.clip,
                                            ),
                                          ),
                                        ]
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: 10),
                  ],
                ),
    );
  }
}
