import 'dart:convert';

import 'package:application_thaweeyont/api.dart';
import 'package:application_thaweeyont/state/authen.dart';
import 'package:application_thaweeyont/state/state_credit/check_blacklist/blacklist_cust_list.dart';
import 'package:application_thaweeyont/utility/my_constant.dart';
import 'package:application_thaweeyont/widgets/custom_appbar.dart';
import 'package:application_thaweeyont/widgets/endpage.dart';
import 'package:application_thaweeyont/widgets/loaddata.dart';
import 'package:flutter/material.dart';
import 'package:loading_gifs/loading_gifs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CheckBlacklistData extends StatefulWidget {
  const CheckBlacklistData({super.key});

  @override
  State<CheckBlacklistData> createState() => _CheckBlacklistDataState();
}

class _CheckBlacklistDataState extends State<CheckBlacklistData> {
  String userId = '',
      empId = '',
      firstName = '',
      lastName = '',
      tokenId = '',
      text_province = '',
      text_amphoe = '';
  var selectValue_province,
      selectValue_amphoe,
      districtId,
      tumbolId,
      amphurId,
      provinceId;
  List dropdown_province = [], list_district = [], dropdown_amphoe = [];

  TextEditingController idblacklist = TextEditingController();
  TextEditingController name_show = TextEditingController();
  TextEditingController smartId = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController home_no = TextEditingController();
  TextEditingController moo_no = TextEditingController();
  TextEditingController district = TextEditingController();
  TextEditingController amphoe = TextEditingController();
  TextEditingController provincn = TextEditingController();

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
        showProgressDialog_404(context, 'แจ้งเตือน', 'ไม่พบข้อมูลที่ค้นหา');
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
        Navigator.pop(context);
        Navigator.pop(context);
        // searchDistrict(sizeIcon, border);
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
        showProgressDialog_404(context, 'แจ้งเตือน', 'ไม่พบข้อมูลที่ค้นหา');
      } else if (respose.statusCode == 405) {
        showProgressDialog_405(
            context, 'แจ้งเตือน', 'ไม่พบข้อมูล (${respose.statusCode})');
      } else if (respose.statusCode == 500) {
        showProgressDialog_500(
            context, 'แจ้งเตือน', 'ข้อมูลผิดพลาด ${respose.statusCode}');
      } else {
        showProgressDialog(context, 'แจ้งเตือน', 'กรุณาติดต่อผู้ดูแลระบบ!');
      }
    } catch (e) {
      print("ไม่มีข้อมูล $e");
      showProgressDialogNotdata(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
  }

  clearDataBlacklist() {
    idblacklist.clear();
    name_show.clear();
    smartId.clear();
    name.clear();
    lastname.clear();
    home_no.clear();
    moo_no.clear();
    district.clear();
    amphoe.clear();
    provincn.clear();
    setState(() {
      districtId = null;
    });
  }

  clearValueSearchDistrict() {
    setState(() {
      selectValue_province = null;
      selectValue_amphoe = null;
      list_district = [];
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
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(162, 181, 252, 1),
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
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'รหัส Blacklist',
                          style: MyContant().h4normalStyle(),
                        ),
                        inputIdblacklist(sizeIcon, border),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            backgroundColor:
                                const Color.fromRGBO(82, 119, 255, 1),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CustomerBlackList(),
                              ),
                            ).then((result) {
                              if (result != null) {
                                setState(() {
                                  idblacklist.text = result['id'];
                                  name_show.text = result['name'];
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
                          'ชื่อ-สกุล ลูกค้า',
                          style: MyContant().h4normalStyle(),
                        ),
                        inputNameShowBl(sizeIcon, border),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'เลขบัตรประชาชน',
                          style: MyContant().h4normalStyle(),
                        ),
                        inputSmartIdBl(sizeIcon, border),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'ชื่อลูกค้า',
                          style: MyContant().h4normalStyle(),
                        ),
                        inputNameBlacklist(sizeIcon, border),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'นามสกุล',
                          style: MyContant().h4normalStyle(),
                        ),
                        inputLastnameBlacklist(sizeIcon, border),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'บ้านเลขที่',
                          style: MyContant().h4normalStyle(),
                        ),
                        inputHomeNoBl(sizeIcon, border),
                        Text(
                          'หมู่ที่',
                          style: MyContant().h4normalStyle(),
                        ),
                        inputMooNoBl(sizeIcon, border),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'ตำบล',
                          style: MyContant().h4normalStyle(),
                        ),
                        inputDistrictBl(sizeIcon, border),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            backgroundColor:
                                const Color.fromRGBO(82, 119, 255, 1),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const DistrictList(),
                              ),
                            ).then((result) {
                              if (result != null) {
                                setState(() {
                                  district.text = result['name'];
                                  tumbolId = result['id'];
                                  provincn.text = result['province'];
                                  provinceId = result['provinceId'];
                                  amphoe.text = result['amphoe'];
                                  amphurId = result['amphoeId'];
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
                          'อำเภอ',
                          style: MyContant().h4normalStyle(),
                        ),
                        inputAmphoeBl(sizeIcon, border),
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
                  ],
                ),
              ),
            ),
            groupBtnsearch(),
            const SizedBox(
              height: 25,
            ),
          ],
        ),
      ),
    );
  }

  Expanded inputIdblacklist(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: TextField(
          controller: idblacklist,
          onChanged: (keyword) {},
          decoration: InputDecoration(
            counterText: "",
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

  Expanded inputNameShowBl(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: TextField(
          controller: name_show,
          onChanged: (keyword) {},
          readOnly: true,
          decoration: InputDecoration(
            counterText: "",
            contentPadding: const EdgeInsets.all(6),
            isDense: true,
            enabledBorder: border,
            focusedBorder: border,
            hintText: 'สำหรับแสดง ชื่อ-สกุล ลูกค้า',
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

  Expanded inputSmartIdBl(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: TextField(
          controller: smartId,
          onChanged: (keyword) {},
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            counterText: "",
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

  Expanded inputNameBlacklist(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: TextField(
          controller: name,
          onChanged: (keyword) {},
          decoration: InputDecoration(
            counterText: "",
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

  Expanded inputLastnameBlacklist(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: TextField(
          controller: lastname,
          onChanged: (keyword) {},
          decoration: InputDecoration(
            counterText: "",
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

  Expanded inputHomeNoBl(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: TextField(
          controller: home_no,
          onChanged: (keyword) {},
          decoration: InputDecoration(
            counterText: "",
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

  Expanded inputMooNoBl(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: TextField(
          controller: moo_no,
          onChanged: (keyword) {},
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            counterText: "",
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

  Expanded inputDistrictBl(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: TextField(
          controller: district,
          onChanged: (keyword) {},
          readOnly: true,
          decoration: InputDecoration(
            counterText: "",
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

  Expanded inputAmphoeBl(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: TextField(
          controller: amphoe,
          onChanged: (keyword) {},
          readOnly: true,
          decoration: InputDecoration(
            counterText: "",
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

  Expanded inputProvince(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: TextField(
          controller: provincn,
          onChanged: (keyword) {},
          readOnly: true,
          decoration: InputDecoration(
            counterText: "",
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
                        // ถ้าทุกฟิลด์ว่าง
                        final allEmpty = [
                          idblacklist.text,
                          smartId.text,
                          name.text,
                          lastname.text,
                          home_no.text,
                          moo_no.text,
                          district.text,
                          amphoe.text,
                          provincn.text,
                        ].every((s) => s.trim().isEmpty);

                        if (allEmpty) {
                          showProgressDialog(
                              context, 'แจ้งเตือน', 'กรุณากรอกข้อมูลลูกค้า');
                          return;
                        }

                        // ถ้ามีบ้านเลขที่หรือหมู่ที่ แต่ยังไม่ได้เลือกตำบล
                        final hasAddress = home_no.text.trim().isNotEmpty ||
                            moo_no.text.trim().isNotEmpty;
                        if (hasAddress && district.text.trim().isEmpty) {
                          showProgressDialog(context, 'แจ้งเตือน',
                              'กรุณาเลือก ตำบล อำเภอ จังหวัด');
                          return;
                        }

                        // ผ่านเงื่อนไขทั้งหมดแล้ว ไปหน้าต่อไป
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlacklistCustList(
                              idblacklist.text,
                              smartId.text,
                              name.text,
                              lastname.text,
                              home_no.text,
                              moo_no.text,
                              tumbolId,
                              amphurId,
                              provinceId,
                            ),
                          ),
                        );
                        // if (idblacklist.text.isEmpty &&
                        //     smartId.text.isEmpty &&
                        //     name.text.isEmpty &&
                        //     lastname.text.isEmpty &&
                        //     home_no.text.isEmpty &&
                        //     moo_no.text.isEmpty &&
                        //     district.text.isEmpty &&
                        //     amphoe.text.isEmpty &&
                        //     provincn.text.isEmpty) {
                        //   showProgressDialog(
                        //       context, 'แจ้งเตือน', 'กรุณากรอกข้อมูลลูกค้า');
                        // } else {
                        //   if (home_no.text.isNotEmpty ||
                        //       moo_no.text.isNotEmpty) {
                        //     if (district.text.isEmpty) {
                        //       showProgressDialog(context, 'แจ้งเตือน',
                        //           'กรุณาเลือก ตำบล อำเภอ จังหวัด');
                        //     } else {
                        //       Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //           builder: (context) => BlacklistCustList(
                        //             idblacklist.text,
                        //             smartId.text,
                        //             name.text,
                        //             lastname.text,
                        //             home_no.text,
                        //             moo_no.text,
                        //             tumbolId,
                        //             amphurId,
                        //             provinceId,
                        //           ),
                        //         ),
                        //       );
                        //     }
                        //   } else {
                        //     Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //         builder: (context) => BlacklistCustList(
                        //           idblacklist.text,
                        //           smartId.text,
                        //           name.text,
                        //           lastname.text,
                        //           home_no.text,
                        //           moo_no.text,
                        //           tumbolId,
                        //           amphurId,
                        //           provinceId,
                        //         ),
                        //       ),
                        //     );
                        //   }
                        // }
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
                        clearDataBlacklist();
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

class CustomerBlackList extends StatefulWidget {
  const CustomerBlackList({super.key});

  @override
  State<CustomerBlackList> createState() => _CustomerBlackListState();
}

class _CustomerBlackListState extends State<CustomerBlackList> {
  String userId = '', empId = '', firstName = '', lastName = '', tokenId = '';
  String districtId = '', text_province = '', text_amphoe = '';
  String selectValue_province = '', selectValue_amphoe = '';
  List list_district = [], dropdown_search_bl = [], list_dataSearch_bl = [];
  var selectValue_bl;
  TextEditingController searchData = TextEditingController();
  TextEditingController nameSearchBl = TextEditingController();
  TextEditingController lastnameSearchBl = TextEditingController();
  bool statusLoading = false,
      statusLoad404 = false,
      isLoadScroll = false,
      isLoadendPage = false;
  final scrollControll = TrackingScrollController();
  int offset = 50, stquery = 0;

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
    getSelectBlSearch();
    myScroll(scrollControll, offset);
  }

  Future<void> getSelectBlSearch() async {
    try {
      var respose = await http.get(
        Uri.parse('${api}setup/blSearchList'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> data =
            Map<String, dynamic>.from(json.decode(respose.body));
        setState(() {
          dropdown_search_bl = data['data'];
          selectValue_bl = dropdown_search_bl[0]['id'];
        });
        statusLoading = true;
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

  Future<void> getData_search_bl(searchType, String? searchData,
      String? firstName, String? lastName, offset) async {
    try {
      var respose = await http.post(
        Uri.parse('${api}credit/blacklist'),
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
          'limit': '$offset'
        }),
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> data_list =
            Map<String, dynamic>.from(json.decode(respose.body));

        setState(() {
          list_dataSearch_bl = data_list['data'];
          statusLoading = true;
        });
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

  void myScroll(ScrollController scrollController, int offset) {
    scrollController.addListener(() async {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        setState(() {
          isLoadScroll = true;
        });
        await Future.delayed(const Duration(seconds: 1), () {
          offset = offset + 20;
          btnSendvalue(offset);
        });
      }
    });
  }

  btnSendvalue(offset) {
    setState(() {
      if (selectValue_bl.toString() == "2") {
        if (nameSearchBl.text.isEmpty && lastnameSearchBl.text.isEmpty) {
          showProgressDialog(context, 'แจ้งเตือน', 'กรุณากรอก ชื่อ-นามสกุล');
        } else {
          getData_search_bl(selectValue_bl, '', nameSearchBl.text,
              lastnameSearchBl.text, offset);
        }
      } else {
        if (searchData.text.isEmpty) {
          showProgressDialog(
              context, 'แจ้งเตือน', 'กรุณากรอกข้อมูลที่ต้องการค้นหา');
        } else {
          getData_search_bl(selectValue_bl, searchData.text, '', '', offset);
        }
      }
    });
  }

  clearValueSearch() {
    setState(() {
      statusLoad404 = false;
      list_dataSearch_bl = [];
      getSelectBlSearch();
      isLoadScroll = false; // ✅ ปิด loading
      isLoadendPage = false;
    });
    searchData.clear();
    nameSearchBl.clear();
    lastnameSearchBl.clear();
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
      appBar: const CustomAppbar(title: 'ค้นหาลูกค้า Blacklist'),
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
                  color: const Color.fromRGBO(162, 181, 252, 1),
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
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.width * 0.105,
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 4),
                                  child: DropdownButton(
                                    items: dropdown_search_bl
                                        .map(
                                          (value) => DropdownMenuItem(
                                            value: value['id'],
                                            child: Text(
                                              value['name'],
                                              style:
                                                  MyContant().textInputStyle(),
                                            ),
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
                                        statusLoad404 = false;
                                      });
                                    },
                                    value: selectValue_bl,
                                    isExpanded: true,
                                    underline: const SizedBox(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          ...(selectValue_bl.toString() == "2"
                              ? [
                                  inputNameSearchBl(sizeIcon, border),
                                  const SizedBox(width: 10),
                                  inputLastnameSearchBl(sizeIcon, border),
                                ]
                              : [
                                  inputSearchData(sizeIcon, border),
                                ])
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
                          controller: scrollControll,
                          physics: const BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics(),
                          ),
                          child: Column(
                            children: [
                              ...list_dataSearch_bl.map(
                                (item) {
                                  return InkWell(
                                    onTap: () {
                                      Navigator.pop(context, {
                                        'id': item['blId'],
                                        'name': item['custName'],
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
                                              162, 181, 252, 1),
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
                                                    'รหัส : ${item['blId']}',
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
                                                    'ชื่อ-สกุล : ',
                                                    style: MyContant()
                                                        .h4normalStyle(),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      '${item['custName']}',
                                                      style: MyContant()
                                                          .h4normalStyle(),
                                                      overflow:
                                                          TextOverflow.clip,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 5),
                                              Row(
                                                children: [
                                                  Text(
                                                    'เลขบัตรประชนชน : ${item['smartId']}',
                                                    style: MyContant()
                                                        .h4normalStyle(),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 5),
                                              Row(
                                                children: [
                                                  Text(
                                                    'สถานะ : ${item['blStatus']}',
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
                                                    'เบอร์โทรศัพท์ : ',
                                                    style: MyContant()
                                                        .h4normalStyle(),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      '${item['telephone']}',
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
                                    ),
                                  );
                                },
                              ),
                              if (isLoadScroll && !isLoadendPage)
                                const LoadData()
                              else if (isLoadendPage)
                                const EndPage(),
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
                          btnSendvalue(offset);
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
                        clearValueSearch();
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

  Expanded inputSearchData(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: searchData,
          onChanged: (keyword) {},
          decoration: InputDecoration(
            counterText: "",
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

  Expanded inputNameSearchBl(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: nameSearchBl,
          onChanged: (keyword) {},
          decoration: InputDecoration(
            counterText: "",
            contentPadding: const EdgeInsets.all(8),
            isDense: true,
            enabledBorder: border,
            focusedBorder: border,
            hintText: 'ชื่อ',
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

  Expanded inputLastnameSearchBl(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: lastnameSearchBl,
          onChanged: (keyword) {},
          decoration: InputDecoration(
            counterText: "",
            contentPadding: const EdgeInsets.all(8),
            isDense: true,
            enabledBorder: border,
            focusedBorder: border,
            hintText: 'นามสกุล',
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

class DistrictList extends StatefulWidget {
  const DistrictList({super.key});

  @override
  State<DistrictList> createState() => _DistrictListState();
}

class _DistrictListState extends State<DistrictList> {
  String userId = '', empId = '', firstName = '', lastName = '', tokenId = '';
  List dropdown_province = [], dropdown_amphoe = [], list_district = [];
  var selectValue_province, selectValue_amphoe, provinceId, amphoeId;
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

  Future<void> getSelectAmphur(selectprovince) async {
    try {
      var respose = await http.get(
        Uri.parse('${api}setup/amphurList?pId=$selectprovince'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> data_amphoe =
            Map<String, dynamic>.from(json.decode(respose.body));
        setState(() {
          dropdown_amphoe = data_amphoe['data'];
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
      } else {
        print(respose.statusCode);
      }
    } catch (e) {
      print("ไม่มีข้อมูล $e");
      showProgressDialogNotdata(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผูดูแลระบบ');
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
      appBar: CustomAppbar(title: 'ค้นหาจังหวัดอำเภอตำบล'),
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
                  color: const Color.fromRGBO(162, 181, 252, 1),
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
                                        final parts =
                                            dfvalue.toString().split('_');
                                        provinceId = parts[0];
                                        text_province = parts[1];
                                        selectValue_amphoe = null;
                                      });
                                      getSelectAmphur(selectValue_province
                                          .toString()
                                          .split("_")[0]);
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
                                        final parts =
                                            dfvalue.toString().split('_');
                                        amphoeId = parts[0];
                                        text_amphoe = parts[1];
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
            SizedBox(height: 5),
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
                                    Navigator.pop(context, {
                                      'id': list_district[i]['id'],
                                      'name': list_district[i]['name'],
                                      'province': text_province,
                                      'provinceId': provinceId,
                                      'amphoe': text_amphoe,
                                      'amphoeId': amphoeId,
                                    });
                                    // print({
                                    //   'id': list_district[i]['id'],
                                    //   'name': list_district[i]['name'],
                                    //   'province': text_province,
                                    //   'provinceId': provinceId,
                                    //   'amphoe': text_amphoe,
                                    //   'amphoeId': amphoeId,
                                    // });
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
                                            162, 181, 252, 1),
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
                                ),
                              const SizedBox(height: 40)
                            ],
                          ),
                        ),
            )
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
