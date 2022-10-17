import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utility/my_constant.dart';
import '../../authen.dart';
import 'page_check_blacklist.dart';
import 'package:http/http.dart' as http;

import 'page_info_consider_cus.dart';

class Data_Cust_Approve extends StatefulWidget {
  final String? custId;
  Data_Cust_Approve(this.custId);
  // const Data_Cust_Approve({super.key});

  @override
  State<Data_Cust_Approve> createState() => _Data_Cust_ApproveState();
}

class _Data_Cust_ApproveState extends State<Data_Cust_Approve> {
  String userId = '', empId = '', firstName = '', lastName = '', tokenId = '';
  bool active_cl1 = true, active_cl2 = false, active_cl3 = false;
  String page = 'list_content1';

  List list_signDetail = [], list_quarantee = [];
  var valueapprove, valueStatus, status = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }

  Future<void> getData_Creditdetail() async {
    print(tokenId);
    print(widget.custId.toString());

    try {
      var respose = await http.post(
        Uri.parse('https://twyapp.com/twyapi/apiV1/credit/detail'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
        body: jsonEncode(<String, String>{
          'custId': widget.custId.toString(),
        }),
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> dataCreditdetail =
            new Map<String, dynamic>.from(json.decode(respose.body));

        status = true;
        valueapprove = dataCreditdetail['data'];
        setState(() {
          if (valueapprove['signDetail'].toString() != "") {
            list_signDetail = valueapprove['signDetail'];
          }
          active_cl1 = true;
          active_cl2 = false;
          active_cl3 = false;
        });

        print('#===> $valueapprove');
        // Navigator.pop(context);
      } else {
        setState(() {
          valueStatus = respose.statusCode;
        });
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
      showProgressDialog(context, 'แจ้งเตือน', 'ไม่พบข้อมูล');
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
    getData_Creditdetail();
  }

  Future<void> getData_quarantee() async {
    print(tokenId);
    print(widget.custId.toString());

    list_quarantee = [];
    try {
      var respose = await http.post(
        Uri.parse('https://twyapp.com/twyapi/apiV1/credit/quarantee'),
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
            new Map<String, dynamic>.from(json.decode(respose.body));

        setState(() {
          list_quarantee = dataQuarantee['data'];
        });

        Navigator.pop(context);
        print(list_quarantee);
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
              behavior: HitTestBehavior.opaque,
              onTap: () => FocusScope.of(context).requestFocus(
                FocusNode(),
              ),
              child: ListView(
                children: [
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
                                labelStyle: TextStyle(
                                    fontSize: 16, fontFamily: 'Prompt'),
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
                              height: MediaQuery.of(context).size.height * 0.22,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(251, 173, 55, 1),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                              ),
                              child: TabBarView(
                                children: <Widget>[
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
                                                style:
                                                    MyContant().h4normalStyle(),
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
                                                style:
                                                    MyContant().h4normalStyle(),
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
                                                style:
                                                    MyContant().h4normalStyle(),
                                              ),
                                              SizedBox(
                                                width: 15,
                                              ),
                                              Text(
                                                'อายุ : ${valueapprove['age']} ปี',
                                                style:
                                                    MyContant().h4normalStyle(),
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
                                                style:
                                                    MyContant().h4normalStyle(),
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
                                                style:
                                                    MyContant().h4normalStyle(),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  '${valueapprove['address']}',
                                                  overflow: TextOverflow.clip,
                                                  style: MyContant()
                                                      .h4normalStyle(),
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
                                                style:
                                                    MyContant().h4normalStyle(),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  '${valueapprove['address']}',
                                                  overflow: TextOverflow.clip,
                                                  style: MyContant()
                                                      .h4normalStyle(),
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'อาชีพ : ',
                                                style:
                                                    MyContant().h4normalStyle(),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  '${valueapprove['career']}',
                                                  overflow: TextOverflow.clip,
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'สถานที่ทำงาน : ',
                                                style:
                                                    MyContant().h4normalStyle(),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  '${valueapprove['workPlace']}',
                                                  overflow: TextOverflow.clip,
                                                  style: MyContant()
                                                      .h4normalStyle(),
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
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ] else ...[
                    if (valueStatus == 404 || valueStatus == 500) ...[
                      notData(context),
                    ],
                  ],
                  if (list_signDetail.isNotEmpty) ...[
                    slidemenu(context),
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

  Container slidemenu(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.07,
      // margin: EdgeInsets.all(10),
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Row(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  menu_list("list_content1");
                },
                child: Container(
                  // margin: EdgeInsets.all(5),
                  // height: 35,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
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
                  showProgressLoading(context);
                  getData_quarantee();
                },
                child: Container(
                  margin: EdgeInsets.only(left: 10),
                  // height: 35,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          Page_Check_Blacklist(valueapprove['smartId']),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(left: 10),
                  // height: 35,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
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

  Container content_list1(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
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
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 6),
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
      height: MediaQuery.of(context).size.height * 0.5,
      child: Scrollbar(
        child: ListView(
          children: [
            if (list_quarantee.isNotEmpty) ...[
              for (var i = 0; i < list_quarantee.length; i++) ...[
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            Page_Info_Consider_Cus(list_quarantee[i]['signId']),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 6),
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
