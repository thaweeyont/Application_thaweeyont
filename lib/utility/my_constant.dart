import 'package:flutter/material.dart';
import 'package:loading_gifs/loading_gifs.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../state/authen.dart';

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
  TextStyle TitleStyle() => TextStyle(
        fontSize: 21,
        color: Colors.white,
        fontWeight: FontWeight.normal,
        fontFamily: 'Prompt',
      );
  TextStyle h1MenuStyle() => TextStyle(
        fontSize: 16,
        color: Colors.white,
        fontWeight: FontWeight.normal,
        fontFamily: 'Prompt',
      );
  TextStyle h1MenuStyle_click() => TextStyle(
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
  TextStyle h3Style() => TextStyle(
        fontSize: 14,
        color: Colors.black,
        fontWeight: FontWeight.normal,
        fontFamily: 'Prompt',
      );
  TextStyle TextsearchStyle() => TextStyle(
        fontSize: 14,
        color: Color.fromRGBO(9, 123, 237, 1),
        fontWeight: FontWeight.normal,
        fontFamily: 'Prompt',
      );
  TextStyle h4normalStyle() => TextStyle(
        fontSize: 16,
        color: Colors.black,
        fontWeight: FontWeight.normal,
        fontFamily: 'Prompt',
      );
  TextStyle textLoading() => TextStyle(
        fontSize: 16,
        color: Colors.white,
        fontWeight: FontWeight.normal,
        fontFamily: 'Prompt',
      );
  TextStyle TextTitleDialog() => TextStyle(
        fontSize: 18,
        color: Colors.black,
        fontWeight: FontWeight.normal,
        fontFamily: 'Prompt',
      );
  TextStyle TextInputStyle() => TextStyle(
        //ตัวหนังสือใน input
        fontSize: 16,
        color: Colors.black,
        fontWeight: FontWeight.normal,
        fontFamily: 'Prompt',
        height: 1.7,
      );
  TextStyle TextInputDate() => TextStyle(
        //ตัวหนังสือใน input date
        fontSize: 14,
        color: Colors.black,
        fontWeight: FontWeight.normal,
        fontFamily: 'Prompt',
      );
  TextStyle TextInputSelect() => TextStyle(
        //ตัวหนังสือใน dropdown
        fontSize: 16,
        color: Color.fromRGBO(106, 106, 106, 1),
        fontWeight: FontWeight.normal,
        fontFamily: 'Prompt',
      );
  TextStyle TextSmallStyle() => TextStyle(
        //ตัวหนังสือเล็กหนา
        fontSize: 12,
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontFamily: 'Prompt',
      );
  TextStyle TextSmalldebNote() => TextStyle(
        // ตัวหนังสือบันทึกหมายเหตุ
        fontSize: 15,
        color: Colors.black,
        fontWeight: FontWeight.normal,
        fontFamily: 'Prompt',
      );
  TextStyle TextcolorBlue() => TextStyle(
        fontSize: 15,
        color: Color.fromRGBO(0, 14, 131, 1),
        fontWeight: FontWeight.normal,
        fontFamily: 'Prompt',
      );
  TextStyle Textversion() => TextStyle(
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

  ButtonStyle myButtonSearchStyle() => ElevatedButton.styleFrom(
        backgroundColor: Color.fromRGBO(76, 83, 146, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.all(0),
        textStyle: const TextStyle(fontSize: 16, fontFamily: 'Prompt'),
      );
  ButtonStyle myButtonCancelStyle() => ElevatedButton.styleFrom(
        backgroundColor: Color.fromRGBO(248, 40, 78, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.all(0),
        textStyle: const TextStyle(fontSize: 16, fontFamily: 'Prompt'),
      );
  ButtonStyle myButtonSubmitStyle() => ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        foregroundColor: Color.fromARGB(255, 0, 0, 0),
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

Future<Null> showProgressDialog(BuildContext context, title, subtitle) async {
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
                Text("ตกลง",
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Prompt',
                        color: Colors.black)),
              ],
            ),
          ),
        ],
      ),
    ),
    // animationType: DialogTransitionType.fadeScale,
    // curve: Curves.fastOutSlowIn,
    // duration: Duration(seconds: 1),
  );
}

Future<Null> showProgressDialog_Notdata(
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
                Text("ตกลง",
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Prompt',
                        color: Colors.black)),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Future<Null> showProgressDialog_400(
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
                Text("ตกลง",
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Prompt',
                        color: Colors.black)),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Future<Null> showProgressDialog_401(
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
                Text("ตกลง",
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Prompt',
                        color: Colors.black)),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Future<Null> showProgressDialog_404(
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
                Text("ตกลง",
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Prompt',
                        color: Colors.black)),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Future<Null> showProgressDialog_405(
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
                Text("ตกลง",
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Prompt',
                        color: Colors.black)),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Future<Null> showProgressDialog_500(
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
                Text("ตกลง",
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Prompt',
                        color: Colors.black)),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Future<Null> showProgressLoading(BuildContext context) async {
  showDialog(
    context: context,
    barrierColor: Colors.transparent,
    builder: (context) => Center(
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 24, 24, 24).withOpacity(0.9),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
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
