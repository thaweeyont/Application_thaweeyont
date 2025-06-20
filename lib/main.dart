import 'package:application_thaweeyont/state/authen.dart';
import 'package:application_thaweeyont/state/state_cus_relations/check_purchase_info/page_checkpurchase_info.dart';
import 'package:application_thaweeyont/state/state_sale/credit_approval/page_credit_approval.dart';
import 'package:application_thaweeyont/state/home.dart';
import 'package:application_thaweeyont/state/navigator_bar_credit.dart';
import 'package:application_thaweeyont/state/state_credit/query_debtor/query_debtor.dart';
import 'package:application_thaweeyont/utility/my_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

final Map<String, WidgetBuilder> map = {
  '/authen': (BuildContext context) => const Authen(),
  '/state/home': (BuildContext context) => const Home_credit(),
  '/state/navigator_bar_credit': (BuildContext context) =>
      Navigator_bar_credit('2'),
  '/state_credit/query_debtor': (BuildContext context) => const Query_debtor(),
  '/state_credit/check_purchase_info/page_checkpurchase_info':
      (BuildContext context) => const Page_Checkpurchase_info(),
  '/state_credit/credit_approval/page_credit_approval':
      (BuildContext context) => const Page_Credit_Approval(),
};

String? initlalRounte;

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // ควรมีถ้ากำหนดการหมุนหน้าจอ
  initlalRounte = MyContant.routeAuthen;
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(const MyApp());
  });
  // runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('th'),
          Locale('en'),
        ],
        theme: ThemeData(
          primarySwatch: colorTheme(),
        ),
        title: MyContant.appName,
        routes: map,
        initialRoute: initlalRounte,
        // home: TapControl("0"),
      ),
    );
  }

  MaterialColor colorTheme() {
    return const MaterialColor(
      0xFF050C45, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
      <int, Color>{
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
