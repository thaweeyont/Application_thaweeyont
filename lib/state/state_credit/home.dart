import 'package:application_thaweeyont/state/state_credit/navigator_bar_credit.dart';
import 'package:application_thaweeyont/utility/my_constant.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home_credit extends StatefulWidget {
  const Home_credit({Key? key}) : super(key: key);

  @override
  State<Home_credit> createState() => _Home_creditState();
}

class _Home_creditState extends State<Home_credit> {
  String userId = '', empId = '', firstName = '', lastName = '', tokenId = '';
  bool? allowApproveStatus;
  DateTime selectedDate = DateTime.now();
  var formattedDate, year;

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
    double size = MediaQuery.of(context).size.width;
    double size_h = MediaQuery.of(context).size.height * 0.005;
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
                  color: Colors.grey.withOpacity(0.5),
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
                        color: Colors.white.withOpacity(0.1),
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
                  color: Colors.grey.withOpacity(0.5),
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
          SingleChildScrollView(
            child: Container(
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
                    const SizedBox(height: 20),
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
                                '13 กันยายน 2566',
                                style: MyContant().TextAbout(),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'เรียนผู้ใช้งานระบบทุกท่าน ทางนักพัฒนาระบบได้ทำการย้ายรายการเมนูทั้งหมดเข้าไปอยู่ในแถบด้านซ้ายทั้งหมด โดยให้ผู้ใช้ทุกท่านเข้ารายการเมนูจากแถบด้านซ้ายและแถบด้านล่าง',
                                  style: MyContant().TextInputStyle(),
                                  overflow: TextOverflow.clip,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );

    // child: GridView.count(
    //   primary: false,
    //   padding: const EdgeInsets.all(20),
    //   crossAxisSpacing: 10,
    //   mainAxisSpacing: 10,
    //   crossAxisCount: 1,
    //   childAspectRatio: size_h,
    //   children: <Widget>[
    //     check_approve(size),
    //     check_information(size),
    //     check_blacklist(size),
    //     check_statususer(size),
    //     check_buyproduct(size),
    //   ],
    // ),
  }

  Container check_information(double size) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      // height: size * 300,
      // alignment: Alignment.center,
      // padding: EdgeInsets.all(20),
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => Navigator_bar_credit('0'),
            ),
            (Route<dynamic> route) => false,
          );
        },
        icon: Icon(
          Icons.people,
          size: size * 0.12,
        ),
        label: Text(
          'สอบถามรายละเอียดลูกหนี้',
          overflow: TextOverflow.clip,
          textAlign: TextAlign.center,
          style: MyContant().TextMenulist(),
        ), //label text
        style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(
                255, 152, 238, 1) //elevated btton background color
            ),
      ),
    );
  }

  Container check_buyproduct(double size) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      // height: size * 300,
      // alignment: Alignment.center,
      // padding: EdgeInsets.all(20),
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => Navigator_bar_credit('1'),
            ),
            (Route<dynamic> route) => false,
          );
        },
        icon: Icon(
          Icons.local_mall_rounded,
          size: size * 0.12,
        ),
        label: Text(
          'ตรวจสอบข้อมูลการซื้อสินค้า',
          overflow: TextOverflow.clip,
          textAlign: TextAlign.center,
          style: MyContant().TextMenulist(),
        ), //label text
        style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(
                212, 151, 233, 1) //elevated btton background color
            ),
      ),
    );
  }

  Container check_approve(double size) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      // height: size * 300,
      // alignment: Alignment.center,
      // padding: EdgeInsets.all(20),
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => Navigator_bar_credit('3'),
            ),
            (Route<dynamic> route) => false,
          );
        },
        icon: Icon(
          Icons.manage_accounts_rounded,
          size: size * 0.12,
        ),
        label: allowApproveStatus == true
            ? Text(
                'บันทึกพิจารณาอนุมัติสินเชื่อ',
                overflow: TextOverflow.clip,
                textAlign: TextAlign.center,
                style: MyContant().TextMenulist(),
              )
            : Text(
                'ตรวจสอบผลพิจารณาสินเชื่อ',
                overflow: TextOverflow.clip,
                textAlign: TextAlign.center,
                style: MyContant().TextMenulist(),
              ), //label text
        style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(
                251, 713, 55, 1) //elevated btton background color
            ),
      ),
    );
  }

  Container check_statususer(double size) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      // height: size * 300,
      // alignment: Alignment.center,
      // padding: EdgeInsets.all(20),
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => Navigator_bar_credit('4'),
            ),
            (Route<dynamic> route) => false,
          );
        },
        icon: Icon(
          Icons.switch_account_outlined,
          size: size * 0.12,
        ),
        label: Text(
          'สถานะสมาชิกทวียนต์',
          overflow: TextOverflow.clip,
          textAlign: TextAlign.center,
          style: MyContant().TextMenulist(),
        ), //label text
        style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(
                64, 203, 203, 1) //elevated btton background color
            ),
      ),
    );
  }

  Container check_blacklist(double size) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      // height: size * 300,
      // alignment: Alignment.center,
      // padding: EdgeInsets.all(20),
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => Navigator_bar_credit('5'),
            ),
            (Route<dynamic> route) => false,
          );
        },
        icon: Icon(
          Icons.person_off_rounded,
          size: size * 0.12,
        ),
        label: Text(
          'สอบถามรายละเอียด BlackList',
          overflow: TextOverflow.clip,
          textAlign: TextAlign.center,
          style: MyContant().TextMenulist(),
        ), //label text
        style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(
                162, 181, 252, 1) //elevated btton background color
            ),
      ),
    );
  }

//-----------------------------เมนูเดิม----------------------------------------------------------------------
  InkWell check_approve_n(double size) {
    return InkWell(
      onTap: () => Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Navigator_bar_credit('3')),
        (Route<dynamic> route) => false,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color.fromRGBO(251, 713, 55, 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.manage_accounts_rounded,
                  size: size * 0.12,
                  color: Colors.white,
                ),
                const SizedBox(width: 15),
                const Text(
                  'เช็คผลการพิจารณาสินเชื่อ',
                  overflow: TextOverflow.clip,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Prompt',
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  InkWell check_statususer_n(double size) {
    return InkWell(
      onTap: () => Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Navigator_bar_credit('4')),
        (Route<dynamic> route) => false,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color.fromRGBO(64, 203, 203, 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.switch_account_outlined,
                  size: size * 0.12,
                  color: Colors.white,
                ),
                const SizedBox(width: 15),
                const Text(
                  'สถานะสมาชิกทวียนต์',
                  overflow: TextOverflow.clip,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Prompt',
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  InkWell check_buyproduct_n(double size) {
    return InkWell(
      onTap: () => Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Navigator_bar_credit('1')),
        (Route<dynamic> route) => false,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color.fromRGBO(212, 151, 233, 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shopping_basket_rounded,
                  size: size * 0.12,
                  color: Colors.white,
                ),
                const SizedBox(width: 15),
                const Text(
                  'ตรวจสอบข้อมูลการซื้อสินค้า',
                  overflow: TextOverflow.clip,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Prompt',
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  InkWell check_blacklist_n(double size) {
    return InkWell(
      onTap: () => Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Navigator_bar_credit('5')),
        (Route<dynamic> route) => false,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color.fromRGBO(162, 181, 252, 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.person_off_rounded,
                  size: size * 0.12,
                  color: Colors.white,
                ),
                const SizedBox(width: 15),
                const Text(
                  'สอบถามรายละเอียด BlackList',
                  overflow: TextOverflow.clip,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Prompt',
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  InkWell check_information_n(double size) {
    return InkWell(
      onTap: () => Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => Navigator_bar_credit('0'),
        ),
        (Route<dynamic> route) => false,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color.fromRGBO(255, 152, 238, 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.people,
                  size: size * 0.12,
                  color: Colors.white,
                ),
                const SizedBox(width: 15),
                const Text(
                  'สอบถามรายละเอียดลูกหนี้',
                  overflow: TextOverflow.clip,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Prompt',
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
