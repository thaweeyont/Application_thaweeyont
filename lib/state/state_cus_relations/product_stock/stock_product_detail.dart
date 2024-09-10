import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:loading_gifs/loading_gifs.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../api.dart';
import '../../../utility/my_constant.dart';
import 'package:http/http.dart' as http;

import '../../../widgets/custom_appbar.dart';
import '../../authen.dart';

class StockProductDetail extends StatefulWidget {
  final String? branchId,
      branchName,
      whId,
      whName,
      itemId,
      itemName,
      itemTypeName,
      brandName;
  const StockProductDetail(
      this.branchId,
      this.branchName,
      this.whId,
      this.whName,
      this.itemId,
      this.itemName,
      this.itemTypeName,
      this.brandName,
      {Key? key})
      : super(key: key);

  @override
  State<StockProductDetail> createState() => _StockProductDetailState();
}

class _StockProductDetailState extends State<StockProductDetail> {
  String userId = '',
      empId = '',
      firstName = '',
      lastName = '',
      tokenId = '',
      branchId = '',
      branchName = '';
  bool? allowApproveStatus;
  bool statusLoading = false, statusLoad404 = false;
  List dropdownSerialStatus = [],
      dataWarehouseStatus = [],
      dataStockDetail = [];
  var selectValueSerial, NitemTypeName, NbrandName;

  @override
  void initState() {
    super.initState();
    getdata();

    NitemTypeName = widget.itemTypeName;
    NbrandName = widget.brandName;
    if (NitemTypeName == null && NbrandName == null) {
      NitemTypeName = '';
      NbrandName = '';
    }
  }

  Future<void> getdata() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      userId = preferences.getString('userId')!;
      empId = preferences.getString('empId')!;
      firstName = preferences.getString('firstName')!;
      lastName = preferences.getString('lastName')!;
      tokenId = preferences.getString('tokenId')!;
      branchId = preferences.getString('branchId')!;
      branchName = preferences.getString('branchName')!;
      allowApproveStatus = preferences.getBool('allowApproveStatus');
    });
    getWarehouseStatus();
  }

  Future<void> getWarehouseStatus() async {
    try {
      var respose = await http.get(
        Uri.parse('${api}setup/warehouseStatus'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> warehouseStatus =
            Map<String, dynamic>.from(json.decode(respose.body));

        setState(() {
          dropdownSerialStatus = warehouseStatus['data'];
        });
        getDataStockDetail('get');
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
          statusLoading = true;
          statusLoad404 = true;
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
      showProgressDialog(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
  }

  Future<void> getDataStockDetail(data) async {
    dataStockDetail = [];
    if (data == 'get') {
      selectValueSerial = dropdownSerialStatus[0]['id'];
    }

    try {
      var respose = await http.post(
        Uri.parse('${api}stock/detail'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
        body: jsonEncode(<String, String>{
          'branchId': '${widget.branchId}',
          'whId': '${widget.whId}',
          'itemId': '${widget.itemId}',
          'serialStatus': '$selectValueSerial',
          'page': '1',
          'limit': '100',
        }),
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> stockdetail =
            Map<String, dynamic>.from(json.decode(respose.body));

        setState(() {
          dataStockDetail = stockdetail['data'];
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
          statusLoading = true;
          statusLoad404 = true;
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
      showProgressDialog(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
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
      appBar: const CustomAppbar(title: 'รายการที่ค้นหา'),
      body: GestureDetector(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(5),
                  ),
                  color: const Color.fromRGBO(176, 218, 255, 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 0.2,
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${widget.branchName}',
                          style: MyContant().h4normalStyle(),
                        ),
                        Text(
                          'คลัง ${widget.whName}',
                          style: MyContant().h4normalStyle(),
                        )
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '$NitemTypeName $NbrandName ${widget.itemName}',
                            overflow: TextOverflow.clip,
                            style: MyContant().h4normalStyle(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const SizedBox(width: 30),
                        selectSerialStatus(sizeIcon, border),
                        const SizedBox(width: 30),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: statusLoading == false
                  ? Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 24, 24, 24)
                              .withOpacity(0.9),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 30),
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
                      : ListView(
                          shrinkWrap: true,
                          children: [
                            if (dataStockDetail.isNotEmpty) ...[
                              for (var i = 0;
                                  i < dataStockDetail.length;
                                  i++) ...[
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 8),
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(5),
                                      ),
                                      color: const Color.fromRGBO(
                                          176, 218, 255, 1),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 0.2,
                                          blurRadius: 2,
                                          offset: const Offset(0, 1),
                                        ),
                                      ],
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
                                              'วันที่รับของ : ${dataStockDetail[i]['receiveDate']}',
                                              style:
                                                  MyContant().h4normalStyle(),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 5),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'หมายเลขเครื่อง : ',
                                              style:
                                                  MyContant().h4normalStyle(),
                                            ),
                                            Expanded(
                                              child: Text(
                                                '${dataStockDetail[i]['serial']}',
                                                overflow: TextOverflow.clip,
                                                style:
                                                    MyContant().h4normalStyle(),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 5),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'สถานะ : ',
                                              style:
                                                  MyContant().h4normalStyle(),
                                            ),
                                            Expanded(
                                              child: Text(
                                                '${dataStockDetail[i]['status']}',
                                                overflow: TextOverflow.clip,
                                                style:
                                                    MyContant().h4normalStyle(),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ],
                            const SizedBox(height: 20),
                          ],
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Expanded selectSerialStatus(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: MediaQuery.of(context).size.width * 0.09,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 4),
            child: DropdownButton(
              items: dropdownSerialStatus
                  .map(
                    (value) => DropdownMenuItem(
                      alignment: AlignmentDirectional.center,
                      value: value['id'],
                      child: Text(
                        value['name'],
                        style: MyContant().textInputStyle(),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (newvalue) async {
                setState(() {
                  selectValueSerial = newvalue;
                });
                statusLoading = false;
                statusLoad404 = false;
                getDataStockDetail('post');
              },
              value: selectValueSerial,
              isExpanded: true,
              underline: const SizedBox(),
            ),
          ),
        ),
      ),
    );
  }
}
