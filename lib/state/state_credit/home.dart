import 'dart:ui';

import 'package:application_thaweeyont/state/state_credit/navigator_bar_credit.dart';
import 'package:application_thaweeyont/utility/my_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class Home_credit extends StatefulWidget {
  const Home_credit({Key? key}) : super(key: key);

  @override
  State<Home_credit> createState() => _Home_creditState();
}

class _Home_creditState extends State<Home_credit> {
  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    double size_h = MediaQuery.of(context).size.height * 0.005;
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        behavior: HitTestBehavior.opaque,
        child: GridView.count(
          primary: false,
          padding: const EdgeInsets.all(20),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 1,
          childAspectRatio: size_h,
          children: <Widget>[
            check_information_n(size),
            check_buyproduct_n(size),
            check_approve_n(size),
            check_statususer_n(size),
            check_blacklist_n(size),
            // check_information(size),
            // check_buyproduct(size),
            // check_approve(size),
            // check_statususer(size),
          ],
        ),
      ),
    );
  }

  InkWell check_approve_n(double size) {
    return InkWell(
      onTap: () => Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Navigator_bar_credit('3')),
        (Route<dynamic> route) => false,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color.fromRGBO(251, 713, 55, 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.manage_accounts_rounded,
                  size: size * 0.12,
                  color: Colors.white,
                ),
                SizedBox(width: 15),
                Text(
                  'เช็คผลการพิจารณาสินเชื่อ',
                  overflow: TextOverflow.clip,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Prompt',
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  InkWell check_statususer_n(double size) {
    return InkWell(
      onTap: () => Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Navigator_bar_credit('4')),
        (Route<dynamic> route) => false,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color.fromRGBO(64, 203, 203, 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.switch_account_outlined,
                  size: size * 0.12,
                  color: Colors.white,
                ),
                SizedBox(width: 15),
                Text(
                  'สถานะสมาชิกทวียนต์',
                  overflow: TextOverflow.clip,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Prompt',
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  InkWell check_buyproduct_n(double size) {
    return InkWell(
      onTap: () => Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Navigator_bar_credit('1')),
        (Route<dynamic> route) => false,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color.fromRGBO(212, 151, 233, 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shopping_basket_rounded,
                  size: size * 0.12,
                  color: Colors.white,
                ),
                SizedBox(width: 15),
                Text(
                  'ตรวจสอบข้อมูลการซื้อสินค้า',
                  overflow: TextOverflow.clip,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Prompt',
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  InkWell check_blacklist_n(double size) {
    return InkWell(
      onTap: () => Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Navigator_bar_credit('5')),
        (Route<dynamic> route) => false,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color.fromRGBO(162, 181, 252, 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.person_off_rounded,
                  size: size * 0.12,
                  color: Colors.white,
                ),
                SizedBox(width: 15),
                Text(
                  'สอบถามรายละเอียด BlackList',
                  overflow: TextOverflow.clip,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Prompt',
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  InkWell check_information_n(double size) {
    return InkWell(
      onTap: () => Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Navigator_bar_credit('0')),
        (Route<dynamic> route) => false,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color.fromRGBO(255, 152, 238, 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.people,
                  size: size * 0.12,
                  color: Colors.white,
                ),
                SizedBox(width: 15),
                Text(
                  'สอบถามรายละเอียดลูกหนี้',
                  overflow: TextOverflow.clip,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Prompt',
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  InkWell check_statususer(double size) {
    return InkWell(
      onTap: () => Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Navigator_bar_credit('4')),
        (Route<dynamic> route) => false,
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color.fromRGBO(64, 203, 203, 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  child: Icon(
                    Icons.switch_account_outlined,
                    size: size * 0.17,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "สถานะสมาชิกทวียนต์",
                    overflow: TextOverflow.clip,
                    textAlign: TextAlign.center,
                    style: MyContant().h1MenuStyle(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  InkWell check_approve(double size) {
    return InkWell(
      onTap: () => Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Navigator_bar_credit('3')),
        (Route<dynamic> route) => false,
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color.fromRGBO(251, 713, 55, 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  child: Icon(
                    Icons.manage_accounts_rounded,
                    size: size * 0.17,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "เช็คผลการพิจารณาสินเชื่อ",
                    overflow: TextOverflow.clip,
                    style: MyContant().h1MenuStyle(),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  InkWell check_buyproduct(double size) {
    return InkWell(
      onTap: () => Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Navigator_bar_credit('1')),
        (Route<dynamic> route) => false,
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color.fromRGBO(212, 151, 233, 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  child: Icon(
                    Icons.shopping_basket_rounded,
                    size: size * 0.17,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "ตรวจสอบข้อมูลการซื้อสินค้า",
                    overflow: TextOverflow.clip,
                    textAlign: TextAlign.center,
                    style: MyContant().h1MenuStyle(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  InkWell check_information(double size) {
    return InkWell(
      onTap: () => Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Navigator_bar_credit('0')),
        (Route<dynamic> route) => false,
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color.fromRGBO(255, 152, 238, 1),
        ),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Icon(
                      Icons.people,
                      size: size * 0.17,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "สอบถามรายละเอียดลูกหนี้",
                      overflow: TextOverflow.clip,
                      textAlign: TextAlign.center,
                      style: MyContant().h1MenuStyle(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
