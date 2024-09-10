import 'dart:convert';

import 'package:application_thaweeyont/state/state_sale/credit_approval/data_list_quarantee.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_gifs/loading_gifs.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utility/my_constant.dart';
import '../../../widgets/custom_appbar.dart';
import '../../authen.dart';
import 'approve_creditquarantee.dart';
import 'credit_debtordetail.dart';
import 'credit_querydebtor.dart';
import 'page_check_blacklist.dart';
import 'package:http/http.dart' as http;

import 'page_info_consider_cus.dart';
import 'package:application_thaweeyont/api.dart';

class Data_Cust_Approve extends StatefulWidget {
  final String? custId, tranId;

  Data_Cust_Approve(this.custId, this.tranId);

  @override
  State<Data_Cust_Approve> createState() => _Data_Cust_ApproveState();
}

class _Data_Cust_ApproveState extends State<Data_Cust_Approve> {
  String userId = '', empId = '', firstName = '', lastName = '', tokenId = '';
  bool? allowApproveStatus;
  bool active_cl1 = true, active_cl2 = false, active_cl3 = false;
  String page = 'list_content1';
  String? id = '1';

  Map<String, dynamic>? list_itemDetail, list_detail;
  String? select_approveTypeList,
      valueSelectApprove,
      select_approveReasonList,
      select_NotapproveReasonList,
      get_valueapprov,
      get_valueReason;
  List list_signDetail = [],
      list_quarantee = [],
      dropdown_approveReasonList = [],
      dropdown_NotapproveReasonList = [],
      dropdown_approveTypeList = [],
      dropdownTest = [];
  var valueapprove,
      value_approveDetail,
      valueStatus,
      status = false,
      status_error401 = false;

  TextEditingController note_approve = TextEditingController();
  TextEditingController name_approve = TextEditingController();
  TextEditingController show_approve_credit = TextEditingController();
  TextEditingController showNamecredit = TextEditingController();

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
      allowApproveStatus = preferences.getBool('allowApproveStatus');
    });
    getDataCreditdetail();
    getApproveReasonList();
    getApproveTypeList();
    getNotApproveReasonList();
  }

  Future<void> getDataCreditdetail() async {
    try {
      var respose = await http.post(
        Uri.parse('${api}credit/detail'),
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
            Map<String, dynamic>.from(json.decode(respose.body));

        status = true;
        valueapprove = dataCreditdetail['data'];
        setState(() {
          if (valueapprove['signDetail'].toString() != "") {
            list_signDetail = valueapprove['signDetail'];
          }
          if (valueapprove['approveDetail']['itemDetail'].toString() != "[]") {
            list_itemDetail = Map<String, dynamic>.from(
                valueapprove['approveDetail']['itemDetail']);
          }
          if (valueapprove['approveDetail']['detail'].toString() != "") {
            list_detail = Map<String, dynamic>.from(
                valueapprove['approveDetail']['detail']);
          }

          get_valueapprov = list_detail!['approveStatus'];
          get_valueReason = list_detail!['approveReasonId'];

          select_approveTypeList = get_valueapprov;
          note_approve.text = list_detail!['approveNote'];

          if (get_valueapprov == '1' || get_valueapprov == '2') {
            name_approve.text = ' ${list_detail!['approveId']}'
                ' ${list_detail!['approveName']}';
          } else {
            name_approve.text = ' $empId'
                ' $firstName'
                ' $lastName';
          }

          if (get_valueapprov == '1') {
            select_approveReasonList = get_valueReason;
          } else if (get_valueapprov == '2') {
            select_NotapproveReasonList = get_valueReason;
          }

          showNamecredit.text = list_detail!['approveReasonName'];
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
        showProgressDialog_404(context, 'แจ้งเตือน', 'ไม่พบข้อมูลที่ค้นหา');
      } else if (respose.statusCode == 405) {
        showProgressDialog_405(
            context, 'แจ้งเตือน', 'ไม่พบข้อมูล (${respose.statusCode})');
      } else if (respose.statusCode == 500) {
        showProgressDialog_500(
            context, 'แจ้งเตือน', 'ข้อมูลผิดพลาด (${respose.statusCode})');
      } else {
        showProgressDialog(context, 'แจ้งเตือน', 'กรุณาติดต่อผู้ดูแลระบบ!');
      }
    } catch (e) {
      showProgressDialog_Notdata(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
      print("ไม่มีข้อมูล $e");
    }
  }

  Future<void> approveCredit() async {
    if (select_approveReasonList == "" || select_approveReasonList == null) {
      valueSelectApprove = select_NotapproveReasonList;
    } else if (select_NotapproveReasonList == "" ||
        select_NotapproveReasonList == null) {
      valueSelectApprove = select_approveReasonList;
    }

    try {
      var respose = await http.post(
        Uri.parse('${api}credit/approveCredit'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
        body: jsonEncode(<String, String>{
          'tranApproveId': widget.tranId.toString(),
          'approveStatus': select_approveTypeList.toString(),
          'approveReasonId': valueSelectApprove.toString(),
          'approveNote': note_approve.text
        }),
      );

      if (respose.statusCode == 200) {
        setState(() {
          Navigator.pop(context);
          getDataCreditdetail();
        });
        showAlertDialogSuccess();
      } else if (respose.statusCode == 400) {
        showProgressDialog_400(
            context, 'แจ้งเตือน', 'ไม่สำเร็จ (${respose.statusCode})');
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
        showProgressDialog_404(context, 'แจ้งเตือน', 'บันทึกข้อมูลไม่สำเร็จ');
      } else if (respose.statusCode == 405) {
        showProgressDialog_405(context, 'แจ้งเตือน',
            'บันทึกข้อมูลไม่สำเร็จ (${respose.statusCode})');
      } else if (respose.statusCode == 500) {
        showProgressDialog_500(
            context, 'แจ้งเตือน', 'ข้อมูลผิดพลาด (${respose.statusCode})');
      } else {
        showProgressDialog(context, 'แจ้งเตือน', 'กรุณาติดต่อผู้ดูแลระบบ!');
      }
    } catch (e) {
      print("ไม่มีข้อมูล $e");
      showProgressDialog_Notdata(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
  }

  Future<void> getApproveTypeList() async {
    try {
      var respose = await http.get(
        Uri.parse('${api}setup/approveTypeList'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> data_approveTypeList =
            Map<String, dynamic>.from(json.decode(respose.body));

        setState(() {
          dropdown_approveTypeList = data_approveTypeList['data'];
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
        showProgressDialog_404(context, 'แจ้งเตือน', 'ไม่พบข้อมูลที่ค้นหา');
      } else if (respose.statusCode == 405) {
        showProgressDialog_405(
            context, 'แจ้งเตือน', 'ไม่พบข้อมูล (${respose.statusCode})');
      } else if (respose.statusCode == 500) {
        showProgressDialog_500(
            context, 'แจ้งเตือน', 'ข้อมูลผิดพลาด ${respose.statusCode}');
      } else {
        showProgressDialog(context, 'แจ้งเตือน', 'กรุณาติดต่อผู้ดูแลระบบ!');
      }
    } catch (e) {
      print("ไม่มีข้อมูล $e");
      showProgressDialog_Notdata(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
  }

  Future<void> getApproveReasonList() async {
    try {
      var respose = await http.get(
        Uri.parse('${api}setup/approveReasonList'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> dataapproveReasonList =
            Map<String, dynamic>.from(json.decode(respose.body));

        setState(() {
          dropdown_approveReasonList = dataapproveReasonList['data'];
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
        showProgressDialog_404(context, 'แจ้งเตือน', 'ไม่พบข้อมูลที่ค้นหา');
      } else if (respose.statusCode == 405) {
        showProgressDialog_405(
            context, 'แจ้งเตือน', 'ไม่พบข้อมูล (${respose.statusCode})');
      } else if (respose.statusCode == 500) {
        showProgressDialog_500(
            context, 'แจ้งเตือน', 'ข้อมูลผิดพลาด (${respose.statusCode})');
      } else {
        showProgressDialog(context, 'แจ้งเตือน', 'กรุณาติดต่อผู้ดูแลระบบ!');
      }
    } catch (e) {
      print("ไม่มีข้อมูล $e");
      showProgressDialog_Notdata(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
  }

  Future<void> getNotApproveReasonList() async {
    try {
      var respose = await http.get(
        Uri.parse('${api}setup/notApproveReasonList'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> datanotReasonList =
            Map<String, dynamic>.from(json.decode(respose.body));

        setState(() {
          dropdown_NotapproveReasonList = datanotReasonList['data'];
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
        showProgressDialog_404(context, 'แจ้งเตือน', 'ไม่พบข้อมูลที่ค้นหา');
      } else if (respose.statusCode == 405) {
        showProgressDialog_405(
            context, 'แจ้งเตือน', 'ไม่พบข้อมูล (${respose.statusCode})');
      } else if (respose.statusCode == 500) {
        showProgressDialog_500(
            context, 'แจ้งเตือน', 'ข้อมูลผิดพลาด (${respose.statusCode})');
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
    const sizeIcon = BoxConstraints(minWidth: 40, minHeight: 40);
    const border = OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.transparent,
        width: 0,
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(4.0),
      ),
    );
    return Scaffold(
      appBar: const CustomAppbar(title: 'รายละเอียดข้อมูล'),
      body: status == false
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
          : GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => FocusScope.of(context).requestFocus(
                FocusNode(),
              ),
              child: ListView(
                children: [
                  if (valueapprove != null) ...[
                    Padding(
                      padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
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
                                indicatorColor: Colors.black,
                                labelStyle: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Prompt',
                                ),
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
                                  //ข้อมูลลูกค้า
                                  SingleChildScrollView(
                                    child: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.20,
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.white.withOpacity(0.7),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(5),
                                              ),
                                            ),
                                            child: Scrollbar(
                                              child: ListView(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              'เลขบัตรประชาชน : ${valueapprove['smartId']}',
                                                              style: MyContant()
                                                                  .h4normalStyle(),
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
                                                              'ชื่อลูกค้า : ',
                                                              style: MyContant()
                                                                  .h4normalStyle(),
                                                            ),
                                                            Expanded(
                                                              child: Text(
                                                                '${valueapprove['custName']}',
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
                                                          children: [
                                                            Text(
                                                              'เกิดวันที่ : ${valueapprove['birthday']}',
                                                              style: MyContant()
                                                                  .h4normalStyle(),
                                                            ),
                                                            const SizedBox(
                                                              width: 15,
                                                            ),
                                                            Text(
                                                              'อายุ : ${valueapprove['age']} ปี',
                                                              style: MyContant()
                                                                  .h4normalStyle(),
                                                            )
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              'ชื่อรอง : ${valueapprove['nickName']}',
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
                                  //ที่อยู่ลูกค้า
                                  SingleChildScrollView(
                                    child: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.20,
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.white.withOpacity(0.7),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(5),
                                              ),
                                            ),
                                            child: Scrollbar(
                                              child: ListView(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
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
                                                                '${valueapprove['address']}',
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
                                                          height: 10,
                                                        ),
                                                        Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              'ที่อยู่ใช้สินค้า : ',
                                                              style: MyContant()
                                                                  .h4normalStyle(),
                                                            ),
                                                            Expanded(
                                                              child: Text(
                                                                '${valueapprove['address']}',
                                                                overflow:
                                                                    TextOverflow
                                                                        .clip,
                                                                style: MyContant()
                                                                    .h4normalStyle(),
                                                              ),
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
                                          const SizedBox(
                                            height: 5,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  //อาชีพ
                                  SingleChildScrollView(
                                    child: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.20,
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.white.withOpacity(0.7),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(5),
                                              ),
                                            ),
                                            child: Scrollbar(
                                              child: ListView(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Column(
                                                      children: [
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
                                                                '${valueapprove['career']}',
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
                                                                '${valueapprove['workPlace']}',
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
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
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
                  slidemenu(context),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 8, right: 8, bottom: 4),
                    child: list_itemDetail == null
                        ? Container(
                            height: MediaQuery.of(context).size.height * 0.13,
                            decoration: const BoxDecoration(
                              color: Color.fromRGBO(251, 173, 55, 1),
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.11,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.7),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(5),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'ไม่พบรายการสินค้า',
                                          style: MyContant().h4normalStyle(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(251, 173, 55, 1),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(5),
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
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                  spaceText(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                  spaceText(),
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
                        color: const Color.fromRGBO(251, 173, 55, 1),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(5),
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
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  'รันนิ่งสัญญา : ${list_detail!['signRunning']}',
                                  style: MyContant().h4normalStyle(),
                                ),
                              ],
                            ),
                            spaceText(),
                            Row(
                              children: [
                                Text(
                                  'ประเภทสัญญา : ${list_detail!['signTypeName']}',
                                  style: MyContant().h4normalStyle(),
                                ),
                              ],
                            ),
                            spaceText(),
                            Row(
                              children: [
                                Text(
                                  'ทำสัญญาที่ : ${list_detail!['makeSignPlace']}',
                                  style: MyContant().h4normalStyle(),
                                ),
                              ],
                            ),
                            spaceText(),
                            Row(
                              children: [
                                Text(
                                  'ราคาตั้งขาย : ${list_detail!['leaseTotal']}  บาท',
                                  style: MyContant().h4normalStyle(),
                                ),
                              ],
                            ),
                            spaceText(),
                            Row(
                              children: [
                                Text(
                                  'เงินดาวน์ : ${list_detail!['downPrice']}  บาท',
                                  style: MyContant().h4normalStyle(),
                                ),
                              ],
                            ),
                            spaceText(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'ดอกเบี้ย :  ${list_detail!['interestPercent']} %',
                                  style: MyContant().h4normalStyle(),
                                ),
                                Text(
                                  'รวม :  ${list_detail!['interestTotal']} บาท',
                                  style: MyContant().h4normalStyle(),
                                ),
                              ],
                            ),
                            spaceText(),
                            Row(
                              children: [
                                Text(
                                  'ระยะส่ง(งวด) :  ${list_detail!['leasePeriod']} งวด',
                                  style: MyContant().h4normalStyle(),
                                ),
                              ],
                            ),
                            spaceText(),
                            Row(
                              children: [
                                Text(
                                  'จำนวนที่ชำระ/งวด : ${list_detail!['periodPrice']}  บาท',
                                  style: MyContant().h4normalStyle(),
                                ),
                              ],
                            ),
                            spaceText(),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ผู้ตรวจสอบเครดิต : ',
                                  style: MyContant().h4normalStyle(),
                                ),
                                Expanded(
                                  child: Text(
                                    '${list_detail!['checkerName']}',
                                    overflow: TextOverflow.clip,
                                    style: MyContant().h4normalStyle(),
                                  ),
                                ),
                              ],
                            ),
                            spaceText(),
                            Row(
                              children: [
                                Text(
                                  'พนักงานขาย : ${list_detail!['saleName']}',
                                  style: MyContant().h4normalStyle(),
                                ),
                              ],
                            ),
                            spaceText(),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ผู้ส่งขออนุมัติสินเชื่อ : ',
                                  style: MyContant().h4normalStyle(),
                                ),
                                Expanded(
                                  child: Text(
                                    '${list_detail!['sendApproveName']}',
                                    overflow: TextOverflow.clip,
                                    style: MyContant().h4normalStyle(),
                                  ),
                                ),
                              ],
                            ),
                            spaceText(),
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
                        color: const Color.fromRGBO(251, 173, 55, 1),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(5),
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
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  'การพิจารณา',
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
                                                  '${list_detail!['considerName']}',
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
                        color: const Color.fromRGBO(251, 173, 55, 1),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(5),
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
                        color: const Color.fromRGBO(251, 173, 55, 1),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(5),
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
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (allowApproveStatus == true) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(251, 173, 55, 1),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(5),
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
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                height: list_detail!['approveStatus'] == '3'
                                    ? MediaQuery.of(context).size.height * 0.72
                                    : MediaQuery.of(context).size.height * 0.75,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.7),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8, bottom: 8, left: 8, right: 8),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                          selectTypeList(sizeIcon, border),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'การอนุมัติสินเชื่อ : ',
                                            style: MyContant().h4normalStyle(),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      if (list_detail!['approveStatus'] ==
                                          '3') ...[
                                        Row(
                                          children: [
                                            if (select_approveTypeList ==
                                                '1') ...[
                                              selectReasonList(
                                                  sizeIcon, border),
                                            ] else if (select_approveTypeList ==
                                                '2') ...[
                                              selectNotReasonList(
                                                  sizeIcon, border),
                                            ] else ...[
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.14,
                                              )
                                            ]
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                      ] else ...[
                                        Row(
                                          children: [
                                            inputshowNamecredit(
                                                sizeIcon, border),
                                          ],
                                        ),
                                      ],
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'หมายเหตุ : ',
                                            style: MyContant().h4normalStyle(),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          inputNoteApprove(sizeIcon, border),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'ผู้อนุมัติสินเชื่อ : ',
                                            style: MyContant().h4normalStyle(),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          inputNameApprove(sizeIcon, border),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              if (list_detail!['approveStatus'] == '3' &&
                                  allowApproveStatus == true) ...[
                                const SizedBox(
                                  height: 5,
                                ),
                                Column(
                                  children: [
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.1,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.7),
                                        borderRadius: const BorderRadius.all(
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
                                              SizedBox(
                                                height: 35,
                                                width: 120,
                                                child: ElevatedButton(
                                                  style: MyContant()
                                                      .myButtonSubmitStyle(),
                                                  onPressed: () {
                                                    if (select_approveTypeList ==
                                                        '1') {
                                                      if (select_approveReasonList ==
                                                              null ||
                                                          select_approveReasonList ==
                                                              "") {
                                                        showProgressDialog(
                                                            context,
                                                            'แจ้งเตือน',
                                                            'กรุณาเลือกการอนุมัติสินเชื่อ');
                                                      } else {
                                                        if (note_approve
                                                            .text.isEmpty) {
                                                          showProgressDialog(
                                                              context,
                                                              'แจ้งเตือน',
                                                              'กรุณากรอกหมายเหตุ');
                                                        } else {
                                                          showAlertDialogSubmit();
                                                        }
                                                      }
                                                    } else if (select_approveTypeList ==
                                                        '2') {
                                                      if (select_NotapproveReasonList ==
                                                              null ||
                                                          select_NotapproveReasonList ==
                                                              '') {
                                                        showProgressDialog(
                                                            context,
                                                            'แจ้งเตือน',
                                                            'กรุณาเลือกการอนุมัติสินเชื่อ');
                                                      } else {
                                                        if (note_approve
                                                            .text.isEmpty) {
                                                          showProgressDialog(
                                                              context,
                                                              'แจ้งเตือน',
                                                              'กรุณากรอกหมายเหตุ');
                                                        } else {
                                                          showAlertDialogSubmit();
                                                        }
                                                      }
                                                    } else {
                                                      showProgressDialog(
                                                          context,
                                                          'แจ้งเตือน',
                                                          'กรุณาเลือกผลการพิจารณาสินเชื่อ');
                                                    }
                                                  },
                                                  child: const Text('บันทึก'),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
    );
  }

  SizedBox spaceText() {
    return const SizedBox(
      height: 3,
    );
  }

  Container slidemenu(BuildContext context) {
    const sizeIcon = BoxConstraints(minWidth: 40, minHeight: 40);
    const border = OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.transparent,
        width: 0,
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(4.0),
      ),
    );
    return Container(
      height: MediaQuery.of(context).size.height * 0.07,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Row(
            children: [
              const SizedBox(
                width: 8,
              ),
              if (allowApproveStatus == true) ...[
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CreditDebtorDetail(widget.custId),
                          ));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(251, 173, 55, 1),
                    ),
                    child: Text(
                      'ตรวจสอบหนี้สิน',
                      style: MyContant().h4normalStyle(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DataListQuarantee(
                            widget.custId.toString(),
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(251, 173, 55, 1),
                    ),
                    child: Text(
                      'รายละเอียดผู้ค้ำ',
                      style: MyContant().h4normalStyle(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              Page_Check_Blacklist(valueapprove['smartId']),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(251, 173, 55, 1),
                    ),
                    child: Text(
                      'เช็ค Blacklist',
                      style: MyContant().h4normalStyle(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreditQueryDebtor(
                            valueapprove['address'],
                            valueapprove['homeNo'],
                            valueapprove['moo'],
                            valueapprove['provId'],
                            valueapprove['amphurId'],
                            valueapprove['tumbolId'],
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(251, 173, 55, 1),
                    ),
                    child: Text(
                      'สอบถามลูกหนี้',
                      style: MyContant().h4normalStyle(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ApproveCreditQuarantee(widget.tranId.toString()),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(251, 173, 55, 1),
                    ),
                    child: Text(
                      'บันทึกผู้ค้ำประกัน',
                      style: MyContant().h4normalStyle(),
                    ),
                  ),
                ),
              ] else ...[
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ApproveCreditQuarantee(widget.tranId.toString()),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(251, 173, 55, 1),
                    ),
                    child: Text(
                      'บันทึกผู้ค้ำประกัน',
                      style: MyContant().h4normalStyle(),
                    ),
                  ),
                ),
              ]
            ],
          )
        ],
      ),
    );
  }

  Future<void> signDetail(sizeIcon, border) async {
    double size = MediaQuery.of(context).size.width;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        behavior: HitTestBehavior.opaque,
        child: StatefulBuilder(
          builder: (context, setState) => Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(5),
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
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.85,
                      // margin: const EdgeInsets.all(5),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 12, bottom: 6),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'ตรวจสอบหนี้สิน',
                                          style: MyContant().h4normalStyle(),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                right: 0,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 4),
                                    child: Icon(
                                      Icons.close,
                                      size: 30,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Divider(
                            color: Color.fromARGB(255, 185, 185, 185),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.7,
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
                                              vertical: 4, horizontal: 8),
                                          child: Container(
                                            decoration: const BoxDecoration(
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

  Expanded selectTypeList(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Container(
          height: MediaQuery.of(context).size.width * 0.1,
          padding: const EdgeInsets.all(4),
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
                          value: value['id'].toString(),
                          child: Text(
                            value['name'],
                            style: MyContant().textInputStyle(),
                          ),
                        ),
                      )
                      .toList(),
              onChanged: list_detail!['approveStatus'] == '3'
                  ? (String? newvalue) {
                      setState(() {
                        select_approveTypeList = newvalue;
                      });
                      if (select_approveTypeList == '1') {
                        getApproveReasonList();
                      } else if (select_approveTypeList == '2') {
                        getNotApproveReasonList();
                      }
                    }
                  : null,
              isExpanded: true,
              underline: const SizedBox(),
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

  Expanded selectReasonList(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.14,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: DropdownButton<String>(
              items: dropdown_approveReasonList.isEmpty
                  ? []
                  : dropdown_approveReasonList
                      .map(
                        (value) => DropdownMenuItem<String>(
                          value: value['id'].toString(),
                          child: Container(
                            width: double.infinity,
                            // alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.fromLTRB(0, 6.0, 0, 6.0),
                            decoration: const BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  color: Color.fromARGB(255, 209, 209, 209),
                                ),
                              ),
                            ),
                            child: Text(
                              value['name'],
                              style: MyContant().textInputStyle(),
                            ),
                          ),
                        ),
                      )
                      .toList(),
              onChanged: list_detail!['approveStatus'] == '3'
                  ? (String? newvalue) {
                      setState(() {
                        select_approveReasonList = newvalue;
                      });
                    }
                  : null,
              value: select_approveReasonList,
              isExpanded: true,
              itemHeight: null,
              // underline: SizedBox(),
              hint: Align(
                alignment: Alignment.center,
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

  Expanded selectNotReasonList(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.1,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: DropdownButton<String>(
              items: dropdown_NotapproveReasonList.isEmpty
                  ? []
                  : dropdown_NotapproveReasonList
                      .map((value) => DropdownMenuItem<String>(
                            value: value['id'].toString(),
                            child: Container(
                              width: double.infinity,
                              padding:
                                  const EdgeInsets.fromLTRB(0, 8.0, 0, 6.0),
                              decoration: const BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                    color: Color.fromARGB(255, 209, 209, 209),
                                  ),
                                ),
                              ),
                              child: Text(
                                value['name'],
                                style: MyContant().textInputStyle(),
                              ),
                            ),
                          ))
                      .toList(),
              onChanged: list_detail!['approveStatus'] == '3'
                  ? (String? newvalue) {
                      setState(() {
                        select_NotapproveReasonList = newvalue;
                      });
                    }
                  : null,
              value: select_NotapproveReasonList,
              isExpanded: true,
              itemHeight: null,
              // underline: SizedBox(),
              hint: Align(
                alignment: Alignment.center,
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

  Expanded inputshowNamecredit(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: TextField(
          controller: showNamecredit,
          onChanged: (keyword) {},
          minLines: 4,
          maxLines: null,
          readOnly: true,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(6),
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
          style: MyContant().textInputStyle(),
        ),
      ),
    );
  }

  Expanded inputNoteApprove(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: TextField(
          controller: note_approve,
          onChanged: (keyword) {},
          minLines: 5,
          maxLines: null,
          readOnly: list_detail!['approveStatus'] == '3' ? false : true,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
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
          style: MyContant().textInputStyle(),
        ),
      ),
    );
  }

  Expanded inputApproveCredit(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: TextField(
          controller: show_approve_credit,
          onChanged: (keyword) {},
          minLines: 2,
          maxLines: null,
          readOnly: true,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(4),
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
          style: MyContant().textInputStyle(),
        ),
      ),
    );
  }

  Expanded inputNameApprove(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: TextField(
          controller: name_approve,
          onChanged: (keyword) {},
          readOnly: true,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(8),
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
          style: MyContant().textInputStyle(),
        ),
      ),
    );
  }

  SizedBox line() {
    return const SizedBox(
      height: 0,
      width: double.infinity,
      child: Divider(
        color: Color.fromARGB(255, 112, 112, 112),
      ),
    );
  }

  showDialogTest() {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return Theme(
          data: ThemeData(dialogBackgroundColor: Colors.orange),
          child: CupertinoAlertDialog(
            title: const Text(
              'แจ้งเตือน',
              style: TextStyle(
                fontFamily: 'Prompt',
                fontSize: 18,
                color: Colors.black,
                // fontWeight: FontWeight.normal,
              ),
            ),
            content: const Text(
              'คุณต้องการบันทึกข้อมูลใช่หรือไม่ ?',
              style: TextStyle(
                fontFamily: 'Prompt',
                fontSize: 16,
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'ยกเลิก',
                  style: TextStyle(
                    fontFamily: 'Prompt',
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'ตกลง',
                  style: TextStyle(
                    fontFamily: 'Prompt',
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  showAlertDialogSubmit() async {
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!

      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 22, vertical: 5),
          title: Row(
            children: [
              const Text(
                "อนุมัติสินเชื่อ",
                style: TextStyle(
                  fontSize: 17,
                  fontFamily: 'Prompt',
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Image.asset('images/question.gif',
                  width: 25, height: 25, fit: BoxFit.contain),
            ],
          ),
          content: const Text(
            "คุณต้องการบันทึกข้อมูลใช่หรือไม่",
            style: TextStyle(fontFamily: 'Prompt', fontSize: 16),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'ยกเลิก',
                style: TextStyle(
                    fontFamily: 'Prompt',
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.normal),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'ตกลง',
                style: TextStyle(
                    fontFamily: 'Prompt',
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.normal),
              ),
              onPressed: () {
                setState(() {
                  Navigator.of(context).pop();
                  showProgressLoading(context);
                  approveCredit();
                });
              },
            ),
          ],
        );
      },
    );
  }

  showAlertDialogSuccess() async {
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!

      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 22, vertical: 5),
          title: Row(
            children: [
              Image.asset('images/success.gif',
                  width: 40, height: 40, fit: BoxFit.contain),
              const SizedBox(width: 5),
              const Text(
                "สำเร็จ",
                style: TextStyle(
                  fontSize: 17,
                  fontFamily: 'Prompt',
                ),
              ),
            ],
          ),
          content: const Text(
            "บันทึกข้อมูลสำเร็จเรียบร้อย",
            style: TextStyle(fontFamily: 'Prompt', fontSize: 16),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'ตกลง',
                style: TextStyle(
                    fontFamily: 'Prompt',
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.normal),
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
                // Navigator.pop(context, 'refresh');
              },
            ),
          ],
        );
      },
    );
  }
}
