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
  final String? custId;
  Detail_member_cust(this.custId);

  @override
  State<Detail_member_cust> createState() => _Detail_member_custState();
}

class _Detail_member_custState extends State<Detail_member_cust> {
  String userId = '', empId = '', firstName = '', lastName = '', tokenId = '';
  List listdataMemberDetail = [],
      listaddress = [],
      listdata = [],
      listinfo = [];
  var valueaddress, dataaddress;
  bool statusLoading = false, statusLoad404 = false;
  Map<String, dynamic>? listvalueAddreses;

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
    getDataCusMemberDetail();
  }

  Future<void> getDataCusMemberDetail() async {
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
        }),
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> dataMemberDetail =
            Map<String, dynamic>.from(json.decode(respose.body));

        valueaddress = dataMemberDetail['data'][0]['address'];
        setState(() {
          listdataMemberDetail = dataMemberDetail['data'];
          listaddress = valueaddress;
        });
        statusLoading = true;
        print('data>>${listdataMemberDetail}');
        print('address>>${listaddress}');
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
        // showProgressDialog_404(context, 'แจ้งเตือน', 'ไม่พบข้อมูลที่ค้นหา');
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
              : Container(
                  height: MediaQuery.of(context).size.height * 0.9,
                  child: Scrollbar(
                    child: ListView(
                      children: [
                        if (listdataMemberDetail.isNotEmpty) ...[
                          for (var i = 0;
                              i < listdataMemberDetail.length;
                              i++) ...[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: const BoxDecoration(
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
                                          'รหัสลูกค้า : ${listdataMemberDetail[i]['custId']}',
                                          style: MyContant().h4normalStyle(),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'ชื่อ-นามสกุล : ',
                                          style: MyContant().h4normalStyle(),
                                        ),
                                        Expanded(
                                          child: Text(
                                            '${listdataMemberDetail[i]['custName']}',
                                            overflow: TextOverflow.clip,
                                            style: MyContant().h4normalStyle(),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'ชื่อเล่น : ${listdataMemberDetail[i]['nickName']}',
                                          style: MyContant().h4normalStyle(),
                                        ),
                                        Text(
                                          'เพศ : ${listdataMemberDetail[i]['gender']}',
                                          style: MyContant().h4normalStyle(),
                                        ),
                                        Text(
                                          'สถานภาพ : ${listdataMemberDetail[i]['marryStatus']}',
                                          style: MyContant().h4normalStyle(),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'ศาสนา : ${listdataMemberDetail[i]['religionName']}',
                                          style: MyContant().h4normalStyle(),
                                        ),
                                        Text(
                                          'เชื้อชาติ : ${listdataMemberDetail[i]['raceName']}',
                                          style: MyContant().h4normalStyle(),
                                        ),
                                        Text(
                                          'สัญชาติ : ${listdataMemberDetail[i]['nationName']}',
                                          style: MyContant().h4normalStyle(),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'วันเกิด : ${listdataMemberDetail[i]['birthday']}',
                                          style: MyContant().h4normalStyle(),
                                        ),
                                        Text(
                                          'อายุ : ${listdataMemberDetail[i]['age']} ปี',
                                          style: MyContant().h4normalStyle(),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'เบอร์โทรศัพท์ : ${listdataMemberDetail[i]['mobile']}',
                                          style: MyContant().h4normalStyle(),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'บัตร : ${listdataMemberDetail[i]['cardTypeName']}',
                                          style: MyContant().h4normalStyle(),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'เลขที่ : ${listdataMemberDetail[i]['smartId']}',
                                          style: MyContant().h4normalStyle(),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Email : ${listdataMemberDetail[i]['email']}',
                                          style: MyContant().h4normalStyle(),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Website : ${listdataMemberDetail[i]['website']}',
                                          style: MyContant().h4normalStyle(),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Line Id : ${listdataMemberDetail[i]['lineId']}',
                                          style: MyContant().h4normalStyle(),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'วันที่หมดอายุ : ${listdataMemberDetail[i]['smartExpireDate']}',
                                          style: MyContant().h4normalStyle(),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: const BoxDecoration(
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
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.15,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.7),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                      ),
                                      child: Scrollbar(
                                        child: ListView(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'รหัสบัตร : ${listdataMemberDetail[i]['memberCardId']}',
                                                          style: MyContant()
                                                              .h4normalStyle(),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'สถานะบัตรสมาชิก : ${listdataMemberDetail[i]['memberCardName']}',
                                                          style: MyContant()
                                                              .h4normalStyle(),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'ผู้ตรวจสอบ : ${listdataMemberDetail[i]['auditName']}',
                                                          style: MyContant()
                                                              .h4normalStyle(),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'วันที่ออกบัตร : ${listdataMemberDetail[i]['applyDate']}',
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
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                  color: Color.fromRGBO(64, 203, 203, 1),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'ข้อมูลที่อยู่ของลูกค้า',
                                      style: MyContant().h4normalStyle(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            for (var c = 0; c < listaddress.length; c++) ...[
                              Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 8, left: 8, right: 8),
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: const BoxDecoration(
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
                                            '',
                                            style: MyContant().h4normalStyle(),
                                          ),
                                          Text(
                                            'ประเภท : ${listaddress[c]['type']}',
                                            style: MyContant().h4normalStyle(),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.15,
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.7),
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(5),
                                          ),
                                        ),
                                        child: Scrollbar(
                                            child: ListView(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
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
                                                          '${listaddress[c]['detail']}',
                                                          overflow:
                                                              TextOverflow.clip,
                                                          style: MyContant()
                                                              .h4normalStyle(),
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
                                                        'เบอร์โทรศัพท์ : ${listaddress[c]['tel']}',
                                                        style: MyContant()
                                                            .h4normalStyle(),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'เบอร์แฟกซ์ : ${listaddress[c]['fax']}',
                                                        style: MyContant()
                                                            .h4normalStyle(),
                                                      ),
                                                    ],
                                                  ),
                                                ],
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
            child: const Divider(
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
            child: const Divider(
              thickness: 1.0,
              color: Colors.black,
              height: 30,
            )),
      ),
    ]),
  );
}
