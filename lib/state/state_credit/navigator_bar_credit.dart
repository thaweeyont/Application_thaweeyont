import 'dart:convert';

import 'package:application_thaweeyont/api.dart';
import 'package:application_thaweeyont/state/about.dart';
import 'package:application_thaweeyont/state/state_credit/check_blacklist/check_blacklist_data.dart';
import 'package:application_thaweeyont/state/state_credit/credit_approval/page_credit_approval.dart';
import 'package:application_thaweeyont/state/state_credit/home.dart';
import 'package:application_thaweeyont/state/state_credit/query_debtor.dart';
import 'package:application_thaweeyont/state/state_credit/status_member/page_status_member.dart';
import 'package:application_thaweeyont/utility/my_constant.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../authen.dart';
import 'check_purchase_info/page_checkpurchase_info.dart';
import 'package:application_thaweeyont/widgets/show_version.dart';

// import 'package:custom_navigator/custom_navigator.dart';

class Navigator_bar_credit extends StatefulWidget {
  String? index;
  Navigator_bar_credit(this.index);

  @override
  _Navigator_bar_creditState createState() => _Navigator_bar_creditState();
}

class _Navigator_bar_creditState extends State<Navigator_bar_credit> {
  String userId = '', empId = '', firstName = '', lastName = '', tokenId = '';
  var status = false;

  Future<void> logout_system() async {
    try {
      print(tokenId);
      var respose = await http.post(
        Uri.parse('${api}authen/logout'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId,
        },
      );

      if (respose.statusCode == 200) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.clear();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => Authen(),
          ),
          (Route<dynamic> route) => false,
        );
      } else {
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
      print("ไม่มีข้อมูล $e");
    }
  }

  void check_index() {
    var index_page = widget.index;
    status = true;
    switch (index_page) {
      case "0":
        setState(() {
          _selectedIndex = 0;
          title_head = "สอบถามรายละเอียดลูกหนี้";
          status = false;
        });
        break;
      case "1":
        setState(() {
          _selectedIndex = 1;
          title_head = "ตรวจสอบข้อมูลการซื้อสินค้า";
          status = false;
        });
        break;
      case "2":
        setState(() {
          _selectedIndex = 2;
          // title_head = "ทวียนต์ ";
          status = true;
        });
        break;
      case "3":
        setState(() {
          _selectedIndex = 3;
          title_head = "เช็คผลการพิจารณาสินเชื่อ";
          status = false;
        });
        break;
      case "4":
        setState(() {
          _selectedIndex = 4;
          title_head = "สถานะสมาชิกทวียนต์";
          status = false;
        });
        break;
      case "5":
        setState(() {
          _selectedIndex = 5;
          title_head = "สอบถามรายละเอียด BlackList";
          status = false;
        });
        break;
      default:
        {
          setState(() {
            _selectedIndex = 0;
            // title_head = "ทวียนต์ ";
            status = true;
          });
        }
        break;
    }
  }

  Future<Null> getprofile_user() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      userId = preferences.getString('userId')!;
      empId = preferences.getString('empId')!;
      firstName = preferences.getString('firstName')!;
      lastName = preferences.getString('lastName')!;
      tokenId = preferences.getString('tokenId')!;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    check_index();
    getprofile_user();
  }

  int _selectedIndex = 0;
  String title_head = "";

  static const TextStyle optionStyle =
      TextStyle(fontSize: 25, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = <Widget>[
    Query_debtor(),
    Page_Checkpurchase_info(),
    Home_credit(),
    Page_Credit_Approval(),
    Page_Status_Member(),
    Check_Blacklist_Data(),
  ];

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    double size = MediaQuery.of(context).size.width;
    double size_h = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: Appbar(),
      body: Container(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      drawer: drawer(size, context),
      bottomNavigationBar: bottonNavigator_new(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor:
            _selectedIndex == 2 ? Colors.blue : Color.fromARGB(255, 22, 30, 94),
        child: const Icon(Icons.home),
        onPressed: () {
          setState(() {
            _selectedIndex = 2;
            // title_head = "ทวียนต์ 222";
            status = true;
          });
        },
      ),
      // bottomNavigationBar: BottomAppBar(
      //   color: Color.fromARGB(255, 22, 30, 94),
      //   shape: CircularNotchedRectangle(),
      //   notchMargin: 6.0,
      //   child: new Row(
      //     mainAxisSize: MainAxisSize.max,
      //     mainAxisAlignment: MainAxisAlignment.spaceAround,
      //     children: <Widget>[
      //       IconButton(
      //         icon: Icon(Icons.view_list_rounded),
      //         color: Colors.white,
      //         onPressed: showMenu,
      //       ),
      //       IconButton(
      //         icon: Icon(Icons.settings_applications),
      //         color: Colors.white,
      //         onPressed: () {},
      //       )
      //     ],
      //   ),
      // ),

      // floatingActionButtonLocation:
      //     FloatingActionButtonLocation.miniCenterDocked,
      // floatingActionButton: Padding(
      //   padding: const EdgeInsets.all(0),
      //   child: FloatingActionButton(
      //     backgroundColor: _selectedIndex == 2
      //         ? Colors.blue
      //         : Color.fromARGB(255, 22, 30, 94),
      //     child: Icon(Icons.home),
      //     onPressed: () => setState(() {
      //       _selectedIndex = 2;
      //       // title_head = "ทวียนต์ 222";
      //       status = true;
      //     }),
      //   ),
      // ),
    );
  }

  showMenu() {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        builder: (context) {
          return SizedBox(
            height: (54 * 6).toDouble(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(height: 15),
                ListTile(
                  title: Text(
                    "สอบถามรายละเอียดลูกหนี้",
                    style: _selectedIndex == 0
                        ? MyContant().h1MenuStyle_click()
                        : MyContant().h2Style(),
                  ),
                  leading: Icon(
                    Icons.people,
                    color: _selectedIndex == 0 ? Colors.blue : Colors.grey[700],
                  ),
                  onTap: () {
                    setState(() {
                      _selectedIndex = 0;
                      title_head = "สอบถามรายละเอียดลูกหนี้";
                      status = false;
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text(
                    "ตรวจสอบข้อมูลการซื้อสินค้า",
                    style: _selectedIndex == 1
                        ? MyContant().h1MenuStyle_click()
                        : MyContant().h2Style(),
                  ),
                  leading: Icon(
                    Icons.local_mall_rounded,
                    color: _selectedIndex == 1 ? Colors.blue : Colors.grey[700],
                  ),
                  onTap: () {
                    setState(() {
                      _selectedIndex = 1;
                      title_head = "ตรวจสอบข้อมูลการซื้อสินค้า";
                      status = false;
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text(
                    "เช็คผลการพิจารณาสินเชื่อ",
                    style: _selectedIndex == 3
                        ? MyContant().h1MenuStyle_click()
                        : MyContant().h2Style(),
                  ),
                  leading: Icon(
                    Icons.manage_accounts_rounded,
                    color: _selectedIndex == 3 ? Colors.blue : Colors.grey[700],
                  ),
                  onTap: () {
                    setState(() {
                      _selectedIndex = 3;
                      title_head = "เช็คผลการพิจารณาสินเชื่อ";
                      status = false;
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text(
                    "สถานะสมาชิกทวียนต์",
                    style: _selectedIndex == 4
                        ? MyContant().h1MenuStyle_click()
                        : MyContant().h2Style(),
                  ),
                  leading: Icon(
                    Icons.switch_account_outlined,
                    color: _selectedIndex == 4 ? Colors.blue : Colors.grey[700],
                  ),
                  onTap: () {
                    setState(() {
                      _selectedIndex = 4;
                      title_head = "สถานะสมาชิกทวียนต์";
                      status = false;
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text(
                    "สอบถามรายละเอียด BlackList",
                    style: _selectedIndex == 5
                        ? MyContant().h1MenuStyle_click()
                        : MyContant().h2Style(),
                  ),
                  leading: Icon(
                    Icons.person_off_rounded,
                    color: _selectedIndex == 5 ? Colors.blue : Colors.grey[700],
                  ),
                  onTap: () {
                    setState(() {
                      _selectedIndex = 5;
                      title_head = "สอบถามรายละเอียด BlackList";
                      status = false;
                    });
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        });
    // showModalBottomSheet(
    //     context: context,
    //     shape: const RoundedRectangleBorder(
    //       // <-- SEE HERE
    //       borderRadius: BorderRadius.only(
    //         topLeft: Radius.circular(16.0),
    //         topRight: Radius.circular(16.0),
    //       ),
    //     ),
    //     builder: (BuildContext context) {
    //       return Container(
    //         color: Color.fromARGB(255, 22, 30, 94),
    //         // decoration: BoxDecoration(
    //         //   borderRadius: BorderRadius.only(
    //         //     topLeft: Radius.circular(16.0),
    //         //     topRight: Radius.circular(16.0),
    //         //   ),
    //         //   color: Color.fromARGB(255, 22, 30, 94),
    //         // ),
    //         child: Column(
    //           mainAxisSize: MainAxisSize.min,
    //           crossAxisAlignment: CrossAxisAlignment.end,
    //           children: <Widget>[
    //             Container(
    //               height: 20,
    //             ),
    //             SizedBox(
    //               height: (56 * 6).toDouble(),
    //               child: Container(
    //                 child: Stack(
    //                   alignment: Alignment(0, 0),
    //                   children: <Widget>[
    //                     Positioned(
    //                       child: ListView(
    //                         physics: NeverScrollableScrollPhysics(),
    //                         children: <Widget>[
    //                           ListTile(
    //                             title: Text(
    //                               "สอบถามรายละเอียดลูกหนี้",
    //                               style: _selectedIndex == 0
    //                                   ? MyContant().h1MenuStyle_click()
    //                                   : MyContant().h1MenuStyle(),
    //                             ),
    //                             leading: Icon(
    //                               Icons.people,
    //                               color: _selectedIndex == 0
    //                                   ? Colors.blue
    //                                   : Colors.white,
    //                             ),
    //                             onTap: () {
    //                               setState(() {
    //                                 _selectedIndex = 0;
    //                                 title_head = "สอบถามรายละเอียดลูกหนี้";
    //                                 status = false;
    //                               });
    //                               Navigator.pop(context);
    //                             },
    //                           ),
    //                           ListTile(
    //                             title: Text(
    //                               "ตรวจสอบข้อมูลการซื้อสินค้า",
    //                               style: _selectedIndex == 1
    //                                   ? MyContant().h1MenuStyle_click()
    //                                   : MyContant().h1MenuStyle(),
    //                             ),
    //                             leading: Icon(
    //                               Icons.local_mall_rounded,
    //                               color: _selectedIndex == 1
    //                                   ? Colors.blue
    //                                   : Colors.white,
    //                             ),
    //                             onTap: () {
    //                               setState(() {
    //                                 _selectedIndex = 1;
    //                                 title_head = "ตรวจสอบข้อมูลการซื้อสินค้า";
    //                                 status = false;
    //                               });
    //                               Navigator.pop(context);
    //                             },
    //                           ),
    //                           ListTile(
    //                             title: Text(
    //                               "เช็คผลการพิจารณาสินเชื่อ",
    //                               style: _selectedIndex == 3
    //                                   ? MyContant().h1MenuStyle_click()
    //                                   : MyContant().h1MenuStyle(),
    //                             ),
    //                             leading: Icon(
    //                               Icons.manage_accounts_rounded,
    //                               color: _selectedIndex == 3
    //                                   ? Colors.blue
    //                                   : Colors.white,
    //                             ),
    //                             onTap: () {
    //                               setState(() {
    //                                 _selectedIndex = 3;
    //                                 title_head = "เช็คผลการพิจารณาสินเชื่อ";
    //                                 status = false;
    //                               });
    //                               Navigator.pop(context);
    //                             },
    //                           ),
    //                           ListTile(
    //                             title: Text(
    //                               "สถานะสมาชิกทวียนต์",
    //                               style: _selectedIndex == 4
    //                                   ? MyContant().h1MenuStyle_click()
    //                                   : MyContant().h1MenuStyle(),
    //                             ),
    //                             leading: Icon(
    //                               Icons.switch_account_outlined,
    //                               color: _selectedIndex == 4
    //                                   ? Colors.blue
    //                                   : Colors.white,
    //                             ),
    //                             onTap: () {
    //                               setState(() {
    //                                 _selectedIndex = 4;
    //                                 title_head = "สถานะสมาชิกทวียนต์";
    //                                 status = false;
    //                               });
    //                               Navigator.pop(context);
    //                             },
    //                           ),
    //                           ListTile(
    //                             title: Text(
    //                               "สอบถามรายละเอียด BlackList",
    //                               style: _selectedIndex == 5
    //                                   ? MyContant().h1MenuStyle_click()
    //                                   : MyContant().h1MenuStyle(),
    //                             ),
    //                             leading: Icon(
    //                               Icons.person_off_rounded,
    //                               color: _selectedIndex == 5
    //                                   ? Colors.blue
    //                                   : Colors.white,
    //                             ),
    //                             onTap: () {
    //                               setState(() {
    //                                 _selectedIndex = 5;
    //                                 title_head = "สอบถามรายละเอียด BlackList";
    //                                 status = false;
    //                               });
    //                               Navigator.pop(context);
    //                             },
    //                           ),
    //                         ],
    //                       ),
    //                     )
    //                   ],
    //                 ),
    //               ),
    //             ),
    //             // Container(
    //             //   height: 56,
    //             //   color: Color.fromARGB(255, 255, 255, 255),
    //             // )
    //           ],
    //         ),
    //       );
    //     });
  }

  showContactsupport() {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        builder: (context) {
          return SizedBox(
            height: (60 * 6).toDouble(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * 0.05,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    gradient: LinearGradient(
                      colors: <Color>[
                        Color.fromRGBO(238, 208, 110, 1),
                        Color.fromRGBO(250, 227, 152, 0.9),
                        Color.fromRGBO(212, 163, 51, 0.8),
                        Color.fromRGBO(250, 227, 152, 0.9),
                        Color.fromRGBO(164, 128, 44, 1),
                      ],
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.help_outline_sharp,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'ช่วยเหลือ',
                            style: MyContant().TextTitleDialog(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              '     ท่านสามารถแจ้งปัญหาหรือความคิดเห็นเกี่ยวกับแอปพลิเคชั่นนี้ หรือสอบถามเกี่ยวกับแอปพลิเคชั่น มาได้ที่แผนกไอทีหรือโปรแกรมเมอร์',
                              overflow: TextOverflow.clip,
                              style: MyContant().h4normalStyle(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'images/thankyou.png',
                            width: 130,
                            height: 130,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
    // showModalBottomSheet(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return Container(
    //         color: Color.fromARGB(255, 255, 255, 255),
    //         child: Column(
    //           mainAxisSize: MainAxisSize.min,
    //           crossAxisAlignment: CrossAxisAlignment.end,
    //           children: <Widget>[
    //             Container(
    //               height: 0,
    //             ),
    //             SizedBox(
    //               height: (60 * 6).toDouble(),
    //               child: Container(
    //                 child: Stack(
    //                   alignment: Alignment(0, 0),
    //                   children: <Widget>[
    //                     Positioned(
    //                       child: ListView(
    //                         physics: NeverScrollableScrollPhysics(),
    //                         children: <Widget>[
    //                           Container(
    //                             height:
    //                                 MediaQuery.of(context).size.height * 0.05,
    //                             decoration: BoxDecoration(
    //                               gradient: LinearGradient(
    //                                 colors: <Color>[
    //                                   Color.fromRGBO(238, 208, 110, 1),
    //                                   Color.fromRGBO(250, 227, 152, 0.9),
    //                                   Color.fromRGBO(212, 163, 51, 0.8),
    //                                   Color.fromRGBO(250, 227, 152, 0.9),
    //                                   Color.fromRGBO(164, 128, 44, 1),
    //                                 ],
    //                               ),
    //                             ),
    //                             child: Column(
    //                               mainAxisAlignment: MainAxisAlignment.center,
    //                               children: [
    //                                 Row(
    //                                   mainAxisAlignment:
    //                                       MainAxisAlignment.center,
    //                                   children: [
    //                                     Icon(
    //                                       Icons.help_outline_sharp,
    //                                     ),
    //                                     SizedBox(
    //                                       width: 5,
    //                                     ),
    //                                     Text(
    //                                       'ช่วยเหลือ',
    //                                       style: MyContant().TextTitleDialog(),
    //                                     ),
    //                                   ],
    //                                 ),
    //                               ],
    //                             ),
    //                           ),
    //                           Container(
    //                             child: Column(
    //                               children: [
    //                                 Padding(
    //                                   padding: const EdgeInsets.all(16),
    //                                   child: Row(
    //                                     mainAxisAlignment:
    //                                         MainAxisAlignment.center,
    //                                     children: [
    //                                       Expanded(
    //                                         child: Text(
    //                                           '     ท่านสามารถแจ้งปัญหาหรือความคิดเห็นเกี่ยวกับแอปพลิเคชั่นนี้ หรือสอบถามเกี่ยวกับแอปพลิเคชั่น มาได้ที่แผนกไอทีหรือโปรแกรมเมอร์',
    //                                           overflow: TextOverflow.clip,
    //                                           style:
    //                                               MyContant().h4normalStyle(),
    //                                         ),
    //                                       ),
    //                                     ],
    //                                   ),
    //                                 ),
    //                               ],
    //                             ),
    //                           ),
    //                           Container(
    //                             child: Column(
    //                               children: [
    //                                 Padding(
    //                                   padding: const EdgeInsets.all(16),
    //                                   child: Row(
    //                                     mainAxisAlignment:
    //                                         MainAxisAlignment.center,
    //                                     children: [
    //                                       Image.asset(
    //                                         'images/thankyou.png',
    //                                         width: 130,
    //                                         height: 130,
    //                                       ),
    //                                     ],
    //                                   ),
    //                                 ),
    //                               ],
    //                             ),
    //                           ),
    //                         ],
    //                       ),
    //                     )
    //                   ],
    //                 ),
    //               ),
    //             ),
    //             // Container(
    //             //   height: 56,
    //             //   color: Color.fromARGB(255, 202, 107, 107),
    //             // )
    //           ],
    //         ),
    //       );
    //     });
  }

  AppBar Appbar() {
    return AppBar(
      centerTitle: true,
      title: status == true
          ? Image.asset(
              'images/TWYLOGO.png',
              height: 40,
            )
          : Text(
              title_head,
              style: MyContant().TitleStyle(),
            ),
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(
              Icons.menu,
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            // tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          );
        },
      ),
    );
  }

  BottomAppBar bottonNavigator_new() {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      notchMargin: 8.0,
      clipBehavior: Clip.antiAlias,
      child: Container(
        height: kBottomNavigationBarHeight,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(
                color: Colors.grey,
                width: 0.5,
              ),
            ),
          ),
          child: BottomNavigationBar(
            elevation: 15,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            type: BottomNavigationBarType.fixed,
            // currentIndex: _selectedIndex,
            backgroundColor: Color.fromARGB(255, 22, 30, 94),
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white,
            onTap: (index) {
              switch (index) {
                case 0:
                  setState(() {
                    showMenu();
                  });
                  break;
                case 1:
                  setState(() {
                    _selectedIndex = 2;
                    // title_head = "ทวียนต์ ";
                    status = true;
                  });
                  break;
                case 2:
                  setState(() {
                    showContactsupport();
                  });
                  break;
              }
            },
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.view_list_rounded), label: ''),
              BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
              BottomNavigationBarItem(
                  icon: Icon(Icons.help_outline_sharp), label: ''),
            ],
          ),
        ),
      ),
    );
  }

  BottomAppBar bottonNavigator() {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      notchMargin: 8.0,
      clipBehavior: Clip.antiAlias,
      child: Container(
        height: kBottomNavigationBarHeight,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(
                color: Colors.grey,
                width: 0.5,
              ),
            ),
          ),
          child: BottomNavigationBar(
              elevation: 15,
              showSelectedLabels: true,
              showUnselectedLabels: false,
              type: BottomNavigationBarType.fixed,
              currentIndex: _selectedIndex,
              backgroundColor: Color.fromARGB(255, 22, 30, 94),
              selectedItemColor: Colors.blue,
              unselectedItemColor: Colors.white,
              onTap: (index) {
                switch (index) {
                  case 0:
                    setState(() {
                      title_head = "สอบถามรายละเอียดลูกหนี้";
                      status = false;
                    });
                    break;
                  case 1:
                    setState(() {
                      _selectedIndex = 1;
                      title_head = "ตรวจสอบข้อมูลการซื้อสินค้า";
                      status = false;
                    });
                    break;
                  case 2:
                    setState(() {
                      _selectedIndex = 2;
                      // title_head = "ทวียนต์";
                      status = true;
                    });
                    break;
                  case 3:
                    setState(() {
                      _selectedIndex = 3;
                      title_head = "เช็คผลการพิจารณาสินเชื่อ";
                      status = false;
                    });
                    break;
                  case 4:
                    setState(() {
                      _selectedIndex = 4;
                      title_head = "สถานะสมาชิกทวียนต์";
                      status = false;
                    });
                    break;
                  default:
                    {
                      setState(() {
                        _selectedIndex = 0;
                        // title_head = "ทวียนต์";
                        status = true;
                      });
                    }
                    break;
                }
                setState(() {
                  _selectedIndex = index;
                });
              },
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.people), label: ''),
                BottomNavigationBarItem(
                    icon: Icon(Icons.local_mall_rounded), label: ''),
                BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
                BottomNavigationBarItem(
                    icon: Icon(Icons.manage_accounts_rounded), label: ''),
                BottomNavigationBarItem(
                    icon: Icon(Icons.switch_account_outlined), label: ''),
              ]),
        ),
      ),
    );
  }

  Container drawer(double size, BuildContext context) {
    return Container(
      width: size * 0.65,
      child: Drawer(
        child: Container(
          color: Color.fromRGBO(7, 15, 82, 1),
          child: Column(
            children: [
              drawerIcon(size),
              navigator_cradit(context, size),
              about(context, size),
              btn_exit()
            ],
          ),
        ),
      ),
    );
  }

  Expanded btn_exit() {
    return Expanded(
      child: Container(
        child: Align(
          alignment: FractionalOffset.bottomCenter,
          child: InkWell(
            onTap: () async {
              showAlertDialog_exit();
              // logout_system();
            },
            child: Container(
              padding: EdgeInsets.all(16),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Icon(Icons.logout_outlined),
                  SizedBox(width: 5),
                  Text(
                    "ออกจากระบบ",
                    style: TextStyle(
                        color: Colors.red, fontSize: 18, fontFamily: 'Prompt'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container drawerIcon(double size) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 30),
      child: Column(
        children: <Widget>[
          Image.asset(
            'images/logo.png',
            width: size * 0.4,
          ),
          SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.account_box_rounded,
                color: Colors.white,
              ),
              SizedBox(width: 10),
              Text(
                "$firstName $lastName",
                style: TextStyle(
                    color: Colors.white, fontSize: 18, fontFamily: 'Prompt'),
              ),
            ],
          )
        ],
      ),
    );
  }

  DrawerHeader drawerheader(double size) {
    return DrawerHeader(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Image.asset(
            'images/logo.png',
            width: size * 0.2,
          ),
          SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.account_box_rounded,
                color: Colors.white,
              ),
              SizedBox(width: 10),
              Text(
                "$firstName $lastName",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ],
          )
        ],
      ),
    );
  }

  InkWell navigator_cradit(BuildContext context, double size) {
    return InkWell(
      onTap: () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => Navigator_bar_credit('2'),
          ),
          (Route<dynamic> route) => false,
        );
      },
      child: Container(
        margin: EdgeInsets.only(left: size * 0.15, bottom: 15),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), bottomLeft: Radius.circular(30)),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.credit_card_outlined),
                SizedBox(width: 10),
                Text(
                  "สินเชื่อ",
                  style: TextStyle(
                      color: Colors.black, fontSize: 16, fontFamily: 'Prompt'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  InkWell about(BuildContext context, double size) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const About(),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(left: size * 0.15, bottom: 15),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), bottomLeft: Radius.circular(30)),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.info_outline_rounded),
                SizedBox(width: 10),
                Text(
                  "เกี่ยวกับ",
                  style: TextStyle(
                      color: Colors.black, fontSize: 16, fontFamily: 'Prompt'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  showAlertDialog_exit() async {
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!

      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 22, vertical: 5),
          title: Row(
            children: [
              const Text(
                "ออกจากระบบ",
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Prompt',
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Image.asset('images/question.gif',
                  width: 30, height: 30, fit: BoxFit.contain),
            ],
          ),
          content: Text(
            "คุณต้องการออกจากระบบใช่หรือไหม",
            style: TextStyle(fontFamily: 'Prompt', fontSize: 16),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'ยกเลิก',
                style: TextStyle(
                    fontFamily: 'Prompt',
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.normal),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'ตกลง',
                style: TextStyle(
                    fontFamily: 'Prompt',
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.normal),
              ),
              onPressed: () {
                logout_system();
              },
            ),
          ],
        );
      },
    );
  }
}
