import 'dart:async';
import 'dart:convert';

import 'package:application_thaweeyont/state/state_credit/query_debtor/data_debtor_list.dart';
import 'package:application_thaweeyont/widgets/custom_appbar.dart';
import 'package:application_thaweeyont/widgets/endpage.dart';
import 'package:application_thaweeyont/widgets/loaddata.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loading_gifs/loading_gifs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../authen.dart';
import 'package:application_thaweeyont/utility/my_constant.dart';
import 'package:application_thaweeyont/api.dart';

class Query_debtor extends StatefulWidget {
  const Query_debtor({super.key});

  @override
  State<Query_debtor> createState() => _Query_debtorState();
}

class _Query_debtorState extends State<Query_debtor> {
  String userId = '',
      empId = '',
      firstName = '',
      lastName = '',
      tokenId = '',
      text_province = '',
      text_amphoe = '';
  bool? allowApproveStatus;

  String? id = '1';
  var filter = false;
  TextEditingController idcard = TextEditingController();
  TextEditingController firstnameCus = TextEditingController();
  TextEditingController lastnameCus = TextEditingController();
  TextEditingController district = TextEditingController();
  TextEditingController amphoe = TextEditingController();
  TextEditingController provincn = TextEditingController();
  TextEditingController searchNameItemtype = TextEditingController();
  TextEditingController itemTypelist = TextEditingController();
  TextEditingController homeNo = TextEditingController();
  TextEditingController moo = TextEditingController();
  TextEditingController telephone = TextEditingController();
  TextEditingController signid = TextEditingController();
  TextEditingController signrunning = TextEditingController();
  TextEditingController custId = TextEditingController();

  bool st_customer = true,
      st_employee = false,
      statusLoad404itemTypeList = false,
      statusLoad404 = false;
  List dropdown_province = [], list_dataDebtor = [];
  List dropdown_amphoe = [],
      dropdown_addresstype = [],
      dropdown_branch = [],
      dropdown_debtorType = [],
      dropdown_signStatus = [],
      dropdown_customer = [];
  List list_district = [],
      list_itemType = [],
      list_Debtordetail = [],
      list_datavalue = [];
  var selectValue_province,
      selectValue_amphoe,
      select_addreessType,
      select_branchlist,
      select_debtorType,
      select_signStatus,
      checkStatuscode,
      debtorStatuscode,
      tumbolId,
      itemType,
      valueSignId,
      status_e = false;

  var selectValue_customer, valueNotdata, Texthint, text_search;
  var signStatus, branch, debtorType, tumbol, amphur, province;
  late var timer;

  @override
  void initState() {
    super.initState();
    setState(() {
      id = '1';
    });
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
      allowApproveStatus = preferences.getBool('allowApproveStatus');
    });
    await Future.delayed(const Duration(milliseconds: 100));
    if (mounted) {
      getSelectProvince();
      getSelectAddressTypelist();
      getSelectBranch();
      getSelectDebtorType();
      getSelectSignStatus();
      getSelectCus();
    }
  }

  Future<void> getSelectProvince() async {
    try {
      var respose = await http.get(
        Uri.parse('${api}setup/provinceList?page=1&limit=100'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> data_provice =
            Map<String, dynamic>.from(json.decode(respose.body));
        setState(() {
          dropdown_province = data_provice['data'];
        });
      } else if (respose.statusCode == 400) {
        if (!mounted) return;
        showProgressDialog_400(
            context, 'แจ้งเตือน', 'ไม่พบข้อมูล (${respose.statusCode})');
      } else if (respose.statusCode == 401) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.clear();
        if (!mounted) return;
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
        if (!mounted) return;
        showProgressDialog_404(context, 'แจ้งเตือน', 'ไม่พบข้อมูลที่ค้นหา');
      } else if (respose.statusCode == 405) {
        if (!mounted) return;
        showProgressDialog_405(
            context, 'แจ้งเตือน', 'ไม่พบข้อมูล (${respose.statusCode})');
      } else if (respose.statusCode == 500) {
        if (!mounted) return;
        showProgressDialog_500(
            context, 'แจ้งเตือน', 'ข้อมูลผิดพลาด (${respose.statusCode})');
      } else {
        if (!mounted) return;
        showProgressDialog(context, 'แจ้งเตือน', 'กรุณาติดต่อผู้ดูแลระบบ');
      }
    } catch (e) {
      print("ไม่มีข้อมูล $e");
      showProgressDialogNotdata(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด กรุณาแจ้งผู้ดูแลระบบ');
    }
  }

  Future<void> getSelectDistrict() async {
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
    try {
      var respose = await http.get(
        Uri.parse(
            '${api}setup/districtList?pId=${selectValue_province.toString().split("_")[0]}&aId=${selectValue_amphoe.toString().split("_")[0]}'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> data_district =
            Map<String, dynamic>.from(json.decode(respose.body));
        setState(() {
          list_district = data_district['data'];
        });
        if (!mounted) return;
        Navigator.pop(context);
        Navigator.pop(context);
        searchDistrict(sizeIcon, border);
      } else if (respose.statusCode == 400) {
        if (!mounted) return;
        showProgressDialog_400(
            context, 'แจ้งเตือน', 'ไม่พบข้อมูล (${respose.statusCode})');
      } else if (respose.statusCode == 401) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.clear();
        if (!mounted) return;
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
        if (!mounted) return;
        showProgressDialog_404(context, 'แจ้งเตือน', 'ไม่พบข้อมูลที่ค้นหา');
      } else if (respose.statusCode == 405) {
        if (!mounted) return;
        showProgressDialog_405(
            context, 'แจ้งเตือน', 'ไม่พบข้อมูล (${respose.statusCode})');
      } else if (respose.statusCode == 500) {
        if (!mounted) return;
        showProgressDialog_500(
            context, 'แจ้งเตือน', 'ข้อมูลผิดพลาด (${respose.statusCode})');
      } else {
        if (!mounted) return;
        showProgressDialog(context, 'แจ้งเตือน', 'กรุณาติดต่อผู้ดูแลระบบ!');
      }
    } catch (e) {
      print("ไม่มีข้อมูล $e");
      showProgressDialogNotdata(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
  }

  Future<void> getItemTypelist() async {
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

    try {
      var respose = await http.get(
        Uri.parse(
            '${api}setup/itemTypeList?searchName=${searchNameItemtype.text}&page=1&limit=50'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> data_itemTypelist =
            Map<String, dynamic>.from(json.decode(respose.body));
        setState(() {
          list_itemType = data_itemTypelist['data'];
        });

        Navigator.pop(context);
      } else if (respose.statusCode == 400) {
        showProgressDialog_400(
            context, 'แจ้งเตือน', 'ไม่พบข้อมูล (${respose.statusCode})');
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
      } else if (respose.statusCode == 404) {
        setState(() {
          Navigator.pop(context);
          statusLoad404itemTypeList = true;
        });
      } else if (respose.statusCode == 405) {
        showProgressDialog_405(
            context, 'แจ้งเตือน', 'ไม่พบข้อมูล (${respose.statusCode})');
      } else if (respose.statusCode == 500) {
        showProgressDialog_500(
            context, 'แจ้งเตือน', 'ไม่พบข้อมูล (${respose.statusCode})');
      } else {
        showProgressDialog(context, 'แจ้งเตือน', 'กรุณาติดต่อผู้ดูแลระบบ!');
      }
    } catch (e) {
      print("ไม่มีข้อมูล $e");
      showProgressDialogNotdata(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
  }

  Future<void> getSelectAddressTypelist() async {
    try {
      var respose = await http.get(
        Uri.parse('${api}setup/addressTypeList'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> data_addressTypelist =
            Map<String, dynamic>.from(json.decode(respose.body));
        setState(() {
          dropdown_addresstype = data_addressTypelist['data'];
          select_addreessType = dropdown_addresstype[0]['id'];
        });
      } else if (respose.statusCode == 401) {
        if (mounted) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const Authen(),
          ),
          (Route<dynamic> route) => false,
        );
        showProgressDialog_401(
            context, 'แจ้งเตือน', 'กรุณา Login เข้าสู่ระบบใหม่');
      }
    } catch (e) {
      print("ไม่มีข้อมูล $e");
      showProgressDialogNotdata(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
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
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const Authen(),
          ),
          (Route<dynamic> route) => false,
        );
        showProgressDialog_401(
            context, 'แจ้งเตือน', 'กรุณา Login เข้าสู่ระบบใหม่');
      }
    } catch (e) {
      print("ไม่มีข้อมูล_อิอิ $e");
      showProgressDialogNotdata(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
  }

  Future<void> getSelectDebtorType() async {
    try {
      var respose = await http.get(
        Uri.parse('${api}setup/debtorTypeList'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> data_debtorType =
            Map<String, dynamic>.from(json.decode(respose.body));
        setState(() {
          dropdown_debtorType = data_debtorType['data'];
        });
      } else if (respose.statusCode == 401) {
        if (mounted) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const Authen(),
          ),
          (Route<dynamic> route) => false,
        );
        showProgressDialog_401(
            context, 'แจ้งเตือน', 'กรุณา Login เข้าสู่ระบบใหม่');
      }
    } catch (e) {
      print("ไม่มีข้อมูล $e");
      showProgressDialogNotdata(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
  }

  Future<void> getSelectSignStatus() async {
    try {
      var respose = await http.get(
        Uri.parse('${api}setup/signStatusList'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> data_signStatusList =
            Map<String, dynamic>.from(json.decode(respose.body));
        setState(() {
          dropdown_signStatus = data_signStatusList['data'];
          select_signStatus = dropdown_signStatus[0]['id'];
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
      } else {}
    } catch (e) {
      print("ไม่มีข้อมูล $e");
      showProgressDialogNotdata(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
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
      }
    } catch (e) {
      print("ไม่มีข้อมูล $e");

      showProgressDialogNotdata(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
  }

  clearTextInputAll() {
    custId.clear();
    idcard.clear();
    firstnameCus.clear();
    lastnameCus.clear();
    telephone.clear();
    homeNo.clear();
    moo.clear();
    district.clear();
    amphoe.clear();
    provincn.clear();
    signid.clear();
    signrunning.clear();
    itemTypelist.clear();
    setState(() {
      select_debtorType = null;
      select_branchlist = null;
      debtorStatuscode = null;
      selectValue_amphoe = null;
      tumbolId = null;
      selectValue_province = null;
      getSelectSignStatus();
      getSelectAddressTypelist();
    });
  }

  clearValueSearchDistrict() {
    setState(() {
      selectValue_province = null;
      selectValue_amphoe = null;
      list_district = [];
    });
  }

  clearValueSearchConType() {
    setState(() {
      list_itemType = [];
    });
    searchNameItemtype.clear();
  }

  Future<void> searchDistrict(sizeIcon, border) async {
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
                                        'ค้นหาข้อมูล',
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
                                  clearValueSearchDistrict();
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
                              color: const Color.fromRGBO(255, 203, 246, 1),
                            ),
                            padding: const EdgeInsets.all(8),
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
                                                0.1,
                                        padding: const EdgeInsets.all(4),
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
                                                          value:
                                                              "${value['id']}_${value['name']}",
                                                          child: Text(
                                                            value['name'],
                                                            style: MyContant()
                                                                .textInputStyle(),
                                                          ),
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
                                                      '${api}setup/amphurList?pId=${selectValue_province.toString().split("_")[0]}'),
                                                  headers: <String, String>{
                                                    'Content-Type':
                                                        'application/json',
                                                    'Authorization':
                                                        tokenId.toString(),
                                                  },
                                                );

                                                if (respose.statusCode == 200) {
                                                  Map<String, dynamic>
                                                      data_amphoe =
                                                      Map<String, dynamic>.from(
                                                          json.decode(
                                                              respose.body));
                                                  setState(() {
                                                    dropdown_amphoe =
                                                        data_amphoe['data'];
                                                  });
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
                                                          const Authen(),
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
                                                showProgressDialogNotdata(
                                                    context,
                                                    'แจ้งเตือน',
                                                    'เกิดข้อผิดพลาด! กรุณาแจ้งผูดูแลระบบ');
                                              }
                                            },
                                            value: selectValue_province,
                                            isExpanded: true,
                                            underline: const SizedBox(),
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
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.1,
                                        padding: const EdgeInsets.all(4),
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
                                                          value:
                                                              "${value['id']}_${value['name']}",
                                                          child: Text(
                                                            value['name'],
                                                            style: MyContant()
                                                                .textInputStyle(),
                                                          ),
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
                                            underline: const SizedBox(),
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
                                    MediaQuery.of(context).size.height * 0.040,
                                width: MediaQuery.of(context).size.width * 0.25,
                                child: ElevatedButton(
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
                                      getSelectDistrict();
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
                                            amphoe.text = text_amphoe;
                                            provincn.text = text_province;
                                            tumbolId =
                                                '${list_district[i]['id']}';
                                          },
                                        );
                                        Navigator.pop(context);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4, horizontal: 8),
                                        child: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(5)),
                                            color: const Color.fromRGBO(
                                                255, 218, 249, 1),
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
                                                    text_province,
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
                                                    text_amphoe,
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
                                    ),
                                  ],
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

  Future<void> searchConType(sizeIcon, border) async {
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
                                        'ค้นหาข้อมูลประเภทสินค้า',
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
                                  clearValueSearchConType();
                                  setState(() {
                                    statusLoad404itemTypeList = false;
                                  });
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
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(5),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withAlpha(130),
                                  spreadRadius: 0.2,
                                  blurRadius: 2,
                                  offset: const Offset(0, 1),
                                )
                              ],
                              color: const Color.fromRGBO(255, 203, 246, 1),
                            ),
                            padding: const EdgeInsets.all(8),
                            width: double.infinity,
                            child: Column(children: [
                              Row(
                                children: [
                                  Text(
                                    'ชื่อประเภท',
                                    style: MyContant().h4normalStyle(),
                                  ),
                                  inputNameDia(sizeIcon, border),
                                ],
                              ),
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
                                    MediaQuery.of(context).size.height * 0.040,
                                width: MediaQuery.of(context).size.width * 0.25,
                                child: ElevatedButton(
                                  style: MyContant().myButtonSearchStyle(),
                                  onPressed: () {
                                    if (searchNameItemtype.text.isEmpty) {
                                      showProgressDialog(context, 'แจ้งเตือน',
                                          'กรุณากรอกชื่อประเภท');
                                    } else {
                                      showProgressLoading(context);
                                      getItemTypelist();
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
                                if (list_itemType.isNotEmpty) ...[
                                  for (var i = 0;
                                      i < list_itemType.length;
                                      i++) ...[
                                    InkWell(
                                      onTap: () {
                                        setState(
                                          () {
                                            itemTypelist.text =
                                                '${list_itemType[i]['name']}';
                                            itemType =
                                                '${list_itemType[i]['id']}';
                                            Navigator.pop(context);
                                          },
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4, horizontal: 8),
                                        child: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(5)),
                                            color: const Color.fromRGBO(
                                                255, 218, 249, 1),
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
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    'รหัส : ${list_itemType[i]['id']}',
                                                    style: MyContant()
                                                        .h4normalStyle(),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 5),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'ชื่อ : ',
                                                    style: MyContant()
                                                        .h4normalStyle(),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      '${list_itemType[i]['name']}',
                                                      overflow:
                                                          TextOverflow.clip,
                                                      style: MyContant()
                                                          .h4normalStyle(),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ] else if (statusLoad404itemTypeList ==
                                    true) ...[
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

  // Future<void> searchIdcustomer(sizeIcon, border) async {
  //   Future<void> getDataCondition(String? custType, conditionType,
  //       String searchData, String firstName, String lastName) async {
  //     try {
  //       var respose = await http.post(
  //         Uri.parse('${api}customer/list'),
  //         headers: <String, String>{
  //           'Content-Type': 'application/json',
  //           'Authorization': tokenId.toString(),
  //         },
  //         body: jsonEncode(<String, String>{
  //           'custType': custType.toString(),
  //           'conditionType': conditionType.toString(),
  //           'searchData': searchData.toString(),
  //           'firstName': firstName.toString(),
  //           'lastName': lastName.toString(),
  //           'page': '1',
  //           'limit': '100'
  //         }),
  //       );

  //       if (respose.statusCode == 200) {
  //         Map<String, dynamic> dataList =
  //             Map<String, dynamic>.from(json.decode(respose.body));

  //         setState(() {
  //           list_datavalue = dataList['data'];
  //         });

  //         Navigator.pop(context);
  //       } else if (respose.statusCode == 400) {
  //         showProgressDialog_400(
  //             context, 'แจ้งเตือน', '${respose.statusCode} ไม่พบข้อมูล!');
  //       } else if (respose.statusCode == 401) {
  //         SharedPreferences preferences = await SharedPreferences.getInstance();
  //         preferences.clear();
  //         Navigator.pushAndRemoveUntil(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => const Authen(),
  //           ),
  //           (Route<dynamic> route) => false,
  //         );
  //         showProgressDialog_401(
  //             context, 'แจ้งเตือน', 'กรุณา Login เข้าสู่ระบบใหม่');
  //       } else if (respose.statusCode == 404) {
  //         setState(() {
  //           Navigator.pop(context);
  //           statusLoad404 = true;
  //         });
  //       } else if (respose.statusCode == 405) {
  //         showProgressDialog_405(context, 'แจ้งเตือน', 'ไม่พบข้อมูล!');
  //       } else if (respose.statusCode == 500) {
  //         showProgressDialog_500(
  //             context, 'แจ้งเตือน', '${respose.statusCode} ข้อมูลผิดพลาด!');
  //       }
  //     } catch (e) {
  //       print("ไม่มีข้อมูล $e");
  //       showProgressDialogNotdata(context, 'แจ้งเตือน', 'ไม่พบข้อมูล!');
  //     }
  //   }

  //   Future<void> getData_search() async {
  //     if (id == '1') {
  //       showProgressLoading(context);
  //       if (selectValue_customer.toString() == "2") {
  //         getDataCondition(
  //             id, selectValue_customer, '', searchData.text, lastname.text);
  //       } else {
  //         getDataCondition(id, selectValue_customer, searchData.text, '', '');
  //       }
  //     } else {
  //       showProgressLoading(context);
  //       getDataCondition(id, '2', '', firstnameEm.text, lastnameEm.text);
  //     }
  //   }

  //   showDialog(
  //     context: context,
  //     builder: (context) => GestureDetector(
  //       onTap: () {
  //         FocusScope.of(context).requestFocus(FocusNode());
  //       },
  //       behavior: HitTestBehavior.opaque,
  //       child: StatefulBuilder(
  //         builder: (context, setState) => Container(
  //           alignment: Alignment.center,
  //           padding: const EdgeInsets.all(5),
  //           child: SingleChildScrollView(
  //             padding: EdgeInsets.only(
  //                 bottom: MediaQuery.of(context).viewInsets.bottom),
  //             child: Column(
  //               children: [
  //                 Card(
  //                   shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(15),
  //                   ),
  //                   elevation: 0,
  //                   color: Colors.white,
  //                   child: Column(
  //                     children: [
  //                       Stack(
  //                         children: [
  //                           Padding(
  //                             padding:
  //                                 const EdgeInsets.only(top: 12, bottom: 6),
  //                             child: Column(
  //                               children: [
  //                                 Row(
  //                                   mainAxisAlignment: MainAxisAlignment.center,
  //                                   children: [
  //                                     Text(
  //                                       'ค้นหาข้อมูลลูกค้า',
  //                                       style: MyContant().h4normalStyle(),
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ],
  //                             ),
  //                           ),
  //                           Positioned(
  //                             right: 0,
  //                             child: InkWell(
  //                               onTap: () {
  //                                 Navigator.pop(context);
  //                                 clearValueDialog();
  //                               },
  //                               child: const Padding(
  //                                 padding: EdgeInsets.symmetric(
  //                                     vertical: 8, horizontal: 4),
  //                                 child: Icon(
  //                                   Icons.close,
  //                                   size: 30,
  //                                   color: Color.fromARGB(255, 0, 0, 0),
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                       const Divider(
  //                         color: Color.fromARGB(255, 138, 138, 138),
  //                       ),
  //                       Padding(
  //                         padding: const EdgeInsets.all(8.0),
  //                         child: Container(
  //                           decoration: BoxDecoration(
  //                             borderRadius: const BorderRadius.all(
  //                               Radius.circular(5),
  //                             ),
  //                             boxShadow: [
  //                               BoxShadow(
  //                                 color: Colors.grey.withAlpha(130),
  //                                 spreadRadius: 0.2,
  //                                 blurRadius: 2,
  //                                 offset: const Offset(0, 1),
  //                               )
  //                             ],
  //                             color: const Color.fromRGBO(255, 203, 246, 1),
  //                           ),
  //                           padding: const EdgeInsets.all(8),
  //                           width: double.infinity,
  //                           child: Column(children: [
  //                             Row(
  //                               children: [
  //                                 Expanded(
  //                                   child: RadioListTile(
  //                                     activeColor: Colors.black,
  //                                     contentPadding: const EdgeInsets.all(0.0),
  //                                     value: '1',
  //                                     groupValue: id,
  //                                     title: Text(
  //                                       'ลูกค้าทั่วไป',
  //                                       style: MyContant().h4normalStyle(),
  //                                     ),
  //                                     onChanged: (value) {
  //                                       setState(() {
  //                                         st_customer = true;
  //                                         st_employee = false;
  //                                         id = value.toString();
  //                                         searchData.clear();
  //                                         statusLoad404 = false;
  //                                       });
  //                                     },
  //                                   ),
  //                                 ),
  //                                 Expanded(
  //                                   child: RadioListTile(
  //                                     activeColor: Colors.black,
  //                                     value: '2',
  //                                     groupValue: id,
  //                                     title: Text(
  //                                       'พนักงาน',
  //                                       style: MyContant().h4normalStyle(),
  //                                     ),
  //                                     onChanged: (value) {
  //                                       setState(() {
  //                                         st_customer = false;
  //                                         st_employee = true;
  //                                         id = value.toString();
  //                                         searchData.clear();
  //                                         statusLoad404 = false;
  //                                       });
  //                                     },
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                             if (st_employee == true) ...[
  //                               Row(
  //                                 children: [
  //                                   Text(
  //                                     'ชื่อ',
  //                                     style: MyContant().h4normalStyle(),
  //                                   ),
  //                                   inputNameEmploDia(sizeIcon, border),
  //                                   Text(
  //                                     'สกุล',
  //                                     style: MyContant().h4normalStyle(),
  //                                   ),
  //                                   inputLastNameEmploDia(sizeIcon, border),
  //                                 ],
  //                               ),
  //                             ],
  //                             if (st_customer == true) ...[
  //                               Row(
  //                                 children: [
  //                                   Expanded(
  //                                     child: Padding(
  //                                       padding: const EdgeInsets.all(1),
  //                                       child: Container(
  //                                         height: MediaQuery.of(context)
  //                                                 .size
  //                                                 .width *
  //                                             0.095,
  //                                         padding: const EdgeInsets.all(4),
  //                                         decoration: BoxDecoration(
  //                                             color: Colors.white,
  //                                             borderRadius:
  //                                                 BorderRadius.circular(5)),
  //                                         child: Padding(
  //                                           padding:
  //                                               const EdgeInsets.only(left: 4),
  //                                           child: DropdownButton(
  //                                             items: dropdown_customer
  //                                                 .map((value) =>
  //                                                     DropdownMenuItem(
  //                                                       value: value['id'],
  //                                                       child: Text(
  //                                                         value['name'],
  //                                                         style: MyContant()
  //                                                             .textInputStyle(),
  //                                                       ),
  //                                                     ))
  //                                                 .toList(),
  //                                             onChanged: (newvalue) {
  //                                               setState(() {
  //                                                 selectValue_customer =
  //                                                     newvalue;
  //                                                 if (selectValue_customer
  //                                                         .toString() ==
  //                                                     "2") {
  //                                                   Texthint = 'ชื่อ';
  //                                                 } else {
  //                                                   Texthint = '';
  //                                                 }
  //                                                 searchData.clear();
  //                                                 statusLoad404 = false;
  //                                               });
  //                                             },
  //                                             value: selectValue_customer,
  //                                             isExpanded: true,
  //                                             underline: const SizedBox(),
  //                                             hint: Align(
  //                                               child: Text(
  //                                                 'กรุณาเลือกข้อมูล',
  //                                                 style: MyContant()
  //                                                     .TextInputSelect(),
  //                                               ),
  //                                             ),
  //                                           ),
  //                                         ),
  //                                       ),
  //                                     ),
  //                                   ),
  //                                   inputSearchCus(sizeIcon, border),
  //                                   if (selectValue_customer.toString() ==
  //                                       "2") ...[
  //                                     inputLastnameCus(sizeIcon, border)
  //                                   ],
  //                                 ],
  //                               ),
  //                             ],
  //                           ]),
  //                         ),
  //                       ),
  //                       const SizedBox(
  //                         height: 5,
  //                       ),
  //                       Padding(
  //                         padding: const EdgeInsets.symmetric(
  //                             vertical: 0, horizontal: 8),
  //                         child: Row(
  //                           mainAxisAlignment: MainAxisAlignment.end,
  //                           children: [
  //                             SizedBox(
  //                               height:
  //                                   MediaQuery.of(context).size.height * 0.040,
  //                               width: MediaQuery.of(context).size.width * 0.25,
  //                               child: ElevatedButton(
  //                                 style: MyContant().myButtonSearchStyle(),
  //                                 onPressed: () {
  //                                   if (id == '1') {
  //                                     if (selectValue_customer == null ||
  //                                         searchData.text.isEmpty &&
  //                                             lastname.text.isEmpty) {
  //                                       showProgressDialog(context, 'แจ้งเตือน',
  //                                           'กรุณากรอกข้อมูล');
  //                                     } else {
  //                                       getData_search();
  //                                     }
  //                                   } else {
  //                                     if (firstnameEm.text.isEmpty &&
  //                                         lastnameEm.text.isEmpty) {
  //                                       showProgressDialog(context, 'แจ้งเตือน',
  //                                           'กรุณากรอกข้อมูล');
  //                                     } else {
  //                                       getData_search();
  //                                     }
  //                                   }
  //                                 },
  //                                 child: const Text('ค้นหา'),
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                       Padding(
  //                         padding: const EdgeInsets.symmetric(horizontal: 8),
  //                         child: Row(
  //                           children: [
  //                             Text(
  //                               'รายการที่ค้นหา',
  //                               style: MyContant().h2Style(),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                       const SizedBox(height: 10),
  //                       SizedBox(
  //                         height: MediaQuery.of(context).size.height * 0.5,
  //                         child: Scrollbar(
  //                           child: ListView(
  //                             children: [
  //                               if (list_datavalue.isNotEmpty) ...[
  //                                 for (var i = 0;
  //                                     i < list_datavalue.length;
  //                                     i++) ...[
  //                                   InkWell(
  //                                     onTap: () {
  //                                       setState(
  //                                         () {
  //                                           custId.text =
  //                                               list_datavalue[i]['custId'];
  //                                           Navigator.pop(context);
  //                                           clearValueDialog();
  //                                         },
  //                                       );
  //                                     },
  //                                     child: Padding(
  //                                       padding: const EdgeInsets.symmetric(
  //                                           vertical: 4, horizontal: 8),
  //                                       child: Container(
  //                                         padding: const EdgeInsets.all(8.0),
  //                                         decoration: BoxDecoration(
  //                                           borderRadius:
  //                                               const BorderRadius.all(
  //                                                   Radius.circular(5)),
  //                                           color: const Color.fromRGBO(
  //                                               255, 218, 249, 1),
  //                                           boxShadow: [
  //                                             BoxShadow(
  //                                               color: Colors.grey
  //                                                   .withValues(alpha: 0.5),
  //                                               spreadRadius: 0.2,
  //                                               blurRadius: 2,
  //                                               offset: const Offset(0, 1),
  //                                             )
  //                                           ],
  //                                         ),
  //                                         child: Column(
  //                                           children: [
  //                                             Row(
  //                                               children: [
  //                                                 Text(
  //                                                   'รหัส : ${list_datavalue[i]['custId']}',
  //                                                   style: MyContant()
  //                                                       .h4normalStyle(),
  //                                                 ),
  //                                               ],
  //                                             ),
  //                                             const SizedBox(
  //                                               height: 5,
  //                                             ),
  //                                             Row(
  //                                               children: [
  //                                                 Text(
  //                                                   'ชื่อ : ${list_datavalue[i]['custName']}',
  //                                                   style: MyContant()
  //                                                       .h4normalStyle(),
  //                                                 ),
  //                                               ],
  //                                             ),
  //                                             const SizedBox(
  //                                               height: 5,
  //                                             ),
  //                                             Row(
  //                                               crossAxisAlignment:
  //                                                   CrossAxisAlignment.start,
  //                                               children: [
  //                                                 Text(
  //                                                   'ที่อยู่ : ',
  //                                                   style: MyContant()
  //                                                       .h4normalStyle(),
  //                                                 ),
  //                                                 Expanded(
  //                                                   child: Text(
  //                                                     '${list_datavalue[i]['address']}',
  //                                                     style: MyContant()
  //                                                         .h4normalStyle(),
  //                                                     overflow:
  //                                                         TextOverflow.clip,
  //                                                   ),
  //                                                 ),
  //                                               ],
  //                                             ),
  //                                             const SizedBox(
  //                                               height: 5,
  //                                             ),
  //                                             Row(
  //                                               crossAxisAlignment:
  //                                                   CrossAxisAlignment.start,
  //                                               children: [
  //                                                 Text(
  //                                                   'โทร : ',
  //                                                   style: MyContant()
  //                                                       .h4normalStyle(),
  //                                                 ),
  //                                                 Expanded(
  //                                                   child: Text(
  //                                                     '${list_datavalue[i]['telephone']}',
  //                                                     style: MyContant()
  //                                                         .h4normalStyle(),
  //                                                     overflow:
  //                                                         TextOverflow.clip,
  //                                                   ),
  //                                                 ),
  //                                               ],
  //                                             ),
  //                                           ],
  //                                         ),
  //                                       ),
  //                                     ),
  //                                   ),
  //                                 ],
  //                               ] else if (statusLoad404 == true) ...[
  //                                 Padding(
  //                                   padding: const EdgeInsets.only(top: 100),
  //                                   child: Column(
  //                                     children: [
  //                                       Row(
  //                                         mainAxisAlignment:
  //                                             MainAxisAlignment.center,
  //                                         children: [
  //                                           Image.asset(
  //                                             'images/Nodata.png',
  //                                             width: 55,
  //                                             height: 55,
  //                                           ),
  //                                         ],
  //                                       ),
  //                                       Row(
  //                                         mainAxisAlignment:
  //                                             MainAxisAlignment.center,
  //                                         children: [
  //                                           Text(
  //                                             'ไม่พบรายการข้อมูล',
  //                                             style: MyContant().h5NotData(),
  //                                           ),
  //                                         ],
  //                                       ),
  //                                     ],
  //                                   ),
  //                                 ),
  //                               ],
  //                             ],
  //                           ),
  //                         ),
  //                       ),
  //                       const SizedBox(
  //                         height: 20,
  //                       )
  //                     ],
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

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
          shrinkWrap: true,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withAlpha(130),
                      spreadRadius: 0.2,
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    )
                  ],
                  color: const Color.fromRGBO(255, 203, 246, 1),
                ),
                width: double.infinity,
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
                                const Color.fromRGBO(202, 71, 150, 1),
                          ),
                          onPressed: () {
                            // searchIdcustomer(sizeIcon, border);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CustomerList(),
                              ),
                            ).then((result) {
                              if (result != null) {
                                setState(() {
                                  custId.text = result['id'];
                                });
                              }
                            });
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
                          'เลขบัตรประชาชน',
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
                        inputName(sizeIcon, border),
                        Text(
                          'นามสกุล',
                          style: MyContant().h4normalStyle(),
                        ),
                        inputLastname(sizeIcon, border),
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
                          'เลขที่สัญญา',
                          style: MyContant().h4normalStyle(),
                        ),
                        inputSignId(sizeIcon, border),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'เบอร์โทร',
                          style: MyContant().h4normalStyle(),
                        ),
                        inputTel(sizeIcon, border),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'ค้นหาจาก',
                          style: MyContant().h4normalStyle(),
                        ),
                        selectSearch(sizeIcon, border),
                      ],
                    ),
                    if (filter == true) ...[
                      line(),
                      Row(
                        children: [
                          Text(
                            'บ้านเลขที่',
                            style: MyContant().h4normalStyle(),
                          ),
                          inputNumberhome(sizeIcon, border),
                          Text(
                            'หมู่',
                            style: MyContant().h4normalStyle(),
                          ),
                          inputMoo(sizeIcon, border),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'ตำบล',
                            style: MyContant().h4normalStyle(),
                          ),
                          inputDistrict(sizeIcon, border),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              backgroundColor:
                                  const Color.fromRGBO(202, 71, 150, 1),
                            ),
                            onPressed: () {
                              // searchDistrict(sizeIcon, border);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const DistrictList(),
                                ),
                              ).then((result) {
                                if (result != null) {
                                  setState(() {});
                                }
                              });
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
                            'อำเภอ',
                            style: MyContant().h4normalStyle(),
                          ),
                          inputAmphoe(sizeIcon, border),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'จังหวัด',
                            style: MyContant().h4normalStyle(),
                          ),
                          inputProvince(sizeIcon, border),
                        ],
                      ),
                      line(),
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
                            'ประเภทลูกหนี้ ',
                            style: MyContant().h4normalStyle(),
                          ),
                          selectDebtorTypelist(sizeIcon, border),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'สถานะสัญญา',
                            style: MyContant().h4normalStyle(),
                          ),
                          selectContractStatus(sizeIcon, border),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'ประเภทสินค้า',
                            style: MyContant().h4normalStyle(),
                          ),
                          inputContractType(sizeIcon, border),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              backgroundColor:
                                  const Color.fromRGBO(202, 71, 150, 1),
                            ),
                            onPressed: () {
                              searchConType(sizeIcon, border);
                            },
                            child: const Icon(
                              Icons.search,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            groupBtnsearch(),
            const SizedBox(
              height: 70,
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              InkWell(
                onTap: () {
                  if (filter == false) {
                    setState(() {
                      filter = true;
                    });
                  } else {
                    setState(() {
                      filter = false;
                    });
                  }
                },
                child: Row(
                  children: [
                    if (filter == true) ...[
                      Text(
                        'ค้นหาแบบย่อย',
                        style: MyContant().TextsearchStyle(),
                      ),
                      const Icon(
                        Icons.arrow_drop_up,
                        color: Colors.black,
                      ),
                    ] else ...[
                      Text(
                        'ค้นหาแบบละเอียด',
                        style: MyContant().TextsearchStyle(),
                      ),
                      const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Data_debtor_list(
                              custId.text,
                              homeNo.text,
                              moo.text,
                              tumbolId,
                              amphur.toString(),
                              province.toString(),
                              firstnameCus.text,
                              lastnameCus.text,
                              select_addreessType.toString(),
                              select_debtorType,
                              idcard.text,
                              telephone.text,
                              select_branchlist,
                              signid.text,
                              signrunning.text,
                              select_signStatus,
                              itemTypelist.text,
                              selectValue_amphoe,
                              selectValue_province,
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
                      onPressed: clearTextInputAll,
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

  Padding line() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: SizedBox(
        height: 5,
        width: double.infinity,
        child: Divider(
          color: Color.fromARGB(105, 71, 71, 71),
        ),
      ),
    );
  }

  Expanded inputIdcustomer(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: TextField(
          controller: custId,
          maxLength: 13,
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

  Expanded inputName(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: TextField(
          controller: firstnameCus,
          onChanged: (keyword) {},
          decoration: InputDecoration(
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

  Expanded inputLastname(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: TextField(
          controller: lastnameCus,
          onChanged: (keyword) {},
          decoration: InputDecoration(
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

  Expanded inputTel(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: TextField(
          controller: telephone,
          maxLength: 10,
          keyboardType: TextInputType.number,
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

  Expanded selectSearch(sizeIcon, border) {
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
              items: dropdown_addresstype
                  .map((value) => DropdownMenuItem(
                        value: value['id'],
                        child: Text(
                          value['name'],
                          style: MyContant().h4normalStyle(),
                        ),
                      ))
                  .toList(),
              onChanged: (newvalue) {
                setState(() {
                  select_addreessType = newvalue;
                });
              },
              value: select_addreessType,
              isExpanded: true,
              underline: const SizedBox(),
              hint: Align(
                child: Text(
                  'ค้นหาจาก',
                  style: MyContant().TextInputSelect(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Expanded inputNumberhome(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: TextField(
          controller: homeNo,
          onChanged: (keyword) {},
          decoration: InputDecoration(
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

  Expanded inputMoo(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: TextField(
          controller: moo,
          onChanged: (keyword) {},
          decoration: InputDecoration(
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

  Expanded inputDistrict(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: TextField(
          controller: district,
          readOnly: true,
          onChanged: (keyword) {},
          decoration: InputDecoration(
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

  Expanded inputAmphoe(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: TextField(
          controller: amphoe,
          readOnly: true,
          onChanged: (keyword) {},
          decoration: InputDecoration(
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

  Expanded inputProvince(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: TextField(
          controller: provincn,
          readOnly: true,
          onChanged: (keyword) {},
          decoration: InputDecoration(
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
            child: DropdownButton(
              items: dropdown_branch
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
                  select_branchlist = newvalue;
                });
              },
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

  Expanded inputSignId(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: TextField(
          controller: signid,
          onChanged: (keyword) {},
          decoration: InputDecoration(
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
          onChanged: (keyword) {},
          decoration: InputDecoration(
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

  Expanded selectDebtorTypelist(sizeIcon, border) {
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
              items: dropdown_debtorType
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
                  select_debtorType = newvalue;
                });
              },
              value: select_debtorType,
              isExpanded: true,
              underline: const SizedBox(),
              hint: Align(
                child: Text(
                  'เลือกประเภทลูกหนี้',
                  style: MyContant().TextInputSelect(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Expanded selectContractStatus(sizeIcon, border) {
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
              items: dropdown_signStatus
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
                  select_signStatus = newvalue;
                });
              },
              value: select_signStatus,
              isExpanded: true,
              underline: const SizedBox(),
              hint: Align(
                child: Text(
                  'เลือกสถานะสัญญา',
                  style: MyContant().TextInputSelect(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Expanded inputContractType(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: TextField(
          controller: itemTypelist,
          readOnly: true,
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

  Expanded inputNameDia(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: searchNameItemtype,
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
  TextEditingController firstnameEm = TextEditingController();
  TextEditingController lastnameEm = TextEditingController();

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
      getData_condition(id, '2', '', firstnameEm.text, lastnameEm.text, offset);
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
    });
    searchData.clear();
    firstnameEm.clear();
    lastnameEm.clear();
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
                  color: const Color.fromRGBO(255, 203, 246, 1),
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
                        children: [
                          Expanded(
                            child: RadioListTile(
                              activeColor: Colors.black,
                              // contentPadding: const EdgeInsets.all(0),
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
                                  // statusLoad404approve = false;
                                  searchData.clear();
                                });
                              },
                              visualDensity:
                                  VisualDensity.compact, // ลด padding รอบ Radio
                              materialTapTargetSize: MaterialTapTargetSize
                                  .shrinkWrap, // ลดขนาด hitbox
                            ),
                          ),
                          Expanded(
                            child: RadioListTile(
                              activeColor: Colors.black,
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
                                  // statusLoad404approve = false;
                                  searchData.clear();
                                });
                              },
                              visualDensity:
                                  VisualDensity.compact, // ลด padding รอบ Radio
                              materialTapTargetSize: MaterialTapTargetSize
                                  .shrinkWrap, // ลดขนาด hitbox
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
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(4),
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
                                          if (selectValue_customer.toString() ==
                                              "2") {
                                            Texthint = 'ชื่อ';
                                          } else {
                                            Texthint = '';
                                          }
                                          // statusLoad404approve = false;
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
                                            255, 203, 246, 1),
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
                            if (firstnameEm.text.isEmpty &&
                                lastnameEm.text.isEmpty) {
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
                        // clearValueDialog();
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
          controller: firstnameEm,
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
          controller: lastnameEm,
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
}

class DistrictList extends StatefulWidget {
  const DistrictList({super.key});

  @override
  State<DistrictList> createState() => _DistrictListState();
}

class _DistrictListState extends State<DistrictList> {
  String userId = '', empId = '', firstName = '', lastName = '', tokenId = '';
  List dropdown_province = [], dropdown_amphoe = [], list_district = [];
  var selectValue_province, selectValue_amphoe;
  String text_province = '', text_amphoe = '';
  bool statusLoading = false, statusLoad404 = false;

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
    getSelectProvince();
    // myScroll(scrollControll, offset);
  }

  Future<void> getSelectProvince() async {
    try {
      var respose = await http.get(
        Uri.parse('${api}setup/provinceList?page=1&limit=100'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> data_provice =
            Map<String, dynamic>.from(json.decode(respose.body));
        setState(() {
          dropdown_province = data_provice['data'];
        });
        statusLoading = true;
      } else if (respose.statusCode == 400) {
        if (!mounted) return;
        showProgressDialog_400(
            context, 'แจ้งเตือน', 'ไม่พบข้อมูล (${respose.statusCode})');
      } else if (respose.statusCode == 401) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.clear();
        if (!mounted) return;
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
        if (!mounted) return;
        showProgressDialog_404(context, 'แจ้งเตือน', 'ไม่พบข้อมูลที่ค้นหา');
      } else if (respose.statusCode == 405) {
        if (!mounted) return;
        showProgressDialog_405(
            context, 'แจ้งเตือน', 'ไม่พบข้อมูล (${respose.statusCode})');
      } else if (respose.statusCode == 500) {
        if (!mounted) return;
        showProgressDialog_500(
            context, 'แจ้งเตือน', 'ข้อมูลผิดพลาด (${respose.statusCode})');
      } else {
        if (!mounted) return;
        showProgressDialog(context, 'แจ้งเตือน', 'กรุณาติดต่อผู้ดูแลระบบ');
      }
    } catch (e) {
      print("ไม่มีข้อมูล $e");
      showProgressDialogNotdata(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด กรุณาแจ้งผู้ดูแลระบบ');
    }
  }

  Future<void> getSelectDistrict() async {
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
    try {
      var respose = await http.get(
        Uri.parse(
            '${api}setup/districtList?pId=${selectValue_province.toString().split("_")[0]}&aId=${selectValue_amphoe.toString().split("_")[0]}'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> data_district =
            Map<String, dynamic>.from(json.decode(respose.body));
        setState(() {
          list_district = data_district['data'];
        });
        statusLoading = true;
        if (!mounted) return;
        // Navigator.pop(context);
        // Navigator.pop(context);
        // searchDistrict(sizeIcon, border);
      } else if (respose.statusCode == 400) {
        if (!mounted) return;
        showProgressDialog_400(
            context, 'แจ้งเตือน', 'ไม่พบข้อมูล (${respose.statusCode})');
      } else if (respose.statusCode == 401) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.clear();
        if (!mounted) return;
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
        if (!mounted) return;
        showProgressDialog_405(
            context, 'แจ้งเตือน', 'ไม่พบข้อมูล (${respose.statusCode})');
      } else if (respose.statusCode == 500) {
        if (!mounted) return;
        showProgressDialog_500(
            context, 'แจ้งเตือน', 'ข้อมูลผิดพลาด (${respose.statusCode})');
      } else {
        if (!mounted) return;
        showProgressDialog(context, 'แจ้งเตือน', 'กรุณาติดต่อผู้ดูแลระบบ!');
      }
    } catch (e) {
      print("ไม่มีข้อมูล $e");
      showProgressDialogNotdata(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
  }

  clearValueSearchDistrict() {
    setState(() {
      selectValue_province = null;
      selectValue_amphoe = null;
      list_district = [];
      dropdown_amphoe = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: 'ค้นหาข้อมูล'),
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
                  color: const Color.fromRGBO(255, 203, 246, 1),
                ),
                padding: const EdgeInsets.all(8),
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
                        children: [
                          Text(
                            'จังหวัด',
                            style: MyContant().h4normalStyle(),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: MediaQuery.of(context).size.width * 0.1,
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 4),
                                  child: DropdownButton(
                                    items: dropdown_province
                                        .map((value) => DropdownMenuItem(
                                              value:
                                                  "${value['id']}_${value['name']}",
                                              child: Text(
                                                value['name'],
                                                style: MyContant()
                                                    .textInputStyle(),
                                              ),
                                            ))
                                        .toList(),
                                    onChanged: (newvalue) async {
                                      list_district = [];
                                      setState(() {
                                        var dfvalue = newvalue;
                                        selectValue_province = dfvalue;
                                        text_province =
                                            dfvalue.toString().split("_")[1];
                                        selectValue_amphoe = null;
                                      });

                                      try {
                                        var respose = await http.get(
                                          Uri.parse(
                                              '${api}setup/amphurList?pId=${selectValue_province.toString().split("_")[0]}'),
                                          headers: <String, String>{
                                            'Content-Type': 'application/json',
                                            'Authorization': tokenId.toString(),
                                          },
                                        );

                                        if (respose.statusCode == 200) {
                                          Map<String, dynamic> data_amphoe =
                                              Map<String, dynamic>.from(
                                                  json.decode(respose.body));
                                          setState(() {
                                            dropdown_amphoe =
                                                data_amphoe['data'];
                                          });
                                        } else if (respose.statusCode == 401) {
                                          SharedPreferences preferences =
                                              await SharedPreferences
                                                  .getInstance();
                                          preferences.clear();
                                          Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const Authen(),
                                            ),
                                            (Route<dynamic> route) => false,
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
                                        showProgressDialogNotdata(
                                            context,
                                            'แจ้งเตือน',
                                            'เกิดข้อผิดพลาด! กรุณาแจ้งผูดูแลระบบ');
                                      }
                                    },
                                    value: selectValue_province,
                                    isExpanded: true,
                                    underline: const SizedBox(),
                                    hint: Align(
                                      child: Text(
                                        'เลือกจังหวัด',
                                        style: MyContant().TextInputSelect(),
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
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: MediaQuery.of(context).size.width * 0.1,
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 4),
                                  child: DropdownButton(
                                    items: dropdown_amphoe
                                        .map((value) => DropdownMenuItem(
                                              value:
                                                  "${value['id']}_${value['name']}",
                                              child: Text(
                                                value['name'],
                                                style: MyContant()
                                                    .textInputStyle(),
                                              ),
                                            ))
                                        .toList(),
                                    onChanged: (newvalue) {
                                      setState(() {
                                        var dfvalue = newvalue;
                                        selectValue_amphoe = dfvalue;
                                        text_amphoe =
                                            dfvalue.toString().split("_")[1];
                                      });
                                      list_district = [];
                                    },
                                    value: selectValue_amphoe,
                                    isExpanded: true,
                                    underline: const SizedBox(),
                                    hint: Align(
                                      child: Text(
                                        'เลือกอำเภอ',
                                        style: MyContant().TextInputSelect(),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
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
                          physics: const BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics(),
                          ),
                          child: Column(
                            children: [
                              for (var i = 0; i < list_district.length; i++)
                                InkWell(
                                  onTap: () {
                                    
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 8),
                                    child: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        color: const Color.fromRGBO(
                                            255, 218, 249, 1),
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
                                          color:
                                              Colors.white.withValues(alpha: 0.7),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  'จังหวัด : ',
                                                  style:
                                                      MyContant().h4normalStyle(),
                                                ),
                                                Text(
                                                  text_province,
                                                  style:
                                                      MyContant().h4normalStyle(),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'อำเภอ : ',
                                                  style:
                                                      MyContant().h4normalStyle(),
                                                ),
                                                Text(
                                                  text_amphoe,
                                                  style:
                                                      MyContant().h4normalStyle(),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'ตำบล : ',
                                                  style:
                                                      MyContant().h4normalStyle(),
                                                ),
                                                Text(
                                                  '${list_district[i]['name']}',
                                                  style:
                                                      MyContant().h4normalStyle(),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              const SizedBox(height: 40)
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
                          if (selectValue_province == null) {
                            showProgressDialog(
                                context, 'แจ้งเตือน', 'กรุณาเลือกจังหวัด');
                          } else if (selectValue_amphoe == null) {
                            showProgressDialog(
                                context, 'แจ้งเตือน', 'กรุณาเลือกอำเภอ');
                          } else {
                            getSelectDistrict();
                            statusLoading = false;
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
                        setState(() {
                          clearValueSearchDistrict();
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
}
