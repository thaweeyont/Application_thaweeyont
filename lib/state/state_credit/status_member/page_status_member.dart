import 'dart:convert';

import 'package:application_thaweeyont/state/state_credit/status_member/member_cust_list.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../utility/my_constant.dart';
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

  bool st_customer = true, st_employee = false, statusLoad404member = false;
  String? id = '1';
  List list_datavalue = [], list_dataMember = [], dropdown_customer = [];
  List list_address = [];
  var selectValue_customer, selectvalue_saletype, Texthint, valueaddress;

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

  Future<void> getdata() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      userId = preferences.getString('userId')!;
      empId = preferences.getString('empId')!;
      firstName = preferences.getString('firstName')!;
      lastName = preferences.getString('lastName')!;
      tokenId = preferences.getString('tokenId')!;
    });
    get_select_cus();
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
        setState(() {
          dropdown_customer = data['data'];
        });
      } else if (respose.statusCode == 401) {
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

  clearValuemembar() {
    custId.clear();
    smartId.clear();
    custName.clear();
    lastnamecust.clear();
    setState(() {
      list_dataMember.clear();
    });
  }

  clearDialog() {
    setState(() {
      id = '1';
      st_customer = true;
      st_employee = false;
      selectValue_customer = null;
      list_datavalue = [];
      Texthint = '';
      statusLoad404member = false;
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
            'searchData': searchData.toString(),
            'firstName': firstName.toString(),
            'lastName': lastName.toString(),
            'page': '1',
            'limit': '100'
          }),
        );

        if (respose.statusCode == 200) {
          Map<String, dynamic> dataList =
              new Map<String, dynamic>.from(json.decode(respose.body));

          setState(() {
            list_datavalue = dataList['data'];
          });

          Navigator.pop(context);
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
            Navigator.pop(context);
            statusLoad404member = true;
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
        showProgressDialog_Notdata(
            context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
      }
    }

    Future<void> getData_search() async {
      if (id == '1') {
        showProgressLoading(context);
        if (selectValue_customer.toString() == "2") {
          getData_condition(
              id, selectValue_customer, '', searchData.text, lastname.text);
        } else {
          getData_condition(id, selectValue_customer, searchData.text, '', '');
        }
      } else {
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
            padding: const EdgeInsets.all(5),
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
                                  clearDialog();
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
                          color: Color.fromARGB(255, 138, 138, 138),
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
                        //               clearDialog();
                        //             },
                        //             child: Container(
                        //               width: 30,
                        //               height: 30,
                        //               decoration: BoxDecoration(
                        //                 color:
                        //                     Color.fromRGBO(18, 108, 108, 1),
                        //                 shape: BoxShape.circle,
                        //               ),
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
                              color: Color.fromRGBO(64, 203, 203, 1),
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
                                          statusLoad404member = false;
                                          searchData.clear();
                                        });
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
                                          statusLoad404member = false;
                                          searchData.clear();
                                        });
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
                                                  statusLoad404member = false;
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
                                      if (selectValue_customer == null ||
                                          searchData.text.isEmpty &&
                                              lastname.text.isEmpty) {
                                        showProgressDialog(context, 'แจ้งเตือน',
                                            'กรุณากรอกข้อมูล');
                                      } else {
                                        getData_search();
                                      }
                                    } else {
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
                                          },
                                        );
                                        Navigator.pop(context);
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
                                ] else if (statusLoad404member == true) ...[
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
                                ]
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
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            // padding: EdgeInsets.all(5),
                            backgroundColor:
                                const Color.fromRGBO(18, 108, 108, 1),
                          ),
                          onPressed: () {
                            search_idcustomer();
                          },
                          child: const Icon(
                            Icons.search,
                          ),
                        ),
                        // InkWell(
                        //   onTap: () {
                        //     search_idcustomer();
                        //     get_select_cus();
                        //   },
                        //   child: Container(
                        //     width: 30,
                        //     height: 30,
                        //     decoration: BoxDecoration(
                        //       color: Color.fromRGBO(18, 108, 108, 1),
                        //       shape: BoxShape.circle,
                        //     ),
                        //     child: Icon(
                        //       Icons.search,
                        //       color: Colors.white,
                        //     ),
                        //   ),
                        // ),
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
                      ],
                    ),
                    Row(
                      children: [
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
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Row(
            //     children: [
            //       Text(
            //         'รายการที่ค้นหา',
            //         style: MyContant().h2Style(),
            //       ),
            //     ],
            //   ),
            // ),
            // if (list_dataMember.isNotEmpty) ...[
            //   for (var i = 0; i < list_dataMember.length; i++) ...[
            //     Padding(
            //       padding: const EdgeInsets.all(8.0),
            //       child: Container(
            //         padding: EdgeInsets.all(8.0),
            //         decoration: BoxDecoration(
            //           color: Color.fromRGBO(64, 203, 203, 1),
            //           borderRadius: BorderRadius.all(
            //             Radius.circular(10),
            //           ),
            //         ),
            //         child: Column(
            //           children: [
            //             Row(
            //               children: [
            //                 Text(
            //                   'รหัสลูกค้า : ${list_dataMember[i]['custId']}',
            //                   style: MyContant().h4normalStyle(),
            //                 ),
            //               ],
            //             ),
            //             SizedBox(
            //               height: 5,
            //             ),
            //             Row(
            //               children: [
            //                 Text(
            //                     'ชื่อ-นามสกุล : ${list_dataMember[i]['custName']}',
            //                     style: MyContant().h4normalStyle()),
            //               ],
            //             ),
            //             SizedBox(
            //               height: 5,
            //             ),
            //             Row(
            //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //               children: [
            //                 Text(
            //                   'ชื่อเล่น : ${list_dataMember[i]['nickName']}',
            //                   style: MyContant().h4normalStyle(),
            //                 ),
            //                 Text(
            //                   'เพศ : ${list_dataMember[i]['gender']}',
            //                   style: MyContant().h4normalStyle(),
            //                 ),
            //                 Text(
            //                   'สถานภาพ : ${list_dataMember[i]['marryStatus']}',
            //                   style: MyContant().h4normalStyle(),
            //                 ),
            //               ],
            //             ),
            //             SizedBox(
            //               height: 5,
            //             ),
            //             Row(
            //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //               children: [
            //                 Text(
            //                   'ศาสนา : ${list_dataMember[i]['religionName']}',
            //                   style: MyContant().h4normalStyle(),
            //                 ),
            //                 Text(
            //                   'เชื้อชาติ : ${list_dataMember[i]['raceName']}',
            //                   style: MyContant().h4normalStyle(),
            //                 ),
            //                 Text(
            //                   'สัญชาติ : ${list_dataMember[i]['nationName']}',
            //                   style: MyContant().h4normalStyle(),
            //                 ),
            //               ],
            //             ),
            //             SizedBox(
            //               height: 5,
            //             ),
            //             Row(
            //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //               children: [
            //                 Text(
            //                   'วันเกิด : ${list_dataMember[i]['birthday']}',
            //                   style: MyContant().h4normalStyle(),
            //                 ),
            //                 Text(
            //                   'อายุ : ${list_dataMember[i]['age']} ปี',
            //                   style: MyContant().h4normalStyle(),
            //                 ),
            //               ],
            //             ),
            //             SizedBox(
            //               height: 5,
            //             ),
            //             Row(
            //               children: [
            //                 Text(
            //                   'เบอร์โทรศัพท์ : ${list_dataMember[i]['mobile']}',
            //                   style: MyContant().h4normalStyle(),
            //                 ),
            //               ],
            //             ),
            //             SizedBox(
            //               height: 5,
            //             ),
            //             Row(
            //               children: [
            //                 Text(
            //                   'บัตร : ${list_dataMember[i]['cardTypeName']}',
            //                   style: MyContant().h4normalStyle(),
            //                 ),
            //               ],
            //             ),
            //             SizedBox(
            //               height: 5,
            //             ),
            //             Row(
            //               children: [
            //                 Text(
            //                   'เลขที่ : ${list_dataMember[i]['smartId']}',
            //                   style: MyContant().h4normalStyle(),
            //                 ),
            //               ],
            //             ),
            //             SizedBox(
            //               height: 5,
            //             ),
            //             Row(
            //               children: [
            //                 Text(
            //                   'Email : ${list_dataMember[i]['email']}',
            //                   style: MyContant().h4normalStyle(),
            //                 ),
            //               ],
            //             ),
            //             SizedBox(
            //               height: 5,
            //             ),
            //             Row(
            //               children: [
            //                 Text(
            //                   'Website : ${list_dataMember[i]['website']}',
            //                   style: MyContant().h4normalStyle(),
            //                 ),
            //               ],
            //             ),
            //             SizedBox(
            //               height: 5,
            //             ),
            //             Row(
            //               children: [
            //                 Text(
            //                   'Line Id : ${list_dataMember[i]['lineId']}',
            //                   style: MyContant().h4normalStyle(),
            //                 ),
            //               ],
            //             ),
            //             SizedBox(
            //               height: 5,
            //             ),
            //             Row(
            //               children: [
            //                 Text(
            //                   'วันที่หมดอายุ : ${list_dataMember[i]['smartExpireDate']}',
            //                   style: MyContant().h4normalStyle(),
            //                 ),
            //               ],
            //             ),
            //           ],
            //         ),
            //       ),
            //     ),
            //     Padding(
            //       padding: const EdgeInsets.all(8.0),
            //       child: Container(
            //         padding: EdgeInsets.all(8.0),
            //         decoration: BoxDecoration(
            //           color: Color.fromRGBO(64, 203, 203, 1),
            //           borderRadius: BorderRadius.all(
            //             Radius.circular(10),
            //           ),
            //         ),
            //         child: Column(
            //           children: [
            //             Row(
            //               children: [
            //                 Text(
            //                   'ข้อมูลบัตรสมาขิก',
            //                   style: MyContant().TextcolorBlue(),
            //                 ),
            //               ],
            //             ),
            //             SizedBox(
            //               height: 10,
            //             ),
            //             Row(
            //               children: [
            //                 Text(
            //                   'รหัสบัตร : ${list_dataMember[i]['memberCardId']}',
            //                   style: MyContant().h4normalStyle(),
            //                 ),
            //               ],
            //             ),
            //             SizedBox(
            //               height: 5,
            //             ),
            //             Row(
            //               children: [
            //                 Text(
            //                   'สถานะบัตรสมาชิก : ${list_dataMember[i]['memberCardName']}',
            //                   style: MyContant().h4normalStyle(),
            //                 ),
            //               ],
            //             ),
            //             SizedBox(
            //               height: 5,
            //             ),
            //             Row(
            //               children: [
            //                 Text(
            //                   'ผู้ตรวจสอบ : ${list_dataMember[i]['auditName']}',
            //                   style: MyContant().h4normalStyle(),
            //                 ),
            //               ],
            //             ),
            //             SizedBox(
            //               height: 5,
            //             ),
            //             Row(
            //               children: [
            //                 Text(
            //                   'วันที่ออกบัตร : ${list_dataMember[i]['applyDate']}',
            //                   style: MyContant().h4normalStyle(),
            //                 ),
            //               ],
            //             ),
            //           ],
            //         ),
            //       ),
            //     ),
            //     Padding(
            //       padding: const EdgeInsets.all(8.0),
            //       child: Row(
            //         children: [
            //           Text(
            //             'ข้อมูลที่อยู่ ${list_address.length}',
            //             style: MyContant().h2Style(),
            //           ),
            //         ],
            //       ),
            //     ),
            //     if (list_address.isNotEmpty) ...[
            //       for (var i = 0; i < list_address.length; i++) ...[
            //         Padding(
            //           padding: const EdgeInsets.all(8.0),
            //           child: Container(
            //             padding: EdgeInsets.all(8.0),
            //             decoration: BoxDecoration(
            //               color: Color.fromRGBO(64, 203, 203, 1),
            //               borderRadius: BorderRadius.all(
            //                 Radius.circular(10),
            //               ),
            //             ),
            //             child: Column(
            //               children: [
            //                 Row(
            //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                   children: [
            //                     Text(
            //                       '${i + 1}',
            //                       style: MyContant().h4normalStyle(),
            //                     ),
            //                     Text(
            //                       'ประเภท : ${list_address[i]['type']}',
            //                       style: MyContant().h4normalStyle(),
            //                     ),
            //                   ],
            //                 ),
            //                 SizedBox(
            //                   height: 10,
            //                 ),
            //                 Row(
            //                   crossAxisAlignment: CrossAxisAlignment.start,
            //                   children: [
            //                     Text(
            //                       'ที่อยู่ : ',
            //                       style: MyContant().h4normalStyle(),
            //                     ),
            //                     Expanded(
            //                       child: Text(
            //                         '${list_address[i]['detail']}',
            //                         overflow: TextOverflow.clip,
            //                         style: MyContant().h4normalStyle(),
            //                       ),
            //                     ),
            //                   ],
            //                 ),
            //                 SizedBox(
            //                   height: 5,
            //                 ),
            //                 Row(
            //                   children: [
            //                     Text(
            //                       'เบอร์โทรศัพท์ : ${list_address[i]['tel']}',
            //                       style: MyContant().h4normalStyle(),
            //                     ),
            //                   ],
            //                 ),
            //                 SizedBox(
            //                   height: 5,
            //                 ),
            //                 Row(
            //                   children: [
            //                     Text(
            //                       'เบอร์แฟกซ์ : ${list_address[i]['fax']}',
            //                       style: MyContant().h4normalStyle(),
            //                     ),
            //                   ],
            //                 ),
            //               ],
            //             ),
            //           ),
            //         ),
            //       ],
            //     ],
            //     if (list_dataMember.length > 1) ...[
            //       lineNext(),
            //     ],
            //   ],
            // ],
            const SizedBox(
              height: 25,
            ),
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
            child: const Divider(
              thickness: 2.0,
              color: Colors.black,
              height: 36,
            )),
      ),
      const Text('คนถัดไป'),
      Expanded(
        child: new Container(
            margin: const EdgeInsets.only(left: 20.0, right: 10.0),
            child: const Divider(
              thickness: 2.0,
              color: Colors.black,
              height: 36,
            )),
      ),
    ]);
  }

  Padding line() {
    return const Padding(
      padding: EdgeInsets.all(6.0),
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
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.034,
                      width: MediaQuery.of(context).size.width * 0.22,
                      child: ElevatedButton(
                        style: MyContant().myButtonSearchStyle(),
                        onPressed: () {
                          if (custId.text.isEmpty &&
                              smartId.text.isEmpty &&
                              custName.text.isEmpty &&
                              lastnamecust.text.isEmpty) {
                            showProgressDialog(context, 'แจ้งเตือน',
                                'กรุณากรอก รหัส หรือ เลขที่บัตร หรือ ชื่อ-สกุล ลูกค้า');
                          } else {
                            // showProgressLoading(context);
                            // getData_CusMember();
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => Detail_member_cust(
                            //         custId.text,
                            //         smartId.text,
                            //         custName.text,
                            //         lastnamecust.text
                            // ),
                            //   ),
                            // );

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MemberCustList(
                                    custId.text,
                                    smartId.text,
                                    custName.text,
                                    lastnamecust.text),
                              ),
                            );
                          }
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

  Expanded input_idcustomer(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8, left: 8),
        child: TextField(
          controller: custId,
          onChanged: (keyword) {},
          decoration: InputDecoration(
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

  Expanded input_smartId(sizeIcon, border) {
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

  Expanded input_lastname(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: lastnamecust,
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
}
