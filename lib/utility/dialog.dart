import 'package:flutter/material.dart';

Future<void> successDialog(
    BuildContext context, String title, String message, String status) async {
  showDialog(
    context: context,
    builder: (context) => Container(
      decoration: const BoxDecoration(
        shape: BoxShape.rectangle,
      ),
      child: SimpleDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
        title: ListTile(
          leading: Image.asset('images/success2.png'),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black,
              fontWeight: FontWeight.w700,
              fontFamily: 'Prompt',
            ),
          ),
          subtitle: Text(
            message,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontWeight: FontWeight.normal,
              fontFamily: 'Prompt',
            ),
          ),
        ),
        children: [
          TextButton(
            onPressed: () {
              if (status == 'submit') {
                Navigator.pop(context);
              } else if (status == 'edit') {
                Navigator.pop(context);
                Navigator.pop(context);
              }
            },
            child: Column(
              children: const [
                Text(
                  "ตกลง",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Prompt',
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

Future<void> showProgressEarthLoad(BuildContext context) async {
  showDialog(
    context: context,
    barrierColor: Colors.transparent,
    builder: (context) => PopScope(
      canPop: true, // เปลี่ยนเป็น false ถ้าไม่ให้ปิด dialog
      child: Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 24, 24, 24).withValues(alpha: 0.7),
            borderRadius: const BorderRadius.all(
              Radius.circular(0),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'images/earthLoading.gif',
                width: MediaQuery.of(context).size.width * 0.4,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
