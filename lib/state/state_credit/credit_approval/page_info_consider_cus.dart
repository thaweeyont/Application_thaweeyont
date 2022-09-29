import 'dart:convert';

import 'package:application_thaweeyont/state/state_credit/credit_approval/page_pay_installment.dart';
import 'package:application_thaweeyont/utility/my_constant.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../authen.dart';

class Page_Info_Consider_Cus extends StatefulWidget {
  // const Page_Info_Consider_Cus({super.key});
  final String? signId;
  Page_Info_Consider_Cus(this.signId);

  @override
  State<Page_Info_Consider_Cus> createState() => _Page_Info_Consider_CusState();
}

class _Page_Info_Consider_CusState extends State<Page_Info_Consider_Cus> {
  String userId = '', empId = '', firstName = '', lastName = '', tokenId = '';
  String page = "list_content_mu1";
  bool active_mu1 = true,
      active_mu2 = false,
      active_mu3 = false,
      active_mu4 = false;
  var Debtordetail, status = false, dataDebnote;
  List list_payDetail = [], data_service = [];
  Map<String, dynamic>? list_quarantee1,
      list_quarantee2,
      list_quarantee3,
      list_itemDetail,
      list_service,
      list_finance,
      list_debNote,
      list_law,
      list_regis,
      list_checker;

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
    getData_debtorDetailApprove();
  }

  Future<void> getData_debtorDetailApprove() async {
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
          list_itemDetail =
              new Map<String, dynamic>.from(Debtordetail['itemDetail']);

          if (Debtordetail['debtNote'] == true) {
            if (Debtordetail['debtNote']['service'] != null) {
              list_service = new Map<String, dynamic>.from(
                  Debtordetail['debtNote']['service']);
            }
            if (Debtordetail['debtNote']['finance'] != null) {
              list_finance = new Map<String, dynamic>.from(
                  Debtordetail['debtNote']['finance']);
            }
            if (Debtordetail['debtNote']['debt'] != null) {
              list_debNote = new Map<String, dynamic>.from(
                  Debtordetail['debtNote']['debt']);
            }
            if (Debtordetail['debtNote']['law'] != null) {
              list_law = new Map<String, dynamic>.from(
                  Debtordetail['debtNote']['law']);
            }
            if (Debtordetail['debtNote']['regis'] != null) {
              list_regis = new Map<String, dynamic>.from(
                  Debtordetail['debtNote']['regis']);
            }
            if (Debtordetail['debtNote']['checker'] != null) {
              list_checker = new Map<String, dynamic>.from(
                  Debtordetail['debtNote']['checker']);
            }
          }

          list_payDetail = Debtordetail['payDetail'];
        });
        // Navigator.pop(context););
        print(list_payDetail);
        // print(list_service);
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
      Navigator.pop(context);
      print("ไม่มีข้อมูล $e");
    }
  }

  void menu_list(page) {
    setState(() {
      active_mu1 = false;
      active_mu2 = false;
      active_mu3 = false;
      active_mu4 = false;
    });
    switch (page) {
      case "list_content_mu1":
        setState(() {
          page = "list_content_mu1";
          active_mu1 = true;
        });
        break;
      case "list_content_mu2":
        setState(() {
          page = "list_content_mu2";
          active_mu2 = true;
        });
        break;
      case "list_content_mu3":
        setState(() {
          page = "list_content_mu3";
          active_mu3 = true;
        });
        break;
      case "list_content_mu4":
        setState(() {
          page = "list_content_mu4";
          active_mu4 = true;
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'ค้นหาข้อมูล',
          style: MyContant().TitleStyle(),
        ),
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
                    if (active_mu1 == true) ...[
                      content_list_mu1(context),
                    ],
                    if (active_mu2 == true) ...[
                      content_list_mu2(context),
                    ],
                    if (active_mu3 == true) ...[
                      content_list_mu3(context),
                    ],
                    if (active_mu4 == true) ...[
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
                      content_list_mu4(context),
                    ],
                  ],
                ),
              ),
            ),
    );
  }

  Container content_list_mu1(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Color.fromRGBO(251, 173, 55, 1),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'เลขที่สัญญา : ${Debtordetail['signId']}',
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
                        'เลขบัตรประชาชน : ${Debtordetail['debtorSmartId']}',
                        style: MyContant().h4normalStyle(),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ชื่อ - สกุล : ',
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
                      Text(
                        'ที่อยู่ : ',
                        style: MyContant().h4normalStyle(),
                      ),
                      Expanded(
                        child: Text(
                          '${Debtordetail['debtorAddress']}',
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'สถานที่ทำงาน : ',
                        style: MyContant().h4normalStyle(),
                      ),
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
                        style: MyContant().h4normalStyle(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DefaultTabController(
              length: 3,
              initialIndex: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(251, 173, 55, 1),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        )),
                    child: TabBar(
                      labelColor: Color.fromRGBO(110, 66, 0, 1),
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
                      color: Color.fromRGBO(251, 173, 55, 1),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    child: TabBarView(
                      children: <Widget>[
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
                                              'เลขบัตรประชาชน : ${list_quarantee1!['smartId']}',
                                              style:
                                                  MyContant().h4normalStyle()),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                              'ชื่อ-สกุล : ${list_quarantee1!['name']}',
                                              style:
                                                  MyContant().h4normalStyle()),
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
                                              '${list_quarantee1!['address']}',
                                              overflow: TextOverflow.clip,
                                              style:
                                                  MyContant().h4normalStyle(),
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
                                              '${list_quarantee1!['workADdress']}',
                                              overflow: TextOverflow.clip,
                                              style:
                                                  MyContant().h4normalStyle(),
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
                                              'อาชีพ : ${list_quarantee1!['career']}',
                                              style:
                                                  MyContant().h4normalStyle()),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                              'สถานที่ใกล้เคียง : ${list_quarantee1!['nearPlace']}',
                                              style:
                                                  MyContant().h4normalStyle()),
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
                                              'เลขบัตรประชาชน : ${list_quarantee2!['smartId']}',
                                              style:
                                                  MyContant().h4normalStyle()),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                              'ชื่อ-สกุล : ${list_quarantee2!['name']}',
                                              style:
                                                  MyContant().h4normalStyle()),
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
                                              '${list_quarantee2!['address']}',
                                              overflow: TextOverflow.clip,
                                              style:
                                                  MyContant().h4normalStyle(),
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
                                              '${list_quarantee2!['workADdress']}',
                                              overflow: TextOverflow.clip,
                                              style:
                                                  MyContant().h4normalStyle(),
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
                                              'อาชีพ : ${list_quarantee2!['career']}',
                                              style:
                                                  MyContant().h4normalStyle()),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                              'สถานที่ใกล้เคียง : ${list_quarantee2!['nearPlace']}',
                                              style:
                                                  MyContant().h4normalStyle()),
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
                                              'เลขบัตรประชาชน : ${list_quarantee3!['smartId']}',
                                              style:
                                                  MyContant().h4normalStyle()),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                              'ชื่อ-สกุล : ${list_quarantee3!['name']}',
                                              style:
                                                  MyContant().h4normalStyle()),
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
                                              '${list_quarantee3!['address']}',
                                              overflow: TextOverflow.clip,
                                              style:
                                                  MyContant().h4normalStyle(),
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
                                              '${list_quarantee3!['workADdress']}',
                                              overflow: TextOverflow.clip,
                                              style:
                                                  MyContant().h4normalStyle(),
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
                                            'อาชีพ : ${list_quarantee3!['career']}',
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
                                            'สถานที่ใกล้เคียง : ${list_quarantee3!['nearPlace']}',
                                            style: MyContant().h4normalStyle(),
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
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Color.fromRGBO(251, 173, 55, 1),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'วันที่ทำสัญญา : ${Debtordetail['signDate']}',
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
                        'ราคาเช่าซื้อ : ${Debtordetail['leaseTotal']} บาท',
                        style: MyContant().h4normalStyle(),
                      ),
                      SizedBox(
                        width: 10,
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
                      Text(
                        'กำหนดเวลา : ${Debtordetail['periodNo']} งวด',
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
                        'พนักงานขาย : ${Debtordetail['saleName']}',
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
                        'ผู้ตรวจสอบเครดิต : ${Debtordetail['creditName']}',
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
                        'ผู้อนุมัติสินเชื่อ : ${Debtordetail['approveName']}',
                        style: MyContant().h4normalStyle(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Color.fromRGBO(251, 173, 55, 1),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: Column(
                children: [
                  // Row(
                  //   children: [
                  //     Text(
                  //       'รายการสินค้า (หมายเหตุ สินค้าปกติ สินค้าเปลี่ยน สินค้ารับคืน)',
                  //       style: TextStyle(
                  //           fontSize: 12, fontWeight: FontWeight.bold),
                  //     ),
                  //   ],
                  // ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'รายการ : ',
                        style: MyContant().h4normalStyle(),
                      ),
                      Expanded(
                        child: Text(
                          '${list_itemDetail!['name']}',
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
                        'ยี่ห้อ : ${list_itemDetail!['brandName']}',
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
                        'ขนาด : ${list_itemDetail!['sizeName']}',
                        style: MyContant().h4normalStyle(),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'รุ่น/แบบ : ',
                        style: MyContant().h4normalStyle(),
                      ),
                      Expanded(
                        child: Text(
                          '${list_itemDetail!['modelName']}',
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'หมายเลขเครื่อง : ',
                        style: MyContant().h4normalStyle(),
                      ),
                      Expanded(
                        child: Text(
                          '${list_itemDetail!['serialId']}',
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
                        'จำนวน : ${list_itemDetail!['qty']}',
                        style: MyContant().h4normalStyle(),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'หมายเหตุการขาย : ${list_itemDetail!['saleNote']}',
                                overflow: TextOverflow.clip,
                                style: MyContant().TextSmalldebNote(),
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
        ],
      ),
    );
  }

  Container content_list_mu2(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Color.fromRGBO(251, 173, 55, 1),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
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
                              Text(
                                '${Debtordetail['considerNote']}',
                                style: MyContant().h4normalStyle(),
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
                      Text(
                        'หมายเหตุหัวหน้าสินเชื่อ',
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
                              Text(
                                '${Debtordetail['headNote']}',
                                style: MyContant().h4normalStyle(),
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

  Container content_list_mu3(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Color.fromRGBO(251, 173, 55, 1),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'เชคเกอร์ ',
                        style: MyContant().h4normalStyle(),
                      ),
                      if (list_service == null && status == true) ...[
                        Text(
                          'วันที่ : ',
                          style: MyContant().h4normalStyle(),
                        ),
                      ] else ...[
                        Text(
                          'วันที่ : ${list_service!['date']}',
                          style: MyContant().h4normalStyle(),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    padding: EdgeInsets.all(8.0),
                    height: MediaQuery.of(context).size.height * 0.15,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    child: list_service == null && status == true
                        ? Container(
                            height: MediaQuery.of(context).size.height * 0.25,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'ไม่มีบันทึก',
                                      style: MyContant().h4normalStyle(),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        : Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            '${list_service!['note']}',
                                            overflow: TextOverflow.clip,
                                            style:
                                                MyContant().TextSmalldebNote(),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'ผู้บันทึก : ${list_service!['createName']}',
                                          style: MyContant().TextSmalldebNote(),
                                        ),
                                      ],
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
                  // H010105220554415
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'การเงิน',
                        style: MyContant().h4normalStyle(),
                      ),
                      if (list_finance == null) ...[
                        Text(
                          'วันที่ : ',
                          style: MyContant().h4normalStyle(),
                        ),
                      ] else ...[
                        Text(
                          'วันที่ : ${list_finance!['date']}',
                          style: MyContant().h4normalStyle(),
                        ),
                      ],
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
                    child: list_finance == null
                        ? Container(
                            height: MediaQuery.of(context).size.height * 0.25,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'ไม่มีบันทึก',
                                      style: MyContant().h4normalStyle(),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        : Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            '${list_finance!['note']}',
                                            overflow: TextOverflow.clip,
                                            style:
                                                MyContant().TextSmalldebNote(),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'ผู้บันทึก : ${list_finance!['createName']}',
                                          style: MyContant().TextSmalldebNote(),
                                        ),
                                      ],
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'ติดตามหนี้ ',
                        style: MyContant().h4normalStyle(),
                      ),
                      if (list_debNote == null) ...[
                        Text(
                          'วันที่ : ',
                          style: MyContant().h4normalStyle(),
                        ),
                      ] else ...[
                        Text(
                          'วันที่ : ${list_debNote!['date']}',
                          style: MyContant().h4normalStyle(),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.2,
                    padding: EdgeInsets.all(2.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    child: list_debNote == null
                        ? Container(
                            height: MediaQuery.of(context).size.height * 0.25,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'ไม่มีบันทึก',
                                      style: MyContant().h4normalStyle(),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        : Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            '${list_debNote!['note']}',
                                            overflow: TextOverflow.clip,
                                            style:
                                                MyContant().TextSmalldebNote(),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'ผู้บันทึก : ${list_debNote!['createName']}',
                                          style: MyContant().TextSmalldebNote(),
                                        ),
                                      ],
                                    )
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'กฎหมาย',
                        style: MyContant().h4normalStyle(),
                      ),
                      if (list_law == null) ...[
                        Text(
                          'วันที่ : ',
                          style: MyContant().h4normalStyle(),
                        ),
                      ] else ...[
                        Text(
                          'วันที่ : ${list_law!['date']}',
                          style: MyContant().h4normalStyle(),
                        ),
                      ],
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
                    child: list_law == null
                        ? Container(
                            height: MediaQuery.of(context).size.height * 0.25,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'ไม่มีบันทึก',
                                      style: MyContant().h4normalStyle(),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        : Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            '${list_law!['note']}',
                                            overflow: TextOverflow.clip,
                                            style:
                                                MyContant().TextSmalldebNote(),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'ผู้บันทึก : ${list_law!['createName']}',
                                          style: MyContant().TextSmalldebNote(),
                                        ),
                                      ],
                                    )
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'ทะเบียน',
                        style: MyContant().h4normalStyle(),
                      ),
                      if (list_regis == null) ...[
                        Text(
                          'วันที่ : ',
                          style: MyContant().h4normalStyle(),
                        ),
                      ] else ...[
                        Text(
                          'วันที่ : ${list_regis!['date']}',
                          style: MyContant().h4normalStyle(),
                        ),
                      ],
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
                    child: list_regis == null
                        ? Container(
                            height: MediaQuery.of(context).size.height * 0.25,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'ไม่มีบันทึก',
                                      style: MyContant().h4normalStyle(),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        : Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            '${list_regis!['note']}',
                                            overflow: TextOverflow.clip,
                                            style:
                                                MyContant().TextSmalldebNote(),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'ผู้บันทึก : ${list_regis!['createName']}',
                                          style: MyContant().TextSmalldebNote(),
                                        ),
                                      ],
                                    )
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'บริการ',
                        style: MyContant().h4normalStyle(),
                      ),
                      if (list_checker == null) ...[
                        Text(
                          'วันที่ : ',
                          style: MyContant().h4normalStyle(),
                        ),
                      ] else ...[
                        Text(
                          'วันที่ : ${list_checker!['date']}',
                          style: MyContant().h4normalStyle(),
                        ),
                      ],
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
                    child: list_checker == null
                        ? Container(
                            height: MediaQuery.of(context).size.height * 0.25,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'ไม่มีบันทึก',
                                      style: MyContant().h4normalStyle(),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        : Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            '${list_checker!['note']}',
                                            overflow: TextOverflow.clip,
                                            style:
                                                MyContant().TextSmalldebNote(),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'ผู้บันทึก : ${list_checker!['createName']}',
                                          style: MyContant().TextSmalldebNote(),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
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

  Container content_list_mu4(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      child: ListView(
        children: [
          for (var i = 0; i <= 10; i++) ...[
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Page_Pay_Installment(
                      Debtordetail['signId'],
                      list_payDetail[i]['periodNo'],
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(251, 173, 55, 1),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'งวดที่ : ${list_payDetail[i]['periodNo']}',
                            style: MyContant().h4normalStyle(),
                          ),
                          Text(
                            'วันที่ชำระ : ${list_payDetail[i]['periodDate']}',
                            style: MyContant().h4normalStyle(),
                          ),
                        ],
                      ),
                      // SizedBox(
                      //   height: 5,
                      // ),
                      // Row(
                      //   children: [
                      //     Text(
                      //       'เลขที่ใบเสร็จ : ${list_payDetail[i]['receiptTranId']}',
                      //       style: MyContant().h4normalStyle(),
                      //     ),
                      //   ],
                      // ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'เงินต้น : ${list_payDetail[i]['periodPrice']}',
                            style: MyContant().h4normalStyle(),
                          ),
                          Text(
                            'คงเหลือ : ${list_payDetail[i]['remainPrice']}',
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
                            'ค่าปรับ : ${list_payDetail[i]['finePrice']}',
                            style: MyContant().h4normalStyle(),
                          ),
                          // Text(
                          //   'คงเหลือ : ${list_payDetail[i]['finePrice']}',
                          //   style: MyContant().h4normalStyle(),
                          // ),
                        ],
                      ),
                      // SizedBox(
                      //   height: 5,
                      // ),
                      // Row(
                      //   children: [
                      //     Expanded(
                      //       child: Text(
                      //         'ประเภทการรับ : ${list_payDetail[i]['payBy']}',
                      //         overflow: TextOverflow.clip,
                      //         style: MyContant().h4normalStyle(),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      SizedBox(
                        height: 5,
                      ),
                      line(),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Text(
                            'วันที่ชำระ : ${list_payDetail[i]['payDate']}',
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
                            'ชำระเงินต้น : ${list_payDetail[i]['payPrice']}',
                            style: MyContant().h4normalStyle(),
                          ),
                          Text(
                            'ชำระค่าปรับ : ${list_payDetail[i]['payFine']}',
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
                  menu_list("list_content_mu1");
                },
                child: Container(
                  margin: EdgeInsets.only(top: 4, left: 5),
                  height: 30,
                  padding: EdgeInsets.all(4.5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    color: active_mu1 == true
                        ? Color.fromRGBO(202, 121, 0, 1)
                        : Color.fromRGBO(251, 173, 55, 1),
                  ),
                  child: Text(
                    'รายการสินค้า',
                    style: MyContant().h4normalStyle(),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  menu_list("list_content_mu2");
                },
                child: Container(
                  margin: EdgeInsets.only(top: 4, left: 10),
                  height: 30,
                  padding: EdgeInsets.all(4.5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    color: active_mu2 == true
                        ? Color.fromRGBO(202, 121, 0, 1)
                        : Color.fromRGBO(251, 173, 55, 1),
                  ),
                  child: Text(
                    'หมายเหตุพิจารณาสินเชื่อ',
                    style: MyContant().h4normalStyle(),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  menu_list("list_content_mu3");
                },
                child: Container(
                  margin: EdgeInsets.only(top: 4, left: 10),
                  height: 30,
                  padding: EdgeInsets.all(4.5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    color: active_mu3 == true
                        ? Color.fromRGBO(202, 121, 0, 1)
                        : Color.fromRGBO(251, 173, 55, 1),
                  ),
                  child: Text(
                    'บันทึกหมายเหตุ',
                    style: MyContant().h4normalStyle(),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  menu_list("list_content_mu4");
                },
                child: Container(
                  margin: EdgeInsets.only(top: 4, left: 10, right: 5),
                  height: 30,
                  padding: EdgeInsets.all(4.5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    color: active_mu4 == true
                        ? Color.fromRGBO(202, 121, 0, 1)
                        : Color.fromRGBO(251, 173, 55, 1),
                  ),
                  child: Text(
                    'ชำระค่างวด',
                    style: MyContant().h4normalStyle(),
                  ),
                ),
              ),
            ],
          )
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
