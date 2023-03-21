import 'dart:convert';

import 'package:application_thaweeyont/state/state_credit/credit_approval/credit_data_detail.dart';
import 'package:application_thaweeyont/state/state_credit/credit_approval/data_list_quarantee.dart';
import 'package:application_thaweeyont/widgets/show_progress.dart';
import 'package:flutter/material.dart';
import 'package:loading_gifs/loading_gifs.dart';
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

  @override
  void initState() {
    // TODO: implement initState
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
    getData_Creditdetail();
    get_approveReasonList();
    get_approveTypeList();
    get_notApproveReasonList();
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
          if (valueapprove['approveDetail']['detail'].toString() != "[]") {
            list_detail = new Map<String, dynamic>.from(
                valueapprove['approveDetail']['detail']);
          }

          get_valueapprov = list_detail!['approveStatus'];
          get_valueReason = list_detail!['approveReasonId'];
          print('value->${get_valueReason}');
          select_approveTypeList = get_valueapprov;
          note_approve.text = list_detail!['approveNote'];

          if (get_valueapprov == '1' || get_valueapprov == '2') {
            name_approve.text = ' ${list_detail!['approveId']}'
                ' ${list_detail!['approveName']}';
          } else {
            name_approve.text = ' ${empId}'
                ' ${firstName}'
                ' ${lastName}';
          }

          if (get_valueapprov == '1') {
            select_approveReasonList = get_valueReason;
          } else if (get_valueapprov == '2') {
            select_NotapproveReasonList = get_valueReason;
          }
        });

        print('data=>>${dataCreditdetail['status']}');
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
        showProgressDialog_404(context, 'แจ้งเตือน', 'ไม่พบข้อมูล!');
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

  Future<void> ApproveCredit() async {
    if (select_approveReasonList == "" || select_approveReasonList == null) {
      print('1=>>$select_approveReasonList');
      valueSelectApprove = select_NotapproveReasonList;
    } else if (select_NotapproveReasonList == "" ||
        select_NotapproveReasonList == null) {
      print('2=>>$select_NotapproveReasonList');
      valueSelectApprove = select_approveReasonList;
    }
    print(widget.tranId);
    print(select_approveTypeList);
    print(valueSelectApprove);
    print(note_approve.text);

    try {
      var respose = await http.post(
        Uri.parse('${beta_api_test}credit/approveCredit'),
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
        print('data=>>${respose.body}');
        setState(() {
          Navigator.pop(context);
          getData_Creditdetail();
        });
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
      print("ไม่มีข้อมูล $e");
      showProgressDialog_Notdata(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
  }

  // Future<void> getData_quarantee() async {
  //   print(tokenId);
  //   print(widget.custId.toString());

  //   try {
  //     var respose = await http.post(
  //       Uri.parse('${beta_api_test}credit/quarantee'),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json',
  //         'Authorization': tokenId.toString(),
  //       },
  //       body: jsonEncode(<String, String>{
  //         'custId': widget.custId.toString(),
  //       }),
  //     );

  //     if (respose.statusCode == 200) {
  //       Map<String, dynamic> dataQuarantee =
  //           new Map<String, dynamic>.from(json.decode(respose.body));

  //       setState(() {
  //         list_quarantee = dataQuarantee['data'];
  //       });

  //       print('data_1->>${list_quarantee}');
  //     } else if (respose.statusCode == 400) {
  //       print(respose.statusCode);
  //       showProgressDialog_400(
  //           context, 'แจ้งเตือน', 'Error ${respose.statusCode} ไม่พบข้อมูล!');
  //     } else if (respose.statusCode == 401) {
  //       print(respose.statusCode);
  //       SharedPreferences preferences = await SharedPreferences.getInstance();
  //       preferences.clear();
  //       Navigator.pushAndRemoveUntil(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => Authen(),
  //         ),
  //         (Route<dynamic> route) => false,
  //       );
  //       showProgressDialog_401(
  //           context, 'แจ้งเตือน', 'กรุณา Login เข้าสู่ระบบใหม่');
  //     } else if (respose.statusCode == 404) {
  //       print(respose.statusCode);
  //       status_error401 = true;
  //       // showProgressDialog_404(context, 'แจ้งเตือน', 'ไม่พบข้อมูลผู้ค้ำ!');
  //     } else if (respose.statusCode == 405) {
  //       print(respose.statusCode);
  //       showProgressDialog_405(context, 'แจ้งเตือน', 'ไม่พบข้อมูล!');
  //     } else if (respose.statusCode == 500) {
  //       print(respose.statusCode);
  //       showProgressDialog_500(
  //           context, 'แจ้งเตือน', '${respose.statusCode} ข้อมูลผิดพลาด!');
  //     } else {
  //       showProgressDialog(context, 'แจ้งเตือน', 'กรุณาติดต่อผู้ดูแลระบบ!');
  //     }
  //   } catch (e) {
  //     print("ไม่มีข้อมูล $e");
  //     showProgressDialog_Notdata(
  //         context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
  //   }
  // }

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

        print(dropdown_approveReasonList);
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

  Future<void> get_notApproveReasonList() async {
    print(tokenId);

    try {
      var respose = await http.get(
        Uri.parse('${beta_api_test}setup/notApproveReasonList'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> datanotReasonList =
            new Map<String, dynamic>.from(json.decode(respose.body));

        setState(() {
          dropdown_NotapproveReasonList = datanotReasonList['data'];
        });

        // Navigator.pop(context);
        print(dropdown_approveReasonList);
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
                  color: Color.fromARGB(255, 24, 24, 24).withOpacity(0.9),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // CircularProgressIndicator(),
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
                                          Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.20,
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.white.withOpacity(0.7),
                                              borderRadius: BorderRadius.all(
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
                                                    child: Container(
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
                                                          SizedBox(
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
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                'เกิดวันที่ : ${valueapprove['birthday']}',
                                                                style: MyContant()
                                                                    .h4normalStyle(),
                                                              ),
                                                              SizedBox(
                                                                width: 15,
                                                              ),
                                                              Text(
                                                                'อายุ : ${valueapprove['age']} ปี',
                                                                style: MyContant()
                                                                    .h4normalStyle(),
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
                                  //ที่อยู่ลูกค้า
                                  SingleChildScrollView(
                                    child: Container(
                                      padding: EdgeInsets.all(8.0),
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
                                              borderRadius: BorderRadius.all(
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
                                                    child: Container(
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
                                                          SizedBox(
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
                                                  ),
                                                ],
                                              ),
                                            ),
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
                                          Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.20,
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.white.withOpacity(0.7),
                                              borderRadius: BorderRadius.all(
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
                                                    child: Container(
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
                                                          SizedBox(
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
                        const EdgeInsets.only(left: 8, right: 8, bottom: 4),
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
                            spaceText(),
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
                              children: [
                                Text(
                                  'ผู้ตรวจสอบเครดิต : ${list_detail!['checkerName']}',
                                  style: MyContant().h4normalStyle(),
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
                              children: [
                                Text(
                                  'ผู้ส่งขออนุมัติสินเชื่อ : ${list_detail!['sendApproveName']}',
                                  style: MyContant().h4normalStyle(),
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
                                  'การพิจารณา',
                                  style: MyContant().h4normalStyle(),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height * 0.1,
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
                  if (allowApproveStatus == true) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
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
                                height: list_detail!['approveStatus'] == '3'
                                    ? MediaQuery.of(context).size.height * 0.43
                                    : MediaQuery.of(context).size.height * 0.43,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.7),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 16, bottom: 8, left: 8, right: 8),
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
                                        Row(
                                          children: [
                                            Text(
                                              'การอนุมัติสินเชื่อ : ',
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
                                            if (select_approveTypeList ==
                                                '1') ...[
                                              select_ReasonList(
                                                  sizeIcon, border),
                                            ] else if (select_approveTypeList ==
                                                '2') ...[
                                              select_notReasonList(
                                                  sizeIcon, border),
                                            ] else ...[
                                              SizedBox(
                                                height: 48,
                                              )
                                            ]
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'หมายเหตุ : ',
                                              style:
                                                  MyContant().h4normalStyle(),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        Row(
                                          children: [
                                            input_note_approve(
                                                sizeIcon, border),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'ผู้อนุมัติสินเชื่อ : ',
                                              style:
                                                  MyContant().h4normalStyle(),
                                            ),
                                            input_NameApprove(sizeIcon, border),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              if (list_detail!['approveStatus'] == '3' &&
                                  allowApproveStatus == true) ...[
                                SizedBox(
                                  height: 5,
                                ),
                                Column(
                                  children: [
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.07,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.7),
                                        borderRadius: BorderRadius.all(
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
                                              Container(
                                                height: 35,
                                                width: 120,
                                                child: ElevatedButton(
                                                  style: MyContant()
                                                      .myButtonSubmitStyle(),
                                                  onPressed: () {
                                                    print('click_submit');
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
                                                        showProgressLoading(
                                                            context);
                                                        ApproveCredit();
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
                                                        showProgressLoading(
                                                            context);
                                                        ApproveCredit();
                                                      }
                                                    } else {
                                                      showProgressDialog(
                                                          context,
                                                          'แจ้งเตือน',
                                                          'กรุณาเปลี่ยนผลการพิจารณาสินเชื่อ');
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
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
    );
  }

  SizedBox spaceText() {
    return SizedBox(
      height: 3,
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
                  sign_Detail(sizeIcon, border);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 7, vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                    color: Color.fromRGBO(251, 173, 55, 1),
                  ),
                  child: Text(
                    'ตรวจสอบหนี้สิน',
                    style: MyContant().h4normalStyle(),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DataListQuarantee(
                          widget.custId.toString(),
                        ),
                      ));
                  // quarantee(sizeIcon, border);
                },
                child: Container(
                  margin: EdgeInsets.only(left: 10),
                  padding: EdgeInsets.symmetric(horizontal: 7, vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                    color: Color.fromRGBO(251, 173, 55, 1),
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
                  padding: EdgeInsets.symmetric(horizontal: 7, vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                    color: Color.fromRGBO(251, 173, 55, 1),
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

  // Container content_list1(BuildContext context) {
  //   return Container(
  //     height: MediaQuery.of(context).size.height * 0.5,
  //     child: Scrollbar(
  //       child: ListView(
  //         children: [
  //           if (list_signDetail.isNotEmpty) ...[
  //             for (var i = 0; i < list_signDetail.length; i++) ...[
  //               InkWell(
  //                 onTap: () {
  //                   Navigator.push(
  //                     context,
  //                     MaterialPageRoute(
  //                       builder: (context) => Page_Info_Consider_Cus(
  //                           list_signDetail[i]['signId']),
  //                     ),
  //                   );
  //                 },
  //                 child: Padding(
  //                   padding: const EdgeInsets.symmetric(horizontal: 8),
  //                   child: Container(
  //                     margin: EdgeInsets.symmetric(vertical: 6),
  //                     padding: EdgeInsets.all(8.0),
  //                     decoration: BoxDecoration(
  //                       borderRadius: BorderRadius.all(Radius.circular(5)),
  //                       color: Color.fromRGBO(251, 173, 55, 1),
  //                     ),
  //                     child: Column(
  //                       children: [
  //                         Row(
  //                           children: [
  //                             Text(
  //                               'วันทำสัญญา : ${list_signDetail[i]['signDate']}',
  //                               style: MyContant().h4normalStyle(),
  //                             ),
  //                           ],
  //                         ),
  //                         SizedBox(
  //                           height: 5,
  //                         ),
  //                         Row(
  //                           children: [
  //                             Text(
  //                               'เลขที่สัญญา : ${list_signDetail[i]['signId']}',
  //                               style: MyContant().h4normalStyle(),
  //                             ),
  //                           ],
  //                         ),
  //                         SizedBox(
  //                           height: 5,
  //                         ),
  //                         Row(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             Text(
  //                               'ชื่อสินค้า : ',
  //                               style: MyContant().h4normalStyle(),
  //                             ),
  //                             Expanded(
  //                               child: Text(
  //                                 '${list_signDetail[i]['itemName']}',
  //                                 overflow: TextOverflow.clip,
  //                                 style: MyContant().h4normalStyle(),
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                         SizedBox(
  //                           height: 5,
  //                         ),
  //                         Row(
  //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                           children: [
  //                             Text(
  //                               'รหัสเขต : ${list_signDetail[i]['followAreaName']}',
  //                               style: MyContant().h4normalStyle(),
  //                             ),
  //                             Text(
  //                               'สถานะ : ${list_signDetail[i]['signStatusName']}',
  //                               style: MyContant().h4normalStyle(),
  //                             ),
  //                           ],
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ],
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Container content_list2(BuildContext context) {
  //   return Container(
  //     height: MediaQuery.of(context).size.height * 0.5,
  //     child: Scrollbar(
  //       child: ListView(
  //         children: [
  //           if (list_quarantee.isNotEmpty) ...[
  //             for (var i = 0; i < list_quarantee.length; i++) ...[
  //               InkWell(
  //                 onTap: () {
  //                   Navigator.push(
  //                     context,
  //                     MaterialPageRoute(
  //                       builder: (context) =>
  //                           Page_Info_Consider_Cus(list_quarantee[i]['signId']),
  //                     ),
  //                   );
  //                 },
  //                 child: Padding(
  //                   padding: const EdgeInsets.symmetric(horizontal: 8),
  //                   child: Container(
  //                     margin: EdgeInsets.symmetric(vertical: 6),
  //                     padding: EdgeInsets.all(8.0),
  //                     decoration: BoxDecoration(
  //                       borderRadius: BorderRadius.all(Radius.circular(5)),
  //                       color: Color.fromRGBO(251, 173, 55, 1),
  //                     ),
  //                     child: Column(
  //                       children: [
  //                         Row(
  //                           children: [
  //                             Text(
  //                               'เลขที่สัญญา : ${list_quarantee[i]['signId']}',
  //                               style: MyContant().h4normalStyle(),
  //                             ),
  //                           ],
  //                         ),
  //                         SizedBox(
  //                           height: 5,
  //                         ),
  //                         Row(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             Text(
  //                               'ชื่อ-สกุล : ',
  //                               style: MyContant().h4normalStyle(),
  //                             ),
  //                             Expanded(
  //                               child: Text(
  //                                 '${list_quarantee[i]['custName']}',
  //                                 overflow: TextOverflow.clip,
  //                                 style: MyContant().h4normalStyle(),
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                         SizedBox(
  //                           height: 5,
  //                         ),
  //                         Row(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             Text(
  //                               'ชื่อ-สกุลในสัญญา : ',
  //                               style: MyContant().h4normalStyle(),
  //                             ),
  //                             Expanded(
  //                               child: Text(
  //                                 '${list_quarantee[i]['signCustName']}',
  //                                 overflow: TextOverflow.clip,
  //                                 style: MyContant().h4normalStyle(),
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                         SizedBox(
  //                           height: 5,
  //                         ),
  //                         Row(
  //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                           children: [
  //                             Text(
  //                               'ยอดคงเหลือ : ${list_quarantee[i]['remainPrice']}',
  //                               style: MyContant().h4normalStyle(),
  //                             ),
  //                             Text(
  //                               'สถานะ : ${list_quarantee[i]['personStatusName']}',
  //                               style: MyContant().h4normalStyle(),
  //                             ),
  //                           ],
  //                         ),
  //                         SizedBox(
  //                           height: 5,
  //                         ),
  //                         Row(
  //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                           children: [
  //                             Text(
  //                               'เขตติดตาม : ${list_quarantee[i]['followName']}',
  //                               style: MyContant().h4normalStyle(),
  //                             ),
  //                             Text(
  //                               'สถานะสัญญา : ${list_quarantee[i]['signStatusName']}',
  //                               style: MyContant().h4normalStyle(),
  //                             ),
  //                           ],
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ],
  //         ],
  //       ),
  //     ),
  //   );
  // }

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

  // Future<Null> quarantee(sizeIcon, border) async {
  //   double size = MediaQuery.of(context).size.width;
  //   // bool btn_edit = false;
  //   showDialog(
  //     barrierDismissible: false,
  //     context: context,
  //     builder: (context) => GestureDetector(
  //       onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
  //       behavior: HitTestBehavior.opaque,
  //       child: StatefulBuilder(
  //         builder: (context, setState) => Container(
  //           alignment: Alignment.center,
  //           padding: EdgeInsets.all(5),
  //           child: SingleChildScrollView(
  //             padding: EdgeInsets.only(
  //                 bottom: MediaQuery.of(context).viewInsets.bottom),
  //             child: Column(
  //               children: [
  //                 Card(
  //                   shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(15),
  //                   ),
  //                   elevation: 0,
  //                   color: Colors.white,
  //                   child: Container(
  //                     height: size * 1.5,
  //                     margin: EdgeInsets.all(5),
  //                     child: Column(
  //                       children: [
  //                         Stack(
  //                           children: [
  //                             Padding(
  //                               padding: const EdgeInsets.all(8.0),
  //                               child: Container(
  //                                 child: Column(
  //                                   children: [
  //                                     Row(
  //                                       mainAxisAlignment:
  //                                           MainAxisAlignment.center,
  //                                       children: [
  //                                         Text(
  //                                           'รายละเอียดผู้ค้ำ',
  //                                           style:
  //                                               MyContant().TextTitleDialog(),
  //                                         ),
  //                                       ],
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ),
  //                             ),
  //                             Positioned(
  //                               right: 0,
  //                               child: InkWell(
  //                                 onTap: () {
  //                                   Navigator.pop(context);
  //                                 },
  //                                 child: Padding(
  //                                   padding: const EdgeInsets.symmetric(
  //                                       vertical: 4, horizontal: 4),
  //                                   child: Container(
  //                                     width: 30,
  //                                     height: 30,
  //                                     decoration: BoxDecoration(
  //                                         color: Color.fromARGB(
  //                                             255, 182, 182, 182),
  //                                         shape: BoxShape.circle),
  //                                     child: Icon(
  //                                       Icons.close,
  //                                       color: Colors.white,
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                         SizedBox(
  //                           height: 15,
  //                         ),
  //                         Container(
  //                           height: MediaQuery.of(context).size.height * 0.63,
  //                           child: status_error401 == true
  //                               ? Container(
  //                                   child: Column(
  //                                     children: [
  //                                       Row(
  //                                         children: [
  //                                           Text('ไม่มีข้อมูล'),
  //                                         ],
  //                                       ),
  //                                     ],
  //                                   ),
  //                                 )
  //                               : Scrollbar(
  //                                   child: ListView(
  //                                     children: [
  //                                       // if (list_quarantee.isNotEmpty) ...[
  //                                       for (var i = 0;
  //                                           i < list_quarantee.length;
  //                                           i++) ...[
  //                                         InkWell(
  //                                           onTap: () {
  //                                             Navigator.push(
  //                                               context,
  //                                               MaterialPageRoute(
  //                                                 builder: (context) =>
  //                                                     Page_Info_Consider_Cus(
  //                                                         list_quarantee[i]
  //                                                             ['signId']),
  //                                               ),
  //                                             );
  //                                           },
  //                                           child: Padding(
  //                                             padding:
  //                                                 const EdgeInsets.symmetric(
  //                                                     vertical: 4,
  //                                                     horizontal: 4),
  //                                             child: Container(
  //                                               decoration: BoxDecoration(
  //                                                 borderRadius:
  //                                                     BorderRadius.all(
  //                                                   Radius.circular(5),
  //                                                 ),
  //                                                 color: Color.fromRGBO(
  //                                                     251, 173, 55, 1),
  //                                               ),
  //                                               child: Padding(
  //                                                 padding:
  //                                                     const EdgeInsets.all(8.0),
  //                                                 child: Column(
  //                                                   children: [
  //                                                     Row(
  //                                                       children: [
  //                                                         Text(
  //                                                           'เลขที่สัญญา : ${list_quarantee[i]['signId']}',
  //                                                           style: MyContant()
  //                                                               .h4normalStyle(),
  //                                                         ),
  //                                                       ],
  //                                                     ),
  //                                                     SizedBox(
  //                                                       height: 5,
  //                                                     ),
  //                                                     Row(
  //                                                       crossAxisAlignment:
  //                                                           CrossAxisAlignment
  //                                                               .start,
  //                                                       children: [
  //                                                         Text(
  //                                                           'ชื่อ-สกุล : ',
  //                                                           style: MyContant()
  //                                                               .h4normalStyle(),
  //                                                         ),
  //                                                         Expanded(
  //                                                           child: Text(
  //                                                             '${list_quarantee[i]['custName']}',
  //                                                             overflow:
  //                                                                 TextOverflow
  //                                                                     .clip,
  //                                                             style: MyContant()
  //                                                                 .h4normalStyle(),
  //                                                           ),
  //                                                         ),
  //                                                       ],
  //                                                     ),
  //                                                     SizedBox(
  //                                                       height: 5,
  //                                                     ),
  //                                                     Row(
  //                                                       crossAxisAlignment:
  //                                                           CrossAxisAlignment
  //                                                               .start,
  //                                                       children: [
  //                                                         Text(
  //                                                           'ชื่อ-สกุลในสัญญา : ',
  //                                                           style: MyContant()
  //                                                               .h4normalStyle(),
  //                                                         ),
  //                                                         Expanded(
  //                                                           child: Text(
  //                                                             '${list_quarantee[i]['signCustName']}',
  //                                                             overflow:
  //                                                                 TextOverflow
  //                                                                     .clip,
  //                                                             style: MyContant()
  //                                                                 .h4normalStyle(),
  //                                                           ),
  //                                                         ),
  //                                                       ],
  //                                                     ),
  //                                                     SizedBox(
  //                                                       height: 5,
  //                                                     ),
  //                                                     Row(
  //                                                       mainAxisAlignment:
  //                                                           MainAxisAlignment
  //                                                               .spaceBetween,
  //                                                       children: [
  //                                                         Text(
  //                                                           'ยอดคงเหลือ : ${list_quarantee[i]['remainPrice']}',
  //                                                           style: MyContant()
  //                                                               .h4normalStyle(),
  //                                                         ),
  //                                                         Text(
  //                                                           'สถานะ : ${list_quarantee[i]['personStatusName']}',
  //                                                           style: MyContant()
  //                                                               .h4normalStyle(),
  //                                                         ),
  //                                                       ],
  //                                                     ),
  //                                                     SizedBox(
  //                                                       height: 5,
  //                                                     ),
  //                                                     Row(
  //                                                       mainAxisAlignment:
  //                                                           MainAxisAlignment
  //                                                               .spaceBetween,
  //                                                       children: [
  //                                                         Text(
  //                                                           'เขตติดตาม : ${list_quarantee[i]['followName']}',
  //                                                           style: MyContant()
  //                                                               .h4normalStyle(),
  //                                                         ),
  //                                                         Text(
  //                                                           'สถานะสัญญา : ${list_quarantee[i]['signStatusName']}',
  //                                                           style: MyContant()
  //                                                               .h4normalStyle(),
  //                                                         ),
  //                                                       ],
  //                                                     ),
  //                                                   ],
  //                                                 ),
  //                                               ),
  //                                             ),
  //                                           ),
  //                                         ),
  //                                       ],
  //                                       // ],
  //                                     ],
  //                                   ),
  //                                 ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

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
              onChanged: list_detail!['approveStatus'] == '3'
                  ? (String? newvalue) {
                      setState(() {
                        select_approveTypeList = newvalue;
                      });
                      if (select_approveTypeList == '1') {
                        get_approveReasonList();
                      } else if (select_approveTypeList == '2') {
                        get_notApproveReasonList();
                      }
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
            child: DropdownButton<String>(
              items: dropdown_approveReasonList.isEmpty
                  ? []
                  : dropdown_approveReasonList
                      .map((value) => DropdownMenuItem<String>(
                            child: Text(
                              value['name'],
                              style: MyContant().TextInputStyle(),
                            ),
                            value: value['id'].toString(),
                          ))
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

  Expanded select_notReasonList(sizeIcon, border) {
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
              items: dropdown_NotapproveReasonList.isEmpty
                  ? []
                  : dropdown_NotapproveReasonList
                      .map((value) => DropdownMenuItem<String>(
                            child: Text(
                              value['name'],
                              style: MyContant().TextInputStyle(),
                            ),
                            value: value['id'].toString(),
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
          readOnly: list_detail!['approveStatus'] == '3' ? false : true,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
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

  Expanded input_approve_credit(sizeIcon, border) {
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

  Expanded input_NameApprove(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: TextField(
          controller: name_approve,
          onChanged: (keyword) {},
          readOnly: true,
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
