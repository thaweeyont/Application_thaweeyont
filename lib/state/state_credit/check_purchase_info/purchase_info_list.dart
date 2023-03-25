import 'dart:convert';

import 'package:application_thaweeyont/state/authen.dart';
import 'package:application_thaweeyont/utility/my_constant.dart';
import 'package:flutter/material.dart';
import 'package:loading_gifs/loading_gifs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../api.dart';

class Purchase_info_list extends StatefulWidget {
  // const Purchase_info_list({Key? key}) : super(key: key);
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
  var status_loading = false;

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
    getData_buyList();
  }

  Future<void> getData_buyList() async {
    try {
      var respose = await http.post(
        Uri.parse('${beta_api_test}sale/custBuyList'),
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
          'limit': '250'
        }),
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> dataBuylist =
            new Map<String, dynamic>.from(json.decode(respose.body));

        setState(() {
          list_dataBuyTyle = dataBuylist['data'];
        });
        status_loading = true;

        print('555 >> ${list_dataBuyTyle}');
      } else if (respose.statusCode == 400) {
        showProgressDialog_400(
            context, 'แจ้งเตือน', 'ไม่พบข้อมูล (${respose.statusCode})');
      } else if (respose.statusCode == 401) {
        print('customer >>${respose.statusCode}');
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
        showProgressDialog_404(context, 'แจ้งเตือน', 'ไม่พบข้อมูลที่ค้นหา');
      } else if (respose.statusCode == 405) {
        print(respose.statusCode);
        showProgressDialog_405(
            context, 'แจ้งเตือน', 'ไม่พบข้อมูล (${respose.statusCode})');
      } else if (respose.statusCode == 500) {
        print(respose.statusCode);
        showProgressDialog_500(
            context, 'แจ้งเตือน', 'ข้อมูลผิดพลาด (${respose.statusCode})');
      } else {
        print(respose.statusCode);
        showProgressDialog(context, 'แจ้งเตือน', 'กรุณาติดต่อผู้ดูแลระบบ!');
      }
    } catch (e) {
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
      body: status_loading == false
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
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.85,
                child: Scrollbar(
                  child: ListView(
                    children: [
                      for (var i = 0; i < list_dataBuyTyle.length; i++) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Container(
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              color: Color.fromRGBO(229, 188, 244, 1),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'ลำดับ : ${i + 1}',
                                      style: MyContant().h4normalStyle(),
                                    ),
                                    Text(
                                      'วันที่ขาย : ${list_dataBuyTyle[i]['saleDate']}',
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
                                      'เลขที่เอกสาร : ${list_dataBuyTyle[i]['saleTranId']}',
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
                                      'ชื่อลูกค้า : ',
                                      style: MyContant().h4normalStyle(),
                                    ),
                                    Expanded(
                                      child: Text(
                                        '${list_dataBuyTyle[i]['custName']}',
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
                                      'รายการสินค้า : ',
                                      style: MyContant().h4normalStyle(),
                                    ),
                                    Expanded(
                                      child: Text(
                                        '${list_dataBuyTyle[i]['itemName']}',
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'ราคา : ${list_dataBuyTyle[i]['billTotal']}',
                                      style: MyContant().h4normalStyle(),
                                    ),
                                    Text(
                                      'ประเภทการขาย : ${list_dataBuyTyle[i]['saleTypeName']}',
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
                                      'พนักงานขาย : ${list_dataBuyTyle[i]['saleName']}',
                                      style: MyContant().h4normalStyle(),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
