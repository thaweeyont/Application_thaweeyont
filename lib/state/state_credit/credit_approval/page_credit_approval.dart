import 'dart:convert';

import 'package:application_thaweeyont/state/state_credit/credit_approval/credit_data_detail.dart';
import 'package:application_thaweeyont/utility/my_constant.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../authen.dart';
import 'package:application_thaweeyont/api.dart';

class Page_Credit_Approval extends StatefulWidget {
  const Page_Credit_Approval({Key? key}) : super(key: key);

  @override
  State<Page_Credit_Approval> createState() => _Page_Credit_ApprovalState();
}

class _Page_Credit_ApprovalState extends State<Page_Credit_Approval> {
  String userId = '',
      empId = '',
      firstName = '',
      lastName = '',
      tokenId = '',
      branchId = '',
      branchName = '';
  bool? allowApproveStatus;
  String? id = '1', value_branch, select_branchlist;
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
  TextEditingController start_date = TextEditingController();
  TextEditingController end_date = TextEditingController();
  TextEditingController idcard = TextEditingController();
  TextEditingController lastname_cust = TextEditingController();

  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Intl.defaultLocale = 'th';
    initializeDateFormatting();
    getdata();
    setState(() {
      id = '1';
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
      branchId = preferences.getString('branchId')!;
      branchName = preferences.getString('branchName')!;
      allowApproveStatus = preferences.getBool('allowApproveStatus');
    });

    print('สิทธิ์อนุมัติ->>${allowApproveStatus}');
    get_select_branch();
    get_select_statusApprove();
    selectDatenow();
    get_select_cus();
    if (allowApproveStatus == false) {
      select_branchlist = branchId;
    }
    print('branch>>${select_branchlist}');
  }

  void selectDatenow() {
    var formattedDate = DateFormat('-MM-dd').format(selectedDate);
    var formattedYear = DateFormat('yyyy').format(selectedDate);
    // var newDate = selectedDate.yearInBuddhistCalendar;
    var yearnow = int.parse(formattedYear);
    final year = [yearnow, 543].reduce((value, element) => value + element);
    start_date.text = '$year$formattedDate';
    print('date_now>>${start_date.text}');
  }

  Future<void> get_select_branch() async {
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

        print(dropdown_branch);
      } else if (respose.statusCode == 401) {
        print(respose.statusCode);
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

  Future<void> get_select_statusApprove() async {
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

        print(dropdown_status);
      } else {
        print(respose.statusCode);
      }
    } catch (e) {
      print("ไม่มีข้อมูล $e");
      showProgressDialog(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
  }

  Future<void> get_select_cus() async {
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
        print(dropdown_customer);
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

  clearValueDialog() {
    setState(() {
      id = '1';
      st_customer = true;
      st_employee = false;
      selectValue_customer = null;
      list_datavalue = [];
      valueNotdata = null;
      Texthint = '';
      statusLoad404approve = false;
    });
    searchData.clear();
    firstname_em.clear();
    lastname_em.clear();
    lastname.clear();
  }

  Future<void> search_idcustomer() async {
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

    Future<void> getData_condition(String? custType, conditionType,
        String searchData, String firstName, String lastName) async {
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
            'limit': '20'
          }),
        );

        if (respose.statusCode == 200) {
          Map<String, dynamic> dataList =
              Map<String, dynamic>.from(json.decode(respose.body));

          setState(() {
            list_datavalue = dataList['data'];
          });

          Navigator.pop(context);
          print('data1>>$list_datavalue');
        } else if (respose.statusCode == 400) {
          print(respose.statusCode);
          showProgressDialog_400(
              context, 'แจ้งเตือน', 'ไม่พบข้อมูล (${respose.statusCode})');
        } else if (respose.statusCode == 401) {
          print(respose.statusCode);
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
            Navigator.pop(context);
            statusLoad404approve = true;
          });
          print(respose.statusCode);
          // showProgressDialog_404(context, 'แจ้งเตือน', 'ไม่พบข้อมูลที่ค้นหา');
        } else if (respose.statusCode == 405) {
          print(respose.statusCode);
          showProgressDialog_405(
              context, 'แจ้งเตือน', 'ไม่พบข้อมูล (${respose.statusCode})');
        } else if (respose.statusCode == 500) {
          print(respose.statusCode);
          showProgressDialog_500(
              context, 'แจ้งเตือน', 'ข้อมูลผิดพลาด (${respose.statusCode})');
        } else {
          showProgressDialog(context, 'แจ้งเตือน', 'กรุณาติดต่อผู้ดูแลระบบ!');
        }
      } catch (e) {
        print("ไม่มีข้อมูล $e");
        showProgressDialog_Notdata(
            context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
      }
    }

    Future<void> getData_search() async {
      if (id == '1') {
        print(id);
        showProgressLoading(context);
        if (selectValue_customer.toString() == "2") {
          getData_condition(
              id, selectValue_customer, '', searchData.text, lastname.text);
        } else {
          getData_condition(id, selectValue_customer, searchData.text, '', '');
        }
      } else {
        print(id);
        showProgressLoading(context);
        getData_condition(id, '2', '', firstname_em.text, lastname_em.text);
      }
    }

    double size = MediaQuery.of(context).size.width;
    showDialog(
      context: context,
      builder: (context) => GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        behavior: HitTestBehavior.opaque,
        child: StatefulBuilder(
          builder: (context, setState) => Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(5),
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 0,
                    color: Colors.white,
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 12, bottom: 6),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'ค้นหาข้อมูลลูกค้า',
                                        style: MyContant().h4normalStyle(),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              right: 0,
                              child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                  clearValueDialog();
                                },
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 4),
                                  child: Icon(
                                    Icons.close,
                                    size: 30,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(
                          color: Color.fromARGB(255, 185, 185, 185),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        // SizedBox(
                        //   height: size * 0.03,
                        // ),
                        // Container(
                        //   padding: EdgeInsets.only(
                        //       left: 15, right: 15, bottom: 15),
                        //   child: Row(
                        //     crossAxisAlignment: CrossAxisAlignment.end,
                        //     mainAxisAlignment: MainAxisAlignment.end,
                        //     children: [
                        //       Row(
                        //         children: [
                        //           InkWell(
                        //             onTap: () {
                        //               Navigator.pop(context);
                        //               clearValueDialog();
                        //             },
                        //             child: Container(
                        //               width: 30,
                        //               height: 30,
                        //               decoration: BoxDecoration(
                        //                   color:
                        //                       Color.fromRGBO(173, 106, 3, 1),
                        //                   shape: BoxShape.circle),
                        //               child: Icon(
                        //                 Icons.close,
                        //                 color: Colors.white,
                        //               ),
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              color: Color.fromRGBO(251, 173, 55, 1),
                            ),
                            padding: const EdgeInsets.all(8),
                            width: double.infinity,
                            child: Column(children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: RadioListTile(
                                      contentPadding: const EdgeInsets.all(0.0),
                                      value: '1',
                                      groupValue: id,
                                      title: Text(
                                        'ลูกค้าทั่วไป',
                                        style: MyContant().h4normalStyle(),
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          st_customer = true;
                                          st_employee = false;
                                          id = value.toString();
                                          statusLoad404approve = false;
                                          searchData.clear();
                                        });
                                        print(value);
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: RadioListTile(
                                      value: '2',
                                      groupValue: id,
                                      title: Text(
                                        'พนักงาน',
                                        style: MyContant().h4normalStyle(),
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          st_customer = false;
                                          st_employee = true;
                                          id = value.toString();
                                          statusLoad404approve = false;
                                          searchData.clear();
                                        });
                                        print(value);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              if (st_employee == true) ...[
                                Row(
                                  children: [
                                    Text(
                                      'ชื่อ',
                                      style: MyContant().h4normalStyle(),
                                    ),
                                    input_nameEmploDia(sizeIcon, border),
                                    Text(
                                      'สกุล',
                                      style: MyContant().h4normalStyle(),
                                    ),
                                    input_lastNameEmploDia(sizeIcon, border),
                                  ],
                                ),
                              ],
                              if (st_customer == true) ...[
                                Row(
                                  children: [
                                    // Text('ชื่อ'),
                                    // select_searchCus(sizeIcon, border),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(1),
                                        child: Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.095,
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 4),
                                            child: DropdownButton(
                                              items: dropdown_customer
                                                  .map((value) =>
                                                      DropdownMenuItem(
                                                        value: value['id'],
                                                        child: Text(
                                                          value['name'],
                                                          style: MyContant()
                                                              .TextInputStyle(),
                                                        ),
                                                      ))
                                                  .toList(),
                                              onChanged: (newvalue) {
                                                print(newvalue);
                                                setState(() {
                                                  selectValue_customer =
                                                      newvalue;
                                                  if (selectValue_customer
                                                          .toString() ==
                                                      "2") {
                                                    Texthint = 'ชื่อ';
                                                  } else {
                                                    Texthint = '';
                                                  }
                                                  statusLoad404approve = false;
                                                  searchData.clear();
                                                });
                                              },
                                              value: selectValue_customer,
                                              isExpanded: true,
                                              underline: const SizedBox(),
                                              hint: Align(
                                                child: Text(
                                                  'กรุณาเลือกข้อมูล',
                                                  style: MyContant()
                                                      .TextInputSelect(),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    input_searchCus(sizeIcon, border),
                                    if (selectValue_customer.toString() ==
                                        "2") ...[
                                      input_lastnameCus(sizeIcon, border)
                                    ],
                                  ],
                                ),
                              ],
                            ]),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.034,
                                width: MediaQuery.of(context).size.width * 0.22,
                                child: ElevatedButton(
                                  style: MyContant().myButtonSearchStyle(),
                                  onPressed: () {
                                    if (id == '1') {
                                      print('1==>> $id');
                                      if (selectValue_customer == null ||
                                          searchData.text.isEmpty &&
                                              lastname.text.isEmpty) {
                                        showProgressDialog(context, 'แจ้งเตือน',
                                            'กรุณากรอกข้อมูล');
                                      } else {
                                        getData_search();
                                      }
                                    } else {
                                      print('2==>> $id');
                                      if (firstname_em.text.isEmpty &&
                                          lastname_em.text.isEmpty) {
                                        showProgressDialog(context, 'แจ้งเตือน',
                                            'กรุณากรอกข้อมูล');
                                      } else {
                                        getData_search();
                                      }
                                    }
                                  },
                                  child: const Text('ค้นหา'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            children: [
                              Text(
                                'รายการที่ค้นหา',
                                style: MyContant().h2Style(),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: Scrollbar(
                            child: ListView(
                              children: [
                                if (list_datavalue.isNotEmpty) ...[
                                  for (var i = 0;
                                      i < list_datavalue.length;
                                      i++) ...[
                                    InkWell(
                                      onTap: () {
                                        setState(
                                          () {
                                            custId.text =
                                                list_datavalue[i]['custId'];
                                            Navigator.pop(context);
                                            clearValueDialog();
                                          },
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 2, horizontal: 8),
                                        child: Container(
                                          // margin:
                                          //     EdgeInsets.symmetric(vertical: 5),
                                          padding: const EdgeInsets.all(8.0),
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                            color:
                                                Color.fromRGBO(251, 173, 55, 1),
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
                                                      overflow:
                                                          TextOverflow.clip,
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
                                                    'โทร : ${list_datavalue[i]['telephone']}',
                                                    style: MyContant()
                                                        .h4normalStyle(),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ] else if (statusLoad404approve == true) ...[
                                  Padding(
                                    padding: const EdgeInsets.only(top: 100),
                                    child: Column(
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
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
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
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(251, 173, 55, 1),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'รหัสลูกค้า',
                          style: MyContant().h4normalStyle(),
                        ),
                        input_idcustomer(sizeIcon, border),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            backgroundColor:
                                const Color.fromRGBO(173, 106, 3, 1),
                          ),
                          onPressed: () {
                            search_idcustomer();
                          },
                          child: const Icon(
                            Icons.search,
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
                        input_idcard(sizeIcon, border),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'ชื่อ',
                          style: MyContant().h4normalStyle(),
                        ),
                        input_namecustomer(sizeIcon, border),
                        Text(
                          'นามสกุล',
                          style: MyContant().h4normalStyle(),
                        ),
                        input_lastnamecustomer(sizeIcon, border),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'สาขา',
                          style: MyContant().h4normalStyle(),
                        ),
                        select_branch(sizeIcon, border),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'วันที่   ',
                          style: MyContant().h4normalStyle(),
                        ),
                        input_dateStart(sizeIcon, border),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'ถึงวันที่',
                          style: MyContant().h4normalStyle(),
                        ),
                        input_dateEnd(sizeIcon, border),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'ผลการพิจารณา',
                          style: MyContant().h4normalStyle(),
                        ),
                        select_statusApprove(sizeIcon, border),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            group_btnsearch(),
          ],
        ),
      ),
    );
  }

  Padding group_btnsearch() {
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
                    height: MediaQuery.of(context).size.height * 0.034,
                    width: MediaQuery.of(context).size.width * 0.22,
                    child: ElevatedButton(
                      style: MyContant().myButtonSearchStyle(),
                      onPressed: () {
                        var newStratDate = start_date.text.replaceAll('-', '');
                        var newEndDate = end_date.text.replaceAll('-', '');
                        print('s==>> $newStratDate');
                        print('e==>> $newEndDate');
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
                              new_branch,
                              newStratDate,
                              newEndDate,
                              select_index_approve,
                            ),
                          ),
                        );
                        // if (custId.text.isEmpty &&
                        //     idcard.text.isEmpty &&
                        //     custName.text.isEmpty &&
                        //     lastname_cust.text.isEmpty) {
                        //   showProgressDialog(context, 'แจ้งเตือน',
                        //       'กรุณากรอก รหัส หรือ เลขที่บัตร หรือ ชื่อ-สกุล ลูกค้า');
                        // } else {
                        //   var newStratDate =
                        //       start_date.text.replaceAll('-', '');
                        //   var newEndDate = end_date.text.replaceAll('-', '');
                        //   print('s==>> $newStratDate');
                        //   print('e==>> $newEndDate');
                        //   showProgressLoading(context);
                        //   getData_approve(newStratDate, newEndDate);
                        // }
                        // showProgressLoading(context);

                        // getData_approve(newStratDate, newEndDate);
                      },
                      child: const Text('ค้นหา'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.034,
                    width: MediaQuery.of(context).size.width * 0.22,
                    child: ElevatedButton(
                      style: MyContant().myButtonCancelStyle(),
                      onPressed: () {
                        clearValueapprove();
                      },
                      child: const Text('ยกเลิก'),
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

  Expanded input_idcustomer(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 8,
          bottom: 8,
          left: 8,
        ),
        child: TextField(
          controller: custId,
          onChanged: (keyword) {},
          decoration: InputDecoration(
            counterText: "",
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
          style: MyContant().TextInputStyle(),
        ),
      ),
    );
  }

  Expanded input_idcard(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: idcard,
          keyboardType: TextInputType.number,
          maxLength: 13,
          onChanged: (keyword) {},
          decoration: InputDecoration(
            counterText: "",
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
          style: MyContant().TextInputStyle(),
        ),
      ),
    );
  }

  Expanded input_namecustomer(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: custName,
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
          style: MyContant().TextInputStyle(),
        ),
      ),
    );
  }

  Expanded input_lastnamecustomer(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: lastname_cust,
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
          style: MyContant().TextInputStyle(),
        ),
      ),
    );
  }

  Expanded input_searchCus(sizeIcon, border) {
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
          style: MyContant().TextInputStyle(),
        ),
      ),
    );
  }

  Expanded input_nameEmploDia(sizeIcon, border) {
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
          style: MyContant().TextInputStyle(),
        ),
      ),
    );
  }

  Expanded input_lastNameEmploDia(sizeIcon, border) {
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
          style: MyContant().TextInputStyle(),
        ),
      ),
    );
  }

  Expanded input_lastnameCus(sizeIcon, border) {
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
          style: MyContant().TextInputStyle(),
        ),
      ),
    );
  }

  Expanded select_branch(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
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
                            style: MyContant().TextInputStyle(),
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

  Expanded select_statusApprove(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
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
                          style: MyContant().TextInputStyle(),
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

  Expanded input_dateStart(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: TextField(
          controller: start_date,
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
              // var newDate = pickeddate.yearInBuddhistCalendar;
              var year = int.parse(formattedyear);
              final newYear =
                  [year, 543].reduce((value, element) => value + element);
              print('===>> $year');
              print(formattedDate);
              setState(() {
                start_date.text =
                    '$newYear$formattedDate'; //set output date to TextField value.
                print(start_date.text);
              });
            } else {}
          },
        ),
      ),
    );
  }

  Expanded input_dateEnd(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: TextField(
          controller: end_date,
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
              // var newDate = pickeddate.yearInBuddhistCalendar;
              var year = int.parse(formattedyear);
              final newYear =
                  [year, 543].reduce((value, element) => value + element);
              print('===>> $year');
              setState(() {
                end_date.text =
                    '$newYear$formattedDate'; //set output date to TextField value.
                print(end_date.text);
              });
            } else {}
          },
        ),
      ),
    );
  }
}
