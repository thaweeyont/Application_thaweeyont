import 'package:flutter/material.dart';
// import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:loading_gifs/loading_gifs.dart';

class MyContant {
  // Genernal
  static String appName = 'Thaweeyont Marketing';
  static String domain = 'https://a0ab-183-88-181-66.ap.ngrok.io';

  // Route
  static String routeProductHome = '/product_home/product_home';
  static String routeAuthen = '/authen';
  static String routeHomeCredit = '/state/home';
  static String routeNavigatorBarCredit = '/state/navigator_bar_credit';
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
  static String logoLogin = 'images/logo.png';
  static String map = 'images/map.jpeg';
  static String idcard = 'images/idcard.png';

  //Color
  static Color primary = const Color(0xff87861d);
  static Color dark = const Color(0xff575900);
  static Color light = const Color(0xffb9b64e);
  static Color load = const Color(0xffe6b980);
  static Color colorAppbar = const Color.fromRGBO(5, 12, 69, 1);

  // size icon input
  final sizeIcon = const BoxConstraints(minWidth: 45, minHeight: 45);

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
  TextStyle h6Style() => const TextStyle(
        fontSize: 16,
        color: Color.fromARGB(255, 32, 64, 154),
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
  TextStyle TextAbout() => const TextStyle(
        fontSize: 14,
        color: Color.fromARGB(255, 148, 148, 148),
        fontWeight: FontWeight.normal,
        fontFamily: 'Prompt',
      );
  TextStyle h4normalStyle() => const TextStyle(
        fontSize: 16,
        color: Colors.black,
        fontWeight: FontWeight.normal,
        fontFamily: 'Prompt',
      );

  TextStyle h5normalStyle() => const TextStyle(
        fontSize: 15,
        color: Colors.black,
        fontWeight: FontWeight.normal,
        fontFamily: 'Prompt',
      );
  TextStyle h5NotData() => const TextStyle(
        fontSize: 18,
        color: Color.fromARGB(255, 158, 158, 158),
        fontWeight: FontWeight.normal,
        fontFamily: 'Prompt',
      );

  TextStyle textLoading() => const TextStyle(
        fontSize: 16,
        color: Colors.white,
        fontWeight: FontWeight.normal,
        fontFamily: 'Prompt',
        decoration: TextDecoration.none,
      );
  TextStyle textSmall() => const TextStyle(
        fontSize: 14,
        color: Colors.white,
        fontWeight: FontWeight.normal,
        fontFamily: 'Prompt',
      );
  TextStyle textTitleDialog() => const TextStyle(
        fontSize: 18,
        color: Colors.black,
        fontWeight: FontWeight.normal,
        fontFamily: 'Prompt',
      );
  TextStyle textInputStyle() => const TextStyle(
        //ตัวหนังสือใน input
        fontSize: 15,
        color: Colors.black,
        fontWeight: FontWeight.normal,
        fontFamily: 'Prompt',
        height: 1.7,
      );
  TextStyle TextBottomSheet() => const TextStyle(
        fontSize: 16,
        color: Colors.black,
        fontWeight: FontWeight.normal,
        fontFamily: 'Prompt',
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
        fontSize: 15,
        color: Color.fromRGBO(106, 106, 106, 1),
        fontWeight: FontWeight.normal,
        fontFamily: 'Prompt',
      );
  TextStyle TextSelect2() => const TextStyle(
        //ตัวหนังสือใน dropdown
        fontSize: 15,
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
        fontSize: 16,
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
  TextStyle TextshowHome() => const TextStyle(
        fontSize: 36,
        color: Colors.white,
        fontFamily: 'Prompt',
        fontWeight: FontWeight.bold,
      );
  TextStyle TextshowHome2() => const TextStyle(
        fontSize: 26,
        color: Colors.white,
        fontFamily: 'Prompt',
        fontWeight: FontWeight.bold,
      );
  TextStyle TextshowHome3() => const TextStyle(
        fontSize: 16,
        color: Colors.white,
        fontFamily: 'Prompt',
        fontWeight: FontWeight.bold,
      );
  TextStyle Textbold() => const TextStyle(
        fontSize: 20,
        color: Color.fromARGB(255, 163, 163, 163),
        fontFamily: 'Prompt',
        fontWeight: FontWeight.w400,
      );

  ButtonStyle myButtonSearchStyle() => ElevatedButton.styleFrom(
        backgroundColor: const Color.fromRGBO(76, 83, 146, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.all(0),
        textStyle: const TextStyle(fontSize: 16, fontFamily: 'Prompt'),
      );
  ButtonStyle myButtonCancelStyle() => ElevatedButton.styleFrom(
        backgroundColor: const Color.fromRGBO(248, 40, 78, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.all(0),
        textStyle: const TextStyle(fontSize: 16, fontFamily: 'Prompt'),
      );
  ButtonStyle myButtonSubmitStyle() => ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        foregroundColor: const Color.fromARGB(255, 0, 0, 0),
        padding: const EdgeInsets.all(0),
        textStyle: const TextStyle(fontSize: 16, fontFamily: 'Prompt'),
      );

  ButtonStyle myButtonQuaranteeStyle() => ElevatedButton.styleFrom(
        backgroundColor: const Color.fromRGBO(251, 173, 55, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        foregroundColor: const Color.fromARGB(255, 0, 0, 0),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        textStyle: const TextStyle(fontSize: 15, fontFamily: 'Prompt'),
      );

  SizedBox spaceBox(double height) => SizedBox(
        height: height,
        child: Container(
          color: Colors.grey[200],
        ),
      );
}

Future<void> showProgressLoading2(BuildContext context) async {
  showDialog(
    context: context,
    barrierColor: Colors.transparent,
    builder: (context) => Center(
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 24, 24, 24).withAlpha(230),
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(cupertinoActivityIndicator, scale: 4),
          ],
        ),
      ),
    ),
  );
}

showProgressDialog11(BuildContext context, title, subtitle) async {
  showDialog(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (context) {
      return AlertDialog(
        title: Row(
          children: [
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
                fontSize: 15,
                color: Colors.black,
                fontWeight: FontWeight.normal,
              ),
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

void showProgressDialog(
    BuildContext context, String title, String subtitle) async {
  showDialog(
    context: context,
    barrierDismissible: false, // ไม่ให้ผู้ใช้ปิดหน้าต่างโดยไม่ตั้งใจ
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), // ทำให้ขอบโค้งมน
        ),
        titlePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        title: Row(
          children: [
            const Icon(Icons.info_outline,
                color: Colors.blue, size: 30), // ไอคอนแจ้งเตือน
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontFamily: 'Prompt',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          subtitle,
          style: const TextStyle(
            fontFamily: 'Prompt',
            fontSize: 16,
          ),
        ),
        actionsAlignment: MainAxisAlignment.end,
        actionsPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
              backgroundColor:
                  const Color.fromARGB(255, 33, 150, 243), // เพิ่มสีให้ปุ่ม
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // ปรับขอบปุ่มให้มน
              ),
            ),
            child: const Text(
              'ตกลง',
              style: TextStyle(
                fontFamily: 'Prompt',
                fontSize: 15,
                color: Colors.white, // ปรับสีข้อความให้เป็นสีขาว
              ),
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

showProgressDialogNotdata(BuildContext context, title, subtitle) async {
  showDialog(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (context) {
      return AlertDialog(
        contentPadding: const EdgeInsets.symmetric(horizontal: 40),
        title: Row(
          children: [
            const Icon(
              Icons.error_outline,
              size: 40,
            ),
            // Image.asset('images/error_log.gif',
            //     width: 50, height: 50, fit: BoxFit.contain),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontFamily: 'Prompt'),
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
                  fontSize: 15,
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

showProgressDialog_400(BuildContext context, String title, String subtitle) {
  showDialog(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (context) {
      return AlertDialog(
        // contentPadding: const EdgeInsets.symmetric(horizontal: 40),
        title: Row(
          children: [
            // Image.asset('images/error_log.gif',
            //     width: 50, height: 50, fit: BoxFit.contain),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontFamily: 'Prompt'),
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
                  fontSize: 15,
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

showProgressDialog_401(BuildContext context, title, subtitle) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Row(
          children: [
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
                  fontSize: 15,
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
        // contentPadding: const EdgeInsets.symmetric(horizontal: 40),
        title: Row(
          children: [
            // Image.asset('images/error_log.gif',
            //     width: 50, height: 50, fit: BoxFit.contain),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontFamily: 'Prompt'),
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
                  fontSize: 15,
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

showProgressDialog_405(BuildContext context, title, subtitle) async {
  showDialog(
    context: context,
    barrierDismissible: false, // user must tap button!

    builder: (context) {
      return AlertDialog(
        // contentPadding: const EdgeInsets.symmetric(horizontal: 40),
        title: Row(
          children: [
            // Image.asset('images/error_log.gif',
            //     width: 50, height: 50, fit: BoxFit.contain),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontFamily: 'Prompt'),
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
                  fontSize: 15,
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
        // contentPadding: const EdgeInsets.symmetric(horizontal: 40),
        title: Row(
          children: [
            // Image.asset('images/error_log.gif',
            //     width: 50, height: 50, fit: BoxFit.contain),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontFamily: 'Prompt'),
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
                  fontSize: 15,
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

Future<void> showProgressLoading(BuildContext context) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.transparent,
    builder: (context) => Center(
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 24, 24, 24).withAlpha(230),
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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

enum AlertType { info, warning, error, success }

/// ตัวอย่าง:
///   showAppAlert(context, 'แจ้งเตือน', 'กรุณาเลือกสาขาก่อน');
///   showAppAlert(context, 'ผิดพลาด', 'ไม่สามารถบันทึกได้', type: AlertType.error);
///   showAppAlert(context, 'สำเร็จ', 'บันทึกเรียบร้อย',
///       type: AlertType.success, onConfirm: () => Navigator.pop(context));
Future<void> showAppAlert(
  BuildContext context,
  String title,
  String message, {
  AlertType type = AlertType.warning,
  String confirmText = 'ตกลง',
  VoidCallback? onConfirm,
}) {
  late final Color color;
  late final IconData icon;
  switch (type) {
    case AlertType.info:
      color = const Color(0xFF1470E0);
      icon = Icons.info_outline_rounded;
      break;
    case AlertType.warning:
      color = const Color(0xFFF5A623);
      icon = Icons.priority_high_rounded;
      break;
    case AlertType.error:
      color = const Color(0xFFE53935);
      icon = Icons.close_rounded;
      break;
    case AlertType.success:
      color = const Color(0xFF2E9E5B);
      icon = Icons.check_rounded;
      break;
  }

  final base = MyContant().h4normalStyle();

  return showGeneralDialog<void>(
    context: context,
    // ถ้ามี onConfirm ต้องกดปุ่มเท่านั้น (กันปิดโดยไม่ตั้งใจแล้วงานไม่ต่อ)
    barrierDismissible: onConfirm == null,
    barrierLabel: 'ปิด',
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 240),
    pageBuilder: (ctx, _, __) => Center(
      child: Dialog(
        backgroundColor: Colors.white,
        elevation: 0,
        insetPadding: const EdgeInsets.symmetric(horizontal: 36),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ไอคอนวงกลมซ้อน 2 ชั้น
              Container(
                width: 84,
                height: 84,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.14),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: color.withValues(alpha: 0.35),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(icon, color: Colors.white, size: 34),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                title,
                textAlign: TextAlign.center,
                style: base.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF0B2C63),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: base.copyWith(
                  fontSize: 15,
                  height: 1.5,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: color,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    onConfirm?.call();
                  },
                  child: Text(
                    confirmText,
                    style: base.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    transitionBuilder: (ctx, anim, _, child) {
      final curved = CurvedAnimation(parent: anim, curve: Curves.easeOutBack);
      return FadeTransition(
        opacity: anim,
        child: ScaleTransition(
            scale: Tween(begin: 0.85, end: 1.0).animate(curved), child: child),
      );
    },
  );
}
