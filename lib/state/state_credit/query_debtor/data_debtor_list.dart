import 'dart:convert';

import 'package:application_thaweeyont/api.dart';
import 'package:application_thaweeyont/state/authen.dart';
import 'package:application_thaweeyont/state/state_credit/query_debtor/data_searchdebtor.dart';
import 'package:application_thaweeyont/utility/my_constant.dart';
import 'package:flutter/material.dart';
import 'package:loading_gifs/loading_gifs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../widgets/custom_appbar.dart';
import '../../../widgets/endpage.dart';
import '../../../widgets/loaddata.dart';

class DataDebtorList extends StatefulWidget {
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
      signRunning,
      itemTypelist;
  final int? select_debtorType, select_signStatus;
  const DataDebtorList(
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
      this.signRunning,
      this.select_signStatus,
      this.itemTypelist,
      {super.key});

  @override
  State<DataDebtorList> createState() => _DataDebtorListState();
}

class _DataDebtorListState extends State<DataDebtorList> {
  String userId = '',
      empId = '',
      firstName = '',
      lastName = '',
      tokenId = '',
      text_province = '',
      text_amphoe = '';

  List list_dataDebtor = [];
  bool statusLoading = false,
      statusLoad404 = false,
      isLoad = false,
      isLoadendPage = false;
  final scrollControll = TrackingScrollController();
  int offset = 30, stquery = 0;

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
    if (mounted) {
      setState(() {
        getDataDebtorList(offset);
      });
    }
    myScroll(scrollControll, offset);
  }

  void myScroll(ScrollController scrollControll, int offset) {
    scrollControll.addListener(() async {
      if (scrollControll.position.pixels ==
          scrollControll.position.maxScrollExtent) {
        setState(() {
          isLoad = true;
        });
        await Future.delayed(const Duration(seconds: 1), () {
          offset = offset + 10;
          getDataDebtorList(offset);
        });
      }
    });
  }

  Future<void> getDataDebtorList(offset) async {
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
      amphur = widget.amphur;
      province = widget.province;
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
          'signRunning': widget.signRunning.toString(),
          'signId': widget.signId.toString(),
          'signStatus': signStatus.toString(),
          'itemType': widget.itemTypelist.toString(),
          'page': '1',
          'limit': '$offset'
        }),
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> datadebtorList =
            Map<String, dynamic>.from(json.decode(respose.body));

        setState(() {
          list_dataDebtor = datadebtorList['data'];
        });
        statusLoading = true;
        isLoad = false;
        if (stquery > 0) {
          if (offset > list_dataDebtor.length) {
            isLoadendPage = true;
          }
          stquery = 1;
        } else {
          stquery = 1;
        }
      } else if (respose.statusCode == 400) {
        if (mounted) return;
        showProgressDialog_400(
            context, 'แจ้งเตือน', 'ไม่พบข้อมูล (${respose.statusCode})');
      } else if (respose.statusCode == 401) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.clear();
        if (mounted) return;
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
        setState(() {
          statusLoad404 = true;
          statusLoading = true;
        });
      } else if (respose.statusCode == 405) {
        if (mounted) return;
        showProgressDialog_405(
            context, 'แจ้งเตือน', 'ไม่พบข้อมูล (${respose.statusCode})');
      } else if (respose.statusCode == 500) {
        if (mounted) return;
        showProgressDialog_500(
            context, 'แจ้งเตือน', 'ข้อมูลผิดพลาด (${respose.statusCode})');
      } else {
        if (mounted) return;
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
      appBar: const CustomAppbar(title: 'รายการที่ค้นหา'),
      body: statusLoading == false
          ? Center(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 24, 24, 24).withAlpha(230),
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
          : statusLoad404 == true
              ? Center(
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    height: MediaQuery.of(context).size.height * 0.15,
                    child: Column(
                      children: [
                        Column(
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
                      ],
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    controller: scrollControll,
                    physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    child: Column(
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
                                      list_dataDebtor[i]['signStatusName'],
                                    ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withAlpha(130),
                                        spreadRadius: 0.5,
                                        blurRadius: 2,
                                        offset: const Offset(0, 1),
                                      )
                                    ],
                                    color:
                                        const Color.fromRGBO(255, 203, 246, 1),
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
                                      const SizedBox(
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
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'รันนิ่งสัญญา : ${list_dataDebtor[i]['signRunning']}',
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
                                            'วันที่ทำสัญญา : ${list_dataDebtor[i]['signDate']}',
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
                                            'เลขบัตรประชาชน : ${list_dataDebtor[i]['smartId']}',
                                            style: MyContant().h4normalStyle(),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
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
                                      const SizedBox(
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
                                      const SizedBox(
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
                                      const SizedBox(
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
                                      const SizedBox(
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
                                      const SizedBox(
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
                                      const SizedBox(
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
                                      const SizedBox(
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
                          if (isLoad == true && isLoadendPage == false) ...[
                            const LoadData(),
                          ] else if (isLoadendPage == true) ...[
                            const EndPage(),
                          ],
                          const SizedBox(
                            height: 35,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
    );
  }
}
