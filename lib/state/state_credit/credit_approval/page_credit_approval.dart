import 'dart:convert';

import 'package:application_thaweeyont/state/state_credit/credit_approval/page_check_blacklist.dart';
import 'package:application_thaweeyont/utility/my_constant.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../authen.dart';
import 'page_info_consider_cus.dart';

class Page_Credit_Approval extends StatefulWidget {
  const Page_Credit_Approval({super.key});

  @override
  State<Page_Credit_Approval> createState() => _Page_Credit_ApprovalState();
}

class _Page_Credit_ApprovalState extends State<Page_Credit_Approval> {
  String userId = '', empId = '', firstName = '', lastName = '', tokenId = '';
  String page = 'list_content1';
  bool active_cl1 = false, active_cl2 = false, active_cl3 = false;
  var valueapprove, status = false;
  List list_signDetail = [], list_quarantee = [];

  TextEditingController custId = TextEditingController();

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
  }

  Future<void> getData_approve() async {
    print(tokenId);
    print(custId.text);
    try {
      var respose = await http.post(
        Uri.parse('https://twyapp.com/twyapi/apiV1/credit/approve'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
        body: jsonEncode(<String, String>{
          'custId': custId.text,
        }),
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> dataApprove =
            new Map<String, dynamic>.from(json.decode(respose.body));

        status = true;
        valueapprove = dataApprove['data'];

        setState(() {
          list_signDetail = valueapprove['signDetail'];
        });

        Navigator.pop(context);
        print(list_signDetail);
      } else {
        // setState(() {
        //   valueStatus = respose.statusCode;
        // });
        Navigator.pop(context);
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

  Future<void> getData_quarantee() async {
    print(tokenId);
    print(custId.text);
    try {
      var respose = await http.post(
        Uri.parse('https://twyapp.com/twyapi/apiV1/credit/quarantee'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
        body: jsonEncode(<String, String>{
          'custId': custId.text,
        }),
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> dataQuarantee =
            new Map<String, dynamic>.from(json.decode(respose.body));

        setState(() {
          list_quarantee = dataQuarantee['data'];
        });

        // Navigator.pop(context);
        print(list_quarantee);
      } else {
        // setState(() {
        //   valueStatus = respose.statusCode;
        // });
        // Navigator.pop(context);
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
      active_cl1 = false;
      active_cl2 = false;
      active_cl3 = false;
    });
    switch (page) {
      case "list_content1":
        setState(() {
          page = "list_content1";
          active_cl1 = true;
        });
        break;
      case "list_content2":
        setState(() {
          page = "list_content2";
          active_cl2 = true;
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
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
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        behavior: HitTestBehavior.opaque,
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
                          'รหัสลูกค้า',
                          style: MyContant().h4normalStyle(),
                        ),
                        input_idcustomer(sizeIcon, border),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'ชื่อลูกค้า',
                          style: MyContant().h4normalStyle(),
                        ),
                        input_namecustomer(sizeIcon, border),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            group_btnsearch(),
            if (valueapprove != null) ...[
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
                          labelStyle:
                              TextStyle(fontSize: 16, fontFamily: 'Prompt'),
                          unselectedLabelColor: Colors.black,
                          tabs: [
                            Tab(text: 'ข้อมูลลูกค้า'),
                            Tab(text: 'ที่อยู่ลูกค้า'),
                            Tab(text: 'อาชีพ'),
                          ],
                        ),
                      ),
                      line(),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(251, 173, 55, 1),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                        ),
                        child: TabBarView(children: <Widget>[
                          //ข้อมูลลูกค้า
                          SingleChildScrollView(
                            child: Container(
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'เลขบัตรประชาชน : ${valueapprove['smartId']}',
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
                                        'ชื่อลูกค้า : ${valueapprove['custName']}',
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
                                        'เกิดวันที่ : ${valueapprove['birthday']}',
                                        style: MyContant().h4normalStyle(),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Text(
                                        'อายุ : ${valueapprove['age']} ปี',
                                        style: MyContant().h4normalStyle(),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'ชื่อรอง : ${valueapprove['nickName']}',
                                        style: MyContant().h4normalStyle(),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          //ที่อยู่ลูกค้า
                          SingleChildScrollView(
                            child: Container(
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                children: [
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
                                          '${valueapprove['address']}',
                                          overflow: TextOverflow.clip,
                                          style: MyContant().h4normalStyle(),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'ที่อยู่ใช้สินค้า : ',
                                        style: MyContant().h4normalStyle(),
                                      ),
                                      Expanded(
                                        child: Text(
                                          '${valueapprove['address']}',
                                          overflow: TextOverflow.clip,
                                          style: MyContant().h4normalStyle(),
                                        ),
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
                          //อาชีพ
                          SingleChildScrollView(
                            child: Container(
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'อาชีพ : ${valueapprove['career']}',
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
                                        'สถานที่ทำงาน : ${valueapprove['workPlace']}',
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
                        ]),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              slidemenu(context),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      'รายการที่ค้นหา',
                      style: MyContant().h2Style(),
                    ),
                  ],
                ),
              ),
              if (active_cl1 == true) ...[
                content_list1(context),
              ],
              if (active_cl2 == true) ...[
                content_list2(context),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Container content_list1(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Scrollbar(
        child: ListView(
          children: [
            if (list_signDetail.isNotEmpty) ...[
              for (var i = 0; i < list_signDetail.length; i++) ...[
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Page_Info_Consider_Cus(
                            list_signDetail[i]['signId']),
                      ),
                    );
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: Color.fromRGBO(251, 173, 55, 1),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'วันทำสัญญา : ${list_signDetail[i]['signDate']}',
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
                                'เลขที่สัญญา : ${list_signDetail[i]['signId']}',
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
                                'ชื่อสินค้า : ',
                                style: MyContant().h4normalStyle(),
                              ),
                              Expanded(
                                child: Text(
                                  '${list_signDetail[i]['itemName']}',
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'รหัสเขต : ${list_signDetail[i]['followAreaName']}',
                                style: MyContant().h4normalStyle(),
                              ),
                              Text(
                                'สถานะ : ${list_signDetail[i]['signStatusName']}',
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
      ),
    );
  }

  Container content_list2(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      child: Scrollbar(
        child: ListView(
          children: [
            if (list_quarantee.isNotEmpty) ...[
              for (var i = 0; i < list_quarantee.length; i++) ...[
                InkWell(
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => Page_Info_Consider_Cus(),
                    //   ),
                    // );
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: Color.fromRGBO(251, 173, 55, 1),
                      ),
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
                            children: [
                              Text(
                                'ชื่อ-สกุล : ${list_quarantee[i]['custName']}',
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
                                'ชื่อ-สกุลในสัญญา : ${list_quarantee[i]['signCustName']}',
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          ],
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
                  margin: EdgeInsets.only(top: 2, left: 10),
                  height: 32,
                  padding: EdgeInsets.all(6.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    color: active_cl1 == true
                        ? Color.fromRGBO(202, 121, 0, 1)
                        : Color.fromRGBO(251, 173, 55, 1),
                  ),
                  child: Text(
                    'ตรวจสอบหนี้สิน',
                    style: MyContant().h4normalStyle(),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  menu_list("list_content2");
                  getData_quarantee();
                },
                child: Container(
                  margin: EdgeInsets.only(top: 2, left: 10),
                  height: 32,
                  padding: EdgeInsets.all(6.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    color: active_cl2 == true
                        ? Color.fromRGBO(202, 121, 0, 1)
                        : Color.fromRGBO(251, 173, 55, 1),
                  ),
                  child: Text(
                    'รายละเอียดผู้ค้ำ',
                    style: MyContant().h4normalStyle(),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  // Navigator.pushNamed(
                  //     context, MyContant.routePageCheckBlacklist);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Page_Check_Blacklist(),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(top: 2, left: 10),
                  height: 32,
                  padding: EdgeInsets.all(6.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    color: Color.fromRGBO(251, 173, 55, 1),
                    // color: active_cl3 == true
                    //     ? Color.fromRGBO(202, 121, 0, 1)
                    //     : Color.fromRGBO(251, 173, 55, 1),
                  ),
                  child: Text(
                    'เช็ค Blacklist',
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

  Padding group_btnsearch() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Container(
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: TextButton(
                        style: MyContant().myButtonSearchStyle(),
                        onPressed: () {
                          showProgressLoading(context);
                          getData_approve();
                        },
                        child: const Text('ค้นหา'),
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: TextButton(
                        style: MyContant().myButtonCancelStyle(),
                        onPressed: () {},
                        child: const Text('ยกเลิก'),
                      ),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
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

  Expanded input_idcustomer(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: custId,
          onChanged: (keyword) {},
          decoration: InputDecoration(
            counterText: "",
            contentPadding: EdgeInsets.all(4),
            isDense: true,
            enabledBorder: border,
            focusedBorder: border,
            hintStyle: TextStyle(
              fontSize: 14,
            ),
            prefixIconConstraints: sizeIcon,
            suffixIconConstraints: sizeIcon,
            filled: true,
            fillColor: Colors.white,
          ),
          style: MyContant().TextInputStyle(),
        ),
      ),
    );
  }

  Expanded input_namecustomer(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          onChanged: (keyword) {},
          decoration: InputDecoration(
            counterText: "",
            contentPadding: EdgeInsets.all(4),
            isDense: true,
            enabledBorder: border,
            focusedBorder: border,
            hintStyle: TextStyle(
              fontSize: 14,
            ),
            prefixIconConstraints: sizeIcon,
            suffixIconConstraints: sizeIcon,
            filled: true,
            fillColor: Colors.white,
          ),
          style: MyContant().TextInputStyle(),
        ),
      ),
    );
  }
}
