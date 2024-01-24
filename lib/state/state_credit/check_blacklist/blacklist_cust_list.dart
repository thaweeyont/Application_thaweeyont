import 'dart:convert';

import 'package:application_thaweeyont/api.dart';
import 'package:application_thaweeyont/state/authen.dart';
import 'package:application_thaweeyont/state/state_credit/check_blacklist/blacklist_detail_data.dart';
import 'package:application_thaweeyont/utility/my_constant.dart';
import 'package:flutter/material.dart';
import 'package:loading_gifs/loading_gifs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../widgets/endpage.dart';
import '../../../widgets/loaddata.dart';

class Blacklist_cust_list extends StatefulWidget {
  final String? idblacklist,
      smartId,
      name,
      lastname,
      home_no,
      moo_no,
      districtId,
      selectValue_amphoe,
      selectValue_province;
  const Blacklist_cust_list(
      this.idblacklist,
      this.smartId,
      this.name,
      this.lastname,
      this.home_no,
      this.moo_no,
      this.districtId,
      this.selectValue_amphoe,
      this.selectValue_province,
      {Key? key})
      : super(key: key);

  @override
  State<Blacklist_cust_list> createState() => _Blacklist_cust_listState();
}

class _Blacklist_cust_listState extends State<Blacklist_cust_list> {
  String userId = '', empId = '', firstName = '', lastName = '', tokenId = '';
  List list_data_blacklist = [];
  bool statusLoading = false,
      statusLoad404 = false,
      isLoad = false,
      isLoadendPage = false;
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
        getDataBlacklist(offset);
      });
    }
    myScroll(scrollControll, offset);
  }

  void myScroll(scrollControll, offset) {
    scrollControll.addListener(() async {
      if (scrollControll.position.pixels ==
          scrollControll.position.maxScrollExtent) {
        setState(() {
          isLoad = true;
        });
        await Future.delayed(const Duration(seconds: 1), () {
          offset = offset + 10;
          getDataBlacklist(offset);
        });
      }
    });
  }

  Future<void> getDataBlacklist(offset) async {
    var tumbol, amphur, province;

    if (widget.districtId == null) {
      tumbol = '';
      amphur = '';
      province = '';
    } else {
      tumbol = widget.districtId;
      amphur = widget.selectValue_amphoe.toString().split("_")[0];
      province = widget.selectValue_province.toString().split("_")[0];
    }

    try {
      var respose = await http.post(
        Uri.parse('${api}credit/checkBlacklist'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
        body: jsonEncode(<String, String>{
          'blId': widget.idblacklist.toString(),
          'smartId': widget.smartId.toString(),
          'firstName': widget.name.toString(),
          'lastName': widget.lastname.toString(),
          'homeNo': widget.home_no.toString(),
          'moo': widget.moo_no.toString(),
          'tumbolId': tumbol.toString(),
          'amphurId': amphur.toString(),
          'provId': province.toString(),
        }),
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> data_blacklist =
            Map<String, dynamic>.from(json.decode(respose.body));

        setState(() {
          list_data_blacklist = data_blacklist['data'];
        });
        statusLoading = true;
        isLoad = false;
        if (stquery > 0) {
          if (offset > list_data_blacklist.length) {
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
          statusLoad404 = true;
          statusLoading = true;
        });
      } else if (respose.statusCode == 405) {
        showProgressDialog_405(
            context, 'แจ้งเตือน', 'ไม่พบข้อมูล (${respose.statusCode})');
      } else if (respose.statusCode == 500) {
        showProgressDialog_500(
            context, 'แจ้งเตือน', 'ข้อมูลผิดพลาด! (${respose.statusCode})');
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
          'รายการที่ค้นหา',
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
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    controller: scrollControll,
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    child: Column(
                      children: [
                        if (list_data_blacklist.isNotEmpty) ...[
                          for (var i = 0;
                              i < list_data_blacklist.length;
                              i++) ...[
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Blacklist_Detail(
                                        list_data_blacklist[i]['blId']),
                                  ),
                                );
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color:
                                        const Color.fromRGBO(162, 181, 252, 1),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(5),
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
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'รหัสลูกค้า : ${list_data_blacklist[i]['blId']}',
                                            style: MyContant().h4normalStyle(),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'ชื่อลูกค้า : ${list_data_blacklist[i]['custName']}',
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
                                              '${list_data_blacklist[i]['custAddress']}',
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
                                            'สถานะ : ${list_data_blacklist[i]['blStatus']}',
                                            style: MyContant().h4normalStyle(),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                          if (isLoad == true && isLoadendPage == false) ...[
                            const LoadData(),
                          ] else if (isLoadendPage == true) ...[
                            const EndPage(),
                          ],
                          const SizedBox(
                            height: 35,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
    );
  }
}
