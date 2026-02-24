import 'dart:convert';

import 'package:application_thaweeyont/utility/my_constant.dart';
import 'package:application_thaweeyont/widgets/loading_view.dart';
import 'package:application_thaweeyont/widgets/nodata_view.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../api.dart';
import 'package:http/http.dart' as http;

import '../../../widgets/custom_appbar.dart';
import '../../authen.dart';
import 'detail_check_blacklist.dart';

class ListCheckBlacklist extends StatefulWidget {
  final String? idblacklist,
      idcard,
      name,
      lastname,
      homeNo,
      mooNo,
      districtId,
      selectValue_amphoe,
      selectValue_province;
  const ListCheckBlacklist(
      this.idblacklist,
      this.idcard,
      this.name,
      this.lastname,
      this.homeNo,
      this.mooNo,
      this.districtId,
      this.selectValue_amphoe,
      this.selectValue_province,
      {super.key});

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
    getDataBlacklist();
  }

  Future<void> getDataBlacklist() async {
    // var tumbol, amphur, province;

    // if (widget.districtId == null) {
    //   tumbol = '';
    //   amphur = '';
    //   province = '';
    // } else {
    //   tumbol = widget.districtId;
    //   amphur = widget.selectValue_amphoe.toString().split("_")[0];
    //   province = widget.selectValue_province.toString().split("_")[0];
    // }
    final tumbol = widget.districtId ?? '';

    final amphur = widget.selectValue_amphoe != null
        ? widget.selectValue_amphoe.toString().split("_").first
        : '';

    final province = widget.selectValue_province != null
        ? widget.selectValue_province.toString().split("_").first
        : '';

    try {
      var response = await http.post(
        Uri.parse('${api}credit/checkBlacklist'),
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

      if (response.statusCode == 200) {
        Map<String, dynamic> dataBlacklist =
            Map<String, dynamic>.from(json.decode(response.body));

        setState(() {
          list_Blacklist = dataBlacklist['data'];
        });
        statusLoading = true;
      } else {
        handleHttpError(response.statusCode);
      }
    } catch (e) {
      print("ไม่มีข้อมูล $e");
      showProgressDialogNotdata(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
  }

  // แยกฟังก์ชัน handle error HTTP
  void handleHttpError(int statusCode) async {
    if (statusCode == 400) {
      showProgressDialog_400(context, 'แจ้งเตือน', 'ไม่พบข้อมูล ($statusCode)');
    } else if (statusCode == 401) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.clear();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Authen()),
        (Route<dynamic> route) => false,
      );
      showProgressDialog_401(
          context, 'แจ้งเตือน', 'กรุณา Login เข้าสู่ระบบใหม่');
    } else if (statusCode == 404) {
      setState(() {
        statusLoading = true;
        statusLoad404 = true;
      });
    } else if (statusCode == 405) {
      showProgressDialog_405(context, 'แจ้งเตือน', 'ไม่พบข้อมูล ($statusCode)');
    } else if (statusCode == 500) {
      showProgressDialog_500(
          context, 'แจ้งเตือน', 'ข้อมูลผิดพลาด ($statusCode)');
    } else {
      showProgressDialog(context, 'แจ้งเตือน', 'กรุณาติดต่อผู้ดูแลระบบ');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: 'รายการค้นหา'),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Scrollbar(
          child: statusLoading == false
              ? LoadingView()
              : statusLoad404 == true
                  ? NoDataView()
                  : mainContent(context),
        ),
      ),
    );
  }

  ListView mainContent(BuildContext context) {
    return ListView(
      children: [
        for (var i = 0; i < list_Blacklist.length; i++) ...[
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      DetailCheckBlacklist(list_Blacklist[i]['blId']),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
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
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(8),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
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
            ),
          ),
        ],
      ],
    );
  }
}
