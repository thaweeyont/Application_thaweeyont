import 'dart:convert';
import 'dart:ffi';

import 'package:application_thaweeyont/state/state_credit/navigator_bar_credit.dart';
import 'package:flutter/material.dart';
import 'package:application_thaweeyont/utility/my_constant.dart';
import 'package:application_thaweeyont/widgets/show_image.dart';
import 'package:application_thaweeyont/widgets/show_title.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../model/login_model.dart';

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

  Future<void> login_user(String id_card) async {
    try {
      var respose = await http.post(
        Uri.parse('https://twyapp.com/twyapi/apiV1/authen/'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'userName': username.text.toString(),
          'passWord': password.text.toString()
        }),
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> data =
            new Map<String, dynamic>.from(json.decode(respose.body));
        if (data['status'] == 'success') {
          var userId = data['data']['userId'];
          var empId = data['data']['empId'];
          var firstName = data['data']['firstName'];
          var lastName = data['data']['lastName'];
          var tokenId = data['data']['tokenId'];

          SharedPreferences preferences = await SharedPreferences.getInstance();
          preferences.setString('userId', userId!);
          preferences.setString('empId', empId!);
          preferences.setString('firstName', firstName!);
          preferences.setString('lastName', lastName!);
          preferences.setString('tokenId', tokenId!);

          print(data['data']);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => Navigator_bar_credit('2')),
            (Route<dynamic> route) => false,
          );
        } else {
          print('ไม่มีข้อมูล');
          showProgressDialog(context, 'แจ้งเตือน', 'ไม่พบข้อมูลของ User นี้');
        }
      } else {
        print('ไม่มีข้อมูล');
        showProgressDialog(context, 'แจ้งเตือน', 'ไม่พบข้อมูลของ User นี้');
      }
    } catch (e) {
      print("ไม่มีข้อมูล $e");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getprofile_user();
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
            const EdgeInsets.only(left: 30, right: 30, top: 60, bottom: 60),
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
                  textStyle: const TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  login_user(username.text);
                },
                child: const Text('เข้าสู่ระบบ'),
              ),
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
        Column(
          children: [
            SizedBox(
              height: size * 0.20,
            ),
            Container(
              width: size * 0.8,
              child: ShowImage(path: MyContant.logo_login),
            ),
          ],
        ),
      ],
    );
  }
}
