import 'dart:convert';

import 'package:application_thaweeyont/state/state_mechanical/mechanicaldetail.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_gifs/loading_gifs.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api.dart';
import '../../utility/my_constant.dart';
import '../authen.dart';
import 'package:http/http.dart' as http;

import 'mechanicallist.dart';

class Mechanical extends StatefulWidget {
  const Mechanical({super.key});

  @override
  State<Mechanical> createState() => _MechanicalState();
}

class _MechanicalState extends State<Mechanical> {
  String userId = '', empId = '', firstName = '', lastName = '', tokenId = '';
  bool actionButton = false, statusNotdata = false, statusLoading = false;
  List workReqList = [];
  var listdata, datenow, newDate;
  DateTime selectedDate = DateTime.now();

  TextEditingController date = TextEditingController();
  TextEditingController saleTranId = TextEditingController();
  TextEditingController workReqTranId = TextEditingController();

  @override
  void initState() {
    super.initState();
    getdata();
    actionButton = true;
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
    selectDatenow();
    workRequestList();
  }

  void selectDatenow() {
    var formattedDate = DateFormat('-MM-dd').format(selectedDate);
    var formattedYear = DateFormat('yyyy').format(selectedDate);

    var yearnow = int.parse(formattedYear);
    final year = [yearnow, 543].reduce((value, element) => value + element);
    datenow = '$year$formattedDate';
    newDate = datenow.toString().replaceAll('-', '');
  }

  void clearInput() {
    date.clear();
    saleTranId.clear();
    workReqTranId.clear();
  }

  Future<void> workRequestList() async {
    try {
      var respose = await http.post(
        Uri.parse('${api}sev/workRequestList'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
        body: jsonEncode(
          <String, String>{
            'saleTranId': workReqTranId.text,
            'workReqTranId': saleTranId.text,
            'requestDate': newDate.toString(),
            'page': '1',
            'limit': '100'
          },
        ),
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> dataworklist =
            Map<String, dynamic>.from(json.decode(respose.body));

        listdata = dataworklist['data'];
        setState(() {
          workReqList = listdata;
          statusLoading = true;
        });
        // print('data>11>$workReqList');
      } else if (respose.statusCode == 400) {
        showProgressDialog_400(context, 'แจ้งเตือน', 'ละติจูด ลองติจูด ซ้ำ');
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
          statusNotdata = true;
          statusLoading = true;
        });
        // showProgressDialog_404(context, 'แจ้งเตือน', 'เกืดข้อผิดพลาด');
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
      showProgressDialog_Notdata(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        behavior: HitTestBehavior.opaque,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            actionButton = true;
                          });
                        },
                        style: ButtonStyle(
                          backgroundColor: actionButton == true
                              ? MaterialStateProperty.all(
                                  const Color.fromARGB(255, 196, 154, 4),
                                )
                              : MaterialStateProperty.all(
                                  const Color.fromARGB(255, 241, 209, 89),
                                ),
                          shape: MaterialStateProperty.all(
                            const RoundedRectangleBorder(
                              borderRadius: BorderRadiusDirectional.only(
                                topStart: Radius.circular(20),
                                bottomStart: Radius.circular(20),
                              ),
                            ),
                          ),
                        ),
                        child: Text(
                          "งานของฉัน",
                          style: MyContant().h1MenuStyle(),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            actionButton = false;
                          });
                        },
                        style: ButtonStyle(
                          backgroundColor: actionButton == false
                              ? MaterialStateProperty.all(
                                  const Color.fromARGB(255, 196, 154, 4),
                                )
                              : MaterialStateProperty.all(
                                  const Color.fromARGB(255, 241, 209, 89),
                                ),
                          shape: MaterialStateProperty.all(
                            const RoundedRectangleBorder(
                              borderRadius: BorderRadiusDirectional.only(
                                topEnd: Radius.circular(20),
                                bottomEnd: Radius.circular(20),
                              ),
                            ),
                          ),
                        ),
                        child: Text(
                          'ค้นหางาน',
                          style: MyContant().h1MenuStyle(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (actionButton == true) ...[
              titleHeader(),
              statusLoading == false
                  ? Expanded(
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 24, 24, 24)
                                .withOpacity(0.9),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 30, horizontal: 30),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(cupertinoActivityIndicator, scale: 4),
                            ],
                          ),
                        ),
                      ),
                    )
                  : statusNotdata == true
                      ? Expanded(
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(40.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'images/noresults.png',
                                        color: const Color.fromARGB(
                                            255, 158, 158, 158),
                                        width: 60,
                                        height: 60,
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'ไม่พบงานวันนี้',
                                        style: MyContant().h5NotData(),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : myJob(context)
            ] else ...[
              searchJob(),
              groupBtnsearch(),
            ]
          ],
        ),
      ),
    );
  }

  Padding notData() {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'images/noresults.png',
                color: const Color.fromARGB(255, 158, 158, 158),
                width: 60,
                height: 60,
              )
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'ไม่พบงานวันนี้',
                style: MyContant().h5NotData(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Padding titleHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 8, right: 8),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'รายการงานวันนี้',
                style: MyContant().h6Style(),
              ),
              const Icon(Icons.arrow_drop_down),
            ],
          )
        ],
      ),
    );
  }

  SizedBox myJob(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.65,
      child: ListView(
        shrinkWrap: true,
        children: [
          for (var i = 0; i < workReqList.length; i++)
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        MechanicalDetail(workReqList[i]['workReqTranId']),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 241, 209, 89),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 0.5,
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
                            'เลขที่ใบเปิด Job : ${workReqList[i]['jobTranId']}',
                            style: MyContant().h6Style(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          if (workReqList[i]['jobTranId'] !=
                              workReqList[i]['workReqTranId']) ...[
                            Text(
                              'เลขที่ใบขอช่าง : ${workReqList[i]['workReqTranId']}',
                              style: MyContant().h6Style(),
                            ),
                          ] else ...[
                            Text(
                              'เลขที่ใบขอช่าง : - ',
                              style: MyContant().h6Style(),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Text(
                            'เลขที่ใบขาย : ${workReqList[i]['saleTranId']}',
                            style: MyContant().h6Style(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ชื่อ-สกุล : ',
                            style: MyContant().h6Style(),
                          ),
                          Expanded(
                            child: Text(
                              '${workReqList[i]['custName']}',
                              style: MyContant().h6Style(),
                              overflow: TextOverflow.clip,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'วันที่จัดส่ง : ',
                            style: MyContant().h6Style(),
                          ),
                          Expanded(
                            child: Text(
                              '${workReqList[i]['sendDateTime']}',
                              style: MyContant().h6Style(),
                              overflow: TextOverflow.clip,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ช่างติดตั้ง : ',
                            style: MyContant().h6Style(),
                          ),
                          if (workReqList[i]['empName'].toString() != "[]") ...[
                            Expanded(
                              child: Text(
                                '${workReqList[i]['empName'][0]}',
                                style: MyContant().h6Style(),
                                overflow: TextOverflow.clip,
                              ),
                            ),
                          ] else ...[
                            Expanded(
                              child: Text(
                                ' ',
                                style: MyContant().h6Style(),
                                overflow: TextOverflow.clip,
                              ),
                            ),
                          ]
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }

  Padding searchJob() {
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 241, 209, 89),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 0.5,
              blurRadius: 2,
              offset: const Offset(0, 1),
            )
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Text(
                          'วันที่ : ',
                          style: MyContant().h6Style(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    Row(
                      children: [
                        Text(
                          'เลขที่ใบขาย : ',
                          style: MyContant().h6Style(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    Row(
                      children: [
                        Text(
                          'เลขที่ใบขอช่าง : ',
                          style: MyContant().h6Style(),
                        ),
                      ],
                    ),
                  ],
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          inputDate(sizeIcon, border),
                        ],
                      ),
                      Row(
                        children: [
                          inputsaleTranId(sizeIcon, border),
                        ],
                      ),
                      Row(
                        children: [
                          inputworkReqTranId(sizeIcon, border),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Padding groupBtnsearch() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.040,
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: ElevatedButton(
                      style: MyContant().myButtonSearchStyle(),
                      onPressed: () {
                        if (date.text.isEmpty &&
                            saleTranId.text.isEmpty &&
                            workReqTranId.text.isEmpty) {
                          showProgressDialog(
                              context, 'แจ้งเตือน', 'กรุณากรอกข้อมูล!');
                        } else {
                          var changeDate =
                              date.text.toString().replaceAll('-', '');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MechanicalList(changeDate,
                                  saleTranId.text, workReqTranId.text),
                            ),
                          );
                        }
                      },
                      child: const Text('ค้นหา'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.040,
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: ElevatedButton(
                      style: MyContant().myButtonCancelStyle(),
                      onPressed: () {
                        clearInput();
                      },
                      child: const Text('ล้างข้อมูล'),
                    ),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  Expanded inputDate(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: TextField(
          controller: date,
          onChanged: (keyword) {},
          readOnly: true,
          decoration: InputDecoration(
            suffixIcon: const Icon(
              Icons.calendar_today,
              color: Colors.black,
            ),
            counterText: "",
            contentPadding: const EdgeInsets.all(6),
            isDense: true,
            enabledBorder: border,
            focusedBorder: border,
            prefixIconConstraints: sizeIcon,
            suffixIconConstraints: sizeIcon,
            filled: true,
            fillColor: Colors.white,
          ),
          style: MyContant().textInputStyle(),
          onTap: () async {
            DateTime? pickeddate = await showDatePicker(
              context: context,
              locale: const Locale("th", "TH"),
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );
            if (pickeddate != null) {
              var formattedDate = DateFormat('-MM-dd').format(pickeddate);
              var formattedyear = DateFormat('yyyy').format(pickeddate);

              var year = int.parse(formattedyear);
              final newYear =
                  [year, 543].reduce((value, element) => value + element);

              setState(() {
                date.text =
                    '$newYear$formattedDate'; //set output date to TextField value.
              });
            } else {}
          },
        ),
      ),
    );
  }

  Expanded inputsaleTranId(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: TextField(
          controller: saleTranId,
          onChanged: (keyword) {},
          decoration: InputDecoration(
            counterText: "",
            contentPadding: const EdgeInsets.all(6),
            isDense: true,
            enabledBorder: border,
            focusedBorder: border,
            prefixIconConstraints: sizeIcon,
            suffixIconConstraints: sizeIcon,
            filled: true,
            fillColor: Colors.white,
          ),
          style: MyContant().textInputStyle(),
        ),
      ),
    );
  }

  Expanded inputworkReqTranId(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: TextField(
          controller: workReqTranId,
          onChanged: (keyword) {},
          decoration: InputDecoration(
            counterText: "",
            contentPadding: const EdgeInsets.all(6),
            isDense: true,
            enabledBorder: border,
            focusedBorder: border,
            prefixIconConstraints: sizeIcon,
            suffixIconConstraints: sizeIcon,
            filled: true,
            fillColor: Colors.white,
          ),
          style: MyContant().textInputStyle(),
        ),
      ),
    );
  }
}
