import 'dart:convert';
import 'dart:math';

import 'package:application_thaweeyont/utility/my_constant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/login_model.dart';
import '../authen.dart';
import 'pay_installment.dart';
import 'package:application_thaweeyont/api.dart';

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

  var Debtordetail, status = false, select_payDetail;
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

  List list_payDetail = [], dropdown_paydetail = [];

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

          if (Debtordetail['debtNote']['debt'].toString() != "[]") {
            list_debNote =
                new Map<String, dynamic>.from(Debtordetail['debtNote']['debt']);
          }
          if (Debtordetail['debtNote']['finance'].toString() != "[]") {
            list_finance = new Map<String, dynamic>.from(
                Debtordetail['debtNote']['finance']);
          }
          if (Debtordetail['debtNote']['service'].toString() != "[]") {
            list_service = new Map<String, dynamic>.from(
                Debtordetail['debtNote']['service']);
          }
          if (Debtordetail['debtNote']['law'].toString() != "[]") {
            list_law =
                new Map<String, dynamic>.from(Debtordetail['debtNote']['law']);
          }
          if (Debtordetail['debtNote']['regis'].toString() != "[]") {
            list_regis = new Map<String, dynamic>.from(
                Debtordetail['debtNote']['regis']);
          }
          if (Debtordetail['debtNote']['checker'].toString() != "[]") {
            list_checker = new Map<String, dynamic>.from(
                Debtordetail['debtNote']['checker']);
          }

          list_payDetail = Debtordetail['payDetail'];
        });
        // Navigator.pop(context);
        // print(list_quarantee1['smartId']);
      } else if (respose.statusCode == 400) {
        print(respose.statusCode);
        showProgressDialog_400(context, 'แจ้งเตือน', 'ไม่พบข้อมูล!');
      } else if (respose.statusCode == 401) {
        print(respose.statusCode);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => Authen(),
          ),
          (Route<dynamic> route) => false,
        );
      } else if (respose.statusCode == 404) {
        print(respose.statusCode);
        showProgressDialog_404(context, 'แจ้งเตือน', 'ไม่พบข้อมูล!');
      } else if (respose.statusCode == 500) {
        print(respose.statusCode);
        showProgressDialog_500(context, 'แจ้งเตือน', 'ไม่พบข้อมูล!');
      } else {
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
      showProgressDialog_Notdata(context, 'แจ้งเตือน', 'ข้อมูลไม่ถูกต้อง');
      // Navigator.pop(context);
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

  Future<Null> show_paydetail(sizeIcon, border, periodNo) async {
    var data_d = periodNo.toString().split('|');
    var perodNo_d = data_d[0].toString(),
        payDate_d = data_d[1].toString(),
        payPrice_d = data_d[2].toString(),
        payFine_d = data_d[3].toString();
    double size = MediaQuery.of(context).size.width;
    // bool btn_edit = false;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        behavior: HitTestBehavior.opaque,
        child: StatefulBuilder(
          builder: (context, setState) => Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(5),
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 0,
                    color: Colors.white,
                    child: Container(
                      // height: MediaQuery.of(context).size.height * 0.7,
                      margin: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          SizedBox(
                            height: size * 0.03,
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 15, right: 15),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                            color:
                                                Color.fromRGBO(202, 71, 150, 1),
                                            shape: BoxShape.circle),
                                        child: Icon(
                                          Icons.close,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              color: Color.fromRGBO(255, 218, 249, 1),
                            ),
                            margin: EdgeInsets.symmetric(vertical: 10),
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'งวดที่ : ',
                                      style: MyContant().h4normalStyle(),
                                    ),
                                    // input_pay_installment(sizeIcon, border),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(1),
                                        child: Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.07,
                                          padding: EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 4),
                                            child: DropdownButton(
                                              items: list_payDetail
                                                  .map((value) =>
                                                      DropdownMenuItem(
                                                        child: Text(
                                                          value['periodNo'],
                                                          style: MyContant()
                                                              .h4normalStyle(),
                                                        ),
                                                        value: value[
                                                                'periodNo'] +
                                                            '|' +
                                                            value['payDate'] +
                                                            '|' +
                                                            value['payPrice'] +
                                                            '|' +
                                                            value['payFine'],
                                                      ))
                                                  .toList(),
                                              onChanged: (newvalue) {
                                                setState(() {
                                                  select_payDetail = newvalue;
                                                  var data_s = select_payDetail
                                                      .toString()
                                                      .split('|');
                                                  perodNo_d =
                                                      data_s[0].toString();
                                                  payDate_d =
                                                      data_s[1].toString();
                                                  payPrice_d =
                                                      data_s[2].toString();
                                                  payFine_d =
                                                      data_s[3].toString();
                                                });
                                              },
                                              value: select_payDetail,
                                              isExpanded: true,
                                              underline: SizedBox(),
                                              hint: Align(
                                                child: Text(
                                                  'ไม่มี',
                                                  style: MyContant()
                                                      .TextInputSelect(),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              color: Color.fromRGBO(255, 218, 249, 1),
                            ),
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'งวดที่ : $perodNo_d',
                                      style: MyContant().h4normalStyle(),
                                    ),
                                    Text(
                                      'วันที่ชำระ : $payDate_d',
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
                                      'จำนวนเงิน : $payPrice_d',
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
                                      'ค่าปรับ : $payFine_d',
                                      style: MyContant().h4normalStyle(),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
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
      ),
    );
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
      height: MediaQuery.of(context).size.height * 0.07,
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 3),
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
                  margin: EdgeInsets.all(5),
                  height: 35,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
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
                  margin: EdgeInsets.all(5),
                  height: 35,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
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
                  margin: EdgeInsets.all(5),
                  height: 35,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
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
                  margin: EdgeInsets.all(5),
                  height: 35,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
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
            padding: const EdgeInsets.only(top: 4, left: 8, right: 8),
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
                                            'เลขบัตรประชาชน : ${list_quarantee1!['smartId']}',
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
                                          'ชื่อ-สกุล : ',
                                          style: MyContant().h4normalStyle(),
                                        ),
                                        Expanded(
                                          child: Text(
                                            '${list_quarantee1!['name']}',
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
                                          'ที่อยู่ : ',
                                          style: MyContant().h4normalStyle(),
                                        ),
                                        Expanded(
                                          child: Text(
                                            '${list_quarantee1!['address']}',
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
                                            '${list_quarantee1!['workADdress']}',
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
                                            'อาชีพ : ${list_quarantee1!['career']}',
                                            style: MyContant().h4normalStyle()),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                            'สถานที่ใกล้เคียง : ${list_quarantee1!['nearPlace']}',
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
                                            'เลขบัตรประชาชน : ${list_quarantee2!['smartId']}',
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
                                          'ชื่อ-สกุล : ',
                                          style: MyContant().h4normalStyle(),
                                        ),
                                        Expanded(
                                          child: Text(
                                            '${list_quarantee2!['name']}',
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
                                          'ที่อยู่ : ',
                                          style: MyContant().h4normalStyle(),
                                        ),
                                        Expanded(
                                          child: Text(
                                            '${list_quarantee2!['address']}',
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
                                            '${list_quarantee2!['workADdress']}',
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
                                            'อาชีพ : ${list_quarantee2!['career']}',
                                            style: MyContant().h4normalStyle()),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                            'สถานที่ใกล้เคียง : ${list_quarantee2!['nearPlace']}',
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
                                            'เลขบัตรประชาชน : ${list_quarantee3!['smartId']}',
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
                                          'ชื่อ-สกุล : ',
                                          style: MyContant().h4normalStyle(),
                                        ),
                                        Expanded(
                                          child: Text(
                                            '${list_quarantee3!['name']}',
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
                                          'ที่อยู่ : ',
                                          style: MyContant().h4normalStyle(),
                                        ),
                                        Expanded(
                                          child: Text(
                                            '${list_quarantee3!['address']}',
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
                                            '${list_quarantee3!['workADdress']}',
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text(
                      //   'รายละเอียดสัญญา : ',
                      //   style: MyContant().h4normalStyle(),
                      // ),
                      Expanded(
                        child: Text(
                            'รายละเอียดสัญญา : ${Debtordetail['signDetail']}',
                            // overflow: TextOverflow.clip,
                            style: MyContant().h4normalStyle()),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
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
                      Text('ชำระแล้ว : ${Debtordetail['periodNo']} งวด',
                          style: MyContant().h4normalStyle()),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'พนักงานขาย : ${Debtordetail['saleName']}',
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
                        child: Text(
                            'ผู้ตรวจสอบเครดิต : ${Debtordetail['creditName']}',
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
                      Text(
                          'ผู้อนุมัติสินเชื่อ : ${Debtordetail['approveName']}',
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
                  // Row(
                  //   children: [
                  //     Text(
                  //       'รายการสินค้า (หมายเหตุ สินค้าปกติ สินค้าเปลี่ยน สินค้ารับคืน)',
                  //       style: MyContant().TextSmallStyle(),
                  //     ),
                  //   ],
                  // ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('รายการ : ', style: MyContant().h4normalStyle()),
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
                      Text('ยี่ห้อ : ${list_itemDetail!['brandName']}',
                          style: MyContant().h4normalStyle()),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Text('ขนาด : ${list_itemDetail!['sizeName']}',
                          style: MyContant().h4normalStyle()),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Text('รุ่น/แบบ : ${list_itemDetail!['modelName']}',
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
                      Text('จำนวน : ${list_itemDetail!['qty']}',
                          style: MyContant().h4normalStyle()),
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
                                'หมายเหตุการขาย : ${list_itemDetail!['saleNote']}',
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
            padding: const EdgeInsets.only(top: 4, left: 8, right: 8),
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
                    height: MediaQuery.of(context).size.height * 0.2,
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
                    height: MediaQuery.of(context).size.height * 0.2,
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
            padding: const EdgeInsets.only(top: 4, left: 8, right: 8),
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
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    padding: EdgeInsets.all(8.0),
                    height: MediaQuery.of(context).size.height * 0.2,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.all(
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
                  // H010105090202023
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
                    height: MediaQuery.of(context).size.height * 0.2,
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
                    height: MediaQuery.of(context).size.height * 0.2,
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
                    height: MediaQuery.of(context).size.height * 0.2,
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
                    height: MediaQuery.of(context).size.height * 0.2,
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

  Container content_list_4(BuildContext context) {
    final sizeIcon = BoxConstraints(minWidth: 40, minHeight: 40);
    final border = OutlineInputBorder(
      borderSide: const BorderSide(
        color: Colors.transparent,
        width: 0,
      ),
      borderRadius: const BorderRadius.all(
        const Radius.circular(4.0),
      ),
    );
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      child: ListView(
        children: [
          if (list_payDetail.isNotEmpty) ...[
            for (var i = 0; i < list_payDetail.length; i++) ...[
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Pay_installment(
                        Debtordetail['signId'],
                        list_payDetail[i]['periodNo'],
                        list_payDetail,
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
