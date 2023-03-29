import 'package:application_thaweeyont/state/state_credit/credit_approval/page_credit_approval.dart';
import 'package:flutter/material.dart';
import 'package:loading_gifs/loading_gifs.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../state/authen.dart';
import '../state/state_credit/navigator_bar_credit.dart';

class MyContant {
  // Genernal
  static String appName = 'Thaweeyont Marketing';
  static String domain = 'https://a0ab-183-88-181-66.ap.ngrok.io';

  // Route
  static String routeProductHome = '/product_home/product_home';
  static String routeAuthen = '/authen';
  static String routeHomeCredit = '/state_credit/home';
  static String routeNavigator_bar_credit =
      '/state_credit/navigator_bar_credit';
  static String routeQueryDebtor = '/state_credit/query_debtor';
  static String routeDataSearchDebtor = '/state_credit/data_searchdebtor';
  static String routePayInstallment = '/state_credit/pay_installment';
  static String routePagePuechaseinfo =
      '/state_credit/check_purchase_info/page_checkpurchase_info';
  static String routePageCreditApproval =
      '/state_credit/credit_approval/page_credit_approval';
  static String routePageCheckBlacklist =
      '/state_credit/credit_approval/page_check_blacklist';
  static String routePageStatusMember =
      '/state_credit/status_member/page_status_member';

  // Image
  static String image1 = 'images/image1.png';
  static String image2 = 'images/image2.png';
  static String image3 = 'images/image3.png';
  static String image4 = 'images/image4.png';
  static String avatar = 'images/avatar.png';
  static String logo_login = 'images/logo.png';
  static String map = 'images/map.jpeg';
  static String idcard = 'images/idcard.png';

  //Color
  static Color primary = Color(0xff87861d);
  static Color dark = Color(0xff575900);
  static Color light = Color(0xffb9b64e);
  static Color load = Color(0xffe6b980);

  // size icon input
  final sizeIcon = BoxConstraints(minWidth: 45, minHeight: 45);

  //Style
  //TitleBar
  TextStyle TitleStyle() => const TextStyle(
        fontSize: 21,
        color: Colors.white,
        fontWeight: FontWeight.normal,
        fontFamily: 'Prompt',
      );
  TextStyle h1MenuStyle() => const TextStyle(
        fontSize: 16,
        color: Colors.white,
        fontWeight: FontWeight.normal,
        fontFamily: 'Prompt',
      );
  TextStyle h1MenuStyle_click() => const TextStyle(
        fontSize: 16,
        color: Colors.blue,
        fontWeight: FontWeight.normal,
        fontFamily: 'Prompt',
      );
  //รายาการค้นหา
  TextStyle h2Style() => TextStyle(
        fontSize: 16,
        color: Colors.grey[700],
        fontWeight: FontWeight.normal,
        fontFamily: 'Prompt',
      );
  TextStyle hintTextStyle() => TextStyle(
        fontSize: 16,
        color: Colors.grey[500],
        fontWeight: FontWeight.normal,
        fontFamily: 'Prompt',
      );
  TextStyle h3Style() => const TextStyle(
        fontSize: 14,
        color: Colors.black,
        fontWeight: FontWeight.normal,
        fontFamily: 'Prompt',
      );
  TextStyle TextsearchStyle() => const TextStyle(
        fontSize: 14,
        color: Color.fromRGBO(9, 123, 237, 1),
        fontWeight: FontWeight.normal,
        fontFamily: 'Prompt',
      );
  TextStyle h4normalStyle() => const TextStyle(
        fontSize: 16,
        color: Colors.black,
        fontWeight: FontWeight.normal,
        fontFamily: 'Prompt',
      );
  TextStyle h5NotData() => const TextStyle(
        fontSize: 20,
        color: Color.fromARGB(255, 158, 158, 158),
        fontWeight: FontWeight.normal,
        fontFamily: 'Prompt',
      );

  TextStyle textLoading() => const TextStyle(
        fontSize: 16,
        color: Colors.white,
        fontWeight: FontWeight.normal,
        fontFamily: 'Prompt',
      );
  TextStyle TextTitleDialog() => const TextStyle(
        fontSize: 18,
        color: Colors.black,
        fontWeight: FontWeight.normal,
        fontFamily: 'Prompt',
      );
  TextStyle TextInputStyle() => const TextStyle(
        //ตัวหนังสือใน input
        fontSize: 16,
        color: Colors.black,
        fontWeight: FontWeight.normal,
        fontFamily: 'Prompt',
        height: 1.7,
      );
  TextStyle TextInputDate() => const TextStyle(
        //ตัวหนังสือใน input date
        fontSize: 14,
        color: Colors.black,
        fontWeight: FontWeight.normal,
        fontFamily: 'Prompt',
      );
  TextStyle TextInputSelect() => const TextStyle(
        //ตัวหนังสือใน dropdown
        fontSize: 16,
        color: Color.fromRGBO(106, 106, 106, 1),
        fontWeight: FontWeight.normal,
        fontFamily: 'Prompt',
      );
  TextStyle TextSmallStyle() => const TextStyle(
        //ตัวหนังสือเล็กหนา
        fontSize: 12,
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontFamily: 'Prompt',
      );
  TextStyle TextSmalldebNote() => const TextStyle(
        // ตัวหนังสือบันทึกหมายเหตุ
        fontSize: 15,
        color: Colors.black,
        fontWeight: FontWeight.normal,
        fontFamily: 'Prompt',
      );
  TextStyle TextcolorBlue() => const TextStyle(
        fontSize: 15,
        color: Color.fromRGBO(0, 14, 131, 1),
        fontWeight: FontWeight.normal,
        fontFamily: 'Prompt',
      );
  TextStyle Textversion() => const TextStyle(
        fontSize: 12,
        color: Color.fromARGB(255, 163, 163, 163),
        fontWeight: FontWeight.normal,
        // fontFamily: 'Prompt',
      );
  TextStyle normal_text(Color color) => TextStyle(
        fontSize: 16,
        color: color,
        fontFamily: 'Prompt',
      );
  TextStyle bold_text(Color color) => TextStyle(
        fontSize: 16,
        color: color,
        fontWeight: FontWeight.bold,
        fontFamily: 'Prompt',
      );

  TextStyle small_text(Color color) => TextStyle(
        fontSize: 14,
        color: color,
        fontFamily: 'Prompt',
      );

  TextStyle TextMenulist() => const TextStyle(
        fontSize: 20,
        color: Colors.white,
        fontFamily: 'Prompt',
        fontWeight: FontWeight.normal,
      );

  ButtonStyle myButtonSearchStyle() => ElevatedButton.styleFrom(
        backgroundColor: const Color.fromRGBO(76, 83, 146, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.all(0),
        textStyle: const TextStyle(fontSize: 16, fontFamily: 'Prompt'),
      );
  ButtonStyle myButtonCancelStyle() => ElevatedButton.styleFrom(
        backgroundColor: const Color.fromRGBO(248, 40, 78, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.all(0),
        textStyle: const TextStyle(fontSize: 16, fontFamily: 'Prompt'),
      );
  ButtonStyle myButtonSubmitStyle() => ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        foregroundColor: const Color.fromARGB(255, 0, 0, 0),
        padding: const EdgeInsets.all(0),
        textStyle: const TextStyle(fontSize: 16, fontFamily: 'Prompt'),
      );

  SizedBox space_box(double height) => SizedBox(
        height: height,
        child: Container(
          color: Colors.grey[200],
        ),
      );
}

showProgressDialog(BuildContext context, title, subtitle) async {
  showDialog(
    context: context,
    barrierDismissible: false, // user must tap button!

    builder: (context) {
      return AlertDialog(
        contentPadding: EdgeInsets.symmetric(horizontal: 40),
        title: Row(
          children: [
            Image.asset('images/error_log.gif',
                width: 50, height: 50, fit: BoxFit.contain),
            Text(
              title,
              style: const TextStyle(
                  fontSize: 18,
                  fontFamily: 'Prompt',
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Text(
          subtitle,
          style: const TextStyle(fontFamily: 'Prompt', fontSize: 16),
        ),
        actionsAlignment: MainAxisAlignment.end,
        actions: <Widget>[
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
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

showProgressDialog_Notdata(BuildContext context, title, subtitle) async {
  showDialog(
    context: context,
    barrierDismissible: false, // user must tap button!

    builder: (context) {
      return AlertDialog(
        contentPadding: const EdgeInsets.symmetric(horizontal: 40),
        title: Row(
          children: [
            Image.asset('images/error_log.gif',
                width: 50, height: 50, fit: BoxFit.contain),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontFamily: 'Prompt'),
            ),
          ],
        ),
        content: Text(
          subtitle,
          style: TextStyle(fontFamily: 'Prompt', fontSize: 16),
        ),
        actionsAlignment: MainAxisAlignment.end,
        actions: <Widget>[
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
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future<Null> showProgressDialog555(
    BuildContext context, title, subtitle) async {
  showDialog(
    context: context,
    builder: (context) => SimpleDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      title: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Row(
          children: [
            Image.asset('images/error_log.gif',
                width: 45, height: 45, fit: BoxFit.contain),
            Text(
              title,
              style: TextStyle(fontSize: 18, fontFamily: 'Prompt'),
            ),
          ],
        ),
        subtitle: Row(
          children: [
            Expanded(
              child: Text(
                subtitle,
                overflow: TextOverflow.clip,
                style: TextStyle(fontSize: 16, fontFamily: 'Prompt'),
              ),
            ),
          ],
        ),
      ),
      children: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "ตกลง",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Prompt',
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
    // animationType: DialogTransitionType.fadeScale,
    // curve: Curves.fastOutSlowIn,
    // duration: Duration(seconds: 1),
  );
}

Future<Null> showProgressDialog_Notdata555(
    BuildContext context, title, subtitle) async {
  showDialog(
    context: context,
    builder: (context) => Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
      ),
      child: SimpleDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
        title: ListTile(
          leading: Image.asset('images/error_log.gif'),
          title: Text(
            title,
            style: TextStyle(fontSize: 18, fontFamily: 'Prompt'),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(fontSize: 16, fontFamily: 'Prompt'),
          ),
        ),
        children: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Column(
              children: [
                Text(
                  "ตกลง",
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Prompt',
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Future<Null> showProgressDialog_4000(
    BuildContext context, title, subtitle) async {
  showDialog(
    context: context,
    builder: (context) => Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
      ),
      child: SimpleDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
        title: ListTile(
          leading: Image.asset('images/error_log.gif'),
          title: Text(
            title,
            style: TextStyle(fontSize: 18, fontFamily: 'Prompt'),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(fontSize: 16, fontFamily: 'Prompt'),
          ),
        ),
        children: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Column(
              children: [
                Text(
                  "ตกลง",
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Prompt',
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Future<Null> showProgressDialog_4011(
    BuildContext context, title, subtitle) async {
  showDialog(
    context: context,
    builder: (context) => Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
      ),
      child: SimpleDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
        title: ListTile(
          leading: Image.asset('images/error_log.gif'),
          title: Text(
            title,
            style: TextStyle(fontSize: 18, fontFamily: 'Prompt'),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(fontSize: 16, fontFamily: 'Prompt'),
          ),
        ),
        children: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Column(
              children: [
                Text(
                  "ตกลง",
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Prompt',
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Future<Null> showProgressDialog_4044(
    BuildContext context, title, subtitle) async {
  showDialog(
    context: context,
    builder: (context) => Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
      ),
      child: SimpleDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        title: ListTile(
          contentPadding: EdgeInsets.zero,
          title: Row(
            children: [
              Image.asset('images/error_log.gif',
                  width: 45, height: 45, fit: BoxFit.contain),
              Text(
                title,
                style: TextStyle(fontSize: 18, fontFamily: 'Prompt'),
              ),
            ],
          ),
          subtitle: Row(
            children: [
              Expanded(
                child: Text(
                  subtitle,
                  overflow: TextOverflow.clip,
                  style: TextStyle(fontSize: 16, fontFamily: 'Prompt'),
                ),
              ),
            ],
          ),
        ),
        children: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Column(
              children: [
                Text(
                  "ตกลง",
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Prompt',
                    // color: Colors.black,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

showProgressDialog_400(BuildContext context, title, subtitle) async {
  showDialog(
    context: context,
    barrierDismissible: false, // user must tap button!

    builder: (context) {
      return AlertDialog(
        contentPadding: EdgeInsets.symmetric(horizontal: 40),
        title: Row(
          children: [
            Image.asset('images/error_log.gif',
                width: 50, height: 50, fit: BoxFit.contain),
            Text(
              title,
              style: TextStyle(fontSize: 18, fontFamily: 'Prompt'),
            ),
          ],
        ),
        content: Text(
          subtitle,
          style: TextStyle(fontFamily: 'Prompt', fontSize: 16),
        ),
        actionsAlignment: MainAxisAlignment.end,
        actions: <Widget>[
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
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

showProgressDialog_401(BuildContext context, title, subtitle) async {
  showDialog(
    context: context,
    barrierDismissible: false, // user must tap button!

    builder: (context) {
      return AlertDialog(
        contentPadding: EdgeInsets.symmetric(horizontal: 40),
        title: Row(
          children: [
            Image.asset('images/error_log.gif',
                width: 50, height: 50, fit: BoxFit.contain),
            Text(
              title,
              style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Prompt',
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Text(
          subtitle,
          style: TextStyle(fontFamily: 'Prompt', fontSize: 16),
        ),
        actionsAlignment: MainAxisAlignment.end,
        actions: <Widget>[
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
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

showProgressDialog_404(BuildContext context, title, subtitle) async {
  showDialog(
    context: context,
    barrierDismissible: false, // user must tap button!

    builder: (context) {
      return AlertDialog(
        contentPadding: EdgeInsets.symmetric(horizontal: 40),
        title: Row(
          children: [
            Image.asset('images/error_log.gif',
                width: 50, height: 50, fit: BoxFit.contain),
            Text(
              title,
              style: TextStyle(fontSize: 18, fontFamily: 'Prompt'),
            ),
          ],
        ),
        content: Text(
          subtitle,
          style: TextStyle(fontFamily: 'Prompt', fontSize: 16),
        ),
        actionsAlignment: MainAxisAlignment.end,
        actions: <Widget>[
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
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => const Page_Credit_Approval(),
              //   ),
              // );
            },
          ),
        ],
      );
    },
  );
}

showDialog_404_approve(BuildContext context, title, subtitle) async {
  showDialog(
    context: context,
    barrierDismissible: false, // user must tap button!

    builder: (context) {
      return AlertDialog(
        contentPadding: EdgeInsets.symmetric(horizontal: 40),
        title: Row(
          children: [
            Image.asset('images/error_log.gif',
                width: 50, height: 50, fit: BoxFit.contain),
            Text(
              title,
              style: TextStyle(fontSize: 18, fontFamily: 'Prompt'),
            ),
          ],
        ),
        content: Text(
          subtitle,
          style: TextStyle(fontFamily: 'Prompt', fontSize: 16),
        ),
        actionsAlignment: MainAxisAlignment.end,
        actions: <Widget>[
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
              // Navigator.of(context).pop();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => Navigator_bar_credit('3'),
                ),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      );
    },
  );
}

showProgressDialog_405(BuildContext context, title, subtitle) async {
  showDialog(
    context: context,
    barrierDismissible: false, // user must tap button!

    builder: (context) {
      return AlertDialog(
        contentPadding: EdgeInsets.symmetric(horizontal: 40),
        title: Row(
          children: [
            Image.asset('images/error_log.gif',
                width: 50, height: 50, fit: BoxFit.contain),
            Text(
              title,
              style: TextStyle(fontSize: 18, fontFamily: 'Prompt'),
            ),
          ],
        ),
        content: Text(
          subtitle,
          style: TextStyle(fontFamily: 'Prompt', fontSize: 16),
        ),
        actionsAlignment: MainAxisAlignment.end,
        actions: <Widget>[
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
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

showProgressDialog_500(BuildContext context, title, subtitle) async {
  showDialog(
    context: context,
    barrierDismissible: false, // user must tap button!

    builder: (context) {
      return AlertDialog(
        contentPadding: EdgeInsets.symmetric(horizontal: 40),
        title: Row(
          children: [
            Image.asset('images/error_log.gif',
                width: 50, height: 50, fit: BoxFit.contain),
            Text(
              title,
              style: TextStyle(fontSize: 18, fontFamily: 'Prompt'),
            ),
          ],
        ),
        content: Text(
          subtitle,
          style: TextStyle(fontFamily: 'Prompt', fontSize: 16),
        ),
        actionsAlignment: MainAxisAlignment.end,
        actions: <Widget>[
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
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future<Null> showProgressDialog_4055(
    BuildContext context, title, subtitle) async {
  showDialog(
    context: context,
    builder: (context) => Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
      ),
      child: SimpleDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
        title: ListTile(
          leading: Image.asset('images/error_log.gif'),
          title: Text(
            title,
            style: TextStyle(fontSize: 18, fontFamily: 'Prompt'),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(fontSize: 16, fontFamily: 'Prompt'),
          ),
        ),
        children: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Column(
              children: [
                Text(
                  "ตกลง",
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Prompt',
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Future<Null> showProgressDialog_5000(
    BuildContext context, title, subtitle) async {
  showDialog(
    context: context,
    builder: (context) => Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
      ),
      child: SimpleDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
        title: ListTile(
          leading: Image.asset('images/error_log.gif'),
          title: Text(
            title,
            style: TextStyle(fontSize: 18, fontFamily: 'Prompt'),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(fontSize: 16, fontFamily: 'Prompt'),
          ),
        ),
        children: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Column(
              children: [
                Text(
                  "ตกลง",
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Prompt',
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Future<void> showProgressLoading(BuildContext context) async {
  showDialog(
    context: context,
    barrierColor: Colors.transparent,
    builder: (context) => Center(
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 24, 24, 24).withOpacity(0.9),
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // CircularProgressIndicator(),
            Image.asset(cupertinoActivityIndicator, scale: 4),
            Text(
              'กำลังโหลด',
              style: MyContant().textLoading(),
            ),
          ],
        ),
      ),
    ),
  );
}

Center notData(BuildContext context) {
  return Center(
    child: Container(
      height: MediaQuery.of(context).size.height * 0.25,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                // width: 50,
                width: MediaQuery.of(context).size.width * 0.2,
                child: Image.asset('images/searc_unscreen.gif'),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'ไม่พบข้อมูล',
                style: MyContant().h4normalStyle(),
              ),
            ],
          )
        ],
      ),
    ),
  );
}
