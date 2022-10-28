import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../utility/my_constant.dart';
import '../../../widgets/show_image.dart';
import 'package:http/http.dart' as http;
import 'package:application_thaweeyont/api.dart';
import '../../authen.dart';

class Page_Status_Member extends StatefulWidget {
  const Page_Status_Member({Key? key}) : super(key: key);

  @override
  State<Page_Status_Member> createState() => _Page_Status_MemberState();
}

class _Page_Status_MemberState extends State<Page_Status_Member> {
  String userId = '', empId = '', firstName = '', lastName = '', tokenId = '';

  bool st_customer = true, st_employee = false;
  String? id = '1';
  List list_datavalue = [], list_dataMember = [], dropdown_customer = [];
  List list_address = [];
  var selectValue_customer,
      selectvalue_saletype,
      valueStatus,
      valueNotdata,
      Texthint,
      valueaddress;

  TextEditingController custId = TextEditingController();
  TextEditingController custName = TextEditingController();
  TextEditingController searchData = TextEditingController();
  TextEditingController firstname_em = TextEditingController();
  TextEditingController lastname_em = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController smartId = TextEditingController();
  TextEditingController lastnamecust = TextEditingController();

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
  }

  Future<void> getData_CusMember() async {
    print(tokenId);
    print(custId.text);
    try {
      var respose = await http.post(
        Uri.parse('${api}customer/member'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
        body: jsonEncode(<String, String>{
          'custId': custId.text,
          'smartId': smartId.text,
          'firstName': custName.text,
          'lastName': lastnamecust.text,
          'page': '1',
          'limit': '20',
        }),
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> dataMemberList =
            new Map<String, dynamic>.from(json.decode(respose.body));

        valueaddress = dataMemberList['data'][0];
        setState(() {
          list_dataMember = dataMemberList['data'];
          list_address = valueaddress['address'];
        });
        Navigator.pop(context);
        print(list_address);
      } else {
        setState(() {
          valueStatus = respose.statusCode;
        });
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
        Uri.parse('${api}setup/custCondition'),
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

  // Future<Null> showProgressLoading(BuildContext context) async {
  //   showDialog(
  //     context: context,
  //     barrierColor: Colors.transparent,
  //     builder: (context) => WillPopScope(
  //       child: Center(
  //         child: Container(
  //           decoration: BoxDecoration(
  //             color: Colors.grey.shade400.withOpacity(0.6),
  //             borderRadius: BorderRadius.all(
  //               Radius.circular(10),
  //             ),
  //           ),
  //           padding: EdgeInsets.all(80),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               CircularProgressIndicator(),
  //               Text(
  //                 'Loading....',
  //                 style: MyContant().h4normalStyle(),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //       onWillPop: () async {
  //         return false;
  //       },
  //     ),
  //   );
  // }

  clearValuemembar() {
    custId.clear();
    smartId.clear();
    custName.clear();
    lastnamecust.clear();
    setState(() {
      list_dataMember.clear();
      valueStatus = null;
    });
  }

  clearDialog() {
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
      list_datavalue = [];
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
      barrierDismissible: false,
      context: context,
      builder: (context) => GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
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
                                        clearDialog();
                                      },
                                      child: Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                            color:
                                                Color.fromRGBO(18, 108, 108, 1),
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
                              color: Color.fromRGBO(64, 203, 203, 1),
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
                                    if (selectValue_customer.toString() ==
                                        "2") ...[
                                      input_lastnameCus(sizeIcon, border)
                                    ],
                                  ],
                                ),
                              ],
                            ]),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  height: 30,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  child: TextButton(
                                    style: MyContant().myButtonSearchStyle(),
                                    onPressed: () {
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
                          SizedBox(
                              height: 10), //Color.fromRGBO(64, 203, 203, 1),
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
                                        },
                                        child: Container(
                                          margin:
                                              EdgeInsets.symmetric(vertical: 5),
                                          padding: EdgeInsets.all(8.0),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                            color:
                                                Color.fromRGBO(64, 203, 203, 1),
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

  Future<Null> view_card_id(sizeIcon, border) async {
    double size = MediaQuery.of(context).size.width;
    // bool btn_edit = false;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => GestureDetector(
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
                                      onTap: () => Navigator.pop(context),
                                      child: Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                            color: Colors.grey,
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
                            width: size * 0.8,
                            child: ShowImage(path: MyContant.idcard),
                          ),
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

  Future<Null> view_map_cus(sizeIcon, border) async {
    double size = MediaQuery.of(context).size.width;
    // bool btn_edit = false;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => GestureDetector(
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
                                      onTap: () => Navigator.pop(context),
                                      child: Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                            color: Colors.grey,
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
                            width: size * 0.8,
                            child: ShowImage(path: MyContant.map),
                          ),
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
                  color: Color.fromRGBO(64, 203, 203, 1),
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
                              color: Color.fromRGBO(18, 108, 108, 1),
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
                        input_smartId(sizeIcon, border),
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
                        input_lastname(sizeIcon, border),
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
            if (list_dataMember.isNotEmpty) ...[
              for (var i = 0; i < list_dataMember.length; i++) ...[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(64, 203, 203, 1),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'รหัสลูกค้า : ${list_dataMember[i]['custId']}',
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
                                'ชื่อ-นามสกุล : ${list_dataMember[i]['custName']}',
                                style: MyContant().h4normalStyle()),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'ชื่อเล่น : ${list_dataMember[i]['nickName']}',
                              style: MyContant().h4normalStyle(),
                            ),
                            Text(
                              'เพศ : ${list_dataMember[i]['gender']}',
                              style: MyContant().h4normalStyle(),
                            ),
                            Text(
                              'สถานภาพ : ${list_dataMember[i]['marryStatus']}',
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
                              'ศาสนา : ${list_dataMember[i]['religionName']}',
                              style: MyContant().h4normalStyle(),
                            ),
                            Text(
                              'เชื้อชาติ : ${list_dataMember[i]['raceName']}',
                              style: MyContant().h4normalStyle(),
                            ),
                            Text(
                              'สัญชาติ : ${list_dataMember[i]['nationName']}',
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
                              'วันเกิด : ${list_dataMember[i]['birthday']}',
                              style: MyContant().h4normalStyle(),
                            ),
                            Text(
                              'อายุ : ${list_dataMember[i]['age']} ปี',
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
                              'เบอร์โทรศัพท์ : ${list_dataMember[i]['mobile']}',
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
                              'บัตร : ${list_dataMember[i]['cardTypeName']}',
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
                              'เลขที่ : ${list_dataMember[i]['smartId']}',
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
                              'Email : ${list_dataMember[i]['email']}',
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
                              'Website : ${list_dataMember[i]['website']}',
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
                              'Line Id : ${list_dataMember[i]['lineId']}',
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
                              'วันที่หมดอายุ : ${list_dataMember[i]['smartExpireDate']}',
                              style: MyContant().h4normalStyle(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(64, 203, 203, 1),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'ข้อมูลบัตรสมาขิก',
                              style: MyContant().TextcolorBlue(),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text(
                              'รหัสบัตร : ${list_dataMember[i]['memberCardId']}',
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
                              'สถานะบัตรสมาชิก : ${list_dataMember[i]['memberCardName']}',
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
                              'ผู้ตรวจสอบ : ${list_dataMember[i]['auditName']}',
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
                              'วันที่ออกบัตร : ${list_dataMember[i]['applyDate']}',
                              style: MyContant().h4normalStyle(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        'ข้อมูลที่อยู่ ${list_address.length}',
                        style: MyContant().h2Style(),
                      ),
                    ],
                  ),
                ),
                if (list_address.isNotEmpty) ...[
                  for (var i = 0; i < list_address.length; i++) ...[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(64, 203, 203, 1),
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
                                  '${i + 1}',
                                  style: MyContant().h4normalStyle(),
                                ),
                                Text(
                                  'ประเภท : ${list_address[i]['type']}',
                                  style: MyContant().h4normalStyle(),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ที่อยู่ : ',
                                  style: MyContant().h4normalStyle(),
                                ),
                                Expanded(
                                  child: Text(
                                    '${list_address[i]['detail']}',
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
                              children: [
                                Text(
                                  'เบอร์โทรศัพท์ : ${list_address[i]['tel']}',
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
                                  'เบอร์แฟกซ์ : ${list_address[i]['fax']}',
                                  style: MyContant().h4normalStyle(),
                                ),
                              ],
                            ),
                            // SizedBox(
                            //   height: 5,
                            // ),
                            // // Row(
                            // //   children: [
                            // //     Text(
                            // //       'บัตร คุณอรทัย ไชยแสน',
                            // //       style: MyContant().h4normalStyle(),
                            // //     ),
                            // //     InkWell(
                            // //       onTap: () {
                            // //         view_card_id(sizeIcon, border);
                            // //       },
                            // //       child: Container(
                            // //         margin: EdgeInsets.only(left: 10),
                            // //         width: 20,
                            // //         height: 20,
                            // //         decoration: BoxDecoration(
                            // //           color: Color.fromRGBO(18, 108, 108, 1),
                            // //           shape: BoxShape.circle,
                            // //         ),
                            // //         child: Icon(
                            // //           Icons.search,
                            // //           size: 15,
                            // //           color: Colors.white,
                            // //         ),
                            // //       ),
                            // //     ),
                            // //   ],
                            // // ),
                            // SizedBox(
                            //   height: 5,
                            // ),
                            // Row(
                            //   children: [
                            //     Text(
                            //       'แผนที่บ้าน คุณอรทัย ไชยแสน',
                            //       style: MyContant().h4normalStyle(),
                            //     ),
                            //     InkWell(
                            //       onTap: () {
                            //         view_map_cus(sizeIcon, border);
                            //       },
                            //       child: Container(
                            //         margin: EdgeInsets.only(left: 10),
                            //         width: 20,
                            //         height: 20,
                            //         decoration: BoxDecoration(
                            //           color: Color.fromRGBO(18, 108, 108, 1),
                            //           shape: BoxShape.circle,
                            //         ),
                            //         child: Icon(
                            //           Icons.search,
                            //           size: 15,
                            //           color: Colors.white,
                            //         ),
                            //       ),
                            //     ),
                            //   ],
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Container(
                //     padding: EdgeInsets.all(8.0),
                //     decoration: BoxDecoration(
                //       color: Color.fromRGBO(64, 203, 203, 1),
                //       borderRadius: BorderRadius.all(
                //         Radius.circular(10),
                //       ),
                //     ),
                //     child: Column(
                //       children: [
                //         Row(
                //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //           children: [
                //             Text(
                //               '2',
                //               style: MyContant().h4normalStyle(),
                //             ),
                //             Text(
                //               'ประเภท : ${list_address[i]['type']}',
                //               style: MyContant().h4normalStyle(),
                //             ),
                //           ],
                //         ),
                //         SizedBox(
                //           height: 10,
                //         ),
                //         Row(
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           children: [
                //             Text(
                //               'ที่อยุ่ : ',
                //               style: MyContant().h4normalStyle(),
                //             ),
                //             Expanded(
                //               child: Text(
                //                 'ที่อยุ่ : ${list_address[i]['detail']}',
                //                 overflow: TextOverflow.clip,
                //                 style: MyContant().h4normalStyle(),
                //               ),
                //             ),
                //           ],
                //         ),
                //         SizedBox(
                //           height: 5,
                //         ),
                //         Row(
                //           children: [
                //             Text(
                //               'เบอร์โทรศัพท์ : ',
                //               style: MyContant().h4normalStyle(),
                //             ),
                //           ],
                //         ),
                //         SizedBox(
                //           height: 5,
                //         ),
                //         Row(
                //           children: [
                //             Text(
                //               'เบอร์แฟกซ์ : ',
                //               style: MyContant().h4normalStyle(),
                //             ),
                //           ],
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Container(
                //     padding: EdgeInsets.all(8.0),
                //     decoration: BoxDecoration(
                //       color: Color.fromRGBO(64, 203, 203, 1),
                //       borderRadius: BorderRadius.all(
                //         Radius.circular(10),
                //       ),
                //     ),
                //     child: Column(
                //       children: [
                //         Row(
                //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //           children: [
                //             Text(
                //               '3',
                //               style: MyContant().h4normalStyle(),
                //             ),
                //             Text(
                //               'ประเภท : ที่อยู่ที่ทำงาน',
                //               style: MyContant().h4normalStyle(),
                //             ),
                //           ],
                //         ),
                //         SizedBox(
                //           height: 10,
                //         ),
                //         Row(
                //           children: [
                //             Text(
                //               'ที่อยุ่ : ',
                //               style: MyContant().h4normalStyle(),
                //             ),
                //           ],
                //         ),
                //         SizedBox(
                //           height: 5,
                //         ),
                //         Row(
                //           children: [
                //             Text(
                //               'เบอร์โทรศัพท์ : ',
                //               style: MyContant().h4normalStyle(),
                //             ),
                //           ],
                //         ),
                //         SizedBox(
                //           height: 5,
                //         ),
                //         Row(
                //           children: [
                //             Text(
                //               'เบอร์แฟกซ์ : ',
                //               style: MyContant().h4normalStyle(),
                //             ),
                //           ],
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                if (list_dataMember.length > 1) ...[
                  lineNext(),
                ],
              ],
            ] else ...[
              if (valueStatus == 404) ...[
                notData(context),
              ] else
                ...[],
            ],
          ],
        ),
      ),
    );
  }

  Row lineNext() {
    return Row(children: <Widget>[
      Expanded(
        child: new Container(
            margin: const EdgeInsets.only(left: 10.0, right: 20.0),
            child: Divider(
              thickness: 2.0,
              color: Colors.black,
              height: 36,
            )),
      ),
      Text('คนถัดไป'),
      Expanded(
        child: new Container(
            margin: const EdgeInsets.only(left: 20.0, right: 10.0),
            child: Divider(
              thickness: 2.0,
              color: Colors.black,
              height: 36,
            )),
      ),
    ]);
  }

  Padding line() {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: SizedBox(
        height: 10,
        width: double.infinity,
        child: Divider(
          thickness: 2.0,
          color: Color.fromARGB(255, 34, 34, 34),
        ),
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
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: TextButton(
                        style: MyContant().myButtonSearchStyle(),
                        onPressed: () {
                          if (custId.text.isEmpty &&
                              smartId.text.isEmpty &&
                              custName.text.isEmpty &&
                              lastnamecust.text.isEmpty) {
                            showProgressDialog(
                                context, 'แจ้งเตือน', 'กรุณากรอกข้อมูลลูกค้า');
                          } else {
                            showProgressLoading(context);
                            getData_CusMember();
                          }
                        },
                        child: const Text('ค้นหา'),
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: TextButton(
                        style: MyContant().myButtonCancelStyle(),
                        onPressed: () {
                          clearValuemembar();
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

  Expanded input_idcustomer(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: custId,
          onChanged: (keyword) {},
          decoration: InputDecoration(
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

  Expanded input_smartId(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: smartId,
          onChanged: (keyword) {},
          decoration: InputDecoration(
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

  Expanded input_lastname(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: lastnamecust,
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
}
