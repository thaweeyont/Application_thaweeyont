import 'dart:convert';

import 'package:application_thaweeyont/state/state_credit/credit_approval/page_pay_installment.dart';
import 'package:application_thaweeyont/utility/my_constant.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../authen.dart';
import 'package:application_thaweeyont/api.dart';

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

          if (Debtordetail['quarantee']['1'].toString() != "[]") {
            list_quarantee1 =
                new Map<String, dynamic>.from(Debtordetail['quarantee']['1']);
          }
          if (Debtordetail['quarantee']['2'].toString() != "[]") {
            list_quarantee2 =
                new Map<String, dynamic>.from(Debtordetail['quarantee']['2']);
          }
          if (Debtordetail['quarantee']['3'].toString() != "[]") {
            list_quarantee3 =
                new Map<String, dynamic>.from(Debtordetail['quarantee']['3']);
          }
          list_itemDetail =
              new Map<String, dynamic>.from(Debtordetail['itemDetail']);

          if (Debtordetail['debtNote']['service'].toString() != "[]") {
            list_service = new Map<String, dynamic>.from(
                Debtordetail['debtNote']['service']);
          }
          if (Debtordetail['debtNote']['finance'].toString() != "[]") {
            list_finance = new Map<String, dynamic>.from(
                Debtordetail['debtNote']['finance']);
          }
          if (Debtordetail['debtNote']['debt'].toString() != "[]") {
            list_debNote =
                new Map<String, dynamic>.from(Debtordetail['debtNote']['debt']);
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

          list_paydetailsum =
              new Map<String, dynamic>.from(Debtordetail['payDetailSummary']);
        });
      } else if (respose.statusCode == 400) {
        print(respose.statusCode);
        showProgressDialog_400(
            context, '???????????????????????????', '${respose.statusCode} ?????????????????????????????????!');
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
            context, '???????????????????????????', '??????????????? Login ?????????????????????????????????????????????');
      } else if (respose.statusCode == 404) {
        status_check404 = true;
        print(respose.statusCode);
        showProgressDialog_404(
            context, '???????????????????????????', '${respose.statusCode} ?????????????????????????????????!');
      } else if (respose.statusCode == 405) {
        print(respose.statusCode);
        showProgressDialog_405(context, '???????????????????????????', '?????????????????????????????????!');
      } else if (respose.statusCode == 500) {
        print(respose.statusCode);
        showProgressDialog_500(
            context, '???????????????????????????', 'Error ${respose.statusCode} ?????????????????????????????????!');
      } else {
        showProgressDialog(context, '???????????????????????????', '??????????????????????????????????????????????????????????????????!');
      }
    } catch (e) {
      print("????????????????????????????????? $e");
      showProgressDialog_Notdata(
          context, '???????????????????????????', '??????????????????????????????????????????! ????????????????????????????????????????????????????????????');
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
          '?????????????????????????????????',
          style: MyContant().TitleStyle(),
        ),
      ),
      body: status == false
          ? Center(
              child: status_check404 == true
                  ? Container(
                      height: MediaQuery.of(context).size.height * 0.25,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '?????????????????????????????????',
                                style: MyContant().h4normalStyle(),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  : Container(
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
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  '????????????????????????????????????????????????',
                                  style: MyContant().h3Style(),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '?????????????????????????????????????????? : ${list_paydetailsum!['remainPrice']}',
                                  style: MyContant().h3Style(),
                                ),
                                Text(
                                  '?????????????????????????????????????????? : ${list_paydetailsum!['finePrice']}',
                                  style: MyContant().h3Style(),
                                ),
                              ],
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
            padding:
                const EdgeInsets.only(top: 4, bottom: 4, left: 8, right: 8),
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
                        '????????????????????????????????? : ${Debtordetail['signId']}',
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
                        '?????????????????????????????????????????? : ${Debtordetail['debtorSmartId']}',
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
                        '???????????? - ???????????? : ',
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
                        '????????????????????? : ',
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
                        '???????????????????????????????????? : ',
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
                        '??????????????? : ${Debtordetail['debtorCareer']}',
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
                        '???????????????????????????????????????????????? : ${Debtordetail['debtorNearPlace']}',
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
                        Tab(text: '??????????????????????????? 1'),
                        Tab(text: '??????????????????????????? 2'),
                        Tab(text: '??????????????????????????? 3'),
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
                        //????????????????????????1
                        SingleChildScrollView(
                          child: list_quarantee1 == null
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
                                            '?????????????????????????????????',
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
                                              '?????????????????????????????????????????? : ${list_quarantee1!['smartId']}',
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
                                            '????????????-???????????? : ',
                                            style: MyContant().h4normalStyle(),
                                          ),
                                          Expanded(
                                            child: Text(
                                              '${list_quarantee1!['name']}',
                                              overflow: TextOverflow.clip,
                                              style:
                                                  MyContant().h4normalStyle(),
                                            ),
                                          )
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
                                            '????????????????????? : ',
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
                                            '???????????????????????????????????? : ',
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
                                              '??????????????? : ${list_quarantee1!['career']}',
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
                                              '???????????????????????????????????????????????? : ${list_quarantee1!['nearPlace']}',
                                              style:
                                                  MyContant().h4normalStyle()),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                        //???????????????????????????2
                        SingleChildScrollView(
                          child: list_quarantee2 == null
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
                                            '?????????????????????????????????',
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
                                              '?????????????????????????????????????????? : ${list_quarantee2!['smartId']}',
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
                                            '????????????-???????????? : ',
                                            style: MyContant().h4normalStyle(),
                                          ),
                                          Expanded(
                                            child: Text(
                                              '${list_quarantee2!['name']}',
                                              overflow: TextOverflow.clip,
                                              style:
                                                  MyContant().h4normalStyle(),
                                            ),
                                          )
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
                                            '????????????????????? : ',
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
                                            '???????????????????????????????????? : ',
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
                                              '??????????????? : ${list_quarantee2!['career']}',
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
                                              '???????????????????????????????????????????????? : ${list_quarantee2!['nearPlace']}',
                                              style:
                                                  MyContant().h4normalStyle()),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                        //???????????????????????????3
                        SingleChildScrollView(
                          child: list_quarantee3 == null
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
                                            '?????????????????????????????????',
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
                                              '?????????????????????????????????????????? : ${list_quarantee3!['smartId']}',
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
                                            '????????????-???????????? : ${list_quarantee3!['name']}',
                                            style: MyContant().h4normalStyle(),
                                          ),
                                          Expanded(
                                            child: Text(
                                              '${list_quarantee3!['name']}',
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
                                            '????????????????????? : ',
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
                                            '???????????????????????????????????? : ',
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
                                            '??????????????? : ${list_quarantee3!['career']}',
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
                                            '???????????????????????????????????????????????? : ${list_quarantee3!['nearPlace']}',
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
                        '??????????????????????????????????????? : ${Debtordetail['signDate']}',
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
                        '???????????????????????????????????? : ${Debtordetail['leaseTotal']} ?????????',
                        style: MyContant().h4normalStyle(),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        '???????????????????????? ${Debtordetail['interest']} %',
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
                        '??????????????????????????? : ${Debtordetail['periodNo']} ?????????',
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
                        '?????????????????????????????? : ${Debtordetail['saleName']}',
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
                        '???????????????????????????????????????????????? : ${Debtordetail['creditName']}',
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
                        '?????????????????????????????????????????????????????? : ${Debtordetail['approveName']}',
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
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '?????????????????? : ',
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
                        '?????????????????? : ${list_itemDetail!['brandName']}',
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
                        '???????????? : ${list_itemDetail!['sizeName']}',
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
                        '????????????/????????? : ',
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
                        '?????????????????????????????????????????? : ',
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
                        '??????????????? : ${list_itemDetail!['qty']}',
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
                                '?????????????????????????????????????????? : ${list_itemDetail!['saleNote']}',
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
            padding: const EdgeInsets.only(top: 4, left: 8, right: 8),
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
                        '?????????????????????????????????????????????????????????????????????',
                        style: MyContant().h4normalStyle(),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    child: Scrollbar(
                      child: ListView(
                        children: [
                          Container(
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
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        '?????????????????????????????????????????????????????????????????????',
                        style: MyContant().h4normalStyle(),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    child: Scrollbar(
                      child: ListView(
                        children: [
                          Container(
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
            padding: const EdgeInsets.only(top: 4, left: 8, right: 8),
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
                        '???????????????????????? ',
                        style: MyContant().h4normalStyle(),
                      ),
                      if (list_service == null) ...[
                        Text(
                          '?????????????????? : ',
                          style: MyContant().h4normalStyle(),
                        ),
                      ] else ...[
                        Text(
                          '?????????????????? : ${list_service!['date']}',
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
                    height: MediaQuery.of(context).size.height * 0.3,
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
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          '??????????????????????????? : ${list_service!['createName']}',
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
                        '?????????????????????',
                        style: MyContant().h4normalStyle(),
                      ),
                      if (list_finance == null) ...[
                        Text(
                          '?????????????????? : ',
                          style: MyContant().h4normalStyle(),
                        ),
                      ] else ...[
                        Text(
                          '?????????????????? : ${list_finance!['date']}',
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
                    height: MediaQuery.of(context).size.height * 0.3,
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
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          '??????????????????????????? : ${list_finance!['createName']}',
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
                        '?????????????????????????????? ',
                        style: MyContant().h4normalStyle(),
                      ),
                      if (list_debNote == null) ...[
                        Text(
                          '?????????????????? : ',
                          style: MyContant().h4normalStyle(),
                        ),
                      ] else ...[
                        Text(
                          '?????????????????? : ${list_debNote!['date']}',
                          style: MyContant().h4normalStyle(),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.3,
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
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          '??????????????????????????? : ${list_debNote!['createName']}',
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
                        '??????????????????',
                        style: MyContant().h4normalStyle(),
                      ),
                      if (list_law == null) ...[
                        Text(
                          '?????????????????? : ',
                          style: MyContant().h4normalStyle(),
                        ),
                      ] else ...[
                        Text(
                          '?????????????????? : ${list_law!['date']}',
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
                    height: MediaQuery.of(context).size.height * 0.3,
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
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          '??????????????????????????? : ${list_law!['createName']}',
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
                        '?????????????????????',
                        style: MyContant().h4normalStyle(),
                      ),
                      if (list_regis == null) ...[
                        Text(
                          '?????????????????? : ',
                          style: MyContant().h4normalStyle(),
                        ),
                      ] else ...[
                        Text(
                          '?????????????????? : ${list_regis!['date']}',
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
                    height: MediaQuery.of(context).size.height * 0.3,
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
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          '??????????????????????????? : ${list_regis!['createName']}',
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
                        '??????????????????',
                        style: MyContant().h4normalStyle(),
                      ),
                      if (list_checker == null) ...[
                        Text(
                          '?????????????????? : ',
                          style: MyContant().h4normalStyle(),
                        ),
                      ] else ...[
                        Text(
                          '?????????????????? : ${list_checker!['date']}',
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
                    height: MediaQuery.of(context).size.height * 0.3,
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
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          '??????????????????????????? : ${list_checker!['createName']}',
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
      height: MediaQuery.of(context).size.height * 0.7,
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
                            '?????????????????? : ${list_payDetail[i]['periodNo']}',
                            style: MyContant().h4normalStyle(),
                          ),
                          Text(
                            '?????????????????????????????? : ${list_payDetail[i]['periodDate']}',
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
                      //       '??????????????????????????????????????? : ${list_payDetail[i]['receiptTranId']}',
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
                            '????????????????????? : ${list_payDetail[i]['periodPrice']}',
                            style: MyContant().h4normalStyle(),
                          ),
                          Text(
                            '????????????????????? : ${list_payDetail[i]['remainPrice']}',
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
                            '????????????????????? : ${list_payDetail[i]['finePrice']}',
                            style: MyContant().h4normalStyle(),
                          ),
                          // Text(
                          //   '????????????????????? : ${list_payDetail[i]['finePrice']}',
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
                      //         '???????????????????????????????????? : ${list_payDetail[i]['payBy']}',
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
                            '?????????????????????????????? : ${list_payDetail[i]['payDate']}',
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
                            '????????????????????????????????? : ${list_payDetail[i]['payPrice']}',
                            style: MyContant().h4normalStyle(),
                          ),
                          Text(
                            '????????????????????????????????? : ${list_payDetail[i]['payFine']}',
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
      height: MediaQuery.of(context).size.height * 0.065,
      padding: EdgeInsets.symmetric(vertical: 3, horizontal: 3),
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
                  margin: EdgeInsets.all(5),
                  height: 35,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                    color: active_mu1 == true
                        ? Color.fromRGBO(202, 121, 0, 1)
                        : Color.fromRGBO(251, 173, 55, 1),
                  ),
                  child: Text(
                    '????????????????????????????????????',
                    style: MyContant().h4normalStyle(),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  menu_list("list_content_mu2");
                },
                child: Container(
                  margin: EdgeInsets.all(5),
                  height: 35,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                    color: active_mu2 == true
                        ? Color.fromRGBO(202, 121, 0, 1)
                        : Color.fromRGBO(251, 173, 55, 1),
                  ),
                  child: Text(
                    '?????????????????????????????????????????????????????????????????????',
                    style: MyContant().h4normalStyle(),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  menu_list("list_content_mu3");
                },
                child: Container(
                  margin: EdgeInsets.all(5),
                  height: 35,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                    color: active_mu3 == true
                        ? Color.fromRGBO(202, 121, 0, 1)
                        : Color.fromRGBO(251, 173, 55, 1),
                  ),
                  child: Text(
                    '??????????????????????????????????????????',
                    style: MyContant().h4normalStyle(),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  menu_list("list_content_mu4");
                },
                child: Container(
                  margin: EdgeInsets.all(5),
                  height: 35,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                    color: active_mu4 == true
                        ? Color.fromRGBO(202, 121, 0, 1)
                        : Color.fromRGBO(251, 173, 55, 1),
                  ),
                  child: Text(
                    '??????????????????????????????',
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
