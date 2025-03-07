import 'dart:convert';

import 'package:application_thaweeyont/api.dart';
import 'package:application_thaweeyont/state/authen.dart';
import 'package:application_thaweeyont/utility/my_constant.dart';
import 'package:application_thaweeyont/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../widgets/endpage.dart';
import '../../../widgets/loaddata.dart';
import 'page_datacust_approve.dart';
import 'package:loading_gifs/loading_gifs.dart';

class Credit_data_detail extends StatefulWidget {
  final String? custId,
      idcard,
      custName,
      lastname_cust,
      signrunning,
      select_branchlist,
      start_date,
      end_date;
  final int? selectIndexApprove;
  const Credit_data_detail(
      this.custId,
      this.idcard,
      this.custName,
      this.lastname_cust,
      this.signrunning,
      this.select_branchlist,
      this.start_date,
      this.end_date,
      this.selectIndexApprove,
      {super.key});

  @override
  State<Credit_data_detail> createState() => _Credit_data_detailState();
}

class _Credit_data_detailState extends State<Credit_data_detail> {
  String userId = '', empId = '', firstName = '', lastName = '', tokenId = '';
  List list_approve = [];
  var status_loading = false;
  bool status_load404 = false, isLoad = false, isLoadendPage = false;
  final scrollControll = TrackingScrollController();
  int offset = 30, stquery = 0;

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
    if (mounted) {
      setState(() {
        getDataApprove(offset);
      });
    }
    myScroll(scrollControll, offset);
  }

  void myScroll(ScrollController scrollControll, int offset) {
    scrollControll.addListener(() async {
      if (scrollControll.position.pixels ==
          scrollControll.position.maxScrollExtent) {
        setState(() {
          isLoad = true;
        });
        await Future.delayed(const Duration(seconds: 1), () {
          offset = offset + 10;
          getDataApprove(offset);
        });
      }
    });
  }

  Future<void> getDataApprove(offset) async {
    try {
      var respose = await http.post(
        Uri.parse('${api}credit/approve'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
        body: jsonEncode(<String, String>{
          'custId': widget.custId.toString(),
          'smartId': widget.idcard.toString(),
          'firstName': widget.custName.toString(),
          'lastName': widget.lastname_cust.toString(),
          'signRunning': widget.signrunning.toString(),
          'branchId': widget.select_branchlist.toString(),
          'startDate': widget.start_date.toString(),
          'endDate': widget.end_date.toString(),
          'approveStatus': widget.selectIndexApprove.toString(),
          'page': '1',
          'limit': '$offset'
        }),
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> dataApprove =
            Map<String, dynamic>.from(json.decode(respose.body));

        setState(() {
          list_approve = dataApprove['data'];
        });
        status_loading = true;
        isLoad = false;
        if (stquery > 0) {
          if (offset > list_approve.length) {
            isLoadendPage = true;
          }
          stquery = 1;
        } else {
          stquery = 1;
        }
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
          status_loading = true;
          status_load404 = true;
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
      appBar: const CustomAppbar(
        title: 'รายการที่ค้นหา',
      ),
      body: status_loading == false
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
                  child: SingleChildScrollView(
                    controller: scrollControll,
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    child: Column(
                      children: [
                        if (list_approve.isNotEmpty) ...[
                          for (var i = 0; i < list_approve.length; i++) ...[
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Data_Cust_Approve(
                                      list_approve[i]['custId'],
                                      list_approve[i]['tranId'],
                                    ),
                                  ),
                                ).then((_) => getdata());
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withAlpha(130),
                                        spreadRadius: 0.2,
                                        blurRadius: 2,
                                        offset: const Offset(0, 1),
                                      )
                                    ],
                                    color:
                                        const Color.fromRGBO(251, 173, 55, 1),
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
                                            'รันนิ่งสัญญา : ${list_approve[i]['signRunning']}',
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
                          if (isLoad == true && isLoadendPage == false) ...[
                            const LoadData(),
                          ] else if (isLoadendPage == true) ...[
                            const EndPage(),
                          ],
                          const SizedBox(
                            height: 30,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
    );
  }
}
