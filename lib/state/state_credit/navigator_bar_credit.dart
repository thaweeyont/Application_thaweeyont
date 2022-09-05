import 'package:application_thaweeyont/state/state_credit/home.dart';
import 'package:application_thaweeyont/state/state_credit/query_debtor.dart';
import 'package:application_thaweeyont/utility/my_constant.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'check_purchase_info/page_checkpurchase_info.dart';

// import 'package:custom_navigator/custom_navigator.dart';

class Navigator_bar_credit extends StatefulWidget {
  String? index;
  Navigator_bar_credit(this.index);

  @override
  _Navigator_bar_creditState createState() => _Navigator_bar_creditState();
}

class _Navigator_bar_creditState extends State<Navigator_bar_credit> {
  String name = '', idcard = '', profile = '', status_advert = '', member = '';

  void check_index() {
    var index_page = widget.index;

    switch (index_page) {
      case "0":
        setState(() {
          _selectedIndex = 0;
          title_head = "สอบถามรายละเอียดลูกหนี้";
        });
        break;
      case "1":
        setState(() {
          _selectedIndex = 1;
          title_head = "ตรวจสอบการข้อมูลซื้อสินค้า";
        });
        break;
      case "2":
        setState(() {
          _selectedIndex = 2;
          title_head = "ทวียนต์ ";
        });
        break;
      case "3":
        setState(() {
          _selectedIndex = 3;
        });
        break;
      default:
        {
          setState(() {
            _selectedIndex = 0;
            title_head = "ทวียนต์ ";
          });
        }
        break;
    }
  }

  Future<Null> getprofile_user() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      name = preferences.getString('name_user')!;
      idcard = preferences.getString('id_card')!;
      profile = preferences.getString('profile_user')!;
      status_advert = preferences.getString('status_advert')!;
      member = preferences.getString('member')!;
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
    Home_credit(),
    Home_credit(),
  ];

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    double size = MediaQuery.of(context).size.width;
    double size_h = MediaQuery.of(context).size.height;
    return Scaffold(
      // backgroundColor: Colors.grey[50],
      appBar: Appbar(),
      body: Container(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      drawer: drawer(size, context),
      bottomNavigationBar: bottonNavigator(),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(0),
        child: FloatingActionButton(
          backgroundColor: _selectedIndex == 2
              ? Colors.blue
              : Color.fromARGB(255, 22, 30, 94),
          child: Icon(Icons.home),
          onPressed: () => setState(() {
            _selectedIndex = 2;
            title_head = "ทวียนต์ ";
          }),
        ),
      ),
    );
  }

  AppBar Appbar() {
    return AppBar(
      centerTitle: true,
      title: Text(title_head),
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
                    });
                    break;
                  case 1:
                    setState(() {
                      _selectedIndex = 1;
                      title_head = "ตรวจสอบการข้อมูลซื้อสินค้า";
                    });
                    break;
                  case 2:
                    setState(() {
                      _selectedIndex = 2;
                      title_head = "ทวียนต์ ";
                    });
                    break;
                  case 3:
                    setState(() {
                      _selectedIndex = 3;
                    });
                    break;
                  default:
                    {
                      setState(() {
                        _selectedIndex = 0;
                        title_head = "ทวียนต์ ";
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
                    icon: Icon(Icons.shopping_basket_rounded), label: ''),
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
            // padding: EdgeInsets.zeros
            children: [
              drawerheader(size),
              SizedBox(height: 45),
              navigator_cradit(context, size),
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
              SharedPreferences preferences =
                  await SharedPreferences.getInstance();
              preferences.clear();
              Navigator.pushReplacementNamed(context, MyContant.routeAuthen);
            },
            child: Container(
              padding: EdgeInsets.all(20),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.exit_to_app_rounded),
                  SizedBox(width: 5),
                  Text(
                    "ออกจากระบบ",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 18,
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

  DrawerHeader drawerheader(double size) {
    return DrawerHeader(
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: Color.fromRGBO(7, 15, 82, 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Image.asset(
            'images/logo.png',
            width: size * 0.33,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.account_box_rounded,
                color: Colors.white,
              ),
              SizedBox(width: 8),
              Text(
                "$name",
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
        Navigator.pop(context);
      },
      child: Container(
        margin: EdgeInsets.only(left: size * 0.15, bottom: 15),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), bottomLeft: Radius.circular(30)),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Icon(Icons.credit_card_outlined),
            SizedBox(width: 10),
            Text(
              "สินเชื่อ",
              style: TextStyle(color: Colors.black, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
