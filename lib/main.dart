import 'package:application_thaweeyont/state/authen.dart';
import 'package:application_thaweeyont/state/state_credit/check_purchase_info/page_checkpurchase_info.dart';
import 'package:application_thaweeyont/state/state_credit/credit_approval/page_check_blacklist.dart';
import 'package:application_thaweeyont/state/state_credit/credit_approval/page_credit_approval.dart';
import 'package:application_thaweeyont/state/state_credit/data_searchdebtor.dart';
import 'package:application_thaweeyont/state/state_credit/home.dart';
import 'package:application_thaweeyont/state/state_credit/navigator_bar_credit.dart';
import 'package:application_thaweeyont/state/state_credit/pay_installment.dart';
import 'package:application_thaweeyont/state/state_credit/query_debtor.dart';
import 'package:application_thaweeyont/utility/my_constant.dart';
import 'package:flutter/material.dart';

final Map<String, WidgetBuilder> map = {
  '/authen': (BuildContext context) => Authen(),
  '/state_credit/home': (BuildContext context) => Home_credit(),
  '/state_credit/navigator_bar_credit': (BuildContext context) =>
      Navigator_bar_credit('2'),
  '/state_credit/query_debtor': (BuildContext context) => Query_debtor(),
  // '/state_credit/pay_installment': (BuildContext context) => Pay_installment(),
  '/state_credit/check_purchase_info/page_checkpurchase_info':
      (BuildContext context) => Page_Checkpurchase_info(),
  '/state_credit/credit_approval/page_credit_approval':
      (BuildContext context) => Page_Credit_Approval(),
  // '/state_credit/credit_approval/page_check_blacklist':
  //     (BuildContext context) => Page_Check_Blacklist(),
  // '/salerService': (BuildContext context) => SalerService(),
  // '/riderService': (BuildContext context) => RiderService(),
};

String? initlalRounte;

void main() {
  initlalRounte = MyContant.routeAuthen;
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: color_theme(),
        // scaffoldBackgroundColor: Colors.tealAccent,
      ),
      title: MyContant.appName,
      routes: map,
      initialRoute: initlalRounte,
    );
  }

  MaterialColor color_theme() {
    return MaterialColor(
      0xFF050C45, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
      const <int, Color>{
        50: Color.fromRGBO(5, 12, 69, 1), //10%
        100: Color.fromRGBO(5, 12, 69, 1), //10%
        200: Color.fromRGBO(5, 12, 69, 1), //10%
        300: Color.fromRGBO(5, 12, 69, 1), //10%
        400: Color.fromRGBO(5, 12, 69, 1), //10%
        500: Color.fromRGBO(5, 12, 69, 1), //10%
        600: Color.fromRGBO(5, 12, 69, 1), //10%
        700: Color.fromRGBO(5, 12, 69, 1), //10%
        800: Color.fromRGBO(5, 12, 69, 1), //10%
        900: Color.fromRGBO(5, 12, 69, 1), //10%
      },
    );
  }
}
