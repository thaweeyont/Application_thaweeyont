import 'dart:convert';
import 'dart:io';

import 'package:application_thaweeyont/api.dart';
import 'package:application_thaweeyont/state/about.dart';
import 'package:application_thaweeyont/state/state_credit/check_blacklist/check_blacklist_data.dart';
import 'package:application_thaweeyont/state/state_mechanical/mechanical.dart';
import 'package:application_thaweeyont/state/state_sale/credit_approval/page_credit_approval.dart';
import 'package:application_thaweeyont/state/home.dart';
import 'package:application_thaweeyont/state/state_credit/query_debtor/query_debtor.dart';
import 'package:application_thaweeyont/state/state_cus_relations/status_member/page_status_member.dart';
import 'package:application_thaweeyont/state/state_cus_relations/product_stock/product_stock_data.dart';
import 'package:application_thaweeyont/utility/my_constant.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'authen.dart';
import 'state_cus_relations/check_purchase_info/page_checkpurchase_info.dart';

class Navigator_bar_credit extends StatefulWidget {
  String? index;
  Navigator_bar_credit(this.index, {super.key});

  @override
  _Navigator_bar_creditState createState() => _Navigator_bar_creditState();
}

class _Navigator_bar_creditState extends State<Navigator_bar_credit> {
  String userId = '',
      empId = '',
      firstName = '',
      lastName = '',
      tokenId = '',
      branchName = '';
  bool? allowApproveStatus, allowedTest;
  List<String>? allowedMenu;
  List<Map<String, String>> result = [];

  var status = false;

  @override
  void initState() {
    super.initState();
    getprofileUser();
  }

  Future<void> getprofileUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      userId = preferences.getString('userId')!;
      empId = preferences.getString('empId')!;
      firstName = preferences.getString('firstName')!;
      lastName = preferences.getString('lastName')!;
      tokenId = preferences.getString('tokenId')!;
      branchName = preferences.getString('branchName')!;
      allowApproveStatus = preferences.getBool('allowApproveStatus');
      allowedMenu = preferences.getStringList('allowedMenu');
    });
    checkIndex();
    handleMenuItemSelected(allowedMenu!);
  }

  Future<void> logoutSystem() async {
    try {
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
            builder: (context) => const Authen(),
          ),
          (Route<dynamic> route) => false,
        );
      } else {
        Map<String, dynamic> check_list =
            Map<String, dynamic>.from(json.decode(respose.body));

        print(check_list['message']);
        if (check_list['message'] == "Token Unauthorized") {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          preferences.clear();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const Authen(),
            ),
            (Route<dynamic> route) => false,
          );
        }
      }
    } catch (e) {
      print("ไม่มีข้อมูล $e");
    }
  }

  void checkIndex() async {
    var indexPage = widget.index;
    status = true;
    switch (indexPage) {
      case "0":
        setState(() {
          _selectedIndex = 0;
          titleHead = "สอบถามรายละเอียดลูกหนี้";
          status = false;
        });
        break;
      case "1":
        setState(() {
          _selectedIndex = 1;
          titleHead = "ตรวจสอบข้อมูลการซื้อสินค้า";
          status = false;
        });
        break;
      case "2":
        setState(() {
          _selectedIndex = 2;
          status = true;
        });
        break;
      case "3":
        setState(() {
          _selectedIndex = 3;
          if (allowApproveStatus == true) {
            titleHead = "บันทึกพิจารณาอนุมัติสินเชื่อ";
          } else {
            titleHead = "ตรวจสอบผลอนุมัติสินเชื่อ";
          }
          status = false;
        });
        break;
      case "4":
        setState(() {
          _selectedIndex = 4;
          titleHead = "ลูกค้าสัมพันธ์ทวียนต์";
          status = false;
        });
        break;
      case "5":
        setState(() {
          _selectedIndex = 5;
          titleHead = "สอบถามรายละเอียด BlackList";
          status = false;
        });
        break;
      case "6":
        setState(() {
          _selectedIndex = 6;
          titleHead = "สอบถามสินค้าในสต็อค";
          status = false;
        });
        break;
      case "7":
        setState(() {
          _selectedIndex = 7;
          titleHead = "บริการงานส่ง/ติดตั้งสินค้า";
          status = false;
        });
        break;
      default:
        {
          setState(() {
            _selectedIndex = 0;
            status = true;
          });
        }
        break;
    }
  }

  int _selectedIndex = 0;
  String titleHead = "";
  String nameMenu = '';

  static const TextStyle optionStyle =
      TextStyle(fontSize: 25, fontWeight: FontWeight.bold);
  static final List<Widget> _widgetOptions = <Widget>[
    const Query_debtor(),
    const Page_Checkpurchase_info(),
    const Home_credit(),
    const Page_Credit_Approval(),
    const Page_Status_Member(),
    const Check_Blacklist_Data(),
    const ProductStockData(),
    const Mechanical(),
  ];

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    double size = MediaQuery.of(context).size.width;
    double size_h = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: appBar(),
      body: Container(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      drawer: drawerList(size),
      bottomNavigationBar: bottomBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        margin: const EdgeInsets.only(top: 50),
        child: builFab(context),
      ),
    );
  }

  Widget builFab(BuildContext context) {
    if (MediaQuery.of(context).viewInsets.bottom == 0.0) {
      return FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
        onPressed: () {
          setState(() {
            _selectedIndex = 2;
            status = true;
          });
        },
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            width: 4,
            color: Color.fromRGBO(5, 12, 69, 1),
          ),
          borderRadius: BorderRadius.circular(100),
        ),
        child: const Icon(
          Icons.home,
          color: Colors.blue,
        ),
      );
    } else {
      return Container();
    }
  }

  showMenuList() {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        builder: (context) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 15),
              if (result.isNotEmpty)
                for (var i = 0; i < result.length; i++)
                  ListTile(
                    title: Text(
                      "${result[i]['nameMenu']}",
                      style:
                          _selectedIndex == getselectmenuBottom(result[i]['id'])
                              ? MyContant().h1MenuStyle_click()
                              : MyContant().h2Style(),
                    ),
                    leading: Icon(
                      getMenuIcon(result[i]['id']),
                      color:
                          _selectedIndex == getselectmenuBottom(result[i]['id'])
                              ? Colors.blue
                              : Colors.grey[700],
                    ),
                    onTap: () {
                      setState(() {
                        titleHead = getTitlemenuBottom(result[i]['id']);
                        _selectedIndex = getselectmenuBottom(result[i]['id']);
                        status = false;
                      });
                      Navigator.pop(context);
                    },
                  ),
              const SizedBox(height: 30),
            ],
          );
        });
  }

  getselectmenuBottom(id) {
    var selectIndex;
    switch (id) {
      case '001':
        selectIndex = 3;
        break;
      case '002':
        selectIndex = 0;
        break;
      case '003':
        selectIndex = 5;
        break;
      case '004':
        selectIndex = 4;
        break;
      case '005':
        selectIndex = 1;
        break;
      case '006':
        selectIndex = 6;
        break;
      case '007':
        selectIndex = 7;
        break;
    }
    return selectIndex;
  }

  getTitlemenuBottom(id) {
    var title, text;
    if (allowApproveStatus == true) {
      text = 'บันทึกพิจารณาอนุมัติสินเชื่อ';
    } else {
      text = 'ตรวจสอบผลอนุมัติสินเชื่อ';
    }
    switch (id) {
      case '001':
        title = text;
        break;
      case '002':
        title = "สอบถามรายละเอียดลูกหนี้";
        break;
      case '003':
        title = "สอบถามรายละเอียด BlackList";
        break;
      case '004':
        title = "ลูกค้าสัมพันธ์ทวียนต์";
        break;
      case '005':
        title = "ตรวจสอบข้อมูลการซื้อสินค้า";
        break;
      case '006':
        title = "สอบถามสินค้าในสต็อค";
        break;
      case '007':
        title = "บริการงานส่ง/ติดตั้งสินค้า";
        break;
    }
    return title;
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
            height: (55 * 6).toDouble(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * 0.05,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    color: Colors.grey.shade200,
                    // gradient: LinearGradient(
                    //   colors: <Color>[
                    //     Color.fromRGBO(238, 208, 110, 1),
                    //     Color.fromRGBO(250, 227, 152, 0.9),
                    //     Color.fromRGBO(212, 163, 51, 0.8),
                    //     Color.fromRGBO(250, 227, 152, 0.9),
                    //     Color.fromRGBO(164, 128, 44, 1),
                    //   ],
                    // ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.help_outline_sharp,
                          ),
                          const SizedBox(
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
                              '     ท่านสามารถแจ้งปัญหาหรือความคิดเห็นเกี่ยวกับการใช้งานแอปพลิเคชั่น หรือสอบถามเพิ่มเติม มาได้ที่แผนกไอทีหรือโปรแกรมเมอร์',
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
  }

  AppBar appBar() {
    return AppBar(
      centerTitle: true,
      elevation: status == true ? 0 : 4,
      backgroundColor: const Color.fromRGBO(5, 12, 69, 1),
      title: status == true
          ? null
          : Text(
              titleHead,
              style: MyContant().TitleStyle(),
            ),
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(
              color: Colors.white,
              Icons.menu,
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        },
      ),
    );
  }

  Container bottomBar() {
    return Container(
      margin: EdgeInsets.only(
        left: 10,
        right: 10,
        bottom: Platform.isAndroid ? 2 : 0,
      ),
      child: BottomAppBar(
        elevation: 0,
        color: const Color.fromARGB(242, 246, 249, 255),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 59, 59, 59).withOpacity(0.6),
                spreadRadius: 1,
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.055,
              color: const Color.fromRGBO(5, 12, 69, 1),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          showMenuList();
                        });
                      },
                      child: const Icon(
                        Icons.view_list_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          showContactsupport();
                        });
                      },
                      child: const Icon(
                        Icons.help_outline_sharp,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  BottomAppBar bottonNavigatorNew() {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: kBottomNavigationBarHeight,
        child: Container(
          decoration: const BoxDecoration(
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
            backgroundColor: const Color.fromRGBO(5, 12, 69, 1),
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white,
            onTap: (index) {
              switch (index) {
                case 0:
                  setState(() {
                    showMenuList();
                  });
                  break;
                case 1:
                  setState(() {
                    _selectedIndex = 2;
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
            items: const [
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

  SizedBox drawer(double size, BuildContext context) {
    return SizedBox(
      width: size * 0.80,
      child: Drawer(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(40),
          ),
        ),
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(40),
            ),
            color: Color.fromRGBO(7, 15, 82, 1),
          ),
          child: Stack(
            children: [
              closeDrawer(context),
              Column(
                children: [
                  drawerIcon(size),
                  listMenu(context, size),
                  about(context, size),
                  btnExit()
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Drawer drawerList(
    double size,
  ) {
    return Drawer(
      width: size * 1.0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(40),
        ),
      ),
      backgroundColor: const Color.fromRGBO(7, 15, 82, 1),
      child: SingleChildScrollView(
        child: SizedBox(
          child: Stack(
            children: [
              closeDrawer(context),
              Column(
                children: [
                  drawerIcon(size),
                  listMenu(context, size),
                  about(context, size),
                  btnLogout(context, size),
                  const SizedBox(height: 10),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Positioned closeDrawer(BuildContext context) {
    return Positioned(
      top: 50,
      right: 0,
      child: Container(
        width: 50,
        height: 40,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          ),
          color: Colors.white,
        ),
        child: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.black,
          icon: const Icon(
            Icons.close_rounded,
          ),
        ),
      ),
    );
  }

  Expanded btnExit() {
    return Expanded(
      child: Align(
        alignment: FractionalOffset.bottomCenter,
        child: InkWell(
          onTap: () async {
            showAlertDialogExit();
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
    );
  }

  Container drawerIcon(double size) {
    return Container(
      padding: const EdgeInsets.only(top: 70, bottom: 30),
      child: Column(
        children: <Widget>[
          Image.asset(
            'images/logoNew.png',
            width: size * 0.3,
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.account_box_rounded,
                color: Colors.white,
              ),
              const SizedBox(width: 10),
              Text(
                "$firstName $lastName",
                style: const TextStyle(
                    color: Colors.white, fontSize: 18, fontFamily: 'Prompt'),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.location_on_rounded,
                color: Colors.white,
              ),
              const SizedBox(width: 10),
              Text(
                branchName,
                style: const TextStyle(
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
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.account_box_rounded,
                color: Colors.white,
              ),
              const SizedBox(width: 10),
              Text(
                "$firstName $lastName",
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ],
          )
        ],
      ),
    );
  }

  void handleMenuItemSelected(allowedMenu) {
    List<String> listallowedMenu = allowedMenu;
    String textNamemenu;
    if (allowApproveStatus == true) {
      textNamemenu = "บันทึกพิจารณาอนุมัติสินเชื่อ";
    } else {
      textNamemenu = "ตรวจสอบผลอนุมัติสินเชื่อ";
    }

    List<Map<String, String>> menuList = [
      {
        "id": "001",
        "nameMenu": textNamemenu,
      },
      {
        "id": "002",
        "nameMenu": "สอบถามรายละเอียดลูกหนี้",
      },
      {
        "id": "003",
        "nameMenu": "สอบถามรายละเอียด BlackList",
      },
      {
        "id": "004",
        "nameMenu": "ลูกค้าสัมพันธ์ทวียนต์",
      },
      {
        "id": "005",
        "nameMenu": "ตรวจสอบข้อมูลการซื้อสินค้า",
      },
      {
        "id": "006",
        "nameMenu": "สอบถามสินค้าในสต็อค",
      },
      {
        "id": "007",
        "nameMenu": "บริการงานส่ง/ติดตั้งสินค้า",
      },
    ];
    for (var menuItem in menuList) {
      for (var allowedItem in listallowedMenu) {
        if (menuItem['id'] == allowedItem) {
          result.add(menuItem);
        }
      }
    }
  }

  Column listMenu(BuildContext context, double size) {
    return Column(
      children: [
        if (result.isNotEmpty)
          for (var i = 0; i < result.length; i++)
            InkWell(
              onTap: () {
                menuOntap(result[i]['id']);
              },
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: size * 0.10, bottom: 15),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        bottomLeft: Radius.circular(30),
                      ),
                      color: getMenuColor(result[i]['id']),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              getMenuIcon(result[i]['id']),
                              color: Colors.white,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                "${result[i]['nameMenu']}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: 'Prompt',
                                  overflow: TextOverflow.clip,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
      ],
    );
  }

  menuOntap(id) {
    var OnTap;
    switch (id) {
      case '001':
        OnTap = Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => Navigator_bar_credit('3'),
          ),
          (Route<dynamic> route) => false,
        );
        break;
      case '002':
        OnTap = Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => Navigator_bar_credit('0'),
          ),
          (Route<dynamic> route) => false,
        );
        break;
      case '003':
        OnTap = Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => Navigator_bar_credit('5'),
          ),
          (Route<dynamic> route) => false,
        );
        break;
      case '004':
        OnTap = Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => Navigator_bar_credit('4'),
          ),
          (Route<dynamic> route) => false,
        );
        break;
      case '005':
        OnTap = Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => Navigator_bar_credit('1'),
          ),
          (Route<dynamic> route) => false,
        );
        break;
      case '006':
        OnTap = Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => Navigator_bar_credit('6'),
          ),
          (Route<dynamic> route) => false,
        );
        break;
      case '007':
        OnTap = Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => Navigator_bar_credit('7'),
          ),
          (Route<dynamic> route) => false,
        );
        break;
    }
    return OnTap;
  }

  getMenuColor(menuColor) {
    var color;
    switch (menuColor) {
      case '001':
        color = const Color.fromRGBO(251, 713, 55, 1);
        break;
      case '002':
        color = const Color.fromRGBO(255, 152, 238, 1);
        break;
      case '003':
        color = const Color.fromRGBO(162, 181, 252, 1);
        break;
      case '004':
        color = const Color.fromRGBO(64, 203, 203, 1);
        break;
      case '005':
        color = const Color.fromRGBO(212, 151, 233, 1);
        break;
      case '006':
        color = const Color.fromRGBO(176, 218, 255, 1);
        break;
      case '007':
        color = const Color.fromARGB(255, 241, 209, 89);
        break;
    }
    return color;
  }

  getMenuIcon(menuId) {
    var icon;
    switch (menuId) {
      case '001':
        icon = Icons.manage_accounts_rounded;
        break;
      case '002':
        icon = Icons.people;
        break;
      case '003':
        icon = Icons.person_off_rounded;
        break;
      case '004':
        icon = Icons.switch_account_outlined;
        break;
      case '005':
        icon = Icons.local_mall_rounded;
        break;
      case '006':
        icon = Icons.production_quantity_limits_sharp;
        break;
      case '007':
        icon = Icons.miscellaneous_services;
        break;
    }
    return icon;
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
        margin: EdgeInsets.only(left: size * 0.10, bottom: 15),
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), bottomLeft: Radius.circular(30)),
          color: Colors.white,
        ),
        child: const Column(
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

  InkWell btnLogout(BuildContext context, double size) {
    return InkWell(
      onTap: () {
        showAlertDialogExit();
      },
      child: Container(
        margin: EdgeInsets.only(left: size * 0.10, bottom: 15),
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), bottomLeft: Radius.circular(30)),
          color: Colors.white,
        ),
        child: const Column(
          children: [
            Row(
              children: [
                Icon(Icons.login_rounded),
                SizedBox(width: 10),
                Text(
                  "ออกจากระบบ",
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

  showAlertDialogExit() async {
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          // contentPadding:
          //     const EdgeInsets.symmetric(horizontal: 22, vertical: 5),
          title: const Row(
            children: [
              Icon(Icons.login_outlined),
              SizedBox(width: 10),
              Text(
                "ออกจากระบบ",
                style: TextStyle(
                  fontSize: 17,
                  fontFamily: 'Prompt',
                ),
              ),
              SizedBox(height: 20),
              // Image.asset('images/question.gif',
              //     width: 25, height: 25, fit: BoxFit.contain),
            ],
          ),
          content: const Text(
            "คุณต้องการออกจากระบบ ?",
            style: TextStyle(
              fontFamily: 'Prompt',
              fontSize: 15,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: const Color.fromARGB(255, 208, 208, 208),
                ),
                child: const Text(
                  'ยกเลิก',
                  style: TextStyle(
                      fontFamily: 'Prompt',
                      fontSize: 15,
                      color: Color.fromARGB(255, 89, 89, 89),
                      fontWeight: FontWeight.normal),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: const Color.fromARGB(255, 255, 86, 74),
                ),
                child: const Text(
                  'ตกลง',
                  style: TextStyle(
                      fontFamily: 'Prompt',
                      fontSize: 15,
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontWeight: FontWeight.normal),
                ),
              ),
              onPressed: () {
                logoutSystem();
              },
            ),
          ],
        );
      },
    );
  }
}
