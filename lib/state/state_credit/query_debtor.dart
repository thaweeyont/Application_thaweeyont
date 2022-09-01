import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utility/my_constant.dart';

class Query_debtor extends StatefulWidget {
  const Query_debtor({Key? key}) : super(key: key);

  @override
  State<Query_debtor> createState() => _Query_debtorState();
}

class _Query_debtorState extends State<Query_debtor> {
  String dropdownValue = 'One';
  String dropdownValue1 = 'แม่สาย';
  String dropdownValue2 = 'text';
  String dropdownValue3 = 'tttt';
  String dropdownValuesector = 'ภาคเหนือ';
  String dropdownValueprovince = 'เชียงราย';
  String dropdownValueamphoe = 'เมืองเชียงราย';
  var filter = false;

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
                                  BorderRadius.all(Radius.circular(10)),
                              color: Color.fromRGBO(255, 218, 249, 1),
                            ),
                            padding: EdgeInsets.all(8),
                            width: double.infinity,
                            child: Column(children: [
                              Row(
                                children: [
                                  Text('ภาค'),
                                  // input_sector(sizeIcon, border),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        // height: 27,
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.07,
                                        // margin: EdgeInsets.zero,
                                        padding: EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: DropdownButton<String>(
                                          isExpanded: true,
                                          // hint: Text(
                                          //   "เลือกอำเภอ",
                                          //   style: TextStyle(fontFamily: 'Prompt', color: Colors.grey),
                                          // ),
                                          value: dropdownValuesector,
                                          elevation: 16,
                                          style: TextStyle(
                                              fontFamily: 'Prompt',
                                              fontSize: 14,
                                              color: Colors.black),
                                          underline: SizedBox(),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              dropdownValuesector = newValue!;
                                            });
                                          },
                                          items: <String>[
                                            'ภาคเหนือ',
                                            'ภาคกลาง',
                                            'ภาคอีสาน',
                                            'ภาคใต้ '
                                          ].map<DropdownMenuItem<String>>(
                                              (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('จังหวัด'),
                                  // input_provinceDia(sizeIcon, border),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        // height: 27,
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.07,
                                        // margin: EdgeInsets.zero,
                                        padding: EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: DropdownButton<String>(
                                          isExpanded: true,
                                          // hint: Text(
                                          //   "เลือกอำเภอ",
                                          //   style: TextStyle(fontFamily: 'Prompt', color: Colors.grey),
                                          // ),
                                          value: dropdownValueprovince,
                                          elevation: 16,
                                          style: TextStyle(
                                              fontFamily: 'Prompt',
                                              fontSize: 14,
                                              color: Colors.black),
                                          underline: SizedBox(),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              dropdownValueprovince = newValue!;
                                            });
                                          },
                                          items: <String>[
                                            'เชียงราย',
                                            'เชียงใหม่',
                                            'พะเยา',
                                            'ลำปาง'
                                          ].map<DropdownMenuItem<String>>(
                                              (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('​อำเภอ'),
                                  // input_amphoeDia(sizeIcon, border),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.07,
                                        padding: EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: DropdownButton<String>(
                                          isExpanded: true,
                                          // hint: Text(
                                          //   "เลือกอำเภอ",
                                          //   style: TextStyle(fontFamily: 'Prompt', color: Colors.grey),
                                          // ),
                                          value: dropdownValueamphoe,
                                          elevation: 16,
                                          style: TextStyle(
                                              fontFamily: 'Prompt',
                                              fontSize: 14,
                                              color: Colors.black),
                                          underline: SizedBox(),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              dropdownValueamphoe = newValue!;
                                            });
                                          },
                                          items: <String>[
                                            'เมืองเชียงราย',
                                            'แม่จัน',
                                            'แม่สาย',
                                            'พาน'
                                          ].map<DropdownMenuItem<String>>(
                                              (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  ),
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
                                      padding: const EdgeInsets.all(0),
                                      primary: Colors.white,
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
                                              Text('จังหวัด : เชียงราย'),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text('อำเภอ : เมืองเชียงราย'),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text('ตำบล : รอบเวียง'),
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
                                      padding: const EdgeInsets.all(0),
                                      primary: Colors.white,
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
                      Text('เลขบัตรประชาชน'),
                      input_idcard(sizeIcon, border),
                    ],
                  ),
                  Row(
                    children: [
                      Text('ชื่อ'),
                      input_name(sizeIcon, border),
                      Text('นามสกุล'),
                      input_lastname(sizeIcon, border),
                    ],
                  ),
                  if (filter == true) ...[
                    Row(
                      children: [
                        Text('เบอร์โทร'),
                        input_tel(sizeIcon, border),
                        Text('ค้นหาจาก'),
                        input_search(sizeIcon, border),
                      ],
                    ),
                    line(),
                    Row(
                      children: [
                        Text('บ้านเลขที่'),
                        input_numberhome(sizeIcon, border),
                        Text('หมู่'),
                        input_moo(sizeIcon, border),
                      ],
                    ),
                    Row(
                      children: [
                        Text('ตำบล'),
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
                        Text('อำเภอ'),
                        input_amphoe(sizeIcon, border),
                      ],
                    ),
                    Row(
                      children: [
                        Text('จังหวัด'),
                        input_province(sizeIcon, border),
                      ],
                    ),
                    line(),
                    Row(
                      children: [
                        Text('สาขา'),
                        input_branch(sizeIcon, border),
                      ],
                    ),
                    Row(
                      children: [
                        Text('เลขที่สัญญา'),
                        input_contractNumber(sizeIcon, border),
                      ],
                    ),
                    Row(
                      children: [
                        Text('ประเภทลูกหนี้ '),
                        input_receivableType(sizeIcon, border),
                      ],
                    ),
                    Row(
                      children: [
                        Text('สถานะสัญญา'),
                        input_contractStatus(sizeIcon, border),
                      ],
                    ),
                    Row(
                      children: [
                        Text('ประเภทสัญญา'),
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
                Text('รายการที่ค้นหา'),
              ],
            ),
          ),
          SizedBox(height: 10),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, MyContant.routeDataSearchDebtor);
            },
            child: Container(
              height: MediaQuery.of(context).size.height * 0.6,
              child: Scrollbar(
                child: ListView(
                  children: [
                    for (var i = 0; i <= 10; i++) ...[
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          color: Color.fromRGBO(255, 218, 249, 1),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text('รหัสเขต : การเงิน'),
                              ],
                            ),
                            Row(
                              children: [
                                Text('เลขที่สัญญา : H0101011140621990'),
                              ],
                            ),
                            Row(
                              children: [
                                Text('ชื่อลูกค้าในสัญญา : นางสนธยา จับใจนาย'),
                              ],
                            ),
                            Row(
                              children: [
                                Text('ชื่อลูกค้าปัจจุบัน : นางสนธยา จับใจนาย'),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                    'ชื่อสินค้า : รถจักรยาน LA Bicycle 24 นิ้ว ALFA 6SP'),
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
          )
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
                        Text('ค้นหาแบบละเอียด'),
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
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Color.fromRGBO(76, 83, 146, 1),
                      ),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(0),
                          primary: Colors.white,
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                        onPressed: () {},
                        child: const Text('ค้นหา'),
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Color.fromRGBO(248, 40, 78, 1),
                      ),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(0),
                          primary: Colors.white,
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                        onPressed: () {},
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

  Expanded input_search(sizeIcon, border) {
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
          child: DropdownButton<String>(
            isExpanded: true,
            hint: Text(
              "เลือกอำเภอ",
              style: TextStyle(fontFamily: 'Prompt', color: Colors.grey),
            ),
            value: dropdownValue,
            elevation: 16,
            style: TextStyle(
                fontFamily: 'Prompt', fontSize: 14, color: Colors.black),
            underline: SizedBox(),
            onChanged: (String? newValue) {
              setState(() {
                dropdownValue = newValue!;
              });
            },
            items: <String>['One', 'Two', 'Free', 'Four']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
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

  Expanded input_branch(sizeIcon, border) {
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
          child: DropdownButton<String>(
            isExpanded: true,
            hint: Text(
              "เลือกอำเภอ",
              style: TextStyle(fontFamily: 'Prompt', color: Colors.grey),
            ),
            value: dropdownValue1,
            elevation: 16,
            style: TextStyle(
                fontFamily: 'Prompt', fontSize: 14, color: Colors.black),
            underline: SizedBox(),
            onChanged: (String? newValue) {
              setState(() {
                dropdownValue1 = newValue!;
              });
            },
            items: <String>[
              'แม่สาย',
              'สำนักงานใหญ่',
              'เชียงรายมอลล์ ',
              'แม่จัน'
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
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

  Expanded input_receivableType(sizeIcon, border) {
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
          child: DropdownButton<String>(
            isExpanded: true,
            hint: Text(
              "เลือกอำเภอ",
              style: TextStyle(fontFamily: 'Prompt', color: Colors.grey),
            ),
            value: dropdownValue2,
            elevation: 16,
            style: TextStyle(
                fontFamily: 'Prompt', fontSize: 14, color: Colors.black),
            underline: SizedBox(),
            onChanged: (String? newValue) {
              setState(() {
                dropdownValue2 = newValue!;
              });
            },
            items: <String>['text', 'Two', 'Free', 'Four']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Expanded input_contractStatus(sizeIcon, border) {
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
          child: DropdownButton<String>(
            isExpanded: true,
            hint: Text(
              "เลือกอำเภอ",
              style: TextStyle(fontFamily: 'Prompt', color: Colors.grey),
            ),
            value: dropdownValue3,
            elevation: 16,
            style: TextStyle(
                fontFamily: 'Prompt', fontSize: 14, color: Colors.black),
            underline: SizedBox(),
            onChanged: (String? newValue) {
              setState(() {
                dropdownValue3 = newValue!;
              });
            },
            items: <String>['tttt', 'Two', 'Free', 'Four']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
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

  Expanded input_sector(sizeIcon, border) {
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
          child: DropdownButton<String>(
            isExpanded: true,
            // hint: Text(
            //   "เลือกอำเภอ",
            //   style: TextStyle(fontFamily: 'Prompt', color: Colors.grey),
            // ),
            value: dropdownValuesector,
            elevation: 16,
            style: TextStyle(
                fontFamily: 'Prompt', fontSize: 14, color: Colors.black),
            underline: SizedBox(),
            onChanged: (String? newValue) {
              setState(() {
                dropdownValuesector = newValue!;
              });
            },
            items: <String>['ภาคเหนือ', 'ภาคกลาง', 'ภาคอีสาน', 'ภาคใต้']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Expanded input_provinceDia(sizeIcon, border) {
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
          child: DropdownButton<String>(
            isExpanded: true,
            // hint: Text(
            //   "เลือกอำเภอ",
            //   style: TextStyle(fontFamily: 'Prompt', color: Colors.grey),
            // ),
            value: dropdownValueprovince,
            elevation: 16,
            style: TextStyle(
                fontFamily: 'Prompt', fontSize: 14, color: Colors.black),
            underline: SizedBox(),
            onChanged: (String? newValue) {
              setState(() {
                dropdownValueprovince = newValue!;
              });
            },
            items: <String>['เชียงราย', 'เชียงใหม่', 'พะเยา', 'ลำปาง']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Expanded input_amphoeDia(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: MediaQuery.of(context).size.width * 0.07,
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: DropdownButton<String>(
            isExpanded: true,
            // hint: Text(
            //   "เลือกอำเภอ",
            //   style: TextStyle(fontFamily: 'Prompt', color: Colors.grey),
            // ),
            value: dropdownValueamphoe,
            elevation: 16,
            style: TextStyle(
                fontFamily: 'Prompt', fontSize: 14, color: Colors.black),
            underline: SizedBox(),
            onChanged: (String? newValue) {
              setState(() {
                dropdownValueamphoe = newValue!;
              });
            },
            items: <String>['เมืองเชียงราย', 'แม่จัน', 'แม่สาย', 'พาน']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
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
