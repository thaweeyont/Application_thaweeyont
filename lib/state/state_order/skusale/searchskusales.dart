import 'dart:convert';

import 'package:application_thaweeyont/api.dart';
import 'package:application_thaweeyont/state/authen.dart';
import 'package:application_thaweeyont/state/state_order/skusale/reportskusalelist.dart';
import 'package:application_thaweeyont/utility/my_constant.dart';
import 'package:application_thaweeyont/widgets/custom_appbar.dart';
import 'package:application_thaweeyont/widgets/endpage.dart';
import 'package:application_thaweeyont/widgets/loaddata.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:loading_gifs/loading_gifs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchSKUSale extends StatefulWidget {
  const SearchSKUSale({super.key});

  @override
  State<SearchSKUSale> createState() => _SearchSKUSaleState();
}

class _SearchSKUSaleState extends State<SearchSKUSale> {
  String userId = '',
      empId = '',
      firstName = '',
      lastName = '',
      tokenId = '',
      branchId = '',
      branchAreaId = '',
      branchAreaName = '',
      appGroupId = '';
  List<String>? itemBrandPC;
  List mybranchProvince = [],
      mybranchGroup = [],
      myAreaBranch = [],
      dropdownAreaBranch = [],
      dropdownBranchGroup = [],
      dropdownbranchProvin = [],
      dropdownMonth1 = [],
      dropdownYear1 = [],
      dropdownMonth2 = [],
      dropdownYear2 = [],
      dropdownMonth3 = [],
      dropdownYear3 = [],
      dropdownMonth4 = [],
      dropdownYear4 = [];
  String? selectBranchgrouplist,
      selectProvinbranchlist,
      selectAreaBranchlist,
      selectMonthId1,
      selectedMonth1,
      selectYearlist1,
      selectMonthId2,
      selectedMonth2,
      selectYearlist2,
      selectMonthId3,
      selectedMonth3,
      selectYearlist3,
      selectMonthId4,
      selectedMonth4,
      selectYearlist4,
      idChkExclude;
  dynamic idBrandlist, idModellist, idStylellist, idSizelist, idColorlist;
  String itemGroupIds = '', itemTypeIds = '', itemSupplyIds = '';
  bool isCheckAll = false,
      isChkExclude = false,
      isLoadingbranchProvince = false;
  List<Map<String, dynamic>> selectedGroupList = [],
      selectedItemTypeList = [],
      selectedSupplyList = [];
  DateTime selectedDate = DateTime.now();
  bool showClearBrand = false;
  bool showClearSupply = false;
  List<Map<String, dynamic>> brandList = [];

  TextEditingController itemGroup = TextEditingController();
  TextEditingController itemType = TextEditingController();
  TextEditingController itemBrand = TextEditingController();
  TextEditingController itemModel = TextEditingController();
  TextEditingController itemStyle = TextEditingController();
  TextEditingController itemSize = TextEditingController();
  TextEditingController itemColor = TextEditingController();
  TextEditingController startdate = TextEditingController();
  TextEditingController startdatePO = TextEditingController();
  TextEditingController enddatePO = TextEditingController();
  TextEditingController startDatesale = TextEditingController();
  TextEditingController endDatesale = TextEditingController();
  TextEditingController supplyList = TextEditingController();

  @override
  void initState() {
    super.initState();
    getdata();
  }

  Future<void> getdata() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      userId = preferences.getString('userId') ?? '';
      empId = preferences.getString('empId') ?? '';
      firstName = preferences.getString('firstName') ?? '';
      lastName = preferences.getString('lastName') ?? '';
      tokenId = preferences.getString('tokenId') ?? '';
      branchId = preferences.getString('branchId') ?? '';
      branchAreaId = preferences.getString('branchAreaId') ?? '';
      branchAreaName = preferences.getString('branchAreaName') ?? '';
      appGroupId = preferences.getString('appGroupId') ?? '';
      itemBrandPC = preferences.getStringList('itemBrandPC');
    });

    if (itemBrandPC != null && itemBrandPC!.isNotEmpty) {
      brandList = itemBrandPC!
          .map((e) => jsonDecode(e) as Map<String, dynamic>)
          .toList();

      final List<String> brandIds = brandList
          .map((e) => (e['brandId'] ?? '').toString())
          .where((id) => id.isNotEmpty)
          .toList();

      final List<String> supplyIds = brandList
          .map((e) => (e['supplyId'] ?? '').toString())
          .where((id) => id.isNotEmpty)
          .toList();

      if (brandIds.length == 1 && supplyIds.length == 1) {
        // ✅ ทั้ง brand และ supply มี 1 รายการ → ตั้ง default ทั้งคู่
        final brandData = brandList.firstWhere(
            (e) => (e['brandId'] ?? '').toString() == brandIds.first);
        await setDefaultBrand(brandData);
        await setDefaultSupplyList(brandList);

        setState(() {
          showClearBrand = true;
          showClearSupply = true;
        });
      } else if (brandIds.length == 1 && supplyIds.isEmpty) {
        // ✅ มี brand 1 รายการ แต่ supply ว่าง → ตั้ง default brand, เปิดให้เลือก supply
        final brandData = brandList.firstWhere(
            (e) => (e['brandId'] ?? '').toString() == brandIds.first);
        await setDefaultBrand(brandData);

        setState(() {
          showClearBrand = true;
          showClearSupply = false; // ให้ user เลือก supply
        });
      } else {
        // 🔄 กรณีมีหลายรายการ → ให้ user เลือกทั้งคู่
        setState(() {
          showClearBrand = false;
          showClearSupply = false;
        });
      }
    }

    // โหลดข้อมูลอื่น ๆ ตามปกติ
    showProgressLoading(context);
    await getSelectbranchProvince();
    await getSelectbranchGroup();
    await getSelectBranchArea();
    await getSelectMonth1();
    await getSelectMonth2();
    await getSelectMonth3();
    await getSelectMonth4();
    await getSelectYear1();
    await getSelectYear2();
    await getSelectYear3();
    await getSelectYear4();

    if (mounted) {
      Navigator.pop(context);
    }
  }

  Future<void> setDefaultBrand(Map<String, dynamic> brandData) async {
    try {
      final brandId = (brandData['brandId'] ?? '').toString();

      final response = await http.get(
        Uri.parse(
            '${api}setup/itemBrandList?searchId=$brandId&page=1&limit=100'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final brandList = data['data'] as List;

        final brandMatch = brandList.firstWhere(
          (b) => (b['id'] ?? '').toString() == brandId,
          orElse: () => null,
        );

        if (brandMatch != null) {
          setState(() {
            idBrandlist = brandId;
            itemBrand.text = (brandMatch['name'] ?? '').toString();
            showClearBrand = true;
          });
          print('🔍 Default Brand: ${brandMatch['name']}');
        }
      } else {
        handleHttpError(response.statusCode);
      }
    } catch (e) {
      print('❌ error get brand default: $e');
    }
  }

  Future<void> setDefaultSupplyList(
      List<Map<String, dynamic>> brandList) async {
    try {
      final List<String> supplyIds = brandList
          .map((e) => (e['supplyId'] ?? '').toString())
          .where((id) => id.isNotEmpty)
          .toList();

      if (supplyIds.isEmpty) return;

      final response = await http.get(
        Uri.parse('${api}setup/supplyList?searchName=&page=1&limit=4000'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final supplyData = data['data'] as List;

        final matchedSupplies = supplyData
            .where((s) => supplyIds.contains((s['id'] ?? '').toString()))
            .toList();

        if (matchedSupplies.isNotEmpty) {
          final displayNames = matchedSupplies
              .map((e) => (e['name'] ?? '').toString())
              .join(', ');
          final supplyIdString =
              matchedSupplies.map((e) => (e['id'] ?? '').toString()).join(',');

          setState(() {
            supplyList.text = displayNames;
            itemSupplyIds = supplyIdString;
            showClearSupply = true;
          });

          print('🔹 Default Supply: $displayNames');
          print('🔹 Supply IDs: $supplyIdString');
        }
      } else {
        handleHttpError(response.statusCode);
      }
    } catch (e) {
      print('❌ error get supply default: $e');
    }
  }

  void selectMonthName1() {
    // ลบ 3 เดือนจากเดือนปัจจุบัน
    final previousMonth = DateTime(selectedDate.year, selectedDate.month - 3);
    selectedMonth1 = DateFormat('MMMM', 'th').format(previousMonth);
    selectMonthId1 = dropdownMonth1.firstWhere(
      (month) => month["name"] == selectedMonth1,
      orElse: () => {"id": ""},
    )["id"];
  }

  void selectMonthName2() {
    // ลบ 2 เดือนจากเดือนปัจจุบัน
    final previousMonth = DateTime(selectedDate.year, selectedDate.month - 2);
    selectedMonth2 = DateFormat('MMMM', 'th').format(previousMonth);
    selectMonthId2 = dropdownMonth2.firstWhere(
      (month) => month["name"] == selectedMonth2,
      orElse: () => {"id": ""},
    )["id"];
  }

  void selectMonthName3() {
    // ลบ 1 เดือนจากเดือนปัจจุบัน
    final previousMonth = DateTime(selectedDate.year, selectedDate.month - 1);
    selectedMonth3 = DateFormat('MMMM', 'th').format(previousMonth);
    selectMonthId3 = dropdownMonth3.firstWhere(
      (month) => month["name"] == selectedMonth3,
      orElse: () => {"id": ""},
    )["id"];
  }

  void selectMonthName4() {
    // เลือกเดือนปัจจุบัน
    selectedMonth4 = DateFormat('MMMM', 'th').format(selectedDate);
    selectMonthId4 = dropdownMonth4.firstWhere(
      (month) => month["name"] == selectedMonth4,
      orElse: () => {"id": ""}, // ถ้าไม่พบ ให้คืนค่า id = ""
    )["id"];
  }

  Future<void> getSelectbranchProvince() async {
    try {
      var response = await http.get(
        Uri.parse('${api}setup/branchProvinceList'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> databranchProvince =
            Map<String, dynamic>.from(json.decode(response.body));
        setState(() {
          List df = [
            {'id': "99", 'name': "เลือกสาขาจังหวัด"}
          ];
          mybranchProvince = List.from(df)..addAll(databranchProvince['data']);
          dropdownbranchProvin = mybranchProvince;
        });

        isLoadingbranchProvince = true;
      } else {
        handleHttpError(response.statusCode);
      }
    } catch (e) {
      print("ไม่มีข้อมูล $e");
      showProgressDialog(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
  }

  Future<void> getSelectbranchGroup() async {
    try {
      var response = await http.get(
        Uri.parse('${api}setup/branchGroupList'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> databranchGroup =
            Map<String, dynamic>.from(json.decode(response.body));
        setState(() {
          List df = [
            {'id': "99", 'name': "เลือกกลุ่มสาขา"}
          ];
          mybranchGroup = List.from(df)..addAll(databranchGroup['data']);
          dropdownBranchGroup = mybranchGroup;
        });

        // isLoadingbranchProvince = true;
      } else {
        handleHttpError(response.statusCode);
      }
    } catch (e) {
      print("ไม่มีข้อมูล $e");
      showProgressDialog(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
  }

  Future<void> getSelectBranchArea() async {
    try {
      var response = await http.get(
        Uri.parse('${api}setup/branchAreaList'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> dataAreaBranch =
            Map<String, dynamic>.from(json.decode(response.body));
        setState(() {
          List ba = [
            {'id': "99", 'name': "เลือกเขตสาขา"}
          ];
          myAreaBranch = List.from(ba)..addAll(dataAreaBranch['data']);
          dropdownAreaBranch = myAreaBranch;
        });
      } else {
        handleHttpError(response.statusCode);
      }
    } catch (e) {
      print("ไม่มีข้อมูล $e");
      showProgressDialog(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
  }

  Future<void> getSelectMonth1() async {
    try {
      var response = await http.get(
        Uri.parse('${api}setup/monthList'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> dataMonth1 =
            Map<String, dynamic>.from(json.decode(response.body));
        setState(() {
          dropdownMonth1 = dataMonth1['data'];
          selectMonthName1();
        });
      } else {
        handleHttpError(response.statusCode);
      }
    } catch (e) {
      print("ไม่มีข้อมูล $e");
      showProgressDialog(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
  }

  Future<void> getSelectMonth2() async {
    try {
      var response = await http.get(
        Uri.parse('${api}setup/monthList'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> dataMonth2 =
            Map<String, dynamic>.from(json.decode(response.body));
        setState(() {
          dropdownMonth2 = dataMonth2['data'];
          selectMonthName2();
        });
      } else {
        handleHttpError(response.statusCode);
      }
    } catch (e) {
      print("ไม่มีข้อมูล $e");
      showProgressDialog(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
  }

  Future<void> getSelectMonth3() async {
    try {
      var response = await http.get(
        Uri.parse('${api}setup/monthList'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> dataMonth3 =
            Map<String, dynamic>.from(json.decode(response.body));
        setState(() {
          dropdownMonth3 = dataMonth3['data'];
          selectMonthName3();
        });
      } else {
        handleHttpError(response.statusCode);
      }
    } catch (e) {
      print("ไม่มีข้อมูล $e");
      showProgressDialog(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
  }

  Future<void> getSelectMonth4() async {
    try {
      var response = await http.get(
        Uri.parse('${api}setup/monthList'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> dataMonth4 =
            Map<String, dynamic>.from(json.decode(response.body));
        setState(() {
          dropdownMonth4 = dataMonth4['data'];
          selectMonthName4();
        });
      } else {
        handleHttpError(response.statusCode);
      }
    } catch (e) {
      print("ไม่มีข้อมูล $e");
      showProgressDialog(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
  }

  Future<void> getSelectYear1() async {
    try {
      var response = await http.get(
        Uri.parse('${api}setup/yearList'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> dataYear1 =
            Map<String, dynamic>.from(json.decode(response.body));
        setState(() {
          dropdownYear1 = dataYear1['data'];
          selectYearlist1 = dropdownYear1.first.toString();
        });
      } else {
        handleHttpError(response.statusCode);
      }
    } catch (e) {
      print("ไม่มีข้อมูล $e");
      showProgressDialog(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
  }

  Future<void> getSelectYear2() async {
    try {
      var response = await http.get(
        Uri.parse('${api}setup/yearList'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> dataYear2 =
            Map<String, dynamic>.from(json.decode(response.body));
        setState(() {
          dropdownYear2 = dataYear2['data'];
          selectYearlist2 = dropdownYear2.first.toString();
        });
      } else {
        handleHttpError(response.statusCode);
      }
    } catch (e) {
      print("ไม่มีข้อมูล $e");
      showProgressDialog(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
  }

  Future<void> getSelectYear3() async {
    try {
      var response = await http.get(
        Uri.parse('${api}setup/yearList'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> dataYear3 =
            Map<String, dynamic>.from(json.decode(response.body));
        setState(() {
          dropdownYear3 = dataYear3['data'];
          selectYearlist3 = dropdownYear3.first.toString();
        });
      } else {
        handleHttpError(response.statusCode);
      }
    } catch (e) {
      print("ไม่มีข้อมูล $e");
      showProgressDialog(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
  }

  Future<void> getSelectYear4() async {
    try {
      var response = await http.get(
        Uri.parse('${api}setup/yearList'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> dataYear4 =
            Map<String, dynamic>.from(json.decode(response.body));
        setState(() {
          dropdownYear4 = dataYear4['data'];
          selectYearlist4 = dropdownYear4.first.toString();
        });
      } else {
        handleHttpError(response.statusCode);
      }
    } catch (e) {
      print("ไม่มีข้อมูล $e");
      showProgressDialog(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
  }

  // แยกฟังก์ชัน handle error HTTP
  void handleHttpError(int statusCode) async {
    if (statusCode == 400) {
      showProgressDialog_400(context, 'แจ้งเตือน', 'ไม่พบข้อมูล ($statusCode)');
    } else if (statusCode == 401) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.clear();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Authen()),
        (Route<dynamic> route) => false,
      );
      showProgressDialog_401(
          context, 'แจ้งเตือน', 'กรุณา Login เข้าสู่ระบบใหม่');
    } else if (statusCode == 404) {
      showProgressDialog_404(context, 'แจ้งเตือน', 'ไม่พบข้อมูล ($statusCode)');
    } else if (statusCode == 405) {
      showProgressDialog_405(context, 'แจ้งเตือน', 'ไม่พบข้อมูล ($statusCode)');
    } else if (statusCode == 500) {
      showProgressDialog_500(
          context, 'แจ้งเตือน', 'ข้อมูลผิดพลาด ($statusCode)');
    } else {
      showProgressDialog(context, 'แจ้งเตือน', 'กรุณาติดต่อผู้ดูแลระบบ');
    }
  }

  void clearInputandSelect() async {
    showProgressLoading(context);
    itemGroup.clear();
    itemType.clear();
    itemBrand.clear();
    itemModel.clear();
    itemStyle.clear();
    itemSize.clear();
    itemColor.clear();
    supplyList.clear();
    selectedGroupList.clear();
    selectedItemTypeList.clear();
    selectedSupplyList.clear();
    itemGroupIds = '';
    itemTypeIds = '';
    idBrandlist = null;
    idModellist = null;
    idStylellist = null;
    idSizelist = null;
    idColorlist = null;
    itemSupplyIds = '';
    selectProvinbranchlist = null;
    selectBranchgrouplist = null;
    selectAreaBranchlist = null;
    isChkExclude = false;
    startdate.clear();
    startdatePO.clear();
    enddatePO.clear();
    startDatesale.clear();
    endDatesale.clear();

// ⚙️ จากนั้นเช็ค itemBrandPC เหมือนใน getdata()
    if (itemBrandPC != null && itemBrandPC!.isNotEmpty) {
      final List<Map<String, dynamic>> brandList = itemBrandPC!
          .map((e) => jsonDecode(e) as Map<String, dynamic>)
          .toList();

      final List<String> brandIds = brandList
          .map((e) => (e['brandId'] ?? '').toString())
          .where((id) => id.isNotEmpty)
          .toList();

      final List<String> supplyIds = brandList
          .map((e) => (e['supplyId'] ?? '').toString())
          .where((id) => id.isNotEmpty)
          .toList();

      if (brandIds.length == 1 && supplyIds.length == 1) {
        // ✅ ทั้ง brand และ supply มี 1 รายการ → ตั้ง default ทั้งคู่
        final brandData = brandList.firstWhere(
            (e) => (e['brandId'] ?? '').toString() == brandIds.first);
        await setDefaultBrand(brandData);
        await setDefaultSupplyList(brandList);

        setState(() {
          showClearBrand = true;
          showClearSupply = true;
        });
      } else if (brandIds.length == 1 && supplyIds.isEmpty) {
        // ✅ มี brand เดียว supply ว่าง → default brand แต่ให้ user เลือก supply
        final brandData = brandList.firstWhere(
            (e) => (e['brandId'] ?? '').toString() == brandIds.first);
        await setDefaultBrand(brandData);

        setState(() {
          showClearBrand = true;
          showClearSupply = false;
        });
      } else {
        // 🔄 หลายตัว → ต้องเลือกเอง
        setState(() {
          showClearBrand = false;
          showClearSupply = false;
        });
      }
    } else {
      // ❌ ไม่มี itemBrandPC → ล้างหมด ไม่ตั้ง default
      setState(() {
        showClearBrand = false;
        showClearSupply = false;
      });
    }

    print('✅ ล้างข้อมูลเสร็จแล้ว พร้อมตั้งค่าเริ่มต้นตาม itemBrandPC');

    await getSelectMonth1();
    await getSelectMonth2();
    await getSelectMonth3();
    await getSelectMonth4();
    await getSelectYear1();
    await getSelectYear2();
    await getSelectYear3();
    await getSelectYear4();

    if (mounted) {
      Navigator.pop(context);
    }
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
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(5),
                  ),
                  color: const Color.fromRGBO(239, 191, 239, 1),
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
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.22,
                          child: Text(
                            'กลุ่ม : ',
                            style: MyContant().h4normalStyle(),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        inputItemGroup(),
                        const SizedBox(width: 3),
                        SizedBox(
                          width: 35,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              shape: const CircleBorder(),
                              backgroundColor:
                                  const Color.fromARGB(255, 223, 132, 223),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ItemGroupList(),
                                ),
                              ).then((result) {
                                if (result != null && result is List) {
                                  setState(() {
                                    selectedGroupList =
                                        List<Map<String, dynamic>>.from(result);
                                    // แสดงชื่อใน TextField
                                    itemGroup.text = selectedGroupList
                                        .map((e) => e['name'].toString())
                                        .join(', ');

                                    // เก็บ id สำหรับส่ง API (เช่น 01,05,07)
                                    itemGroupIds = selectedGroupList
                                        .map((e) => e['id'].toString())
                                        .join(',');
                                    // print('itemGroupIds: $itemGroupIds');
                                  });
                                }
                              });
                            },
                            child: const Icon(
                              Icons.search,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 3)
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.22,
                          child: Text(
                            'ประเภท : ',
                            style: MyContant().h4normalStyle(),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        inputItemType(),
                        const SizedBox(width: 3),
                        SizedBox(
                          width: 35,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              shape: const CircleBorder(),
                              backgroundColor:
                                  const Color.fromARGB(255, 223, 132, 223),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ItemTypeList(
                                    valueGrouplist: selectedGroupList
                                        .map((e) => e['id'].toString())
                                        .toList(),
                                  ),
                                ),
                              ).then((result) {
                                if (result != null && result is List) {
                                  setState(() {
                                    selectedItemTypeList =
                                        List<Map<String, dynamic>>.from(result);
                                    // แสดงชื่อใน TextField
                                    itemType.text = selectedItemTypeList
                                        .map((e) => e['name'].toString())
                                        .join(', ');
                                    // เก็บ id สำหรับส่ง API (เช่น 01,05,07)
                                    itemTypeIds = selectedItemTypeList
                                        .map((e) => e['id'].toString())
                                        .join(',');
                                    // print('itemTypeIds: $itemTypeIds');
                                  });
                                }
                              });
                            },
                            child: const Icon(
                              Icons.search,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 3)
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.22,
                          child: Text(
                            'ยี่ห้อ : ',
                            style: MyContant().h4normalStyle(),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        inputItemBrand(),
                        const SizedBox(width: 3),
                        SizedBox(
                          width: 35,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              shape: const CircleBorder(),
                              backgroundColor:
                                  const Color.fromARGB(255, 223, 132, 223),
                            ),
                            onPressed: showClearBrand
                                ? null
                                : () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ItemBrandList(),
                                      ),
                                    ).then((result) {
                                      if (result != null) {
                                        setState(() {
                                          itemBrand.text = result['name'];
                                          idBrandlist = result['id'];
                                          // print('idBrandlist: $idBrandlist');
                                        });
                                      }
                                    });
                                  },
                            child: const Icon(
                              Icons.search,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 3)
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.22,
                          child: Text(
                            'รุ่น : ',
                            style: MyContant().h4normalStyle(),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        inputItemModel(),
                        const SizedBox(width: 3),
                        SizedBox(
                          width: 35,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              shape: const CircleBorder(),
                              backgroundColor:
                                  const Color.fromARGB(255, 223, 132, 223),
                            ),
                            onPressed: () {
                              if (itemBrand.text.isEmpty) {
                                showProgressDialog(context, 'แจ้งเตือน',
                                    'กรุณาเลือกยี่ห้อสินค้า');
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ItemModelList(
                                      valueBrandlist: idBrandlist,
                                    ),
                                  ),
                                ).then((result) {
                                  if (result != null) {
                                    setState(() {
                                      itemModel.text = result['name'];
                                      idModellist = result['id'];
                                    });
                                  }
                                });
                              }
                            },
                            child: const Icon(
                              Icons.search,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 3)
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.22,
                          child: Text(
                            'แบบ : ',
                            style: MyContant().h4normalStyle(),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        inputItemStyle(),
                        const SizedBox(width: 3),
                        SizedBox(
                          width: 35,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              shape: const CircleBorder(),
                              backgroundColor:
                                  const Color.fromARGB(255, 223, 132, 223),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ItemStyleList(),
                                ),
                              ).then((result) {
                                if (result != null) {
                                  setState(() {
                                    itemStyle.text = result['name'];
                                    idStylellist = result['id'];
                                  });
                                }
                              });
                            },
                            child: const Icon(
                              Icons.search,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 3)
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.22,
                          child: Text(
                            'ขนาด : ',
                            style: MyContant().h4normalStyle(),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        inputItemSize(),
                        const SizedBox(width: 3),
                        SizedBox(
                          width: 35,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              shape: const CircleBorder(),
                              backgroundColor:
                                  const Color.fromARGB(255, 223, 132, 223),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ItemSizeList(),
                                ),
                              ).then((result) {
                                if (result != null) {
                                  setState(() {
                                    itemSize.text = result['name'];
                                    idSizelist = result['id'];
                                  });
                                }
                              });
                            },
                            child: const Icon(
                              Icons.search,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 3)
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.22,
                          child: Text(
                            'สี : ',
                            style: MyContant().h4normalStyle(),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        inputItemColor(),
                        const SizedBox(width: 3),
                        SizedBox(
                          width: 35,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              shape: const CircleBorder(),
                              backgroundColor:
                                  const Color.fromARGB(255, 223, 132, 223),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ItemColorList(),
                                ),
                              ).then((result) {
                                if (result != null) {
                                  setState(() {
                                    itemColor.text = result['name'];
                                    idColorlist = result['id'];
                                  });
                                }
                              });
                            },
                            child: const Icon(
                              Icons.search,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 3)
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.22,
                          child: Text(
                            'สาขาจังหวัด : ',
                            style: MyContant().h4normalStyle(),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        selectProvinbranch(sizeIcon, border),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.22,
                          child: Text(
                            'กลุ่มสาขา : ',
                            style: MyContant().h4normalStyle(),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        selectBranchGroup(sizeIcon, border),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.22,
                          child: Text(
                            'เขตสาขา : ',
                            style: MyContant().h4normalStyle(),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        selectAreaBranch(sizeIcon, border),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.22,
                          child: Text(
                            'วันที่ : ',
                            style: MyContant().h4normalStyle(),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        inputStartdate(),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.22,
                          child: Text(
                            'วันที่ PO : ',
                            style: MyContant().h4normalStyle(),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        inputStartdatePO(),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.22,
                          child: Text(
                            'ถึงวันที่ : ',
                            style: MyContant().h4normalStyle(),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        inputEnddatePO(),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.22,
                          child: Text(
                            'วันที่ขาย : ',
                            style: MyContant().h4normalStyle(),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        inputStartdateSale(),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.22,
                          child: Text(
                            'ถึงวันที่ : ',
                            style: MyContant().h4normalStyle(),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        inputEnddateSale(),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.22,
                          child: Text(
                            'ผู้จำหน่าย : ',
                            style: MyContant().h4normalStyle(),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        inputSupplyList(),
                        const SizedBox(width: 3),
                        SizedBox(
                          width: 35,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              shape: const CircleBorder(),
                              backgroundColor:
                                  const Color.fromARGB(255, 223, 132, 223),
                            ),
                            onPressed: showClearSupply
                                ? null
                                : () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SupplyList(),
                                      ),
                                    ).then((result) {
                                      if (result != null && result is List) {
                                        setState(() {
                                          selectedSupplyList =
                                              List<Map<String, dynamic>>.from(
                                                  result);
                                          // แสดงชื่อใน TextField
                                          supplyList.text = selectedSupplyList
                                              .map((e) => e['name'].toString())
                                              .join(', ');

                                          // เก็บ id สำหรับส่ง API (เช่น 01,05,07)
                                          itemSupplyIds = selectedSupplyList
                                              .map((e) => e['id'].toString())
                                              .join(',');
                                          // print(
                                          //     'itemSupplyIds: $itemSupplyIds');
                                        });
                                      }
                                    });
                                  },
                            child: const Icon(
                              Icons.search,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 3)
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          child: Text(
                            'เดือนที่ 1 : ',
                            style: MyContant().h4normalStyle(),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        selectMonth1(sizeIcon, border),
                        SizedBox(
                          child: Text(
                            'ปี : ',
                            style: MyContant().h4normalStyle(),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        selectYear1(sizeIcon, border),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          child: Text(
                            'เดือนที่ 2 : ',
                            style: MyContant().h4normalStyle(),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        selectMonth2(sizeIcon, border),
                        SizedBox(
                          child: Text(
                            'ปี : ',
                            style: MyContant().h4normalStyle(),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        selectYear2(sizeIcon, border),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          child: Text(
                            'เดือนที่ 3 : ',
                            style: MyContant().h4normalStyle(),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        selectMonth3(sizeIcon, border),
                        SizedBox(
                          child: Text(
                            'ปี : ',
                            style: MyContant().h4normalStyle(),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        selectYear3(sizeIcon, border),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          child: Text(
                            'เดือนที่ 4 : ',
                            style: MyContant().h4normalStyle(),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        selectMonth4(sizeIcon, border),
                        SizedBox(
                          child: Text(
                            'ปี : ',
                            style: MyContant().h4normalStyle(),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        selectYear4(sizeIcon, border),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Checkbox(
                          side: WidgetStateBorderSide.resolveWith(
                            (Set<WidgetState> states) {
                              return const BorderSide(
                                color: Color.fromARGB(255, 0, 0, 0),
                                width: 1.7,
                              );
                            },
                          ),
                          value: isChkExclude,
                          checkColor: const Color.fromARGB(255, 0, 0, 0),
                          activeColor: const Color.fromARGB(255, 255, 255, 255),
                          onChanged: (bool? value) {
                            setState(() {
                              isChkExclude = value!;
                            });
                            idChkExclude = isChkExclude ? '1' : '';
                          },
                          visualDensity: VisualDensity.compact,
                        ),
                        Text(
                          'ไม่ดึงข้อมูลย้อนหลัง 1 ปี',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Prompt',
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            groupBtnsearch(),
            SizedBox(height: 30),
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
                        String normalizeId(dynamic value) {
                          if (value == null) return '';
                          final v = value.toString().trim();
                          return (v == '99') ? '' : v;
                        }

                        // ✅ ดึง supplyId ทั้งหมดจาก brandList ที่ผูกไว้
                        final List<String> supplyIds = brandList
                            .map((e) => (e['supplyId'] ?? '').toString())
                            .where((id) => id.isNotEmpty)
                            .toList();

                        print('🔹 supplyIds (system-linked): $supplyIds');

                        // ✅ ผู้ใช้ไม่ได้เลือก supplyId เลย
                        final bool noSupplySelected =
                            itemSupplyIds.trim().isEmpty;

                        // ✅ ถ้า user ไม่เลือก และระบบมี supplyIds มากกว่า 1 → ส่งทั้งหมดแทน
                        final Object supplyToSend =
                            (noSupplySelected && supplyIds.length > 1)
                                ? supplyIds
                                : itemSupplyIds;

                        print("🔹 supplyToSend: $supplyToSend");

                        if (itemGroup.text.isEmpty &&
                            itemType.text.isEmpty &&
                            itemBrand.text.isEmpty) {
                          showProgressDialog(context, 'แจ้งเตือน',
                              'กรุณาเลือกกลุ่มสินค้า ประเภทสินค้า ยี่ห้อสินค้า');
                        } else if (itemType.text.isEmpty &&
                            itemBrand.text.isEmpty) {
                          showProgressDialog(context, 'แจ้งเตือน',
                              'กรุณาเลือกประเภทสินค้าและยี่ห้อสินค้า');
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReportSKUSaleList(
                                itemGroupIds: itemGroupIds,
                                itemTypeIds: itemTypeIds,
                                idBrandlist: idBrandlist,
                                idModellist: idModellist,
                                idStylellist: idStylellist,
                                idSizelist: idSizelist,
                                idColorlist: idColorlist,
                                selectProvinbranchlist:
                                    normalizeId(selectProvinbranchlist),
                                selectBranchgrouplist:
                                    normalizeId(selectBranchgrouplist),
                                selectAreaBranchlist:
                                    normalizeId(selectAreaBranchlist),
                                itemSupplyIds: supplyToSend,
                                startdate: startdate.text.replaceAll('-', ''),
                                startdatePO:
                                    startdatePO.text.replaceAll('-', ''),
                                enddatePO: enddatePO.text.replaceAll('-', ''),
                                startDatesale:
                                    startDatesale.text.replaceAll('-', ''),
                                endDatesale:
                                    endDatesale.text.replaceAll('-', ''),
                                selectMonthId1: selectMonthId1,
                                selectMonthId2: selectMonthId2,
                                selectMonthId3: selectMonthId3,
                                selectMonthId4: selectMonthId4,
                                selectYearlist1: selectYearlist1,
                                selectYearlist2: selectYearlist2,
                                selectYearlist3: selectYearlist3,
                                selectYearlist4: selectYearlist4,
                                idChkExclude: idChkExclude,
                              ),
                            ),
                          );
                        }
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
                          clearInputandSelect();
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

  final _border = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.transparent, width: 0),
    borderRadius: BorderRadius.all(Radius.circular(5.0)),
  );

  final _sizeIcon = BoxConstraints(minWidth: 40, minHeight: 40);

  Expanded inputItemGroup() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: TextField(
          readOnly: true,
          controller: itemGroup,
          decoration: InputDecoration(
            suffixIcon: itemGroup.text.isEmpty
                ? null
                : GestureDetector(
                    onTap: () {
                      setState(() {
                        itemGroup.clear();
                        itemGroupIds = '';
                        itemType.clear();
                        itemTypeIds = '';
                      });
                    },
                    child: const Icon(Icons.close),
                  ),
            contentPadding: const EdgeInsets.all(8),
            isDense: true,
            enabledBorder: _border,
            focusedBorder: _border,
            prefixIconConstraints: _sizeIcon,
            suffixIconConstraints: _sizeIcon,
            filled: true,
            fillColor: Colors.white,
          ),
          style: MyContant().textInputStyle(),
        ),
      ),
    );
  }

  Expanded inputItemType() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: TextField(
          readOnly: true,
          controller: itemType,
          decoration: InputDecoration(
            suffixIcon: itemType.text.isEmpty
                ? null
                : GestureDetector(
                    onTap: () {
                      setState(() {
                        itemType.clear();
                        itemTypeIds = '';
                      });
                    },
                    child: const Icon(Icons.close),
                  ),
            contentPadding: const EdgeInsets.all(8),
            isDense: true,
            enabledBorder: _border,
            focusedBorder: _border,
            prefixIconConstraints: _sizeIcon,
            suffixIconConstraints: _sizeIcon,
            filled: true,
            fillColor: Colors.white,
          ),
          style: MyContant().textInputStyle(),
        ),
      ),
    );
  }

  Expanded inputItemBrand() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: TextField(
          controller: itemBrand,
          readOnly: true,
          decoration: InputDecoration(
            suffixIcon: showClearBrand
                ? null
                : itemBrand.text.isEmpty
                    ? null
                    : GestureDetector(
                        onTap: () {
                          setState(() {
                            itemBrand.clear();
                            idBrandlist = null;
                          });
                        },
                        child: const Icon(Icons.close),
                      ),
            contentPadding: const EdgeInsets.all(8),
            isDense: true,
            enabledBorder: _border,
            focusedBorder: _border,
            prefixIconConstraints: _sizeIcon,
            suffixIconConstraints: _sizeIcon,
            filled: true,
            fillColor: Colors.white,
          ),
          style: MyContant().textInputStyle(),
        ),
      ),
    );
  }

  Expanded inputItemModel() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: TextField(
          controller: itemModel,
          readOnly: true,
          decoration: InputDecoration(
            suffixIcon: itemModel.text.isEmpty
                ? null
                : GestureDetector(
                    onTap: () {
                      setState(() {
                        itemModel.clear();
                        idModellist = null;
                      });
                    },
                    child: const Icon(Icons.close),
                  ),
            contentPadding: const EdgeInsets.all(8),
            isDense: true,
            enabledBorder: _border,
            focusedBorder: _border,
            prefixIconConstraints: _sizeIcon,
            suffixIconConstraints: _sizeIcon,
            filled: true,
            fillColor: Colors.white,
          ),
          style: MyContant().textInputStyle(),
        ),
      ),
    );
  }

  Expanded inputItemStyle() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: TextField(
          controller: itemStyle,
          readOnly: true,
          decoration: InputDecoration(
            suffixIcon: itemStyle.text.isEmpty
                ? null
                : GestureDetector(
                    onTap: () {
                      setState(() {
                        itemStyle.clear();
                        idStylellist = null;
                      });
                    },
                    child: const Icon(Icons.close),
                  ),
            contentPadding: const EdgeInsets.all(8),
            isDense: true,
            enabledBorder: _border,
            focusedBorder: _border,
            prefixIconConstraints: _sizeIcon,
            suffixIconConstraints: _sizeIcon,
            filled: true,
            fillColor: Colors.white,
          ),
          style: MyContant().textInputStyle(),
        ),
      ),
    );
  }

  Expanded inputItemSize() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: TextField(
          controller: itemSize,
          readOnly: true,
          decoration: InputDecoration(
            suffixIcon: itemSize.text.isEmpty
                ? null
                : GestureDetector(
                    onTap: () {
                      setState(() {
                        itemSize.clear();
                        idSizelist = null;
                      });
                    },
                    child: const Icon(Icons.close),
                  ),
            contentPadding: const EdgeInsets.all(8),
            isDense: true,
            enabledBorder: _border,
            focusedBorder: _border,
            prefixIconConstraints: _sizeIcon,
            suffixIconConstraints: _sizeIcon,
            filled: true,
            fillColor: Colors.white,
          ),
          style: MyContant().textInputStyle(),
        ),
      ),
    );
  }

  Expanded inputItemColor() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: TextField(
          controller: itemColor,
          readOnly: true,
          decoration: InputDecoration(
            suffixIcon: itemColor.text.isEmpty
                ? null
                : GestureDetector(
                    onTap: () {
                      setState(() {
                        itemColor.clear();
                        idColorlist = null;
                      });
                    },
                    child: const Icon(Icons.close),
                  ),
            contentPadding: const EdgeInsets.all(8),
            isDense: true,
            enabledBorder: _border,
            focusedBorder: _border,
            prefixIconConstraints: _sizeIcon,
            suffixIconConstraints: _sizeIcon,
            filled: true,
            fillColor: Colors.white,
          ),
          style: MyContant().textInputStyle(),
        ),
      ),
    );
  }

  Expanded selectProvinbranch(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Container(
          height: 42,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: Padding(
            padding: const EdgeInsets.only(left: 4),
            child: DropdownButton<String>(
              items: dropdownbranchProvin
                  .map(
                    (value) => DropdownMenuItem<String>(
                      value: value['id'].toString(),
                      child: Text(
                        value['name'].toString(),
                        style: value['id'] == "99"
                            ? MyContant().TextInputSelect()
                            : MyContant().textInputStyle(),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (String? newvalue) {
                setState(() {
                  selectProvinbranchlist = newvalue;
                });
              },
              value: selectProvinbranchlist,
              isExpanded: true,
              underline: const SizedBox(),
              hint: Align(
                alignment: Alignment.center,
                child: Text(
                  'เลือกสาขาจังหวัด',
                  style: MyContant().TextInputSelect(),
                ),
              ),
              selectedItemBuilder: (BuildContext context) {
                return dropdownbranchProvin.map<Widget>((value) {
                  return Align(
                    alignment: value['id'] == "99"
                        ? Alignment.center
                        : Alignment.centerLeft,
                    child: Text(
                      value['name'],
                      style: value['id'] == "99"
                          ? MyContant().TextInputSelect()
                          : MyContant().textInputStyle(),
                      textAlign: value['id'] == "99"
                          ? TextAlign.center
                          : TextAlign.left,
                    ),
                  );
                }).toList();
              },
            ),
          ),
        ),
      ),
    );
  }

  Expanded selectBranchGroup(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Container(
          height: 42,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: Padding(
            padding: const EdgeInsets.only(left: 4),
            child: DropdownButton<String>(
              items: dropdownBranchGroup
                  .map(
                    (value) => DropdownMenuItem<String>(
                      value: value['id'].toString(),
                      child: Text(
                        value['name'].toString(),
                        style: value['id'] == "99"
                            ? MyContant().TextInputSelect()
                            : MyContant().textInputStyle(),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (String? newvalue) {
                setState(() {
                  selectBranchgrouplist = newvalue;
                });
              },
              value: selectBranchgrouplist,
              isExpanded: true,
              underline: const SizedBox(),
              hint: Align(
                alignment: Alignment.center,
                child: Text(
                  'เลือกกลุ่มสาขา',
                  style: MyContant().TextInputSelect(),
                ),
              ),
              selectedItemBuilder: (BuildContext context) {
                return dropdownBranchGroup.map<Widget>((value) {
                  return Align(
                    alignment: value['id'] == "99"
                        ? Alignment.center
                        : Alignment.centerLeft,
                    child: Text(
                      value['name'],
                      style: value['id'] == "99"
                          ? MyContant().TextInputSelect()
                          : MyContant().textInputStyle(),
                      textAlign: value['id'] == "99"
                          ? TextAlign.center
                          : TextAlign.left,
                    ),
                  );
                }).toList();
              },
            ),
          ),
        ),
      ),
    );
  }

  Expanded selectAreaBranch(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Container(
          height: 42,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: Padding(
            padding: const EdgeInsets.only(left: 4),
            child: DropdownButton<String>(
              items: dropdownAreaBranch
                  .map(
                    (value) => DropdownMenuItem<String>(
                      value: value['id'].toString(),
                      child: Text(
                        value['name'].toString(),
                        style: value['id'] == "99"
                            ? MyContant().TextInputSelect()
                            : MyContant().textInputStyle(),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (String? newvalue) {
                setState(() {
                  selectAreaBranchlist = newvalue;
                });
              },
              value: selectAreaBranchlist,
              isExpanded: true,
              underline: const SizedBox(),
              hint: Align(
                alignment: Alignment.center,
                child: Text(
                  'เลือกเขตสาขา',
                  style: MyContant().TextInputSelect(),
                ),
              ),
              selectedItemBuilder: (BuildContext context) {
                return dropdownAreaBranch.map<Widget>((value) {
                  return Align(
                    alignment: value['id'] == "99"
                        ? Alignment.center
                        : Alignment.centerLeft,
                    child: Text(
                      value['name'],
                      style: value['id'] == "99"
                          ? MyContant().TextInputSelect()
                          : MyContant().textInputStyle(),
                      textAlign: value['id'] == "99"
                          ? TextAlign.center
                          : TextAlign.left,
                    ),
                  );
                }).toList();
              },
            ),
          ),
        ),
      ),
    );
  }

  Expanded inputStartdate() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: TextField(
          controller: startdate,
          onChanged: (keyword) {},
          readOnly: true,
          decoration: InputDecoration(
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (startdate.text.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        startdate.clear();
                      });
                    },
                    child: const Icon(Icons.close),
                  ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.calendar_today,
                  color: Colors.black,
                ),
                const SizedBox(width: 8),
              ],
            ),
            contentPadding: const EdgeInsets.all(8),
            isDense: true,
            enabledBorder: _border,
            focusedBorder: _border,
            prefixIconConstraints: _sizeIcon,
            suffixIconConstraints: _sizeIcon,
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
                startdate.text =
                    '$newYear$formattedDate'; //set output date to TextField value.
              });
            } else {}
          },
        ),
      ),
    );
  }

  Expanded inputStartdatePO() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: TextField(
          controller: startdatePO,
          onChanged: (keyword) {},
          readOnly: true,
          decoration: InputDecoration(
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (startdatePO.text.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        startdatePO.clear();
                      });
                    },
                    child: const Icon(Icons.close),
                  ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.calendar_today,
                  color: Colors.black,
                ),
                const SizedBox(width: 8),
              ],
            ),
            contentPadding: const EdgeInsets.all(8),
            isDense: true,
            enabledBorder: _border,
            focusedBorder: _border,
            prefixIconConstraints: _sizeIcon,
            suffixIconConstraints: _sizeIcon,
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
                startdatePO.text =
                    '$newYear$formattedDate'; //set output date to TextField value.
              });
            } else {}
          },
        ),
      ),
    );
  }

  Expanded inputEnddatePO() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: TextField(
          controller: enddatePO,
          onChanged: (keyword) {},
          readOnly: true,
          decoration: InputDecoration(
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (enddatePO.text.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        enddatePO.clear();
                      });
                    },
                    child: const Icon(Icons.close),
                  ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.calendar_today,
                  color: Colors.black,
                ),
                const SizedBox(width: 8),
              ],
            ),
            contentPadding: const EdgeInsets.all(8),
            isDense: true,
            enabledBorder: _border,
            focusedBorder: _border,
            prefixIconConstraints: _sizeIcon,
            suffixIconConstraints: _sizeIcon,
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
                enddatePO.text =
                    '$newYear$formattedDate'; //set output date to TextField value.
              });
            } else {}
          },
        ),
      ),
    );
  }

  Expanded inputStartdateSale() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: TextField(
          controller: startDatesale,
          onChanged: (keyword) {},
          readOnly: true,
          decoration: InputDecoration(
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (startDatesale.text.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        startDatesale.clear();
                      });
                    },
                    child: const Icon(Icons.close),
                  ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.calendar_today,
                  color: Colors.black,
                ),
                const SizedBox(width: 8),
              ],
            ),
            contentPadding: const EdgeInsets.all(8),
            isDense: true,
            enabledBorder: _border,
            focusedBorder: _border,
            prefixIconConstraints: _sizeIcon,
            suffixIconConstraints: _sizeIcon,
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
                startDatesale.text =
                    '$newYear$formattedDate'; //set output date to TextField value.
              });
            } else {}
          },
        ),
      ),
    );
  }

  Expanded inputEnddateSale() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: TextField(
          controller: endDatesale,
          onChanged: (keyword) {},
          readOnly: true,
          decoration: InputDecoration(
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (endDatesale.text.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        endDatesale.clear();
                      });
                    },
                    child: const Icon(Icons.close),
                  ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.calendar_today,
                  color: Colors.black,
                ),
                const SizedBox(width: 8),
              ],
            ),
            contentPadding: const EdgeInsets.all(8),
            isDense: true,
            enabledBorder: _border,
            focusedBorder: _border,
            prefixIconConstraints: _sizeIcon,
            suffixIconConstraints: _sizeIcon,
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
                endDatesale.text =
                    '$newYear$formattedDate'; //set output date to TextField value.
              });
            } else {}
          },
        ),
      ),
    );
  }

  Expanded inputSupplyList() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: TextField(
          readOnly: true,
          controller: supplyList,
          decoration: InputDecoration(
            suffixIcon: showClearSupply
                ? null
                : supplyList.text.isEmpty
                    ? null
                    : GestureDetector(
                        onTap: () {
                          setState(() {
                            supplyList.clear();
                            itemSupplyIds = '';
                          });
                        },
                        child: const Icon(Icons.close),
                      ),
            contentPadding: const EdgeInsets.all(8),
            isDense: true,
            enabledBorder: _border,
            focusedBorder: _border,
            prefixIconConstraints: _sizeIcon,
            suffixIconConstraints: _sizeIcon,
            filled: true,
            fillColor: Colors.white,
          ),
          style: MyContant().textInputStyle(),
        ),
      ),
    );
  }

  Expanded selectMonth1(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Container(
          height: 42,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: Padding(
            padding: const EdgeInsets.only(left: 4),
            child: DropdownButton<String>(
              items: dropdownMonth1
                  .map((value) => DropdownMenuItem<String>(
                        value: value['id'].toString(),
                        child: Text(
                          value['name'],
                          style: MyContant().textInputStyle(),
                        ),
                      ))
                  .toList(),
              onChanged: (String? newvalue) {
                setState(() {
                  selectMonthId1 = newvalue;
                });
              },
              value: selectMonthId1,
              isExpanded: true,
              underline: const SizedBox(),
              hint: Align(
                child: Text(
                  'เลือกเดือน',
                  style: MyContant().TextInputSelect(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Expanded selectMonth2(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Container(
          height: 42,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: Padding(
            padding: const EdgeInsets.only(left: 4),
            child: DropdownButton<String>(
              items: dropdownMonth2
                  .map((value) => DropdownMenuItem<String>(
                        value: value['id'].toString(),
                        child: Text(
                          value['name'],
                          style: MyContant().textInputStyle(),
                        ),
                      ))
                  .toList(),
              onChanged: (String? newvalue) {
                setState(() {
                  selectMonthId2 = newvalue;
                });
              },
              value: selectMonthId2,
              isExpanded: true,
              underline: const SizedBox(),
              hint: Align(
                child: Text(
                  'เลือกเดือน',
                  style: MyContant().TextInputSelect(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Expanded selectMonth3(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Container(
          height: 42,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: Padding(
            padding: const EdgeInsets.only(left: 4),
            child: DropdownButton<String>(
              items: dropdownMonth3
                  .map((value) => DropdownMenuItem<String>(
                        value: value['id'].toString(),
                        child: Text(
                          value['name'],
                          style: MyContant().textInputStyle(),
                        ),
                      ))
                  .toList(),
              onChanged: (String? newvalue) {
                setState(() {
                  selectMonthId3 = newvalue;
                });
              },
              value: selectMonthId3,
              isExpanded: true,
              underline: const SizedBox(),
              hint: Align(
                child: Text(
                  'เลือกเดือน',
                  style: MyContant().TextInputSelect(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Expanded selectMonth4(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Container(
          height: 42,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: Padding(
            padding: const EdgeInsets.only(left: 4),
            child: DropdownButton<String>(
              items: dropdownMonth4
                  .map((value) => DropdownMenuItem<String>(
                        value: value['id'].toString(),
                        child: Text(
                          value['name'],
                          style: MyContant().textInputStyle(),
                        ),
                      ))
                  .toList(),
              onChanged: (String? newvalue) {
                setState(() {
                  selectMonthId4 = newvalue;
                });
              },
              value: selectMonthId4,
              isExpanded: true,
              underline: const SizedBox(),
              hint: Align(
                child: Text(
                  'เลือกเดือน',
                  style: MyContant().TextInputSelect(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Expanded selectYear1(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Container(
          height: 42,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: Padding(
            padding: const EdgeInsets.only(left: 4),
            child: DropdownButton<String>(
              items: dropdownYear1
                  .map((value) => DropdownMenuItem<String>(
                        value: value.toString(),
                        child: Text(
                          value.toString(),
                          style: MyContant().textInputStyle(),
                        ),
                      ))
                  .toList(),
              onChanged: (String? newvalue) {
                setState(() {
                  selectYearlist1 = newvalue;
                });
              },
              value: selectYearlist1,
              isExpanded: true,
              underline: const SizedBox(),
              hint: Align(
                child: Text(
                  'เลือกปี พ.ศ.',
                  style: MyContant().TextInputSelect(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Expanded selectYear2(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Container(
          height: 42,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: Padding(
            padding: const EdgeInsets.only(left: 4),
            child: DropdownButton<String>(
              items: dropdownYear2
                  .map((value) => DropdownMenuItem<String>(
                        value: value.toString(),
                        child: Text(
                          value.toString(),
                          style: MyContant().textInputStyle(),
                        ),
                      ))
                  .toList(),
              onChanged: (String? newvalue) {
                setState(() {
                  selectYearlist2 = newvalue;
                });
              },
              value: selectYearlist2,
              isExpanded: true,
              underline: const SizedBox(),
              hint: Align(
                child: Text(
                  'เลือกปี พ.ศ.',
                  style: MyContant().TextInputSelect(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Expanded selectYear3(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Container(
          height: 42,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: Padding(
            padding: const EdgeInsets.only(left: 4),
            child: DropdownButton<String>(
              items: dropdownYear3
                  .map((value) => DropdownMenuItem<String>(
                        value: value.toString(),
                        child: Text(
                          value.toString(),
                          style: MyContant().textInputStyle(),
                        ),
                      ))
                  .toList(),
              onChanged: (String? newvalue) {
                setState(() {
                  selectYearlist3 = newvalue;
                });
              },
              value: selectYearlist3,
              isExpanded: true,
              underline: const SizedBox(),
              hint: Align(
                child: Text(
                  'เลือกปี พ.ศ.',
                  style: MyContant().TextInputSelect(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Expanded selectYear4(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Container(
          height: 42,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: Padding(
            padding: const EdgeInsets.only(left: 4),
            child: DropdownButton<String>(
              items: dropdownYear4
                  .map((value) => DropdownMenuItem<String>(
                        value: value.toString(),
                        child: Text(
                          value.toString(),
                          style: MyContant().textInputStyle(),
                        ),
                      ))
                  .toList(),
              onChanged: (String? newvalue) {
                setState(() {
                  selectYearlist4 = newvalue;
                });
              },
              value: selectYearlist4,
              isExpanded: true,
              underline: const SizedBox(),
              hint: Align(
                child: Text(
                  'เลือกปี พ.ศ.',
                  style: MyContant().TextInputSelect(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ItemGroupList extends StatefulWidget {
  const ItemGroupList({super.key});

  @override
  State<ItemGroupList> createState() => _ItemGroupListState();
}

class _ItemGroupListState extends State<ItemGroupList> {
  String userId = '', empId = '', firstName = '', lastName = '', tokenId = '';
  TextEditingController itemgrouplist = TextEditingController();
  List<dynamic> dropdowngrouplist = [];
  List<dynamic> originalGroupList = []; // เก็บข้อมูลเดิมก่อนค้นหา
  bool statusLoading = false,
      statusLoad404 = false,
      isLoading = false,
      isLoadScroll = false,
      isLoadendPage = false;
  final scrollControll = TrackingScrollController();
  int offset = 30, stquery = 0;
  List<bool> isCheckedList = [];
  Set<String> selectedGroupSet = {};
  List<Map<String, String>> selectedGroupList = [];

  @override
  void initState() {
    super.initState();
    getdata();
    itemgrouplist.addListener(() {
      setState(() {}); // อัปเดต UI ทุกครั้งที่ค่าของ TextField เปลี่ยน
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
    });
    if (mounted) {
      getSelectGroupList(offset);
    }
    myScroll(scrollControll, offset);
  }

  void myScroll(ScrollController scrollController, int offset) {
    scrollController.addListener(() async {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 10) {
        if (isLoadScroll || isLoadendPage) return;
        setState(() => isLoadScroll = true);
        await Future.delayed(const Duration(seconds: 1));

        // โหลดเพิ่มสำหรับข้อมูลเริ่มต้น (ไม่ใช้ search)
        if (itemgrouplist.text.isEmpty) {
          offset += 20;
          await getSelectGroupList(offset, loadMore: true);
        } else {
          // โหลดเพิ่มสำหรับข้อมูลค้นหา
          offset += 20;
          await searchItemGroup(offset, itemgrouplist.text, loadMore: true);
        }

        setState(() => isLoadScroll = false);
      }
    });
  }

  // ค้นหากลุ่มสินค้า
  Future<void> searchItemGroup(offset, String keyword,
      {bool loadMore = false}) async {
    try {
      var response = await http.get(
        Uri.parse(
            '${api}setup/itemGroupList?searchName=$keyword&page=1&limit=$offset'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> dataGrouplist =
            Map<String, dynamic>.from(json.decode(response.body));
        final List<Map<String, dynamic>> searchList =
            (dataGrouplist['data'] as List)
                .map((e) => Map<String, dynamic>.from(e as Map))
                .toList();

        setState(() {
          if (!loadMore) {
            dropdowngrouplist = List.of(searchList, growable: true);
            isCheckedList = dropdowngrouplist
                .map((e) => selectedGroupSet.contains(e['id'].toString()))
                .toList();
            isLoadendPage = false;
          } else {
            final existingIds =
                dropdowngrouplist.map((e) => e['id'].toString()).toSet();
            final uniqueNew = searchList
                .where((e) => !existingIds.contains(e['id'].toString()))
                .toList();

            if (uniqueNew.isEmpty) {
              isLoadendPage = true;
            } else {
              dropdowngrouplist.addAll(uniqueNew);
              isCheckedList.addAll(uniqueNew
                  .map((e) => selectedGroupSet.contains(e['id'].toString()))
                  .toList());
            }
          }

          statusLoading = true;
        });
      } else {
        handleHttpError(response.statusCode);
      }
    } catch (e) {
      showProgressDialog(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
  }

  Future<void> getSelectGroupList(offset, {bool loadMore = false}) async {
    try {
      var response = await http.get(
        Uri.parse(
            '${api}setup/itemGroupList?searchName=${itemgrouplist.text}&page=1&limit=$offset'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> dataGrouplist =
            Map<String, dynamic>.from(json.decode(response.body));
        final List<Map<String, dynamic>> newList =
            (dataGrouplist['data'] as List)
                .map((e) => Map<String, dynamic>.from(e as Map))
                .toList();

        setState(() {
          if (!loadMore) {
            // โหลดเริ่มต้น / รีเฟรช
            dropdowngrouplist = newList;
            originalGroupList = List.from(newList); // เก็บสำรอง
            isCheckedList = dropdowngrouplist
                .map((e) => selectedGroupSet.contains(e['id'].toString()))
                .toList();
            offset = dropdowngrouplist.length;
            isLoadendPage = false;
          } else {
            // โหลดเพิ่ม
            final existingIds =
                dropdowngrouplist.map((e) => e['id'].toString()).toSet();
            final uniqueNew = newList
                .where((e) => !existingIds.contains(e['id'].toString()))
                .toList();
            if (uniqueNew.isEmpty) {
              isLoadendPage = true;
            } else {
              dropdowngrouplist.addAll(uniqueNew);
              isCheckedList.addAll(uniqueNew
                  .map((e) => selectedGroupSet.contains(e['id'].toString()))
                  .toList());
              offset = dropdowngrouplist.length;
            }
          }
          statusLoading = true;
        });
      } else {
        handleHttpError(response.statusCode);
      }
    } catch (e) {
      showProgressDialog(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
  }

  // แยกฟังก์ชัน handle error HTTP
  void handleHttpError(int statusCode) async {
    if (statusCode == 400) {
      showProgressDialog_400(context, 'แจ้งเตือน', 'ไม่พบข้อมูล ($statusCode)');
    } else if (statusCode == 401) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.clear();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Authen()),
        (Route<dynamic> route) => false,
      );
      showProgressDialog_401(
          context, 'แจ้งเตือน', 'กรุณา Login เข้าสู่ระบบใหม่');
    } else if (statusCode == 404) {
      setState(() {
        statusLoading = true;
        statusLoad404 = true;
      });
    } else if (statusCode == 405) {
      showProgressDialog_405(context, 'แจ้งเตือน', 'ไม่พบข้อมูล ($statusCode)');
    } else if (statusCode == 500) {
      showProgressDialog_500(
          context, 'แจ้งเตือน', 'ข้อมูลผิดพลาด ($statusCode)');
    } else {
      showProgressDialog(context, 'แจ้งเตือน', 'กรุณาติดต่อผู้ดูแลระบบ');
    }
  }

  void toggleCheckItem(int index, bool? value) {
    final id = dropdowngrouplist[index]['id'].toString();
    final name = dropdowngrouplist[index]['name'].toString();
    final checked = value ?? false;

    setState(() {
      if (checked) {
        if (!selectedGroupList.any((item) => item['id'] == id)) {
          selectedGroupList.add({'id': id, 'name': name});
        }
      } else {
        selectedGroupList.removeWhere((item) => item['id'] == id);
      }
    });
  }

  // ล้างค้นหาโดยไม่ลบ checkbox
  Future<void> clearSearchAndReload() async {
    setState(() {
      itemgrouplist.clear();
      statusLoad404 = false;
      statusLoading = false;
    });

    await Future.delayed(
        const Duration(milliseconds: 100)); // กัน state race (optional)

    setState(() {
      dropdowngrouplist = List.from(originalGroupList);
      isCheckedList = dropdowngrouplist
          .map((e) => selectedGroupSet.contains(e['id'].toString()))
          .toList();
      offset = dropdowngrouplist.length;
      isLoadendPage = false;
      statusLoading = true;
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
      borderRadius: BorderRadius.all(Radius.circular(4.0)),
    );

    final hasSelected = selectedGroupList.isNotEmpty;
    return Scaffold(
      appBar: const CustomAppbar(title: 'ค้นหากลุ่มสินค้า'),
      body: Stack(
        children: [
          GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
            behavior: HitTestBehavior.opaque,
            child: Column(
              children: [
                // Search input
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withAlpha(130),
                          spreadRadius: 0.2,
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        )
                      ],
                      color: const Color.fromRGBO(239, 191, 239, 1),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(180),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Text('กลุ่มสินค้า : ',
                              style: MyContant().h4normalStyle()),
                          inputGroupNamelist(sizeIcon, border),
                        ],
                      ),
                    ),
                  ),
                ),
                groupBtnsearch(),
                Expanded(
                  child: buildListView(),
                ),
              ],
            ),
          ),
          // ✅ ปุ่มล่างแบบเด้งขึ้น
          AnimatedPositioned(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            bottom: hasSelected ? 0 : -100, // เด้งขึ้นถ้ามีการติ๊ก
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.only(
                    top: 15, bottom: 30, left: 0, right: 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(40),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // ปุ่มตกลง
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.040,
                      width: MediaQuery.of(context).size.width * 0.25,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context, selectedGroupList);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'ตกลง',
                          style: MyContant().h1MenuStyle(),
                        ),
                      ),
                    ),

                    // ปุ่มยกเลิก
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.040,
                      width: MediaQuery.of(context).size.width * 0.25,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedGroupList.clear();
                            isCheckedList =
                                List.filled(dropdowngrouplist.length, false);
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'ยกเลิก',
                          style: MyContant().h1MenuStyle(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // สร้าง listview / scroll
  Widget buildListView() {
    if (!statusLoading) {
      return Center(child: Image.asset(cupertinoActivityIndicator, scale: 4));
    }
    if (statusLoad404) {
      return Center(
        child: Center( 
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
                      color: const Color.fromARGB(255, 158, 158, 158),
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
        ),
      );
    }

    return SingleChildScrollView(
      controller: scrollControll,
      physics:
          const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
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
                color: const Color.fromRGBO(239, 191, 239, 1),
              ),
              child: Column(
                children: [
                  for (var i = 0; i < dropdowngrouplist.length; i++) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: Row(
                        children: [
                          // กล่อง Checkbox
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.7),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Checkbox(
                              side: WidgetStateBorderSide.resolveWith(
                                (Set<WidgetState> states) {
                                  return const BorderSide(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    width: 1.7,
                                  );
                                },
                              ),
                              value: selectedGroupList.any(
                                (item) =>
                                    item['id'] ==
                                    dropdowngrouplist[i]['id'].toString(),
                              ),
                              onChanged: (bool? value) {
                                toggleCheckItem(i, value);
                              },
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              checkColor: Colors.black,
                              activeColor: Colors.white.withAlpha(180),
                            ),
                          ),

                          const SizedBox(width: 6),

                          // กล่องข้อความ
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                // Navigator.pop(context, {
                                //   'id': '${dropdownsupplylist[i]['id']}',
                                //   'name': '${dropdownsupplylist[i]['name']}',
                                // });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.7),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  dropdowngrouplist[i]['name'],
                                  style: MyContant().h4normalStyle(),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (isLoadScroll && !isLoadendPage) const LoadData(),
          if (isLoadendPage) const EndPage(),
          SizedBox(
            height: selectedGroupList.isNotEmpty ? 100 : 20,
          ),
        ],
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
                      onPressed: () async {
                        await searchItemGroup(
                            offset, itemgrouplist.text); // ทำงาน async ก่อน
                        setState(() {
                          // อัปเดตสถานะหลังจาก search เสร็จ
                          statusLoading = true;
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
                      onPressed: () async {
                        await clearSearchAndReload();
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

  Expanded inputGroupNamelist(BoxConstraints sizeIcon, InputBorder border) {
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
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: TextField(
          controller: itemgrouplist,
          decoration: InputDecoration(
            suffixIcon: itemgrouplist.text.isEmpty
                ? null
                : GestureDetector(
                    onTap: () async {
                      await clearSearchAndReload();
                    },
                    child: const Icon(Icons.close),
                  ),
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
}

class ItemTypeList extends StatefulWidget {
  final List<String>? valueGrouplist;
  const ItemTypeList({super.key, this.valueGrouplist});

  @override
  State<ItemTypeList> createState() => _ItemTypeListState();
}

class _ItemTypeListState extends State<ItemTypeList> {
  String userId = '', empId = '', firstName = '', lastName = '', tokenId = '';
  TextEditingController itemtypelist = TextEditingController();
  List<dynamic> dropdowntypelist = [];
  List<dynamic> originalItemTypeList = []; // เก็บข้อมูลเดิมก่อนค้นหา
  bool statusLoading = false,
      statusLoad404 = false,
      isLoading = false,
      isLoadScroll = false,
      isLoadendPage = false;
  final scrollControll = TrackingScrollController();
  int offset = 30, stquery = 0;
  String? valGroupList = '';
  List<bool> isCheckedList = [];
  List<String> selectedItemType = [];
  Set<String> selectedItemTypeSet = {};
  List<Map<String, String>> selectedItemTypeList = [];
  late List<String> groupIds;
  String groupIdsParam = '';

  @override
  void initState() {
    super.initState();
    getdata();
    itemtypelist.addListener(() {
      setState(() {}); // อัปเดต UI ทุกครั้งที่ค่าของ TextField เปลี่ยน
    });

    groupIds = widget.valueGrouplist ?? [];
    groupIdsParam = (groupIds.isNotEmpty) ? groupIds.join(',') : '';
    print('groupIdsParam: $groupIdsParam'); // ตรวจสอบค่าที่ส่งมา
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
    if (mounted) {
      getSelectTypeList(offset);
    }
    myScroll(scrollControll, offset);
  }

  void myScroll(ScrollController scrollController, int offset) {
    scrollController.addListener(() async {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 10) {
        if (isLoadScroll || isLoadendPage) return;
        setState(() => isLoadScroll = true);
        await Future.delayed(const Duration(seconds: 1));

        // โหลดเพิ่มสำหรับข้อมูลเริ่มต้น (ไม่ใช้ search)
        if (itemtypelist.text.isEmpty) {
          offset += 20;
          await getSelectTypeList(offset, loadMore: true);
        } else {
          // โหลดเพิ่มสำหรับข้อมูลค้นหา
          offset += 20;
          await searchItemtype(offset, itemtypelist.text, loadMore: true);
        }

        setState(() => isLoadScroll = false);
      }
    });
  }

  Future<void> getSelectTypeList(offset, {bool loadMore = false}) async {
    try {
      var response = await http.get(
        Uri.parse(
            '${api}setup/itemTypeList?searchName=${itemtypelist.text}&page=1&limit=$offset&itemGroupId=$groupIdsParam&itemStatus=1'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> dataTypelist =
            Map<String, dynamic>.from(json.decode(response.body));
        final List<Map<String, dynamic>> newList =
            (dataTypelist['data'] as List)
                .map((e) => Map<String, dynamic>.from(e as Map))
                .toList();

        setState(() {
          if (!loadMore) {
            // โหลดเริ่มต้น / รีเฟรช
            dropdowntypelist = List.of(newList, growable: true);
            originalItemTypeList =
                List.of(newList, growable: true); // เก็บสำรอง
            isCheckedList = dropdowntypelist
                .map((e) => selectedItemTypeSet.contains(e['id'].toString()))
                .toList();
            offset = dropdowntypelist.length;
            isLoadendPage = false;
          } else {
            // โหลดเพิ่ม
            dropdowntypelist = List.of(dropdowntypelist, growable: true);
            isCheckedList = List.of(isCheckedList, growable: true);

            final existingIds =
                dropdowntypelist.map((e) => e['id'].toString()).toSet();
            final uniqueNew = newList
                .where((e) => !existingIds.contains(e['id'].toString()))
                .toList();

            if (uniqueNew.isEmpty) {
              isLoadendPage = true;
            } else {
              dropdowntypelist.addAll(uniqueNew);
              isCheckedList.addAll(uniqueNew
                  .map((e) => selectedItemTypeSet.contains(e['id'].toString()))
                  .toList());
              offset = dropdowntypelist.length;
            }
          }
          statusLoading = true;
        });
      } else {
        handleHttpError(response.statusCode);
      }
    } catch (e) {
      showProgressDialog(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
  }

  // ค้นหาผู้จำหน่าย
  Future<void> searchItemtype(offset, String keyword,
      {bool loadMore = false}) async {
    try {
      var response = await http.get(
        Uri.parse(
            '${api}setup/itemTypeList?searchName=$keyword&page=1&limit=$offset&itemGroupId=$groupIdsParam&itemStatus=1'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> dataTypelist =
            Map<String, dynamic>.from(json.decode(response.body));
        final List<Map<String, dynamic>> searchList =
            (dataTypelist['data'] as List)
                .map((e) => Map<String, dynamic>.from(e as Map))
                .toList();

        setState(() {
          if (!loadMore) {
            dropdowntypelist = List.of(searchList, growable: true);
            isCheckedList = dropdowntypelist
                .map((e) => selectedItemTypeSet.contains(e['id'].toString()))
                .toList();
            isLoadendPage = false;
          } else {
            final existingIds =
                dropdowntypelist.map((e) => e['id'].toString()).toSet();
            final uniqueNew = searchList
                .where((e) => !existingIds.contains(e['id'].toString()))
                .toList();

            if (uniqueNew.isEmpty) {
              isLoadendPage = true;
            } else {
              dropdowntypelist.addAll(uniqueNew);
              isCheckedList.addAll(uniqueNew
                  .map((e) => selectedItemTypeSet.contains(e['id'].toString()))
                  .toList());
            }
          }

          statusLoading = true;
        });
      } else {
        handleHttpError(response.statusCode);
      }
    } catch (e) {
      showProgressDialog(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ2');
    }
  }

  // แยกฟังก์ชัน handle error HTTP
  void handleHttpError(int statusCode) async {
    if (statusCode == 400) {
      showProgressDialog_400(context, 'แจ้งเตือน', 'ไม่พบข้อมูล ($statusCode)');
    } else if (statusCode == 401) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.clear();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Authen()),
        (Route<dynamic> route) => false,
      );
      showProgressDialog_401(
          context, 'แจ้งเตือน', 'กรุณา Login เข้าสู่ระบบใหม่');
    } else if (statusCode == 404) {
      setState(() {
        statusLoading = true;
        statusLoad404 = true;
      });
    } else if (statusCode == 405) {
      showProgressDialog_405(context, 'แจ้งเตือน', 'ไม่พบข้อมูล ($statusCode)');
    } else if (statusCode == 500) {
      showProgressDialog_500(
          context, 'แจ้งเตือน', 'ข้อมูลผิดพลาด ($statusCode)');
    } else {
      showProgressDialog(context, 'แจ้งเตือน', 'กรุณาติดต่อผู้ดูแลระบบ');
    }
  }

  void toggleCheckItem(int index, bool? value) {
    final id = dropdowntypelist[index]['id'].toString();
    final name = dropdowntypelist[index]['name'].toString();
    final checked = value ?? false;

    setState(() {
      if (checked) {
        if (!selectedItemTypeList.any((item) => item['id'] == id)) {
          selectedItemTypeList.add({'id': id, 'name': name});
        }
      } else {
        selectedItemTypeList.removeWhere((item) => item['id'] == id);
      }

      // print('✅ selectedItemType: $selectedItemTypeList');
    });
  }

  // ล้างค้นหาโดยไม่ลบ checkbox
  Future<void> clearSearchAndReload() async {
    setState(() {
      offset = 30; // รีเซ็ต offset
      itemtypelist.clear();
      statusLoad404 = false;
      statusLoading = false;
    });

    await Future.delayed(
        const Duration(milliseconds: 100)); // กัน state race (optional)

    setState(() {
      dropdowntypelist = List.from(originalItemTypeList);
      isCheckedList = dropdowntypelist
          .map((e) => selectedItemTypeSet.contains(e['id'].toString()))
          .toList();
      offset = dropdowntypelist.length;
      print('offset drop: ${dropdowntypelist.length}');
      isLoadendPage = false;
      statusLoading = true;
      print('offset after clear: $offset');
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
      borderRadius: BorderRadius.all(Radius.circular(4.0)),
    );

    final hasSelected = selectedItemTypeList.isNotEmpty;
    return Scaffold(
      appBar: const CustomAppbar(title: 'ค้นหาประเภทสินค้า'),
      body: Stack(
        children: [
          GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
            behavior: HitTestBehavior.opaque,
            child: Column(
              children: [
                // Search input
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withAlpha(130),
                          spreadRadius: 0.2,
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        )
                      ],
                      color: const Color.fromRGBO(239, 191, 239, 1),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(180),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Text('ประเภทสินค้า : ',
                              style: MyContant().h4normalStyle()),
                          inputTypeNamelist(sizeIcon, border),
                        ],
                      ),
                    ),
                  ),
                ),
                groupBtnsearch(),
                Expanded(
                  child: buildListView(),
                ),
              ],
            ),
          ),
          // ✅ ปุ่มล่างแบบเด้งขึ้น
          AnimatedPositioned(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            bottom: hasSelected ? 0 : -100, // เด้งขึ้นถ้ามีการติ๊ก
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(40),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // ปุ่มตกลง
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, selectedItemTypeList);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'ตกลง',
                        style: MyContant().h1MenuStyle(),
                      ),
                    ),

                    // ปุ่มยกเลิก
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedItemTypeList.clear();
                          isCheckedList =
                              List.filled(dropdowntypelist.length, false);
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'ยกเลิก',
                        style: MyContant().h1MenuStyle(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // สร้าง listview / scroll
  Widget buildListView() {
    if (!statusLoading) {
      return Center(child: Image.asset(cupertinoActivityIndicator, scale: 4));
    }
    if (statusLoad404) {
      return Center(
        child: Center(
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
                      color: const Color.fromARGB(255, 158, 158, 158),
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
        ),
      );
    }

    return SingleChildScrollView(
      controller: scrollControll,
      physics:
          const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
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
                color: const Color.fromRGBO(239, 191, 239, 1),
              ),
              child: Column(
                children: [
                  for (var i = 0; i < dropdowntypelist.length; i++) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: Row(
                        children: [
                          // กล่อง Checkbox
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.7),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Checkbox(
                              side: WidgetStateBorderSide.resolveWith(
                                (Set<WidgetState> states) {
                                  return const BorderSide(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    width: 1.7,
                                  );
                                },
                              ),
                              value: selectedItemTypeList.any(
                                (item) =>
                                    item['id'] ==
                                    dropdowntypelist[i]['id'].toString(),
                              ),
                              onChanged: (bool? value) {
                                toggleCheckItem(i, value);
                              },
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              checkColor: Colors.black,
                              activeColor: Colors.white.withAlpha(180),
                            ),
                          ),

                          const SizedBox(width: 6),

                          // กล่องข้อความ
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                // Navigator.pop(context, {
                                //   'id': '${dropdownsupplylist[i]['id']}',
                                //   'name': '${dropdownsupplylist[i]['name']}',
                                // });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.7),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  dropdowntypelist[i]['name'],
                                  style: MyContant().h4normalStyle(),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (isLoadScroll && !isLoadendPage) const LoadData(),
          if (isLoadendPage) const EndPage(),
          SizedBox(
            height: selectedItemTypeList.isNotEmpty ? 100 : 20,
          ),
        ],
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
                      onPressed: () async {
                        offset = 30; // รีเซ็ต offset ก่อนค้นหาใหม่
                        await searchItemtype(
                            offset, itemtypelist.text); // ทำงาน async ก่อน
                        setState(() {
                          // อัปเดตสถานะหลังจาก search เสร็จ
                          statusLoading = true;
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
                      onPressed: () async {
                        await clearSearchAndReload();
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

  Expanded inputTypeNamelist(BoxConstraints sizeIcon, InputBorder border) {
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
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: TextField(
          controller: itemtypelist,
          decoration: InputDecoration(
            suffixIcon: itemtypelist.text.isEmpty
                ? null
                : GestureDetector(
                    onTap: () async {
                      await clearSearchAndReload();
                    },
                    child: const Icon(Icons.close),
                  ),
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
}

class ItemBrandList extends StatefulWidget {
  const ItemBrandList({super.key});

  @override
  State<ItemBrandList> createState() => _ItemBrandListState();
}

class _ItemBrandListState extends State<ItemBrandList> {
  String userId = '', empId = '', firstName = '', lastName = '', tokenId = '';
  List<String>? itemBrandPC;
  TextEditingController itembrandlist = TextEditingController();
  List<dynamic> dropdownbrandlist = [];
  bool statusLoading = false,
      statusLoad404 = false,
      isLoading = false,
      isLoadScroll = false,
      isLoadendPage = false;
  final scrollControll = TrackingScrollController();
  int offset = 30, stquery = 0;
  String? valGroupList = '', valTypeList = '';

  @override
  void initState() {
    super.initState();
    getdata();
    itembrandlist.addListener(() {
      setState(() {}); // อัปเดต UI ทุกครั้งที่ค่าของ TextField เปลี่ยน
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
      itemBrandPC = preferences.getStringList('itemBrandPC')!;
    });

    if (mounted) {
      // getSelectBrandList(offset);
      loadBrandList(offset);
    }
    myScroll(scrollControll, offset);
  }

  void myScroll(ScrollController scrollController, int offset) {
    scrollController.addListener(() async {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (!isLoadScroll && !isLoadendPage) {
          setState(() {
            isLoadScroll = true;
          });

          await Future.delayed(const Duration(milliseconds: 500));

          offset += 20;

          // ตรวจสอบว่ามี itemBrandPC หรือไม่
          if (itemBrandPC != null && itemBrandPC!.isNotEmpty) {
            await loadBrandList(offset);
          } else {
            await getSelectBrandList(offset);
          }
        }
      }
    });
  }

  Future<void> loadBrandList(offset) async {
    if (itemBrandPC != null && itemBrandPC!.isNotEmpty) {
      // กรณี itemBrandPC มีค่า → เอา brandId ไปหา API ทีละตัว
      final List<Map<String, dynamic>> brandList = itemBrandPC!
          .map((e) => jsonDecode(e) as Map<String, dynamic>)
          .toList();

      final List<Map<String, dynamic>> tempDropdownList = [];

      for (var brand in brandList) {
        final brandId = (brand['brandId'] ?? '').toString();
        if (brandId.isEmpty) continue;

        try {
          final response = await http.get(
            Uri.parse(
                '${api}setup/itemBrandList?searchId=$brandId&page=1&limit=$offset'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': tokenId.toString(),
            },
          );

          if (response.statusCode == 200) {
            final data = jsonDecode(response.body);
            final List<dynamic> apiData = data['data'];

            // filter ให้เหลือเฉพาะ record ที่ id == brandId
            tempDropdownList.addAll(apiData
                .where((e) => (e['id'] ?? '').toString() == brandId)
                .map((e) => e as Map<String, dynamic>));
          } else {
            handleHttpError(response.statusCode);
          }
        } catch (e) {
          print('❌ Error fetching brand for brandId $brandId: $e');
        }
      }
      setState(() {
        dropdownbrandlist = tempDropdownList;
      });
      statusLoading = true;
      isLoadScroll = false;
      if (stquery > 0) {
        if (offset > dropdownbrandlist.length) {
          isLoadendPage = true;
        }
        stquery = 1;
      } else {
        stquery = 1;
      }
    } else {
      // กรณี itemBrandPC ว่าง → ทำงานแบบเดิม
      await getSelectBrandList(offset);
    }
  }

  Future<void> getSelectBrandList(offset) async {
    try {
      var respose = await http.get(
        Uri.parse(
            '${api}setup/itemBrandList?searchName=${itembrandlist.text}&page=1&limit=$offset&itemGroupId=&itemTypeId=&itemStatus=1'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> dataBrandlist =
            Map<String, dynamic>.from(json.decode(respose.body));
        setState(() {
          dropdownbrandlist = dataBrandlist['data'];
        });
        statusLoading = true;
        isLoadScroll = false;
        if (stquery > 0) {
          if (offset > dropdownbrandlist.length) {
            isLoadendPage = true;
          }
          stquery = 1;
        } else {
          stquery = 1;
        }
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
        showProgressDialog(context, 'แจ้งเตือน', 'กรุณาติดต่อผู้ดูแลระบบ');
      }
    } catch (e) {
      showProgressDialog(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
  }

  // แยกฟังก์ชัน handle error HTTP
  void handleHttpError(int statusCode) async {
    if (statusCode == 400) {
      showProgressDialog_400(context, 'แจ้งเตือน', 'ไม่พบข้อมูล ($statusCode)');
    } else if (statusCode == 401) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.clear();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Authen()),
        (Route<dynamic> route) => false,
      );
      showProgressDialog_401(
          context, 'แจ้งเตือน', 'กรุณา Login เข้าสู่ระบบใหม่');
    } else if (statusCode == 404) {
      showProgressDialog_404(context, 'แจ้งเตือน', 'ไม่พบข้อมูล ($statusCode)');
    } else if (statusCode == 405) {
      showProgressDialog_405(context, 'แจ้งเตือน', 'ไม่พบข้อมูล ($statusCode)');
    } else if (statusCode == 500) {
      showProgressDialog_500(
          context, 'แจ้งเตือน', 'ข้อมูลผิดพลาด ($statusCode)');
    } else {
      showProgressDialog(context, 'แจ้งเตือน', 'กรุณาติดต่อผู้ดูแลระบบ');
    }
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
      appBar: const CustomAppbar(title: 'ค้นหายี่ห้อสินค้า'),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        behavior: HitTestBehavior.opaque,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.all(6),
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
                  color: const Color.fromRGBO(239, 191, 239, 1),
                ),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'ยี่ห้อสินค้า : ',
                            style: MyContant().h4normalStyle(),
                          ),
                          inputBrandNamelist(sizeIcon, border),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            groupBtnsearch(),
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
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 3, horizontal: 6),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withAlpha(130),
                                        spreadRadius: 0.2,
                                        blurRadius: 2,
                                        offset: const Offset(0, 1),
                                      )
                                    ],
                                    color:
                                        const Color.fromRGBO(239, 191, 239, 1),
                                  ),
                                  child: Column(
                                    children: [
                                      for (var i = 0;
                                          i < dropdownbrandlist.length;
                                          i++) ...[
                                        InkWell(
                                          onTap: () {
                                            Navigator.pop(context, {
                                              'id':
                                                  '${dropdownbrandlist[i]['id']}',
                                              'name':
                                                  '${dropdownbrandlist[i]['name']}',
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 3),
                                            child: Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: Colors.white
                                                    .withValues(alpha: 0.7),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      dropdownbrandlist[i]
                                                          ['name'],
                                                      style: MyContant()
                                                          .h4normalStyle(),
                                                      overflow:
                                                          TextOverflow.clip,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                              if (isLoadScroll == true &&
                                  isLoadendPage == false) ...[
                                const LoadData(),
                              ] else if (isLoadendPage == true) ...[
                                const EndPage(),
                              ],
                              const SizedBox(
                                height: 20,
                              ),
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
                          getSelectBrandList(offset);
                          statusLoading = false;
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
                          itembrandlist.clear();
                          getSelectBrandList(offset);
                          statusLoading = false;
                          statusLoad404 = false;
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

  Expanded inputBrandNamelist(BoxConstraints sizeIcon, InputBorder border) {
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
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: TextField(
          controller: itembrandlist,
          decoration: InputDecoration(
            suffixIcon: itembrandlist.text.isEmpty
                ? null
                : GestureDetector(
                    onTap: () {
                      setState(() {
                        itembrandlist.clear();
                        getSelectBrandList(offset);
                        statusLoading = false;
                        statusLoad404 = false;
                      });
                    },
                    child: const Icon(Icons.close),
                  ),
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
}

class ItemModelList extends StatefulWidget {
  final String? valueBrandlist;
  const ItemModelList({super.key, this.valueBrandlist});

  @override
  State<ItemModelList> createState() => _ItemModelListState();
}

class _ItemModelListState extends State<ItemModelList> {
  String userId = '', empId = '', firstName = '', lastName = '', tokenId = '';
  TextEditingController itemmodellist = TextEditingController();
  List<dynamic> dropdownmodellist = [];
  bool statusLoading = false,
      statusLoad404 = false,
      isLoading = false,
      isLoadScroll = false,
      isLoadendPage = false;
  final scrollControll = TrackingScrollController();
  int offset = 50, stquery = 0;
  String? valGroupList = '', valTypeList = '', valBrandList = '';

  @override
  void initState() {
    super.initState();
    getdata();
    itemmodellist.addListener(() {
      setState(() {}); // อัปเดต UI ทุกครั้งที่ค่าของ TextField เปลี่ยน
    });

    widget.valueBrandlist == null
        ? valBrandList = ''
        : valBrandList = widget.valueBrandlist;
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
    if (mounted) {
      getSelectModelList(offset);
    }
    myScroll(scrollControll, offset);
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
          getSelectModelList(offset);
        });
      }
    });
  }

  Future<void> getSelectModelList(offset) async {
    try {
      var respose = await http.get(
        Uri.parse(
            '${api}setup/itemModelList?searchName=${itemmodellist.text}&page=1&limit=$offset&itemGroupId=&itemTypeId=&itemBrandId=$valBrandList&itemStatus=1'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> dataModellist =
            Map<String, dynamic>.from(json.decode(respose.body));
        setState(() {
          dropdownmodellist = dataModellist['data'];
        });
        statusLoading = true;
        isLoadScroll = false;
        if (stquery > 0) {
          if (offset > dropdownmodellist.length) {
            isLoadendPage = true;
          }
          stquery = 1;
        } else {
          stquery = 1;
        }
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
        showProgressDialog(context, 'แจ้งเตือน', 'กรุณาติดต่อผู้ดูแลระบบ');
      }
    } catch (e) {
      showProgressDialog(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
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
      appBar: const CustomAppbar(title: 'ค้นหารุ่นสินค้า'),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        behavior: HitTestBehavior.opaque,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.all(6),
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
                  color: const Color.fromRGBO(239, 191, 239, 1),
                ),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'รุ่นสินค้า : ',
                            style: MyContant().h4normalStyle(),
                          ),
                          inputModelNamelist(sizeIcon, border),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            groupBtnsearch(),
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
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 3, horizontal: 6),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withAlpha(130),
                                        spreadRadius: 0.2,
                                        blurRadius: 2,
                                        offset: const Offset(0, 1),
                                      )
                                    ],
                                    color:
                                        const Color.fromRGBO(239, 191, 239, 1),
                                  ),
                                  child: Column(
                                    children: [
                                      for (var i = 0;
                                          i < dropdownmodellist.length;
                                          i++) ...[
                                        InkWell(
                                          onTap: () {
                                            Navigator.pop(context, {
                                              'id':
                                                  '${dropdownmodellist[i]['id']}',
                                              'name':
                                                  '${dropdownmodellist[i]['name']}',
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 3),
                                            child: Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: Colors.white
                                                    .withValues(alpha: 0.7),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      dropdownmodellist[i]
                                                          ['name'],
                                                      style: MyContant()
                                                          .h4normalStyle(),
                                                      overflow:
                                                          TextOverflow.clip,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                              if (isLoadScroll == true &&
                                  isLoadendPage == false) ...[
                                const LoadData(),
                              ] else if (isLoadendPage == true) ...[
                                const EndPage(),
                              ],
                              const SizedBox(
                                height: 20,
                              ),
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
                          getSelectModelList(offset);
                          statusLoading = false;
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
                          itemmodellist.clear();
                          getSelectModelList(offset);
                          statusLoading = false;
                          statusLoad404 = false;
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

  Expanded inputModelNamelist(BoxConstraints sizeIcon, InputBorder border) {
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
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: TextField(
          controller: itemmodellist,
          decoration: InputDecoration(
            suffixIcon: itemmodellist.text.isEmpty
                ? null
                : GestureDetector(
                    onTap: () {
                      setState(() {
                        itemmodellist.clear();
                        getSelectModelList(offset);
                        statusLoading = false;
                        statusLoad404 = false;
                      });
                    },
                    child: const Icon(Icons.close),
                  ),
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
}

class ItemStyleList extends StatefulWidget {
  const ItemStyleList({super.key});

  @override
  State<ItemStyleList> createState() => _ItemStyleListState();
}

class _ItemStyleListState extends State<ItemStyleList> {
  String userId = '', empId = '', firstName = '', lastName = '', tokenId = '';
  TextEditingController itemstylelist = TextEditingController();
  List<dynamic> dropdownstylelist = [];
  bool statusLoading = false,
      statusLoad404 = false,
      isLoading = false,
      isLoadScroll = false,
      isLoadendPage = false;
  final scrollControll = TrackingScrollController();
  int offset = 50, stquery = 0;
  String? valTypeList = '';

  @override
  void initState() {
    super.initState();
    getdata();
    itemstylelist.addListener(() {
      setState(() {}); // อัปเดต UI ทุกครั้งที่ค่าของ TextField เปลี่ยน
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
    });
    if (mounted) {
      getSelectStyleList(offset);
    }
    myScroll(scrollControll, offset);
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
          getSelectStyleList(offset);
        });
      }
    });
  }

  Future<void> getSelectStyleList(offset) async {
    try {
      var respose = await http.get(
        Uri.parse(
            '${api}setup/itemStyleList?searchName=${itemstylelist.text}&page=1&limit=$offset&itemTypeId='),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> dataStylelist =
            Map<String, dynamic>.from(json.decode(respose.body));
        setState(() {
          dropdownstylelist = dataStylelist['data'];
        });
        statusLoading = true;
        isLoadScroll = false;
        if (stquery > 0) {
          if (offset > dropdownstylelist.length) {
            isLoadendPage = true;
          }
          stquery = 1;
        } else {
          stquery = 1;
        }
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
        showProgressDialog(context, 'แจ้งเตือน', 'กรุณาติดต่อผู้ดูแลระบบ');
      }
    } catch (e) {
      showProgressDialog(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
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
      appBar: const CustomAppbar(title: 'ค้นหาแบบสินค้า'),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        behavior: HitTestBehavior.opaque,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.all(6),
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
                  color: const Color.fromRGBO(239, 191, 239, 1),
                ),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'แบบ : ',
                            style: MyContant().h4normalStyle(),
                          ),
                          inputStyleNamelist(sizeIcon, border),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            groupBtnsearch(),
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
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 3, horizontal: 6),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withAlpha(130),
                                        spreadRadius: 0.2,
                                        blurRadius: 2,
                                        offset: const Offset(0, 1),
                                      )
                                    ],
                                    color:
                                        const Color.fromRGBO(239, 191, 239, 1),
                                  ),
                                  child: Column(
                                    children: [
                                      for (var i = 0;
                                          i < dropdownstylelist.length;
                                          i++) ...[
                                        InkWell(
                                          onTap: () {
                                            Navigator.pop(context, {
                                              'id':
                                                  '${dropdownstylelist[i]['id']}',
                                              'name':
                                                  '${dropdownstylelist[i]['name']}',
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 3),
                                            child: Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: Colors.white
                                                    .withValues(alpha: 0.7),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      dropdownstylelist[i]
                                                          ['name'],
                                                      style: MyContant()
                                                          .h4normalStyle(),
                                                      overflow:
                                                          TextOverflow.clip,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                              if (isLoadScroll == true &&
                                  isLoadendPage == false) ...[
                                const LoadData(),
                              ] else if (isLoadendPage == true) ...[
                                const EndPage(),
                              ],
                              const SizedBox(
                                height: 30,
                              ),
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
                          getSelectStyleList(offset);
                          statusLoading = false;
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
                          itemstylelist.clear();
                          getSelectStyleList(offset);
                          statusLoading = false;
                          statusLoad404 = false;
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

  Expanded inputStyleNamelist(BoxConstraints sizeIcon, InputBorder border) {
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
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: TextField(
          controller: itemstylelist,
          decoration: InputDecoration(
            suffixIcon: itemstylelist.text.isEmpty
                ? null
                : GestureDetector(
                    onTap: () {
                      setState(() {
                        itemstylelist.clear();
                        getSelectStyleList(offset);
                        statusLoading = false;
                        statusLoad404 = false;
                      });
                    },
                    child: const Icon(Icons.close),
                  ),
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
}

class ItemSizeList extends StatefulWidget {
  const ItemSizeList({super.key});

  @override
  State<ItemSizeList> createState() => _ItemSizeListState();
}

class _ItemSizeListState extends State<ItemSizeList> {
  String userId = '', empId = '', firstName = '', lastName = '', tokenId = '';
  TextEditingController itemsizelist = TextEditingController();
  List<dynamic> dropdownsizelist = [];
  bool statusLoading = false,
      statusLoad404 = false,
      isLoading = false,
      isLoadScroll = false,
      isLoadendPage = false;
  final scrollControll = TrackingScrollController();
  int offset = 50, stquery = 0;
  String? valTypeList = '';

  @override
  void initState() {
    super.initState();
    getdata();
    itemsizelist.addListener(() {
      setState(() {}); // อัปเดต UI ทุกครั้งที่ค่าของ TextField เปลี่ยน
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
    });
    if (mounted) {
      getSelectSizeList(offset);
    }
    myScroll(scrollControll, offset);
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
          getSelectSizeList(offset);
        });
      }
    });
  }

  Future<void> getSelectSizeList(offset) async {
    try {
      var respose = await http.get(
        Uri.parse(
            '${api}setup/itemSizeList?searchName=${itemsizelist.text}&page=1&limit=$offset&itemTypeId='),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> dataSizelist =
            Map<String, dynamic>.from(json.decode(respose.body));
        setState(() {
          dropdownsizelist = dataSizelist['data'];
        });
        statusLoading = true;
        isLoadScroll = false;
        if (stquery > 0) {
          if (offset > dropdownsizelist.length) {
            isLoadendPage = true;
          }
          stquery = 1;
        } else {
          stquery = 1;
        }
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
        showProgressDialog(context, 'แจ้งเตือน', 'กรุณาติดต่อผู้ดูแลระบบ');
      }
    } catch (e) {
      showProgressDialog(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
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
      appBar: const CustomAppbar(title: 'ค้นหาขนาดสินค้า'),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        behavior: HitTestBehavior.opaque,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.all(6),
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
                  color: const Color.fromRGBO(239, 191, 239, 1),
                ),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'ขนาด : ',
                            style: MyContant().h4normalStyle(),
                          ),
                          inputSizeNamelist(sizeIcon, border),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            groupBtnsearch(),
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
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 3, horizontal: 6),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withAlpha(130),
                                        spreadRadius: 0.2,
                                        blurRadius: 2,
                                        offset: const Offset(0, 1),
                                      )
                                    ],
                                    color:
                                        const Color.fromRGBO(239, 191, 239, 1),
                                  ),
                                  child: Column(
                                    children: [
                                      for (var i = 0;
                                          i < dropdownsizelist.length;
                                          i++) ...[
                                        InkWell(
                                          onTap: () {
                                            Navigator.pop(context, {
                                              'id':
                                                  '${dropdownsizelist[i]['id']}',
                                              'name':
                                                  '${dropdownsizelist[i]['name']}',
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 3),
                                            child: Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: Colors.white
                                                    .withValues(alpha: 0.7),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      dropdownsizelist[i]
                                                          ['name'],
                                                      style: MyContant()
                                                          .h4normalStyle(),
                                                      overflow:
                                                          TextOverflow.clip,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                              if (isLoadScroll == true &&
                                  isLoadendPage == false) ...[
                                const LoadData(),
                              ] else if (isLoadendPage == true) ...[
                                const EndPage(),
                              ],
                              const SizedBox(
                                height: 20,
                              ),
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
                          getSelectSizeList(offset);
                          statusLoading = false;
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
                          itemsizelist.clear();
                          getSelectSizeList(offset);
                          statusLoading = false;
                          statusLoad404 = false;
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

  Expanded inputSizeNamelist(BoxConstraints sizeIcon, InputBorder border) {
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
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: TextField(
          controller: itemsizelist,
          decoration: InputDecoration(
            suffixIcon: itemsizelist.text.isEmpty
                ? null
                : GestureDetector(
                    onTap: () {
                      setState(() {
                        itemsizelist.clear();
                        getSelectSizeList(offset);
                        statusLoading = false;
                        statusLoad404 = false;
                      });
                    },
                    child: const Icon(Icons.close),
                  ),
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
}

class ItemColorList extends StatefulWidget {
  const ItemColorList({super.key});

  @override
  State<ItemColorList> createState() => _ItemColorListState();
}

class _ItemColorListState extends State<ItemColorList> {
  String userId = '', empId = '', firstName = '', lastName = '', tokenId = '';
  TextEditingController itemcolorlist = TextEditingController();
  List<dynamic> dropdowncolorlist = [];
  bool statusLoading = false,
      statusLoad404 = false,
      isLoading = false,
      isLoadScroll = false,
      isLoadendPage = false;
  final scrollControll = TrackingScrollController();
  int offset = 50, stquery = 0;

  @override
  void initState() {
    super.initState();
    getdata();
    itemcolorlist.addListener(() {
      setState(() {}); // อัปเดต UI ทุกครั้งที่ค่าของ TextField เปลี่ยน
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
    });
    if (mounted) {
      getSelectColorList(offset);
    }
    myScroll(scrollControll, offset);
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
          getSelectColorList(offset);
        });
      }
    });
  }

  Future<void> getSelectColorList(offset) async {
    try {
      var respose = await http.get(
        Uri.parse(
            '${api}setup/itemColorList?searchName=${itemcolorlist.text}&page=1&limit=$offset'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> dataColorlist =
            Map<String, dynamic>.from(json.decode(respose.body));
        setState(() {
          dropdowncolorlist = dataColorlist['data'];
        });
        statusLoading = true;
        isLoadScroll = false;
        if (stquery > 0) {
          if (offset > dropdowncolorlist.length) {
            isLoadendPage = true;
          }
          stquery = 1;
        } else {
          stquery = 1;
        }
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
        showProgressDialog(context, 'แจ้งเตือน', 'กรุณาติดต่อผู้ดูแลระบบ');
      }
    } catch (e) {
      showProgressDialog(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
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
      appBar: const CustomAppbar(title: 'ค้นหาสีสินค้า'),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        behavior: HitTestBehavior.opaque,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.all(6),
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
                  color: const Color.fromRGBO(239, 191, 239, 1),
                ),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'สี : ',
                            style: MyContant().h4normalStyle(),
                          ),
                          inputColorNamelist(sizeIcon, border),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            groupBtnsearch(),
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
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 3, horizontal: 6),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withAlpha(130),
                                        spreadRadius: 0.2,
                                        blurRadius: 2,
                                        offset: const Offset(0, 1),
                                      )
                                    ],
                                    color:
                                        const Color.fromRGBO(239, 191, 239, 1),
                                  ),
                                  child: Column(
                                    children: [
                                      for (var i = 0;
                                          i < dropdowncolorlist.length;
                                          i++) ...[
                                        InkWell(
                                          onTap: () {
                                            Navigator.pop(context, {
                                              'id':
                                                  '${dropdowncolorlist[i]['id']}',
                                              'name':
                                                  '${dropdowncolorlist[i]['name']}',
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 3),
                                            child: Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: Colors.white
                                                    .withValues(alpha: 0.7),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      dropdowncolorlist[i]
                                                          ['name'],
                                                      style: MyContant()
                                                          .h4normalStyle(),
                                                      overflow:
                                                          TextOverflow.clip,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                              if (isLoadScroll == true &&
                                  isLoadendPage == false) ...[
                                const LoadData(),
                              ] else if (isLoadendPage == true) ...[
                                const EndPage(),
                              ],
                              const SizedBox(
                                height: 20,
                              ),
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
                          getSelectColorList(offset);
                          statusLoading = false;
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
                          itemcolorlist.clear();
                          getSelectColorList(offset);
                          statusLoading = false;
                          statusLoad404 = false;
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

  Expanded inputColorNamelist(BoxConstraints sizeIcon, InputBorder border) {
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
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: TextField(
          controller: itemcolorlist,
          decoration: InputDecoration(
            suffixIcon: itemcolorlist.text.isEmpty
                ? null
                : GestureDetector(
                    onTap: () {
                      setState(() {
                        itemcolorlist.clear();
                        getSelectColorList(offset);
                        statusLoading = false;
                        statusLoad404 = false;
                      });
                    },
                    child: const Icon(Icons.close),
                  ),
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
}

class SupplyList extends StatefulWidget {
  const SupplyList({super.key});

  @override
  State<SupplyList> createState() => _SupplyListState();
}

class _SupplyListState extends State<SupplyList> {
  String userId = '', empId = '', firstName = '', lastName = '', tokenId = '';
  List<String>? itemBrandPC;
  TextEditingController supplynamelist = TextEditingController();
  List<dynamic> dropdownsupplylist = [];
  List<dynamic> originalSupplyList = []; // เก็บข้อมูลเดิมก่อนค้นหา
  bool statusLoading = false,
      statusLoad404 = false,
      isLoading = false,
      isLoadScroll = false,
      isLoadendPage = false;
  final scrollControll = TrackingScrollController();
  int offset = 30, stquery = 0;
  List<bool> isCheckedList = [];
  List<String> selectedSupply = [];
  Set<String> selectedSupplySet = {};
  List<Map<String, String>> selectedSupplyList = [];

  @override
  void initState() {
    super.initState();
    getdata();
    supplynamelist.addListener(() {
      setState(() {}); // อัปเดต UI ทุกครั้งที่ค่าของ TextField เปลี่ยน
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
      itemBrandPC = preferences.getStringList('itemBrandPC');
    });
    if (mounted) {
      await loadSupplyList(offset);
    }
    myScroll(scrollControll, offset);
  }

  void myScroll(ScrollController scrollController, int offset) {
    scrollController.addListener(() async {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 10) {
        if (isLoadScroll || isLoadendPage) return;
        setState(() => isLoadScroll = true);
        await Future.delayed(const Duration(milliseconds: 500));

        offset += 20;

        if (itemBrandPC != null && itemBrandPC!.isNotEmpty) {
          await loadSupplyList(offset, loadMore: true);
        } else {
          if (supplynamelist.text.isEmpty) {
            await getSelectSupplyList(offset, loadMore: true);
          } else {
            await searchSupply(offset, supplynamelist.text, loadMore: true);
          }
        }

        setState(() => isLoadScroll = false);
      }
    });
  }

  Future<void> loadSupplyList(offset, {bool loadMore = false}) async {
    if (itemBrandPC != null && itemBrandPC!.isNotEmpty) {
      final List<Map<String, dynamic>> brandList = itemBrandPC!
          .map((e) => jsonDecode(e) as Map<String, dynamic>)
          .toList();

      // ถ้ามี supplyId ว่าง → กลับไปใช้การโหลดแบบเดิม
      final hasEmptySupply =
          brandList.any((b) => (b['supplyId'] ?? '').toString().isEmpty);
      if (hasEmptySupply) {
        await getSelectSupplyList(offset, loadMore: loadMore);
        return;
      }

      // เอาเฉพาะ supplyId ทั้งหมดที่มีค่า
      final supplyIds = brandList
          .map((b) => (b['supplyId'] ?? '').toString())
          .where((id) => id.isNotEmpty)
          .toSet()
          .toList();

      if (supplyIds.isEmpty) {
        await getSelectSupplyList(offset, loadMore: loadMore);
        return;
      }

      try {
        // ดึงข้อมูลทั้งหมดจาก API
        final response = await http.get(
          Uri.parse('${api}setup/supplyList?searchName=&page=1&limit=5000'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': tokenId.toString(),
          },
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final List<dynamic> apiData = data['data'];

          // filter เฉพาะ id ที่อยู่ใน supplyIds
          final filtered = apiData
              .where((e) => supplyIds.contains((e['id'] ?? '').toString()))
              .map((e) => e as Map<String, dynamic>)
              .toList();

          setState(() {
            if (!loadMore) {
              dropdownsupplylist = filtered;
              isCheckedList = filtered
                  .map((e) => selectedSupplySet.contains(e['id'].toString()))
                  .toList();
            } else {
              dropdownsupplylist.addAll(filtered);
              isCheckedList.addAll(filtered
                  .map((e) => selectedSupplySet.contains(e['id'].toString()))
                  .toList());
            }
            statusLoading = true;
            isLoadendPage = offset > dropdownsupplylist.length;
          });
        } else {
          handleHttpError(response.statusCode);
        }
      } catch (e) {
        print('❌ Error loading supplyList: $e');
        showProgressDialog(context, 'แจ้งเตือน', 'โหลดข้อมูลผู้จำหน่ายล้มเหลว');
      }
    } else {
      // ถ้าไม่มี itemBrandPC → ทำงานปกติ
      await getSelectSupplyList(offset, loadMore: loadMore);
    }
  }

  Future<void> getSelectSupplyList(offset, {bool loadMore = false}) async {
    try {
      var response = await http.get(
        Uri.parse('${api}setup/supplyList?searchName=&page=1&limit=$offset'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> dataSupplylist =
            Map<String, dynamic>.from(json.decode(response.body));
        final List<Map<String, dynamic>> newList =
            (dataSupplylist['data'] as List)
                .map((e) => Map<String, dynamic>.from(e as Map))
                .toList();

        setState(() {
          if (!loadMore) {
            // โหลดเริ่มต้น / รีเฟรช
            dropdownsupplylist = List.of(newList, growable: true);
            originalSupplyList = List.of(newList, growable: true); // เก็บสำรอง
            isCheckedList = dropdownsupplylist
                .map((e) => selectedSupplySet.contains(e['id'].toString()))
                .toList();
            offset = dropdownsupplylist.length;
            isLoadendPage = false;
          } else {
            // โหลดเพิ่ม
            dropdownsupplylist = List.of(dropdownsupplylist, growable: true);
            isCheckedList = List.of(isCheckedList, growable: true);

            final existingIds =
                dropdownsupplylist.map((e) => e['id'].toString()).toSet();
            final uniqueNew = newList
                .where((e) => !existingIds.contains(e['id'].toString()))
                .toList();

            if (uniqueNew.isEmpty) {
              isLoadendPage = true;
            } else {
              dropdownsupplylist.addAll(uniqueNew);
              isCheckedList.addAll(uniqueNew
                  .map((e) => selectedSupplySet.contains(e['id'].toString()))
                  .toList());
              offset = dropdownsupplylist.length;
            }
          }
          statusLoading = true;
        });
      } else {
        handleHttpError(response.statusCode);
      }
    } catch (e) {
      showProgressDialog(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
  }

  // ค้นหาผู้จำหน่าย
  Future<void> searchSupply(offset, String keyword,
      {bool loadMore = false}) async {
    try {
      var response = await http.get(
        Uri.parse(
            '${api}setup/supplyList?searchName=$keyword&page=1&limit=$offset'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> dataSupplylist =
            Map<String, dynamic>.from(json.decode(response.body));
        final List<Map<String, dynamic>> searchList =
            (dataSupplylist['data'] as List)
                .map((e) => Map<String, dynamic>.from(e as Map))
                .toList();

        setState(() {
          if (!loadMore) {
            print('loadMore false');
            dropdownsupplylist = List.of(searchList, growable: true);
            isCheckedList = dropdownsupplylist
                .map((e) => selectedSupplySet.contains(e['id'].toString()))
                .toList();
            isLoadendPage = false;
          } else {
            print('loadMore true');
            final existingIds =
                dropdownsupplylist.map((e) => e['id'].toString()).toSet();
            final uniqueNew = searchList
                .where((e) => !existingIds.contains(e['id'].toString()))
                .toList();

            if (uniqueNew.isEmpty) {
              isLoadendPage = true;
            } else {
              dropdownsupplylist.addAll(uniqueNew);
              isCheckedList.addAll(uniqueNew
                  .map((e) => selectedSupplySet.contains(e['id'].toString()))
                  .toList());
            }
          }

          statusLoading = true;
        });
      } else {
        handleHttpError(response.statusCode);
      }
    } catch (e) {
      showProgressDialog(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ2');
    }
  }

  // ล้างค้นหาโดยไม่ลบ checkbox
  Future<void> clearSearchAndReload() async {
    setState(() {
      offset = 30; // รีเซ็ต offset
      supplynamelist.clear();
      statusLoad404 = false;
      statusLoading = false;
    });

    await Future.delayed(
        const Duration(milliseconds: 100)); // กัน state race (optional)

    setState(() {
      dropdownsupplylist = List.from(originalSupplyList);
      isCheckedList = dropdownsupplylist
          .map((e) => selectedSupplySet.contains(e['id'].toString()))
          .toList();
      offset = dropdownsupplylist.length;
      isLoadendPage = false;
      statusLoading = true;
    });
  }

  void toggleCheckItem(int index, bool? value) {
    final id = dropdownsupplylist[index]['id'].toString();
    final name = dropdownsupplylist[index]['name'].toString();
    final checked = value ?? false;

    setState(() {
      if (checked) {
        if (!selectedSupplyList.any((item) => item['id'] == id)) {
          selectedSupplyList.add({'id': id, 'name': name});
        }
      } else {
        selectedSupplyList.removeWhere((item) => item['id'] == id);
      }

      print('✅ selectedSupply: $selectedSupplyList');
    });
  }

  // แยกฟังก์ชัน handle error HTTP
  void handleHttpError(int statusCode) async {
    if (statusCode == 400) {
      showProgressDialog_400(context, 'แจ้งเตือน', 'ไม่พบข้อมูล ($statusCode)');
    } else if (statusCode == 401) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.clear();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Authen()),
        (Route<dynamic> route) => false,
      );
      showProgressDialog_401(
          context, 'แจ้งเตือน', 'กรุณา Login เข้าสู่ระบบใหม่');
    } else if (statusCode == 404) {
      setState(() {
        statusLoading = true;
        statusLoad404 = true;
      });
    } else if (statusCode == 405) {
      showProgressDialog_405(context, 'แจ้งเตือน', 'ไม่พบข้อมูล ($statusCode)');
    } else if (statusCode == 500) {
      showProgressDialog_500(
          context, 'แจ้งเตือน', 'ข้อมูลผิดพลาด ($statusCode)');
    } else {
      showProgressDialog(context, 'แจ้งเตือน', 'กรุณาติดต่อผู้ดูแลระบบ');
    }
  }

  @override
  Widget build(BuildContext context) {
    const sizeIcon = BoxConstraints(minWidth: 40, minHeight: 40);
    const border = OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.transparent,
        width: 0,
      ),
      borderRadius: BorderRadius.all(Radius.circular(4.0)),
    );

    final hasSelected = selectedSupplyList.isNotEmpty;
    return Scaffold(
      appBar: const CustomAppbar(title: 'ค้นหาผู้จำหน่าย'),
      body: Stack(
        children: [
          GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
            behavior: HitTestBehavior.opaque,
            child: Column(
              children: [
                // Search input
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withAlpha(130),
                          spreadRadius: 0.2,
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        )
                      ],
                      color: const Color.fromRGBO(239, 191, 239, 1),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(180),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Text('ผู้จำหน่าย : ',
                              style: MyContant().h4normalStyle()),
                          inputSupplyNamelist(sizeIcon, border),
                        ],
                      ),
                    ),
                  ),
                ),
                groupBtnsearch(),
                Expanded(
                  child: buildListView(),
                ),
              ],
            ),
          ),
          // ✅ ปุ่มล่างแบบเด้งขึ้น
          AnimatedPositioned(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            bottom: hasSelected ? 0 : -100, // เด้งขึ้นถ้ามีการติ๊ก
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(40),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // ปุ่มตกลง
                    ElevatedButton(
                      onPressed: () {
                        // print('✅ ส่งข้อมูลกลับ: $selectedSupplyList');
                        // ตัวอย่างส่งกลับไปหน้าก่อน
                        Navigator.pop(context, selectedSupplyList);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'ตกลง',
                        style: MyContant().h1MenuStyle(),
                      ),
                    ),

                    // ปุ่มยกเลิก
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedSupplyList.clear();
                          isCheckedList =
                              List.filled(dropdownsupplylist.length, false);
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'ยกเลิก',
                        style: MyContant().h1MenuStyle(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // สร้าง listview / scroll
  Widget buildListView() {
    if (!statusLoading) {
      return Center(child: Image.asset(cupertinoActivityIndicator, scale: 4));
    }
    if (statusLoad404) {
      return Center(
        child: Center(
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
                      color: const Color.fromARGB(255, 158, 158, 158),
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
        ),
      );
    }

    return SingleChildScrollView(
      controller: scrollControll,
      physics:
          const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
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
                color: const Color.fromRGBO(239, 191, 239, 1),
              ),
              child: Column(
                children: [
                  for (var i = 0; i < dropdownsupplylist.length; i++) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: Row(
                        children: [
                          // กล่อง Checkbox
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.7),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Checkbox(
                              side: WidgetStateBorderSide.resolveWith(
                                (Set<WidgetState> states) {
                                  return const BorderSide(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    width: 1.7,
                                  );
                                },
                              ),
                              value: selectedSupplyList.any(
                                (item) =>
                                    item['id'] ==
                                    dropdownsupplylist[i]['id'].toString(),
                              ),
                              onChanged: (bool? value) {
                                toggleCheckItem(i, value);
                              },
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              checkColor: Colors.black,
                              activeColor: Colors.white.withAlpha(180),
                            ),
                          ),

                          const SizedBox(width: 6),

                          // กล่องข้อความ
                          Expanded(
                            child: InkWell(
                              onTap: () {},
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.7),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  dropdownsupplylist[i]['name'],
                                  style: MyContant().h4normalStyle(),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (isLoadScroll && !isLoadendPage) const LoadData(),
          if (isLoadendPage) const EndPage(),
          SizedBox(
            height: selectedSupplyList.isNotEmpty ? 100 : 20,
          ),
        ],
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
                      onPressed: () async {
                        offset = 30; // รีเซ็ต offset ก่อนค้นหาใหม่
                        await searchSupply(
                            offset, supplynamelist.text); // ทำงาน async ก่อน
                        setState(() {
                          // อัปเดตสถานะหลังจาก search เสร็จ
                          statusLoading = true;
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
                      onPressed: () async {
                        await clearSearchAndReload();
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

  Expanded inputSupplyNamelist(BoxConstraints sizeIcon, InputBorder border) {
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
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: TextField(
          controller: supplynamelist,
          decoration: InputDecoration(
            suffixIcon: supplynamelist.text.isEmpty
                ? null
                : GestureDetector(
                    onTap: () async {
                      await clearSearchAndReload();
                    },
                    child: const Icon(Icons.close),
                  ),
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
}
