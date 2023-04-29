import 'dart:convert';

import 'package:application_thaweeyont/api.dart';
import 'package:application_thaweeyont/state/authen.dart';
import 'package:application_thaweeyont/utility/my_constant.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'page_datacust_approve.dart';
import 'package:loading_gifs/loading_gifs.dart';

class Credit_data_detail extends StatefulWidget {
  // const Credit_data_detail({Key? key}) : super(key: key);
  final String? custId,
      idcard,
      custName,
      lastname_cust,
      select_branchlist,
      start_date,
      end_date;
  final int? select_index_approve;
  Credit_data_detail(
      this.custId,
      this.idcard,
      this.custName,
      this.lastname_cust,
      this.select_branchlist,
      this.start_date,
      this.end_date,
      this.select_index_approve);

  @override
  State<Credit_data_detail> createState() => _Credit_data_detailState();
}

class _Credit_data_detailState extends State<Credit_data_detail> {
  String userId = '', empId = '', firstName = '', lastName = '', tokenId = '';
  List list_approve = [];
  var status_loading = false;
  bool status_load404 = false;

  @override
  void initState() {
    // TODO: implement initState
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
    getData_approve();
  }

  Future<void> getData_approve() async {
    try {
      var respose = await http.post(
        Uri.parse('${beta_api_test}credit/approve'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
        body: jsonEncode(<String, String>{
          'custId': widget.custId.toString(),
          'smartId': widget.idcard.toString(),
          'firstName': widget.custName.toString(),
          'lastName': widget.lastname_cust.toString(),
          'branchId': widget.select_branchlist.toString(),
          'startDate': widget.start_date.toString(),
          'endDate': widget.end_date.toString(),
          'approveStatus': widget.select_index_approve.toString(),
          'page': '1',
          'limit': '80'
        }),
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> data_approve =
            new Map<String, dynamic>.from(json.decode(respose.body));

        setState(() {
          list_approve = data_approve['data'];
        });
        status_loading = true;
      } else if (respose.statusCode == 400) {
        print(respose.statusCode);
        showProgressDialog_400(
            context, 'แจ้งเตือน', 'ไม่พบข้อมูล (${respose.statusCode})');
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
        setState(() {
          status_loading = true;
          status_load404 = true;
          print('>>$status_load404');
        });
        print(respose.statusCode);
        // showDialog_404_approve(context, 'แจ้งเตือน', 'ไม่พบรายการข้อมูล');
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
        showProgressDialog(context, 'แจ้งเตือน', 'กรุณาติดต่อผู้ดูแลระบบ');
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
          'รายการที่ค้นหา',
          style: MyContant().TitleStyle(),
        ),
      ),
      body: status_loading == false
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
          : status_load404 == true
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
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Scrollbar(
                    child: ListView(
                      children: [
                        if (list_approve.isNotEmpty) ...[
                          for (var i = 0; i < list_approve.length; i++) ...[
                            InkWell(
                              onTap: () {
                                // String refresh = await
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Data_Cust_Approve(
                                        list_approve[i]['custId'],
                                        list_approve[i]['tranId'],
                                        widget.custId.toString(),
                                        widget.idcard.toString(),
                                        widget.custName.toString(),
                                        widget.lastname_cust.toString(),
                                        widget.select_branchlist.toString(),
                                        widget.start_date.toString(),
                                        widget.end_date.toString(),
                                        widget.select_index_approve),
                                  ),
                                ).then((_) => getdata());
                                // if (refresh == 'refresh') {
                                //   setState(() {
                                //     print('refresh data');
                                //     getdata();
                                //   });
                                // }
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    color: Color.fromRGBO(251, 173, 55, 1),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'สาขา : ${list_approve[i]['branchName']}',
                                            style: MyContant().h4normalStyle(),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'เลขที่เอกสาร : ${list_approve[i]['tranId']}',
                                            style: MyContant().h4normalStyle(),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'วันที่ : ${list_approve[i]['tranDate']}',
                                            style: MyContant().h4normalStyle(),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'ชื่อ : ',
                                            style: MyContant().h4normalStyle(),
                                          ),
                                          Expanded(
                                            child: Text(
                                              '${list_approve[i]['custName']}',
                                              overflow: TextOverflow.clip,
                                              style:
                                                  MyContant().h4normalStyle(),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'สถานะ : ${list_approve[i]['approveStatus']}',
                                            style: MyContant().h4normalStyle(),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ],
                      ],
                    ),
                  ),
                ),
    );
  }
}
