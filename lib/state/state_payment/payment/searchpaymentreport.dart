import 'dart:convert';

import 'package:application_thaweeyont/state/state_payment/payment/paymentreportlist.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:loading_gifs/loading_gifs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../api.dart';
import '../../../utility/my_constant.dart';
import '../../../widgets/custom_appbar.dart';
import '../../authen.dart';

class SearchPaymentReport extends StatefulWidget {
  const SearchPaymentReport({super.key});

  @override
  State<SearchPaymentReport> createState() => _SearchPaymentReportState();
}

class _SearchPaymentReportState extends State<SearchPaymentReport> {
  String userId = '', empId = '', firstName = '', lastName = '', tokenId = '';
  List dropdownbranch = [],
      dropdownsupplylist = [],
      dropdownemployeelist = [],
      dropdownpaymenttypeliist = [];
  String? selectBranchlist;
  bool isLoadingSupplylist = false,
      isLoadingBranch = false,
      isLoadingEmployee = false,
      isLoadingPatmentType = false,
      isDisabled = true;
  var newBranch,
      newSupplylist,
      newEmployee,
      selectSupplylist,
      selectEmployeelist,
      selectpaymentTypelist;
  TextEditingController startdate = TextEditingController();
  TextEditingController enddate = TextEditingController();
  TextEditingController paydetail = TextEditingController();
  TextEditingController supplyname = TextEditingController();

  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    getdata();
    supplyname.addListener(() {
      setState(() {}); // อัปเดต UI ทุกครั้งที่ค่าของ TextField เปลี่ยน
    });
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
      showProgressLoading(context);
      getSelectBranch();
      showProgressLoading(context);
      getSelectEmployeeList();
      showProgressLoading(context);
      getSelectPaymentTypeList();
      selectDatenow();
    }
  }

  void selectDatenow() {
    var formattedDate = DateFormat('-MM-dd').format(selectedDate);
    var formattedYear = DateFormat('yyyy').format(selectedDate);

    var yearnow = int.parse(formattedYear);
    final year = [yearnow, 543].reduce((value, element) => value + element);
    startdate.text = '$year$formattedDate';
  }

  Future<void> getSelectBranch() async {
    try {
      var respose = await http.get(
        Uri.parse('${api}setup/branchList'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> dataBranch =
            Map<String, dynamic>.from(json.decode(respose.body));
        setState(() {
          dropdownbranch = dataBranch['data'];
        });
        Navigator.pop(context);
        isLoadingBranch = true;
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
      } else {
        print(respose.statusCode);
      }
    } catch (e) {
      print("ไม่มีข้อมูล $e");
      showProgressDialog(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
  }

  Future<void> getSelectSupplyList() async {
    try {
      var respose = await http.get(
        Uri.parse('${api}setup/supplyList'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> dataSupplylist =
            Map<String, dynamic>.from(json.decode(respose.body));
        setState(() {
          dropdownsupplylist = dataSupplylist['data'];
        });
        Navigator.pop(context);
        isLoadingSupplylist = false;
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
      } else {
        print(respose.statusCode);
      }
    } catch (e) {
      print("ไม่มีข้อมูล $e");
      showProgressDialog(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
  }

  Future<void> getSelectEmployeeList() async {
    try {
      var respose = await http.get(
        Uri.parse('${api}setup/employeeList'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> dataEmployeelist =
            Map<String, dynamic>.from(json.decode(respose.body));
        setState(() {
          dropdownemployeelist = dataEmployeelist['data'];
        });
        Navigator.pop(context);
        isLoadingEmployee = false;
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
      } else {
        print(respose.statusCode);
      }
    } catch (e) {
      print("ไม่มีข้อมูล $e");
      showProgressDialog(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
  }

  Future<void> getSelectPaymentTypeList() async {
    try {
      var respose = await http.get(
        Uri.parse('${api}setup/paymentTypeList'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> dataPaymentTypelist =
            Map<String, dynamic>.from(json.decode(respose.body));
        setState(() {
          dropdownpaymenttypeliist = dataPaymentTypelist['data'];
        });
        Navigator.pop(context);
        isLoadingPatmentType = true;
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
      } else {
        print(respose.statusCode);
      }
    } catch (e) {
      print("ไม่มีข้อมูล $e");
      showProgressDialog(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
  }

  void clearInput() {
    startdate.clear();
    enddate.clear();
    paydetail.clear();
    supplyname.clear();
    setState(() {
      selectBranchlist = null;
      selectSupplylist = null;
      selectEmployeelist = null;
      selectpaymentTypelist = null;
    });
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
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        behavior: HitTestBehavior.opaque,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 0.2,
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    )
                  ],
                  color: const Color.fromRGBO(226, 199, 132, 1),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'สาขา',
                          style: MyContant().h4normalStyle(),
                        ),
                        selectBranch(sizeIcon, border)
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'ผู้จำหน่าย',
                          style: MyContant().h4normalStyle(),
                        ),
                        selectSupplyList(sizeIcon, border),
                        const SizedBox(width: 3),
                        SizedBox(
                          width: 35,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              shape: const CircleBorder(),
                              backgroundColor:
                                  const Color.fromRGBO(120, 84, 32, 1),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const PaymentTypeList(),
                                ),
                              ).then((result) {
                                if (result != null) {
                                  setState(() {
                                    supplyname.text = result['item1'];
                                    paydetail.text = result['item2'];
                                  });
                                }
                              });
                            },
                            child: const Icon(
                              Icons.search,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 3)
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'ชื่อผู้จำหน่าย',
                          style: MyContant().h4normalStyle(),
                        ),
                        inputSupplyName(sizeIcon, border),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'วันที่',
                          style: MyContant().h4normalStyle(),
                        ),
                        inputStartdate(sizeIcon, border),
                        Text(
                          'ถึง',
                          style: MyContant().h4normalStyle(),
                        ),
                        inputEnddate(sizeIcon, border)
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'ผู้จ่าย',
                          style: MyContant().h4normalStyle(),
                        ),
                        selectEmployeeList(sizeIcon, border),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'รายการจ่าย',
                          style: MyContant().h4normalStyle(),
                        ),
                        inputPaydetail(sizeIcon, border)
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'ประเภทการจ่าย',
                          style: MyContant().h4normalStyle(),
                        ),
                        selectPaytypeList(sizeIcon, border),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            groupBtnsearch(),
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
                    width: MediaQuery.of(context).size.width * 0.22,
                    child: ElevatedButton(
                      style: MyContant().myButtonSearchStyle(),
                      onPressed: () {
                        var valueStartDate = startdate.text.replaceAll('-', '');
                        var valueEndDate = enddate.text.replaceAll('-', '');
                        selectBranchlist != null
                            ? newBranch = selectBranchlist
                            : newBranch = '';
                        selectSupplylist != null
                            ? newSupplylist = selectSupplylist
                            : newSupplylist = '';
                        selectEmployeelist != null
                            ? newEmployee = selectEmployeelist
                            : newEmployee = '';

                        if (startdate.text.isNotEmpty) {
                          showProgressDialog(
                              context, 'แจ้งเตือน', 'กรุณาเลือกวันที่');
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PaymentReportList(
                                newBranch,
                                startdate.text,
                                enddate.text,
                                newSupplylist,
                                supplyname.text,
                                newEmployee,
                                paydetail.text,
                                selectpaymentTypelist,
                                valueStartDate,
                                valueEndDate,
                              ),
                            ),
                          );
                        }
                      },
                      child: const Text('ค้นหา'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.038,
                    width: MediaQuery.of(context).size.width * 0.22,
                    child: ElevatedButton(
                      style: MyContant().myButtonCancelStyle(),
                      onPressed: () {
                        setState(() {
                          clearInput();
                          selectDatenow();
                        });
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

  Padding groupBtnsearch11() {
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
                    height: MediaQuery.of(context).size.height * 0.045,
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blueAccent, // สีตัวอักษรบนปุ่ม
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(15), // ปรับขอบให้มน
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        elevation: 3, // เพิ่มเงา
                      ),
                      onPressed: () {
                        // โค้ดค้นหา
                      },
                      child: const Text(
                        'ค้นหา',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Prompt',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.045,
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.redAccent, // สีตัวอักษรบนปุ่ม
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(15), // ปรับขอบให้มน
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        elevation: 3, // เพิ่มเงา
                      ),
                      onPressed: () {
                        // โค้ดยกเลิกหรือล้างข้อมูล
                      },
                      child: const Text(
                        'ล้างข้อมูล',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Prompt',
                        ),
                      ),
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

  Expanded selectBranch(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Container(
          height: MediaQuery.of(context).size.width * 0.1,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: Padding(
            padding: const EdgeInsets.only(left: 4),
            child: DropdownButton<String>(
              items: dropdownbranch
                  .map((value) => DropdownMenuItem<String>(
                        value: value['id'],
                        child: Text(
                          value['name'],
                          style: MyContant().textInputStyle(),
                        ),
                      ))
                  .toList(),
              onChanged: (String? newvalue) {
                setState(() {
                  selectBranchlist = newvalue;
                });
              },
              value: selectBranchlist,
              isExpanded: true,
              underline: const SizedBox(),
              hint: Align(
                child: Text(
                  'เลือกสาขา',
                  style: MyContant().TextInputSelect(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Expanded selectSupplyList(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Container(
          height: MediaQuery.of(context).size.width * 0.1,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: supplyname.text.isEmpty ? Colors.white : Colors.grey[300],
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 4),
            child: DropdownButton(
              items: dropdownsupplylist
                  .map((value) => DropdownMenuItem(
                        value: value['id'],
                        child: Text(
                          value['name'],
                          style: MyContant().textInputStyle(),
                        ),
                      ))
                  .toList(),
              onChanged: supplyname.text.isEmpty
                  ? (newvalue) {
                      setState(() {
                        selectSupplylist = newvalue;
                      });
                    }
                  : null,
              value: selectSupplylist,
              isExpanded: true,
              underline: const SizedBox(),
              hint: Align(
                child: Text(
                  'เลือกผู้จำหน่าย',
                  style: MyContant().TextInputSelect(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Expanded inputSupplyName(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: TextField(
          enabled: selectSupplylist != null ? false : true,
          controller: supplyname,
          onChanged: (keyword) {},
          decoration: InputDecoration(
            counterText: "",
            contentPadding: const EdgeInsets.all(7),
            border: const OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
            suffixIcon: supplyname.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      supplyname.clear(); // ล้างค่าใน TextField
                      setState(() {}); // อัปเดต UI เพื่อซ่อนไอคอน
                    },
                  )
                : null,
            isDense: true,
            enabledBorder: border,
            focusedBorder: border,
            prefixIconConstraints: sizeIcon,
            suffixIconConstraints: sizeIcon,
            filled: true,
            fillColor:
                selectSupplylist != null ? Colors.grey[300] : Colors.white,
          ),
          style: MyContant().textInputStyle(),
        ),
      ),
    );
  }

  Expanded inputStartdate(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: TextField(
          controller: startdate,
          onChanged: (keyword) {},
          readOnly: true,
          decoration: InputDecoration(
            suffixIcon: const Icon(
              Icons.calendar_today,
              color: Colors.black,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            isDense: true,
            enabledBorder: border,
            focusedBorder: border,
            prefixIconConstraints: sizeIcon,
            suffixIconConstraints: sizeIcon,
            filled: true,
            fillColor: Colors.white,
          ),
          style: MyContant().TextInputDate(),
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
                startdate.text =
                    '$newYear$formattedDate'; //set output date to TextField value.
              });
            } else {}
          },
        ),
      ),
    );
  }

  Expanded inputEnddate(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: TextField(
          controller: enddate,
          onChanged: (keyword) {},
          readOnly: true,
          decoration: InputDecoration(
            suffixIcon: const Icon(
              Icons.calendar_today,
              color: Colors.black,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            isDense: true,
            enabledBorder: border,
            focusedBorder: border,
            prefixIconConstraints: sizeIcon,
            suffixIconConstraints: sizeIcon,
            filled: true,
            fillColor: Colors.white,
          ),
          style: MyContant().TextInputDate(),
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
                enddate.text =
                    '$newYear$formattedDate'; //set output date to TextField value.
              });
            } else {}
          },
        ),
      ),
    );
  }

  Expanded selectEmployeeList(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Container(
          height: MediaQuery.of(context).size.width * 0.1,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: Padding(
            padding: const EdgeInsets.only(left: 4),
            child: DropdownButton(
              items: dropdownemployeelist
                  .map((value) => DropdownMenuItem(
                        value: value['id'],
                        child: Text(
                          value['name'],
                          style: MyContant().textInputStyle(),
                        ),
                      ))
                  .toList(),
              onChanged: (newvalue) {
                setState(() {
                  selectEmployeelist = newvalue;
                });
              },
              value: selectEmployeelist,
              isExpanded: true,
              underline: const SizedBox(),
              hint: Align(
                child: Text(
                  'เลือกผู้จ่าย',
                  style: MyContant().TextInputSelect(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Expanded inputPaydetail(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: TextField(
          controller: paydetail,
          onChanged: (keyword) {},
          decoration: InputDecoration(
            counterText: "",
            contentPadding: const EdgeInsets.all(7),
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

  Expanded selectPaytypeList(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Container(
          height: MediaQuery.of(context).size.width * 0.1,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: Padding(
            padding: const EdgeInsets.only(left: 4),
            child: DropdownButton(
              items: dropdownpaymenttypeliist
                  .map((value) => DropdownMenuItem(
                        value: value['id'],
                        child: Text(
                          value['name'],
                          style: MyContant().textInputStyle(),
                        ),
                      ))
                  .toList(),
              onChanged: (newvalue) {
                setState(() {
                  selectpaymentTypelist = newvalue;
                });
              },
              value: selectpaymentTypelist,
              isExpanded: true,
              underline: const SizedBox(),
              hint: Align(
                child: Text(
                  'เลือกประเภทการจ่าย',
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

class PaymentTypeList extends StatefulWidget {
  const PaymentTypeList({super.key});

  @override
  State<PaymentTypeList> createState() => _PaymentTypeListState();
}

class _PaymentTypeListState extends State<PaymentTypeList> {
  String userId = '', empId = '', firstName = '', lastName = '', tokenId = '';
  TextEditingController supplynamelist = TextEditingController();
  List<dynamic> dropdownsupplylist = [], supplylist = [];
  bool statusLoading = false, statusLoad404 = false, isLoading = false;
  var selectSupplylist;

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
    getSelectSupplyList();
  }

  Future<void> getSelectSupplyList() async {
    try {
      var respose = await http.get(
        Uri.parse('${api}setup/supplyList'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> dataSupplylist =
            Map<String, dynamic>.from(json.decode(respose.body));
        setState(() {
          dropdownsupplylist = dataSupplylist['data'];
          supplylist = dataSupplylist['data'];
        });
        // Navigator.pop(context);
        statusLoading = true;
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
      } else {
        print(respose.statusCode);
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
        appBar: const CustomAppbar(title: 'ค้นหาผู้จำหน่าย'),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          behavior: HitTestBehavior.opaque,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 0.2,
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      )
                    ],
                    color: const Color.fromRGBO(226, 199, 132, 1),
                  ),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'ผู้จำหน่าย : ',
                              style: MyContant().h4normalStyle(),
                            ),
                            inputSupplyName(sizeIcon, border),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              groupBtnsearch(),
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
                    : Scrollbar(
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 6),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 0.2,
                                      blurRadius: 2,
                                      offset: const Offset(0, 1),
                                    )
                                  ],
                                  color: const Color.fromRGBO(226, 199, 132, 1),
                                ),
                                child: Column(
                                  children: [
                                    if (supplylist.isNotEmpty)
                                      for (var i = 0;
                                          i < supplylist.length;
                                          i++)
                                        InkWell(
                                          onTap: () {
                                            // Navigator.push(
                                            //   context,
                                            //   MaterialPageRoute(
                                            //     builder: (context) =>
                                            //         const PaymentDetail(),
                                            //   ),
                                            // );
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 3),
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 6,
                                                      horizontal: 8),
                                              decoration: BoxDecoration(
                                                color: Colors.white
                                                    .withOpacity(0.7),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      supplylist[i]['name'],
                                                      style: MyContant()
                                                          .h4normalStyle(),
                                                      overflow:
                                                          TextOverflow.clip,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ));
  }

  void searchSupplyList() {
    String text = supplynamelist.text;
    supplylist = dropdownsupplylist.where((element) {
      if (element['name'] != null && element['name'] is String) {
        return (element['name'] as String)
            .toLowerCase()
            .contains(text.toLowerCase());
      }
      return false;
    }).toList();
    setState(() {});
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
                    width: MediaQuery.of(context).size.width * 0.22,
                    child: ElevatedButton(
                      style: MyContant().myButtonSearchStyle(),
                      onPressed: () {
                        setState(() {
                          searchSupplyList();
                          // statusLoading = false;
                        });
                      },
                      child: const Text('ค้นหา'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.038,
                    width: MediaQuery.of(context).size.width * 0.22,
                    child: ElevatedButton(
                      style: MyContant().myButtonCancelStyle(),
                      onPressed: () {
                        supplylist = [];
                        setState(() {
                          supplynamelist.clear();
                          supplylist = dropdownsupplylist;
                        });
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

  Expanded inputSupplyName(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: TextField(
          enabled: selectSupplylist != null ? false : true,
          controller: supplynamelist,
          onChanged: (keyword) {},
          decoration: InputDecoration(
            counterText: "",
            contentPadding: const EdgeInsets.all(7),
            border: const OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
            suffixIcon: supplynamelist.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      // supplyname.clear(); // ล้างค่าใน TextField
                      setState(() {}); // อัปเดต UI เพื่อซ่อนไอคอน
                    },
                  )
                : null,
            isDense: true,
            enabledBorder: border,
            focusedBorder: border,
            prefixIconConstraints: sizeIcon,
            suffixIconConstraints: sizeIcon,
            filled: true,
            fillColor:
                selectSupplylist != null ? Colors.grey[300] : Colors.white,
          ),
          style: MyContant().textInputStyle(),
        ),
      ),
    );
  }
}
