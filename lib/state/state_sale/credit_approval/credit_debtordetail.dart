import 'dart:convert';

import 'package:application_thaweeyont/state/state_sale/credit_approval/page_info_consider_cus.dart';
import 'package:application_thaweeyont/utility/my_constant.dart';
import 'package:application_thaweeyont/widgets/loading_view.dart';
import 'package:application_thaweeyont/widgets/nodata_view.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../api.dart';
import '../../../widgets/custom_appbar.dart';
import '../../authen.dart';

class CreditDebtorDetail extends StatefulWidget {
  final String? custId;
  const CreditDebtorDetail(this.custId, {super.key});

  @override
  State<CreditDebtorDetail> createState() => _CreditDebtorDetailState();
}

class _CreditDebtorDetailState extends State<CreditDebtorDetail> {
  String userId = '', empId = '', firstName = '', lastName = '', tokenId = '';
  bool? allowApproveStatus;
  bool statusLoading = false, statusNotsignDetail = false;
  List listCreditdebtor = [];
  var listDataDebtor;

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
    getDataCreditdebtor();
  }

  Future<void> getDataCreditdebtor() async {
    try {
      var response = await http.post(
        Uri.parse('${api}credit/debtorDetail'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
        body: jsonEncode(<String, String>{
          'custId': widget.custId.toString(),
        }),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> dataCreditDebtor =
            Map<String, dynamic>.from(jsonDecode(response.body));

        listDataDebtor = dataCreditDebtor['data'];

        setState(() {
          if (listDataDebtor!['signDetail'].toString() != "") {
            listCreditdebtor = listDataDebtor['signDetail'];
            statusNotsignDetail = false;
          } else {
            statusNotsignDetail = true;
          }
        });
        statusLoading = true;
      } else {
        handleHttpError(response.statusCode);
      }
    } catch (e) {
      print("ไม่มีข้อมูล $e");
      showProgressDialogNotdata(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
  }

  // แยกฟังก์ชัน handle error HTTP
  void handleHttpError(int statusCode) async {
    if (statusCode == 400) {
      showProgressDialog_400(context, 'แจ้งเตือน', 'ไม่พบข้อมูล ($statusCode)');
    } else if (statusCode == 401) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.clear();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Authen()),
        (Route<dynamic> route) => false,
      );
      showProgressDialog_401(
          context, 'แจ้งเตือน', 'กรุณา Login เข้าสู่ระบบใหม่');
    } else if (statusCode == 404) {
      showProgressDialog_404(context, 'แจ้งเตือน', 'ไม่พบข้อมูล ($statusCode)');
    } else if (statusCode == 405) {
      showProgressDialog_405(context, 'แจ้งเตือน', 'ไม่พบข้อมูล ($statusCode)');
    } else if (statusCode == 500) {
      showProgressDialog_500(
          context, 'แจ้งเตือน', 'ข้อมูลผิดพลาด ($statusCode)');
    } else {
      showProgressDialog(context, 'แจ้งเตือน', 'กรุณาติดต่อผู้ดูแลระบบ');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: 'ตรวจสอบหนี้สิน'),
      body: statusLoading == false
          ? LoadingView()
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 8, bottom: 8, left: 8, right: 8),
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
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8),
                            ),
                            color: Colors.white.withAlpha(180),
                          ),
                          child: Row(
                            children: [
                              Text(
                                'ชื่อลูกค้า : ${listDataDebtor!['custName']}',
                                style: MyContant().h4normalStyle(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: statusNotsignDetail == true
                      ? NoDataView()
                      : ListView(
                          shrinkWrap: true,
                          children: [
                            for (var i = 0;
                                i < listCreditdebtor.length;
                                i++) ...[
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 8),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            PageInfoConsiderCus(
                                                listCreditdebtor[i]['signId']),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(10),
                                      ),
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
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 8),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withAlpha(180),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                'เลขที่สัญญา : ${listCreditdebtor[i]['signId']}',
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
                                                'วันที่ทำสัญญา : ${listCreditdebtor[i]['signDate']}',
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
                                                'ชื่อสินค้า : ',
                                                style:
                                                    MyContant().h4normalStyle(),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  '${listCreditdebtor[i]['itemName']}',
                                                  style: MyContant()
                                                      .h4normalStyle(),
                                                  overflow: TextOverflow.clip,
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
                                                'รหัสเขต : ${listCreditdebtor[i]['followAreaName']}',
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
                                                'สถานะ : ${listCreditdebtor[i]['signStatusName']}',
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
                              ),
                            ],
                          ],
                        ),
                ),
              ],
            ),
    );
  }
}
