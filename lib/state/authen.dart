import 'dart:convert';
import 'dart:async';

import 'package:application_thaweeyont/state/navigator_bar_credit.dart';
import 'package:flutter/material.dart';
import 'package:application_thaweeyont/utility/my_constant.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:application_thaweeyont/api.dart';

import '../model/login_model.dart';
import 'package:package_info_plus/package_info_plus.dart';

class Authen extends StatefulWidget {
  const Authen({super.key});

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
    super.initState();
    getprofileUser();
    _initPackageInfo();
  }

  Future<void> getprofileUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.getString('userId') != null) {
      loginUser(
          preferences.getString('username'), preferences.getString('password'));
    } else {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.clear();
    }

    // if (preferences.getString('userId') != null) {
    //   Navigator.pushAndRemoveUntil(
    //     context,
    //     MaterialPageRoute(builder: (context) => Navigator_bar_credit('2')),
    //     (Route<dynamic> route) => false,
    //   );
    // }
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

  // Future<void> loginUser(username, password) async {
  //   try {
  //     var respose = await http.post(
  //       Uri.parse('${api}authen/'),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json',
  //       },
  //       body: jsonEncode(<String, String>{
  //         'userName': username.toString(),
  //         'passWord': password.toString(),
  //       }),
  //     );

  //     if (respose.statusCode == 200) {
  //       Map<String, dynamic> data =
  //           Map<String, dynamic>.from(json.decode(respose.body));

  //       if (data['status'] == 'success') {
  //         var userId = data['data']['userId'];
  //         var empId = data['data']['empId'];
  //         var firstName = data['data']['firstName'];
  //         var lastName = data['data']['lastName'];
  //         var tokenId = data['data']['tokenId'];
  //         var branchId = data['data']['branchId'];
  //         var branchName = data['data']['branchName'];
  //         var branchAreaId = data['data']['branchAreaId'];
  //         var branchAreaName = data['data']['branchAreaName'];
  //         var appGroupId = data['data']['appGroupId'];
  //         var appGroupName = data['data']['appGroupName'];
  //         bool allowApproveStatus = data['data']['allowApproveStatus'];
  //         List dataMenu = data['data']['allowedMenu'];
  //         final List<String> allowedMenu =
  //             dataMenu.map((e) => e.toString()).toList();

  //         SharedPreferences preferences = await SharedPreferences.getInstance();
  //         preferences.setString('userId', userId!);
  //         preferences.setString('empId', empId!);
  //         preferences.setString('firstName', firstName!);
  //         preferences.setString('lastName', lastName!);
  //         preferences.setString('tokenId', tokenId!);
  //         preferences.setString('branchId', branchId);
  //         preferences.setString('branchName', branchName);
  //         preferences.setString('branchAreaId', branchAreaId);
  //         preferences.setString('branchAreaName', branchAreaName);
  //         preferences.setString('appGroupId', appGroupId);
  //         preferences.setString('appGroupName', appGroupName);
  //         preferences.setBool('allowApproveStatus', allowApproveStatus);
  //         preferences.setStringList('allowedMenu', allowedMenu);
  //         preferences.setString('username', username);
  //         preferences.setString('password', password);

  //         Navigator.pushAndRemoveUntil(
  //           context,
  //           MaterialPageRoute(builder: (context) => NavigatorBarMenu('2')),
  //           (Route<dynamic> route) => false,
  //         );
  //       } else {
  //         print('ไม่มีข้อมูล');
  //       }
  //     } else if (respose.statusCode == 401) {
  //       SharedPreferences preferences = await SharedPreferences.getInstance();
  //       preferences.clear();
  //       Navigator.pushAndRemoveUntil(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => const Authen(),
  //         ),
  //         (Route<dynamic> route) => false,
  //       );
  //       showProgressDialog_401(
  //           context, 'แจ้งเตือน', 'กรุณา Login เข้าสู่ระบบใหม่');
  //     } else {
  //       Map<String, dynamic> check_list =
  //           Map<String, dynamic>.from(json.decode(respose.body));

  //       print(check_list['message']);
  //       if (check_list['message'] == "ไม่พบชื่อเข้าใช้ระบบ") {
  //         SharedPreferences preferences = await SharedPreferences.getInstance();
  //         preferences.clear();
  //         print('ไม่พบชื่อเข้าใช้ระบบ');
  //         showProgressDialog(context, 'แจ้งเตือน', 'ไม่พบชื่อเข้าใช้ระบบ');
  //       } else if (check_list['message'] == "รหัสผ่านผิด") {
  //         print('รหัสผ่านผิด');
  //         showProgressDialog(context, 'แจ้งเตือน', 'รหัสผ่านไม่ถูกต้อง');
  //       } else if (check_list['message'] ==
  //           "ไม่สามารถใช้ Application ได้ กรุณาติดต่อผู้ดูแลระบบ") {
  //         SharedPreferences preferences = await SharedPreferences.getInstance();
  //         preferences.clear();
  //         showProgressDialog(context, 'แจ้งเตือน',
  //             'ไม่สามารถใช้ Application ได้ กรุณาติดต่อผู้ดูแลระบบ');
  //       }
  //     }
  //   } catch (e) {
  //     print("ไม่มีข้อมูล $e");
  //   }
  // }

  Future<void> loginUser(username, password) async {
    try {
      final response = await http.post(
        Uri.parse('${api}authen/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userName': username, 'passWord': password}),
      );

      final prefs = await SharedPreferences.getInstance();

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;

        if (data['status'] == 'success') {
          final d = data['data'];

          // เก็บค่าใน SharedPreferences
          await prefs.setString('userId', d['userId'] ?? '');
          await prefs.setString('empId', d['empId'] ?? '');
          await prefs.setString('firstName', d['firstName'] ?? '');
          await prefs.setString('lastName', d['lastName'] ?? '');
          await prefs.setString('tokenId', d['tokenId'] ?? '');
          await prefs.setString('branchId', d['branchId'] ?? '');
          await prefs.setString('branchName', d['branchName'] ?? '');
          await prefs.setString('branchAreaId', d['branchAreaId'] ?? '');
          await prefs.setString('branchAreaName', d['branchAreaName'] ?? '');
          await prefs.setString('appGroupId', d['appGroupId'] ?? '');
          await prefs.setString('appGroupName', d['appGroupName'] ?? '');
          await prefs.setBool(
              'allowApproveStatus', d['allowApproveStatus'] ?? false);
          await prefs.setStringList(
            'allowedMenu',
            (d['allowedMenu'] as List).map((e) => e.toString()).toList(),
          );

          if (d['itemBrandPC'] != null && d['itemBrandPC'] is List) {
            final itemBrandPC = (d['itemBrandPC'] as List)
                .map(
                    (e) => jsonEncode(e)) // ✅ แปลงแต่ละ object เป็น JSON string
                .toList();

            await prefs.setStringList('itemBrandPC', itemBrandPC);
          } else {
            await prefs.remove('itemBrandPC');
            print('⚠️ ไม่มีข้อมูล itemBrandPC');
          }
          await prefs.setString('username', username);
          await prefs.setString('password', password);

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => NavigatorBarMenu('2')),
            (_) => false,
          );
        } else {
          print('ไม่มีข้อมูล');
        }
      } else if (response.statusCode == 401) {
        await prefs.clear();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const Authen()),
          (_) => false,
        );
        showProgressDialog_401(
            context, 'แจ้งเตือน', 'กรุณา Login เข้าสู่ระบบใหม่');
      } else {
        final error = json.decode(response.body) as Map<String, dynamic>;
        final message = error['message'] ?? '';

        if (message == "ไม่พบชื่อเข้าใช้ระบบ") {
          await prefs.clear();
          showProgressDialog(context, 'แจ้งเตือน', 'ไม่พบชื่อเข้าใช้ระบบ');
        } else if (message == "รหัสผ่านผิด") {
          showProgressDialog(context, 'แจ้งเตือน', 'รหัสผ่านไม่ถูกต้อง');
        } else if (message ==
            "ไม่สามารถใช้ Application ได้ กรุณาติดต่อผู้ดูแลระบบ") {
          await prefs.clear();
          showProgressDialog(context, 'แจ้งเตือน', message);
        } else {
          print('Error: $message');
        }
      }
    } catch (e) {
      print("เกิดข้อผิดพลาด $e");
    }
  }

  Future<PackageInfo> getPackageInfo() {
    return PackageInfo.fromPlatform();
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        color: Colors.white,
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
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
        color: Colors.white,
      ),
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
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                      prefixIcon: const Icon(
                        Icons.account_circle_rounded,
                        color: Color.fromRGBO(7, 15, 82, 1),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      hintText: 'Username',
                      hintStyle: const TextStyle(
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
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        statusRedEye = !statusRedEye;
                      });
                    },
                    icon: statusRedEye
                        ? const Icon(
                            Icons.remove_red_eye,
                            color: Colors.grey,
                          )
                        : const Icon(
                            Icons.remove_red_eye_outlined,
                            color: Colors.grey,
                          ),
                  ),
                  prefixIcon: const Icon(
                    Icons.key,
                    color: Color.fromRGBO(7, 15, 82, 1),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  hintText: 'Password',
                  hintStyle: const TextStyle(
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
                borderRadius: BorderRadius.circular(30),
                color: const Color.fromRGBO(7, 15, 82, 1),
              ),
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(12),
                  textStyle: const TextStyle(
                    fontSize: 20,
                    fontFamily: 'Prompt',
                  ),
                ),
                onPressed: () {
                  if (username.text.isEmpty || password.text.isEmpty) {
                    showProgressDialog(
                        context, 'แจ้งเตือน', 'กรุณากรอก User และ Password');
                  } else {
                    loginUser(username.text, password.text);
                  }
                },
                child: const Text('เข้าสู่ระบบ'),
              ),
            ),
            showversion(),
          ],
        ),
      ),
    );
  }

  Padding showversion() {
    return Padding(
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
    );
  }

  Container buildImage(double size) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.55,
      decoration: const BoxDecoration(
        color: Color.fromRGBO(5, 12, 69, 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.15,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Image.asset(
                  'images/logoNew.png',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
