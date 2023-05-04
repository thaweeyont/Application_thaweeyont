import 'dart:convert';

import 'package:application_thaweeyont/utility/my_constant.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../api.dart';
import '../../authen.dart';
import 'list_credit_querydebtor.dart';

class CreditQueryDebtor extends StatefulWidget {
  // const CreditQueryDebtor(valueapprove, {Key? key}) : super(key: key);
  final String? address, homeNo, moo, provId, amphurId, tunbolId;
  CreditQueryDebtor(
    this.address,
    this.homeNo,
    this.moo,
    this.provId,
    this.amphurId,
    this.tunbolId,
  );

  @override
  State<CreditQueryDebtor> createState() => _CreditQueryDebtorState();
}

class _CreditQueryDebtorState extends State<CreditQueryDebtor> {
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

  bool st_customer = true,
      st_employee = false,
      statusLoad404itemTypeList = false,
      statusLoad404 = false;
  List dropdown_province = [], list_dataDebtor = [];
  List drProvince = [], drAmphur = [], drTumbol = [];
  List dropdown_amphoe = [],
      dropdown_addresstype = [],
      dropdown_branch = [],
      dropdown_debtorType = [],
      dropdown_signStatus = [],
      dropdown_customer = [];
  List list_district = [], list_itemType = [], list_datavalue = [];

  var selectValue_province,
      selectValue_amphoe,
      select_addreessType,
      select_branchlist,
      select_debtorType,
      select_signStatus,
      debtorStatuscode,
      tumbolId,
      itemType;

  var selectValue_customer, valueNotdata, Texthint, text_search;
  var signStatus, branch, debtorType, tumbol, amphur, province;
  var selectProvince, selectAmphur, selectTumbol;

  @override
  void initState() {
    super.initState();
    setState(() {
      id = '1';
    });
    getdata();
    print('sp>>$selectValue_province');
    print('sa>>$selectValue_amphoe');
    print('st>>$tumbolId');
    print('address>>${widget.address}');
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
    homeNo.text = widget.homeNo.toString();
    moo.text = widget.moo.toString();
    selectProvince = widget.provId.toString();
    selectAmphur = widget.amphurId.toString();
    selectTumbol = widget.tunbolId.toString();
    print('p>$selectProvince');
    print('a>$selectAmphur');
    print('t>$selectTumbol');
    get_province();
    get_amphor();
    get_district();
    get_select_province();
    get_select_addressTypelist();
    get_select_branch();
    get_select_debtorType();
    get_select_signStatus();
    get_select_cus();
  }

  Future<void> get_select_province() async {
    print(tokenId);
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

        print('จ.->${dropdown_province}');
      } else if (respose.statusCode == 400) {
        print(respose.statusCode);
        showProgressDialog_400(
            context, 'แจ้งเตือน', 'ไม่พบข้อมูล (${respose.statusCode})');
      } else if (respose.statusCode == 401) {
        print('error =>> ${respose.statusCode}');
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
        print(respose.statusCode);
        showProgressDialog_404(context, 'แจ้งเตือน', 'ไม่พบข้อมูลที่ค้นหา');
      } else if (respose.statusCode == 405) {
        print(respose.statusCode);
        showProgressDialog_405(
            context, 'แจ้งเตือน', 'ไม่พบข้อมูล (${respose.statusCode})');
      } else if (respose.statusCode == 500) {
        print(respose.statusCode);
        showProgressDialog_500(
            context, 'แจ้งเตือน', 'ข้อมูลผิดพลาด (${respose.statusCode})');
      } else {
        print(respose.statusCode);
        showProgressDialog(context, 'แจ้งเตือน', 'กรุณาติดต่อผู้ดูแลระบบ');
      }
    } catch (e) {
      print("ไม่มีข้อมูล $e");
      showProgressDialog_Notdata(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด กรุณาแจ้งผู้ดูแลระบบ');
    }
  }

  Future<void> get_province() async {
    print(tokenId);
    try {
      var respose = await http.get(
        Uri.parse('${beta_api_test}setup/provinceList?page=1&limit=100'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> dataProvice =
            new Map<String, dynamic>.from(json.decode(respose.body));

        setState(() {
          drProvince = dataProvice['data'];
          provincn.text = drProvince
              .where((element) => element['id'] == selectProvince)
              .first['name']
              .toString();
        });

        print('จจ.->${drProvince}');
      } else if (respose.statusCode == 400) {
        print(respose.statusCode);
        showProgressDialog_400(
            context, 'แจ้งเตือน', 'ไม่พบข้อมูล (${respose.statusCode})');
      } else if (respose.statusCode == 401) {
        print('error =>> ${respose.statusCode}');
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
        print(respose.statusCode);
        showProgressDialog_404(context, 'แจ้งเตือน', 'ไม่พบข้อมูลที่ค้นหา');
      } else if (respose.statusCode == 405) {
        print(respose.statusCode);
        showProgressDialog_405(
            context, 'แจ้งเตือน', 'ไม่พบข้อมูล (${respose.statusCode})');
      } else if (respose.statusCode == 500) {
        print(respose.statusCode);
        showProgressDialog_500(
            context, 'แจ้งเตือน', 'ข้อมูลผิดพลาด (${respose.statusCode})');
      } else {
        print(respose.statusCode);
        showProgressDialog(context, 'แจ้งเตือน', 'กรุณาติดต่อผู้ดูแลระบบ');
      }
    } catch (e) {
      print("ไม่มีข้อมูล $e");
      showProgressDialog_Notdata(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด กรุณาแจ้งผู้ดูแลระบบ');
    }
  }

  Future<void> get_amphor() async {
    print(tokenId);
    try {
      var respose = await http.get(
        Uri.parse(
            '${beta_api_test}setup/amphurList?pId=${selectProvince.toString().split("_")[0]}'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> dataAmphur =
            new Map<String, dynamic>.from(json.decode(respose.body));
        setState(() {
          drAmphur = dataAmphur['data'];
          amphoe.text = drAmphur
              .where((element) => element['id'] == selectAmphur)
              .first['name']
              .toString();
        });

        print('อ.->${drAmphur}');
      } else if (respose.statusCode == 400) {
        print(respose.statusCode);
        showProgressDialog_400(
            context, 'แจ้งเตือน', 'ไม่พบข้อมูล (${respose.statusCode})');
      } else if (respose.statusCode == 401) {
        print('error =>> ${respose.statusCode}');
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
        print(respose.statusCode);
        showProgressDialog_404(context, 'แจ้งเตือน', 'ไม่พบข้อมูลที่ค้นหา');
      } else if (respose.statusCode == 405) {
        print(respose.statusCode);
        showProgressDialog_405(
            context, 'แจ้งเตือน', 'ไม่พบข้อมูล (${respose.statusCode})');
      } else if (respose.statusCode == 500) {
        print(respose.statusCode);
        showProgressDialog_500(
            context, 'แจ้งเตือน', 'ข้อมูลผิดพลาด (${respose.statusCode})');
      } else {
        print(respose.statusCode);
        showProgressDialog(context, 'แจ้งเตือน', 'กรุณาติดต่อผู้ดูแลระบบ');
      }
    } catch (e) {
      print("ไม่มีข้อมูล $e");
      showProgressDialog_Notdata(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด กรุณาแจ้งผู้ดูแลระบบ');
    }
  }

  Future<void> get_district() async {
    try {
      var respose = await http.get(
        Uri.parse(
            '${beta_api_test}setup/districtList?pId=${selectProvince.toString().split("_")[0]}&aId=${selectAmphur.toString().split("_")[0]}'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> dataTumbol =
            new Map<String, dynamic>.from(json.decode(respose.body));
        setState(() {
          drTumbol = dataTumbol['data'];
          district.text = drTumbol
              .where((element) => element['id'] == selectTumbol)
              .first['name']
              .toString();
        });

        print('ต.->${drTumbol}');
      } else if (respose.statusCode == 400) {
        print(respose.statusCode);
        showProgressDialog_400(
            context, 'แจ้งเตือน', 'ไม่พบข้อมูล (${respose.statusCode})');
      } else if (respose.statusCode == 401) {
        print('select_district >>${respose.statusCode}');
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
        print(respose.statusCode);
        showProgressDialog_404(context, 'แจ้งเตือน', 'ไม่พบข้อมูลที่ค้นหา');
      } else if (respose.statusCode == 405) {
        print(respose.statusCode);
        showProgressDialog_405(
            context, 'แจ้งเตือน', 'ไม่พบข้อมูล (${respose.statusCode})');
      } else if (respose.statusCode == 500) {
        print(respose.statusCode);
        showProgressDialog_500(
            context, 'แจ้งเตือน', 'ข้อมูลผิดพลาด (${respose.statusCode})');
      } else {
        print(respose.statusCode);
        showProgressDialog(context, 'แจ้งเตือน', 'กรุณาติดต่อผู้ดูแลระบบ!');
      }
    } catch (e) {
      print("ไม่มีข้อมูล $e");
      showProgressDialog_Notdata(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
  }

  Future<void> get_select_district() async {
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
        print(data_district['data']);
      } else if (respose.statusCode == 400) {
        print(respose.statusCode);
        showProgressDialog_400(
            context, 'แจ้งเตือน', 'ไม่พบข้อมูล (${respose.statusCode})');
      } else if (respose.statusCode == 401) {
        print('select_district >>${respose.statusCode}');
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
        print(respose.statusCode);
        showProgressDialog_404(context, 'แจ้งเตือน', 'ไม่พบข้อมูลที่ค้นหา');
      } else if (respose.statusCode == 405) {
        print(respose.statusCode);
        showProgressDialog_405(
            context, 'แจ้งเตือน', 'ไม่พบข้อมูล (${respose.statusCode})');
      } else if (respose.statusCode == 500) {
        print(respose.statusCode);
        showProgressDialog_500(
            context, 'แจ้งเตือน', 'ข้อมูลผิดพลาด (${respose.statusCode})');
      } else {
        print(respose.statusCode);
        showProgressDialog(context, 'แจ้งเตือน', 'กรุณาติดต่อผู้ดูแลระบบ!');
      }
    } catch (e) {
      print("ไม่มีข้อมูล $e");
      showProgressDialog_Notdata(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
  }

  Future<void> get_itemTypelist() async {
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
    print(searchNameItemtype.text);
    print(tokenId);
    try {
      var respose = await http.get(
        Uri.parse(
            '${beta_api_test}setup/itemTypeList?searchName=${searchNameItemtype.text}&page=1&limit=50'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> data_itemTypelist =
            new Map<String, dynamic>.from(json.decode(respose.body));
        setState(() {
          list_itemType = data_itemTypelist['data'];
        });

        Navigator.pop(context);
        print(list_itemType);
      } else if (respose.statusCode == 400) {
        print(respose.statusCode);
        showProgressDialog_400(
            context, 'แจ้งเตือน', 'ไม่พบข้อมูล (${respose.statusCode})');
      } else if (respose.statusCode == 401) {
        print(respose.statusCode);
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
        print(respose.statusCode);
        // showProgressDialog_404(context, 'แจ้งเตือน', 'ไม่พบข้อมูลที่ค้นหา');
      } else if (respose.statusCode == 405) {
        print(respose.statusCode);
        showProgressDialog_405(
            context, 'แจ้งเตือน', 'ไม่พบข้อมูล (${respose.statusCode})');
      } else if (respose.statusCode == 500) {
        print(respose.statusCode);
        showProgressDialog_500(
            context, 'แจ้งเตือน', 'ไม่พบข้อมูล (${respose.statusCode})');
      } else {
        print(respose.statusCode);
        showProgressDialog(context, 'แจ้งเตือน', 'กรุณาติดต่อผู้ดูแลระบบ!');
      }
    } catch (e) {
      print("ไม่มีข้อมูล $e");
      showProgressDialog_Notdata(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
  }

  Future<void> get_select_addressTypelist() async {
    print(tokenId);
    try {
      var respose = await http.get(
        Uri.parse('${beta_api_test}setup/addressTypeList'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> data_addressTypelist =
            new Map<String, dynamic>.from(json.decode(respose.body));
        setState(() {
          dropdown_addresstype = data_addressTypelist['data'];
          select_addreessType = dropdown_addresstype[0]['id'];
        });

        print('>>${select_addreessType}');
      } else if (respose.statusCode == 401) {
        print(respose.statusCode);
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
      showProgressDialog_Notdata(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
  }

  Future<void> get_select_branch() async {
    print(tokenId);
    try {
      var respose = await http.get(
        Uri.parse('${beta_api_test}setup/branchList'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> data_branch =
            new Map<String, dynamic>.from(json.decode(respose.body));
        setState(() {
          dropdown_branch = data_branch['data'];
        });

        print(dropdown_branch);
      } else if (respose.statusCode == 401) {
        print(respose.statusCode);
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
      showProgressDialog_Notdata(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
  }

  Future<void> get_select_debtorType() async {
    print(tokenId);
    try {
      var respose = await http.get(
        Uri.parse('${beta_api_test}setup/debtorTypeList'),
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
      } else if (respose.statusCode == 401) {
        print(respose.statusCode);
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
      showProgressDialog_Notdata(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
  }

  Future<void> get_select_signStatus() async {
    print(tokenId);
    try {
      var respose = await http.get(
        Uri.parse('${beta_api_test}setup/signStatusList'),
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
      showProgressDialog_Notdata(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
  }

  Future<void> get_select_cus() async {
    try {
      var respose = await http.get(
        Uri.parse('${beta_api_test}setup/custCondition'),
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
        print(respose.statusCode);
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
      showProgressDialog_Notdata(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
  }

  clearTextInputAll() {
    custId.clear();
    idcard.clear();
    firstname_c.clear();
    lastname_c.clear();
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

  clearValueDialog() {
    setState(() {
      id = '1';
      st_customer = true;
      st_employee = false;
      selectValue_customer = null;
      list_datavalue = [];
      valueNotdata = null;
      Texthint = '';
      statusLoad404 = false;
    });
    searchData.clear();
    firstname_em.clear();
    lastname_em.clear();
    lastname.clear();
  }

  Future<void> search_district(sizeIcon, border) async {
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
                                  clearValue_search_district();
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
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              color: Color.fromRGBO(251, 173, 55, 1),
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
                                                                .TextInputStyle(),
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
                                                showProgressDialog_Notdata(
                                                    context,
                                                    'แจ้งเตือน',
                                                    'เกิดข้อผิดพลาด! กรุณาแจ้งผูดูแลระบบ');
                                              }
                                              // print(selectValue_province);
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
                                                                .TextInputStyle(),
                                                          ),
                                                        ))
                                                .toList(),
                                            onChanged: (newvalue) {
                                              setState(() {
                                                print('111>>$newvalue');
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
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.034,
                                width: MediaQuery.of(context).size.width * 0.22,
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
                                      get_select_district();
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
                        Container(
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
                                            amphoe.text = '$text_amphoe';
                                            provincn.text = '$text_province';
                                            tumbolId =
                                                '${list_district[i]['id']}';
                                          },
                                        );
                                        Navigator.pop(context);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 2, horizontal: 8),
                                        child: Container(
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

  Future<void> search_conType(sizeIcon, border) async {
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
                                  clearValue_search_conType();
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
                                  Text(
                                    'ชื่อประเภท',
                                    style: MyContant().h4normalStyle(),
                                  ),
                                  input_nameDia(sizeIcon, border),
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
                                    MediaQuery.of(context).size.height * 0.034,
                                width: MediaQuery.of(context).size.width * 0.22,
                                child: ElevatedButton(
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
                                            vertical: 2, horizontal: 8),
                                        child: Container(
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

  Future<void> search_idcustomer(sizeIcon, border) async {
    Future<void> getData_condition(String? custType, conditionType,
        String searchData, String firstName, String lastName) async {
      try {
        var respose = await http.post(
          Uri.parse('${beta_api_test}customer/list'),
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
        } else if (respose.statusCode == 400) {
          print(respose.statusCode);
          showProgressDialog_400(
              context, 'แจ้งเตือน', '${respose.statusCode} ไม่พบข้อมูล!');
        } else if (respose.statusCode == 401) {
          print('${respose.statusCode}');
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
            statusLoad404 = true;
          });
          print(respose.statusCode);
          // showProgressDialog_404(
          //     context, 'แจ้งเตือน', '${respose.statusCode} ไม่พบข้อมูล');
        } else if (respose.statusCode == 405) {
          print(respose.statusCode);
          showProgressDialog_405(context, 'แจ้งเตือน', 'ไม่พบข้อมูล!');
        } else if (respose.statusCode == 500) {
          print(respose.statusCode);
          showProgressDialog_500(
              context, 'แจ้งเตือน', '${respose.statusCode} ข้อมูลผิดพลาด!');
        }
      } catch (e) {
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
                          color: Color.fromARGB(255, 138, 138, 138),
                        ),
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
                                          searchData.clear();
                                          statusLoad404 = false;
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
                                          searchData.clear();
                                          statusLoad404 = false;
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
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(1),
                                        child: Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
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
                                                  searchData.clear();
                                                  statusLoad404 = false;
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
                          padding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.034,
                                width: MediaQuery.of(context).size.width * 0.22,
                                child: ElevatedButton(
                                  style: MyContant().myButtonSearchStyle(),
                                  onPressed: () {
                                    print('data>>>$list_datavalue');
                                    if (id == '1') {
                                      print('1==>> $id');
                                      if (selectValue_customer == null ||
                                          searchData.text.isEmpty) {
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
                        Container(
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
                                ] else if (statusLoad404 == true) ...[
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
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'สอบถามลูกหนี้',
          style: MyContant().TitleStyle(),
        ),
      ),
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
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Color.fromRGBO(251, 173, 55, 1),
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
                        input_idcustomer(sizeIcon, border),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            backgroundColor:
                                const Color.fromRGBO(173, 106, 3, 1),
                          ),
                          onPressed: () {
                            search_idcustomer(sizeIcon, border);
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
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            backgroundColor:
                                const Color.fromRGBO(173, 106, 3, 1),
                          ),
                          onPressed: () {
                            search_district(sizeIcon, border);
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
                    if (filter == true) ...[
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
                            'ประเภทสินค้า',
                            style: MyContant().h4normalStyle(),
                          ),
                          input_contractType(sizeIcon, border),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              backgroundColor:
                                  const Color.fromRGBO(173, 106, 3, 1),
                            ),
                            onPressed: () {
                              search_conType(sizeIcon, border);
                            },
                            child: const Icon(
                              Icons.search,
                            ),
                          ),
                        ],
                      ),
                    ],
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
            //   height: MediaQuery.of(context).size.height * 0.6,
            //   child: Scrollbar(
            //     child: ListView(
            //       children: [
            //         if (list_dataDebtor.isNotEmpty) ...[
            //           for (var i = 0; i < list_dataDebtor.length; i++) ...[
            //             InkWell(
            //               onTap: () {
            //                 Navigator.push(
            //                   context,
            //                   MaterialPageRoute(
            //                       builder: (context) => Data_SearchDebtor(
            //                           list_dataDebtor[i]['signId'],
            //                           list_dataDebtor[i]['signStatusName'])),
            //                 );
            //               },
            //               child: Padding(
            //                 padding: const EdgeInsets.symmetric(horizontal: 8),
            //                 child: Container(
            //                   margin: EdgeInsets.symmetric(vertical: 5),
            //                   padding: EdgeInsets.all(8.0),
            //                   decoration: BoxDecoration(
            //                     borderRadius:
            //                         BorderRadius.all(Radius.circular(5)),
            //                     color: Color.fromRGBO(255, 218, 249, 1),
            //                   ),
            //                   child: Column(
            //                     children: [
            //                       Row(
            //                         children: [
            //                           Text(
            //                             'สาขาที่ออกขาย : ${list_dataDebtor[i]['branchName']}',
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
            //                             'เลขที่สัญญา : ${list_dataDebtor[i]['signId']}',
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
            //                             'วันที่ทำสัญญา : ${list_dataDebtor[i]['signDate']}',
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
            //                             'เลขบัตรประชาชน : ${list_dataDebtor[i]['smartId']}',
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
            //                             'ชื่อลูกค้าในสัญญา : ',
            //                             style: MyContant().h4normalStyle(),
            //                           ),
            //                           Expanded(
            //                             child: Text(
            //                               '${list_dataDebtor[i]['custName']}',
            //                               overflow: TextOverflow.clip,
            //                               style: MyContant().h4normalStyle(),
            //                             ),
            //                           )
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
            //                             'สินค้าที่ซื้อ : ',
            //                             style: MyContant().h4normalStyle(),
            //                           ),
            //                           Expanded(
            //                             child: Text(
            //                               '${list_dataDebtor[i]['itemName']}',
            //                               overflow: TextOverflow.clip,
            //                               style: MyContant().h4normalStyle(),
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
            //                             'เงินดาวน์/งวดแรก : ${list_dataDebtor[i]['downPrice']}  บาท',
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
            //                             'ส่งเดือนละ : ${list_dataDebtor[i]['periodPrice']}  บาท',
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
            //                             'ระยเวลา : ${list_dataDebtor[i]['periodCount']}  งวด',
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
            //                             'กำหนดชำระทุกวันที่ : ${list_dataDebtor[i]['periodDay']}  ของเดือน',
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
            //                             'หมายเหตุ : ',
            //                             style: MyContant().h4normalStyle(),
            //                           ),
            //                           Expanded(
            //                             child: Text(
            //                               'เกินกำหนดชำระค่างวด 3 วัน มีเบี้ยปรับ+ค่าทวงถาม',
            //                               overflow: TextOverflow.clip,
            //                               style: MyContant().h4normalStyle(),
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
            //                             'สถานะสัญญา : ${list_dataDebtor[i]['signStatusName']}',
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
            const SizedBox(
              height: 70,
            ),
          ],
        ),
      ),
    );
  }

  Padding group_btnsearch() {
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
                      const Icon(Icons.arrow_drop_up),
                    ] else ...[
                      Text(
                        'ค้นหาแบบละเอียด',
                        style: MyContant().TextsearchStyle(),
                      ),
                      const Icon(Icons.arrow_drop_down),
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
                    height: MediaQuery.of(context).size.height * 0.034,
                    width: MediaQuery.of(context).size.width * 0.22,
                    child: ElevatedButton(
                      style: MyContant().myButtonSearchStyle(),
                      onPressed: () {
                        setState(() {
                          selectValue_province ??= selectProvince;
                          selectValue_amphoe ??= selectAmphur;
                          tumbolId ??= selectTumbol;
                        });
                        print('test_value_p>>$selectValue_province');
                        print('test_value_a>>$selectValue_amphoe');
                        print('test_value_t>>$tumbolId');

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ListCreditQueryDebtor(
                              custId.text,
                              homeNo.text,
                              moo.text,
                              tumbolId,
                              amphur.toString(),
                              province.toString(),
                              firstname_c.text,
                              lastname_c.text,
                              select_addreessType.toString(),
                              select_debtorType,
                              idcard.text,
                              telephone.text,
                              select_branchlist,
                              signId.text,
                              select_signStatus,
                              itemTypelist.text,
                              selectValue_amphoe,
                              selectValue_province,
                              widget.address,
                            ),
                          ),
                        );
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
    );
  }

  Padding line() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
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
        padding: const EdgeInsets.only(top: 8, bottom: 8, left: 8),
        child: TextField(
          controller: custId,
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

  Expanded input_lastname(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: lastname_c,
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

  Expanded select_search(sizeIcon, border) {
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
              items: dropdown_addresstype
                  .map(
                    (value) => DropdownMenuItem(
                      value: value['id'],
                      child: Text(
                        value['name'],
                        style: MyContant().h4normalStyle(),
                      ),
                    ),
                  )
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

  Expanded input_numberhome(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: homeNo,
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

  Expanded input_moo(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: moo,
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

  Expanded input_district(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8, left: 8),
        child: TextField(
          controller: district,
          readOnly: true,
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

  Expanded input_amphoe(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: amphoe,
          readOnly: true,
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

  Expanded input_province(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: provincn,
          readOnly: true,
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

  Expanded select_branch(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: MediaQuery.of(context).size.width * 0.1,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: Padding(
            padding: const EdgeInsets.only(left: 4),
            child: DropdownButton(
              items: dropdown_branch
                  .map(
                    (value) => DropdownMenuItem(
                      value: value['id'],
                      child: Text(
                        value['name'],
                        style: MyContant().TextInputStyle(),
                      ),
                    ),
                  )
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

  Expanded provin(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: MediaQuery.of(context).size.width * 0.1,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: Padding(
            padding: const EdgeInsets.only(left: 4),
            child: DropdownButton<String>(
              value: selectProvince,
              items: drProvince.isEmpty
                  ? []
                  : drProvince
                      .map(
                        (value) => DropdownMenuItem(
                          value: value['id'].toString(),
                          child: Text(
                            value['name'],
                            style: MyContant().TextInputStyle(),
                          ),
                        ),
                      )
                      .toList(),
              onChanged: (newvalue) async {
                setState(() {
                  var dfvalue = newvalue;
                  selectProvince = dfvalue;
                  // provincn.text = dfvalue.toString().split("_")[1];
                  // selectValue_amphoe = null;
                });

                // try {
                //   var respose = await http.get(
                //     Uri.parse(
                //         '${beta_api_test}setup/amphurList?pId=${selectValue_province.toString().split("_")[0]}'),
                //     headers: <String, String>{
                //       'Content-Type': 'application/json',
                //       'Authorization': tokenId.toString(),
                //     },
                //   );

                //   if (respose.statusCode == 200) {
                //     Map<String, dynamic> data_amphoe =
                //         new Map<String, dynamic>.from(
                //             json.decode(respose.body));
                //     setState(() {
                //       dropdown_amphoe = data_amphoe['data'];
                //     });
                //     print(data_amphoe['data']);
                //   } else if (respose.statusCode == 401) {
                //     SharedPreferences preferences =
                //         await SharedPreferences.getInstance();
                //     preferences.clear();
                //     Navigator.pushAndRemoveUntil(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => const Authen(),
                //       ),
                //       (Route<dynamic> route) => false,
                //     );
                //     showProgressDialog_401(
                //         context, 'แจ้งเตือน', 'กรุณา Login เข้าสู่ระบบใหม่');
                //   } else {
                //     print(respose.statusCode);
                //   }
                // } catch (e) {
                //   print("ไม่มีข้อมูล $e");
                //   showProgressDialog_Notdata(context, 'แจ้งเตือน',
                //       'เกิดข้อผิดพลาด! กรุณาแจ้งผูดูแลระบบ');
                // }
                // print(selectValue_province);
              },
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
    );
  }

  Expanded amphor(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: MediaQuery.of(context).size.width * 0.1,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: Padding(
            padding: const EdgeInsets.only(left: 4),
            child: DropdownButton<String>(
              value: selectAmphur,
              items: drAmphur.isEmpty
                  ? []
                  : drAmphur
                      .map((value) => DropdownMenuItem(
                            value: value['id'].toString(),
                            child: Text(
                              value['name'],
                              style: MyContant().TextInputStyle(),
                            ),
                          ))
                      .toList(),
              onChanged: (newvalue) {
                setState(() {
                  var dfvalue = newvalue;
                  selectAmphur = dfvalue;
                  // text_amphoe = dfvalue.toString().split("_")[1];
                });
              },
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
    );
  }

  Expanded tumbole(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: MediaQuery.of(context).size.width * 0.1,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: Padding(
            padding: const EdgeInsets.only(left: 4),
            child: DropdownButton<String>(
              value: selectTumbol,
              items: drTumbol.isEmpty
                  ? []
                  : drTumbol
                      .map((value) => DropdownMenuItem(
                            value: value['id'].toString(),
                            child: Text(
                              value['name'],
                              style: MyContant().TextInputStyle(),
                            ),
                          ))
                      .toList(),
              onChanged: (newvalue) {
                setState(() {
                  var dfvalue = newvalue;
                  selectTumbol = dfvalue;
                  // text_amphoe = dfvalue.toString().split("_")[1];
                });
              },
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

  Expanded select_debtorTypelist(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
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

  Expanded select_contractStatus(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
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

  Expanded input_contractType(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8, left: 8),
        child: TextField(
          controller: itemTypelist,
          readOnly: true,
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

  Expanded input_nameDia(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: searchNameItemtype,
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
