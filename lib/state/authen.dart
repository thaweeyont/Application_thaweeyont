import 'dart:convert';
import 'dart:async';

import 'package:application_thaweeyont/state/state_credit/navigator_bar_credit.dart';
import 'package:flutter/material.dart';
import 'package:application_thaweeyont/utility/my_constant.dart';
import 'package:application_thaweeyont/widgets/show_image.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:application_thaweeyont/api.dart';

import '../model/login_model.dart';
import 'package:package_info_plus/package_info_plus.dart';

class Authen extends StatefulWidget {
  const Authen({Key? key}) : super(key: key);

  @override
  State<Authen> createState() => _AuthenState();
}

class _AuthenState extends State<Authen> {
  bool statusRedEye = true;
  List<Login> datauser = [];
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  late String name;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getprofile_user();
    _initPackageInfo();
  }

  Future<Null> getprofile_user() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    if (preferences.getString('userId') != null) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Navigator_bar_credit('2')),
        (Route<dynamic> route) => false,
      );
    }
  }

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    // installerStore: 'Unknown',
  );

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  Future<void> login_user() async {
    try {
      var respose = await http.post(
        Uri.parse('${api}authen/'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'userName': username.text,
          'passWord': password.text,
        }),
      );

      if (respose.statusCode == 200) {
        print(respose.statusCode);
        Map<String, dynamic> data =
            new Map<String, dynamic>.from(json.decode(respose.body));
        if (data['status'] == 'success') {
          var userId = data['data']['userId'];
          var empId = data['data']['empId'];
          var firstName = data['data']['firstName'];
          var lastName = data['data']['lastName'];
          var tokenId = data['data']['tokenId'];
          var branchId = data['data']['branchId'];
          var branchName = data['data']['branchName'];
          bool allowApproveStatus = data['data']['allowApproveStatus'];

          SharedPreferences preferences = await SharedPreferences.getInstance();
          preferences.setString('userId', userId!);
          preferences.setString('empId', empId!);
          preferences.setString('firstName', firstName!);
          preferences.setString('lastName', lastName!);
          preferences.setString('tokenId', tokenId!);
          preferences.setString('branchId', branchId);
          preferences.setString('branchName', branchName);
          preferences.setBool('allowApproveStatus', allowApproveStatus);

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => Navigator_bar_credit('2')),
            (Route<dynamic> route) => false,
          );
        } else {
          print('ไม่มีข้อมูล');
        }
      } else if (respose.statusCode == 401) {
        
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.clear();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => Authen(),
          ),
          (Route<dynamic> route) => false,
        );
        showProgressDialog_401(
            context, 'แจ้งเตือน', 'กรุณา Login เข้าสู่ระบบใหม่');
      } else {
        Map<String, dynamic> check_list =
            new Map<String, dynamic>.from(json.decode(respose.body));
        
        print(check_list['message']);
        if (check_list['message'] == "ไม่พบชื่อเข้าใช้ระบบ") {
          print('ไม่พบชื่อเข้าใช้ระบบ');
          showProgressDialog(context, 'แจ้งเตือน', 'ไม่พบชื่อเข้าใช้ระบบ');
        } else if (check_list['message'] == "รหัสผ่านผิด") {
          print('รหัสผ่านผิด');
          showProgressDialog(context, 'แจ้งเตือน', 'รหัสผ่านไม่ถูกต้อง');
        } else if (check_list['message'] ==
            "ไม่สามารถใช้ Application ได้ กรุณาติดต่อผู้ดูแลระบบ") {
          showProgressDialog(context, 'แจ้งเตือน',
              'ไม่สามารถใช้ Application ได้ กรุณาติดต่อผู้ดูแลระบบ');
        }
      }
    } catch (e) {
      print("ไม่มีข้อมูล $e");
    }
  }

  Future<PackageInfo> _getPackageInfo() {
    return PackageInfo.fromPlatform();
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        color: Color.fromRGBO(5, 12, 69, 1),
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          behavior: HitTestBehavior.opaque,
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.topCenter,
                child: buildImage(size),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: buildform(size),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container buildform(double size) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
        color: Colors.white,
      ),
      // color: Colors.white,
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.48,
      child: Padding(
        padding:
            const EdgeInsets.only(left: 30, right: 30, top: 50, bottom: 30),
        child: Column(
          children: <Widget>[
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: username,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.account_circle_rounded,
                        color: Color.fromRGBO(7, 15, 82, 1),
                      ),
                      border: OutlineInputBorder(),
                      hintText: 'Username',
                      hintStyle: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Prompt',
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: size * 0.04),
            Expanded(
              child: TextField(
                controller: password,
                obscureText: statusRedEye,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        statusRedEye = !statusRedEye;
                      });
                    },
                    icon: statusRedEye
                        ? Icon(
                            Icons.remove_red_eye,
                            color: Colors.grey,
                          )
                        : Icon(
                            Icons.remove_red_eye_outlined,
                            color: Colors.grey,
                          ),
                  ),
                  prefixIcon: Icon(
                    Icons.key,
                    color: Color.fromRGBO(7, 15, 82, 1),
                  ),
                  border: OutlineInputBorder(),
                  hintText: 'Password',
                  hintStyle: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Prompt',
                  ),
                ),
              ),
            ),
            SizedBox(height: size * 0.04),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Color.fromRGBO(7, 15, 82, 1),
              ),
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(10.0),
                  textStyle:
                      const TextStyle(fontSize: 20, fontFamily: 'Prompt'),
                ),
                onPressed: () {
                  if (username.text.isEmpty || password.text.isEmpty) {
                    showProgressDialog(
                        context, 'แจ้งเตือน', 'กรุณากรอก User และ Password');
                  } else {
                    login_user();
                  }
                },
                child: const Text('เข้าสู่ระบบ'),
              ),
            ),
            // SizedBox(height: size * 0.04),
            showversion(),
          ],
        ),
      ),
    );
  }

  Container showversion() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 30,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'version ${_packageInfo.version}',
                  style: MyContant().Textversion(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Row buildImage(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 50),
          child: Column(
            children: [
              // SizedBox(
              //   height: MediaQuery.of(context).size.height * 0.1,
              // ),
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: ShowImage(path: MyContant.logo_login),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
