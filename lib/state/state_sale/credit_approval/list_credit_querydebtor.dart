import 'dart:convert';

import 'package:application_thaweeyont/state/state_sale/credit_approval/page_info_consider_cus.dart';
import 'package:application_thaweeyont/widgets/loading_view.dart';
import 'package:application_thaweeyont/widgets/nodata_view.dart';
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
    final signStatus = widget.select_signStatus ?? '';
    final branch = widget.select_branchlist ?? '';
    final debtorType = widget.select_debtorType ?? '';

    final tumbol = widget.tumbolId ?? '';
    final amphur = widget.tumbolId != null ? widget.amphur ?? '' : '';
    final province = widget.tumbolId != null ? widget.province ?? '' : '';

    // print('================= Search Debtor2 =================');
    // print('custId2> ${widget.custId}');
    // print('idcard2> ${widget.idcard}');
    // print('firstnameC2> ${widget.firstnameC}');
    // print('lastnameC2> ${widget.lastnameC}');
    // print('signId2> ${widget.signId}');
    // print('telephone2> ${widget.telephone}');
    // print('addressType2> ${widget.selectAddreessType}');
    // print('homeNo2> ${widget.homeNo}');
    // print('moo> ${widget.moo}');
    // print('tumbolId2> $tumbol');
    // print('amphur2> $amphur');
    // print('province2> $province');
    // print('branchId2> $branch');
    // print('itemType2> ${widget.itemTypelist}');
    // print('signStatus2> $signStatus');
    // print('debtorType2> $debtorType');

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
          ? LoadingView()
          : statusLoad404 == true
              ? NoDataView()
              : mainContent(context),
    );
  }

  Column mainContent(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 4, left: 8, right: 8),
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
        const SizedBox(height: 5),
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
                          builder: (context) =>
                              PageInfoConsiderCus(listDataDebtor[i]['signId']),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 8),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          color: const Color.fromRGBO(251, 173, 55, 1),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withValues(alpha: 0.5),
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
                                  style: MyContant().h4normalStyle(),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                Text(
                                  'วันที่ทำสัญญา : ${listDataDebtor[i]['signDate']}',
                                  style: MyContant().h4normalStyle(),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ชื่อลูกค้าในสัญญา : ',
                                  style: MyContant().h4normalStyle(),
                                ),
                                Expanded(
                                  child: Text(
                                    '${listDataDebtor[i]['custSignName']}',
                                    overflow: TextOverflow.clip,
                                    style: MyContant().h4normalStyle(),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ชื่อลูกค้าปัจจุบัน : ',
                                  style: MyContant().h4normalStyle(),
                                ),
                                Expanded(
                                  child: Text(
                                    '${listDataDebtor[i]['custName']}',
                                    overflow: TextOverflow.clip,
                                    style: MyContant().h4normalStyle(),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'สินค้าที่ซื้อ : ',
                                  style: MyContant().h4normalStyle(),
                                ),
                                Expanded(
                                  child: Text(
                                    '${listDataDebtor[i]['itemName']}',
                                    overflow: TextOverflow.clip,
                                    style: MyContant().h4normalStyle(),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'รหัสเขต : ${listDataDebtor[i]['followAreaName']}',
                                  style: MyContant().h4normalStyle(),
                                ),
                                Text(
                                  'สถานะสัญญา : ${listDataDebtor[i]['signStatusName']}',
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
              const SizedBox(height: 10),
            ],
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
