import 'dart:html';
import 'dart:ui';

import 'package:application_thaweeyont/state/state_credit/navigator_bar_credit.dart';
import 'package:application_thaweeyont/utility/my_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:upgrader/upgrader.dart';

class Home_credit extends StatefulWidget {
  const Home_credit({Key? key}) : super(key: key);

  @override
  State<Home_credit> createState() => _Home_creditState();
}

class _Home_creditState extends State<Home_credit> {
  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        behavior: HitTestBehavior.opaque,
        child: GridView.count(
          primary: false,
          padding: const EdgeInsets.all(20),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 2,
          children: <Widget>[
            check_information(size),
            check_buyproduct(size),
            check_approve(size),
            check_statususer(size),
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

// class CheckUpdate extends StatelessWidget {
//   const CheckUpdate({
//     Key? key,
//   }) : super(key: key);
// ;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: UpgradeAlert(
//         upgrader: Upgrader(
//           durationUntilAlertAgain: const Duration(days: 1),
//           dialogStyle: Platform.isIOS ? UpgradeDialogStyle.cupertino : UpgradeDialogStyle.material
//         ),
//         child: Center(
//           child: Column(children: [
//             Text('test'),
//           ]),
//         ),
//       ),
//     );
//   }
// }
