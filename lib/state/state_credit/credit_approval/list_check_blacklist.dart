import 'dart:convert';

import 'package:application_thaweeyont/utility/my_constant.dart';
import 'package:flutter/material.dart';
import 'package:loading_gifs/loading_gifs.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../api.dart';
import 'package:http/http.dart' as http;

import '../../authen.dart';
import 'detail_check_blacklist.dart';

class ListCheckBlacklist extends StatefulWidget {
  // const ListCheckBlacklist({Key? key}) : super(key: key);
  final String? idblacklist,
      idcard,
      name,
      lastname,
      homeNo,
      mooNo,
      districtId,
      selectValue_amphoe,
      selectValue_province;
  ListCheckBlacklist(
      this.idblacklist,
      this.idcard,
      this.name,
      this.lastname,
      this.homeNo,
      this.mooNo,
      this.districtId,
      this.selectValue_amphoe,
      this.selectValue_province);

  @override
  State<ListCheckBlacklist> createState() => _ListCheckBlacklistState();
}

class _ListCheckBlacklistState extends State<ListCheckBlacklist> {
  String userId = '', empId = '', firstName = '', lastName = '', tokenId = '';
  List list_Blacklist = [];
  bool statusLoading = false, statusLoad404 = false;

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
    print(tokenId);
    // print('1>${widget.idblacklist}');
    // print('2>${widget.idcard}');
    // print('3>${widget.name}');
    // print('4>${widget.lastname}');
    // print('5>${widget.homeNo}');
    // print('6>${widget.mooNo}');
    // print('7>${tumbol}');
    // print('8>${amphur}');
    // print('9>${province}');
    try {
      var respose = await http.post(
        Uri.parse('${beta_api_test}credit/checkBlacklist'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
        body: jsonEncode(<String, String>{
          'blId': widget.idblacklist.toString(),
          'smartId': widget.idcard.toString(),
          'firstName': widget.name.toString(),
          'lastName': widget.lastname.toString(),
          'homeNo': widget.homeNo.toString(),
          'moo': widget.mooNo.toString(),
          'tumbolId': tumbol,
          'amphurId': amphur,
          'provId': province
        }),
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> dataBlacklist =
            new Map<String, dynamic>.from(json.decode(respose.body));

        setState(() {
          list_Blacklist = dataBlacklist['data'];
        });
        statusLoading = true;
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
          statusLoad404 = true;
          statusLoading = true;
        });
        print(respose.statusCode);
        // showProgressDialog_404(context, 'แจ้งเตือน', 'ไม่พบข้อมูล Blacklist');
      } else if (respose.statusCode == 405) {
        print(respose.statusCode);
        showProgressDialog_405(
            context, 'แจ้งเตือน', 'ไม่พบข้อมูล (${respose.statusCode})');
      } else if (respose.statusCode == 500) {
        print(respose.statusCode);
        showProgressDialog_500(
            context, 'แจ้งเตือน', 'ข้อมูลผิดพลาด (${respose.statusCode})');
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
          'รายการค้นหา',
          style: MyContant().TitleStyle(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Scrollbar(
          child: statusLoading == false
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
                      children: [
                        for (var i = 0; i < list_Blacklist.length; i++) ...[
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailCheckBlacklist(
                                      list_Blacklist[i]['blId']),
                                ),
                              );
                            },
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
                                    children: [
                                      Text(
                                        'รหัสลูกค้า : ${list_Blacklist[i]['blId']}',
                                        style: MyContant().h4normalStyle(),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'ชื่อลูกค้า : ${list_Blacklist[i]['custName']}',
                                        style: MyContant().h4normalStyle(),
                                      ),
                                    ],
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
                                          '${list_Blacklist[i]['custAddress']}',
                                          overflow: TextOverflow.clip,
                                          style: MyContant().h4normalStyle(),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'สถานะ : ${list_Blacklist[i]['blStatus']}',
                                        style: MyContant().h4normalStyle(),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
        ),
      ),
    );
  }
}
