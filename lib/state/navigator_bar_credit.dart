import 'dart:convert';
import 'dart:io';

import 'package:application_thaweeyont/api.dart';
import 'package:application_thaweeyont/state/about.dart';
import 'package:application_thaweeyont/state/state_credit/check_blacklist/check_blacklist_data.dart';
import 'package:application_thaweeyont/state/state_mechanical/mechanical.dart';
import 'package:application_thaweeyont/state/state_order/branchsale/branchsales.dart';
import 'package:application_thaweeyont/state/state_payment/payment/searchpaymentreport.dart';
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
import 'state_order/skusale/searchskusales.dart';
import 'state_sale/credit_approval/testUI.dart';

class NavigatorBarMenu extends StatefulWidget {
  String? index;
  NavigatorBarMenu(this.index, {super.key});

  @override
  _NavigatorBarMenuState createState() => _NavigatorBarMenuState();
}

class _NavigatorBarMenuState extends State<NavigatorBarMenu> {
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
      case "8":
        setState(() {
          _selectedIndex = 8;
          titleHead = "บันทึกอนุมัติการจ่าย";
          status = false;
        });
        break;
      case "9":
        setState(() {
          _selectedIndex = 9;
          titleHead = "ยอดขายสินค้ารวมสาขาในแต่ละวัน";
          status = false;
        });
        break;
      case "11":
        setState(() {
          _selectedIndex = 11;
          titleHead = "รายงาน SKU Sale";
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

  static final List<Widget> _widgetOptions = <Widget>[
    const QueryDebtor(),
    const Page_Checkpurchase_info(),
    const Home(),
    const PageCreditApproval(),
    const PageStatusMember(),
    const CheckBlacklistData(),
    const ProductStockData(),
    const Mechanical(),
    const SearchPaymentReport(),
    const BranchSales(),
    const FixedTablePage(),
    const SearchSKUSale()
  ];

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
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
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min, // ให้ขนาดพอดีกับเนื้อหา
              children: [
                ...result.map((menu) {
                  return ListTile(
                    title: Text(
                      "${menu['nameMenu']}",
                      style: _selectedIndex == getselectmenuBottom(menu['id'])
                          ? MyContant().h1MenuStyle_click()
                          : MyContant().h2Style(),
                    ),
                    leading: Icon(
                      getMenuIcon(menu['id']),
                      color: _selectedIndex == getselectmenuBottom(menu['id'])
                          ? Colors.blue
                          : Colors.grey[700],
                    ),
                    onTap: () {
                      setState(() {
                        titleHead = getTitlemenuBottom(menu['id']);
                        _selectedIndex = getselectmenuBottom(menu['id']);
                        status = false;
                      });
                      Navigator.pop(context);
                    },
                  );
                }),
                const SizedBox(height: 20), // ✅ เพิ่มช่องว่างด้านล่าง
              ],
            ),
          ),
        );
      },
    );
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
      case '008':
        selectIndex = 8;
        break;
      case '009':
        selectIndex = 9;
        break;
      case '011':
        selectIndex = 11;
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
      case '008':
        title = "บันทึกอนุมัติการจ่าย";
        break;
      case '009':
        title = "ยอดขายสินค้ารวมสาขาในแต่ละวัน";
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
                    color: Colors.grey[300],
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
                            style: MyContant().textTitleDialog(),
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
                              '  หากพบปัญหาในการใช้งาน หรือต้องการเสนอความคิดเห็นเพิ่มเติม ผู้ใช้งานสามารถติดต่อแผนกไอทีหรือทีมพัฒนาโปรแกรม (โปรแกรมเมอร์) ได้โดยตรง',
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
                color: const Color.fromARGB(255, 59, 59, 59)
                    .withValues(alpha: 0.6),
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

  Widget drawerList(double size) {
    return Stack(
      children: [
        /// Drawer หลัก (เลื่อนดูได้)
        Drawer(
          width: size,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                // topRight: Radius.circular(5),
                ),
          ),
          backgroundColor: const Color.fromRGBO(7, 15, 82, 1),
          child: SingleChildScrollView(
            child: Column(
              children: [
                drawerIcon(size),
                listMenu(context, size),
                skusale(context, size),
                about(context, size),
                btnLogout(context, size),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),

        /// ปุ่มปิด (Fixed ไม่ขยับตามการเลื่อน)
        Positioned(
          top: 50,
          right: 0,
          child: closeDrawer(context),
        ),
      ],
    );
  }

  Widget closeDrawer(BuildContext context) {
    return Container(
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
        icon: const Icon(Icons.close_rounded),
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

  void handleMenuItemSelected(List<String> allowedMenu) {
    final String textNamemenu = allowApproveStatus!
        ? "บันทึกพิจารณาอนุมัติสินเชื่อ"
        : "ตรวจสอบผลอนุมัติสินเชื่อ";

    final List<Map<String, String>> menuList = [
      {"id": "001", "nameMenu": textNamemenu},
      {"id": "002", "nameMenu": "สอบถามรายละเอียดลูกหนี้"},
      {"id": "003", "nameMenu": "สอบถามรายละเอียด BlackList"},
      {"id": "004", "nameMenu": "ลูกค้าสัมพันธ์ทวียนต์"},
      {"id": "005", "nameMenu": "ตรวจสอบข้อมูลการซื้อสินค้า"},
      {"id": "006", "nameMenu": "สอบถามสินค้าในสต็อค"},
      {"id": "007", "nameMenu": "บริการงานส่ง/ติดตั้งสินค้า"},
      {"id": "008", "nameMenu": "บันทึกอนุมัติการจ่าย"},
      {"id": "009", "nameMenu": "ยอดขายสินค้ารวมสาขาในแต่ละวัน"},
      {"id": "011", "nameMenu": "รายงาน SKU Sale"},
    ];

    result = menuList.where((menuItem) {
      return allowedMenu.contains(menuItem['id']);
    }).toList();
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

  InkWell skusale(BuildContext context, double size) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const FixedTablePage(),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(left: size * 0.10, bottom: 15),
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), bottomLeft: Radius.circular(30)),
          color: Color.fromRGBO(239, 191, 239, 1),
        ),
        child: const Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.insert_chart_outlined,
                  color: Colors.white,
                ),
                SizedBox(width: 10),
                Text(
                  "รายงาน SKU Sale ทดสอบ",
                  style: TextStyle(
                      color: Colors.white, fontSize: 16, fontFamily: 'Prompt'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  menuOntap(id) {
    final Map<String, String> idToMenu = {
      '001': '3',
      '002': '0',
      '003': '5',
      '004': '4',
      '005': '1',
      '006': '6',
      '007': '7',
      '008': '8',
      '009': '9',
      '011': '11',
    };

    final credit = idToMenu[id];

    if (credit != null) {
      return Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => NavigatorBarMenu(credit),
        ),
        (Route<dynamic> route) => false,
      );
    }
    return null; // หรือแสดงข้อความ error กรณี id ไม่ถูกต้อง
  }

  Color? getMenuColor(menuColor) {
    final Map<String, Color> menuColors = {
      '001': const Color.fromRGBO(251, 713, 55, 1),
      '002': const Color.fromRGBO(255, 152, 238, 1),
      '003': const Color.fromRGBO(162, 181, 252, 1),
      '004': const Color.fromRGBO(64, 203, 203, 1),
      '005': const Color.fromRGBO(212, 151, 233, 1),
      '006': const Color.fromRGBO(176, 218, 255, 1),
      '007': const Color.fromARGB(255, 241, 209, 89),
      '008': const Color.fromRGBO(226, 199, 132, 1),
      '009': const Color.fromRGBO(239, 191, 239, 1),
      '011': const Color.fromRGBO(239, 191, 239, 1),
    };

    return menuColors[menuColor];
  }

  IconData? getMenuIcon(menuId) {
    final Map<String, IconData> menuIcons = {
      '001': Icons.manage_accounts_rounded,
      '002': Icons.people,
      '003': Icons.person_off_rounded,
      '004': Icons.switch_account_outlined,
      '005': Icons.local_mall_rounded,
      '006': Icons.production_quantity_limits_sharp,
      '007': Icons.miscellaneous_services,
      '008': Icons.payments_outlined,
      '009': Icons.point_of_sale_rounded,
      '011': Icons.insert_chart_outlined,
    };

    return menuIcons[menuId];
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
                Icon(Icons.logout),
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

  showAlertDialogExit2() async {
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
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

  void showAlertDialogExit() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15), // ปรับให้มุมกลม
          ),
          titlePadding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          title: const Row(
            children: [
              Icon(Icons.logout, size: 30, color: Colors.redAccent),
              SizedBox(width: 10),
              Text(
                "ออกจากระบบ",
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Prompt',
                  fontWeight: FontWeight.bold, // เพิ่มความหนาให้ตัวอักษร
                ),
              ),
            ],
          ),
          content: const Text(
            "คุณต้องการออกจากระบบหรือไม่?",
            style: TextStyle(
              fontFamily: 'Prompt',
              fontSize: 16,
            ),
          ),
          actionsPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 208, 208, 208),
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'ยกเลิก',
                style: TextStyle(
                  fontFamily: 'Prompt',
                  fontSize: 15,
                  color: Color.fromARGB(255, 89, 89, 89),
                ),
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 255, 86, 74),
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                logoutSystem();
              },
              child: const Text(
                'ตกลง',
                style: TextStyle(
                  fontFamily: 'Prompt',
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
