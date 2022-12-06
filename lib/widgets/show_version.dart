import 'dart:async';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:application_thaweeyont/utility/my_constant.dart';

class ShowVersion extends StatefulWidget {
  const ShowVersion({Key? key}) : super(key: key);

  @override
  State<ShowVersion> createState() => _ShowVersionState();
}

class _ShowVersionState extends State<ShowVersion> {
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    // installerStore: 'Unknown',
  );

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  Future<PackageInfo> _getPackageInfo() {
    return PackageInfo.fromPlatform();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        showProgressDialog_version(context, 'version ${_packageInfo.version}',
            'แอปพลิเคชั่นเป็นเวอร์ชั่นปัจจุบัน');
      },
      child: Container(
        margin: EdgeInsets.only(left: size * 0.15, bottom: 15),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), bottomLeft: Radius.circular(30)),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.refresh_outlined),
                SizedBox(width: 10),
                Text(
                  "เวอร์ชั่นแอป",
                  style: TextStyle(
                      color: Colors.black, fontSize: 16, fontFamily: 'Prompt'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<Null> showProgressDialog_version(
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
            leading: Image.asset('images/checked.png'),
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
}
