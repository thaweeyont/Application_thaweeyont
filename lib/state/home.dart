import 'dart:async';

import 'package:application_thaweeyont/utility/my_constant.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
export 'disconnect.dart';

class Home_credit extends StatefulWidget {
  const Home_credit({super.key});

  @override
  State<Home_credit> createState() => _Home_creditState();
}

class _Home_creditState extends State<Home_credit> {
  String userId = '', empId = '', firstName = '', lastName = '', tokenId = '';
  bool? allowApproveStatus;
  DateTime selectedDate = DateTime.now();
  var formattedDate, year;

  bool statusConn = true;

  @override
  void initState() {
    super.initState();
    Intl.defaultLocale = 'th';
    initializeDateFormatting();
    getdata();
  }

  Future<void> getdata() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      userId = preferences.getString('userId')!;
      empId = preferences.getString('empId')!;
      firstName = preferences.getString('firstName')!;
      lastName = preferences.getString('lastName')!;
      tokenId = preferences.getString('tokenId')!;
      allowApproveStatus = preferences.getBool('allowApproveStatus');
    });
    selectDatenow();
  }

  void selectDatenow() {
    formattedDate = DateFormat('EEE d MMM').format(selectedDate);
    var formattedYear = DateFormat('yyyy').format(selectedDate);

    var yearnow = int.parse(formattedYear);
    year = [yearnow, 543].reduce((value, element) => value + element);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(242, 246, 249, 255),
      body: Stack(
        children: [
          Container(
            height: 220,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(60),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withAlpha(130),
                  spreadRadius: 0.2,
                  blurRadius: 7,
                  offset: const Offset(0, 1),
                )
              ],
              color: const Color.fromRGBO(5, 12, 69, 1),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 16, left: 20),
              child: Stack(
                children: [
                  Positioned(
                    top: 10,
                    right: -100,
                    child: Container(
                      width: 350,
                      height: 350,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(180),
                        ),
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            '$formattedDate $year',
                            style: MyContant().TextshowHome3(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Text(
                            'Welcome To',
                            style: MyContant().TextshowHome2(),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Thaweeyont',
                            style: MyContant().TextshowHome(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 180),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withAlpha(130),
                  spreadRadius: 0.2,
                  blurRadius: 7,
                  offset: const Offset(0, 1),
                )
              ],
            ),
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Image.asset(
                    'images/TWYLOGO.png',
                    height: MediaQuery.of(context).size.height * 0.08,
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 300),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'images/megaphone.png',
                        width: 25,
                        height: 25,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'ประกาศข่าวสาร',
                        style: MyContant().Textbold(),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 340),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 5),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromARGB(236, 240, 242, 255),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                '4 กรกฎาคม 2568',
                                style: MyContant().TextAbout(),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'ปรับปรุงประสิทธิภาพการทำงานและความเสถียรโดยรวมของแอปให้เป็นล่าสุดแล้ว',
                                  style: MyContant().textInputStyle(),
                                  overflow: TextOverflow.clip,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
