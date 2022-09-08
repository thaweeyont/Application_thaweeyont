import 'package:application_thaweeyont/state/state_credit/credit_approval/page_check_blacklist.dart';
import 'package:application_thaweeyont/state/state_credit/credit_approval/page_info_consider_cus.dart';
import 'package:application_thaweeyont/utility/my_constant.dart';
import 'package:flutter/material.dart';

class Page_Credit_Approval extends StatefulWidget {
  const Page_Credit_Approval({super.key});

  @override
  State<Page_Credit_Approval> createState() => _Page_Credit_ApprovalState();
}

class _Page_Credit_ApprovalState extends State<Page_Credit_Approval> {
  String page = 'list_content1';
  bool active_cl1 = true, active_cl2 = false, active_cl3 = false;

  void menu_list(page) {
    setState(() {
      active_cl1 = false;
      active_cl2 = false;
      active_cl3 = false;
    });
    switch (page) {
      case "list_content1":
        setState(() {
          page = "list_content1";
          active_cl1 = true;
        });
        break;
      case "list_content2":
        setState(() {
          page = "list_content2";
          active_cl2 = true;
        });
        break;
    }
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
                        Text('รหัสลูกค้า'),
                        input_idcustomer(sizeIcon, border),
                      ],
                    ),
                    Row(
                      children: [
                        Text('ชื่อลูกค้า'),
                        input_namecustomer(sizeIcon, border),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            group_btnsearch(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DefaultTabController(
                length: 3,
                initialIndex: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(251, 173, 55, 1),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          )),
                      child: TabBar(
                        labelColor: Color.fromRGBO(110, 66, 0, 1),
                        unselectedLabelColor: Colors.black,
                        tabs: [
                          Tab(text: 'ผู้ค้ำที่ 1'),
                          Tab(text: 'ผู้ค้ำที่ 2'),
                          Tab(text: 'ผู้ค้ำที่ 3'),
                        ],
                      ),
                    ),
                    line(),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.17,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(251, 173, 55, 1),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                        // border: Border(
                        //   top: BorderSide(color: Colors.grey, width: 0.5),
                        // ),
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
                                    Text('ชื่อลูกค้า : '),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Text('เกิดวันที่ : '),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Text('อายุ : '),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Text('ชื่อรอง : '),
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
                                    Text('ชื่อลูกค้า : '),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Text('เกิดวันที่ : '),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Text('อายุ : '),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Text('ชื่อรอง : '),
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
                                    Text('ชื่อลูกค้า : '),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Text('เกิดวันที่ : '),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Text('อายุ : '),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Text('ชื่อรอง : '),
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
            ),
            SizedBox(
              height: 10,
            ),
            slidemenu(context),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text('รายการที่ค้นหา'),
                ],
              ),
            ),
            if (active_cl1 == true) ...[
              content_list1(context),
            ],
            if (active_cl2 == true) ...[
              content_list2(context),
            ],
          ],
        ),
      ),
    );
  }

  Container content_list1(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Scrollbar(
        child: ListView(
          children: [
            // if (datauser.isNotEmpty) ...[
            for (var i = 0; i < 5; i++) ...[
              InkWell(
                onTap: () {
                  // var idcard = datauser[i].idcard;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Page_Info_Consider_Cus(),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: Color.fromRGBO(251, 173, 55, 1),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text('วันทำสัญญา : '),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Text('เลขที่สัญญา : '),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Text('ชื่อสินค้า : '),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('รหัสเขต : '),
                            Text('สถานะ : '),
                          ],
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
    );
  }

  Container content_list2(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Scrollbar(
        child: ListView(
          children: [
            // if (datauser.isNotEmpty) ...[
            for (var i = 0; i < 5; i++) ...[
              InkWell(
                onTap: () {
                  // var idcard = datauser[i].idcard;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Page_Info_Consider_Cus(),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: Color.fromRGBO(251, 173, 55, 1),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text('เลขที่สัญญา : '),
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
                            Text('ชื่อ-สกุลในสัญญา : '),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('ยอดคงเหลือ : '),
                            Text('สถานะ : '),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('เขตติดตาม : '),
                            Text('สถานะสัญญา : '),
                          ],
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
                  height: 32,
                  padding: EdgeInsets.all(6.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    color: active_cl1 == true
                        ? Color.fromRGBO(202, 121, 0, 1)
                        : Color.fromRGBO(251, 173, 55, 1),
                  ),
                  child: Text('ตรวจสอบหนี้สิน'),
                ),
              ),
              InkWell(
                onTap: () {
                  menu_list("list_content2");
                },
                child: Container(
                  margin: EdgeInsets.only(top: 2, left: 10),
                  height: 32,
                  padding: EdgeInsets.all(6.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    color: active_cl2 == true
                        ? Color.fromRGBO(202, 121, 0, 1)
                        : Color.fromRGBO(251, 173, 55, 1),
                  ),
                  child: Text('รายละเอียดผู้ค้ำ'),
                ),
              ),
              InkWell(
                onTap: () {
                  // Navigator.pushNamed(
                  //     context, MyContant.routePageCheckBlacklist);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Page_Check_Blacklist(),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(top: 2, left: 10),
                  height: 32,
                  padding: EdgeInsets.all(6.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    color: Color.fromRGBO(251, 173, 55, 1),
                    // color: active_cl3 == true
                    //     ? Color.fromRGBO(202, 121, 0, 1)
                    //     : Color.fromRGBO(251, 173, 55, 1),
                  ),
                  child: Text('เช็ค Blacklist'),
                ),
              ),
            ],
          )
        ],
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
                        borderRadius: BorderRadius.all(Radius.circular(10)),
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
                    SizedBox(width: 10),
                    Container(
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Color.fromRGBO(248, 40, 78, 1),
                      ),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.all(0),
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

  SizedBox line() {
    return SizedBox(
      height: 0,
      width: double.infinity,
      child: Divider(
        color: Color.fromARGB(255, 34, 34, 34),
      ),
    );
  }

  Expanded input_idcustomer(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          keyboardType: TextInputType.number,
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

  Expanded input_namecustomer(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          keyboardType: TextInputType.number,
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
}
