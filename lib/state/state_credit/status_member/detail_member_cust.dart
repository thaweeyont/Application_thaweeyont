import 'dart:convert';

import 'package:application_thaweeyont/state/authen.dart';
import 'package:application_thaweeyont/utility/my_constant.dart';
import 'package:flutter/material.dart';
import 'package:loading_gifs/loading_gifs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../api.dart';

class Detail_member_cust extends StatefulWidget {
  // const Detail_member_cust({Key? key}) : super(key: key);
  final String? custId, smartId, custName, lastnamecust;
  Detail_member_cust(
      this.custId, this.smartId, this.custName, this.lastnamecust);

  @override
  State<Detail_member_cust> createState() => _Detail_member_custState();
}

class _Detail_member_custState extends State<Detail_member_cust> {
  String userId = '', empId = '', firstName = '', lastName = '', tokenId = '';
  List list_dataMember = [], list_address = [];
  var valueaddress, status_loading = false;
  @override
  void initState() {
    // TODO: implement initState
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
    getData_CusMember();
  }

  Future<void> getData_CusMember() async {
    print(tokenId);
    print(widget.custId);
    try {
      var respose = await http.post(
        Uri.parse('${beta_api_test}customer/member'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
        body: jsonEncode(<String, String>{
          'custId': widget.custId.toString(),
          'smartId': widget.smartId.toString(),
          'firstName': widget.custName.toString(),
          'lastName': widget.lastnamecust.toString(),
          'page': '1',
          'limit': '20',
        }),
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> dataMemberList =
            new Map<String, dynamic>.from(json.decode(respose.body));

        valueaddress = dataMemberList['data'][0];
        setState(() {
          list_dataMember = dataMemberList['data'];
          list_address = valueaddress['address'];
        });
        status_loading = true;
        // Navigator.pop(context);
        print('data->>${list_address}');
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
        showProgressDialog_404(context, 'แจ้งเตือน', 'ไม่พบข้อมูลที่ค้นหา');
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
          : Container(
              height: MediaQuery.of(context).size.height * 0.9,
              child: Scrollbar(
                child: ListView(
                  children: [
                    if (list_dataMember.isNotEmpty) ...[
                      for (var i = 0; i < list_dataMember.length; i++) ...[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(64, 203, 203, 1),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'รหัสลูกค้า : ${list_dataMember[i]['custId']}',
                                      style: MyContant().h4normalStyle(),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Row(
                                  children: [
                                    Text(
                                        'ชื่อ-นามสกุล : ${list_dataMember[i]['custName']}',
                                        style: MyContant().h4normalStyle()),
                                  ],
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'ชื่อเล่น : ${list_dataMember[i]['nickName']}',
                                      style: MyContant().h4normalStyle(),
                                    ),
                                    Text(
                                      'เพศ : ${list_dataMember[i]['gender']}',
                                      style: MyContant().h4normalStyle(),
                                    ),
                                    Text(
                                      'สถานภาพ : ${list_dataMember[i]['marryStatus']}',
                                      style: MyContant().h4normalStyle(),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'ศาสนา : ${list_dataMember[i]['religionName']}',
                                      style: MyContant().h4normalStyle(),
                                    ),
                                    Text(
                                      'เชื้อชาติ : ${list_dataMember[i]['raceName']}',
                                      style: MyContant().h4normalStyle(),
                                    ),
                                    Text(
                                      'สัญชาติ : ${list_dataMember[i]['nationName']}',
                                      style: MyContant().h4normalStyle(),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'วันเกิด : ${list_dataMember[i]['birthday']}',
                                      style: MyContant().h4normalStyle(),
                                    ),
                                    Text(
                                      'อายุ : ${list_dataMember[i]['age']} ปี',
                                      style: MyContant().h4normalStyle(),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'เบอร์โทรศัพท์ : ${list_dataMember[i]['mobile']}',
                                      style: MyContant().h4normalStyle(),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'บัตร : ${list_dataMember[i]['cardTypeName']}',
                                      style: MyContant().h4normalStyle(),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'เลขที่ : ${list_dataMember[i]['smartId']}',
                                      style: MyContant().h4normalStyle(),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Email : ${list_dataMember[i]['email']}',
                                      style: MyContant().h4normalStyle(),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Website : ${list_dataMember[i]['website']}',
                                      style: MyContant().h4normalStyle(),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Line Id : ${list_dataMember[i]['lineId']}',
                                      style: MyContant().h4normalStyle(),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'วันที่หมดอายุ : ${list_dataMember[i]['smartExpireDate']}',
                                      style: MyContant().h4normalStyle(),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Container(
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(64, 203, 203, 1),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'ข้อมูลบัตรสมาขิก',
                                      style: MyContant().TextcolorBlue(),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.15,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.7),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                  ),
                                  child: Scrollbar(
                                    child: ListView(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      'รหัสบัตร : ${list_dataMember[i]['memberCardId']}',
                                                      style: MyContant()
                                                          .h4normalStyle(),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      'สถานะบัตรสมาชิก : ${list_dataMember[i]['memberCardName']}',
                                                      style: MyContant()
                                                          .h4normalStyle(),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      'ผู้ตรวจสอบ : ${list_dataMember[i]['auditName']}',
                                                      style: MyContant()
                                                          .h4normalStyle(),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      'วันที่ออกบัตร : ${list_dataMember[i]['applyDate']}',
                                                      style: MyContant()
                                                          .h4normalStyle(),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(
                                'ข้อมูลที่อยู่ ${list_address.length}',
                                style: MyContant().h2Style(),
                              ),
                            ],
                          ),
                        ),
                        if (list_address.isNotEmpty) ...[
                          for (var i = 0; i < list_address.length; i++) ...[
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 8, left: 8, right: 8),
                              child: Container(
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(64, 203, 203, 1),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${i + 1}',
                                          style: MyContant().h4normalStyle(),
                                        ),
                                        Text(
                                          'ประเภท : ${list_address[i]['type']}',
                                          style: MyContant().h4normalStyle(),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.15,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.7),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                      ),
                                      child: Scrollbar(
                                          child: ListView(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              child: Column(
                                                children: [
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'ที่อยู่ : ',
                                                        style: MyContant()
                                                            .h4normalStyle(),
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          '${list_address[i]['detail']}',
                                                          overflow:
                                                              TextOverflow.clip,
                                                          style: MyContant()
                                                              .h4normalStyle(),
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
                                                        'เบอร์โทรศัพท์ : ${list_address[i]['tel']}',
                                                        style: MyContant()
                                                            .h4normalStyle(),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'เบอร์แฟกซ์ : ${list_address[i]['fax']}',
                                                        style: MyContant()
                                                            .h4normalStyle(),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      )),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ],
                        if (list_dataMember.length > 1) ...[
                          lineNext(),
                        ],
                      ],
                    ],
                  ],
                ),
              ),
            ),
    );
  }
}

Padding lineNext() {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(children: <Widget>[
      Expanded(
        child: new Container(
            margin: const EdgeInsets.only(left: 10.0, right: 20.0),
            child: Divider(
              thickness: 1.0,
              color: Colors.black,
              height: 30,
            )),
      ),
      Text(
        'คนถัดไป',
        style: MyContant().TextInputStyle(),
      ),
      Expanded(
        child: new Container(
            margin: const EdgeInsets.only(left: 20.0, right: 10.0),
            child: Divider(
              thickness: 1.0,
              color: Colors.black,
              height: 30,
            )),
      ),
    ]),
  );
}
