import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utility/my_constant.dart';
import '../../authen.dart';
import 'page_check_blacklist.dart';
import 'package:http/http.dart' as http;

import 'page_info_consider_cus.dart';
import 'package:application_thaweeyont/api.dart';

class Data_Cust_Approve extends StatefulWidget {
  final String? custId, tranId;
  Data_Cust_Approve(this.custId, this.tranId);
  // const Data_Cust_Approve({super.key});

  @override
  State<Data_Cust_Approve> createState() => _Data_Cust_ApproveState();
}

class _Data_Cust_ApproveState extends State<Data_Cust_Approve> {
  String userId = '', empId = '', firstName = '', lastName = '', tokenId = '';
  bool active_cl1 = true, active_cl2 = false, active_cl3 = false;
  String page = 'list_content1';
  String? id = '1';
  final disabledItems = ['3'];

  Map<String, dynamic>? list_itemDetail, list_detail, dropdown_approve;
  String? select_approveTypeList;
  List list_signDetail = [],
      list_quarantee = [],
      dropdown_approveReasonList = [],
      dropdown_approveTypeList = [],
      dropdownTest = [];
  var valueapprove,
      value_approveDetail,
      valueStatus,
      select_approveReasonList,
      get_valueapprov,
      status = false;

  TextEditingController note_approve = TextEditingController();
  TextEditingController name_approve = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }

  Future<void> getData_Creditdetail() async {
    print(tokenId);
    print(widget.custId.toString());
    print(widget.tranId.toString());

    try {
      var respose = await http.post(
        Uri.parse('${beta_api_test}credit/detail'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
        body: jsonEncode(<String, String>{
          'custId': widget.custId.toString(),
          'tranApproveId': widget.tranId.toString()
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
          if (valueapprove['approveDetail']['itemDetail'].toString() != "") {
            list_itemDetail = new Map<String, dynamic>.from(
                valueapprove['approveDetail']['itemDetail']);
          }
          if (valueapprove['approveDetail']['detail'].toString() != "") {
            list_detail = new Map<String, dynamic>.from(
                valueapprove['approveDetail']['detail']);
          }

          get_valueapprov = list_detail!['approveStatus'];
          select_approveTypeList = get_valueapprov;
          // active_cl1 = true;
          // active_cl2 = false;
          // active_cl3 = false;
        });

        print('#===> ${get_valueapprov}');
        // Navigator.pop(context);
      } else if (respose.statusCode == 400) {
        print(respose.statusCode);
        showProgressDialog_400(
            context, 'แจ้งเตือน', '${respose.statusCode} ไม่พบข้อมูล!');
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
        showProgressDialog_404(
            context, 'แจ้งเตือน', '${respose.statusCode} ไม่พบข้อมูล!');
      } else if (respose.statusCode == 405) {
        print(respose.statusCode);
        showProgressDialog_405(context, 'แจ้งเตือน', 'ไม่พบข้อมูล!');
      } else if (respose.statusCode == 500) {
        print(respose.statusCode);
        showProgressDialog_500(
            context, 'แจ้งเตือน', '${respose.statusCode} ข้อมูลผิดพลาด!');
      } else {
        print(respose.statusCode);
        showProgressDialog(context, 'แจ้งเตือน', 'กรุณาติดต่อผู้ดูแลระบบ!');
      }
    } catch (e) {
      showProgressDialog_Notdata(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
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
    get_approveReasonList();
    get_approveTypeList();
  }

  Future<void> getData_quarantee() async {
    print(tokenId);
    print(widget.custId.toString());

    list_quarantee = [];
    try {
      var respose = await http.post(
        Uri.parse('${beta_api_test}credit/quarantee'),
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
        // print(list_quarantee);
        // print(respose.statusCode);
      } else if (respose.statusCode == 400) {
        print(respose.statusCode);
        showProgressDialog_400(
            context, 'แจ้งเตือน', 'Error ${respose.statusCode} ไม่พบข้อมูล!');
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
        showProgressDialog_404(
            context, 'แจ้งเตือน', '${respose.statusCode} ไม่พบข้อมูล!');
      } else if (respose.statusCode == 405) {
        print(respose.statusCode);
        showProgressDialog_405(context, 'แจ้งเตือน', 'ไม่พบข้อมูล!');
      } else if (respose.statusCode == 500) {
        print(respose.statusCode);
        showProgressDialog_500(
            context, 'แจ้งเตือน', '${respose.statusCode} ข้อมูลผิดพลาด!');
      } else {
        showProgressDialog(context, 'แจ้งเตือน', 'กรุณาติดต่อผู้ดูแลระบบ!');
      }
    } catch (e) {
      print("ไม่มีข้อมูล $e");
      showProgressDialog_Notdata(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
  }

  Future<void> get_approveTypeList() async {
    print(tokenId);

    try {
      var respose = await http.get(
        Uri.parse('${beta_api_test}setup/approveTypeList'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> data_approveTypeList =
            new Map<String, dynamic>.from(json.decode(respose.body));

        setState(() {
          dropdown_approveTypeList = data_approveTypeList['data'];
        });

        // Navigator.pop(context);
        print(dropdown_approveTypeList);
      } else if (respose.statusCode == 400) {
        print(respose.statusCode);
        showProgressDialog_400(
            context, 'แจ้งเตือน', 'Error ${respose.statusCode} ไม่พบข้อมูล!');
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
        showProgressDialog_404(
            context, 'แจ้งเตือน', '${respose.statusCode} ไม่พบข้อมูล!');
      } else if (respose.statusCode == 405) {
        print(respose.statusCode);
        showProgressDialog_405(context, 'แจ้งเตือน', 'ไม่พบข้อมูล!');
      } else if (respose.statusCode == 500) {
        print(respose.statusCode);
        showProgressDialog_500(
            context, 'แจ้งเตือน', '${respose.statusCode} ข้อมูลผิดพลาด!');
      } else {
        showProgressDialog(context, 'แจ้งเตือน', 'กรุณาติดต่อผู้ดูแลระบบ!');
      }
    } catch (e) {
      print("ไม่มีข้อมูล $e");
      showProgressDialog_Notdata(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
  }

  Future<void> get_approveReasonList() async {
    print(tokenId);

    try {
      var respose = await http.get(
        Uri.parse('${beta_api_test}setup/approveReasonList'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> dataapproveReasonList =
            new Map<String, dynamic>.from(json.decode(respose.body));

        setState(() {
          dropdown_approveReasonList = dataapproveReasonList['data'];
        });

        // Navigator.pop(context);
        // print(dropdown_approveReasonList);
      } else if (respose.statusCode == 400) {
        print(respose.statusCode);
        showProgressDialog_400(
            context, 'แจ้งเตือน', 'Error ${respose.statusCode} ไม่พบข้อมูล!');
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
        showProgressDialog_404(
            context, 'แจ้งเตือน', '${respose.statusCode} ไม่พบข้อมูล!');
      } else if (respose.statusCode == 405) {
        print(respose.statusCode);
        showProgressDialog_405(context, 'แจ้งเตือน', 'ไม่พบข้อมูล!');
      } else if (respose.statusCode == 500) {
        print(respose.statusCode);
        showProgressDialog_500(
            context, 'แจ้งเตือน', '${respose.statusCode} ข้อมูลผิดพลาด!');
      } else {
        showProgressDialog(context, 'แจ้งเตือน', 'กรุณาติดต่อผู้ดูแลระบบ!');
      }
    } catch (e) {
      print("ไม่มีข้อมูล $e");
      showProgressDialog_Notdata(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'ชื่อลูกค้า : ',
                                                style:
                                                    MyContant().h4normalStyle(),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  '${valueapprove['custName']}',
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
                  ],
                  // if (list_signDetail.isNotEmpty) ...[
                  slidemenu(context),
                  // if (active_cl1 == true) ...[
                  //   // content_list1(context),
                  // ],
                  // if (active_cl2 == true) ...[
                  //   content_list2(context),
                  // ],
                  // ],
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(251, 173, 55, 1),
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          )),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ชื่อสินค้า : ',
                                  style: MyContant().h4normalStyle(),
                                ),
                                Expanded(
                                  child: Text(
                                    '${list_itemDetail!['itemName']}',
                                    style: MyContant().h4normalStyle(),
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'ราคา/หน่วย : ${list_itemDetail!['unitPrice']}',
                                  style: MyContant().h4normalStyle(),
                                ),
                                Text(
                                  'จำนวน : ${list_itemDetail!['qty']}',
                                  style: MyContant().h4normalStyle(),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'จำนวนเงิน : ${list_itemDetail!['totalPrice']}',
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(251, 173, 55, 1),
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  'ประเภทสัญญา : ${list_detail!['signTypeName']}',
                                  style: MyContant().h4normalStyle(),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'ทำสัญญาที่ : ${list_detail!['makeSignPlace']}',
                                  style: MyContant().h4normalStyle(),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'ราคาตั้งขาย : ${list_detail!['leaseTotal']}  บาท',
                                  style: MyContant().h4normalStyle(),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'เงินดาวน์ : ${list_detail!['downPrice']}  บาท',
                                  style: MyContant().h4normalStyle(),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'ระยะส่ง(งวด) :  ${list_detail!['leasePeriod']} งวด',
                                  style: MyContant().h4normalStyle(),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'จำนวนที่ชำระ/งวด : ${list_detail!['periodPrice']}  บาท',
                                  style: MyContant().h4normalStyle(),
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'การพิจารณา : ',
                                  style: MyContant().h4normalStyle(),
                                ),
                                Expanded(
                                  child: Text(
                                    '${list_detail!['considerName']}',
                                    style: MyContant().h4normalStyle(),
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'ผู้ตรวจสอบเครดิต : ${list_detail!['checkerName']}',
                                  style: MyContant().h4normalStyle(),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'พนักงานขาย : ${list_detail!['saleName']}',
                                  style: MyContant().h4normalStyle(),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'ผู้ส่งขออนุมัติสินเชื่อ : ${list_detail!['sendApproveName']}',
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(251, 173, 55, 1),
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
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
                              height: MediaQuery.of(context).size.height * 0.15,
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
                                                    '${list_detail!['creditNote']}',
                                                    overflow: TextOverflow.clip,
                                                    style: MyContant()
                                                        .h4normalStyle(),
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
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(251, 173, 55, 1),
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
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
                              height: MediaQuery.of(context).size.height * 0.15,
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
                                                    '${list_detail!['headNote']}',
                                                    overflow: TextOverflow.clip,
                                                    style: MyContant()
                                                        .h4normalStyle(),
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
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(251, 173, 55, 1),
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'ผลการอนุมัติสินเชื่อ',
                                  style: MyContant().h4normalStyle(),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              height:
                                  MediaQuery.of(context).size.height * 0.465,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.7),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 8),
                                child: Container(
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8),
                                            child: Text(
                                              'ผลการพิจารณา : ',
                                              style:
                                                  MyContant().h4normalStyle(),
                                            ),
                                          ),
                                          select_TypeList(sizeIcon, border),
                                        ],
                                      ),
                                      // SizedBox(
                                      //   height: 5,
                                      // ),
                                      // Container(
                                      //   height:
                                      //       MediaQuery.of(context).size.height *
                                      //           0.1,
                                      //   decoration: BoxDecoration(
                                      //     color: Colors.white.withOpacity(0.6),
                                      //     borderRadius: BorderRadius.all(
                                      //       Radius.circular(5),
                                      //     ),
                                      //   ),
                                      //   child: Container(
                                      //     child: Column(
                                      //       children: [
                                      //         Row(
                                      //           children: [
                                      //             Expanded(
                                      //               child: RadioListTile(
                                      //                   contentPadding:
                                      //                       EdgeInsets.all(0.0),
                                      //                   value: '1',
                                      //                   groupValue: id,
                                      //                   title: Text(
                                      //                     'อนุมัติ',
                                      //                     style: MyContant()
                                      //                         .h4normalStyle(),
                                      //                   ),
                                      //                   onChanged: (value) {
                                      //                     setState(() {});
                                      //                   }),
                                      //             ),
                                      //             Expanded(
                                      //               child: RadioListTile(
                                      //                   contentPadding:
                                      //                       EdgeInsets.all(0.0),
                                      //                   value: '2',
                                      //                   groupValue: id,
                                      //                   title: Text(
                                      //                     'ไม่อนุมัติ',
                                      //                     style: MyContant()
                                      //                         .h4normalStyle(),
                                      //                   ),
                                      //                   onChanged: (value) {
                                      //                     setState(() {});
                                      //                   }),
                                      //             ),
                                      //             Expanded(
                                      //               child: RadioListTile(
                                      //                   contentPadding:
                                      //                       EdgeInsets.all(0.0),
                                      //                   value: '3',
                                      //                   groupValue: id,
                                      //                   title: Text(
                                      //                     'รอพิจารณา',
                                      //                     style: MyContant()
                                      //                         .h4normalStyle(),
                                      //                   ),
                                      //                   onChanged: (value) {
                                      //                     setState(() {});
                                      //                   }),
                                      //             ),
                                      //           ],
                                      //         ),
                                      //       ],
                                      //     ),
                                      //   ),
                                      // ),

                                      Row(
                                        children: [
                                          Text(
                                            'การอนุมัติสินเชื่อ : ',
                                            style: MyContant().h4normalStyle(),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          select_ReasonList(sizeIcon, border),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'หมายเหตุ : ',
                                            style: MyContant().h4normalStyle(),
                                          ),
                                          input_note_approve(sizeIcon, border),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'ผู้อนุมัติสินเชื่อ : ',
                                            style: MyContant().h4normalStyle(),
                                          ),
                                          input_NameApprove(sizeIcon, border),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Column(
                                            children: [
                                              Container(
                                                height: 30,
                                                width: 120,
                                                child: TextButton(
                                                  style: MyContant()
                                                      .myButtonSubmitStyle(),
                                                  onPressed: () {},
                                                  child: const Text('บันทึก'),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
    );
  }

  Container slidemenu(BuildContext context) {
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
      height: MediaQuery.of(context).size.height * 0.07,
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Row(
            children: [
              InkWell(
                onTap: () {
                  // menu_list("list_content1");
                  sign_Detail(sizeIcon, border);
                },
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                    color: Color.fromRGBO(251, 173, 55, 1),
                    // color: active_cl1 == true
                    //     ? Color.fromRGBO(202, 121, 0, 1)
                    //     : Color.fromRGBO(251, 173, 55, 1),
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
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                    color: Color.fromRGBO(251, 173, 55, 1),
                    // color: active_cl2 == true
                    //     ? Color.fromRGBO(202, 121, 0, 1)
                    //     : Color.fromRGBO(251, 173, 55, 1),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                            crossAxisAlignment: CrossAxisAlignment.start,
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

  Future<Null> sign_Detail(sizeIcon, border) async {
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
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 0,
                    color: Colors.white,
                    child: Container(
                      height: size * 1.5,
                      margin: EdgeInsets.all(5),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'ตรวจสอบหนี้สิน',
                                            style:
                                                MyContant().TextTitleDialog(),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 0,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 4),
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                          color: Color.fromARGB(
                                              255, 182, 182, 182),
                                          shape: BoxShape.circle),
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.63,
                            child: Scrollbar(
                              child: ListView(
                                children: [
                                  if (list_signDetail.isNotEmpty) ...[
                                    for (var i = 0;
                                        i < list_signDetail.length;
                                        i++) ...[
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  Page_Info_Consider_Cus(
                                                list_signDetail[i]['signId'],
                                              ),
                                            ),
                                          );
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 4, horizontal: 4),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(5),
                                              ),
                                              color: Color.fromRGBO(
                                                  251, 173, 55, 1),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'วันทำสัญญา : ${list_signDetail[i]['signDate']}',
                                                        style: MyContant()
                                                            .h4normalStyle(),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'เลขที่สัญญา : ${list_signDetail[i]['signId']}',
                                                        style: MyContant()
                                                            .h4normalStyle(),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'ชื่อสินค้า : ',
                                                        style: MyContant()
                                                            .h4normalStyle(),
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          '${list_signDetail[i]['itemName']}',
                                                          overflow:
                                                              TextOverflow.clip,
                                                          style: MyContant()
                                                              .h4normalStyle(),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        'รหัสเขต : ${list_signDetail[i]['followAreaName']}',
                                                        style: MyContant()
                                                            .h4normalStyle(),
                                                      ),
                                                      Text(
                                                        'สถานะ : ${list_signDetail[i]['signStatusName']}',
                                                        style: MyContant()
                                                            .h4normalStyle(),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
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
        ),
      ),
    );
  }

  Expanded select_TypeList(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Container(
          height: MediaQuery.of(context).size.width * 0.1,
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: Padding(
            padding: const EdgeInsets.only(left: 4),
            child: DropdownButton<String>(
              value: select_approveTypeList,
              items: dropdown_approveTypeList.isEmpty
                  ? []
                  : dropdown_approveTypeList
                      .map(
                        (value) => DropdownMenuItem<String>(
                          child: Text(
                            value['name'],
                            style: MyContant().TextInputStyle(),
                          ),
                          value: value['id'].toString(),
                        ),
                      )
                      .toList(),
              onChanged: disabledItems.contains(select_approveTypeList)
                  ? (String? newvalue) {
                      setState(() {
                        select_approveTypeList = newvalue;
                      });
                    }
                  : null,
              isExpanded: true,
              underline: SizedBox(),
              hint: Align(
                child: Text(
                  '',
                  style: MyContant().TextInputSelect(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Expanded select_ReasonList(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Container(
          height: MediaQuery.of(context).size.width * 0.1,
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: Padding(
            padding: const EdgeInsets.only(left: 4),
            child: DropdownButton(
              items: dropdown_approveReasonList
                  .map((value) => DropdownMenuItem(
                        child: Text(
                          value['name'],
                          style: MyContant().TextInputStyle(),
                        ),
                        value: value['id'],
                      ))
                  .toList(),
              onChanged: (newvalue) {
                setState(() {
                  select_approveReasonList = newvalue;
                });
              },
              value: select_approveReasonList,
              isExpanded: true,
              underline: SizedBox(),
              hint: Align(
                child: Text(
                  'กรุณาเลือกข้อมูล',
                  style: MyContant().TextInputSelect(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Expanded input_note_approve(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: TextField(
          controller: note_approve,
          onChanged: (keyword) {},
          minLines: 4,
          maxLines: null,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(4),
            isDense: true,
            enabledBorder: border,
            focusedBorder: border,
            hintText: 'หมายเหตุ',
            hintStyle: MyContant().hintTextStyle(),
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

  Expanded input_NameApprove(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: TextField(
          controller: name_approve,
          onChanged: (keyword) {},
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(4),
            isDense: true,
            enabledBorder: border,
            focusedBorder: border,
            hintText: '',
            hintStyle: MyContant().hintTextStyle(),
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
