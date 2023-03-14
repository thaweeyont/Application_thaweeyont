import 'dart:convert';

import 'package:application_thaweeyont/api.dart';
import 'package:application_thaweeyont/state/authen.dart';
import 'package:application_thaweeyont/state/state_credit/check_blacklist/blacklist_cust_list.dart';
import 'package:application_thaweeyont/state/state_credit/check_blacklist/blacklist_detail_data.dart';
import 'package:application_thaweeyont/utility/my_constant.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Check_Blacklist_Data extends StatefulWidget {
  const Check_Blacklist_Data({Key? key}) : super(key: key);

  @override
  State<Check_Blacklist_Data> createState() => _Check_Blacklist_DataState();
}

class _Check_Blacklist_DataState extends State<Check_Blacklist_Data> {
  String userId = '',
      empId = '',
      firstName = '',
      lastName = '',
      tokenId = '',
      text_province = '',
      text_amphoe = '';
  var selectValue_bl, selectValue_province, selectValue_amphoe, districtId;
  List dropdown_search_bl = [],
      list_dataSearch_bl = [],
      dropdown_province = [],
      list_district = [],
      dropdown_amphoe = [],
      list_data_blacklist = [];

  TextEditingController idblacklist = TextEditingController();
  TextEditingController name_show = TextEditingController();
  TextEditingController smartId = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController home_no = TextEditingController();
  TextEditingController moo_no = TextEditingController();
  TextEditingController district = TextEditingController();
  TextEditingController amphoe = TextEditingController();
  TextEditingController province = TextEditingController();
  TextEditingController searchData = TextEditingController();
  TextEditingController nameSearchBl = TextEditingController();
  TextEditingController lastnameSearchBl = TextEditingController();

  @override
  void initState() {
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
    get_select_bl_search();
    get_select_province();
  }

  // Future<void> getData_blacklist() async {
  //   list_data_blacklist = [];
  //   var tumbol, amphur, province;

  //   if (districtId == null) {
  //     tumbol = '';
  //     amphur = '';
  //     province = '';
  //   } else {
  //     tumbol = districtId;
  //     amphur = selectValue_amphoe.toString().split("_")[0];
  //     province = selectValue_province.toString().split("_")[0];
  //   }

  //   try {
  //     var respose = await http.post(
  //       Uri.parse('${beta_api_test}credit/checkBlacklist'),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json',
  //         'Authorization': tokenId.toString(),
  //       },
  //       body: jsonEncode(<String, String>{
  //         'blId': idblacklist.text,
  //         'smartId': smartId.text,
  //         'firstName': name.text,
  //         'lastName': lastname.text,
  //         'homeNo': home_no.text,
  //         'moo': moo_no.text,
  //         'tumbolId': tumbol.toString(),
  //         'amphurId': amphur.toString(),
  //         'provId': province.toString(),
  //       }),
  //     );
  //     print('ตอจ >$districtId>> $tumbol,$amphur,$province');

  //     if (respose.statusCode == 200) {
  //       Map<String, dynamic> data_blacklist =
  //           new Map<String, dynamic>.from(json.decode(respose.body));

  //       setState(() {
  //         list_data_blacklist = data_blacklist['data'];
  //       });

  //       Navigator.pop(context);
  //       // Navigator.pop(context);
  //       print('ข้อมูล => $list_data_blacklist');
  //     } else if (respose.statusCode == 400) {
  //       print(respose.statusCode);
  //       showProgressDialog_400(
  //           context, 'แจ้งเตือน', 'Error ${respose.statusCode} ไม่พบข้อมูล!');
  //     } else if (respose.statusCode == 401) {
  //       print(respose.statusCode);
  //       SharedPreferences preferences = await SharedPreferences.getInstance();
  //       preferences.clear();
  //       Navigator.pushAndRemoveUntil(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => Authen(),
  //         ),
  //         (Route<dynamic> route) => false,
  //       );
  //       showProgressDialog_401(
  //           context, 'แจ้งเตือน', 'กรุณา Login เข้าสู่ระบบใหม่');
  //     } else if (respose.statusCode == 404) {
  //       print(respose.statusCode);
  //       showProgressDialog_404(
  //           context, 'แจ้งเตือน', '${respose.statusCode} ไม่พบข้อมูล!');
  //     } else if (respose.statusCode == 405) {
  //       print(respose.statusCode);
  //       showProgressDialog_405(context, 'แจ้งเตือน', 'ไม่พบข้อมูล!');
  //     } else if (respose.statusCode == 500) {
  //       print(respose.statusCode);
  //       showProgressDialog_500(
  //           context, 'แจ้งเตือน', '${respose.statusCode} ข้อมูลผิดพลาด!');
  //     } else {
  //       showProgressDialog(context, 'แจ้งเตือน', 'กรุณาติดต่อผู้ดูแลระบบ!');
  //     }
  //   } catch (e) {
  //     print("ไม่มีข้อมูล $e");
  //     showProgressDialog_Notdata(
  //         context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
  //   }
  // }

  Future<void> get_select_bl_search() async {
    try {
      var respose = await http.get(
        Uri.parse('${beta_api_test}setup/blSearchList'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> data =
            new Map<String, dynamic>.from(json.decode(respose.body));
        setState(() {
          dropdown_search_bl = data['data'];
          selectValue_bl = dropdown_search_bl[0]['id'];
        });
        print('ข้อมูล => $dropdown_search_bl');
      } else {
        print(respose.statusCode);
      }
    } catch (e) {
      print("ไม่มีข้อมูล $e");
      showProgressDialog(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
  }

  Future<void> get_select_province() async {
    try {
      var respose = await http.get(
        Uri.parse('${beta_api_test}setup/provinceList?page=1&limit=100'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> data_provice =
            new Map<String, dynamic>.from(json.decode(respose.body));
        setState(() {
          dropdown_province = data_provice['data'];
        });

        // print(dropdown_province);
      } else if (respose.statusCode == 400) {
        print(respose.statusCode);
        showProgressDialog_400(
            context, 'แจ้งเตือน', '${respose.statusCode} ไม่พบข้อมูล!');
      } else if (respose.statusCode == 401) {
        print('error =>> ${respose.statusCode}');
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
            context, 'แจ้งเตือน', 'กรุณา Login เข้าสู่ระบบใหม่');
      } else if (respose.statusCode == 404) {
        print(respose.statusCode);
        showProgressDialog_404(
            context, 'แจ้งเตือน', '${respose.statusCode} ไม่พบข้อมูล!');
      } else if (respose.statusCode == 405) {
        print(respose.statusCode);
        showProgressDialog_405(context, 'แจ้งเตือน', 'ไม่พบข้อมูล!');
      } else if (respose.statusCode == 500) {
        print(respose.statusCode);
        showProgressDialog_500(
            context, 'แจ้งเตือน', '${respose.statusCode} ข้อมูลผิดพลาด!');
      } else {
        print(respose.statusCode);
        showProgressDialog(context, 'แจ้งเตือน', 'กรุณาติดต่อผู้ดูแลระบบ!');
      }
    } catch (e) {
      print("ไม่มีข้อมูล $e");
      showProgressDialog_Notdata(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด กรุณาแจ้งผู้ดูแลระบบ');
    }
  }

  Future<void> get_select_district() async {
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
    try {
      var respose = await http.get(
        Uri.parse(
            '${beta_api_test}setup/districtList?pId=${selectValue_province.toString().split("_")[0]}&aId=${selectValue_amphoe.toString().split("_")[0]}'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> data_district =
            new Map<String, dynamic>.from(json.decode(respose.body));
        setState(() {
          list_district = data_district['data'];
        });
        Navigator.pop(context);
        Navigator.pop(context);
        search_district(sizeIcon, border);
        // print(data_district['data']);
      } else if (respose.statusCode == 400) {
        print(respose.statusCode);
        showProgressDialog_400(
            context, 'แจ้งเตือน', '${respose.statusCode} ไม่พบข้อมูล!');
      } else if (respose.statusCode == 401) {
        print('select_district >>${respose.statusCode}');
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
            context, 'แจ้งเตือน', 'กรุณา Login เข้าสู่ระบบใหม่');
      } else if (respose.statusCode == 404) {
        print(respose.statusCode);
        showProgressDialog_404(
            context, 'แจ้งเตือน', '${respose.statusCode} ไม่พบข้อมูล!');
      } else if (respose.statusCode == 405) {
        print(respose.statusCode);
        showProgressDialog_405(context, 'แจ้งเตือน', 'ไม่พบข้อมูล!');
      } else if (respose.statusCode == 500) {
        print(respose.statusCode);
        showProgressDialog_500(
            context, 'แจ้งเตือน', '${respose.statusCode} ข้อมูลผิดพลาด!');
      } else {
        // Navigator.pop(context);
        print(respose.statusCode);
        showProgressDialog(context, 'แจ้งเตือน', 'กรุณาติดต่อผู้ดูแลระบบ!');
      }
    } catch (e) {
      // Navigator.pop(context);
      print("ไม่มีข้อมูล $e");
      showProgressDialog_Notdata(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
  }

  clear_data_blacklist() {
    idblacklist.clear();
    name_show.clear();
    smartId.clear();
    name.clear();
    lastname.clear();
    home_no.clear();
    moo_no.clear();
    district.clear();
    amphoe.clear();
    province.clear();
    setState(() {
      list_data_blacklist = [];
      districtId = null;
    });
  }

  clear_value_search() {
    searchData.clear();
    nameSearchBl.clear();
    lastnameSearchBl.clear();
  }

  clearValue_search_district() {
    setState(() {
      selectValue_province = null;
      selectValue_amphoe = null;
      list_district = [];
    });
  }

  Future<Null> search_id_blacklist() async {
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

    Future<void> getData_search_bl(searchType, String? searchData,
        String? firstName, String? lastName) async {
      list_dataSearch_bl = [];
      try {
        var respose = await http.post(
          Uri.parse('${beta_api_test}credit/blacklist'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': tokenId.toString(),
          },
          body: jsonEncode(<String, String>{
            'searchType': searchType.toString(),
            'searchData': searchData.toString(),
            'firstName': firstName.toString(),
            'lastName': lastName.toString(),
            'page': '1',
            'limit': '30'
          }),
        );

        if (respose.statusCode == 200) {
          Map<String, dynamic> data_list =
              new Map<String, dynamic>.from(json.decode(respose.body));

          setState(() {
            list_dataSearch_bl = data_list['data'];
          });

          Navigator.pop(context);
          Navigator.pop(context);
          search_id_blacklist();
          print('ข้อมูล => $list_dataSearch_bl');
        } else if (respose.statusCode == 400) {
          print(respose.statusCode);
          showProgressDialog_400(
              context, 'แจ้งเตือน', 'Error ${respose.statusCode} ไม่พบข้อมูล!');
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
              context, 'แจ้งเตือน', 'กรุณา Login เข้าสู่ระบบใหม่');
        } else if (respose.statusCode == 404) {
          print(respose.statusCode);
          showProgressDialog_404(
              context, 'แจ้งเตือน', '${respose.statusCode} ไม่พบข้อมูล!');
        } else if (respose.statusCode == 405) {
          print(respose.statusCode);
          showProgressDialog_405(context, 'แจ้งเตือน', 'ไม่พบข้อมูล!');
        } else if (respose.statusCode == 500) {
          print(respose.statusCode);
          showProgressDialog_500(
              context, 'แจ้งเตือน', '${respose.statusCode} ข้อมูลผิดพลาด!');
        } else {
          showProgressDialog(context, 'แจ้งเตือน', 'กรุณาติดต่อผู้ดูแลระบบ!');
        }
      } catch (e) {
        print("ไม่มีข้อมูล $e");
        showProgressDialog_Notdata(
            context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
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
                      borderRadius: BorderRadius.all(Radius.circular(20)),
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
                                        clear_value_search();
                                      },
                                      child: Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          color:
                                              Color.fromRGBO(82, 119, 255, 1),
                                          shape: BoxShape.circle,
                                        ),
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
                              color: Color.fromRGBO(162, 181, 252, 1),
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                            padding: EdgeInsets.all(8),
                            width: double.infinity,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.095,
                                          padding: EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 4),
                                            child: DropdownButton(
                                              items: dropdown_search_bl
                                                  .map(
                                                    (value) => DropdownMenuItem(
                                                      child: Text(
                                                        value['name'],
                                                        style: MyContant()
                                                            .TextInputStyle(),
                                                      ),
                                                      value: value['id'],
                                                    ),
                                                  )
                                                  .toList(),
                                              onChanged: (newvalue) {
                                                setState(() {
                                                  selectValue_bl = newvalue;
                                                  searchData.clear();
                                                  nameSearchBl.clear();
                                                  lastnameSearchBl.clear();
                                                  list_dataSearch_bl = [];
                                                });
                                              },
                                              value: selectValue_bl,
                                              isExpanded: true,
                                              underline: SizedBox(),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    if (selectValue_bl.toString() == "2") ...[
                                      input_name_search_bl(sizeIcon, border),
                                      SizedBox(width: 10),
                                      input_lastname_search_bl(sizeIcon, border)
                                    ] else ...[
                                      input_search_data(sizeIcon, border),
                                    ]
                                  ],
                                ),
                              ],
                            ),
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
                                      if (selectValue_bl.toString() == "2") {
                                        if (nameSearchBl.text.isEmpty &&
                                            lastnameSearchBl.text.isEmpty) {
                                          showProgressDialog(
                                              context,
                                              'แจ้งเตือน',
                                              'กรุณากรอก ชื่อ-นามสกุล');
                                        } else {
                                          showProgressLoading(context);
                                          getData_search_bl(
                                              selectValue_bl,
                                              '',
                                              nameSearchBl.text,
                                              lastnameSearchBl.text);
                                        }
                                        print(
                                            'data >$selectValue_bl,${nameSearchBl.text},${lastnameSearchBl.text}');
                                      } else {
                                        if (searchData.text.isEmpty) {
                                          showProgressDialog(
                                              context,
                                              'แจ้งเตือน',
                                              'กรุณากรอกข้อมูลที่ต้องการค้นหา');
                                        } else {
                                          showProgressLoading(context);
                                          getData_search_bl(selectValue_bl,
                                              searchData.text, '', '');
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
                            height: MediaQuery.of(context).size.height * 0.45,
                            child: Scrollbar(
                              child: ListView(
                                children: [
                                  if (list_dataSearch_bl.isNotEmpty) ...[
                                    for (var i = 0;
                                        i < list_dataSearch_bl.length;
                                        i++) ...[
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            idblacklist.text =
                                                list_dataSearch_bl[i]['blId'];
                                            name_show.text =
                                                list_dataSearch_bl[i]
                                                    ['custName'];
                                          });
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          margin:
                                              EdgeInsets.symmetric(vertical: 5),
                                          padding: EdgeInsets.all(8.0),
                                          decoration: BoxDecoration(
                                            color: Color.fromRGBO(
                                                162, 181, 252, 1),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(5),
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    'รหัส : ${list_dataSearch_bl[i]['blId']}',
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
                                                    'ชื่อ-สกุล : ${list_dataSearch_bl[i]['custName']}',
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
                                                    'เลขบัตรประชนชน : ${list_dataSearch_bl[i]['smartId']}',
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
                                                    'สถานะ : ${list_dataSearch_bl[i]['blStatus']}',
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
                                                    'เบอร์โทรศัพท์ : ',
                                                    style: MyContant()
                                                        .h4normalStyle(),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      '${list_dataSearch_bl[i]['telephone']}',
                                                      style: MyContant()
                                                          .h4normalStyle(),
                                                      overflow:
                                                          TextOverflow.clip,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ],
                              ),
                            ),
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

  Future<Null> search_district(sizeIcon, border) async {
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
                                        clearValue_search_district();
                                      },
                                      child: Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                            color:
                                                Color.fromRGBO(82, 119, 255, 1),
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
                                  BorderRadius.all(Radius.circular(10)),
                              color: Color.fromRGBO(162, 181, 252, 1),
                            ),
                            padding: EdgeInsets.all(8),
                            width: double.infinity,
                            child: Column(children: [
                              Row(
                                children: [
                                  Text(
                                    'จังหวัด',
                                    style: MyContant().h4normalStyle(),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.08,
                                        padding: EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 4),
                                          child: DropdownButton(
                                            items: dropdown_province
                                                .map(
                                                    (value) => DropdownMenuItem(
                                                          child: Text(
                                                            value['name'],
                                                            style: MyContant()
                                                                .TextInputStyle(),
                                                          ),
                                                          value:
                                                              "${value['id']}_${value['name']}",
                                                        ))
                                                .toList(),
                                            onChanged: (newvalue) async {
                                              list_district = [];
                                              setState(() {
                                                var dfvalue = newvalue;
                                                selectValue_province = dfvalue;
                                                text_province = dfvalue
                                                    .toString()
                                                    .split("_")[1];

                                                selectValue_amphoe = null;
                                              });

                                              try {
                                                var respose = await http.get(
                                                  Uri.parse(
                                                      '${beta_api_test}setup/amphurList?pId=${selectValue_province.toString().split("_")[0]}'),
                                                  headers: <String, String>{
                                                    'Content-Type':
                                                        'application/json',
                                                    'Authorization':
                                                        tokenId.toString(),
                                                  },
                                                );

                                                if (respose.statusCode == 200) {
                                                  Map<String, dynamic>
                                                      data_amphoe = new Map<
                                                              String,
                                                              dynamic>.from(
                                                          json.decode(
                                                              respose.body));
                                                  setState(() {
                                                    dropdown_amphoe =
                                                        data_amphoe['data'];
                                                  });
                                                  print(
                                                      'อำเภอ =>${dropdown_amphoe}');
                                                } else if (respose.statusCode ==
                                                    401) {
                                                  SharedPreferences
                                                      preferences =
                                                      await SharedPreferences
                                                          .getInstance();
                                                  preferences.clear();
                                                  Navigator.pushAndRemoveUntil(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          Authen(),
                                                    ),
                                                    (Route<dynamic> route) =>
                                                        false,
                                                  );
                                                  showProgressDialog_401(
                                                      context,
                                                      'แจ้งเตือน',
                                                      'กรุณา Login เข้าสู่ระบบใหม่');
                                                } else {
                                                  print(respose.statusCode);
                                                }
                                              } catch (e) {
                                                print("ไม่มีข้อมูล $e");
                                                showProgressDialog_Notdata(
                                                    context,
                                                    'แจ้งเตือน',
                                                    'เกิดข้อผิดพลาด! กรุณาแจ้งผูดูแลระบบ');
                                              }
                                              // print(selectValue_province);
                                            },
                                            value: selectValue_province,
                                            isExpanded: true,
                                            underline: SizedBox(),
                                            hint: Align(
                                              child: Text(
                                                'เลือกจังหวัด',
                                                style: MyContant()
                                                    .TextInputSelect(),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    '​อำเภอ',
                                    style: MyContant().h4normalStyle(),
                                  ),
                                  // select_amphoeDia(context, setState),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.08,
                                        padding: EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 4),
                                          child: DropdownButton(
                                            items: dropdown_amphoe
                                                .map(
                                                    (value) => DropdownMenuItem(
                                                          child: Text(
                                                            value['name'],
                                                            style: MyContant()
                                                                .TextInputStyle(),
                                                          ),
                                                          value:
                                                              "${value['id']}_${value['name']}",
                                                        ))
                                                .toList(),
                                            onChanged: (newvalue) {
                                              setState(() {
                                                var dfvalue = newvalue;
                                                selectValue_amphoe = dfvalue;
                                                text_amphoe = dfvalue
                                                    .toString()
                                                    .split("_")[1];
                                              });
                                              list_district = [];
                                            },
                                            value: selectValue_amphoe,
                                            isExpanded: true,
                                            underline: SizedBox(),
                                            hint: Align(
                                              child: Text(
                                                'เลือกอำเภอ',
                                                style: MyContant()
                                                    .TextInputSelect(),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ]),
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
                                      if (selectValue_province == null) {
                                        showProgressDialog(context, 'แจ้งเตือน',
                                            'กรุณาเลือกจังหวัด');
                                      } else if (selectValue_amphoe == null) {
                                        showProgressDialog(context, 'แจ้งเตือน',
                                            'กรุณาเลือกอำเภอ');
                                      } else {
                                        showProgressLoading(context);
                                        get_select_district();
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
                                  if (list_district.isNotEmpty) ...[
                                    for (var i = 0;
                                        i < list_district.length;
                                        i++) ...[
                                      InkWell(
                                        onTap: () {
                                          setState(
                                            () {
                                              district.text =
                                                  '${list_district[i]['name']}';
                                              amphoe.text = '$text_amphoe';
                                              province.text = '$text_province';
                                              districtId =
                                                  '${list_district[i]['id']}';
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
                                                162, 181, 252, 1),
                                          ),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    'จังหวัด : ',
                                                    style: MyContant()
                                                        .h4normalStyle(),
                                                  ),
                                                  Text(
                                                    "$text_province",
                                                    style: MyContant()
                                                        .h4normalStyle(),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    'อำเภอ : ',
                                                    style: MyContant()
                                                        .h4normalStyle(),
                                                  ),
                                                  Text(
                                                    '$text_amphoe',
                                                    style: MyContant()
                                                        .h4normalStyle(),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    'ตำบล : ',
                                                    style: MyContant()
                                                        .h4normalStyle(),
                                                  ),
                                                  Text(
                                                    '${list_district[i]['name']}',
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
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(162, 181, 252, 1),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'รหัส Blacklist',
                          style: MyContant().h4normalStyle(),
                        ),
                        input_idblacklist(sizeIcon, border),
                        InkWell(
                          onTap: () {
                            search_id_blacklist();
                          },
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(82, 119, 255, 1),
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
                          'ชื่อ-สกุล ลูกค้า',
                          style: MyContant().h4normalStyle(),
                        ),
                        input_name_show_bl(sizeIcon, border),
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(162, 181, 252, 1),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'เลขบัตรประชาชน',
                          style: MyContant().h4normalStyle(),
                        ),
                        input_smartId_bl(sizeIcon, border),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'ชื่อ',
                          style: MyContant().h4normalStyle(),
                        ),
                        input_name_blacklist(sizeIcon, border),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'สกุล',
                          style: MyContant().h4normalStyle(),
                        ),
                        input_lastname_blacklist(sizeIcon, border),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'บ้านเลขที่',
                          style: MyContant().h4normalStyle(),
                        ),
                        input_home_no_bl(sizeIcon, border),
                        Text(
                          'หมู่ที่',
                          style: MyContant().h4normalStyle(),
                        ),
                        input_moo_no_bl(sizeIcon, border),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'ตำบล',
                          style: MyContant().h4normalStyle(),
                        ),
                        input_district_bl(sizeIcon, border),
                        InkWell(
                          onTap: () {
                            search_district(context, border);
                            get_select_province();
                          },
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(82, 119, 255, 1),
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
                          'อำเภอ',
                          style: MyContant().h4normalStyle(),
                        ),
                        input_amphoe_bl(sizeIcon, border),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'จังหวัด',
                          style: MyContant().h4normalStyle(),
                        ),
                        input_province_bl(sizeIcon, border),
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
            // Container(
            //   height: MediaQuery.of(context).size.height * 0.7,
            //   child: Scrollbar(
            //     child: ListView(
            //       children: [
            //         if (list_data_blacklist.isNotEmpty) ...[
            //           for (var i = 0; i < list_data_blacklist.length; i++) ...[
            //             InkWell(
            //               onTap: () {
            //                 Navigator.push(
            //                   context,
            //                   MaterialPageRoute(
            //                     builder: (context) => Blacklist_Detail(
            //                         list_data_blacklist[i]['blId']),
            //                   ),
            //                 );
            //               },
            //               child: Padding(
            //                 padding: const EdgeInsets.symmetric(horizontal: 8),
            //                 child: Container(
            //                   margin: EdgeInsets.symmetric(vertical: 5),
            //                   padding: EdgeInsets.all(8),
            //                   decoration: BoxDecoration(
            //                     color: Color.fromRGBO(162, 181, 252, 1),
            //                     borderRadius: BorderRadius.all(
            //                       Radius.circular(5),
            //                     ),
            //                   ),
            //                   child: Column(
            //                     children: [
            //                       Row(
            //                         children: [
            //                           Text(
            //                             'รหัสลูกค้า : ${list_data_blacklist[i]['blId']}',
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
            //                             'ชื่อลูกค้า : ${list_data_blacklist[i]['custName']}',
            //                             style: MyContant().h4normalStyle(),
            //                           ),
            //                         ],
            //                       ),
            //                       SizedBox(
            //                         height: 5,
            //                       ),
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
            //                               '${list_data_blacklist[i]['custAddress']}',
            //                               style: MyContant().h4normalStyle(),
            //                               overflow: TextOverflow.clip,
            //                             ),
            //                           ),
            //                         ],
            //                       ),
            //                       SizedBox(
            //                         height: 5,
            //                       ),
            //                       Row(
            //                         children: [
            //                           Text(
            //                             'สถานะ : ${list_data_blacklist[i]['blStatus']}',
            //                             style: MyContant().h4normalStyle(),
            //                           ),
            //                         ],
            //                       ),
            //                     ],
            //                   ),
            //                 ),
            //               ),
            //             ),
            //           ],
            //         ],
            //       ],
            //     ),
            //   ),
            // ),
            SizedBox(
              height: 25,
            ),
          ],
        ),
      ),
    );
  }

  Expanded input_idblacklist(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: idblacklist,
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

  Expanded input_name_show_bl(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: name_show,
          onChanged: (keyword) {},
          readOnly: true,
          decoration: InputDecoration(
            counterText: "",
            contentPadding: EdgeInsets.all(4),
            isDense: true,
            enabledBorder: border,
            focusedBorder: border,
            hintText: 'สำหรับแสดง ชื่อ-สกุล ลูกค้า',
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

  Expanded input_smartId_bl(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: smartId,
          onChanged: (keyword) {},
          keyboardType: TextInputType.number,
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

  Expanded input_name_blacklist(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: name,
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

  Expanded input_lastname_blacklist(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: lastname,
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

  Expanded input_home_no_bl(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: home_no,
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

  Expanded input_moo_no_bl(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: moo_no,
          onChanged: (keyword) {},
          keyboardType: TextInputType.number,
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

  Expanded input_district_bl(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: district,
          onChanged: (keyword) {},
          readOnly: true,
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

  Expanded input_amphoe_bl(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: amphoe,
          onChanged: (keyword) {},
          readOnly: true,
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

  Expanded input_province_bl(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: province,
          onChanged: (keyword) {},
          readOnly: true,
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
                          if (idblacklist.text.isEmpty &&
                              smartId.text.isEmpty &&
                              name.text.isEmpty &&
                              lastname.text.isEmpty &&
                              home_no.text.isEmpty &&
                              moo_no.text.isEmpty &&
                              district.text.isEmpty &&
                              amphoe.text.isEmpty &&
                              province.text.isEmpty) {
                            showProgressDialog(context, 'แจ้งเตือน',
                                'กรุณากรอกข้อมูลลูกค้าที่ต้องการค้นหา');
                          } else {
                            if (home_no.text.isNotEmpty ||
                                moo_no.text.isNotEmpty) {
                              if (district.text.isEmpty) {
                                showProgressDialog(context, 'แจ้งเตือน',
                                    'กรุณาเลือก ตำบล อำเภอ จังหวัด');
                              } else {
                                // showProgressLoading(context);
                                // getData_blacklist();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Blacklist_cust_list(
                                        idblacklist.text,
                                        smartId.text,
                                        name.text,
                                        lastname.text,
                                        home_no.text,
                                        moo_no.text,
                                        districtId,
                                        selectValue_amphoe,
                                        selectValue_province),
                                  ),
                                );
                              }
                            } else {
                              // showProgressLoading(context);
                              // getData_blacklist();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Blacklist_cust_list(
                                      idblacklist.text,
                                      smartId.text,
                                      name.text,
                                      lastname.text,
                                      home_no.text,
                                      moo_no.text,
                                      districtId,
                                      selectValue_amphoe,
                                      selectValue_province),
                                ),
                              );
                            }
                          }
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
                          clear_data_blacklist();
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

  Expanded input_search_data(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: searchData,
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

  Expanded input_name_search_bl(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: nameSearchBl,
          onChanged: (keyword) {},
          decoration: InputDecoration(
            counterText: "",
            contentPadding: EdgeInsets.all(4),
            isDense: true,
            enabledBorder: border,
            focusedBorder: border,
            hintText: 'ชื่อ',
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

  Expanded input_lastname_search_bl(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: lastnameSearchBl,
          onChanged: (keyword) {},
          decoration: InputDecoration(
            counterText: "",
            contentPadding: EdgeInsets.all(4),
            isDense: true,
            enabledBorder: border,
            focusedBorder: border,
            hintText: 'นามสกุล',
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
}
