import 'dart:convert';

import 'package:application_thaweeyont/utility/my_constant.dart';
import 'package:application_thaweeyont/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:loading_gifs/loading_gifs.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../api.dart';
import 'package:http/http.dart' as http;

import '../../../widgets/endpage.dart';
import '../../../widgets/loaddata.dart';
import '../../authen.dart';
import 'detail_member_cust.dart';

class MemberCustList extends StatefulWidget {
  final String? custId, smartId, custName, lastnamecust;
  const MemberCustList(
      this.custId, this.smartId, this.custName, this.lastnamecust,
      {super.key});

  @override
  State<MemberCustList> createState() => _MemberCustListState();
}

class _MemberCustListState extends State<MemberCustList> {
  String userId = '', empId = '', firstName = '', lastName = '', tokenId = '';
  List list_dataMember = [];
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
        getDataCusMember(offset);
      });
    }
    myScroll(scrollControll, offset);
  }

  void myScroll(ScrollController scrollController, int offset) {
    scrollController.addListener(() async {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        setState(() {
          isLoad = true;
        });
        await Future.delayed(const Duration(seconds: 1), () {
          offset = offset + 10;
          getDataCusMember(offset);
        });
      }
    });
  }

  Future<void> getDataCusMember(offset) async {
    try {
      var respose = await http.post(
        Uri.parse('${api}customer/memberList'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
        body: jsonEncode(<String, String>{
          'custId': widget.custId.toString(),
          'smartId': widget.smartId.toString(),
          'firstName': widget.custName.toString(),
          'lastName': widget.lastnamecust.toString(),
          'page': '1',
          'limit': '$offset',
        }),
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> dataMemberList =
            Map<String, dynamic>.from(json.decode(respose.body));

        setState(() {
          list_dataMember = dataMemberList['data'];
        });
        statusLoading = true;
        isLoad = false;
        if (stquery > 0) {
          if (offset > list_dataMember.length) {
            isLoadendPage = true;
          }
          stquery = 1;
        } else {
          stquery = 1;
        }
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
        showProgressDialog(context, 'แจ้งเตือน', 'กรุณาติดต่อผู้ดูแลระบบ');
      }
    } catch (e) {
      print("ไม่มีข้อมูล $e");
      showProgressDialogNotdata(
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
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    child: Column(
                      children: [
                        for (var member in list_dataMember)
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      Detail_member_cust(member['custId']),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withAlpha(130),
                                      spreadRadius: 0.5,
                                      blurRadius: 2,
                                      offset: const Offset(0, 1),
                                    )
                                  ],
                                  color: const Color.fromRGBO(64, 203, 203, 1),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('สาขา : ${member['branchName']}',
                                        style: MyContant().h4normalStyle()),
                                    Text('รหัสลูกค้า : ${member['custId']}',
                                        style: MyContant().h4normalStyle()),
                                    buildLabelValue(
                                        'ชื่อ-นามสกุล', member['custName']),
                                    Text('เลขที่บัตร : ${member['smartId']}',
                                        style: MyContant().h4normalStyle()),
                                    buildLabelValue(
                                        'เบอร์โทรศัพท์', member['telephone']),
                                    Text('ที่มา : ${member['sourceName']}',
                                        style: MyContant().h4normalStyle()),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        if (isLoad && !isLoadendPage) const LoadData(),
                        if (isLoadendPage) const EndPage(),
                        const SizedBox(height: 35),
                      ],
                    ),
                  ),
                ),
    );
  }

  /// ด้านล่างนี้คือฟังก์ชันย่อยสั้นๆ (อยู่ในหน้าเดียวกัน)
  Widget buildLabelValue(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label : ', style: MyContant().h4normalStyle()),
        Expanded(
          child: Text(value,
              style: MyContant().h4normalStyle(), overflow: TextOverflow.clip),
        ),
      ],
    );
  }
}
