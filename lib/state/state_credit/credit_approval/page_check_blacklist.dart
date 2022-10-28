import 'dart:convert';
import 'dart:ffi';

import 'package:application_thaweeyont/utility/my_constant.dart';
import 'package:application_thaweeyont/widgets/show_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:application_thaweeyont/api.dart';

import '../../authen.dart';

class Page_Check_Blacklist extends StatefulWidget {
  // const Page_Check_Blacklist({super.key});
  final String? smartId;
  Page_Check_Blacklist(this.smartId);

  @override
  State<Page_Check_Blacklist> createState() => _Page_Check_BlacklistState();
}

class _Page_Check_BlacklistState extends State<Page_Check_Blacklist> {
  String userId = '', empId = '', firstName = '', lastName = '', tokenId = '';
  var valueStatus;
  List list_Blacklist = [];
  TextEditingController idcard = TextEditingController();
  // late String setvalue = widget.smartId.toString();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
    idcard.text = widget.smartId.toString();
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
    showProgressLoading(context);
    getData_blacklist();
  }

  Future<void> getData_blacklist() async {
    print(tokenId);
    print(idcard.text);
    valueStatus = " ";
    list_Blacklist = [];
    try {
      var respose = await http.post(
        Uri.parse('${api}credit/checkBlacklist'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
        body: jsonEncode(<String, String>{
          'smartId': idcard.text,
        }),
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> dataBlacklist =
            new Map<String, dynamic>.from(json.decode(respose.body));

        setState(() {
          list_Blacklist = dataBlacklist['data'];
        });

        Navigator.pop(context);
        print(list_Blacklist);
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

  clearValueblacklist() {
    idcard.clear();
    setState(() {
      list_Blacklist = [];
      valueStatus = null;
    });
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
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'เช็ค Blacklist',
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
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(251, 173, 55, 1),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'เลขบัตรประชาชน',
                          style: MyContant().h4normalStyle(),
                        ),
                        input_idcard(sizeIcon, border),
                      ],
                    ),
                    // Row(
                    //   children: [
                    //     Text(
                    //       'ชื่อ',
                    //       style: MyContant().h4normalStyle(),
                    //     ),
                    //     input_name(sizeIcon, border),
                    //     Text(
                    //       'สกุล',
                    //       style: MyContant().h4normalStyle(),
                    //     ),
                    //     input_lastname(sizeIcon, border),
                    //   ],
                    // ),
                    // Row(
                    //   children: [
                    //     Text(
                    //       'รหัส Blacklist',
                    //       style: MyContant().h4normalStyle(),
                    //     ),
                    //     input_idblacklist(sizeIcon, border),
                    //   ],
                    // ),
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
                    if (list_Blacklist.isNotEmpty) ...[
                      for (var i = 0; i < list_Blacklist.length; i++) ...[
                        InkWell(
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => Page_Info_Consider_Cus(),
                            //   ),
                            // );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 5),
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                color: Color.fromRGBO(251, 173, 55, 1),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'รหัสลูกค้า : ${list_Blacklist[i]['blId']}',
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
                                        'ชื่อลูกค้า : ${list_Blacklist[i]['custName']}',
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
                                        'ที่อยู่ : ',
                                        style: MyContant().h4normalStyle(),
                                      ),
                                      Expanded(
                                        child: Text(
                                          '${list_Blacklist[i]['custAddress']}',
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
                                        'สถานะ : ${list_Blacklist[i]['blStatus']}',
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
                    ] else ...[
                      if (valueStatus == 404) ...[
                        notData(context),
                      ],
                    ],
                  ],
                ),
              ),
            )
          ],
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
                          if (idcard.text.isEmpty) {
                            showProgressDialog(context, 'แจ้งเตือน',
                                'กรุณากรอกเลขบัตรประชาชน!');
                          } else {
                            showProgressLoading(context);
                            getData_blacklist();
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
                          clearValueblacklist();
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

  Expanded input_name(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
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

  Expanded input_idblacklist(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
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
}
