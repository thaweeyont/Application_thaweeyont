import 'dart:math';

import 'package:application_thaweeyont/utility/my_constant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../model/login_model.dart';

class Data_SearchDebtor extends StatefulWidget {
  final String? idcard;
  Data_SearchDebtor(this.idcard);

  @override
  State<Data_SearchDebtor> createState() => _Data_SearchDebtorState();
}

class _Data_SearchDebtorState extends State<Data_SearchDebtor> {
  String page = "list_content1";
  bool active_l1 = true,
      active_l2 = false,
      active_l3 = false,
      active_l4 = false;
  List<Login> data_searchUser = [];

  Future<void> get_datauser_search() async {
    try {
      var respose = await http.get(
        Uri.http('110.164.131.46', '/flutter_api/api_user/login_user.php',
            {"id_card": widget.idcard.toString()}),
      );
      // print(respose.body);
      if (respose.statusCode == 200) {
        setState(() {
          data_searchUser = loginFromJson(respose.body);
        });
        print(respose.body);
        // if (datauser[0].idcard!.isNotEmpty) {
        //   setpreferences();
        // }
      }
    } catch (e) {
      print("ไม่มีข้อมูล");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_datauser_search();
  }

  void menu_list(page) {
    setState(() {
      active_l1 = false;
      active_l2 = false;
      active_l3 = false;
      active_l4 = false;
    });
    switch (page) {
      case "list_content1":
        setState(() {
          page = "list_content1";
          active_l1 = true;
        });
        break;
      case "list_content2":
        setState(() {
          page = "list_content2";
          active_l2 = true;
        });
        break;
      case "list_content3":
        setState(() {
          page = "list_content3";
          active_l3 = true;
        });
        break;
      case "list_content4":
        setState(() {
          page = "list_content4";
          active_l4 = true;
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('ค้นหาข้อมูล'),
      ),
      body: data_searchUser.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Stack(children: [
              if (active_l1 == true) ...[
                content_list_1(context),
              ],
              if (active_l2 == true) ...[
                content_list_2(context),
              ],
              if (active_l3 == true) ...[
                content_list_3(context),
              ],
              if (active_l4 == true) ...[
                content_list_4(context),
              ],
              slidemenu(context),
            ]),
    );
  }

  Container slidemenu(BuildContext context) {
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height * 0.05,
      // margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(3),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  menu_list("list_content1");
                },
                child: Container(
                  margin: EdgeInsets.only(top: 2, left: 10),
                  height: 30,
                  padding: EdgeInsets.all(2.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Color.fromRGBO(255, 218, 249, 1),
                    border: active_l1 == true
                        ? Border.all(
                            color: Color.fromRGBO(202, 71, 150, 1), width: 2)
                        : Border.all(color: Colors.transparent),
                    // color: active_l1 == true
                    //     ? Color.fromRGBO(202, 71, 150, 1)
                    //     : Color.fromRGBO(255, 218, 249, 1),
                  ),
                  child: Text('รายการสินค้า'),
                ),
              ),
              InkWell(
                onTap: () {
                  menu_list("list_content2");
                },
                child: Container(
                  margin: EdgeInsets.only(top: 2, left: 10),
                  height: 30,
                  padding: EdgeInsets.all(2.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Color.fromRGBO(255, 218, 249, 1),
                    border: active_l2 == true
                        ? Border.all(
                            color: Color.fromRGBO(202, 71, 150, 1), width: 2)
                        : Border.all(color: Colors.transparent),
                  ),
                  child: Text('หมายเหตุพิจารณาสินเชื่อ'),
                ),
              ),
              InkWell(
                onTap: () {
                  menu_list("list_content3");
                },
                child: Container(
                  margin: EdgeInsets.only(top: 2, left: 10),
                  height: 30,
                  padding: EdgeInsets.all(2.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Color.fromRGBO(255, 218, 249, 1),
                    border: active_l3 == true
                        ? Border.all(
                            color: Color.fromRGBO(202, 71, 150, 1), width: 2)
                        : Border.all(color: Colors.transparent),
                  ),
                  child: Text('บันทึกหมายเหตุ'),
                ),
              ),
              InkWell(
                onTap: () {
                  menu_list("list_content4");
                },
                child: Container(
                  margin: EdgeInsets.only(top: 2, left: 10, right: 10),
                  height: 30,
                  padding: EdgeInsets.all(2.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Color.fromRGBO(255, 218, 249, 1),
                    border: active_l4 == true
                        ? Border.all(
                            color: Color.fromRGBO(202, 71, 150, 1), width: 2)
                        : Border.all(color: Colors.transparent),
                  ),
                  child: Text('ชำระค่างวด'),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  SingleChildScrollView content_list_1(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8.0),
            color: Color.fromRGBO(255, 218, 249, 1),
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.06,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('เลขที่สัญญา : ${data_searchUser[0].id}'),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Text('เลขบัตรประชาชน : ${widget.idcard}'),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Text('ชื่อ-สกุล : ${data_searchUser[0].fullname}'),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ที่อยู่ : '),
                    Expanded(
                      child: Text(
                        '${data_searchUser[0].addressUser} ต.${data_searchUser[0].provincesU} อ.${data_searchUser[0].amphuresU} จ.${data_searchUser[0].districtsU}',
                        overflow: TextOverflow.clip,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('สถานที่ทำงาน : '),
                    Expanded(
                      child: Text('${data_searchUser[0].phoneUser}',
                          overflow: TextOverflow.clip),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Text('อาชีพ : ${data_searchUser[0].statusMember}'),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Text('สถานที่ใกล้เคียง : '),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          DefaultTabController(
            length: 3,
            initialIndex: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  color: Color.fromRGBO(255, 218, 249, 1),
                  child: TabBar(
                    labelColor: Color.fromRGBO(202, 71, 150, 1),
                    unselectedLabelColor: Colors.black,
                    tabs: [
                      Tab(text: 'ผู้ค้ำที่ 1'),
                      Tab(text: 'ผู้ค้ำที่ 2'),
                      Tab(text: 'ผู้ค้ำที่ 3'),
                    ],
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 218, 249, 1),
                    border:
                        Border(top: BorderSide(color: Colors.grey, width: 0.5)),
                  ),
                  child: TabBarView(children: <Widget>[
                    //ผู้ค้ำที1
                    SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text('เลขบัตรประชาชน : '),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text('ชื่อ-สกุล : '),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text('ที่อยู่ : '),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text('สถานที่ทำงาน : '),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text('อาชีพ : '),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text('สถานที่ใกล้เคียง : '),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    //ผู้ค้ำที่2
                    SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text('เลขบัตรประชาชน : '),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text('ชื่อ-สกุล : '),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text('ที่อยู่ : '),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text('สถานที่ทำงาน : '),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text('อาชีพ : '),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text('สถานที่ใกล้เคียง : '),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    //ผู้ค้ำที่3
                    SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text('เลขบัตรประชาชน : '),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text('ชื่อ-สกุล : '),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text('ที่อยู่ : '),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text('สถานที่ทำงาน : '),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text('อาชีพ : '),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text('สถานที่ใกล้เคียง : '),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            color: Color.fromRGBO(255, 218, 249, 1),
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                    // height: MediaQuery.of(context).size.height * 0.06,
                    ),
                Row(
                  children: [
                    Text('วันที่ทำสัญญา : 22/04/53'),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Text('ราคาเช่าซื้อ : 19,500.00 บาท ดอกเบี้ย 0.81 %'),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Text('กำหนดงวด : 18 งวด'),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'พนักงานขาย : โสภิณ ปินใจ',
                        overflow: TextOverflow.clip,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text('ผู้ตรวจสอบเครดิต : อัฒพงษ์ ใจเผิน',
                          overflow: TextOverflow.clip),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Text('ผู้อนุมัติสินเชื่อ : อัฒพงษ์ ใจเผิน'),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            color: Color.fromRGBO(255, 218, 249, 1),
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                    // height: MediaQuery.of(context).size.height * 0.06,
                    ),
                Row(
                  children: [
                    Text(
                      'รายการสินค้า (หมายเหตุ สินค้าปกติ สินค้าเปลี่ยน สินค้ารับคืน)',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('รายการ : '),
                    Expanded(
                      child: Text(
                        'เครื่องปรับอากาศ มิตซูบิชิ MS-SGE13VC/MU-SGE13VC',
                        overflow: TextOverflow.clip,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Text('ยี่ห้อ : MITSUBISHI'),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Text('ขนาด : -'),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Text('รุ่น/แบบ : MS-SGE13VC/MU-SGE13VC'),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('หมายเลขเครื่อง : '),
                    Expanded(
                      child: Text(
                        'L20T90SS0000635T/L20T9B6S0000106T',
                        overflow: TextOverflow.clip,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Text('จำนวน : 1'),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'หมายเหตุการขาย : หักเงินเดือนพนักงาน เริ่ม 20/05/53 = 1,075.-/ด. พนักงานคิด 0.8% * 18 = 1,075.- ราคาขายพร้อมติดตั้ง ฟรีท่อน้ำยา 4 เมตร สายไฟไม่เกิน 15 เมตร ไม่รวมขาแขวน',
                              overflow: TextOverflow.clip,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  SingleChildScrollView content_list_2(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 330,
            padding: EdgeInsets.all(8.0),
            color: Color.fromRGBO(255, 218, 249, 1),
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.06,
                ),
                Row(
                  children: [
                    Text('หมายเหตุพนักงานสินเชื่อ'),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [Text('')],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text('หมายเหตุหัวหน้าสินเชื่อ'),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [Text('')],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  SingleChildScrollView content_list_3(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            // height: 600,
            padding: EdgeInsets.all(8.0),
            color: Color.fromRGBO(255, 218, 249, 1),
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.06,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('เชคเกอร์ '),
                    Text('วันที่ : 28/10/62 15:45:59 '),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  padding: EdgeInsets.all(8.0),
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [Text('')],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('การเงิน'),
                    Text('วันที่ : '),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  padding: EdgeInsets.all(8.0),
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [Text('ทดสอบตัวหนังสือ')],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('ติดตามหนี้ '),
                    Text('วันที่ : '),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  padding: EdgeInsets.all(8.0),
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [Text('')],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('กฎหมาย'),
                    Text('วันที่ : '),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  padding: EdgeInsets.all(8.0),
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [Text('')],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('ทะเบียน'),
                    Text('วันที่ : '),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  padding: EdgeInsets.all(8.0),
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [Text('ทดสอบตัวหนังสือ')],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('บริการ'),
                    Text('วันที่ : '),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  padding: EdgeInsets.all(8.0),
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [Text('')],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  SingleChildScrollView content_list_4(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.06,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text('รายการชำระค่างวด'),
              ],
            ),
          ),
          for (var i = 0; i <= 10; i++) ...[
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, MyContant.routePayInstallment);
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                // height: 330,
                padding: EdgeInsets.all(8.0),
                color: Color.fromRGBO(255, 218, 249, 1),
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('งวดที่ : ${i + 1}'),
                        Text('วันที่ชำระ : 20/07/62'),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Text('เลขที่ใบเสร็จ : R301190778395'),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('เงินต้น : 1,065.00'),
                        Text('คงเหลือ : '),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('ค่าปรับ : '),
                        Text('วันที่ชำระ : 20/07/62'),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('ชำระเงินต้น : 1,065.00'),
                        Text('ชำระค่าปรับ : '),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
