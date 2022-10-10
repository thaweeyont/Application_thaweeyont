import 'package:flutter/material.dart';

class MyContant {
  // Genernal
  static String appName = 'Thaweeyont Marketing';
  static String domain = 'https://a0ab-183-88-181-66.ap.ngrok.io';

  // Route
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
  TextStyle TextInputStyle() => TextStyle(
        //ตัวหนังสือใน input
        fontSize: 16,
        color: Colors.black,
        fontWeight: FontWeight.normal,
        fontFamily: 'Prompt',
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

  ButtonStyle myButtonSearchStyle() => ElevatedButton.styleFrom(
        backgroundColor: Color.fromRGBO(76, 83, 146, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.all(0),
        textStyle: const TextStyle(fontSize: 16, fontFamily: 'Prompt'),
      );
  ButtonStyle myButtonCancelStyle() => ElevatedButton.styleFrom(
        backgroundColor: Color.fromRGBO(248, 40, 78, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.all(0),
        textStyle: const TextStyle(fontSize: 16, fontFamily: 'Prompt'),
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

Future<Null> showProgressLoading(BuildContext context) async {
  showDialog(
    context: context,
    barrierColor: Colors.transparent,
    builder: (context) => WillPopScope(
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade400.withOpacity(0.6),
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          padding: EdgeInsets.all(80),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              Text(
                'Loading....',
                style: MyContant().h4normalStyle(),
              ),
            ],
          ),
        ),
      ),
      onWillPop: () async {
        return false;
      },
    ),
  );
}
