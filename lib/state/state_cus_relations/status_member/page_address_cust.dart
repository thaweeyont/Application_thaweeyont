import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../api.dart';
import '../../../utility/dialog.dart';
import '../../../utility/my_constant.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;
import 'package:webview_flutter/webview_flutter.dart';

import '../../../widgets/custom_appbar.dart';
import '../../authen.dart';

class AddressCust extends StatefulWidget {
  final String? custId, addressId, type, detail, tel, fax, latOld, lngOld;
  const AddressCust(this.custId, this.addressId, this.type, this.detail,
      this.tel, this.fax, this.latOld, this.lngOld,
      {Key? key})
      : super(key: key);

  @override
  State<AddressCust> createState() => _AddressCustState();
}

class _AddressCustState extends State<AddressCust> {
  String userId = '', empId = '', firstName = '', lastName = '', tokenId = '';
  double? lat, lng;
  double? editlat, editlng;
  String loca = '';
  bool statusChecklocation = false, statuSuccess = false;
  late WebViewController controller;
  String sampleHTML = '';

  @override
  void initState() {
    super.initState();
    checkLatLng();
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

  Future<void> checkLatLng() async {
    if (widget.latOld.toString().isNotEmpty &&
        widget.lngOld.toString().isNotEmpty) {
      lat = double.parse(widget.latOld.toString());
      lng = double.parse(widget.lngOld.toString());
      setState(() {
        statusChecklocation = true;
      });
    } else {
      lat = 0.0;
      lng = 0.0;
      setState(() {
        statusChecklocation = false;
      });
    }
    webView(lat, lng);
  }

  Future<void> upLocationCust(latitude, longitude, from) async {
    try {
      var respose = await http.post(
        Uri.parse('${api}customer/updLocation'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
        body: jsonEncode(<String, String>{
          'custId': widget.custId.toString(),
          'addressId': widget.addressId.toString(),
          'lat': latitude.toString(),
          'lng': longitude.toString(),
        }),
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> upLocationData =
            Map<String, dynamic>.from(json.decode(respose.body));

        if (upLocationData['status'] == 'success') {
          if (from == 'submit') {
            Navigator.pop(context);
            successDialog(
                context, 'สำเร็จ', 'บันทึกตำแหน่งเสร็จสิ้น', 'submit');
            setState(() {
              statusChecklocation = true;
              statuSuccess = true;
            });
          } else if (from == 'edit') {
            Navigator.pop(context);
            successDialog(context, 'สำเร็จ', 'แก้ไขตำแหน่งเสร็จสิ้น', 'edit');

            setState(() {
              lat = editlat;
              lng = editlng;
            });
            webView(lat, lng);
          }
        }
      } else if (respose.statusCode == 400) {
        showProgressDialog_400(context, 'แจ้งเตือน', 'ละติจูด ลองติจูด ซ้ำ');
      } else if (respose.statusCode == 401) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.clear();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const Authen(),
          ),
          (Route<dynamic> route) => false,
        );
        showProgressDialog_401(
            context, 'แจ้งเตือน', 'กรุณา Login เข้าสู่ระบบใหม่');
      } else if (respose.statusCode == 404) {
        showProgressDialog_404(context, 'แจ้งเตือน', 'เกืดข้อผิดพลาด');
      } else if (respose.statusCode == 405) {
        showProgressDialog_405(
            context, 'แจ้งเตือน', 'ไม่พบข้อมูล (${respose.statusCode})');
      } else if (respose.statusCode == 500) {
        showProgressDialog_500(
            context, 'แจ้งเตือน', 'ข้อมูลผิดพลาด (${respose.statusCode})');
      } else {
        showProgressDialog(context, 'แจ้งเตือน', 'กรุณาติดต่อผู้ดูแลระบบ');
      }
    } catch (e) {
      print("ไม่มีข้อมูล $e");
      showProgressDialog_Notdata(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
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
      statusChecklocation = true;
      print('lat> = $lat, lng> = $lng');
      Navigator.pop(context);
      webView(lat, lng);
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

  // getLocationEdit
  Future<void> getEditLocation() async {
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
          editfindLatLng();
        }
      } else {
        if (locationPermission == LocationPermission.deniedForever) {
          showProgressDialog(
              context, 'ไม่อนุญาติแชร์ Location', 'โปรดแชร์ location');
        } else {
          editfindLatLng();
        }
      }
    } else {
      print('Service Location Close');
      showProgressDialog(
          context, 'Location ปิดอยู่?', 'กรุณาเปิด Location ด้วยคะ');
    }
  }

  Future<void> editfindLatLng() async {
    Position? position = await editfindPosition();
    setState(() {
      editlat = position!.latitude;
      editlng = position.longitude;
      Navigator.pop(context);
      editLocation(context, editlat, editlng);
    });
  }

  Future<Position?> editfindPosition() async {
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
      appBar: const CustomAppbar(title: 'ข้อมูลที่อยู่'),
      body: ListView(
        shrinkWrap: true,
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(64, 203, 203, 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'ประเภท : ${widget.type}',
                            style: MyContant().h4normalStyle(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.7),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ที่อยู่ : ',
                                  style: MyContant().h4normalStyle(),
                                ),
                                Expanded(
                                  child: Text(
                                    '${widget.detail}',
                                    overflow: TextOverflow.clip,
                                    style: MyContant().h4normalStyle(),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'เบอร์โทรศัพท์ : ${widget.tel}',
                                  style: MyContant().h4normalStyle(),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'เบอร์แฟกซ์ : ${widget.fax}',
                                  style: MyContant().h4normalStyle(),
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(64, 203, 203, 1),
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'พิกัดตำแหน่ง',
                            style: MyContant().h4normalStyle(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.7),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  'ละติจูด : $lat $loca',
                                  style: MyContant().h4normalStyle(),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'ลองติจูด : $lng $loca',
                                  style: MyContant().h4normalStyle(),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.7),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if ((widget.latOld.toString().isEmpty &&
                                        widget.lngOld.toString().isEmpty) &&
                                    statusChecklocation == false)
                                  Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.038,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.62,
                                          child: ElevatedButton.icon(
                                            label: Text(
                                              'กดเพื่อขอพิกัดตำแหน่ง',
                                              style: MyContant().textLoading(),
                                            ),
                                            icon: const Icon(
                                              Icons.pin_drop_rounded,
                                              color: Colors.white,
                                            ),
                                            onPressed: () {
                                              showProgressEarthLoad(context);
                                              getLocation();
                                            },
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                        255, 87, 109, 225)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                else
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          if ((widget.latOld
                                                      .toString()
                                                      .isEmpty &&
                                                  widget.lngOld
                                                      .toString()
                                                      .isEmpty) &&
                                              statuSuccess == false)
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 3,
                                                      vertical: 8),
                                              child: SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.038,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.25,
                                                child: ElevatedButton.icon(
                                                  label: Text(
                                                    'บันทึก',
                                                    style:
                                                        MyContant().textSmall(),
                                                  ),
                                                  icon: Icon(
                                                    Icons.pin_drop_rounded,
                                                    size: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.05,
                                                  ),
                                                  onPressed: () {
                                                    showProgressLoading2(
                                                        context);
                                                    upLocationCust(
                                                        lat, lng, 'submit');
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        const Color.fromARGB(
                                                            255, 52, 168, 83),
                                                  ),
                                                ),
                                              ),
                                            )
                                          else
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 3,
                                                      vertical: 8),
                                              child: SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.038,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.25,
                                                child: ElevatedButton.icon(
                                                  label: Text(
                                                    'แก้ไข',
                                                    style:
                                                        MyContant().textSmall(),
                                                  ),
                                                  icon: Icon(
                                                    Icons.pin_drop_rounded,
                                                    size: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.05,
                                                  ),
                                                  onPressed: () {
                                                    showProgressEarthLoad(
                                                        context);
                                                    getEditLocation();
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        const Color.fromARGB(
                                                            255, 255, 232, 21),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 3, vertical: 8),
                                            child: SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.038,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.28,
                                              child: ElevatedButton.icon(
                                                label: Text(
                                                  'ดูแผนที่',
                                                  style:
                                                      MyContant().textSmall(),
                                                ),
                                                icon: Icon(
                                                  Icons.map_outlined,
                                                  size: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.05,
                                                ),
                                                onPressed: () async {
                                                  Uri googleMapUrl = Uri.parse(
                                                    'https://www.google.co.th/maps/search/?api=1&query=$lat,$lng',
                                                  );

                                                  if (!await launcher.launchUrl(
                                                    googleMapUrl,
                                                    mode: launcher.LaunchMode
                                                        .externalApplication,
                                                  )) {
                                                    throw Exception(
                                                        'Could not open the map $googleMapUrl');
                                                  }
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      const Color.fromARGB(
                                                          255, 87, 109, 225),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 3, vertical: 8),
                                            child: SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.038,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.28,
                                              child: ElevatedButton.icon(
                                                label: Text(
                                                  'เส้นทาง',
                                                  style:
                                                      MyContant().textSmall(),
                                                ),
                                                icon: Icon(
                                                  Icons.assistant_navigation,
                                                  size: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.05,
                                                ),
                                                onPressed: () async {
                                                  Uri googleMapUrl = Uri.parse(
                                                    'https://www.google.com/maps/dir/Current+Location/$lat,$lng',
                                                  );

                                                  if (!await launcher.launchUrl(
                                                    googleMapUrl,
                                                    mode: launcher.LaunchMode
                                                        .externalApplication,
                                                  )) {
                                                    throw Exception(
                                                        'Could not open the map $googleMapUrl');
                                                  }
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        const Color.fromARGB(
                                                            255, 26, 115, 232)),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (lat != 0.0 && lng != 0.0) ...[
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(10),
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.4,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.7),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          child: WebViewWidget(controller: controller),
                        )
                      ],
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

  Future<void> editLocation(BuildContext context, elat, elng) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 60),
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 0,
                  color: Colors.white,
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 12, bottom: 6),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'แก้ไขตำแหน่งที่ตั้ง',
                                      style: MyContant().h4normalStyle(),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            right: 0,
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                child: Icon(
                                  Icons.close,
                                  size: 30,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(
                        color: Color.fromARGB(255, 138, 138, 138),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(5),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 0.2,
                                blurRadius: 2,
                                offset: const Offset(0, 1),
                              )
                            ],
                            color: const Color.fromRGBO(64, 203, 203, 1),
                          ),
                          padding: const EdgeInsets.all(8),
                          width: double.infinity,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: const CircleBorder(),
                                      backgroundColor: const Color.fromARGB(
                                          255, 255, 255, 255),
                                    ),
                                    onPressed: () {},
                                    child: const Icon(
                                      Icons.edit_location_alt,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.7),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'ละติจูดใหม่ : $elat',
                                          style: MyContant().h4normalStyle(),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'ลองติจูดใหม่ : $elng',
                                          style: MyContant().h4normalStyle(),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    '*ตรวจสอบความถูกต้องก่อนแก้ไข*',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontFamily: 'Prompt',
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 3, vertical: 8),
                                    child: SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.038,
                                      width: MediaQuery.of(context).size.width *
                                          0.28,
                                      child: ElevatedButton.icon(
                                        label: Text(
                                          'ดูแผนที่',
                                          style: MyContant().textSmall(),
                                        ),
                                        icon: Icon(
                                          Icons.map_outlined,
                                          size: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.05,
                                        ),
                                        onPressed: () async {
                                          Uri googleMapUrl = Uri.parse(
                                            'https://www.google.co.th/maps/search/?api=1&query=$elat,$elng',
                                          );

                                          if (!await launcher.launchUrl(
                                            googleMapUrl,
                                            mode: launcher
                                                .LaunchMode.externalApplication,
                                          )) {
                                            throw Exception(
                                                'Could not open the map $googleMapUrl');
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color.fromARGB(
                                              255, 87, 109, 225),
                                        ),
                                      ),
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
                            horizontal: 8, vertical: 10),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.038,
                          width: MediaQuery.of(context).size.width * 0.28,
                          child: ElevatedButton.icon(
                            label: Text(
                              'แก้ไข',
                              style: MyContant().textSmall(),
                            ),
                            icon: Icon(
                              Icons.edit_location_alt,
                              size: MediaQuery.of(context).size.width * 0.05,
                            ),
                            onPressed: () async {
                              showProgressLoading2(context);
                              upLocationCust(elat, elng, 'edit');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 251, 231, 55),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
