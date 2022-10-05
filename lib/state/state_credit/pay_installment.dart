import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../utility/my_constant.dart';
import '../authen.dart';

class Pay_installment extends StatefulWidget {
  // const Pay_installment({Key? key}) : super(key: key);
  var signId, list_payDetail;
  List<dynamic> period;
  Pay_installment(this.signId, this.list_payDetail, this.period);

  @override
  State<Pay_installment> createState() => _Pay_installmentState();
}

class _Pay_installmentState extends State<Pay_installment> {
  String userId = '', empId = '', firstName = '', lastName = '', tokenId = '';
  String dropdownValue = '1';
  var payDetail, status = false, debtorStatuscode;

  List<String> datalist = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
    setListdropdown();
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
    showProgressLoading(context);
    getData_payDetail(widget.signId, widget.list_payDetail);
  }

  setListdropdown() {
    List<dynamic> no = widget.period.map((e) => e["periodNo"]).toList();
    print(widget.list_payDetail);
    no.forEach((element) {
      datalist.add(element);
    });
    setState(() {
      datalist = datalist;
      dropdownValue =
          datalist.firstWhere((element) => element == widget.list_payDetail);
    });
    print('#==>> $datalist');
    print('==>>> ${widget.period}');
  }

  Future<void> getData_payDetail(signId, String period) async {
    print(tokenId);
    print(widget.signId);
    // print(data);

    try {
      var respose = await http.post(
        Uri.parse('https://twyapp.com/twyapi/apiV1/debtor/payDetail'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
        body: jsonEncode(<String, String>{
          'signId': signId,
          'periodId': period,
        }),
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> dataPayDetail =
            new Map<String, dynamic>.from(json.decode(respose.body));

        setState(() {
          status = true;
          payDetail = dataPayDetail['data'][0];
        });

        Navigator.pop(context);
        print('#data# $period == >> $payDetail');
        // print(payDetail['payDate']);
        // print(payDetail['payPrice']);
        // print(payDetail['payFine']);
        // print(payDetail['payBy']);
      } else {
        setState(() {
          status = false;
          debtorStatuscode = respose.statusCode;
        });
        Navigator.pop(context);
        print(respose.body);
        print(respose.statusCode);
        print('ไม่พบข้อมูล');
        Map<String, dynamic> check_list =
            new Map<String, dynamic>.from(json.decode(respose.body));
        print(respose.statusCode);
        print(check_list['message']);
        if (check_list['message'] == "Token Unauthorized") {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          preferences.clear();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => Authen(),
            ),
            (Route<dynamic> route) => false,
          );
        }
      }
    } catch (e) {
      Navigator.pop(context);
      print("ไม่มีข้อมูล $e");
    }
  }

  Future<Null> showProgressLoading(BuildContext context) async {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) => WillPopScope(
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade400.withOpacity(0.6),
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            padding: EdgeInsets.all(80),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                Text(
                  'Loading....',
                  style: MyContant().h4normalStyle(),
                ),
              ],
            ),
          ),
        ),
        onWillPop: () async {
          return false;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sizeIcon = BoxConstraints(minWidth: 20, minHeight: 20);
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
        title: Text('ค้นหาข้อมูล'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                color: Color.fromRGBO(255, 218, 249, 1),
              ),
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'งวดที่ : ',
                    style: MyContant().h4normalStyle(),
                  ),
                  input_pay_installment(sizeIcon, border),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: status == false
                  ? Center(
                      child: Container(
                      height: MediaQuery.of(context).size.height * 0.25,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'ไม่พบข้อมูล',
                                style: MyContant().h4normalStyle(),
                              ),
                            ],
                          )
                        ],
                      ),
                    ))
                  : Container(
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 218, 249, 1),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'งวดที่ : ${dropdownValue.toString()}',
                                style: MyContant().h4normalStyle(),
                              ),
                              Text(
                                'วันที่ใบเสร็จ : ${payDetail['payDate']}',
                                style: MyContant().h4normalStyle(),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'เลขที่ใบเสร็จ : ${payDetail['receiptTranId']}',
                                style: MyContant().h4normalStyle(),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'จำนวนเงิน : ${payDetail['payPrice']}',
                                style: MyContant().h4normalStyle(),
                              ),
                              Text(
                                'ค่าปรับ : ${payDetail['payFine']}',
                                style: MyContant().h4normalStyle(),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'ประเภทการรับ : ${payDetail['payBy']}',
                                  style: MyContant().h4normalStyle(),
                                  overflow: TextOverflow.clip,
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
    );
  }

  Expanded input_pay_installment(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: MediaQuery.of(context).size.width * 0.08,
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: Padding(
            padding: const EdgeInsets.only(left: 5),
            child: DropdownButton(
              items: datalist
                  .map((value) => DropdownMenuItem(
                        child: Text(
                          value,
                          style: MyContant().TextInputStyle(),
                        ),
                        value: value,
                      ))
                  .toList(),
              onChanged: (String? newValue) {
                setState(() {
                  dropdownValue = newValue!;
                  showProgressLoading(context);
                  getData_payDetail(widget.signId, dropdownValue);
                });

                print('#1==>${widget.signId} #2==> $dropdownValue');
              },
              value: dropdownValue,
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
}
