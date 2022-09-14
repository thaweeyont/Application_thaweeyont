import 'dart:convert';
import 'dart:ffi';

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

    if (preferences.getString('name_user') != null) {
      Navigator.pushReplacementNamed(
        context,
        MyContant.routeNavigator_bar_credit,
      );
    }
  }

  Future<void> login_user(String id_card) async {
    // var headers = {'Content-Type': 'application/json;text/charset=utf-8'};
    // var request = http.Request(
    //     'POST', Uri.parse('https://twyapp.com/twyapi/apiV1/authen/'));
    // request.body = json.encode({"userName": "Jakkrit.i", "passWord": "1234"});
    // request.headers.addAll(headers);

    // http.get() response = await request.send();

    // if (response.statusCode == 200) {
    //   print(await response.stream.bytesToString());
    //   setState(() {
    //     datauser = authenToJson(response.stream) as List<Data>;
    //   });
    //   // print(datauser[0].)
    // } else {
    //   print(response.reasonPhrase);
    // }

    try {
      var respose = await http.post(
        Uri.parse('https://twyapp.com/twyapi/apiV1/authen/'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
            <String, String>{'userName': 'Jakkrit.i', 'passWord': '1234'}),
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> data =
            new Map<String, dynamic>.from(json.decode(respose.body));

        print(data['data']["firstName"]);
      }
    } catch (e) {
      print("ไม่มีข้อมูล $e");
      // showProgressDialog(context, 'แจ้งเตือน', 'เลขบัตรประชาชนนี้ไม่ถูกต้อง');
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
                  // if (idcard.text.isNotEmpty) {
                  //   login_user(idcard.text);
                  // } else {
                  //   showProgressDialog(
                  //       context, 'แจ้งเตือน', 'กรุณากรอกข้อมูลให้ถูกต้อง');
                  // }

                  // Navigator.pushReplacementNamed(
                  //     context, MyContant.routeNavigator_bar_credit);
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
