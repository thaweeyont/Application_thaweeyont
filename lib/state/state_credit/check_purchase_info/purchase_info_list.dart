import 'dart:convert';

import 'package:application_thaweeyont/state/authen.dart';
import 'package:application_thaweeyont/utility/my_constant.dart';
import 'package:flutter/material.dart';
import 'package:loading_gifs/loading_gifs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../api.dart';
import 'package:intl/intl.dart';

import '../../../widgets/endpage.dart';
import '../../../widgets/loaddata.dart';

class Purchase_info_list extends StatefulWidget {
  final String? custId,
      smartId,
      custName,
      lastname_cust,
      newStartDate,
      newEndDate;
  final int? select_index_saletype;
  Purchase_info_list(this.custId, this.select_index_saletype, this.smartId,
      this.custName, this.lastname_cust, this.newStartDate, this.newEndDate);

  @override
  State<Purchase_info_list> createState() => _Purchase_info_listState();
}

class _Purchase_info_listState extends State<Purchase_info_list> {
  String userId = '', empId = '', firstName = '', lastName = '', tokenId = '';
  List list_dataBuyTyle = [];
  bool statusLoading = false,
      statusLoad404 = false,
      isLoad = false,
      isLoadendPage = false;
  List<dynamic> listbilltotal = [], errorList = [];
  var res = 0.0, number, lengthbill;
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
        getDataBuyList(offset);
      });
    }
    myScroll(scrollControll, offset);
  }

  void myScroll(scrollControll, offset) {
    scrollControll.addListener(() async {
      // double currentScroll = scrollControll.position.pixels;
      if (scrollControll.position.pixels ==
          scrollControll.position.maxScrollExtent) {
        setState(() {
          isLoad = true;
        });
        await Future.delayed(const Duration(seconds: 1), () {
          offset = offset + 20;
          getDataBuyList(offset);
        });
      }
    });
  }

  Future<void> getDataBuyList(offset) async {
    try {
      var respose = await http.post(
        Uri.parse('${api}sale/custBuyList'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
        body: jsonEncode(<String, String>{
          'custId': widget.custId.toString(),
          'saleTypeId': widget.select_index_saletype.toString(),
          'smartId': widget.smartId.toString(),
          'firstName': widget.custName.toString(),
          'lastName': widget.lastname_cust.toString(),
          'startDate': widget.newStartDate.toString(),
          'endDate': widget.newEndDate.toString(),
          'page': '1',
          'limit': '$offset'
        }),
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> dataBuylist =
            Map<String, dynamic>.from(json.decode(respose.body));

        setState(() {
          list_dataBuyTyle = dataBuylist['data'];
          setbillTotal();
        });
        statusLoading = true;
        isLoad = false;
        if (stquery > 0) {
          if (offset > list_dataBuyTyle.length) {
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
        showProgressDialog(context, 'แจ้งเตือน', 'กรุณาติดต่อผู้ดูแลระบบ!');
      }
    } catch (e) {
      print("ไม่มีข้อมูล >> $e");
      showProgressDialog(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
  }

  void setbillTotal() {
    List billtotal = list_dataBuyTyle.map((e) => e['billTotal']).toList();
    listbilltotal.clear();
    for (var element in billtotal) {
      listbilltotal.add(element);
    }
    res = 0.0;
    for (var element in listbilltotal) {
      print(element.runtimeType);
    }
    for (var c = 0; c < listbilltotal.length; c++) {
      res += double.parse(listbilltotal[c].toString().replaceAll(',', ''));
    }
    var f = NumberFormat('###,###.00', 'en_US');
    number = f.format(res);
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
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 8, bottom: 8, left: 8, right: 8),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(5),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 0.5,
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        )
                      ],
                      color: const Color.fromRGBO(229, 188, 244, 1),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(5),
                            ),
                            color: Colors.white.withOpacity(0.7),
                          ),
                          child: statusLoad404 == true
                              ? Row(
                                  children: [
                                    Text(
                                      'ยอดเงินทั้งหมด : 0 บาท \nจำนวน 0 รายการ',
                                      style: MyContant().h4normalStyle(),
                                    )
                                  ],
                                )
                              : Row(
                                  children: [
                                    Text(
                                      'ยอดเงินทั้งหมด : $number บาท \nจำนวน : ${list_dataBuyTyle.length} รายการ',
                                      style: MyContant().h4normalStyle(),
                                    )
                                  ],
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: statusLoad404 == true
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'images/Nodata.png',
                                          width: 55,
                                          height: 55,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                      : SingleChildScrollView(
                          controller: scrollControll,
                          physics: const BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics(),
                          ),
                          child: Column(
                            // shrinkWrap: true,
                            children: [
                              for (var i = 0;
                                  i < list_dataBuyTyle.length;
                                  i++) ...[
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 8),
                                  child: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(5),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 0.5,
                                          blurRadius: 2,
                                          offset: const Offset(0, 1),
                                        )
                                      ],
                                      color: const Color.fromRGBO(
                                          229, 188, 244, 1),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'ลำดับ : ${i + 1}',
                                              style:
                                                  MyContant().h4normalStyle(),
                                            ),
                                            Text(
                                              'วันที่ขาย : ${list_dataBuyTyle[i]['saleDate']}',
                                              style:
                                                  MyContant().h4normalStyle(),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color:
                                                Colors.white.withOpacity(0.7),
                                          ),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    'เลขที่เอกสาร : ${list_dataBuyTyle[i]['saleTranId']}',
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
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'ชื่อลูกค้า : ',
                                                    style: MyContant()
                                                        .h4normalStyle(),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      '${list_dataBuyTyle[i]['custName']}',
                                                      overflow:
                                                          TextOverflow.clip,
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
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'รายการสินค้า : ',
                                                    style: MyContant()
                                                        .h4normalStyle(),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      '${list_dataBuyTyle[i]['itemName']}',
                                                      overflow:
                                                          TextOverflow.clip,
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
                                                    'ราคา : ${list_dataBuyTyle[i]['billTotal']}',
                                                    style: MyContant()
                                                        .h4normalStyle(),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    'ประเภทการขาย : ${list_dataBuyTyle[i]['saleTypeName']}',
                                                    style: MyContant()
                                                        .h4normalStyle(),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    'พนักงานขาย : ${list_dataBuyTyle[i]['saleName']}',
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
                              if (isLoad == true && isLoadendPage == false) ...[
                                const LoadData(),
                              ] else if (isLoadendPage == true) ...[
                                const EndPage(),
                              ],
                              const SizedBox(
                                height: 35,
                              ),
                            ],
                          ),
                        ),
                ),
              ],
            ),
    );
  }
}
