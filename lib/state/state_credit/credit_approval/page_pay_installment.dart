import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:application_thaweeyont/api.dart';

import '../../../utility/my_constant.dart';
import '../../authen.dart';

class Page_Pay_Installment extends StatefulWidget {
  // const Page_Pay_Installment({super.key});
  var signId, list_payDetail;
  List<dynamic> period;
  Page_Pay_Installment(this.signId, this.list_payDetail, this.period);

  @override
  State<Page_Pay_Installment> createState() => _Page_Pay_InstallmentState();
}

class _Page_Pay_InstallmentState extends State<Page_Pay_Installment> {
  String userId = '', empId = '', firstName = '', lastName = '', tokenId = '';
  String dropdownValue = '1';
  var payDetail, status = false, debtorStatuscode;
  // late String? periodNo = widget.list_payDetail.toString();
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
    // print(widget.signId.toString());
    // print(list);
    try {
      var respose = await http.post(
        Uri.parse('${api}debtor/payDetail'),
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
        print(payDetail);
      } else {
        setState(() {
          status = false;
          debtorStatuscode = respose.statusCode;
        });
        print('#=> $debtorStatuscode');
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
        title: Text(
          'ค้นหาข้อมูล',
          style: MyContant().TitleStyle(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                color: Color.fromRGBO(251, 173, 55, 1),
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
                      child: debtorStatuscode == 404
                          ? notData(context)
                          : Container(),
                    )
                  : Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(251, 173, 55, 1),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'งวดที่ : ${dropdownValue}',
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
