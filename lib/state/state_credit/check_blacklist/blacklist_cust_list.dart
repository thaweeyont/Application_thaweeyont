import 'dart:convert';

import 'package:application_thaweeyont/api.dart';
import 'package:application_thaweeyont/state/authen.dart';
import 'package:application_thaweeyont/state/state_credit/check_blacklist/blacklist_detail_data.dart';
import 'package:application_thaweeyont/utility/my_constant.dart';
import 'package:flutter/material.dart';
import 'package:loading_gifs/loading_gifs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Blacklist_cust_list extends StatefulWidget {
  // const Blacklist_cust_list({Key? key}) : super(key: key);
  final String? idblacklist,
      smartId,
      name,
      lastname,
      home_no,
      moo_no,
      districtId,
      selectValue_amphoe,
      selectValue_province;
  Blacklist_cust_list(
      this.idblacklist,
      this.smartId,
      this.name,
      this.lastname,
      this.home_no,
      this.moo_no,
      this.districtId,
      this.selectValue_amphoe,
      this.selectValue_province);

  @override
  State<Blacklist_cust_list> createState() => _Blacklist_cust_listState();
}

class _Blacklist_cust_listState extends State<Blacklist_cust_list> {
  String userId = '', empId = '', firstName = '', lastName = '', tokenId = '';
  List list_data_blacklist = [];
  bool statusLoading = false, statusLoad404 = false;

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
    getData_blacklist();
  }

  Future<void> getData_blacklist() async {
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
        Uri.parse('${beta_api_test}credit/checkBlacklist'),
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
      print('ตอจ >${widget.districtId}>> $tumbol,$amphur,$province');

      if (respose.statusCode == 200) {
        Map<String, dynamic> data_blacklist =
            new Map<String, dynamic>.from(json.decode(respose.body));

        setState(() {
          list_data_blacklist = data_blacklist['data'];
        });
        statusLoading = true;

        print('ข้อมูล => $list_data_blacklist');
      } else if (respose.statusCode == 400) {
        showProgressDialog_400(
            context, 'แจ้งเตือน', 'ไม่พบข้อมูล (${respose.statusCode})');
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
        setState(() {
          statusLoad404 = true;
          statusLoading = true;
        });
        print(respose.statusCode);
        // showProgressDialog_404(context, 'แจ้งเตือน', 'ไม่พบข้อมูลที่ค้นหา');
      } else if (respose.statusCode == 405) {
        print(respose.statusCode);
        showProgressDialog_405(
            context, 'แจ้งเตือน', 'ไม่พบข้อมูล (${respose.statusCode})');
      } else if (respose.statusCode == 500) {
        print(respose.statusCode);
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
                  color: Color.fromARGB(255, 24, 24, 24).withOpacity(0.9),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
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
          : statusLoad404 == true
              ? Center(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    height: MediaQuery.of(context).size.height * 0.15,
                    child: Column(
                      children: [
                        Container(
                          child: Column(
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
                        ),
                      ],
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.9,
                    child: Scrollbar(
                      child: ListView(
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
                                              'รหัสลูกค้า : ${list_data_blacklist[i]['blId']}',
                                              style:
                                                  MyContant().h4normalStyle(),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'ชื่อลูกค้า : ${list_data_blacklist[i]['custName']}',
                                              style:
                                                  MyContant().h4normalStyle(),
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
                                              'ที่อยู่ : ',
                                              style:
                                                  MyContant().h4normalStyle(),
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
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'สถานะ : ${list_data_blacklist[i]['blStatus']}',
                                              style:
                                                  MyContant().h4normalStyle(),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }
}
