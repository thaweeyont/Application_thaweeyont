import 'dart:async';
import 'dart:convert';

import 'package:application_thaweeyont/state/state_credit/query_debtor/data_debtor_list.dart';
import 'package:application_thaweeyont/widgets/custom_appbar.dart';
import 'package:application_thaweeyont/widgets/endpage.dart';
import 'package:application_thaweeyont/widgets/loaddata.dart';
import 'package:application_thaweeyont/widgets/loading_view.dart';
import 'package:application_thaweeyont/widgets/nodata_view.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loading_gifs/loading_gifs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../authen.dart';
import 'package:application_thaweeyont/utility/my_constant.dart';
import 'package:application_thaweeyont/api.dart';

class QueryDebtor extends StatefulWidget {
  const QueryDebtor({super.key});

  @override
  State<QueryDebtor> createState() => _QueryDebtorState();
}

class _QueryDebtorState extends State<QueryDebtor> {
  String userId = '',
      empId = '',
      firstName = '',
      lastName = '',
      tokenId = '',
      text_province = '',
      text_amphoe = '';
  bool? allowApproveStatus;

  var filter = false;
  TextEditingController idcard = TextEditingController();
  TextEditingController firstnameCus = TextEditingController();
  TextEditingController lastnameCus = TextEditingController();
  TextEditingController district = TextEditingController();
  TextEditingController amphoe = TextEditingController();
  TextEditingController provincn = TextEditingController();
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
  List list_dataDebtor = [];
  List dropdown_addresstype = [],
      dropdown_branch = [],
      dropdown_debtorType = [],
      dropdown_signStatus = [],
      dropdown_customer = [];
  List list_Debtordetail = [], list_datavalue = [];
  var select_addreessType,
      select_branchlist,
      select_debtorType,
      select_signStatus,
      debtorStatuscode,
      itemType;

  var selectValue_customer, Texthint;
  var signStatus, branch, debtorType, tumbol, tumbolId, amphurId, provinceId;

  @override
  void initState() {
    super.initState();
    getdata();
  }

  Future<void> getdata() async {
    final preferences = await SharedPreferences.getInstance();

    if (!mounted) return;

    setState(() {
      userId = preferences.getString('userId') ?? '';
      empId = preferences.getString('empId') ?? '';
      firstName = preferences.getString('firstName') ?? '';
      lastName = preferences.getString('lastName') ?? '';
      tokenId = preferences.getString('tokenId') ?? '';
      allowApproveStatus = preferences.getBool('allowApproveStatus') ?? false;
    });

    getSelectAddressTypelist();
    getSelectBranch();
    getSelectDebtorType();
    getSelectSignStatus();
  }

  Future<void> getSelectAddressTypelist() async {
    try {
      var response = await http.get(
        Uri.parse('${api}setup/addressTypeList'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
      );
      if (!mounted) return;

      if (response.statusCode == 200) {
        Map<String, dynamic> data_addressTypelist =
            Map<String, dynamic>.from(json.decode(response.body));
        setState(() {
          dropdown_addresstype = data_addressTypelist['data'];
          select_addreessType = dropdown_addresstype[0]['id'];
        });
      } else {
        handleHttpError(response.statusCode);
      }
    } catch (e) {
      if (!mounted) return;
      print("ไม่มีข้อมูล $e");
      showProgressDialogNotdata(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
  }

  Future<void> getSelectBranch() async {
    try {
      var response = await http.get(
        Uri.parse('${api}setup/branchList'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
      );
      if (!mounted) return;

      if (response.statusCode == 200) {
        Map<String, dynamic> data_branch =
            Map<String, dynamic>.from(json.decode(response.body));
        setState(() {
          dropdown_branch = data_branch['data'];
        });
      } else {
        handleHttpError(response.statusCode);
      }
    } catch (e) {
      if (!mounted) return;
      print("ไม่มีข้อมูล $e");
      showProgressDialogNotdata(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
  }

  Future<void> getSelectDebtorType() async {
    try {
      var response = await http.get(
        Uri.parse('${api}setup/debtorTypeList'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
      );
      if (!mounted) return;

      if (response.statusCode == 200) {
        Map<String, dynamic> data_debtorType =
            Map<String, dynamic>.from(json.decode(response.body));
        setState(() {
          dropdown_debtorType = data_debtorType['data'];
        });
      } else {
        handleHttpError(response.statusCode);
      }
    } catch (e) {
      if (!mounted) return;
      print("ไม่มีข้อมูล $e");
      showProgressDialogNotdata(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
  }

  Future<void> getSelectSignStatus() async {
    try {
      var response = await http.get(
        Uri.parse('${api}setup/signStatusList'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
      );
      if (!mounted) return;

      if (response.statusCode == 200) {
        Map<String, dynamic> data_signStatusList =
            Map<String, dynamic>.from(json.decode(response.body));
        setState(() {
          dropdown_signStatus = data_signStatusList['data'];
          select_signStatus = dropdown_signStatus[0]['id'];
        });
      } else {
        handleHttpError(response.statusCode);
      }
    } catch (e) {
      if (!mounted) return;
      print("ไม่มีข้อมูล $e");
      showProgressDialogNotdata(
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
        // statusLoading = true;
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
      tumbolId = null;
      amphurId = null;
      provinceId = null;
      getSelectSignStatus();
      getSelectAddressTypelist();
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ItemTypeList(),
                                ),
                              ).then((result) {
                                if (result != null) {
                                  setState(() {
                                    itemTypelist.text = result['name'];
                                    itemType = result?['id'] ?? '';
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
                    ],
                  ],
                ),
              ),
            ),
            groupBtnsearch(),
            const SizedBox(height: 70),
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
                  setState(() {
                    filter = !filter;
                  });
                },
                child: Row(
                  children: [
                    Text(
                      filter ? 'ค้นหาแบบย่อย' : 'ค้นหาแบบละเอียด',
                      style: MyContant().TextsearchStyle(),
                    ),
                    Icon(
                      filter ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
              // InkWell(
              //   onTap: () {
              //     if (filter == false) {
              //       setState(() {
              //         filter = true;
              //       });
              //     } else {
              //       setState(() {
              //         filter = false;
              //       });
              //     }
              //   },
              //   child: Row(
              //     children: [
              //       if (filter == true) ...[
              //         Text(
              //           'ค้นหาแบบย่อย',
              //           style: MyContant().TextsearchStyle(),
              //         ),
              //         const Icon(
              //           Icons.arrow_drop_up,
              //           color: Colors.black,
              //         ),
              //       ] else ...[
              //         Text(
              //           'ค้นหาแบบละเอียด',
              //           style: MyContant().TextsearchStyle(),
              //         ),
              //         const Icon(
              //           Icons.arrow_drop_down,
              //           color: Colors.black,
              //         ),
              //       ],
              //     ],
              //   ),
              // ),
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
                            builder: (context) => DataDebtorList(
                              custId.text,
                              homeNo.text,
                              moo.text,
                              tumbolId,
                              amphurId,
                              provinceId,
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
                              itemType = itemType ?? '',
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
  bool st_customer = true, st_employee = false;
  var selectValue_customer, Texthint;
  final scrollControll = TrackingScrollController();
  bool isLoadScroll = false;
  bool isLoadendPage = false;
  bool isLoadingMore = false;
  bool isAtBottom = false;
  bool statusLoading = false;
  bool statusLoad404 = false;
  int offset = 20;
  int step = 20;
  int totalRows = 0;

  TextEditingController searchData = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController firstnameEm = TextEditingController();
  TextEditingController lastnameEm = TextEditingController();

  @override
  void initState() {
    super.initState();
    myScroll();
    getdata();
  }

  @override
  void dispose() {
    scrollControll.dispose();
    super.dispose();
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
          'limit': '$offset'
        }),
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> dataList =
            Map<String, dynamic>.from(json.decode(respose.body));

        List newData = dataList['data'] ?? [];

        totalRows = int.tryParse(dataList['rowCount'].toString()) ?? 0;

        setState(() {
          list_datavalue = newData;

          isLoadendPage = list_datavalue.length >= totalRows;

          isLoadScroll = false;
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

  Future<void> getData_search() async {
    String customerType = selectValue_customer.toString();
    String firstName = '';
    String lastName = '';
    String keyword = '';

    if (id == '1') {
      if (customerType == '2') {
        firstName = searchData.text;
        lastName = lastname.text;
      } else {
        keyword = searchData.text;
      }
    } else {
      customerType = '2';
      firstName = firstnameEm.text;
      lastName = lastnameEm.text;
    }

    await getData_condition(
      id,
      customerType,
      keyword,
      firstName,
      lastName,
    );
  }

  void myScroll() {
    scrollControll.addListener(() async {
      if (!scrollControll.hasClients) return;

      final position = scrollControll.position;

      if (position.maxScrollExtent <= 0) return;

      final isNearBottom = position.pixels >= position.maxScrollExtent - 50;

      // 👇 ถ้ายังไม่ถึงล่าง รีเซ็ต flag
      if (!isNearBottom) {
        isAtBottom = false;
        return;
      }

      // 👇 ถึงล่างแล้ว และเคยโหลดไปแล้ว ห้ามยิงซ้ำ
      if (isAtBottom) return;

      if (isLoadingMore || isLoadendPage) return;

      isAtBottom = true;

      setState(() {
        isLoadingMore = true;
        offset += step;
      });

      await getData_search();

      setState(() {
        isLoadingMore = false;
      });
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
      isLoadScroll = false;
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
                child: content(sizeIcon, border, context),
              ),
            ),
            groupBtnsearch(),
            const SizedBox(height: 5),
            Expanded(
              child: statusLoading == false
                  ? LoadingView()
                  : statusLoad404 == true
                      ? NoDataView()
                      : mainContent(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget content(sizeIcon, border, context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          radioSection(),
          if (st_employee) employeeInput(sizeIcon, border),
          if (st_customer) customerInput(context, sizeIcon, border),
        ],
      ),
    );
  }

  Row employeeInput(sizeIcon, border) {
    return Row(
      children: [
        Text('ชื่อ', style: MyContant().h4normalStyle()),
        inputNameEmploDia(sizeIcon, border),
        Text('สกุล', style: MyContant().h4normalStyle()),
        inputLastNameEmploDia(sizeIcon, border),
      ],
    );
  }

  Row customerInput(context, sizeIcon, border) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: customerDropdown(context),
        ),
        inputSearchCus(sizeIcon, border),
        if (selectValue_customer.toString() == "2") ...[
          inputLastnameCus(sizeIcon, border)
        ],
      ],
    );
  }

  Widget customerDropdown(context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Container(
        height: MediaQuery.of(context).size.width * 0.095,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(5)),
        child: Padding(
          padding: const EdgeInsets.only(left: 4),
          child: DropdownButton(
            items: dropdown_customer
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
                selectValue_customer = newvalue;
                Texthint = newvalue.toString() == '2' ? 'ชื่อ' : '';
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
    );
  }

  Widget radioSection() {
    return RadioGroup<String>(
      groupValue: id,
      onChanged: (value) {
        setState(() {
          id = value!;
          final isCustomer = value == '1';
          st_customer = isCustomer;
          st_employee = !isCustomer;
          searchData.clear();
        });
      },
      child: Row(
        children:
            ['1', '2'].map((val) => Expanded(child: radioTile(val))).toList(),
      ),
    );
  }

  Widget radioTile(String val) {
    final isCustomer = val == '1';

    return RadioListTile<String>(
      activeColor: Colors.black,
      value: val,
      title: Text(
        isCustomer ? 'ลูกค้าทั่วไป' : 'พนักงาน',
        style: MyContant().h4normalStyle(),
      ),
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  SingleChildScrollView mainContent(BuildContext context) {
    return SingleChildScrollView(
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
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    color: const Color.fromRGBO(255, 203, 246, 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.5),
                        spreadRadius: 0.2,
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      )
                    ],
                  ),
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
                              'รหัส : ${list_datavalue[i]['custId']}',
                              style: MyContant().h4normalStyle(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ชื่อ : ',
                              style: MyContant().h4normalStyle(),
                            ),
                            Expanded(
                              child: Text(
                                '${list_datavalue[i]['custName']}',
                                style: MyContant().h4normalStyle(),
                                overflow: TextOverflow.clip,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ที่อยู่ : ',
                              style: MyContant().h4normalStyle(),
                            ),
                            Expanded(
                              child: Text(
                                '${list_datavalue[i]['address']}',
                                style: MyContant().h4normalStyle(),
                                overflow: TextOverflow.clip,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'โทร : ',
                              style: MyContant().h4normalStyle(),
                            ),
                            Expanded(
                              child: Text(
                                '${list_datavalue[i]['telephone']}',
                                style: MyContant().h4normalStyle(),
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
          if (isLoadScroll && !isLoadendPage)
            const LoadData()
          else if (isLoadendPage)
            const EndPage(),
          const SizedBox(height: 20),
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
                        // 🔎 VALIDATE

                        if (id == '1') {
                          if (selectValue_customer == null ||
                              (searchData.text.isEmpty &&
                                  lastname.text.isEmpty)) {
                            showProgressDialog(
                                context, 'แจ้งเตือน', 'กรุณากรอกข้อมูล');
                            return;
                          }
                        } else {
                          if (firstnameEm.text.isEmpty &&
                              lastnameEm.text.isEmpty) {
                            showProgressDialog(
                                context, 'แจ้งเตือน', 'กรุณากรอกข้อมูล');
                            return;
                          }
                        }

                        // 🔥 RESET STATE ก่อนค้นหาใหม่
                        setState(() {
                          offset = step; // reset limit
                          list_datavalue.clear(); // ล้างของเก่า
                          isLoadendPage = false;
                          isLoadScroll = false;
                          statusLoading = false;
                        });

                        // 🚀 ยิง API
                        await getData_search();
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
                        clearValueDialog();
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
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        child: SizedBox(
          height: MediaQuery.of(context).size.width * 0.095,
          child: TextField(
            controller: searchData,
            onChanged: (keyword) {},
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(8),
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
        padding: const EdgeInsets.only(right: 4),
        child: TextField(
          controller: lastname,
          onChanged: (keyword) {},
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(7),
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
      } else {
        handleHttpError(respose.statusCode);
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
      } else {
        handleHttpError(respose.statusCode);
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
      } else {
        handleHttpError(respose.statusCode);
      }
    } catch (e) {
      print("ไม่มีข้อมูล $e");
      showProgressDialogNotdata(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผูดูแลระบบ');
    }
  }

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
      appBar: const CustomAppbar(title: 'ค้นหาจังหวัดอำเภอตำบล'),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        behavior: HitTestBehavior.opaque,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
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
            const SizedBox(height: 5),
            Expanded(
              child: statusLoading == false
                  ? LoadingView()
                  : statusLoad404 == true
                      ? NoDataView()
                      : mainContent(context),
            ),
          ],
        ),
      ),
    );
  }

  SingleChildScrollView mainContent(BuildContext context) {
    return SingleChildScrollView(
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
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    color: const Color.fromRGBO(255, 218, 249, 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.5),
                        spreadRadius: 0.2,
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      )
                    ],
                  ),
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
                              'จังหวัด : ',
                              style: MyContant().h4normalStyle(),
                            ),
                            Text(
                              text_province,
                              style: MyContant().h4normalStyle(),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'อำเภอ : ',
                              style: MyContant().h4normalStyle(),
                            ),
                            Text(
                              text_amphoe,
                              style: MyContant().h4normalStyle(),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'ตำบล : ',
                              style: MyContant().h4normalStyle(),
                            ),
                            Text(
                              '${list_district[i]['name']}',
                              style: MyContant().h4normalStyle(),
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

class ItemTypeList extends StatefulWidget {
  const ItemTypeList({super.key});

  @override
  State<ItemTypeList> createState() => _ItemTypeListState();
}

class _ItemTypeListState extends State<ItemTypeList> {
  String userId = '', empId = '', firstName = '', lastName = '', tokenId = '';
  List list_itemType = [];
  bool statusLoading = false,
      statusLoad404 = false,
      isLoadScroll = false,
      isLoadendPage = false;
  bool isLoadingMore = false;
  bool isAtBottom = false;
  TextEditingController searchNameItemtype = TextEditingController();
  final scrollControll = TrackingScrollController();
  int offset = 20;
  int step = 20;
  int totalRows = 0;

  @override
  void initState() {
    super.initState();
    getdata();
    myScroll();
  }

  @override
  void dispose() {
    scrollControll.dispose();
    super.dispose();
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
    statusLoading = true;
  }

  Future<void> getItemTypelist() async {
    try {
      var respose = await http.get(
        Uri.parse(
            '${api}setup/itemTypeList?searchName=${searchNameItemtype.text}&page=1&limit=$offset'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> data_itemTypelist =
            Map<String, dynamic>.from(json.decode(respose.body));

        List newData = data_itemTypelist['data'] ?? [];

        totalRows = int.tryParse(data_itemTypelist['rowCount'].toString()) ?? 0;
        setState(() {
          list_itemType = newData;
          isLoadendPage = list_itemType.length >= totalRows;

          isLoadScroll = false;
          statusLoading = true;
        });
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
          statusLoading = true;
          statusLoad404 = true;
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

  void myScroll() {
    scrollControll.addListener(() async {
      if (!scrollControll.hasClients) return;

      final position = scrollControll.position;

      if (position.maxScrollExtent <= 0) return;

      final isNearBottom = position.extentAfter < 200;

      if (!isNearBottom) {
        isAtBottom = false;
        return;
      }

      if (isAtBottom || isLoadingMore || isLoadendPage) return;

      isAtBottom = true;

      setState(() => isLoadingMore = true);

      offset += step;

      await getItemTypelist();

      if (!mounted) return;

      setState(() => isLoadingMore = false);
    });
  }

  clearValueSearchConType() {
    setState(() {
      list_itemType = [];
    });
    searchNameItemtype.clear();
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
      appBar: const CustomAppbar(title: 'ค้นหาประเภทสินค้า'),
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
                          Text(
                            'ชื่อประเภท',
                            style: MyContant().h4normalStyle(),
                          ),
                          inputNameDia(sizeIcon, border),
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
                  ? LoadingView()
                  : statusLoad404 == true
                      ? NoDataView()
                      : mainContent(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget mainContent(BuildContext context) {
    return ListView.builder(
      controller: scrollControll,
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      itemCount:
          list_itemType.length + ((isLoadScroll || isLoadendPage) ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < list_itemType.length) {
          final item = list_itemType[index];

          return InkWell(
            onTap: () {
              Navigator.pop(context, {
                'id': item['id'],
                'name': item['name'],
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
              child: buildItem(item),
            ),
          );
        }

        if (isLoadScroll && !isLoadendPage) {
          return const LoadData();
        }

        return const EndPage();
      },
    );
  }

  Widget buildItem(dynamic item) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromRGBO(255, 218, 249, 1),
      ),
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
                  'รหัส : ${item['id']}',
                  style: MyContant().h4normalStyle(),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ชื่อ : ',
                  style: MyContant().h4normalStyle(),
                ),
                Expanded(
                  child: Text(
                    item['name'] ?? '',
                    overflow: TextOverflow.clip,
                    style: MyContant().h4normalStyle(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // SingleChildScrollView mainContent(BuildContext context) {
  //   final List<Widget> items = list_itemType.map(
  //     (item) {
  //       return InkWell(
  //         onTap: () {
  //           Navigator.pop(context, {
  //             'id': item['id'],
  //             'name': item['name'],
  //           });
  //         },
  //         child: Padding(
  //           padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
  //           child: Container(
  //             padding: const EdgeInsets.all(6),
  //             decoration: BoxDecoration(
  //               borderRadius: const BorderRadius.all(
  //                 Radius.circular(10),
  //               ),
  //               color: const Color.fromRGBO(255, 218, 249, 1),
  //               boxShadow: [
  //                 BoxShadow(
  //                   color: Colors.grey.withValues(alpha: 0.5),
  //                   spreadRadius: 0.2,
  //                   blurRadius: 2,
  //                   offset: const Offset(0, 1),
  //                 )
  //               ],
  //             ),
  //             child: Container(
  //               padding: const EdgeInsets.all(6),
  //               decoration: BoxDecoration(
  //                 color: Colors.white.withValues(alpha: 0.7),
  //                 borderRadius: BorderRadius.circular(8),
  //               ),
  //               child: Column(
  //                 children: [
  //                   Row(
  //                     children: [
  //                       Text(
  //                         'รหัส : ${item['id']}',
  //                         style: MyContant().h4normalStyle(),
  //                       ),
  //                     ],
  //                   ),
  //                   const SizedBox(height: 5),
  //                   Row(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Text(
  //                         'ชื่อ : ',
  //                         style: MyContant().h4normalStyle(),
  //                       ),
  //                       Expanded(
  //                         child: Text(
  //                           item['name'] ?? '',
  //                           overflow: TextOverflow.clip,
  //                           style: MyContant().h4normalStyle(),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   ).toList();

  //   if (isLoadScroll && !isLoadendPage) {
  //     items.add(const LoadData());
  //   } else if (isLoadendPage) {
  //     items.add(const EndPage());
  //   }

  //   items.add(const SizedBox(height: 20));

  //   return SingleChildScrollView(
  //     controller: scrollControll,
  //     physics: const BouncingScrollPhysics(
  //       parent: AlwaysScrollableScrollPhysics(),
  //     ),
  //     child: Padding(
  //       padding: const EdgeInsets.only(bottom: 40),
  //       child: Column(
  //         children: items,
  //       ),
  //     ),
  //   );
  // }

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
                          getItemTypelist();
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
                          clearValueSearchConType();
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
