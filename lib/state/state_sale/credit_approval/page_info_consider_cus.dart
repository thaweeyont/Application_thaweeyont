import 'dart:convert';

import 'package:application_thaweeyont/state/state_sale/credit_approval/page_pay_installment.dart';
import 'package:application_thaweeyont/utility/my_constant.dart';
import 'package:flutter/material.dart';
import 'package:loading_gifs/loading_gifs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../widgets/custom_appbar.dart';
import '../../authen.dart';
import 'package:application_thaweeyont/api.dart';

class Page_Info_Consider_Cus extends StatefulWidget {
  final String? signId;
  const Page_Info_Consider_Cus(this.signId, {Key? key}) : super(key: key);

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
  var Debtordetail,
      status = false,
      dataDebnote,
      debtorStatuscode,
      status_check404 = false;
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
      list_checker,
      list_paydetailsum;

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
    getDataDebtorDetailApprove();
  }

  Future<void> getDataDebtorDetailApprove() async {
    try {
      var respose = await http.post(
        Uri.parse('${api}debtor/detail'),
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
            Map<String, dynamic>.from(json.decode(respose.body));

        Debtordetail = datadebtorDetail['data'];

        setState(() {
          status = true;

          if (Debtordetail['quarantee']['1'].toString() != "[]") {
            list_quarantee1 =
                Map<String, dynamic>.from(Debtordetail['quarantee']['1']);
          }
          if (Debtordetail['quarantee']['2'].toString() != "[]") {
            list_quarantee2 =
                Map<String, dynamic>.from(Debtordetail['quarantee']['2']);
          }
          if (Debtordetail['quarantee']['3'].toString() != "[]") {
            list_quarantee3 =
                Map<String, dynamic>.from(Debtordetail['quarantee']['3']);
          }
          list_itemDetail =
              Map<String, dynamic>.from(Debtordetail['itemDetail']);

          if (Debtordetail['debtNote']['service'].toString() != "[]") {
            list_service =
                Map<String, dynamic>.from(Debtordetail['debtNote']['service']);
          }
          if (Debtordetail['debtNote']['finance'].toString() != "[]") {
            list_finance =
                Map<String, dynamic>.from(Debtordetail['debtNote']['finance']);
          }
          if (Debtordetail['debtNote']['debt'].toString() != "[]") {
            list_debNote =
                Map<String, dynamic>.from(Debtordetail['debtNote']['debt']);
          }
          if (Debtordetail['debtNote']['law'].toString() != "[]") {
            list_law =
                Map<String, dynamic>.from(Debtordetail['debtNote']['law']);
          }
          if (Debtordetail['debtNote']['regis'].toString() != "[]") {
            list_regis =
                Map<String, dynamic>.from(Debtordetail['debtNote']['regis']);
          }
          if (Debtordetail['debtNote']['checker'].toString() != "[]") {
            list_checker =
                Map<String, dynamic>.from(Debtordetail['debtNote']['checker']);
          }

          list_payDetail = Debtordetail['payDetail'];

          list_paydetailsum =
              Map<String, dynamic>.from(Debtordetail['payDetailSummary']);
        });
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
        status_check404 = true;

        showProgressDialog_404(context, 'แจ้งเตือน', 'ไม่พบข้อมูลที่ค้นหา');
      } else if (respose.statusCode == 405) {
        showProgressDialog_405(
            context, 'แจ้งเตือน', 'ไม่พบข้อมูล (${respose.statusCode})');
      } else if (respose.statusCode == 500) {
        showProgressDialog_500(
            context, 'แจ้งเตือน', 'ไม่พบข้อมูล (${respose.statusCode})');
      } else {
        showProgressDialog(context, 'แจ้งเตือน', 'กรุณาติดต่อผู้ดูแลระบบ!');
      }
    } catch (e) {
      print("ไม่มีข้อมูล $e");
      showProgressDialog_Notdata(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
  }

  void menuList(page) {
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
      appBar: const CustomAppbar(title: 'ค้นหาข้อมูล'),
      body: status == false
          ? Center(
              child: status_check404 == true
                  ? SizedBox(
                      height: MediaQuery.of(context).size.height * 0.25,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'ไม่พบข้อมูล',
                                style: MyContant().h4normalStyle(),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  : Container(
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
          : GestureDetector(
              child: Column(
                children: [
                  slidemenu(context),
                  if (active_mu1 == true) ...[
                    contentListMu1(context),
                  ],
                  if (active_mu2 == true) ...[
                    contentListMu2(context),
                  ],
                  if (active_mu3 == true) ...[
                    contentListMu3(context),
                  ],
                  if (active_mu4 == true) ...[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color.fromRGBO(251, 173, 55, 1),
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
                                      'รายการชำระค่างวด',
                                      style: MyContant().h4normalStyle(),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.7),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'เงินต้นคงเหลือ : ${list_paydetailsum!['remainPrice']}',
                                            style: MyContant().h3Style(),
                                          ),
                                          Text(
                                            'ค่าปรับคงเหลือ : ${list_paydetailsum!['finePrice']}',
                                            style: MyContant().h3Style(),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    contentListMu4(context),
                  ],
                ],
              ),
            ),
    );
  }

  Expanded contentListMu1(BuildContext context) {
    return Expanded(
      child: ListView(
        children: [
          const SizedBox(
            height: 5,
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 0, bottom: 0, left: 8, right: 8),
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(251, 173, 55, 1),
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
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
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(5),
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
                    const SizedBox(
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
                    const SizedBox(
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
                    const SizedBox(
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
                    const SizedBox(
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
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'อาชีพ : ',
                          style: MyContant().h4normalStyle(),
                        ),
                        Expanded(
                          child: Text(
                            '${Debtordetail['debtorCareer']}',
                            overflow: TextOverflow.clip,
                            style: MyContant().h4normalStyle(),
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
                          'สถานที่ใกล้เคียง : ${Debtordetail['debtorNearPlace']}',
                          style: MyContant().h4normalStyle(),
                        ),
                      ],
                    ),
                  ],
                ),
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
                      color: const Color.fromRGBO(251, 173, 55, 1),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
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
                    child: const TabBar(
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
                    height: MediaQuery.of(context).size.height * 0.28,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(251, 173, 55, 1),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
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
                    child: TabBarView(
                      children: <Widget>[
                        //ผู้ค้ำที1
                        SingleChildScrollView(
                          child: list_quarantee1 == null
                              ? SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.28,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.26,
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.white.withOpacity(0.7),
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(5),
                                            ),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'ไม่มีผู้ค้ำ',
                                                    style: MyContant()
                                                        .h4normalStyle(),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Container(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.26,
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
                                                      children: [
                                                        Text(
                                                            'เลขบัตรประชาชน : ${list_quarantee1!['smartId']}',
                                                            style: MyContant()
                                                                .h4normalStyle()),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'ชื่อ-สกุล : ',
                                                          style: MyContant()
                                                              .h4normalStyle(),
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            '${list_quarantee1!['name']}',
                                                            overflow:
                                                                TextOverflow
                                                                    .clip,
                                                            style: MyContant()
                                                                .h4normalStyle(),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
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
                                                            '${list_quarantee1!['address']}',
                                                            overflow:
                                                                TextOverflow
                                                                    .clip,
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
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'สถานที่ทำงาน : ',
                                                          style: MyContant()
                                                              .h4normalStyle(),
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            '${list_quarantee1!['workADdress']}',
                                                            overflow:
                                                                TextOverflow
                                                                    .clip,
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
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'อาชีพ : ',
                                                          style: MyContant()
                                                              .h4normalStyle(),
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            '${list_quarantee1!['career']}',
                                                            style: MyContant()
                                                                .h4normalStyle(),
                                                            overflow:
                                                                TextOverflow
                                                                    .clip,
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
                                                            'สถานที่ใกล้เคียง : ${list_quarantee1!['nearPlace']}',
                                                            style: MyContant()
                                                                .h4normalStyle()),
                                                      ],
                                                    ),
                                                  ],
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
                        //ผู้ค้ำที่2
                        SingleChildScrollView(
                          child: list_quarantee2 == null
                              ? SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.28,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.26,
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.white.withOpacity(0.7),
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(5),
                                            ),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'ไม่มีผู้ค้ำ',
                                                    style: MyContant()
                                                        .h4normalStyle(),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Container(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.26,
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
                                                      children: [
                                                        Text(
                                                            'เลขบัตรประชาชน : ${list_quarantee2!['smartId']}',
                                                            style: MyContant()
                                                                .h4normalStyle()),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'ชื่อ-สกุล : ',
                                                          style: MyContant()
                                                              .h4normalStyle(),
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            '${list_quarantee2!['name']}',
                                                            overflow:
                                                                TextOverflow
                                                                    .clip,
                                                            style: MyContant()
                                                                .h4normalStyle(),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
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
                                                            '${list_quarantee2!['address']}',
                                                            overflow:
                                                                TextOverflow
                                                                    .clip,
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
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'สถานที่ทำงาน : ',
                                                          style: MyContant()
                                                              .h4normalStyle(),
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            '${list_quarantee2!['workADdress']}',
                                                            overflow:
                                                                TextOverflow
                                                                    .clip,
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
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'อาชีพ : ',
                                                          style: MyContant()
                                                              .h4normalStyle(),
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            '${list_quarantee2!['career']}',
                                                            style: MyContant()
                                                                .h4normalStyle(),
                                                            overflow:
                                                                TextOverflow
                                                                    .clip,
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
                                                            'สถานที่ใกล้เคียง : ${list_quarantee2!['nearPlace']}',
                                                            style: MyContant()
                                                                .h4normalStyle()),
                                                      ],
                                                    ),
                                                  ],
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
                        //ผู้ค้ำที่3
                        SingleChildScrollView(
                          child: list_quarantee3 == null
                              ? SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.28,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.26,
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.white.withOpacity(0.7),
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(5),
                                            ),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'ไม่มีผู้ค้ำ',
                                                    style: MyContant()
                                                        .h4normalStyle(),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Container(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.26,
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
                                                      children: [
                                                        Text(
                                                            'เลขบัตรประชาชน : ${list_quarantee3!['smartId']}',
                                                            style: MyContant()
                                                                .h4normalStyle()),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'ชื่อ-สกุล : ${list_quarantee3!['name']}',
                                                          style: MyContant()
                                                              .h4normalStyle(),
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            '${list_quarantee3!['name']}',
                                                            overflow:
                                                                TextOverflow
                                                                    .clip,
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
                                                            '${list_quarantee3!['address']}',
                                                            overflow:
                                                                TextOverflow
                                                                    .clip,
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
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'สถานที่ทำงาน : ',
                                                          style: MyContant()
                                                              .h4normalStyle(),
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            '${list_quarantee3!['workADdress']}',
                                                            overflow:
                                                                TextOverflow
                                                                    .clip,
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
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'อาชีพ : ',
                                                          style: MyContant()
                                                              .h4normalStyle(),
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            '${list_quarantee3!['career']}',
                                                            style: MyContant()
                                                                .h4normalStyle(),
                                                            overflow:
                                                                TextOverflow
                                                                    .clip,
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
                                                          'สถานที่ใกล้เคียง : ${list_quarantee3!['nearPlace']}',
                                                          style: MyContant()
                                                              .h4normalStyle(),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(251, 173, 55, 1),
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
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
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(5),
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
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Text(
                          'ราคาเช่าซื้อ : ${Debtordetail['leaseTotal']} บาท',
                          style: MyContant().h4normalStyle(),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          'ดอกเบี้ย ${Debtordetail['interest']} %',
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
                          'กำหนดเวลา : ${Debtordetail['periodNo']} งวด',
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
                          'พนักงานขาย : ${Debtordetail['saleName']}',
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
                          'ผู้ตรวจสอบเครดิต : ${Debtordetail['creditName']}',
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
                          'ผู้อนุมัติสินเชื่อ : ${Debtordetail['approveName']}',
                          style: MyContant().h4normalStyle(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(251, 173, 55, 1),
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
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
                  const SizedBox(
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
                  const SizedBox(
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
                  const SizedBox(
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
                  const SizedBox(
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
                  const SizedBox(
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
                  const SizedBox(
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
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'หมายเหตุการขาย : ',
                              style: MyContant().TextSmalldebNote(),
                            ),
                            Expanded(
                              child: Text(
                                '${list_itemDetail!['saleNote']}',
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
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Expanded contentListMu2(BuildContext context) {
    return Expanded(
      child: ListView(
        children: [
          const SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 0, left: 8, right: 8),
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(251, 173, 55, 1),
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
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
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    child: Scrollbar(
                      child: ListView(
                        children: [
                          Column(
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
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
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
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    child: Scrollbar(
                      child: ListView(
                        children: [
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '${Debtordetail['headNote']}',
                                        style: MyContant().h4normalStyle(),
                                        overflow: TextOverflow.clip,
                                      ),
                                    ),
                                  ],
                                ),
                              )
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
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Expanded contentListMu3(BuildContext context) {
    return Expanded(
      child: ListView(
        children: [
          const SizedBox(
            height: 5,
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 0, left: 8, right: 8, bottom: 8),
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(251, 173, 55, 1),
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'เชคเกอร์ ',
                        style: MyContant().h4normalStyle(),
                      ),
                      if (list_service == null) ...[
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
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    height: MediaQuery.of(context).size.height * 0.3,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    child: list_service == null
                        ? Container(
                            height: MediaQuery.of(context).size.height * 0.25,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '',
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
                                    const SizedBox(
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
                  const SizedBox(
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
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    height: MediaQuery.of(context).size.height * 0.3,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: const BorderRadius.all(
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
                                      '',
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
                                    const SizedBox(
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
                  const SizedBox(
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
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    padding: const EdgeInsets.all(2.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: const BorderRadius.all(
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
                                      '',
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
                                    const SizedBox(
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
                  const SizedBox(
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
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    height: MediaQuery.of(context).size.height * 0.3,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    child: list_law == null
                        ? SizedBox(
                            height: MediaQuery.of(context).size.height * 0.25,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '',
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
                                    const SizedBox(
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
                  const SizedBox(
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
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    height: MediaQuery.of(context).size.height * 0.3,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: const BorderRadius.all(
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
                                      '',
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
                                    const SizedBox(
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
                  const SizedBox(
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
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    height: MediaQuery.of(context).size.height * 0.3,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: const BorderRadius.all(
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
                                      '',
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
                                    const SizedBox(
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
                  const SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Expanded contentListMu4(BuildContext context) {
    return Expanded(
      child: ListView(
        children: [
          for (var i = 0; i < list_payDetail.length; i++) ...[
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Page_Pay_Installment(
                        Debtordetail['signId'],
                        list_payDetail[i]['periodNo'],
                        list_payDetail),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(251, 173, 55, 1),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
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
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.7),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'ค่าปรับ : ${list_payDetail[i]['finePrice']}',
                                    style: MyContant().h4normalStyle(),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              line(),
                              const SizedBox(
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
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                    ],
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  SizedBox slidemenu(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.065,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(left: 8, top: 8, right: 2, bottom: 8),
                child: ElevatedButton(
                  onPressed: () {
                    menuList("list_content_mu1");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: active_mu1 == true
                        ? const Color.fromRGBO(202, 121, 0, 1)
                        : const Color.fromRGBO(251, 173, 55, 1),
                  ),
                  child: Text(
                    'รายการสินค้า',
                    style: MyContant().h4normalStyle(),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 8, top: 8, right: 2, bottom: 8),
                child: ElevatedButton(
                  onPressed: () {
                    menuList("list_content_mu2");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: active_mu2 == true
                        ? const Color.fromRGBO(202, 121, 0, 1)
                        : const Color.fromRGBO(251, 173, 55, 1),
                  ),
                  child: Text(
                    'หมายเหตุพิจารณาสินเชื่อ',
                    style: MyContant().h4normalStyle(),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 8, top: 8, right: 2, bottom: 8),
                child: ElevatedButton(
                  onPressed: () {
                    menuList("list_content_mu3");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: active_mu3 == true
                        ? const Color.fromRGBO(202, 121, 0, 1)
                        : const Color.fromRGBO(251, 173, 55, 1),
                  ),
                  child: Text(
                    'บันทึกหมายเหตุ',
                    style: MyContant().h4normalStyle(),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 8, top: 8, right: 2, bottom: 8),
                child: ElevatedButton(
                  onPressed: () {
                    menuList("list_content_mu4");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: active_mu4 == true
                        ? const Color.fromRGBO(202, 121, 0, 1)
                        : const Color.fromRGBO(251, 173, 55, 1),
                  ),
                  child: Text(
                    'ชำระค่างวด',
                    style: MyContant().h4normalStyle(),
                  ),
                ),
              ),
              const SizedBox(
                width: 6,
              )
            ],
          )
        ],
      ),
    );
  }

  SizedBox line() {
    return const SizedBox(
      height: 0,
      width: double.infinity,
      child: Divider(
        color: Color.fromARGB(255, 34, 34, 34),
      ),
    );
  }
}
