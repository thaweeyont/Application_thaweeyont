import 'dart:convert';
import 'dart:math';

import 'package:application_thaweeyont/utility/my_constant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/login_model.dart';
import '../authen.dart';

class Data_SearchDebtor extends StatefulWidget {
  final String? signId;
  Data_SearchDebtor(this.signId);

  @override
  State<Data_SearchDebtor> createState() => _Data_SearchDebtorState();
}

class _Data_SearchDebtorState extends State<Data_SearchDebtor> {
  String userId = '', empId = '', firstName = '', lastName = '', tokenId = '';
  String page = "list_content1";
  bool active_l1 = true,
      active_l2 = false,
      active_l3 = false,
      active_l4 = false;

  var Debtordetail, status = false;
  late Map<String, dynamic> list_quarantee1, list_quarantee2, list_quarantee3;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }

  Future<void> getData_debtorDetail() async {
    print(tokenId);
    print(widget.signId.toString());

    try {
      var respose = await http.post(
        Uri.parse('https://twyapp.com/twyapi/apiV1/debtor/detail'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
        body: jsonEncode(<String, String>{
          'signId': widget.signId.toString(),
        }),
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> datadebtorDetail =
            new Map<String, dynamic>.from(json.decode(respose.body));

        Debtordetail = datadebtorDetail['data'];

        setState(() {
          status = true;
          if (Debtordetail['quarantee']['1'] != null) {
            list_quarantee1 =
                new Map<String, dynamic>.from(Debtordetail['quarantee']['1']);
          }
          if (Debtordetail['quarantee']['2'] != null) {
            list_quarantee2 =
                new Map<String, dynamic>.from(Debtordetail['quarantee']['2']);
          }
          if (Debtordetail['quarantee']['3'] != null) {
            list_quarantee3 =
                new Map<String, dynamic>.from(Debtordetail['quarantee']['3']);
          }
        });
        // Navigator.pop(context);
        // print(list_quarantee1['smartId']);
        // print(list_quarantee1);
        // print(list_quarantee2);
        // print(list_quarantee3.isNotEmpty);
      } else {
        // setState(() {
        //   debtorStatuscode = respose.statusCode;
        // });
        // Navigator.pop(context);
        print(respose.body);
        print(respose.statusCode);
        print('ไม่พบข้อมูล');
        Map<String, dynamic> check_list =
            new Map<String, dynamic>.from(json.decode(respose.body));
        print(respose.statusCode);
        print(check_list['message']);
        if (check_list['message'] == "Token Unauthorized") {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          preferences.clear();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => Authen(),
            ),
            (Route<dynamic> route) => false,
          );
        }
      }
    } catch (e) {
      // Navigator.pop(context);
      print("ไม่มีข้อมูล $e");
    }
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
    getData_debtorDetail();
  }

  Future<Null> showProgressLoading(BuildContext context) async {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) => WillPopScope(
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade400.withOpacity(0.6),
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            padding: EdgeInsets.all(80),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                Text(
                  'Loading....',
                  style: MyContant().h4normalStyle(),
                ),
              ],
            ),
          ),
        ),
        onWillPop: () async {
          return false;
        },
      ),
    );
  }

  void menu_list(page) {
    setState(() {
      active_l1 = false;
      active_l2 = false;
      active_l3 = false;
      active_l4 = false;
    });
    switch (page) {
      case "list_content1":
        setState(() {
          page = "list_content1";
          active_l1 = true;
        });
        break;
      case "list_content2":
        setState(() {
          page = "list_content2";
          active_l2 = true;
        });
        break;
      case "list_content3":
        setState(() {
          page = "list_content3";
          active_l3 = true;
        });
        break;
      case "list_content4":
        setState(() {
          page = "list_content4";
          active_l4 = true;
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('ค้นหาข้อมูล'),
      ),
      body: status == false
          ? Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade400.withOpacity(0.6),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                padding: EdgeInsets.all(80),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    Text(
                      'Loading....',
                      style: MyContant().h4normalStyle(),
                    ),
                  ],
                ),
              ),
            )
          : GestureDetector(
              child: Container(
                child: Column(
                  children: [
                    slidemenu(context),
                    if (active_l1 == true) ...[
                      content_list_1(context),
                    ],
                    if (active_l2 == true) ...[
                      content_list_2(context),
                    ],
                    if (active_l3 == true) ...[
                      content_list_3(context),
                    ],
                    if (active_l4 == true) ...[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text(
                              'รายการชำระค่างวด',
                              style: MyContant().h3Style(),
                            ),
                          ],
                        ),
                      ),
                      content_list_4(context),
                    ],
                  ],
                ),
              ),
            ),
    );
  }

  Container slidemenu(BuildContext context) {
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height * 0.05,
      // margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(3),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  menu_list("list_content1");
                },
                child: Container(
                  margin: EdgeInsets.only(top: 4, left: 5),
                  height: 30,
                  padding: EdgeInsets.all(4.5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: active_l1 == true
                        ? Color.fromRGBO(202, 71, 150, 1)
                        : Color.fromRGBO(255, 218, 249, 1),
                  ),
                  child: Text(
                    'รายการสินค้า',
                    style: MyContant().h4normalStyle(),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  menu_list("list_content2");
                },
                child: Container(
                  margin: EdgeInsets.only(top: 4, left: 7),
                  height: 30,
                  padding: EdgeInsets.all(4.5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: active_l2 == true
                        ? Color.fromRGBO(202, 71, 150, 1)
                        : Color.fromRGBO(255, 218, 249, 1),
                  ),
                  child: Text('หมายเหตุพิจารณาสินเชื่อ',
                      style: MyContant().h4normalStyle()),
                ),
              ),
              InkWell(
                onTap: () {
                  menu_list("list_content3");
                },
                child: Container(
                  margin: EdgeInsets.only(top: 4, left: 7),
                  height: 30,
                  padding: EdgeInsets.all(4.5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: active_l3 == true
                        ? Color.fromRGBO(202, 71, 150, 1)
                        : Color.fromRGBO(255, 218, 249, 1),
                  ),
                  child: Text('บันทึกหมายเหตุ',
                      style: MyContant().h4normalStyle()),
                ),
              ),
              InkWell(
                onTap: () {
                  menu_list("list_content4");
                },
                child: Container(
                  margin: EdgeInsets.only(top: 4, left: 7, right: 5),
                  height: 30,
                  padding: EdgeInsets.all(4.5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: active_l4 == true
                        ? Color.fromRGBO(202, 71, 150, 1)
                        : Color.fromRGBO(255, 218, 249, 1),
                  ),
                  child: Text('ชำระค่างวด', style: MyContant().h4normalStyle()),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Container content_list_1(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
            child: Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Color.fromRGBO(255, 218, 249, 1),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('เลขที่สัญญา : ${Debtordetail['signId']}',
                          style: MyContant().h4normalStyle()),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Text('เลขบัตรประชาชน : ${Debtordetail['debtorSmartId']}',
                          style: MyContant().h4normalStyle()),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ชื่อ-สกุล : ',
                        style: MyContant().h4normalStyle(),
                      ),
                      Expanded(
                        child: Text(
                          '${Debtordetail['debtorName']}',
                          style: MyContant().h4normalStyle(),
                          overflow: TextOverflow.clip,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ที่อยู่ : ', style: MyContant().h4normalStyle()),
                      Expanded(
                        child: Text(
                          '${Debtordetail['debtorAddress']}',
                          style: MyContant().h4normalStyle(),
                          overflow: TextOverflow.clip,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('สถานที่ทำงาน : ',
                          style: MyContant().h4normalStyle()),
                      Expanded(
                        child: Text(
                          '${Debtordetail['debtorWorkAddress']}',
                          style: MyContant().h4normalStyle(),
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
                        'อาชีพ : ${Debtordetail['debtorCareer']}',
                        style: MyContant().h4normalStyle(),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Text(
                          'สถานที่ใกล้เคียง : ${Debtordetail['debtorNearPlace']}',
                          style: MyContant().h4normalStyle()),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
            child: DefaultTabController(
              length: 3,
              initialIndex: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(255, 218, 249, 1),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    child: TabBar(
                      labelColor: Color.fromRGBO(202, 71, 150, 1),
                      labelStyle: TextStyle(fontSize: 16, fontFamily: 'Prompt'),
                      unselectedLabelColor: Colors.black,
                      tabs: [
                        Tab(text: 'ผู้ค้ำที่ 1'),
                        Tab(text: 'ผู้ค้ำที่ 2'),
                        Tab(text: 'ผู้ค้ำที่ 3'),
                      ],
                    ),
                  ),
                  line(),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.25,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(255, 218, 249, 1),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    child: TabBarView(children: <Widget>[
                      //ผู้ค้ำที1
                      SingleChildScrollView(
                        child: Debtordetail['quarantee']['1'] == null
                            ? Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.25,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'ไม่มีผู้ค้ำ',
                                          style: MyContant().h4normalStyle(),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              )
                            : Container(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                            'เลขบัตรประชาชน : ${list_quarantee1['smartId']}',
                                            style: MyContant().h4normalStyle()),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                            'ชื่อ-สกุล : ${list_quarantee1['name']}',
                                            style: MyContant().h4normalStyle()),
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
                                          style: MyContant().h4normalStyle(),
                                        ),
                                        Expanded(
                                          child: Text(
                                            '${list_quarantee1['address']}',
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
                                          'สถานที่ทำงาน : ',
                                          style: MyContant().h4normalStyle(),
                                        ),
                                        Expanded(
                                          child: Text(
                                            '${list_quarantee1['workADdress']}',
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
                                      children: [
                                        Text(
                                            'อาชีพ : ${list_quarantee1['career']}',
                                            style: MyContant().h4normalStyle()),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                            'สถานที่ใกล้เคียง : ${list_quarantee1['nearPlace']}',
                                            style: MyContant().h4normalStyle()),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                      ),
                      //ผู้ค้ำที่2
                      SingleChildScrollView(
                        child: Debtordetail['quarantee']['2'] == null
                            ? Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.25,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'ไม่มีผู้ค้ำ',
                                          style: MyContant().h4normalStyle(),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              )
                            : Container(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                            'เลขบัตรประชาชน : ${list_quarantee2['smartId']}',
                                            style: MyContant().h4normalStyle()),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                            'ชื่อ-สกุล : ${list_quarantee2['name']}',
                                            style: MyContant().h4normalStyle()),
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
                                          style: MyContant().h4normalStyle(),
                                        ),
                                        Expanded(
                                          child: Text(
                                            '${list_quarantee2['address']}',
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
                                          'สถานที่ทำงาน : ',
                                          style: MyContant().h4normalStyle(),
                                        ),
                                        Expanded(
                                          child: Text(
                                            '${list_quarantee2['workADdress']}',
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
                                      children: [
                                        Text(
                                            'อาชีพ : ${list_quarantee2['career']}',
                                            style: MyContant().h4normalStyle()),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                            'สถานที่ใกล้เคียง : ${list_quarantee2['nearPlace']}',
                                            style: MyContant().h4normalStyle()),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                      ),
                      //ผู้ค้ำที่3
                      SingleChildScrollView(
                        child: Debtordetail['quarantee']['3'] == null
                            ? Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.25,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'ไม่มีผู้ค้ำ',
                                          style: MyContant().h4normalStyle(),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              )
                            : Container(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                            'เลขบัตรประชาชน : ${list_quarantee3['smartId']}',
                                            style: MyContant().h4normalStyle()),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                            'ชื่อ-สกุล : ${list_quarantee3['name']}',
                                            style: MyContant().h4normalStyle()),
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
                                          style: MyContant().h4normalStyle(),
                                        ),
                                        Expanded(
                                          child: Text(
                                            '${list_quarantee3['address']}',
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
                                          'สถานที่ทำงาน : ',
                                          style: MyContant().h4normalStyle(),
                                        ),
                                        Expanded(
                                          child: Text(
                                            '${list_quarantee3['workADdress']}',
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
                                      children: [
                                        Text(
                                          'อาชีพ : ${list_quarantee3['career']}',
                                          style: MyContant().h4normalStyle(),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'สถานที่ใกล้เคียง : ${list_quarantee3['nearPlace']}',
                                          style: MyContant().h4normalStyle(),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    ]),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(255, 218, 249, 1),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              padding: EdgeInsets.all(8.0),
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                      // height: MediaQuery.of(context).size.height * 0.06,
                      ),
                  Row(
                    children: [
                      Text('วันที่ทำสัญญา : ${Debtordetail['signDate']}',
                          style: MyContant().h4normalStyle()),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Text(
                        'ราคาเช่าซื้อ : ${Debtordetail['leaseTotal']}',
                        style: MyContant().h4normalStyle(),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'ดอกเบี้ย ${Debtordetail['interest']} %',
                        style: MyContant().h4normalStyle(),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Text('กำหนดงวด : ', style: MyContant().h4normalStyle()),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'พนักงานขาย : ',
                          style: MyContant().h4normalStyle(),
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
                      Expanded(
                        child: Text('ผู้ตรวจสอบเครดิต : ',
                            style: MyContant().h4normalStyle(),
                            overflow: TextOverflow.clip),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Text('ผู้อนุมัติสินเชื่อ : ',
                          style: MyContant().h4normalStyle()),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(255, 218, 249, 1),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              padding: EdgeInsets.all(8.0),
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                      // height: MediaQuery.of(context).size.height * 0.06,
                      ),
                  Row(
                    children: [
                      Text(
                        'รายการสินค้า (หมายเหตุ สินค้าปกติ สินค้าเปลี่ยน สินค้ารับคืน)',
                        style: MyContant().TextSmallStyle(),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('รายการ : ', style: MyContant().h4normalStyle()),
                      Expanded(
                        child: Text(
                          'เครื่องปรับอากาศ มิตซูบิชิ MS-SGE13VC/MU-SGE13VC',
                          style: MyContant().h4normalStyle(),
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
                      Text('ยี่ห้อ : MITSUBISHI',
                          style: MyContant().h4normalStyle()),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Text('ขนาด : -', style: MyContant().h4normalStyle()),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Text('รุ่น/แบบ : MS-SGE13VC/MU-SGE13VC',
                          style: MyContant().h4normalStyle()),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('หมายเลขเครื่อง : ',
                          style: MyContant().h4normalStyle()),
                      Expanded(
                        child: Text(
                          'L20T90SS0000635T/L20T9B6S0000106T',
                          style: MyContant().h4normalStyle(),
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
                      Text('จำนวน : 1', style: MyContant().h4normalStyle()),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'หมายเหตุการขาย : หักเงินเดือนพนักงาน เริ่ม 20/05/53 = 1,075.-/ด. พนักงานคิด 0.8% * 18 = 1,075.- ราคาขายพร้อมติดตั้ง ฟรีท่อน้ำยา 4 เมตร สายไฟไม่เกิน 15 เมตร ไม่รวมขาแขวน',
                                style: MyContant().h4normalStyle(),
                                overflow: TextOverflow.clip,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Container content_list_2(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(255, 218, 249, 1),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              padding: EdgeInsets.all(8.0),
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        'หมายเหตุพนักงานสินเชื่อ',
                        style: MyContant().h4normalStyle(),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '${Debtordetail['considerNote']}',
                                  overflow: TextOverflow.clip,
                                  style: MyContant().h4normalStyle(),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text('หมายเหตุหัวหน้าสินเชื่อ',
                          style: MyContant().h4normalStyle()),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '${Debtordetail['headNote']}',
                                  overflow: TextOverflow.clip,
                                  style: MyContant().h4normalStyle(),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container content_list_3(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(255, 218, 249, 1),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              padding: EdgeInsets.all(8.0),
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('เชคเกอร์ ', style: MyContant().h4normalStyle()),
                      Text('วันที่ : 28/10/62 15:45:59 ',
                          style: MyContant().h4normalStyle()),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    padding: EdgeInsets.all(8.0),
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [Text('')],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('การเงิน', style: MyContant().h4normalStyle()),
                      Text('วันที่ : ', style: MyContant().h4normalStyle()),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    padding: EdgeInsets.all(8.0),
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [Text('ทดสอบตัวหนังสือ')],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('ติดตามหนี้ ', style: MyContant().h4normalStyle()),
                      Text(
                        'วันที่ : ',
                        style: MyContant().h4normalStyle(),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    padding: EdgeInsets.all(8.0),
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [Text('')],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'กฎหมาย',
                        style: MyContant().h4normalStyle(),
                      ),
                      Text(
                        'วันที่ : ',
                        style: MyContant().h4normalStyle(),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    padding: EdgeInsets.all(8.0),
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [Text('')],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'ทะเบียน',
                        style: MyContant().h4normalStyle(),
                      ),
                      Text(
                        'วันที่ : ',
                        style: MyContant().h4normalStyle(),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    padding: EdgeInsets.all(8.0),
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [Text('ทดสอบตัวหนังสือ')],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'บริการ',
                        style: MyContant().h4normalStyle(),
                      ),
                      Text(
                        'วันที่ : ',
                        style: MyContant().h4normalStyle(),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    padding: EdgeInsets.all(8.0),
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [Text('')],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container content_list_4(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      child: ListView(
        children: [
          for (var i = 0; i <= 10; i++) ...[
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, MyContant.routePayInstallment);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 218, 249, 1),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  padding: EdgeInsets.all(8.0),
                  width: double.infinity,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'งวดที่ : ${i + 1}',
                            style: MyContant().h4normalStyle(),
                          ),
                          Text(
                            'วันที่ชำระ : 20/07/62',
                            style: MyContant().h4normalStyle(),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Text(
                            'เลขที่ใบเสร็จ : R301190778395',
                            style: MyContant().h4normalStyle(),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'เงินต้น : 1,065.00',
                            style: MyContant().h4normalStyle(),
                          ),
                          Text(
                            'คงเหลือ : ',
                            style: MyContant().h4normalStyle(),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'ค่าปรับ : ',
                            style: MyContant().h4normalStyle(),
                          ),
                          Text(
                            'วันที่ชำระ : 20/07/62',
                            style: MyContant().h4normalStyle(),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'ชำระเงินต้น : 1,065.00',
                            style: MyContant().h4normalStyle(),
                          ),
                          Text(
                            'ชำระค่าปรับ : ',
                            style: MyContant().h4normalStyle(),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  SizedBox line() {
    return SizedBox(
      height: 0,
      width: double.infinity,
      child: Divider(
        color: Color.fromARGB(255, 34, 34, 34),
      ),
    );
  }
}
