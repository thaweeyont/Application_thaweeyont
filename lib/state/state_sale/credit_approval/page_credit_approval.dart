import 'dart:convert';

import 'package:application_thaweeyont/state/state_sale/credit_approval/credit_data_detail.dart';
import 'package:application_thaweeyont/state/state_sale/credit_approval/testUI.dart';
import 'package:application_thaweeyont/utility/my_constant.dart';
import 'package:application_thaweeyont/widgets/custom_appbar.dart';
import 'package:application_thaweeyont/widgets/endpage.dart';
import 'package:application_thaweeyont/widgets/loaddata.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:loading_gifs/loading_gifs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../authen.dart';
import 'package:application_thaweeyont/api.dart';

class PageCreditApproval extends StatefulWidget {
  const PageCreditApproval({super.key});

  @override
  State<PageCreditApproval> createState() => _PageCreditApprovalState();
}

class _PageCreditApprovalState extends State<PageCreditApproval> {
  String userId = '',
      empId = '',
      firstName = '',
      lastName = '',
      tokenId = '',
      branchId = '',
      branchName = '';
  bool? allowApproveStatus;
  String? value_branch, select_branchlist;
  bool st_customer = true, st_employee = false, statusLoad404approve = false;
  var status = false, valueStatus, Texthint, valueNotdata, new_branch;
  var selectValue_customer,
      selectvalue_saletype,
      select_index_approve,
      select_status;

  var filter_search = false;
  List list_datavalue = [],
      dropdown_customer = [],
      dropdown_branch = [],
      dropdown_status = [],
      list_approve = [];

  TextEditingController custId = TextEditingController();
  TextEditingController custName = TextEditingController();
  TextEditingController searchData = TextEditingController();
  TextEditingController firstname_em = TextEditingController();
  TextEditingController lastname_em = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController signrunning = TextEditingController();
  TextEditingController start_date = TextEditingController();
  TextEditingController end_date = TextEditingController();
  TextEditingController idcard = TextEditingController();
  TextEditingController lastname_cust = TextEditingController();

  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    Intl.defaultLocale = 'th';
    initializeDateFormatting();
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
      branchId = preferences.getString('branchId')!;
      branchName = preferences.getString('branchName')!;
      allowApproveStatus = preferences.getBool('allowApproveStatus');
    });

    getSelectBranch();
    getSelectStatusApprove();
    selectDatenow();
    if (allowApproveStatus == false) {
      select_branchlist = branchId;
    }
  }

  void selectDatenow() {
    var formattedDate = DateFormat('-MM-dd').format(selectedDate);
    var formattedYear = DateFormat('yyyy').format(selectedDate);

    var yearnow = int.parse(formattedYear);
    final year = [yearnow, 543].reduce((value, element) => value + element);
    start_date.text = '$year$formattedDate';
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
        Map<String, dynamic> data_branch =
            Map<String, dynamic>.from(json.decode(respose.body));
        setState(() {
          dropdown_branch = data_branch['data'];
        });
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

  Future<void> getSelectStatusApprove() async {
    try {
      var respose = await http.get(
        Uri.parse('${api}setup/approveStatus'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> data_statusApprove =
            Map<String, dynamic>.from(json.decode(respose.body));
        setState(() {
          dropdown_status = data_statusApprove['data'];
          select_index_approve = dropdown_status[3]['id'];
        });
      } else {
        print(respose.statusCode);
      }
    } catch (e) {
      print("ไม่มีข้อมูล $e");
      showProgressDialog(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
  }

  clearValueapprove() {
    custId.clear();
    idcard.clear();
    custName.clear();
    lastname_cust.clear();
    signrunning.clear();
    end_date.clear();
    setState(() {
      selectDatenow();
      if (allowApproveStatus == false) {
        select_branchlist = branchId;
      } else {
        select_branchlist = null;
      }
      select_index_approve = dropdown_status[3]['id'];
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
                  color: const Color.fromRGBO(251, 173, 55, 1),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
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
                    Row(
                      children: [
                        Text(
                          'รหัสลูกค้า',
                          style: MyContant().h4normalStyle(),
                        ),
                        inputIdcustomer(sizeIcon, border),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            backgroundColor:
                                const Color.fromRGBO(173, 106, 3, 1),
                          ),
                          onPressed: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => const CustomerList(),
                            //   ),
                            // ).then((result) {
                            //   if (result != null) {
                            //     setState(() {
                            //       custId.text = result['id'];
                            //     });
                            //   }
                            // });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FixedTablePage(),
                              ),
                            );
                          },
                          child: const Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'เลขที่บัตร',
                          style: MyContant().h4normalStyle(),
                        ),
                        inputIdcard(sizeIcon, border),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'ชื่อ',
                          style: MyContant().h4normalStyle(),
                        ),
                        inputNamecustomer(sizeIcon, border),
                        Text(
                          'นามสกุล',
                          style: MyContant().h4normalStyle(),
                        ),
                        inputLastnamecustomer(sizeIcon, border),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'รันนิ่งสัญญา',
                          style: MyContant().h4normalStyle(),
                        ),
                        inputSignRunning(sizeIcon, border),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'สาขา',
                          style: MyContant().h4normalStyle(),
                        ),
                        selectBranch(sizeIcon, border),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'วันที่   ',
                          style: MyContant().h4normalStyle(),
                        ),
                        inputDateStart(sizeIcon, border),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'ถึงวันที่',
                          style: MyContant().h4normalStyle(),
                        ),
                        inputDateEnd(sizeIcon, border),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'ผลการพิจารณา',
                          style: MyContant().h4normalStyle(),
                        ),
                        selectStatusApprove(sizeIcon, border),
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
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: ElevatedButton(
                      style: MyContant().myButtonSearchStyle(),
                      onPressed: () {
                        var newStratDate = start_date.text.replaceAll('-', '');
                        var newEndDate = end_date.text.replaceAll('-', '');

                        if (select_branchlist == null) {
                          new_branch = "";
                        } else {
                          new_branch = select_branchlist;
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Credit_data_detail(
                              custId.text,
                              idcard.text,
                              custName.text,
                              lastname_cust.text,
                              signrunning.text,
                              new_branch,
                              newStratDate,
                              newEndDate,
                              select_index_approve,
                            ),
                          ),
                        );
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
                        clearValueapprove();
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

  SizedBox line() {
    return const SizedBox(
      height: 0,
      width: double.infinity,
      child: Divider(
        color: Color.fromARGB(255, 34, 34, 34),
      ),
    );
  }

  Expanded inputIdcustomer(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: TextField(
          controller: custId,
          onChanged: (keyword) {},
          decoration: InputDecoration(
            counterText: "",
            contentPadding: const EdgeInsets.all(8),
            isDense: true,
            enabledBorder: border,
            focusedBorder: border,
            hintStyle: const TextStyle(
              fontSize: 14,
            ),
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

  Expanded inputIdcard(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: TextField(
          controller: idcard,
          keyboardType: TextInputType.number,
          maxLength: 13,
          onChanged: (keyword) {},
          decoration: InputDecoration(
            counterText: "",
            contentPadding: const EdgeInsets.all(8),
            isDense: true,
            enabledBorder: border,
            focusedBorder: border,
            hintStyle: const TextStyle(
              fontSize: 14,
            ),
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

  Expanded inputNamecustomer(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: TextField(
          controller: custName,
          onChanged: (keyword) {},
          decoration: InputDecoration(
            counterText: "",
            contentPadding: const EdgeInsets.all(8),
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

  Expanded inputLastnamecustomer(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: TextField(
          controller: lastname_cust,
          onChanged: (keyword) {},
          decoration: InputDecoration(
            counterText: "",
            contentPadding: const EdgeInsets.all(8),
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

  Expanded inputSignRunning(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: TextField(
          controller: signrunning,
          keyboardType: TextInputType.number,
          onChanged: (keyword) {},
          decoration: InputDecoration(
            counterText: "",
            contentPadding: const EdgeInsets.all(8),
            isDense: true,
            enabledBorder: border,
            focusedBorder: border,
            hintStyle: const TextStyle(
              fontSize: 14,
            ),
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

  Expanded inputSearchCus(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: searchData,
          onChanged: (keyword) {},
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(6),
            isDense: true,
            enabledBorder: border,
            focusedBorder: border,
            hintText: Texthint,
            hintStyle: MyContant().hintTextStyle(),
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

  Expanded inputNameEmploDia(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: firstname_em,
          onChanged: (keyword) {},
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(6),
            isDense: true,
            enabledBorder: border,
            focusedBorder: border,
            hintStyle: const TextStyle(
              fontSize: 14,
            ),
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

  Expanded inputLastNameEmploDia(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: lastname_em,
          onChanged: (keyword) {},
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(6),
            isDense: true,
            enabledBorder: border,
            focusedBorder: border,
            hintStyle: const TextStyle(
              fontSize: 14,
            ),
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

  Expanded inputLastnameCus(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: TextField(
          controller: lastname,
          onChanged: (keyword) {},
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(6),
            isDense: true,
            enabledBorder: border,
            focusedBorder: border,
            hintText: 'นามสกุล',
            hintStyle: MyContant().hintTextStyle(),
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

  Expanded selectBranch(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Container(
          height: MediaQuery.of(context).size.width * 0.1,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 4),
            child: DropdownButton<String>(
              items: dropdown_branch.isEmpty
                  ? []
                  : dropdown_branch
                      .map(
                        (value) => DropdownMenuItem<String>(
                          value: value['id'].toString(),
                          child: Text(
                            value['name'],
                            style: MyContant().textInputStyle(),
                          ),
                        ),
                      )
                      .toList(),
              onChanged: allowApproveStatus == true
                  ? (String? newvalue) {
                      setState(() {
                        select_branchlist = newvalue;
                      });
                    }
                  : null,
              value: select_branchlist,
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

  Expanded selectStatusApprove(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Container(
          height: MediaQuery.of(context).size.width * 0.1,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 4),
            child: DropdownButton(
              items: dropdown_status
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
                  select_index_approve = newvalue;
                });
              },
              value: select_index_approve,
              isExpanded: true,
              underline: const SizedBox(),
              hint: Align(
                child: Text(
                  'เลือกผลการพิจารณา',
                  style: MyContant().TextInputSelect(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Expanded inputDateStart(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: TextField(
          controller: start_date,
          onChanged: (keyword) {},
          readOnly: true,
          decoration: InputDecoration(
            suffixIcon: const Icon(
              Icons.calendar_today,
              color: Colors.black,
            ),
            // contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            contentPadding: const EdgeInsets.all(8),
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
                start_date.text =
                    '$newYear$formattedDate'; //set output date to TextField value.
              });
            } else {}
          },
        ),
      ),
    );
  }

  Expanded inputDateEnd(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: TextField(
          controller: end_date,
          onChanged: (keyword) {},
          readOnly: true,
          decoration: InputDecoration(
            suffixIcon: const Icon(
              Icons.calendar_today,
              color: Colors.black,
            ),
            // contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            contentPadding: const EdgeInsets.all(8),
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
                end_date.text =
                    '$newYear$formattedDate'; //set output date to TextField value.
              });
            } else {}
          },
        ),
      ),
    );
  }
}

class CustomerList extends StatefulWidget {
  const CustomerList({super.key});

  @override
  State<CustomerList> createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomerList> {
  String userId = '', empId = '', firstName = '', lastName = '', tokenId = '';
  List list_datavalue = [], dropdown_customer = [];
  String? id = '1';
  bool st_customer = true, st_employee = false, statusLoad404approve = false;
  bool statusLoading = false,
      statusLoad404 = false,
      isLoading = false,
      isLoadScroll = false,
      isLoadendPage = false;
  var selectValue_customer, Texthint;
  final scrollControll = TrackingScrollController();
  int offset = 50, stquery = 0;

  TextEditingController searchData = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController firstname_em = TextEditingController();
  TextEditingController lastname_em = TextEditingController();

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
    getSelectCus();
    myScroll(scrollControll, offset);
  }

  Future<void> getSelectCus() async {
    try {
      var respose = await http.get(
        Uri.parse('${api}setup/custCondition'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> data =
            Map<String, dynamic>.from(json.decode(respose.body));
        setState(() {
          dropdown_customer = data['data'];
        });
        statusLoading = true;
      } else {
        print(respose.statusCode);
      }
    } catch (e) {
      print("ไม่มีข้อมูล $e");
      showProgressDialog(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
  }

  Future<void> getData_condition(String? custType, conditionType,
      String searchData, String firstName, String lastName, offset) async {
    try {
      var respose = await http.post(
        Uri.parse('${api}customer/list'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
        body: jsonEncode(<String, String>{
          'custType': custType.toString(),
          'conditionType': conditionType.toString(),
          'searchData': searchData.toString(),
          'firstName': firstName.toString(),
          'lastName': lastName.toString(),
          'page': '1',
          'limit': '$offset'
        }),
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> dataList =
            Map<String, dynamic>.from(json.decode(respose.body));

        setState(() {
          list_datavalue = dataList['data'];
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
        showProgressDialog(context, 'แจ้งเตือน', 'กรุณาติดต่อผู้ดูแลระบบ!');
      }
    } catch (e) {
      print("ไม่มีข้อมูล $e");
      showProgressDialogNotdata(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
  }

  Future<void> getData_search(offset) async {
    if (id == '1') {
      if (selectValue_customer.toString() == "2") {
        getData_condition(id, selectValue_customer, '', searchData.text,
            lastname.text, offset);
      } else {
        getData_condition(
            id, selectValue_customer, searchData.text, '', '', offset);
      }
    } else {
      getData_condition(
          id, '2', '', firstname_em.text, lastname_em.text, offset);
    }
  }

  void myScroll(ScrollController scrollController, int offset) {
    scrollController.addListener(() async {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        setState(() {
          isLoadScroll = true;
        });
        await Future.delayed(const Duration(seconds: 1), () {
          offset = offset + 20;
          getData_search(offset);
        });
      }
    });
  }

  clearValueDialog() {
    setState(() {
      id = '1';
      st_customer = true;
      st_employee = false;
      selectValue_customer = null;
      list_datavalue = [];
      Texthint = '';
      statusLoad404approve = false;
      isLoadScroll = false;
    });
    searchData.clear();
    firstname_em.clear();
    lastname_em.clear();
    lastname.clear();
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
      appBar: const CustomAppbar(title: 'ค้นหาข้อมูลลูกค้า'),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        behavior: HitTestBehavior.opaque,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withAlpha(130),
                      spreadRadius: 0.2,
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    )
                  ],
                  color: const Color.fromRGBO(251, 173, 55, 1),
                ),
                padding: const EdgeInsets.all(6),
                width: double.infinity,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: ['1', '2'].map((val) {
                          final isCustomer = val == '1';
                          return Expanded(
                            child: RadioListTile(
                              activeColor: Colors.black,
                              value: val,
                              groupValue: id,
                              title: Text(
                                isCustomer ? 'ลูกค้าทั่วไป' : 'พนักงาน',
                                style: MyContant().h4normalStyle(),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  st_customer = isCustomer;
                                  st_employee = !isCustomer;
                                  id = value.toString();
                                  searchData.clear();
                                });
                              },
                              visualDensity: VisualDensity.compact,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            ),
                          );
                        }).toList(),
                      ),
                      if (st_employee == true) ...[
                        Row(
                          children: [
                            Text(
                              'ชื่อ',
                              style: MyContant().h4normalStyle(),
                            ),
                            inputNameEmploDia(sizeIcon, border),
                            Text(
                              'สกุล',
                              style: MyContant().h4normalStyle(),
                            ),
                            inputLastNameEmploDia(sizeIcon, border),
                          ],
                        ),
                      ],
                      if (st_customer == true) ...[
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 7),
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.width * 0.095,
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 4),
                                    child: DropdownButton(
                                      items: dropdown_customer
                                          .map((value) => DropdownMenuItem(
                                                value: value['id'],
                                                child: Text(
                                                  value['name'],
                                                  style: MyContant()
                                                      .textInputStyle(),
                                                ),
                                              ))
                                          .toList(),
                                      onChanged: (newvalue) {
                                        setState(() {
                                          selectValue_customer = newvalue;
                                          Texthint = newvalue.toString() == '2'
                                              ? 'ชื่อ'
                                              : '';
                                          searchData.clear();
                                        });
                                      },
                                      value: selectValue_customer,
                                      isExpanded: true,
                                      underline: const SizedBox(),
                                      hint: Align(
                                        child: Text(
                                          'กรุณาเลือกข้อมูล',
                                          style: MyContant().TextInputSelect(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            inputSearchCus(sizeIcon, border),
                            if (selectValue_customer.toString() == "2") ...[
                              inputLastnameCus(sizeIcon, border)
                            ],
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            groupBtnsearch(),
            const SizedBox(height: 5),
            Expanded(
              child: statusLoading == false
                  ? Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 24, 24, 24)
                              .withValues(alpha: 0.9),
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
                                      'ไม่พบรายการข้อมูล',
                                      style: MyContant().h5NotData(),
                                    ),
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
                            children: [
                              for (var i = 0; i < list_datavalue.length; i++)
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context, {
                                      'id': list_datavalue[i]['custId'],
                                      // 'name': list_datavalue[i]['custName'],
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 8),
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        color: const Color.fromRGBO(
                                            251, 173, 55, 1),
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
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: Colors.white
                                              .withValues(alpha: 0.7),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  'รหัส : ${list_datavalue[i]['custId']}',
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
                                                  'ชื่อ : ${list_datavalue[i]['custName']}',
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
                                                  'ที่อยู่ : ',
                                                  style: MyContant()
                                                      .h4normalStyle(),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    '${list_datavalue[i]['address']}',
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
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'โทร : ',
                                                  style: MyContant()
                                                      .h4normalStyle(),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    '${list_datavalue[i]['telephone']}',
                                                    style: MyContant()
                                                        .h4normalStyle(),
                                                    overflow: TextOverflow.clip,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              if (isLoadScroll == true &&
                                  isLoadendPage == false) ...[
                                const LoadData(),
                              ] else if (isLoadendPage == true) ...[
                                const EndPage(),
                              ],
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
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
                        setState(() {
                          if (id == '1') {
                            if (selectValue_customer == null ||
                                searchData.text.isEmpty &&
                                    lastname.text.isEmpty) {
                              showProgressDialog(
                                  context, 'แจ้งเตือน', 'กรุณากรอกข้อมูล');
                            } else {
                              getData_search(offset);
                              statusLoading = false;
                            }
                          } else {
                            if (firstname_em.text.isEmpty &&
                                lastname_em.text.isEmpty) {
                              showProgressDialog(
                                  context, 'แจ้งเตือน', 'กรุณากรอกข้อมูล');
                            } else {
                              getData_search(offset);
                              statusLoading = false;
                            }
                          }
                        });
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
                        clearValueDialog();
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

  Expanded inputSearchCus(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: SizedBox(
          height: MediaQuery.of(context).size.width * 0.095,
          child: TextField(
            controller: searchData,
            onChanged: (keyword) {},
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(8),
              isDense: true,
              enabledBorder: border,
              focusedBorder: border,
              hintText: Texthint,
              hintStyle: MyContant().hintTextStyle(),
              prefixIconConstraints: sizeIcon,
              suffixIconConstraints: sizeIcon,
              filled: true,
              fillColor: Colors.white,
            ),
            style: MyContant().textInputStyle(),
          ),
        ),
      ),
    );
  }

  Expanded inputNameEmploDia(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: firstname_em,
          onChanged: (keyword) {},
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(8),
            isDense: true,
            enabledBorder: border,
            focusedBorder: border,
            hintStyle: const TextStyle(
              fontSize: 14,
            ),
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

  Expanded inputLastNameEmploDia(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: lastname_em,
          onChanged: (keyword) {},
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(8),
            isDense: true,
            enabledBorder: border,
            focusedBorder: border,
            hintStyle: const TextStyle(
              fontSize: 14,
            ),
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

  Expanded inputLastnameCus(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(right: 4),
        child: SizedBox(
          height: MediaQuery.of(context).size.width * 0.095,
          child: TextField(
            controller: lastname,
            onChanged: (keyword) {},
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(8),
              isDense: true,
              enabledBorder: border,
              focusedBorder: border,
              hintText: 'นามสกุล',
              hintStyle: MyContant().hintTextStyle(),
              prefixIconConstraints: sizeIcon,
              suffixIconConstraints: sizeIcon,
              filled: true,
              fillColor: Colors.white,
            ),
            style: MyContant().textInputStyle(),
          ),
        ),
      ),
    );
  }
}
