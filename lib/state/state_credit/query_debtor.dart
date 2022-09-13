import 'package:application_thaweeyont/widgets/show_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../../model/login_model.dart';
import 'data_searchdebtor.dart';
import 'package:application_thaweeyont/utility/my_constant.dart';

class Query_debtor extends StatefulWidget {
  const Query_debtor({Key? key}) : super(key: key);

  @override
  State<Query_debtor> createState() => _Query_debtorState();
}

class _Query_debtorState extends State<Query_debtor> {
  var selected,
      selectedBranch,
      selectedreceiType,
      selectedStatus,
      selectsector,
      selectprovince,
      selectamphoe;
  List<String> dropdownValue = <String>[
    'ชื่อ',
    'นามสกุล',
    'เบอร์โทร',
    'เลขบัตรประชาชน'
  ];
  List<String> dropdownBranch = <String>[
    'แม่สาย',
    'สำนักงานใหญ่',
    'เชียงรายมอลล์ ',
    'แม่จัน'
  ];
  List<String> dropdownreceiType = <String>['ดีมาก', 'ดี', 'ปานกลาง ', 'ไม่ดี'];
  List<String> dropdowncontractStatus = <String>['ยังไม่หมดสัญญา', 'หมดสัญญา'];
  List<String> dropdowncdropdownValuesectorontractStatus = <String>[
    'ยังไม่หมดสัญญา',
    'หมดสัญญา'
  ];
  List<String> dropdownsector = <String>[
    'ภาคเหนือ',
    'ภาคกลาง',
    'ภาคอีสาน',
    'ภาคใต้ '
  ];
  List<String> dropdownprovince = <String>[
    'เชียงราย',
    'เชียงใหม่',
    'พะเยา',
    'ลำปาง'
  ];
  List<String> dropdownamphoe = <String>[
    'เมืองเชียงราย',
    'แม่จัน',
    'แม่สาย',
    'พาน'
  ];
  var filter = false;
  List<Login> datauser = [];
  TextEditingController idcard = TextEditingController();
  TextEditingController district = TextEditingController();
  TextEditingController amphoe = TextEditingController();
  TextEditingController provincn = TextEditingController();

  Future<void> get_datauser(String id_card) async {
    try {
      var respose = await http.get(
        Uri.http('110.164.131.46', '/flutter_api/api_user/login_user.php',
            {"id_card": id_card}),
      );
      // print(respose.body);
      if (respose.statusCode == 200) {
        setState(() {
          datauser = loginFromJson(respose.body);
        });
        print(respose.body);
        // if (datauser[0].idcard!.isNotEmpty) {
        //   setpreferences();
        // }
      }
    } catch (e) {
      print("ไม่มีข้อมูล");
      showProgressDialog(context, 'แจ้งเตือน', 'ไม่พบข้อมูลเลขบัตรประชาชนนี้');
    }
  }

  Future<Null> search_district(sizeIcon, border) async {
    double size = MediaQuery.of(context).size.width;
    // bool btn_edit = false;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => GestureDetector(
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
                                        setState(() {
                                          selectsector = null;
                                          selectprovince = null;
                                          selectamphoe = null;
                                        });
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
                              Row(
                                children: [
                                  Text(
                                    'ภาค',
                                    style: MyContant().h4normalStyle(),
                                  ),
                                  select_sectorDia(context, setState),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    'จังหวัด',
                                    style: MyContant().h4normalStyle(),
                                  ),
                                  select_provincnDia(context, setState),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    '​อำเภอ',
                                    style: MyContant().h4normalStyle(),
                                  ),
                                  select_amphoeDia(context, setState),
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
                                    onPressed: () {},
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
                                  for (var i = 0; i <= 10; i++) ...[
                                    InkWell(
                                      onTap: () {
                                        setState(
                                          () {
                                            district.text = 'รอบเวียง';
                                            amphoe.text = 'เมืองเชียงราย';
                                            provincn.text = 'เชียงราย';
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
                                          color:
                                              Color.fromRGBO(255, 218, 249, 1),
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
                                                  'เชียงราย',
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
                                                  'เมืองเชียงราย',
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
                                                  'รอบเวียง',
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

  Expanded select_amphoeDia(BuildContext context, StateSetter setState) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: MediaQuery.of(context).size.width * 0.07,
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: DropdownButton(
            items: dropdownamphoe
                .map((value) => DropdownMenuItem(
                      child: Text(
                        value,
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                      value: value,
                    ))
                .toList(),
            onChanged: (selected_Amphoe) {
              setState(() {
                selectamphoe = selected_Amphoe;
              });
            },
            value: selectamphoe,
            isExpanded: true,
            underline: SizedBox(),
            hint: Align(
              child: Text(
                'เลือกอำเภอ',
                style: TextStyle(
                    fontSize: 14, color: Color.fromRGBO(106, 106, 106, 1)),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Expanded select_provincnDia(BuildContext context, StateSetter setState) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: MediaQuery.of(context).size.width * 0.07,
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: DropdownButton(
            items: dropdownprovince
                .map((value) => DropdownMenuItem(
                      child: Text(
                        value,
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                      value: value,
                    ))
                .toList(),
            onChanged: (selected_Provincn) {
              setState(() {
                selectprovince = selected_Provincn;
              });
            },
            value: selectprovince,
            isExpanded: true,
            underline: SizedBox(),
            hint: Align(
              child: Text(
                'เลือกจังหวัด',
                style: TextStyle(
                    fontSize: 14, color: Color.fromRGBO(106, 106, 106, 1)),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Expanded select_sectorDia(BuildContext context, StateSetter setState) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: MediaQuery.of(context).size.width * 0.07,
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: DropdownButton(
            items: dropdownsector
                .map((value) => DropdownMenuItem(
                      child: Text(
                        value,
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                      value: value,
                    ))
                .toList(),
            onChanged: (selected_Sector) {
              setState(() {
                selectsector = selected_Sector;
              });
            },
            value: selectsector,
            isExpanded: true,
            underline: SizedBox(),
            hint: Align(
              child: Text(
                'เลือกภาค',
                style: TextStyle(
                    fontSize: 14, color: Color.fromRGBO(106, 106, 106, 1)),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<Null> search_conType(sizeIcon, border) async {
    double size = MediaQuery.of(context).size.width;
    // bool btn_edit = false;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => GestureDetector(
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
                                      onTap: () => Navigator.pop(context),
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
                                  Text('ชื่อ'),
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
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.all(0),
                                      textStyle: const TextStyle(fontSize: 16),
                                    ),
                                    onPressed: () {},
                                    child: const Text('ค้นหา'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Text('รายการที่ค้นหา'),
                            ],
                          ),
                          SizedBox(height: 10),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.4,
                            child: Scrollbar(
                              child: ListView(
                                children: [
                                  for (var i = 0; i <= 10; i++) ...[
                                    Container(
                                      margin: EdgeInsets.symmetric(vertical: 5),
                                      padding: EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        color: Color.fromRGBO(255, 218, 249, 1),
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text('รหัส : 1432'),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                  'ชื่อ : 4 Way Dual vane Panel'),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
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

  clearTextInput() {
    idcard.clear();
    district.clear();
    amphoe.clear();
    provincn.clear();
    setState(() {
      datauser.clear();
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
                  if (filter == true) ...[
                    Row(
                      children: [
                        Text(
                          'เบอร์โทร',
                          style: MyContant().h4normalStyle(),
                        ),
                        input_tel(sizeIcon, border),
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
                          'เลขที่สัญญา',
                          style: MyContant().h4normalStyle(),
                        ),
                        input_contractNumber(sizeIcon, border),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'ประเภทลูกหนี้ ',
                          style: MyContant().h4normalStyle(),
                        ),
                        select_receivableType(sizeIcon, border),
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
                  if (datauser.isNotEmpty) ...[
                    for (var i = 0; i < datauser.length; i++) ...[
                      InkWell(
                        onTap: () {
                          var idcard = datauser[i].idcard;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Data_SearchDebtor(idcard)),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
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
                                    Text('รหัสเขต : ${datauser[i].id}'),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('เลขที่สัญญา : ${datauser[i].idcard}'),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                        'ชื่อลูกค้าในสัญญา : ${datauser[i].fullname}'),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                        'ชื่อลูกค้าปัจจุบัน : ${datauser[i].fullname}'),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                        'ชื่อสินค้า : ${datauser[i].phoneUser}'),
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
                          style: MyContant().h3Style(),
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
                      // decoration: BoxDecoration(
                      //   borderRadius: BorderRadius.all(Radius.circular(10)),
                      //   color: Color.fromRGBO(76, 83, 146, 1),
                      // ),
                      child: TextButton(
                        style: MyContant().myButtonSearchStyle(),
                        // style: TextButton.styleFrom(
                        //   foregroundColor: Colors.white,
                        //   padding: const EdgeInsets.all(0),
                        //   textStyle: const TextStyle(fontSize: 16),
                        // ),
                        onPressed: () {
                          if (idcard.text.isNotEmpty) {
                            get_datauser(idcard.text);
                          } else {
                            showProgressDialog(context, 'แจ้งเตือน',
                                'กรูณากรอกข้อมูลที่ต้องการค้นหา!');
                          }
                        },
                        child: const Text('ค้นหา'),
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      height: 30,
                      // decoration: BoxDecoration(
                      //   borderRadius: BorderRadius.all(Radius.circular(10)),
                      //   color: Color.fromRGBO(248, 40, 78, 1),
                      // ),
                      child: TextButton(
                        style: MyContant().myButtonCancelStyle(),
                        // style: TextButton.styleFrom(
                        //   foregroundColor: Colors.white,
                        //   padding: const EdgeInsets.all(0),
                        //   textStyle: const TextStyle(fontSize: 16),
                        // ),
                        onPressed: clearTextInput,
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
        ),
      ),
    );
  }

  Expanded input_tel(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          keyboardType: TextInputType.number,
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
        ),
      ),
    );
  }

  Expanded select_search(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: MediaQuery.of(context).size.width * 0.07,
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: DropdownButton(
            items: dropdownValue
                .map((value) => DropdownMenuItem(
                      child: Text(
                        value,
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                      value: value,
                    ))
                .toList(),
            onChanged: (selectedSearch) {
              setState(() {
                selected = selectedSearch;
              });
            },
            value: selected,
            isExpanded: true,
            underline: SizedBox(),
            hint: Align(
              child: Text(
                'ค้นหาจาก',
                style: TextStyle(
                    fontSize: 14, color: Color.fromRGBO(106, 106, 106, 1)),
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
        ),
      ),
    );
  }

  Expanded input_moo(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
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
        ),
      ),
    );
  }

  Expanded select_branch(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          // height: 27,
          height: MediaQuery.of(context).size.width * 0.07,
          // margin: EdgeInsets.zero,
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: DropdownButton(
            items: dropdownBranch
                .map((value) => DropdownMenuItem(
                      child: Text(
                        value,
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                      value: value,
                    ))
                .toList(),
            onChanged: (selected_branch) {
              setState(() {
                selectedBranch = selected_branch;
              });
            },
            value: selectedBranch,
            isExpanded: true,
            underline: SizedBox(),
            hint: Align(
              child: Text(
                'เลือกสาขา',
                style: TextStyle(
                    fontSize: 14, color: Color.fromRGBO(106, 106, 106, 1)),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Expanded input_contractNumber(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
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
        ),
      ),
    );
  }

  Expanded select_receivableType(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          // height: 27,
          height: MediaQuery.of(context).size.width * 0.07,
          // margin: EdgeInsets.zero,
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: DropdownButton(
            items: dropdownreceiType
                .map((value) => DropdownMenuItem(
                      child: Text(
                        value,
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                      value: value,
                    ))
                .toList(),
            onChanged: (selected_receiType) {
              setState(() {
                selectedreceiType = selected_receiType;
              });
            },
            value: selectedreceiType,
            isExpanded: true,
            underline: SizedBox(),
            hint: Align(
              child: Text(
                'เลือกประเภทลูกหนี้',
                style: TextStyle(
                    fontSize: 14, color: Color.fromRGBO(106, 106, 106, 1)),
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
          // height: 27,
          height: MediaQuery.of(context).size.width * 0.07,
          // margin: EdgeInsets.zero,
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: DropdownButton(
            items: dropdowncontractStatus
                .map((value) => DropdownMenuItem(
                      child: Text(
                        value,
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                      value: value,
                    ))
                .toList(),
            onChanged: (selected_status) {
              setState(() {
                selectedStatus = selected_status;
              });
            },
            value: selectedStatus,
            isExpanded: true,
            underline: SizedBox(),
            hint: Align(
              child: Text(
                'เลือกสถานะสัญญา',
                style: TextStyle(
                    fontSize: 14, color: Color.fromRGBO(106, 106, 106, 1)),
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
        ),
      ),
    );
  }

  Expanded input_nameDia(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
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
        ),
      ),
    );
  }
}
