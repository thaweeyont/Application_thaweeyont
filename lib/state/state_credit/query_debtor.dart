import 'dart:convert';
import 'dart:math';

import 'package:application_thaweeyont/widgets/show_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/login_model.dart';
import '../authen.dart';
import 'data_searchdebtor.dart';
import 'package:application_thaweeyont/utility/my_constant.dart';
import 'package:application_thaweeyont/api.dart';

class Query_debtor extends StatefulWidget {
  const Query_debtor({Key? key}) : super(key: key);

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

  String? id = '1';
  var filter = false;
  TextEditingController idcard = TextEditingController();
  TextEditingController firstname_c = TextEditingController();
  TextEditingController lastname_c = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController district = TextEditingController();
  TextEditingController amphoe = TextEditingController();
  TextEditingController provincn = TextEditingController();
  TextEditingController searchNameItemtype = TextEditingController();
  TextEditingController itemTypelist = TextEditingController();
  TextEditingController homeNo = TextEditingController();
  TextEditingController moo = TextEditingController();
  TextEditingController telephone = TextEditingController();
  TextEditingController signId = TextEditingController();
  TextEditingController searchData = TextEditingController();
  TextEditingController firstname_em = TextEditingController();
  TextEditingController lastname_em = TextEditingController();
  TextEditingController custId = TextEditingController();

  bool st_customer = true, st_employee = false;
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

  var selectValue_customer, valueNotdata, Texthint;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      id = '1';
    });
    getdata();
  }

  Future<void> getData_debtorList() async {
    var signStatus, branch, debtorType, tumbol, amphur, province;
    if (select_signStatus == null) {
      signStatus = '';
    } else {
      signStatus = select_signStatus;
    }

    if (select_branchlist == null) {
      branch = '';
    } else {
      branch = select_branchlist;
    }

    if (select_debtorType == null) {
      debtorType = '';
    } else {
      debtorType = select_debtorType;
    }

    if (tumbolId == null) {
      tumbol = '';
      amphur = '';
      province = '';
    } else {
      tumbol = tumbolId;
      amphur = selectValue_amphoe.toString().split("_")[0];
      province = selectValue_province.toString().split("_")[0];
    }

    print(tokenId);
    print(firstname_c.text);
    print(lastname.text);
    print(select_addreessType.toString());
    list_dataDebtor = [];
    try {
      var respose = await http.post(
        Uri.parse('${api}debtor/list'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
        body: jsonEncode(<String, String>{
          'custId': custId.text,
          'homeNo': homeNo.text,
          'moo': moo.text,
          'tumbolId': tumbol.toString(),
          'amphurId': amphur.toString(),
          'provId': province.toString(),
          'firstName': firstname_c.text,
          'lastName': lastname_c.text,
          'addressType': select_addreessType.toString(),
          'debtorType': debtorType.toString(),
          'smartId': idcard.text,
          'telephone': telephone.text,
          'branchId': branch.toString(),
          'signId': signId.text,
          'signStatus': signStatus.toString(),
          'itemType': itemTypelist.text,
          'page': '1',
          'limit': '20'
        }),
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> datadebtorList =
            new Map<String, dynamic>.from(json.decode(respose.body));

        setState(() {
          list_dataDebtor = datadebtorList['data'];
        });
        Navigator.pop(context);

        print(list_dataDebtor);
      } else if (respose.statusCode == 400) {
        print(respose.statusCode);
        showProgressDialog_400(context, 'แจ้งเตือน', 'ไม่พบข้อมูล!');
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
            context, 'แจ้งเตือน', 'Error ${respose.statusCode} ไม่พบข้อมูล!');
      } else if (respose.statusCode == 405) {
        print(respose.statusCode);
        showProgressDialog_405(context, 'แจ้งเตือน', 'ไม่พบข้อมูล!');
      } else if (respose.statusCode == 500) {
        print(respose.statusCode);
        showProgressDialog_500(
            context, 'แจ้งเตือน', 'Error ${respose.statusCode} ข้อมูลผิดพลาด!');
      } else {
        setState(() {
          debtorStatuscode = respose.statusCode;
        });
        Navigator.pop(context);
        // print(respose.body);
        // print(respose.statusCode);
        // print('ไม่พบข้อมูล');
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
      Navigator.pop(context);
      print("ไม่มีข้อมูล $e");
      showProgressDialog(context, 'แจ้งเตือน', 'ไม่พบข้อมูล!');
    }
  }

  Future<void> get_select_province() async {
    print(tokenId);
    try {
      var respose = await http.get(
        Uri.parse('${api}setup/provinceList?page=1&limit=100'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
        // body: jsonEncode(<String, String>{'page': '1', 'limit': '100'}),
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> data_provice =
            new Map<String, dynamic>.from(json.decode(respose.body));
        setState(() {
          dropdown_province = data_provice['data'];
        });

        // print(data_provice['data']);
        print(dropdown_province);
      } else if (respose.statusCode == 400) {
        print(respose.statusCode);
        showProgressDialog_400(
            context, 'แจ้งเตือน', 'Error ${respose.statusCode} ไม่พบข้อมูล!');
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
            context, 'แจ้งเตือน', 'Error ${respose.statusCode} ไม่พบข้อมูล!');
      } else if (respose.statusCode == 405) {
        print(respose.statusCode);
        showProgressDialog_405(context, 'แจ้งเตือน', 'ไม่พบข้อมูล!');
      } else if (respose.statusCode == 500) {
        print(respose.statusCode);
        showProgressDialog_500(
            context, 'แจ้งเตือน', 'Error ${respose.statusCode} ข้อมูลผิดพลาด!');
      } else {
        print(respose.statusCode);
      }
    } catch (e) {
      print("ไม่มีข้อมูล $e");
      showProgressDialog(context, 'แจ้งเตือน', 'ไม่พบข้อมูล!');
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
            '${api}setup/districtList?pId=${selectValue_province.toString().split("_")[0]}&aId=${selectValue_amphoe.toString().split("_")[0]}'),
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
        print(data_district['data']);
      } else if (respose.statusCode == 400) {
        print(respose.statusCode);
        showProgressDialog_400(
            context, 'แจ้งเตือน', 'Error ${respose.statusCode} ไม่พบข้อมูล!');
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
            context, 'แจ้งเตือน', 'Error ${respose.statusCode} ไม่พบข้อมูล!');
      } else if (respose.statusCode == 405) {
        print(respose.statusCode);
        showProgressDialog_405(context, 'แจ้งเตือน', 'ไม่พบข้อมูล!');
      } else if (respose.statusCode == 500) {
        print(respose.statusCode);
        showProgressDialog_500(
            context, 'แจ้งเตือน', 'Error ${respose.statusCode} ข้อมูลผิดพลาด!');
      } else {
        Navigator.pop(context);
        print(respose.statusCode);
      }
    } catch (e) {
      // Navigator.pop(context);
      print("ไม่มีข้อมูล $e");
      showProgressDialog(context, 'แจ้งเตือน', 'ไม่พบข้อมูล!');
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
    get_select_province();
    get_select_addressTypelist();
    get_select_branch();
    get_select_debtorType();
    get_select_signStatus();
  }

  Future<void> get_itemTypelist() async {
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
    print(searchNameItemtype.text);
    print(tokenId);
    try {
      var respose = await http.get(
        Uri.parse(
            '${api}setup/itemTypeList?searchName=${searchNameItemtype.text}&page=1&limit=50'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
        // body: jsonEncode(<String, String>{'page': '1', 'limit': '100'}),
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> data_itemTypelist =
            new Map<String, dynamic>.from(json.decode(respose.body));
        setState(() {
          list_itemType = data_itemTypelist['data'];
        });

        Navigator.pop(context);
        Navigator.pop(context);
        search_conType(sizeIcon, border);
        // print(data_provice['data']);
        print(list_itemType);
      } else if (respose.statusCode == 400) {
        print(respose.statusCode);
        showProgressDialog_400(
            context, 'แจ้งเตือน', 'Error ${respose.statusCode} ไม่พบข้อมูล!');
      } else if (respose.statusCode == 401) {
        print(respose.statusCode);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => Authen(),
          ),
          (Route<dynamic> route) => false,
        );
      } else if (respose.statusCode == 404) {
        print(respose.statusCode);
        showProgressDialog_404(
            context, 'แจ้งเตือน', 'Error ${respose.statusCode} ถูกยกเลิกสัญญา');
      } else if (respose.statusCode == 405) {
        print(respose.statusCode);
        showProgressDialog_405(context, 'แจ้งเตือน', 'ไม่พบข้อมูล!');
      } else if (respose.statusCode == 500) {
        print(respose.statusCode);
        showProgressDialog_500(
            context, 'แจ้งเตือน', 'Error ${respose.statusCode} ไม่พบข้อมูล!');
      } else {
        setState(() {
          checkStatuscode = respose.statusCode;
        });
        Navigator.pop(context);
        print(respose.statusCode);
      }
    } catch (e) {
      // Navigator.pop(context);
      print("ไม่มีข้อมูล $e");
      showProgressDialog_Notdata(context, 'แจ้งเตือน', 'ไม่พบข้อมูล!');
    }
  }

  Future<void> get_select_addressTypelist() async {
    print(tokenId);
    try {
      var respose = await http.get(
        Uri.parse('${api}setup/addressTypeList'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
        // body: jsonEncode(<String, String>{'page': '1', 'limit': '100'}),
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> data_addressTypelist =
            new Map<String, dynamic>.from(json.decode(respose.body));
        setState(() {
          dropdown_addresstype = data_addressTypelist['data'];
          select_addreessType = dropdown_addresstype[0]['id'];
        });

        print(select_addreessType);
      } else {
        print(respose.statusCode);
      }
    } catch (e) {
      print("ไม่มีข้อมูล $e");
    }
  }

  Future<void> get_select_branch() async {
    print(tokenId);
    try {
      var respose = await http.get(
        Uri.parse('${api}setup/branchList'),
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

  Future<void> get_select_debtorType() async {
    print(tokenId);
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
            new Map<String, dynamic>.from(json.decode(respose.body));
        setState(() {
          dropdown_debtorType = data_debtorType['data'];
        });
        print(respose.statusCode);
        print(dropdown_debtorType);
      } else {
        print(respose.statusCode);
      }
    } catch (e) {
      print("ไม่มีข้อมูล $e");
    }
  }

  Future<void> get_select_signStatus() async {
    print(tokenId);
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
            new Map<String, dynamic>.from(json.decode(respose.body));
        setState(() {
          dropdown_signStatus = data_signStatusList['data'];
        });

        print(dropdown_signStatus);
      } else if (respose.statusCode == 401) {
        print('signStatus >>${respose.statusCode}');
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
      } else {
        print(respose.statusCode);
      }
    } catch (e) {
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

  clearTextInputAll() {
    custId.clear();
    idcard.clear();
    firstname_c.clear();
    lastname.clear();
    telephone.clear();
    homeNo.clear();
    moo.clear();
    district.clear();
    amphoe.clear();
    provincn.clear();
    signId.clear();
    itemTypelist.clear();
    setState(() {
      select_debtorType = null;
      select_signStatus = null;
      select_branchlist = null;
      // select_addreessType = dropdown_addresstype[0]['id'];
      list_dataDebtor = [];
      debtorStatuscode = null;
    });
  }

  clearValue_search_district() {
    setState(() {
      selectValue_province = null;
      selectValue_amphoe = null;
      list_district = [];
    });
  }

  clearValue_search_conType() {
    setState(() {
      list_itemType = [];
    });
    searchNameItemtype.clear();
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
                                  BorderRadius.all(Radius.circular(10)),
                              color: Color.fromRGBO(255, 218, 249, 1),
                            ),
                            padding: EdgeInsets.all(8),
                            width: double.infinity,
                            child: Column(children: [
                              // Row(
                              //   children: [
                              //     Text(
                              //       'ภาค',
                              //       style: MyContant().h4normalStyle(),
                              //     ),
                              //     select_sectorDia(context, setState),
                              //   ],
                              // ),
                              Row(
                                children: [
                                  Text(
                                    'จังหวัด',
                                    style: MyContant().h4normalStyle(),
                                  ),
                                  // select_provincnDia(context, setState),
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
                                              setState(() {
                                                var dfvalue = newvalue;

                                                selectValue_province = dfvalue;
                                                text_province = dfvalue
                                                    .toString()
                                                    .split("_")[1];
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
                                                  // body: jsonEncode(<String, String>{'page': '1', 'limit': '100'}),
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
                                                  print(data_amphoe['data']);
                                                } else if (respose.statusCode ==
                                                    401) {
                                                  print(
                                                      'จังหวัด >>${respose.statusCode}');
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
                                              provincn.text = '$text_province';
                                              tumbolId =
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
                                                255, 218, 249, 1),
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

  // Expanded select_amphoeDia(BuildContext context, StateSetter setState) {
  //   return Expanded(
  //     child: Padding(
  //       padding: const EdgeInsets.all(8.0),
  //       child: Container(
  //         height: MediaQuery.of(context).size.width * 0.07,
  //         padding: EdgeInsets.all(4),
  //         decoration: BoxDecoration(
  //             color: Colors.white, borderRadius: BorderRadius.circular(5)),
  //         child: DropdownButton(
  //           items: dropdownamphoe
  //               .map((value) => DropdownMenuItem(
  //                     child: Text(
  //                       value,
  //                       style: TextStyle(fontSize: 14, color: Colors.black),
  //                     ),
  //                     value: value,
  //                   ))
  //               .toList(),
  //           onChanged: (selected_Amphoe) {
  //             setState(() {
  //               selectamphoe = selected_Amphoe;
  //             });
  //           },
  //           value: selectamphoe,
  //           isExpanded: true,
  //           underline: SizedBox(),
  //           hint: Align(
  //             child: Text(
  //               'เลือกอำเภอ',
  //               style: TextStyle(
  //                   fontSize: 14, color: Color.fromRGBO(106, 106, 106, 1)),
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Expanded select_provincnDia(BuildContext context, StateSetter setState) {
  //   return Expanded(
  //     child: Padding(
  //       padding: const EdgeInsets.all(8.0),
  //       child: Container(
  //         height: MediaQuery.of(context).size.width * 0.07,
  //         padding: EdgeInsets.all(4),
  //         decoration: BoxDecoration(
  //             color: Colors.white, borderRadius: BorderRadius.circular(5)),
  //         child: DropdownButton(
  //           items: dropdownprovince
  //               .map((value) => DropdownMenuItem(
  //                     child: Text(
  //                       value,
  //                       style: TextStyle(fontSize: 14, color: Colors.black),
  //                     ),
  //                     value: value,
  //                   ))
  //               .toList(),
  //           onChanged: (selected_Provincn) {
  //             setState(() {
  //               selectprovince = selected_Provincn;
  //             });
  //           },
  //           value: selectprovince,
  //           isExpanded: true,
  //           underline: SizedBox(),
  //           hint: Align(
  //             child: Text(
  //               'เลือกจังหวัด',
  //               style: TextStyle(
  //                   fontSize: 14, color: Color.fromRGBO(106, 106, 106, 1)),
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Expanded select_sectorDia(BuildContext context, StateSetter setState) {
  //   return Expanded(
  //     child: Padding(
  //       padding: const EdgeInsets.all(8.0),
  //       child: Container(
  //         height: MediaQuery.of(context).size.width * 0.07,
  //         padding: EdgeInsets.all(4),
  //         decoration: BoxDecoration(
  //             color: Colors.white, borderRadius: BorderRadius.circular(5)),
  //         child: DropdownButton(
  //           items: dropdownsector
  //               .map((value) => DropdownMenuItem(
  //                     child: Text(
  //                       value,
  //                       style: TextStyle(fontSize: 14, color: Colors.black),
  //                     ),
  //                     value: value,
  //                   ))
  //               .toList(),
  //           onChanged: (selected_Sector) {
  //             setState(() {
  //               selectsector = selected_Sector;
  //             });
  //           },
  //           value: selectsector,
  //           isExpanded: true,
  //           underline: SizedBox(),
  //           hint: Align(
  //             child: Text(
  //               'เลือกภาค',
  //               style: TextStyle(
  //                   fontSize: 14, color: Color.fromRGBO(106, 106, 106, 1)),
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Future<Null> search_conType(sizeIcon, border) async {
    double size = MediaQuery.of(context).size.width;
    // bool btn_edit = false;
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
                                        clearValue_search_conType();
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
                              color: Color.fromRGBO(255, 218, 249, 1),
                            ),
                            padding: EdgeInsets.all(8),
                            width: double.infinity,
                            child: Column(children: [
                              Row(
                                children: [
                                  Text(
                                    'ชื่อประเภท',
                                    style: MyContant().h4normalStyle(),
                                  ),
                                  input_nameDia(sizeIcon, border),
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
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    color: Color.fromRGBO(76, 83, 146, 1),
                                  ),
                                  child: TextButton(
                                    style: MyContant().myButtonSearchStyle(),
                                    onPressed: () {
                                      if (searchNameItemtype.text.isEmpty) {
                                        showProgressDialog(context, 'แจ้งเตือน',
                                            'กรุณากรอกชื่อประเภท');
                                      } else {
                                        showProgressLoading(context);
                                        get_itemTypelist();
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
                                                255, 218, 249, 1),
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
                                              SizedBox(height: 5),
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
                                    ],
                                  ] else ...[
                                    if (checkStatuscode == 404) ...[
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
                                                  'ไม่พบข้อมูล',
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
              new Map<String, dynamic>.from(json.decode(respose.body));

          setState(() {
            list_datavalue = dataList['data'];
          });
          print(respose.statusCode);
          Navigator.pop(context);
          Navigator.pop(context);
          search_idcustomer();
        } else if (respose.statusCode == 400) {
          print(respose.statusCode);
          showProgressDialog_400(
              context, 'แจ้งเตือน', 'Error ${respose.statusCode} ไม่พบข้อมูล!');
        } else if (respose.statusCode == 401) {
          print('${respose.statusCode}');
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
              context, 'แจ้งเตือน', 'Error ${respose.statusCode} ไม่พบข้อมูล');
        } else if (respose.statusCode == 405) {
          print(respose.statusCode);
          showProgressDialog_405(context, 'แจ้งเตือน', 'ไม่พบข้อมูล!');
        } else if (respose.statusCode == 500) {
          print(respose.statusCode);
          showProgressDialog_500(context, 'แจ้งเตือน',
              'Error ${respose.statusCode} ข้อมูลผิดพลาด!');
        }
        // else {
        //   setState(() {
        //     valueNotdata = respose.statusCode;
        //   });
        //   Navigator.pop(context);
        //   print(respose.statusCode);
        //   print('ไม่พบข้อมูล');
        // Map<String, dynamic> check_list =
        //     new Map<String, dynamic>.from(json.decode(respose.body));
        // print(respose.statusCode);
        // print(check_list['message']);
        // if (check_list['message'] == "Token Unauthorized") {
        //   SharedPreferences preferences =
        //       await SharedPreferences.getInstance();
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
        // Navigator.pop(context);
        print("ไม่มีข้อมูล $e");
        showProgressDialog_Notdata(context, 'แจ้งเตือน', 'ไม่พบข้อมูล!');
      }
    }

    Future<Null> getData_search() async {
      if (id == '1') {
        print(id);
        list_datavalue = [];
        showProgressLoading(context);
        if (selectValue_customer.toString() == "2") {
          getData_condition(
              id, selectValue_customer, '', searchData.text, lastname.text);
        } else {
          list_datavalue = [];
          getData_condition(id, selectValue_customer, searchData.text, '', '');
        }
      } else {
        print(id);
        list_datavalue = [];
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
                              color: Color.fromRGBO(255, 218, 249, 1),
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
                                              // custName.text =
                                              //     list_datavalue[i]['custName'];
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
                                            color: Color.fromRGBO(
                                                255, 218, 249, 1),
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
                                  ],
                                  // else ...[
                                  //   if (valueNotdata == 404) ...[
                                  //     notData(context),
                                  //   ] else
                                  //     ...[],
                                  // ],
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
        child: ListView(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Color.fromRGBO(255, 218, 249, 1),
              ),
              width: double.infinity,
              // height: 250,
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
                            color: Color.fromRGBO(202, 71, 150, 1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'เลขบัตรประชาชน',
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
                      input_name(sizeIcon, border),
                      Text(
                        'นามสกุล',
                        style: MyContant().h4normalStyle(),
                      ),
                      input_lastname(sizeIcon, border),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'เลขที่สัญญา',
                        style: MyContant().h4normalStyle(),
                      ),
                      input_signId(sizeIcon, border),
                    ],
                  ),
                  if (filter == true) ...[
                    Row(
                      children: [
                        Text(
                          'เบอร์โทร',
                          style: MyContant().h4normalStyle(),
                        ),
                        input_tel(sizeIcon, border),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'ค้นหาจาก',
                          style: MyContant().h4normalStyle(),
                        ),
                        select_search(sizeIcon, border),
                      ],
                    ),
                    line(),
                    Row(
                      children: [
                        Text(
                          'บ้านเลขที่',
                          style: MyContant().h4normalStyle(),
                        ),
                        input_numberhome(sizeIcon, border),
                        Text(
                          'หมู่',
                          style: MyContant().h4normalStyle(),
                        ),
                        input_moo(sizeIcon, border),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'ตำบล',
                          style: MyContant().h4normalStyle(),
                        ),
                        input_district(sizeIcon, border),
                        InkWell(
                          onTap: () {
                            search_district(sizeIcon, border);
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
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'อำเภอ',
                          style: MyContant().h4normalStyle(),
                        ),
                        input_amphoe(sizeIcon, border),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'จังหวัด',
                          style: MyContant().h4normalStyle(),
                        ),
                        input_province(sizeIcon, border),
                      ],
                    ),
                    line(),
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
                          'ประเภทลูกหนี้ ',
                          style: MyContant().h4normalStyle(),
                        ),
                        select_debtorTypelist(sizeIcon, border),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'สถานะสัญญา',
                          style: MyContant().h4normalStyle(),
                        ),
                        select_contractStatus(sizeIcon, border),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'ประเภทสัญญา',
                          style: MyContant().h4normalStyle(),
                        ),
                        input_contractType(sizeIcon, border),
                        InkWell(
                          onTap: () {
                            search_conType(sizeIcon, border);
                          },
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(202, 71, 150, 1),
                                shape: BoxShape.circle),
                            child: Icon(
                              Icons.search,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
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
          Container(
            height: MediaQuery.of(context).size.height * 0.6,
            child: Scrollbar(
              child: ListView(
                children: [
                  if (list_dataDebtor.isNotEmpty) ...[
                    for (var i = 0; i < list_dataDebtor.length; i++) ...[
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Data_SearchDebtor(
                                    list_dataDebtor[i]['signId'],
                                    list_dataDebtor[i]['signStatusName'])),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 5),
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              color: Color.fromRGBO(255, 218, 249, 1),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'รหัสเขต : ${list_dataDebtor[i]['followAreaName']}',
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
                                      'เลขที่สัญญา : ${list_dataDebtor[i]['signId']}',
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
                                      'ชื่อลูกค้าในสัญญา : ${list_dataDebtor[i]['custName']}',
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
                                      'เลขบัตรประชาชน : ${list_dataDebtor[i]['smartId']}',
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
                                      'ชื่อลูกค้าปัจจุบัน : ${list_dataDebtor[i]['custSignName']}',
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
                                        '${list_dataDebtor[i]['itemName']}',
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
                                      'สถานะสัญญา : ${list_dataDebtor[i]['signStatusName']}',
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
                  // else ...[
                  //   if (debtorStatuscode == 404 || debtorStatuscode == 500) ...[
                  //     notData(context),
                  //   ] else
                  //     ...[],
                  // ],
                ],
              ),
            ),
          ),
          SizedBox(
            height: 25,
          ),
        ]),
      ),
    );
  }

  Padding group_btnsearch() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
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
                  child: Container(
                    child: Row(
                      children: [
                        Text(
                          'ค้นหาแบบละเอียด',
                          style: MyContant().TextsearchStyle(),
                        ),
                        if (filter == true) ...[
                          Icon(Icons.arrow_drop_up),
                        ] else ...[
                          Icon(Icons.arrow_drop_down),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Row(
                  children: [
                    Container(
                      height: 30,
                      child: TextButton(
                        style: MyContant().myButtonSearchStyle(),
                        onPressed: () {
                          showProgressLoading(context);
                          getData_debtorList();
                        },
                        child: const Text('ค้นหา'),
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      height: 30,
                      child: TextButton(
                        style: MyContant().myButtonCancelStyle(),
                        onPressed: clearTextInputAll,
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

  Padding line() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 5,
        width: double.infinity,
        child: Divider(
          color: Color.fromARGB(255, 34, 34, 34),
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
          maxLength: 13,
          onChanged: (keyword) {},
          decoration: InputDecoration(
            counterText: "",
            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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

  Expanded input_name(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: firstname_c,
          onChanged: (keyword) {},
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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

  Expanded input_lastname(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: lastname_c,
          onChanged: (keyword) {},
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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

  Expanded input_tel(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: telephone,
          maxLength: 10,
          keyboardType: TextInputType.number,
          onChanged: (keyword) {},
          decoration: InputDecoration(
            counterText: "",
            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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

  Expanded select_search(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: MediaQuery.of(context).size.width * 0.08,
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 4),
            child: DropdownButton(
              items: dropdown_addresstype
                  .map((value) => DropdownMenuItem(
                        child: Text(
                          value['name'],
                          style: MyContant().h4normalStyle(),
                        ),
                        value: value['id'],
                      ))
                  .toList(),
              onChanged: (newvalue) {
                setState(() {
                  select_addreessType = newvalue;
                });
              },
              value: select_addreessType,
              isExpanded: true,
              underline: SizedBox(),
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

  Expanded input_numberhome(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: homeNo,
          onChanged: (keyword) {},
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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

  Expanded input_moo(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: moo,
          onChanged: (keyword) {},
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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

  Expanded input_district(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: district,
          readOnly: true,
          onChanged: (keyword) {},
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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

  Expanded input_amphoe(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: amphoe,
          readOnly: true,
          onChanged: (keyword) {},
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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

  Expanded input_province(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: provincn,
          readOnly: true,
          onChanged: (keyword) {},
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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

  Expanded input_signId(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: signId,
          onChanged: (keyword) {},
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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

  Expanded select_debtorTypelist(sizeIcon, border) {
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
              items: dropdown_debtorType
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
                  select_debtorType = newvalue;
                });
              },
              value: select_debtorType,
              isExpanded: true,
              underline: SizedBox(),
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

  Expanded select_contractStatus(sizeIcon, border) {
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
              items: dropdown_signStatus
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
                  select_signStatus = newvalue;
                });
              },
              value: select_signStatus,
              isExpanded: true,
              underline: SizedBox(),
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

  Expanded input_contractType(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: itemTypelist,
          readOnly: true,
          onChanged: (keyword) {},
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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

  Expanded input_nameDia(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: searchNameItemtype,
          onChanged: (keyword) {},
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
