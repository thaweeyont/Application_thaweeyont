import 'dart:convert';

import 'package:application_thaweeyont/state/state_sale/credit_approval/page_info_consider_cus.dart';
import 'package:flutter/material.dart';
import 'package:loading_gifs/loading_gifs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../api.dart';
import '../../../utility/my_constant.dart';
import '../../../widgets/custom_appbar.dart';
import '../../authen.dart';

class ListCreditQueryDebtor extends StatefulWidget {
  final String? custId,
      homeNo,
      moo,
      tumbolId,
      amphur,
      province,
      firstnameC,
      lastnameC,
      selectAddreessType,
      idcard,
      telephone,
      select_branchlist,
      signId,
      itemTypelist,
      address;
  final int? select_debtorType, select_signStatus;
  const ListCreditQueryDebtor(
      this.custId,
      this.homeNo,
      this.moo,
      this.tumbolId,
      this.amphur,
      this.province,
      this.firstnameC,
      this.lastnameC,
      this.selectAddreessType,
      this.select_debtorType,
      this.idcard,
      this.telephone,
      this.select_branchlist,
      this.signId,
      this.select_signStatus,
      this.itemTypelist,
      this.address,
      {super.key});

  @override
  State<ListCreditQueryDebtor> createState() => _ListCreditQueryDebtorState();
}

class _ListCreditQueryDebtorState extends State<ListCreditQueryDebtor> {
  String userId = '',
      empId = '',
      firstName = '',
      lastName = '',
      tokenId = '',
      textProvince = '',
      textAmphoe = '';

  List listDataDebtor = [];
  bool statusLoading = false, statusLoad404 = false;

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
    getDataDebtorList();
  }

  Future<void> getDataDebtorList() async {
    // var signStatus, branch, debtorType, tumbol, amphur, province;
    // if (widget.selectSignStatus == null) {
    //   signStatus = '';
    // } else {
    //   signStatus = widget.selectSignStatus;
    // }

    // if (widget.selectBranchlist == null) {
    //   branch = '';
    // } else {
    //   branch = widget.selectBranchlist;
    // }

    // if (widget.selectDebtorType == null) {
    //   debtorType = '';
    // } else {
    //   debtorType = widget.selectDebtorType;
    // }

    // if (widget.tumbolId == null) {
    //   tumbol = '';
    //   amphur = '';
    //   province = '';
    // } else {
    //   tumbol = widget.tumbolId;
    //   amphur = widget.selectValueAmphoe.toString().split("_")[0];
    //   province = widget.selectValueProvince.toString().split("_")[0];
    // }

    print('================= Search Debtor =================');
    print('custId> ${widget.custId}');
    print('idcard> ${widget.idcard}');
    print('firstnameC> ${widget.firstnameC}');
    print('lastnameC> ${widget.lastnameC}');
    print('signId> ${widget.signId}');
    print('telephone> ${widget.telephone}');
    print('addressType> ${widget.selectAddreessType}');
    print('homeNo> ${widget.homeNo}');
    print('moo> ${widget.moo}');
    print('tumbolId> ${widget.tumbolId}');
    print('amphur> ${widget.amphur}');
    print('province> ${widget.province}');
    print('branchId> ${widget.select_branchlist}');
    print('itemType> ${widget.itemTypelist}');
    print('signStatus> ${widget.select_signStatus}');
    print('debtorType> ${widget.select_debtorType}');

    final signStatus = widget.select_signStatus ?? '';
    final branch = widget.select_branchlist ?? '';
    final debtorType = widget.select_debtorType ?? '';

    final tumbol = widget.tumbolId ?? '';
    final amphur = widget.tumbolId != null ? widget.amphur ?? '' : '';
    final province = widget.tumbolId != null ? widget.province ?? '' : '';

    print('================= Search Debtor2 =================');
    print('custId2> ${widget.custId}');
    print('idcard2> ${widget.idcard}');
    print('firstnameC2> ${widget.firstnameC}');
    print('lastnameC2> ${widget.lastnameC}');
    print('signId2> ${widget.signId}');
    print('telephone2> ${widget.telephone}');
    print('addressType2> ${widget.selectAddreessType}');
    print('homeNo2> ${widget.homeNo}');
    print('moo> ${widget.moo}');
    print('tumbolId2> $tumbol');
    print('amphur2> $amphur');
    print('province2> $province');
    print('branchId2> $branch');
    print('itemType2> ${widget.itemTypelist}');
    print('signStatus2> $signStatus');
    print('debtorType2> $debtorType');

    try {
      var respose = await http.post(
        Uri.parse('${api}debtor/list'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
        body: jsonEncode(<String, String>{
          'custId': widget.custId ?? '',
          'homeNo': widget.homeNo ?? '',
          'moo': widget.moo ?? '',
          'tumbolId': tumbol,
          'amphurId': amphur,
          'provId': province,
          'firstName': widget.firstnameC ?? '',
          'lastName': widget.lastnameC ?? '',
          'addressType': widget.selectAddreessType ?? '',
          'debtorType': debtorType.toString(),
          'smartId': widget.idcard ?? '',
          'telephone': widget.telephone ?? '',
          'branchId': branch,
          'signId': widget.signId ?? '',
          'signStatus': signStatus.toString(),
          'itemType': widget.itemTypelist ?? '',
          'page': '1',
          'limit': '20',
        }),
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> datadebtorList =
            Map<String, dynamic>.from(json.decode(respose.body));

        setState(() {
          listDataDebtor = datadebtorList['data'];
        });
        statusLoading = true;
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
        setState(() {
          statusLoad404 = true;
          statusLoading = true;
        });
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
      Navigator.pop(context);
      print("ไม่มีข้อมูล $e");
      showProgressDialog(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: 'รายการค้นหา'),
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
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 8, bottom: 4, left: 8, right: 8),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                          color: const Color.fromRGBO(251, 173, 55, 1),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withAlpha(130),
                              spreadRadius: 0.2,
                              blurRadius: 2,
                              offset: const Offset(0, 1),
                            )
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white.withAlpha(180),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'ที่อยู่ : ',
                                    style: MyContant().h4normalStyle(),
                                  ),
                                  Expanded(
                                    child: Text(
                                      '${widget.address}',
                                      style: MyContant().h4normalStyle(),
                                      overflow: TextOverflow.clip,
                                    ),
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
                    Expanded(
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          if (listDataDebtor.isNotEmpty) ...[
                            for (var i = 0; i < listDataDebtor.length; i++) ...[
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PageInfoConsiderCus(
                                          listDataDebtor[i]['signId']),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 8),
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      color:
                                          const Color.fromRGBO(251, 173, 55, 1),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey
                                              .withValues(alpha: 0.5),
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
                                              'เลขที่สัญญา : ${listDataDebtor[i]['signId']}',
                                              style:
                                                  MyContant().h4normalStyle(),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'วันที่ทำสัญญา : ${listDataDebtor[i]['signDate']}',
                                              style:
                                                  MyContant().h4normalStyle(),
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
                                              style:
                                                  MyContant().h4normalStyle(),
                                            ),
                                            Expanded(
                                              child: Text(
                                                '${listDataDebtor[i]['custSignName']}',
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
                                              'ชื่อลูกค้าปัจจุบัน : ',
                                              style:
                                                  MyContant().h4normalStyle(),
                                            ),
                                            Expanded(
                                              child: Text(
                                                '${listDataDebtor[i]['custName']}',
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
                                              style:
                                                  MyContant().h4normalStyle(),
                                            ),
                                            Expanded(
                                              child: Text(
                                                '${listDataDebtor[i]['itemName']}',
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'รหัสเขต : ${listDataDebtor[i]['followAreaName']}',
                                              style:
                                                  MyContant().h4normalStyle(),
                                            ),
                                            Text(
                                              'สถานะสัญญา : ${listDataDebtor[i]['signStatusName']}',
                                              style:
                                                  MyContant().h4normalStyle(),
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
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
    );
  }
}
