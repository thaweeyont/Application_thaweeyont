import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../utility/my_constant.dart';

class MechanicalDetail extends StatefulWidget {
  const MechanicalDetail({Key? key}) : super(key: key);

  @override
  State<MechanicalDetail> createState() => _MechanicalDetailState();
}

class _MechanicalDetailState extends State<MechanicalDetail> {
  String userId = '', empId = '', firstName = '', lastName = '', tokenId = '';
  double? lat, lng;
  bool statusChecklocation = false, statuSuccess = false;
  late WebViewController controller;
  String sampleHTML = '';

  @override
  void initState() {
    super.initState();
  }

  Future<void> getdata() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      userId = preferences.getString('userId')!;
      empId = preferences.getString('empId')!;
      firstName = preferences.getString('firstName')!;
      lastName = preferences.getString('lastName')!;
      tokenId = preferences.getString('tokenId')!;
    });
  }

  Future<void> webView(lat, lng) async {
    sampleHTML = '''<iframe
                    class="size-google-map"
                    style="border:0;border-radius: 15px;  width: 100%;height: 100%;"
                    loading="lazy"
                    allowfullscreen
                    src="https://www.google.com/maps/embed/v1/place?key=AIzaSyAqWnK3U_cSqW-rM_6inkVwHEJRDgTcUBI
                    &q=$lat,$lng&zoom=20">
                    </iframe>''';
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadHtmlString(sampleHTML);
    controller.reload();
  }

// getLocationNew
  Future<void> getLocation() async {
    bool locationService;
    LocationPermission locationPermission;

    locationService = await Geolocator.isLocationServiceEnabled();
    if (locationService) {
      print('Service Location Open');
      locationPermission = await Geolocator.checkPermission();
      if (locationPermission == LocationPermission.denied) {
        locationPermission = await Geolocator.requestPermission();
        if (locationPermission == LocationPermission.deniedForever) {
          showProgressDialog(
              context, 'ไม่อนุญาติแชร์ Location', 'โปรดแชร์ location');
        } else {
          findLatLng();
        }
      } else {
        if (locationPermission == LocationPermission.deniedForever) {
          showProgressDialog(
              context, 'ไม่อนุญาติแชร์ Location', 'โปรดแชร์ location');
        } else {
          findLatLng();
        }
      }
    } else {
      print('Service Location Close');
      showProgressDialog(
          context, 'Location ปิดอยู่?', 'กรุณาเปิด Location ด้วยคะ');
    }
  }

  Future<void> findLatLng() async {
    Position? position = await findPosition();
    setState(() {
      lat = position!.latitude;
      lng = position.longitude;
      // statusChecklocation = true;
      print('lat> = $lat, lng> = $lng');
      Navigator.pop(context);
      // webView(lat, lng);
    });
  }

  Future<Position?> findPosition() async {
    Position position;
    try {
      position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      return position;
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'รายละเอียดของลูกค้า',
          style: MyContant().TitleStyle(),
        ),
      ),
      body: ListView(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 241, 209, 89),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 0.5,
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      )
                    ],
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'ชื่อ-สกุล : ',
                              style: MyContant().h6Style(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Text(
                              'ที่อยู่ในเอกสารขาย : ',
                              style: MyContant().h6Style(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Text(
                              'โทรศัพท์มือถือ : ',
                              style: MyContant().h6Style(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Text(
                              'โทรศัพท์บ้าน : ',
                              style: MyContant().h6Style(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Text(
                              'โทรศัพท์ที่ทำงาน : ',
                              style: MyContant().h6Style(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Text(
                              'เลขที่ใบขอช่าง : ',
                              style: MyContant().h6Style(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Text(
                              'วันที่จัดส่ง : ',
                              style: MyContant().h6Style(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 241, 209, 89),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 0.5,
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: Row(
                          children: [
                            Text(
                              'รายการสินค้า',
                              style: MyContant().h6Style(),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 2),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'คลัง MK',
                                    style: MyContant().h6Style(),
                                  ),
                                  Text(
                                    'จำนวน 11 เครื่อง',
                                    style: MyContant().h6Style(),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'ACONATIC ตู้เย็น 1 ประตู รุ่น AN-FR1750 ความจุ 6.0 คิว สี Drak Gray รับประกัน 10 ปี',
                                      style: MyContant().h6Style(),
                                      overflow: TextOverflow.clip,
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  Text(
                                    'เลขที่เครื่อง : ',
                                    style: MyContant().h6Style(),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 241, 209, 89),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 0.5,
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: Row(
                          children: [
                            Text(
                              'ที่อยู่จัดส่งสินค้า',
                              style: MyContant().h6Style(),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 2),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      '283 ม. 1 เหล่าพนาวัล ต. แม่ข้าวต้ม อ. เมืองเชียงราย จ. เชียงราย 57100 โทร. 0897599652',
                                      style: MyContant().h6Style(),
                                      overflow: TextOverflow.clip,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 2),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.038,
                                      width: MediaQuery.of(context).size.width *
                                          0.62,
                                      child: ElevatedButton.icon(
                                        label: Text(
                                          'กดเพื่อขอพิกัดตำแหน่ง',
                                          style: MyContant().textLoading(),
                                        ),
                                        icon: const Icon(
                                          Icons.pin_drop_rounded,
                                        ),
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color.fromARGB(
                                              255, 0, 155, 247),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
