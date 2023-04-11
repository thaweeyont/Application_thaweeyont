import 'dart:convert';

import 'package:application_thaweeyont/api.dart';
import 'package:application_thaweeyont/state/state_credit/data_searchdebtor.dart';
import 'package:application_thaweeyont/utility/my_constant.dart';
import 'package:flutter/material.dart';
import 'package:loading_gifs/loading_gifs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../authen.dart';

class Data_debtor_list extends StatefulWidget {
  // const Data_debtor_list({Key? key}) : super(key: key);
  final String? custId,
      homeNo,
      moo,
      tumbolId,
      amphur,
      province,
      firstname_c,
      lastname_c,
      select_addreessType,
      idcard,
      telephone,
      select_branchlist,
      signId,
      itemTypelist,
      selectValue_amphoe,
      selectValue_province;
  final int? select_debtorType, select_signStatus;
  Data_debtor_list(
      this.custId,
      this.homeNo,
      this.moo,
      this.tumbolId,
      this.amphur,
      this.province,
      this.firstname_c,
      this.lastname_c,
      this.select_addreessType,
      this.select_debtorType,
      this.idcard,
      this.telephone,
      this.select_branchlist,
      this.signId,
      this.select_signStatus,
      this.itemTypelist,
      this.selectValue_amphoe,
      this.selectValue_province);

  @override
  State<Data_debtor_list> createState() => _Data_debtor_listState();
}

class _Data_debtor_listState extends State<Data_debtor_list> {
  String userId = '',
      empId = '',
      firstName = '',
      lastName = '',
      tokenId = '',
      text_province = '',
      text_amphoe = '';

  List list_dataDebtor = [];
  bool statusLoading = false, statusLoad404 = false;

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
    getData_debtorList();
  }

  Future<void> getData_debtorList() async {
    var signStatus, branch, debtorType, tumbol, amphur, province;
    if (widget.select_signStatus == null) {
      signStatus = '';
    } else {
      signStatus = widget.select_signStatus;
    }

    if (widget.select_branchlist == null) {
      branch = '';
    } else {
      branch = widget.select_branchlist;
    }

    if (widget.select_debtorType == null) {
      debtorType = '';
    } else {
      debtorType = widget.select_debtorType;
    }

    if (widget.tumbolId == null) {
      tumbol = '';
      amphur = '';
      province = '';
    } else {
      tumbol = widget.tumbolId;
      amphur = widget.selectValue_amphoe.toString().split("_")[0];
      province = widget.selectValue_province.toString().split("_")[0];
    }

    try {
      var respose = await http.post(
        Uri.parse('${api}debtor/list'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
        body: jsonEncode(<String, String>{
          'custId': widget.custId.toString(),
          'homeNo': widget.homeNo.toString(),
          'moo': widget.moo.toString(),
          'tumbolId': tumbol.toString(),
          'amphurId': amphur.toString(),
          'provId': province.toString(),
          'firstName': widget.firstname_c.toString(),
          'lastName': widget.lastname_c.toString(),
          'addressType': widget.select_addreessType.toString(),
          'debtorType': debtorType.toString(),
          'smartId': widget.idcard.toString(),
          'telephone': widget.telephone.toString(),
          'branchId': branch.toString(),
          'signId': widget.signId.toString(),
          'signStatus': signStatus.toString(),
          'itemType': widget.itemTypelist.toString(),
          'page': '1',
          'limit': '20'
        }),
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> datadebtorList =
            new Map<String, dynamic>.from(json.decode(respose.body));

        setState(() {
          list_dataDebtor = datadebtorList['data'];
        });
        statusLoading = true;

        print('testData->>${list_dataDebtor}');
      } else if (respose.statusCode == 400) {
        print(respose.statusCode);
        showProgressDialog_400(
            context, 'แจ้งเตือน', 'ไม่พบข้อมูล (${respose.statusCode})');
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
        setState(() {
          statusLoad404 = true;
          statusLoading = true;
        });
        print(respose.statusCode);
        // showProgressDialog_404(context, 'แจ้งเตือน', 'ไม่พบข้อมูลที่ค้นหา');
      } else if (respose.statusCode == 405) {
        print(respose.statusCode);
        showProgressDialog_405(
            context, 'แจ้งเตือน', 'ไม่พบข้อมูล (${respose.statusCode})');
      } else if (respose.statusCode == 500) {
        print(respose.statusCode);
        showProgressDialog_500(
            context, 'แจ้งเตือน', 'ข้อมูลผิดพลาด (${respose.statusCode})');
      } else {
        showProgressDialog(context, 'แจ้งเตือน', 'กรุณาติดต่อผู้ดูแลระบบ!');
      }
    } catch (e) {
      Navigator.pop(context);
      print("ไม่มีข้อมูล $e");
      showProgressDialog(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'รายการที่ค้นหา',
          style: MyContant().TitleStyle(),
        ),
      ),
      body: statusLoading == false
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
                    Image.asset(cupertinoActivityIndicator, scale: 4),
                    Text(
                      'กำลังโหลด',
                      style: MyContant().textLoading(),
                    ),
                  ],
                ),
              ),
            )
          : statusLoad404 == true
              ? Center(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    height: MediaQuery.of(context).size.height * 0.15,
                    child: Column(
                      children: [
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'images/Nodata.png',
                                    width: 55,
                                    height: 55,
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'ไม่พบรายการข้อมูล',
                                    style: MyContant().h5NotData(),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Scrollbar(
                    child: ListView(
                      children: [
                        if (list_dataDebtor.isNotEmpty) ...[
                          for (var i = 0; i < list_dataDebtor.length; i++) ...[
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Data_SearchDebtor(
                                          list_dataDebtor[i]['signId'],
                                          list_dataDebtor[i]
                                              ['signStatusName'])),
                                );
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: Container(
                                  padding: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    color: Color.fromRGBO(255, 203, 246, 1),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'สาขาที่ออกขาย : ${list_dataDebtor[i]['branchName']}',
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
                                            'เลขที่สัญญา : ${list_dataDebtor[i]['signId']}',
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
                                            'วันที่ทำสัญญา : ${list_dataDebtor[i]['signDate']}',
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
                                            'เลขบัตรประชาชน : ${list_dataDebtor[i]['smartId']}',
                                            style: MyContant().h4normalStyle(),
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
                                            'ชื่อลูกค้าในสัญญา : ',
                                            style: MyContant().h4normalStyle(),
                                          ),
                                          Expanded(
                                            child: Text(
                                              '${list_dataDebtor[i]['custName']}',
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
                                            'สินค้าที่ซื้อ : ',
                                            style: MyContant().h4normalStyle(),
                                          ),
                                          Expanded(
                                            child: Text(
                                              '${list_dataDebtor[i]['itemName']}',
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
                                            'เงินดาวน์/งวดแรก : ${list_dataDebtor[i]['downPrice']}  บาท',
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
                                            'ส่งเดือนละ : ${list_dataDebtor[i]['periodPrice']}  บาท',
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
                                            'ระยเวลา : ${list_dataDebtor[i]['periodCount']}  งวด',
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
                                            'กำหนดชำระทุกวันที่ : ${list_dataDebtor[i]['periodDay']}  ของเดือน',
                                            style: MyContant().h4normalStyle(),
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
                                            'หมายเหตุ : ',
                                            style: MyContant().h4normalStyle(),
                                          ),
                                          Expanded(
                                            child: Text(
                                              'เกินกำหนดชำระค่างวด 3 วัน มีเบี้ยปรับ+ค่าทวงถาม',
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
                                            'สถานะสัญญา : ${list_dataDebtor[i]['signStatusName']}',
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
                ),
    );
  }
}
