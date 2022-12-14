import 'dart:convert';

import 'package:application_thaweeyont/utility/my_constant.dart';
import 'package:application_thaweeyont/widgets/show_progress.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:buddhist_datetime_dateformat/buddhist_datetime_dateformat.dart';

import '../../authen.dart';
import 'package:application_thaweeyont/api.dart';

class Page_Checkpurchase_info extends StatefulWidget {
  const Page_Checkpurchase_info({Key? key}) : super(key: key);

  @override
  State<Page_Checkpurchase_info> createState() =>
      _Page_Checkpurchase_infoState();
}

class _Page_Checkpurchase_infoState extends State<Page_Checkpurchase_info> {
  var selectedType, selectedTypeCus;
  String userId = '', empId = '', firstName = '', lastName = '', tokenId = '';

  List dropdown_customer = [];
  List dropdown_saletype = [];
  List list_datavalue = [];
  List list_dataBuyTyle = [], list_test = [];
  List totalbill = [];
  List<int> lint = [];
  var selectValue_customer;
  var selectvalue_saletype, select_index_saletype;
  var valueStatus, valueNotdata;
  var Texthint, list_sort, list;
  var list_1, total;
  int sumbill = 0;
  // ProductTypeEum? _productTypeEum;
  String? id = '1';
  bool st_customer = true, st_employee = false;
  var filter_search = false;
  TextEditingController custId = TextEditingController();
  TextEditingController custName = TextEditingController();
  TextEditingController lastname_cust = TextEditingController();
  TextEditingController searchData = TextEditingController();
  TextEditingController firstname_em = TextEditingController();
  TextEditingController lastname_em = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController smartId = TextEditingController();
  TextEditingController start_date = TextEditingController();
  TextEditingController end_date = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      id = '1';
    });
    getdata();
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
      print("????????????????????????????????? $e");
      showProgressDialog_Notdata(
          context, '???????????????????????????', '??????????????????????????????????????????! ??????????????????????????????????????????????????????????????????');
    }
  }

  Future<void> get_select_saleType() async {
    print(tokenId);
    try {
      var respose = await http.get(
        Uri.parse('${api}setup/saleType'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> dataSale =
            new Map<String, dynamic>.from(json.decode(respose.body));
        // print(data['data'][1]['id']);
        setState(() {
          dropdown_saletype = dataSale['data'];
          select_index_saletype = dropdown_saletype[0]['id'];
        });
        print(dropdown_saletype);
      } else if (respose.statusCode == 401) {
        print(respose.statusCode);
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
            context, '???????????????????????????', '??????????????? Login ?????????????????????????????????????????????');
      }
      // else {
      //   print(respose.statusCode);
      // Map<String, dynamic> check_list =
      //     new Map<String, dynamic>.from(json.decode(respose.body));
      // print(respose.statusCode);
      // print(check_list['message']);
      // if (check_list['message'] == "Token Unauthorized") {
      //   SharedPreferences preferences = await SharedPreferences.getInstance();
      //   preferences.clear();
      //   Navigator.pushAndRemoveUntil(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => Authen(),
      //     ),
      //     (Route<dynamic> route) => false,
      //   );
      // }
      // }
    } catch (e) {
      print("????????????????????????????????? $e");
      showProgressDialog_Notdata(
          context, '???????????????????????????', '??????????????????????????????????????????! ??????????????????????????????????????????????????????????????????');
    }
  }

  Future<void> getData_buyList(start_date, end_date) async {
    setState(() {
      list_dataBuyTyle = [];
    });
    try {
      var respose = await http.post(
        Uri.parse('${api}sale/custBuyList'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
        body: jsonEncode(<String, String>{
          'custId': custId.text.toString(),
          'saleTypeId': select_index_saletype.toString(),
          'smartId': smartId.text,
          'firstName': custName.text,
          'lastName': lastname_cust.text,
          'startDate': start_date,
          'endDate': end_date,
          'page': '1',
          'limit': '230'
        }),
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> dataBuylist =
            new Map<String, dynamic>.from(json.decode(respose.body));

        setState(() {
          list_dataBuyTyle = dataBuylist['data'];
        });
        Navigator.pop(context);

        // ------ sum billTotal ---------------------------------------
        totalbill = [];
        List bill = list_dataBuyTyle.map((e) => e['billTotal']).toList();
        bill.forEach((element) {
          totalbill.add(element);
        });
        setState(() {
          totalbill = totalbill;
        });
        print('bill >> ${totalbill}');
        // List<int> ints = jsonDecode("[$totalbill]");

        // print('sum >${ints}');
        //-------------------------------------------------------------
      } else if (respose.statusCode == 400) {
        print(respose.statusCode);
        showProgressDialog_400(
            context, '???????????????????????????', '${respose.statusCode} ?????????????????????????????????!');
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
            context, '???????????????????????????', '??????????????? Login ?????????????????????????????????????????????');
      } else if (respose.statusCode == 404) {
        print(respose.statusCode);
        showProgressDialog_404(
            context, '???????????????????????????', '${respose.statusCode} ?????????????????????????????????!');
      } else if (respose.statusCode == 405) {
        print(respose.statusCode);
        showProgressDialog_405(context, '???????????????????????????', '?????????????????????????????????!');
      } else if (respose.statusCode == 500) {
        print(respose.statusCode);
        showProgressDialog_500(
            context, '???????????????????????????', '${respose.statusCode} ???????????????????????????????????????!');
      } else {
        // setState(() {
        //   valueStatus = respose.statusCode;
        // });
        // Navigator.pop(context);
        print(respose.statusCode);
        showProgressDialog(context, '???????????????????????????', '??????????????????????????????????????????????????????????????????!');
        // print('?????????????????????????????????');
        // Map<String, dynamic> check_list =
        //     new Map<String, dynamic>.from(json.decode(respose.body));
        // print(respose.statusCode);
        // print(check_list['message']);
        // if (check_list['message'] == "Token Unauthorized") {
        //   SharedPreferences preferences = await SharedPreferences.getInstance();
        //   preferences.clear();
        //   Navigator.pushAndRemoveUntil(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => Authen(),
        //     ),
        //     (Route<dynamic> route) => false,
        //   );
        // }
      }
    } catch (e) {
      print("????????????????????????????????? $e");
      showProgressDialog(
          context, '???????????????????????????', '??????????????????????????????????????????! ????????????????????????????????????????????????????????????');
    }
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
    get_select_saleType();
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
    lastname.clear();
  }

  clearValueBuylist() {
    custId.clear();
    smartId.clear();
    custName.clear();
    lastname_cust.clear();
    start_date.clear();
    end_date.clear();
    setState(() {
      // selectvalue_saletype = null;
      list_dataBuyTyle.clear();
    });
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
          print(respose.statusCode);
        } else if (respose.statusCode == 400) {
          print(respose.statusCode);
          showProgressDialog_400(
              context, '???????????????????????????', 'Error ${respose.statusCode} ?????????????????????????????????!');
        } else if (respose.statusCode == 401) {
          print(respose.statusCode);
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
              context, '???????????????????????????', '??????????????? Login ?????????????????????????????????????????????');
        } else if (respose.statusCode == 404) {
          print(respose.statusCode);
          showProgressDialog_404(
              context, '???????????????????????????', 'Error ${respose.statusCode} ?????????????????????????????????!');
        } else if (respose.statusCode == 405) {
          print(respose.statusCode);
          showProgressDialog_405(context, '???????????????????????????', '?????????????????????????????????!');
        } else if (respose.statusCode == 500) {
          print(respose.statusCode);
          showProgressDialog_500(context, '???????????????????????????',
              'Error ${respose.statusCode} ???????????????????????????????????????!');
        } else {
          showProgressDialog(context, '???????????????????????????', '??????????????????????????????????????????????????????????????????!');
        }
        // else {
        //   setState(() {
        //     valueNotdata = respose.statusCode;
        //   });
        //   Navigator.pop(context);
        //   print(respose.statusCode);
        //   // print('?????????????????????????????????');
        //   // Map<String, dynamic> check_list =
        //   //     new Map<String, dynamic>.from(json.decode(respose.body));
        //   // print(respose.statusCode);
        //   // print(check_list['message']);
        //   // if (check_list['message'] == "Token Unauthorized") {
        //   //   SharedPreferences preferences =
        //   //       await SharedPreferences.getInstance();
        //   //   preferences.clear();
        //   //   Navigator.pushAndRemoveUntil(
        //   //     context,
        //   //     MaterialPageRoute(
        //   //       builder: (context) => Authen(),
        //   //     ),
        //   //     (Route<dynamic> route) => false,
        //   //   );
        //   // }
        // }
      } catch (e) {
        print("????????????????????????????????? $e");
        showProgressDialog_Notdata(
            context, '???????????????????????????', '??????????????????????????????????????????! ????????????????????????????????????????????????????????????');
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
                                            color:
                                                Color.fromRGBO(202, 71, 150, 1),
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
                              color: Color.fromRGBO(229, 188, 244, 1),
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
                                        '????????????????????????????????????',
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
                                        '?????????????????????',
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
                                      '????????????',
                                      style: MyContant().h4normalStyle(),
                                    ),
                                    input_nameEmploDia(sizeIcon, border),
                                    Text(
                                      '????????????',
                                      style: MyContant().h4normalStyle(),
                                    ),
                                    input_lastNameEmploDia(sizeIcon, border),
                                  ],
                                ),
                              ],
                              if (st_customer == true) ...[
                                Row(
                                  children: [
                                    // Text('????????????'),
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
                                                    Texthint = '????????????';
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
                                                  '????????????????????????????????????????????????',
                                                  style: MyContant()
                                                      .TextInputSelect(),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Text('????????????'),
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
                                      if (id == '1') {
                                        print('1==>> $id');
                                        if (selectValue_customer == null ||
                                            searchData.text.isEmpty) {
                                          showProgressDialog(context,
                                              '???????????????????????????', '?????????????????????????????????????????????');
                                        } else {
                                          getData_search();
                                        }
                                      } else {
                                        print('2==>> $id');
                                        if (firstname_em.text.isEmpty &&
                                            lastname_em.text.isEmpty) {
                                          showProgressDialog(context,
                                              '???????????????????????????', '?????????????????????????????????????????????');
                                        } else {
                                          getData_search();
                                        }
                                      }
                                    },
                                    child: const Text('???????????????'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                '??????????????????????????????????????????',
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
                                        },
                                        child: Container(
                                          margin:
                                              EdgeInsets.symmetric(vertical: 5),
                                          padding: EdgeInsets.all(8.0),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                            color: Color.fromRGBO(
                                                229, 188, 244, 1),
                                          ),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    '???????????? : ${list_datavalue[i]['custId']}',
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
                                                    '???????????? : ${list_datavalue[i]['custName']}',
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
                                                    '????????????????????? : ',
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
                                                    '????????? : ${list_datavalue[i]['telephone']}',
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
                                      Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.4,
                                        // color: Colors.blue,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  '?????????????????????????????????',
                                                  style: MyContant()
                                                      .h4normalStyle(),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(229, 188, 244, 1),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            '??????????????????????????????',
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
                                color: Color.fromRGBO(202, 71, 150, 1),
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
                            '??????????????????????????????',
                            style: MyContant().h4normalStyle(),
                          ),
                          input_idcard(sizeIcon, border),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            '????????????',
                            style: MyContant().h4normalStyle(),
                          ),
                          input_namecustomer(sizeIcon, border),
                          Text(
                            '?????????????????????',
                            style: MyContant().h4normalStyle(),
                          ),
                          input_lastnamecustomer(sizeIcon, border),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            '??????????????????',
                            style: MyContant().h4normalStyle(),
                          ),
                          input_dateStart(sizeIcon, border),
                          Text(
                            '???????????????????????????',
                            style: MyContant().h4normalStyle(),
                          ),
                          input_dateEnd(sizeIcon, border),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            '????????????????????????????????????',
                            style: MyContant().h4normalStyle(),
                          ),
                          select_sale_type(sizeIcon, border),
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
                      '??????????????????????????????????????????',
                      style: MyContant().h2Style(),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              if (list_dataBuyTyle.isNotEmpty) ...[
                Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: Scrollbar(
                    child: ListView(
                      children: [
                        for (var i = 0; i < list_dataBuyTyle.length; i++) ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 5),
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
                                        '??????????????? : ${i + 1}',
                                        style: MyContant().h4normalStyle(),
                                      ),
                                      Text(
                                        '??????????????????????????? : ${list_dataBuyTyle[i]['saleDate']}',
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
                                        '???????????????????????????????????? : ${list_dataBuyTyle[i]['saleTranId']}',
                                        style: MyContant().h4normalStyle(),
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
                                        '?????????????????????????????? : ',
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '???????????????????????????????????? : ',
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
                                        '???????????? : ${list_dataBuyTyle[i]['billTotal']}',
                                        style: MyContant().h4normalStyle(),
                                      ),
                                      Text(
                                        '???????????????????????????????????? : ${list_dataBuyTyle[i]['saleTypeName']}',
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
                                        '?????????????????????????????? : ${list_dataBuyTyle[i]['saleName']}',
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
                SizedBox(
                  height: 25,
                ),
              ],
            ],
          ),
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
                      child: TextButton(
                        style: MyContant().myButtonSearchStyle(),
                        onPressed: () {
                          print(selectvalue_saletype);
                          if (custId.text.isEmpty &&
                              smartId.text.isEmpty &&
                              custName.text.isEmpty &&
                              lastname_cust.text.isEmpty) {
                            showProgressDialog(context, '???????????????????????????',
                                '??????????????????????????? ???????????? ???????????? ?????????????????????????????? ???????????? ????????????-???????????? ??????????????????');
                          } else {
                            var newStratDate =
                                start_date.text.replaceAll('-', '');
                            var newEndDate = end_date.text.replaceAll('-', '');
                            print('s==>> $newStratDate');
                            print('e==>> $newEndDate');
                            showProgressLoading(context);
                            getData_buyList(newStratDate, newEndDate);
                          }
                        },
                        child: const Text('???????????????'),
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      height: 30,
                      child: TextButton(
                        style: MyContant().myButtonCancelStyle(),
                        onPressed: () {
                          clearValueBuylist();
                        },
                        child: const Text('??????????????????'),
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

  Expanded input_idcustomer(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          textAlignVertical: TextAlignVertical.center,
          controller: custId,
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

  Expanded select_sale_type(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Container(
          height: MediaQuery.of(context).size.width * 0.085,
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 4),
            child: DropdownButton(
              items: dropdown_saletype
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
                  select_index_saletype = newvalue;
                });
              },
              value: select_index_saletype,
              isExpanded: true,
              underline: SizedBox(),
              hint: Align(
                child: Text(
                  '????????????????????????????????????????????????',
                  style: MyContant().TextInputSelect(),
                ),
              ),
            ),
          ),
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
            hintText: '?????????????????????',
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

  // Expanded select_searchCus(sizeIcon, border) {
  //   return Expanded(
  //     child: Padding(
  //       padding: const EdgeInsets.all(1),
  //       child: Container(
  //         height: MediaQuery.of(context).size.width * 0.07,
  //         padding: EdgeInsets.all(4),
  //         decoration: BoxDecoration(
  //             color: Colors.white, borderRadius: BorderRadius.circular(5)),
  //         child: DropdownButton(
  //           items: dropdown_customer
  //               .map((value) => DropdownMenuItem(
  //                     child: Text(value['name'],
  //                         style: TextStyle(fontSize: 14, color: Colors.black)),
  //                     value: value['id'],
  //                   ))
  //               .toList(),
  //           onChanged: (newvalue) {
  //             print(newvalue);
  //             setState(() {
  //               selectValue_customer = newvalue;
  //             });
  //           },
  //           value: selectValue_customer,
  //           isExpanded: true,
  //           underline: SizedBox(),
  //           hint: Align(
  //             child: Text(
  //               '????????????????????????????????????????????????',
  //               style: TextStyle(
  //                   fontSize: 14, color: Color.fromRGBO(106, 106, 106, 1)),
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

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

  Expanded input_idcard(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: smartId,
          keyboardType: TextInputType.number,
          maxLength: 13,
          onChanged: (keyword) {},
          decoration: InputDecoration(
            counterText: "",
            contentPadding: EdgeInsets.all(4),
            isDense: true,
            enabledBorder: border,
            focusedBorder: border,
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
              var formattedDate = DateFormat('-MM-dd').format(pickeddate);
              var newDate = pickeddate.yearInBuddhistCalendar;
              print('===>> $newDate');
              print(formattedDate);
              setState(() {
                start_date.text = '${newDate}' +
                    formattedDate; //set output date to TextField value.
                print(start_date.text);
              });
              // print('<=>>> ${start_date.text.replaceAll(RegExp("-"), "")}');
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
              var formattedDate = DateFormat('-MM-dd').format(pickeddate);
              var newDate = pickeddate.yearInBuddhistCalendar;
              print('===>> $newDate');
              // print('${newDate}${formattedDate}');
              setState(() {
                end_date.text = '${newDate}' +
                    formattedDate; //set output date to TextField value.
                print(end_date.text);
              });
            } else {}
          },
        ),
      ),
    );
  }
}

// class load_data extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 30,
//       color: Colors.blue,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             '???????????????????????????',
//             style: MyContant().TextInputStyle(),
//           ),
//         ],
//       ),
//     );
//   }
// }
