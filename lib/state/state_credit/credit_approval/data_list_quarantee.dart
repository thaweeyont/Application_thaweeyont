import 'dart:convert';

import 'package:application_thaweeyont/api.dart';
import 'package:application_thaweeyont/utility/my_constant.dart';
import 'package:flutter/material.dart';
import 'package:loading_gifs/loading_gifs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../authen.dart';
import 'page_info_consider_cus.dart';

class DataListQuarantee extends StatefulWidget {
  // const DataListQuarantee({Key? key}) : super(key: key);
  final String? custId;
  DataListQuarantee(this.custId);

  @override
  State<DataListQuarantee> createState() => _DataListQuaranteeState();
}

class _DataListQuaranteeState extends State<DataListQuarantee> {
  String userId = '', empId = '', firstName = '', lastName = '', tokenId = '';
  List list_quarantee = [];
  var status_loading = false;

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
    getData_quarantee();
  }

  Future<void> getData_quarantee() async {
    print(tokenId);
    print(widget.custId.toString());
    try {
      var respose = await http.post(
        Uri.parse('${api}credit/quarantee'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
        body: jsonEncode(<String, String>{
          'custId': widget.custId.toString(),
        }),
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> dataQuarantee =
            new Map<String, dynamic>.from(jsonDecode(respose.body));

        setState(() {
          list_quarantee = dataQuarantee['data'];
        });
        status_loading = true;

        print('data=>>${list_quarantee}');
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
            builder: (context) => Authen(),
          ),
          (Route<dynamic> route) => false,
        );
        showProgressDialog_401(
            context, 'แจ้งเตือน', 'กรุณา Login เข้าสู่ระบบใหม่');
      } else if (respose.statusCode == 404) {
        print(respose.statusCode);
        showProgressDialog_404(context, 'แจ้งเตือน', 'ไม่พบข้อมูลผู้ค้ำประกัน');
      } else if (respose.statusCode == 405) {
        print(respose.statusCode);
        showProgressDialog_405(
            context, 'แจ้งเตือน', 'ไม่พบข้อมูล (${respose.statusCode})');
      } else if (respose.statusCode == 500) {
        print(respose.statusCode);
        showProgressDialog_500(context, 'แจ้งเตือน',
            '${respose.statusCode} ข้อมูลผิดพลาด (${respose.statusCode})');
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
          'รายละเอียดผู้ค้ำ',
          style: MyContant().TitleStyle(),
        ),
      ),
      body: status_loading == false
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
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.9,
                child: Scrollbar(
                  child: ListView(
                    children: [
                      for (var i = 0; i < list_quarantee.length; i++) ...[
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Page_Info_Consider_Cus(
                                  list_quarantee[i]['signId'],
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                  color: Color.fromRGBO(251, 173, 55, 1)),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'เลขที่สัญญา : ${list_quarantee[i]['signId']}',
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
                                        'ชื่อ-สกุล : ',
                                        style: MyContant().h4normalStyle(),
                                      ),
                                      Expanded(
                                        child: Text(
                                          '${list_quarantee[i]['custName']}',
                                          overflow: TextOverflow.clip,
                                          style: MyContant().h4normalStyle(),
                                        ),
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
                                        'ชื่อ-สกุลในสัญญา : ',
                                        style: MyContant().h4normalStyle(),
                                      ),
                                      Expanded(
                                        child: Text(
                                          '${list_quarantee[i]['signCustName']}',
                                          overflow: TextOverflow.clip,
                                          style: MyContant().h4normalStyle(),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'ยอดคงเหลือ : ${list_quarantee[i]['remainPrice']}',
                                        style: MyContant().h4normalStyle(),
                                      ),
                                      Text(
                                        'สถานะ : ${list_quarantee[i]['personStatusName']}',
                                        style: MyContant().h4normalStyle(),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'เขตติดตาม : ${list_quarantee[i]['followName']}',
                                        style: MyContant().h4normalStyle(),
                                      ),
                                      Text(
                                        'สถานะสัญญา : ${list_quarantee[i]['signStatusName']}',
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
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
