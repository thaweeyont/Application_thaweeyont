import 'dart:convert';

import 'package:application_thaweeyont/utility/my_constant.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../authen.dart';
import 'page_check_blacklist.dart';
import 'page_info_consider_cus.dart';

class Page_Credit_Approval extends StatefulWidget {
  const Page_Credit_Approval({super.key});

  @override
  State<Page_Credit_Approval> createState() => _Page_Credit_ApprovalState();
}

class _Page_Credit_ApprovalState extends State<Page_Credit_Approval> {
  String userId = '', empId = '', firstName = '', lastName = '', tokenId = '';
  String page = 'list_content1';
  String? id = '1';
  bool active_cl1 = true, active_cl2 = false, active_cl3 = false;
  bool st_customer = true, st_employee = false;
  var valueapprove, status = false, valueStatus, Texthint, valueNotdata;
  var selectValue_customer,
      selectvalue_saletype,
      select_branchlist,
      select_status;
  var filter_search = false;
  List list_quarantee = [],
      list_datavalue = [],
      dropdown_customer = [],
      list_signDetail = [],
      dropdown_branch = [],
      dropdown_status = [],
      list_approve = [];

  // Map<String, dynamic>? list_signDetail;

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      id = '1';
    });
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
    get_select_branch();
    get_select_statusApprove();
  }

  Future<void> getData_approve() async {
    print(tokenId);
    try {
      var respose = await http.post(
        Uri.parse('https://twyapp.com/twyapi/apiV1/credit/approve'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
        body: jsonEncode(<String, String>{
          'custId': custId.text,
          'smartId': idcard.text,
          'firstName': custName.text,
          'lastName': lastname_cust.text,
          'branchId': select_branchlist,
          'startDate': start_date.text,
          'endDate': end_date.text,
          'approveStatus': select_status.toString(),
          'page': '1',
          'limit': '20'
        }),
      );
      print(custId.text);
      print(idcard.text);
      print(custName.text);
      print(lastname_cust.text);
      print(select_branchlist.toString());
      print(select_status.toString());
      if (respose.statusCode == 200) {
        Map<String, dynamic> data_approve =
            new Map<String, dynamic>.from(json.decode(respose.body));

        setState(() {
          list_approve = data_approve['data'];
        });
        // Navigator.pop(context);

        print('==>> $list_approve');
        print(valueStatus);
      } else {
        setState(() {
          valueStatus = respose.statusCode;
        });
        // Navigator.pop(context);
        print(respose.statusCode);
        print(respose.body);
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
      // Navigator.pop(context);
      print("ไม่มีข้อมูล $e");
    }
  }

  // Future<void> getData_approve() async {
  //   print(tokenId);
  //   print(custName.text);
  //   print(lastname_cust.text);
  //   print(select_status.toString());

  //   try {
  //     var respose = await http.post(
  //       Uri.parse('https://twyapp.com/twyapi/apiV1/credit/approve'),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json',
  //         'Authorization': tokenId.toString(),
  //       },
  //       body: jsonEncode(<String, String>{
  //         'custId': "M010707046123",
  //         'smartId': idcard.text,
  //         'firstName': custName.text,
  //         'lastName': lastname_cust.text,
  //         'branchId': select_branchlist.toString(),
  //         'startDate': start_date.text,
  //         'endDate': end_date.text,
  //         'approveStatus': "1",
  //         'page': '1',
  //         'limit': '20',
  //       }),
  //     );

  //     if (respose.statusCode == 200) {
  //       Map<String, dynamic> dataApprove =
  //           new Map<String, dynamic>.from(json.decode(respose.body));

  //       // status = true;
  //       // valueapprove = dataApprove['data'];
  //       setState(() {
  //         list_approve = dataApprove['data'];
  //       });

  //       print('#===> $list_approve');
  //       // Navigator.pop(context);
  //     } else {
  //       setState(() {
  //         valueStatus = respose.statusCode;
  //       });
  //       // Navigator.pop(context);
  //       print(respose.statusCode);
  //       print('ไม่พบข้อมูล');
  //       Map<String, dynamic> check_list =
  //           new Map<String, dynamic>.from(json.decode(respose.body));
  //       print(respose.statusCode);
  //       print(check_list['message']);
  //       if (check_list['message'] == "Token Unauthorized") {
  //         SharedPreferences preferences = await SharedPreferences.getInstance();
  //         preferences.clear();
  //         Navigator.pushAndRemoveUntil(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => Authen(),
  //           ),
  //           (Route<dynamic> route) => false,
  //         );
  //       }
  //     }
  //   } catch (e) {
  //     // Navigator.pop(context);
  //     showProgressDialog(context, 'แจ้งเตือน', 'ไม่พบข้อมูล');
  //     print("ไม่มีข้อมูล $e");
  //   }
  // }

  Future<void> get_select_branch() async {
    print(tokenId);
    try {
      var respose = await http.get(
        Uri.parse('https://twyapp.com/twyapi/apiV1/setup/branchList'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
        // body: jsonEncode(<String, String>{'page': '1', 'limit': '100'}),
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> data_branch =
            new Map<String, dynamic>.from(json.decode(respose.body));
        setState(() {
          dropdown_branch = data_branch['data'];
        });

        print(dropdown_branch);
      } else {
        print(respose.statusCode);
      }
    } catch (e) {
      print("ไม่มีข้อมูล $e");
    }
  }

  Future<void> get_select_statusApprove() async {
    print(tokenId);
    try {
      var respose = await http.get(
        Uri.parse('https://twyapp.com/twyapi/apiV1/setup/approveStatus'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
        // body: jsonEncode(<String, String>{'page': '1', 'limit': '100'}),
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> data_statusApprove =
            new Map<String, dynamic>.from(json.decode(respose.body));
        setState(() {
          dropdown_status = data_statusApprove['data'];
        });

        print(dropdown_status);
      } else {
        print(respose.statusCode);
      }
    } catch (e) {
      print("ไม่มีข้อมูล $e");
    }
  }

  Future<void> getData_quarantee() async {
    print(tokenId);
    print(custId.text);

    list_quarantee = [];
    try {
      var respose = await http.post(
        Uri.parse('https://twyapp.com/twyapi/apiV1/credit/quarantee'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
        body: jsonEncode(<String, String>{
          'custId': custId.text,
        }),
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> dataQuarantee =
            new Map<String, dynamic>.from(json.decode(respose.body));

        setState(() {
          list_quarantee = dataQuarantee['data'];
        });

        Navigator.pop(context);
        print(list_quarantee);
      } else {
        // setState(() {
        //   valueStatus = respose.statusCode;
        // });
        Navigator.pop(context);
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

  Future<void> get_select_cus() async {
    try {
      var respose = await http.get(
        Uri.parse('https://twyapp.com/twyapi/apiV1/setup/custCondition'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> data =
            new Map<String, dynamic>.from(json.decode(respose.body));
        // print(data['data'][1]['id']);
        setState(() {
          dropdown_customer = data['data'];
        });
      } else {
        print(respose.statusCode);
      }
    } catch (e) {
      print("ไม่มีข้อมูล $e");
    }
  }

  void menu_list(page) {
    setState(() {
      active_cl1 = false;
      active_cl2 = false;
      active_cl3 = false;
    });
    switch (page) {
      case "list_content1":
        setState(() {
          page = "list_content1";
          active_cl1 = true;
        });
        break;
      case "list_content2":
        setState(() {
          page = "list_content2";
          active_cl2 = true;
        });
        break;
    }
  }

  clearValueapprove() {
    custId.clear();
    custName.clear();
    valueStatus = [];
    setState(() {
      list_signDetail = [];
      valueapprove = null;
      valueStatus = null;
    });
  }

  clearValue() {
    setState(() {
      id = '1';
      st_customer = true;
      st_employee = false;
      selectValue_customer = null;
      list_datavalue = [];
      valueNotdata = null;
      Texthint = '';
    });
    searchData.clear();
    firstname_em.clear();
    lastname_em.clear();
  }

  Future<Null> search_idcustomer() async {
    final sizeIcon = BoxConstraints(minWidth: 40, minHeight: 40);
    final border = OutlineInputBorder(
      borderSide: const BorderSide(
        color: Colors.transparent,
        width: 0,
      ),
      borderRadius: const BorderRadius.all(
        const Radius.circular(4.0),
      ),
    );

    Future<void> getData_condition(String? custType, conditionType,
        String searchData, String firstName, String lastName) async {
      // list_datavalue = [];
      try {
        var respose = await http.post(
          Uri.parse('https://twyapp.com/twyapi/apiV1/customer/list'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': tokenId.toString(),
          },
          body: jsonEncode(<String, String>{
            'custType': custType.toString(),
            'conditionType': conditionType.toString(),
            'searchData': searchData.toString(), // M011911761883
            'firstName': firstName.toString(),
            'lastName': lastName.toString(),
            'page': '1',
            'limit': '20'
          }),
        );

        if (respose.statusCode == 200) {
          Map<String, dynamic> dataList =
              new Map<String, dynamic>.from(json.decode(respose.body));

          setState(() {
            list_datavalue = dataList['data'];
          });
          Navigator.pop(context);
          Navigator.pop(context);
          search_idcustomer();
          // print(list_datavalue);
        } else {
          setState(() {
            valueNotdata = respose.statusCode;
          });
          Navigator.pop(context);
          print(respose.statusCode);
          print('ไม่พบข้อมูล');
          Map<String, dynamic> check_list =
              new Map<String, dynamic>.from(json.decode(respose.body));
          print(respose.statusCode);
          print(check_list['message']);
          if (check_list['message'] == "Token Unauthorized") {
            SharedPreferences preferences =
                await SharedPreferences.getInstance();
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

    Future<Null> getData_search() async {
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
            padding: EdgeInsets.all(5),
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    elevation: 0,
                    color: Colors.white,
                    child: Container(
                      margin: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          SizedBox(
                            height: size * 0.03,
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                left: 15, right: 15, bottom: 15),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                        clearValue();
                                      },
                                      child: Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                            color: Color.fromRGBO(
                                              173,
                                              106,
                                              3,
                                              1,
                                            ),
                                            shape: BoxShape.circle),
                                        child: Icon(
                                          Icons.close,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              color: Color.fromRGBO(251, 173, 55, 1),
                            ),
                            padding: EdgeInsets.all(8),
                            width: double.infinity,
                            child: Column(children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: RadioListTile(
                                      contentPadding: EdgeInsets.all(0.0),
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
                                              0.085,
                                          padding: EdgeInsets.all(4),
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
                                                        child: Text(
                                                          value['name'],
                                                          style: MyContant()
                                                              .TextInputStyle(),
                                                        ),
                                                        value: value['id'],
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
                                                });
                                              },
                                              value: selectValue_customer,
                                              isExpanded: true,
                                              underline: SizedBox(),
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
                                    // Text('สกุล'),
                                    input_searchCus(sizeIcon, border),
                                    //lastname
                                    // Text(selectValue_customer),
                                    if (selectValue_customer.toString() ==
                                        "2") ...[
                                      input_lastnameCus(sizeIcon, border)
                                    ],
                                  ],
                                ),
                              ],
                            ]),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  height: 30,
                                  child: TextButton(
                                    style: MyContant().myButtonSearchStyle(),
                                    onPressed: () {
                                      // getData_condition();
                                      // getData_search();
                                      if (id == '1') {
                                        print('1==>> $id');
                                        if (selectValue_customer == null ||
                                            searchData.text.isEmpty) {
                                          showProgressDialog(context,
                                              'แจ้งเตือน', 'กรุณากรอกข้อมูล');
                                        } else {
                                          getData_search();
                                        }
                                      } else {
                                        print('2==>> $id');
                                        if (firstname_em.text.isEmpty &&
                                            lastname_em.text.isEmpty) {
                                          showProgressDialog(context,
                                              'แจ้งเตือน', 'กรุณากรอกข้อมูล');
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
                          Row(
                            children: [
                              Text(
                                'รายการที่ค้นหา',
                                style: MyContant().h2Style(),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.4,
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
                                            },
                                          );
                                          Navigator.pop(context);
                                          // list_signDetail = [];
                                        },
                                        child: Container(
                                          margin:
                                              EdgeInsets.symmetric(vertical: 5),
                                          padding: EdgeInsets.all(8.0),
                                          decoration: BoxDecoration(
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
                                              SizedBox(
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
                                              SizedBox(
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
                                              SizedBox(
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
                                    ],
                                  ] else ...[
                                    if (valueNotdata == 404) ...[
                                      notData(context),
                                    ] else
                                      ...[],
                                  ],
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
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
    final sizeIcon = BoxConstraints(minWidth: 40, minHeight: 40);
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
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        behavior: HitTestBehavior.opaque,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
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
                      children: [
                        Text(
                          'รหัสลูกค้า',
                          style: MyContant().h4normalStyle(),
                        ),
                        input_idcustomer(sizeIcon, border),
                        InkWell(
                          onTap: () {
                            search_idcustomer();
                            get_select_cus();
                          },
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(
                                173,
                                106,
                                3,
                                1,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.search,
                              color: Colors.white,
                            ),
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
                          'วันที่',
                          style: MyContant().h4normalStyle(),
                        ),
                        input_dateStart(sizeIcon, border),
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    'รายการที่ค้นหา',
                    style: MyContant().h2Style(),
                  ),
                ],
              ),
            ),
            // if (valueapprove != null) ...[
            //   Padding(
            //     padding: const EdgeInsets.symmetric(horizontal: 8),
            //     child: DefaultTabController(
            //       length: 3,
            //       initialIndex: 0,
            //       child: Column(
            //         crossAxisAlignment: CrossAxisAlignment.stretch,
            //         children: <Widget>[
            //           Container(
            //             decoration: BoxDecoration(
            //                 color: Color.fromRGBO(251, 173, 55, 1),
            //                 borderRadius: BorderRadius.only(
            //                   topLeft: Radius.circular(10),
            //                   topRight: Radius.circular(10),
            //                 )),
            //             child: TabBar(
            //               labelColor: Color.fromRGBO(110, 66, 0, 1),
            //               labelStyle:
            //                   TextStyle(fontSize: 16, fontFamily: 'Prompt'),
            //               unselectedLabelColor: Colors.black,
            //               tabs: [
            //                 Tab(text: 'ข้อมูลลูกค้า'),
            //                 Tab(text: 'ที่อยู่ลูกค้า'),
            //                 Tab(text: 'อาชีพ'),
            //               ],
            //             ),
            //           ),
            //           line(),
            //           Container(
            //             height: MediaQuery.of(context).size.height * 0.2,
            //             decoration: BoxDecoration(
            //               color: Color.fromRGBO(251, 173, 55, 1),
            //               borderRadius: BorderRadius.only(
            //                 bottomLeft: Radius.circular(10),
            //                 bottomRight: Radius.circular(10),
            //               ),
            //             ),
            //             child: TabBarView(children: <Widget>[
            //               //ข้อมูลลูกค้า
            //               SingleChildScrollView(
            //                 child: Container(
            //                   padding: EdgeInsets.all(8.0),
            //                   child: Column(
            //                     children: [
            //                       Row(
            //                         children: [
            //                           Text(
            //                             'เลขบัตรประชาชน : ${valueapprove['smartId']}',
            //                             style: MyContant().h4normalStyle(),
            //                           ),
            //                         ],
            //                       ),
            //                       SizedBox(
            //                         height: 5,
            //                       ),
            //                       Row(
            //                         children: [
            //                           Text(
            //                             'ชื่อลูกค้า : ${valueapprove['custName']}',
            //                             style: MyContant().h4normalStyle(),
            //                           ),
            //                         ],
            //                       ),
            //                       SizedBox(
            //                         height: 5,
            //                       ),
            //                       Row(
            //                         children: [
            //                           Text(
            //                             'เกิดวันที่ : ${valueapprove['birthday']}',
            //                             style: MyContant().h4normalStyle(),
            //                           ),
            //                           SizedBox(
            //                             width: 15,
            //                           ),
            //                           Text(
            //                             'อายุ : ${valueapprove['age']} ปี',
            //                             style: MyContant().h4normalStyle(),
            //                           )
            //                         ],
            //                       ),
            //                       SizedBox(
            //                         height: 5,
            //                       ),
            //                       Row(
            //                         children: [
            //                           Text(
            //                             'ชื่อรอง : ${valueapprove['nickName']}',
            //                             style: MyContant().h4normalStyle(),
            //                           ),
            //                         ],
            //                       ),
            //                     ],
            //                   ),
            //                 ),
            //               ),
            //               //ที่อยู่ลูกค้า
            //               SingleChildScrollView(
            //                 child: Container(
            //                   padding: EdgeInsets.all(8.0),
            //                   child: Column(
            //                     children: [
            //                       Row(
            //                         crossAxisAlignment:
            //                             CrossAxisAlignment.start,
            //                         children: [
            //                           Text(
            //                             'ที่อยู่ : ',
            //                             style: MyContant().h4normalStyle(),
            //                           ),
            //                           Expanded(
            //                             child: Text(
            //                               '${valueapprove['address']}',
            //                               overflow: TextOverflow.clip,
            //                               style: MyContant().h4normalStyle(),
            //                             ),
            //                           ),
            //                         ],
            //                       ),
            //                       SizedBox(
            //                         height: 10,
            //                       ),
            //                       Row(
            //                         crossAxisAlignment:
            //                             CrossAxisAlignment.start,
            //                         children: [
            //                           Text(
            //                             'ที่อยู่ใช้สินค้า : ',
            //                             style: MyContant().h4normalStyle(),
            //                           ),
            //                           Expanded(
            //                             child: Text(
            //                               '${valueapprove['address']}',
            //                               overflow: TextOverflow.clip,
            //                               style: MyContant().h4normalStyle(),
            //                             ),
            //                           ),
            //                         ],
            //                       ),
            //                       SizedBox(
            //                         height: 5,
            //                       ),
            //                     ],
            //                   ),
            //                 ),
            //               ),
            //               //อาชีพ
            //               SingleChildScrollView(
            //                 child: Container(
            //                   padding: EdgeInsets.all(8.0),
            //                   child: Column(
            //                     children: [
            //                       SizedBox(
            //                         height: 5,
            //                       ),
            //                       Row(
            //                         children: [
            //                           Text(
            //                             'อาชีพ : ${valueapprove['career']}',
            //                             style: MyContant().h4normalStyle(),
            //                           ),
            //                         ],
            //                       ),
            //                       SizedBox(
            //                         height: 5,
            //                       ),
            //                       Row(
            //                         children: [
            //                           Text(
            //                             'สถานที่ทำงาน : ${valueapprove['workPlace']}',
            //                             style: MyContant().h4normalStyle(),
            //                           ),
            //                         ],
            //                       ),
            //                       SizedBox(
            //                         height: 5,
            //                       ),
            //                     ],
            //                   ),
            //                 ),
            //               ),
            //             ]),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // SizedBox(
            //   height: 10,
            // ),
            // ] else ...[
            //   if (valueStatus == 404 || valueStatus == 500) ...[
            //     notData(context),
            //   ],
            // ],
            // if (list_signDetail.isNotEmpty) ...[
            //   slidemenu(context),
            //   if (active_cl1 == true) ...[
            //     content_list1(context),
            //   ],
            //   if (active_cl2 == true) ...[
            //     content_list2(context),
            //   ],
            // ],
          ],
        ),
      ),
    );
  }

  Container content_list1(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Scrollbar(
        child: ListView(
          children: [
            if (list_signDetail.isNotEmpty) ...[
              for (var i = 0; i < list_signDetail.length; i++) ...[
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Page_Info_Consider_Cus(
                            list_signDetail[i]['signId']),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: Color.fromRGBO(251, 173, 55, 1),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'วันทำสัญญา : ${list_signDetail[i]['signDate']}',
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
                                'เลขที่สัญญา : ${list_signDetail[i]['signId']}',
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
                                'ชื่อสินค้า : ',
                                style: MyContant().h4normalStyle(),
                              ),
                              Expanded(
                                child: Text(
                                  '${list_signDetail[i]['itemName']}',
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'รหัสเขต : ${list_signDetail[i]['followAreaName']}',
                                style: MyContant().h4normalStyle(),
                              ),
                              Text(
                                'สถานะ : ${list_signDetail[i]['signStatusName']}',
                                style: MyContant().h4normalStyle(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Container content_list2(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      child: Scrollbar(
        child: ListView(
          children: [
            if (list_quarantee.isNotEmpty) ...[
              for (var i = 0; i < list_quarantee.length; i++) ...[
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            Page_Info_Consider_Cus(list_quarantee[i]['signId']),
                      ),
                    );
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: Color.fromRGBO(251, 173, 55, 1),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'เลขที่สัญญา : ${list_quarantee[i]['signId']}',
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
                                'ชื่อ-สกุล : ${list_quarantee[i]['custName']}',
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
                                'ชื่อ-สกุลในสัญญา : ${list_quarantee[i]['signCustName']}',
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
                                'ยอดคงเหลือ : ${list_quarantee[i]['remainPrice']}',
                                style: MyContant().h4normalStyle(),
                              ),
                              Text(
                                'สถานะ : ${list_quarantee[i]['personStatusName']}',
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
                                'เขตติดตาม : ${list_quarantee[i]['followName']}',
                                style: MyContant().h4normalStyle(),
                              ),
                              Text(
                                'สถานะสัญญา : ${list_quarantee[i]['signStatusName']}',
                                style: MyContant().h4normalStyle(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Container slidemenu(BuildContext context) {
    return Container(
      // color: Colors.white,
      height: MediaQuery.of(context).size.height * 0.07,
      // margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(3),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  menu_list("list_content1");
                },
                child: Container(
                  margin: EdgeInsets.all(5),
                  height: 35,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                    color: active_cl1 == true
                        ? Color.fromRGBO(202, 121, 0, 1)
                        : Color.fromRGBO(251, 173, 55, 1),
                  ),
                  child: Text(
                    'ตรวจสอบหนี้สิน',
                    style: MyContant().h4normalStyle(),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  menu_list("list_content2");
                  showProgressLoading(context);
                  getData_quarantee();
                },
                child: Container(
                  margin: EdgeInsets.all(5),
                  height: 35,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                    color: active_cl2 == true
                        ? Color.fromRGBO(202, 121, 0, 1)
                        : Color.fromRGBO(251, 173, 55, 1),
                  ),
                  child: Text(
                    'รายละเอียดผู้ค้ำ',
                    style: MyContant().h4normalStyle(),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          Page_Check_Blacklist(valueapprove['smartId']),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.all(5),
                  height: 35,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                    color: Color.fromRGBO(251, 173, 55, 1),
                    // color: active_cl3 == true
                    //     ? Color.fromRGBO(202, 121, 0, 1)
                    //     : Color.fromRGBO(251, 173, 55, 1),
                  ),
                  child: Text(
                    'เช็ค Blacklist',
                    style: MyContant().h4normalStyle(),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Padding group_btnsearch() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Container(
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: TextButton(
                        style: MyContant().myButtonSearchStyle(),
                        onPressed: () {
                          getData_approve();
                        },
                        child: const Text('ค้นหา'),
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: TextButton(
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
      ),
    );
  }

  SizedBox line() {
    return SizedBox(
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
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: custId,
          onChanged: (keyword) {},
          decoration: InputDecoration(
            counterText: "",
            contentPadding: EdgeInsets.all(4),
            isDense: true,
            enabledBorder: border,
            focusedBorder: border,
            hintStyle: TextStyle(
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
          onChanged: (keyword) {},
          decoration: InputDecoration(
            counterText: "",
            contentPadding: EdgeInsets.all(4),
            isDense: true,
            enabledBorder: border,
            focusedBorder: border,
            hintStyle: TextStyle(
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
            contentPadding: EdgeInsets.all(4),
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
            contentPadding: EdgeInsets.all(4),
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
            contentPadding: EdgeInsets.all(4),
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
            contentPadding: EdgeInsets.all(4),
            isDense: true,
            enabledBorder: border,
            focusedBorder: border,
            hintStyle: TextStyle(
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
            contentPadding: EdgeInsets.all(4),
            isDense: true,
            enabledBorder: border,
            focusedBorder: border,
            hintStyle: TextStyle(
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
            contentPadding: EdgeInsets.all(4),
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
          height: MediaQuery.of(context).size.width * 0.08,
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: Padding(
            padding: const EdgeInsets.only(left: 4),
            child: DropdownButton(
              items: dropdown_branch
                  .map((value) => DropdownMenuItem(
                        child: Text(
                          value['name'],
                          style: MyContant().TextInputStyle(),
                        ),
                        value: value['id'],
                      ))
                  .toList(),
              onChanged: (newvalue) {
                setState(() {
                  select_branchlist = newvalue;
                });
              },
              value: select_branchlist,
              isExpanded: true,
              underline: SizedBox(),
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
          height: MediaQuery.of(context).size.width * 0.08,
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: Padding(
            padding: const EdgeInsets.only(left: 4),
            child: DropdownButton(
              items: dropdown_status
                  .map((value) => DropdownMenuItem(
                        child: Text(
                          value['name'],
                          style: MyContant().TextInputStyle(),
                        ),
                        value: value['id'],
                      ))
                  .toList(),
              onChanged: (newvalue) {
                setState(() {
                  select_status = newvalue;
                });
              },
              value: select_status,
              isExpanded: true,
              underline: SizedBox(),
              hint: Align(
                child: Text(
                  'เลือกการพิจารณา',
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
            suffixIcon: Icon(
              Icons.calendar_today,
              color: Colors.black,
            ),
            contentPadding: EdgeInsets.all(4),
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
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );
            if (pickeddate != null) {
              print(
                  pickeddate); //pickedDate output format => 2021-03-10 00:00:00.000
              String formattedDate = DateFormat('yyyyMMdd').format(pickeddate);
              print(
                  formattedDate); //formatted date output using intl package =>  2021-03-16
              setState(() {
                start_date.text =
                    formattedDate; //set output date to TextField value.
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
            suffixIcon: Icon(
              Icons.calendar_today,
              color: Colors.black,
            ),
            contentPadding: EdgeInsets.all(4),
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
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );
            if (pickeddate != null) {
              print(
                  pickeddate); //pickedDate output format => 2021-03-10 00:00:00.000
              String formattedDate =
                  DateFormat('yyyy-MM-dd').format(pickeddate);
              print(
                  formattedDate); //formatted date output using intl package =>  2021-03-16
              setState(() {
                end_date.text =
                    formattedDate; //set output date to TextField value.
              });
            } else {}
          },
        ),
      ),
    );
  }
}
