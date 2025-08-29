import 'dart:convert';

import 'package:application_thaweeyont/state/state_cus_relations/status_member/member_cust_list.dart';
import 'package:application_thaweeyont/widgets/custom_appbar.dart';
import 'package:application_thaweeyont/widgets/endpage.dart';
import 'package:application_thaweeyont/widgets/loaddata.dart';
import 'package:flutter/material.dart';
import 'package:loading_gifs/loading_gifs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../utility/my_constant.dart';
import 'package:http/http.dart' as http;
import 'package:application_thaweeyont/api.dart';
import '../../authen.dart';

class PageStatusMember extends StatefulWidget {
  const PageStatusMember({super.key});

  @override
  State<PageStatusMember> createState() => _PageStatusMemberState();
}

class _PageStatusMemberState extends State<PageStatusMember> {
  String userId = '', empId = '', firstName = '', lastName = '', tokenId = '';
  bool st_customer = true, st_employee = false, statusLoad404member = false;
  var selectValue_customer, selectvalue_saletype, Texthint, valueaddress;

  TextEditingController custId = TextEditingController();
  TextEditingController custName = TextEditingController();
  TextEditingController smartId = TextEditingController();
  TextEditingController lastnamecust = TextEditingController();

  @override
  void initState() {
    super.initState();
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

  clearValuemembar() {
    custId.clear();
    smartId.clear();
    custName.clear();
    lastnamecust.clear();
  }

  // Future<void> searchIdcustomer() async {
  //   const sizeIcon = BoxConstraints(minWidth: 40, minHeight: 40);
  //   const border = OutlineInputBorder(
  //     borderSide: BorderSide(
  //       color: Colors.transparent,
  //       width: 0,
  //     ),
  //     borderRadius: BorderRadius.all(
  //       Radius.circular(4.0),
  //     ),
  //   );

  //   Future<void> getDataCondition(String? custType, conditionType,
  //       String searchData, String firstName, String lastName) async {
  //     list_datavalue = [];
  //     try {
  //       var respose = await http.post(
  //         Uri.parse('${api}customer/list'),
  //         headers: <String, String>{
  //           'Content-Type': 'application/json',
  //           'Authorization': tokenId.toString(),
  //         },
  //         body: jsonEncode(<String, String>{
  //           'custType': custType.toString(),
  //           'conditionType': conditionType.toString(),
  //           'searchData': searchData.toString(),
  //           'firstName': firstName.toString(),
  //           'lastName': lastName.toString(),
  //           'page': '1',
  //           'limit': '100'
  //         }),
  //       );

  //       if (respose.statusCode == 200) {
  //         Map<String, dynamic> dataList =
  //             Map<String, dynamic>.from(json.decode(respose.body));

  //         setState(() {
  //           list_datavalue = dataList['data'];
  //         });

  //         Navigator.pop(context);
  //       } else if (respose.statusCode == 400) {
  //         showProgressDialog_400(
  //             context, 'แจ้งเตือน', 'ไม่พบข้อมูล (${respose.statusCode})');
  //       } else if (respose.statusCode == 401) {
  //         SharedPreferences preferences = await SharedPreferences.getInstance();
  //         preferences.clear();
  //         Navigator.pushAndRemoveUntil(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => const Authen(),
  //           ),
  //           (Route<dynamic> route) => false,
  //         );
  //         showProgressDialog_401(
  //             context, 'แจ้งเตือน', 'กรุณา Login เข้าสู่ระบบใหม่');
  //       } else if (respose.statusCode == 404) {
  //         setState(() {
  //           Navigator.pop(context);
  //           statusLoad404member = true;
  //         });
  //       } else if (respose.statusCode == 405) {
  //         showProgressDialog_405(
  //             context, 'แจ้งเตือน', 'ไม่พบข้อมูล (${respose.statusCode})');
  //       } else if (respose.statusCode == 500) {
  //         showProgressDialog_500(
  //             context, 'แจ้งเตือน', 'ข้อมูลผิดพลาด (${respose.statusCode})');
  //       } else {
  //         showProgressDialog(context, 'แจ้งเตือน', 'กรุณาติดต่อผู้ดูแลระบบ');
  //       }
  //     } catch (e) {
  //       print("ไม่มีข้อมูล $e");
  //       showProgressDialogNotdata(
  //           context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
  //     }
  //   }

  //   Future<void> getDataSearch() async {
  //     if (id == '1') {
  //       showProgressLoading(context);
  //       if (selectValue_customer.toString() == "2") {
  //         getDataCondition(
  //             id, selectValue_customer, '', searchData.text, lastname.text);
  //       } else {
  //         getDataCondition(id, selectValue_customer, searchData.text, '', '');
  //       }
  //     } else {
  //       showProgressLoading(context);
  //       getDataCondition(id, '2', '', firstname_em.text, lastname_em.text);
  //     }
  //   }

  //   double size = MediaQuery.of(context).size.width;
  //   showDialog(
  //     barrierDismissible: false,
  //     context: context,
  //     builder: (context) => GestureDetector(
  //       onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
  //       behavior: HitTestBehavior.opaque,
  //       child: StatefulBuilder(
  //         builder: (context, setState) => Container(
  //           alignment: Alignment.center,
  //           padding: const EdgeInsets.all(5),
  //           child: SingleChildScrollView(
  //             padding: EdgeInsets.only(
  //                 bottom: MediaQuery.of(context).viewInsets.bottom),
  //             child: Column(
  //               children: [
  //                 Card(
  //                   shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(20.0),
  //                   ),
  //                   elevation: 0,
  //                   color: Colors.white,
  //                   child: Column(
  //                     children: [
  //                       Stack(
  //                         children: [
  //                           Padding(
  //                             padding:
  //                                 const EdgeInsets.only(top: 12, bottom: 6),
  //                             child: Column(
  //                               children: [
  //                                 Row(
  //                                   mainAxisAlignment: MainAxisAlignment.center,
  //                                   children: [
  //                                     Text(
  //                                       'ค้นหาข้อมูลลูกค้า',
  //                                       style: MyContant().h4normalStyle(),
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ],
  //                             ),
  //                           ),
  //                           Positioned(
  //                             right: 0,
  //                             child: InkWell(
  //                               onTap: () {
  //                                 Navigator.pop(context);
  //                                 clearDialog();
  //                               },
  //                               child: const Padding(
  //                                 padding: EdgeInsets.symmetric(
  //                                     vertical: 8, horizontal: 4),
  //                                 child: Icon(
  //                                   Icons.close,
  //                                   size: 30,
  //                                   color: Color.fromARGB(255, 0, 0, 0),
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                       const Divider(
  //                         color: Color.fromARGB(255, 138, 138, 138),
  //                       ),
  //                       Padding(
  //                         padding: const EdgeInsets.all(8.0),
  //                         child: Container(
  //                           decoration: BoxDecoration(
  //                             borderRadius: const BorderRadius.all(
  //                               Radius.circular(5),
  //                             ),
  //                             boxShadow: [
  //                               BoxShadow(
  //                                 color: Colors.grey.withAlpha(130),
  //                                 spreadRadius: 0.2,
  //                                 blurRadius: 2,
  //                                 offset: const Offset(0, 1),
  //                               )
  //                             ],
  //                             color: const Color.fromRGBO(64, 203, 203, 1),
  //                           ),
  //                           padding: const EdgeInsets.all(8),
  //                           width: double.infinity,
  //                           child: Column(
  //                             children: [
  //                               Row(
  //                                 children: [
  //                                   Expanded(
  //                                     child: RadioListTile(
  //                                       activeColor: Colors.black,
  //                                       contentPadding:
  //                                           const EdgeInsets.all(0.0),
  //                                       value: '1',
  //                                       groupValue: id,
  //                                       title: Text(
  //                                         'ลูกค้าทั่วไป',
  //                                         style: MyContant().h4normalStyle(),
  //                                       ),
  //                                       onChanged: (value) {
  //                                         setState(
  //                                           () {
  //                                             st_customer = true;
  //                                             st_employee = false;
  //                                             id = value.toString();
  //                                             statusLoad404member = false;
  //                                             searchData.clear();
  //                                           },
  //                                         );
  //                                       },
  //                                     ),
  //                                   ),
  //                                   Expanded(
  //                                     child: RadioListTile(
  //                                       activeColor: Colors.black,
  //                                       value: '2',
  //                                       groupValue: id,
  //                                       title: Text(
  //                                         'พนักงาน',
  //                                         style: MyContant().h4normalStyle(),
  //                                       ),
  //                                       onChanged: (value) {
  //                                         setState(
  //                                           () {
  //                                             st_customer = false;
  //                                             st_employee = true;
  //                                             id = value.toString();
  //                                             statusLoad404member = false;
  //                                             searchData.clear();
  //                                           },
  //                                         );
  //                                       },
  //                                     ),
  //                                   ),
  //                                 ],
  //                               ),
  //                               if (st_employee == true) ...[
  //                                 Row(
  //                                   children: [
  //                                     Text(
  //                                       'ชื่อ',
  //                                       style: MyContant().h4normalStyle(),
  //                                     ),
  //                                     inputNameEmploDia(sizeIcon, border),
  //                                     Text(
  //                                       'สกุล',
  //                                       style: MyContant().h4normalStyle(),
  //                                     ),
  //                                     inputLastNameEmploDia(sizeIcon, border),
  //                                   ],
  //                                 ),
  //                               ],
  //                               if (st_customer == true) ...[
  //                                 Row(
  //                                   children: [
  //                                     Expanded(
  //                                       child: Padding(
  //                                         padding: const EdgeInsets.all(1),
  //                                         child: Container(
  //                                           height: MediaQuery.of(context)
  //                                                   .size
  //                                                   .width *
  //                                               0.095,
  //                                           padding: const EdgeInsets.all(4),
  //                                           decoration: BoxDecoration(
  //                                               color: Colors.white,
  //                                               borderRadius:
  //                                                   BorderRadius.circular(5)),
  //                                           child: Padding(
  //                                             padding: const EdgeInsets.only(
  //                                                 left: 4),
  //                                             child: DropdownButton(
  //                                               items: dropdown_customer
  //                                                   .map(
  //                                                     (value) =>
  //                                                         DropdownMenuItem(
  //                                                       value: value['id'],
  //                                                       child: Text(
  //                                                         value['name'],
  //                                                         style: MyContant()
  //                                                             .textInputStyle(),
  //                                                       ),
  //                                                     ),
  //                                                   )
  //                                                   .toList(),
  //                                               onChanged: (newvalue) {
  //                                                 setState(
  //                                                   () {
  //                                                     selectValue_customer =
  //                                                         newvalue;
  //                                                     if (selectValue_customer
  //                                                             .toString() ==
  //                                                         "2") {
  //                                                       Texthint = 'ชื่อ';
  //                                                     } else {
  //                                                       Texthint = '';
  //                                                     }
  //                                                     statusLoad404member =
  //                                                         false;
  //                                                     searchData.clear();
  //                                                   },
  //                                                 );
  //                                               },
  //                                               value: selectValue_customer,
  //                                               isExpanded: true,
  //                                               underline: const SizedBox(),
  //                                               hint: Align(
  //                                                 child: Text(
  //                                                   'กรุณาเลือกข้อมูล',
  //                                                   style: MyContant()
  //                                                       .TextInputSelect(),
  //                                                 ),
  //                                               ),
  //                                             ),
  //                                           ),
  //                                         ),
  //                                       ),
  //                                     ),
  //                                     inputSearchCus(sizeIcon, border),
  //                                     if (selectValue_customer.toString() ==
  //                                         "2") ...[
  //                                       inputLastnameCus(sizeIcon, border)
  //                                     ],
  //                                   ],
  //                                 ),
  //                               ],
  //                             ],
  //                           ),
  //                         ),
  //                       ),
  //                       const SizedBox(
  //                         height: 5,
  //                       ),
  //                       Padding(
  //                         padding: const EdgeInsets.symmetric(horizontal: 8),
  //                         child: Row(
  //                           mainAxisAlignment: MainAxisAlignment.end,
  //                           children: [
  //                             SizedBox(
  //                               height:
  //                                   MediaQuery.of(context).size.height * 0.040,
  //                               width: MediaQuery.of(context).size.width * 0.25,
  //                               child: ElevatedButton(
  //                                 style: MyContant().myButtonSearchStyle(),
  //                                 onPressed: () {
  //                                   final isCustomer = id == '1';

  //                                   final isCustomerInputValid =
  //                                       selectValue_customer != null &&
  //                                           (searchData.text.isNotEmpty ||
  //                                               lastname.text.isNotEmpty);

  //                                   final isEmployeeInputValid =
  //                                       firstname_em.text.isNotEmpty ||
  //                                           lastname_em.text.isNotEmpty;

  //                                   if (isCustomer && isCustomerInputValid) {
  //                                     getDataSearch();
  //                                   } else if (!isCustomer &&
  //                                       isEmployeeInputValid) {
  //                                     getDataSearch();
  //                                   } else {
  //                                     showProgressDialog(context, 'แจ้งเตือน',
  //                                         'กรุณากรอกข้อมูล');
  //                                   }
  //                                   // if (id == '1') {
  //                                   //   if (selectValue_customer == null ||
  //                                   //       searchData.text.isEmpty &&
  //                                   //           lastname.text.isEmpty) {
  //                                   //     showProgressDialog(context, 'แจ้งเตือน',
  //                                   //         'กรุณากรอกข้อมูล');
  //                                   //   } else {
  //                                   //     getDataSearch();
  //                                   //   }
  //                                   // } else {
  //                                   //   if (firstname_em.text.isEmpty &&
  //                                   //       lastname_em.text.isEmpty) {
  //                                   //     showProgressDialog(context, 'แจ้งเตือน',
  //                                   //         'กรุณากรอกข้อมูล');
  //                                   //   } else {
  //                                   //     getDataSearch();
  //                                   //   }
  //                                   // }
  //                                 },
  //                                 child: const Text('ค้นหา'),
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                       Padding(
  //                         padding: const EdgeInsets.symmetric(horizontal: 8),
  //                         child: Row(
  //                           children: [
  //                             Text(
  //                               'รายการที่ค้นหา',
  //                               style: MyContant().h2Style(),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                       const SizedBox(height: 10),
  //                       SizedBox(
  //                         height: MediaQuery.of(context).size.height * 0.5,
  //                         child: Scrollbar(
  //                           child: list_datavalue.isNotEmpty
  //                               ? ListView.builder(
  //                                   itemCount: list_datavalue.length,
  //                                   itemBuilder: (context, i) {
  //                                     final data = list_datavalue[i];
  //                                     return InkWell(
  //                                       onTap: () {
  //                                         setState(() {
  //                                           custId.text = data['custId'];
  //                                         });
  //                                         Navigator.pop(context);
  //                                       },
  //                                       child: Padding(
  //                                         padding: const EdgeInsets.symmetric(
  //                                             vertical: 4, horizontal: 8),
  //                                         child: Container(
  //                                           padding: const EdgeInsets.all(8.0),
  //                                           decoration: BoxDecoration(
  //                                             borderRadius:
  //                                                 BorderRadius.circular(5),
  //                                             color: const Color.fromRGBO(
  //                                                 64, 203, 203, 1),
  //                                             boxShadow: [
  //                                               BoxShadow(
  //                                                 color: Colors.grey
  //                                                     .withValues(alpha: 0.5),
  //                                                 spreadRadius: 0.2,
  //                                                 blurRadius: 2,
  //                                                 offset: const Offset(0, 1),
  //                                               ),
  //                                             ],
  //                                           ),
  //                                           child: Column(
  //                                             crossAxisAlignment:
  //                                                 CrossAxisAlignment.start,
  //                                             children: [
  //                                               Text(
  //                                                 'รหัส : ${data['custId']}',
  //                                                 style: MyContant()
  //                                                     .h4normalStyle(),
  //                                               ),
  //                                               const SizedBox(height: 5),
  //                                               Row(
  //                                                 crossAxisAlignment:
  //                                                     CrossAxisAlignment.start,
  //                                                 children: [
  //                                                   Text('ชื่อ : ',
  //                                                       style: MyContant()
  //                                                           .h4normalStyle()),
  //                                                   Expanded(
  //                                                     child: Text(
  //                                                       data['custName'] ?? '',
  //                                                       style: MyContant()
  //                                                           .h4normalStyle(),
  //                                                       overflow:
  //                                                           TextOverflow.clip,
  //                                                     ),
  //                                                   ),
  //                                                 ],
  //                                               ),
  //                                               const SizedBox(height: 5),
  //                                               Row(
  //                                                 crossAxisAlignment:
  //                                                     CrossAxisAlignment.start,
  //                                                 children: [
  //                                                   Text('ที่อยู่ : ',
  //                                                       style: MyContant()
  //                                                           .h4normalStyle()),
  //                                                   Expanded(
  //                                                     child: Text(
  //                                                       data['address'] ?? '',
  //                                                       style: MyContant()
  //                                                           .h4normalStyle(),
  //                                                       overflow:
  //                                                           TextOverflow.clip,
  //                                                     ),
  //                                                   ),
  //                                                 ],
  //                                               ),
  //                                               const SizedBox(height: 5),
  //                                               Text(
  //                                                 'โทร : ${data['telephone'] ?? '-'}',
  //                                                 style: MyContant()
  //                                                     .h4normalStyle(),
  //                                               ),
  //                                             ],
  //                                           ),
  //                                         ),
  //                                       ),
  //                                     );
  //                                   },
  //                                 )
  //                               : statusLoad404member
  //                                   ? Padding(
  //                                       padding:
  //                                           const EdgeInsets.only(top: 100),
  //                                       child: Column(
  //                                         children: [
  //                                           Image.asset('images/Nodata.png',
  //                                               width: 55, height: 55),
  //                                           const SizedBox(height: 10),
  //                                           Text('ไม่พบรายการข้อมูล',
  //                                               style: MyContant().h5NotData()),
  //                                         ],
  //                                       ),
  //                                     )
  //                                   : const SizedBox.shrink(),
  //                         ),
  //                       ),
  //                       const SizedBox(
  //                         height: 20,
  //                       )
  //                     ],
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    const sizeIcon = BoxConstraints(minWidth: 40, minHeight: 40);
    const border = OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.transparent,
        width: 0,
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(4.0),
      ),
    );
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        behavior: HitTestBehavior.opaque,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(64, 203, 203, 1),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withAlpha(130),
                      spreadRadius: 0.5,
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'รหัสลูกค้า',
                          style: MyContant().h4normalStyle(),
                        ),
                        inputIdcustomer(sizeIcon, border),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            backgroundColor:
                                const Color.fromRGBO(18, 108, 108, 1),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CustomerList(),
                              ),
                            ).then((result) {
                              if (result != null) {
                                setState(() {
                                  custId.text = result['id'];
                                });
                              }
                            });
                          },
                          child: const Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'เลขที่บัตร',
                          style: MyContant().h4normalStyle(),
                        ),
                        inputSmartId(sizeIcon, border),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'ชื่อลูกค้า',
                          style: MyContant().h4normalStyle(),
                        ),
                        inputNamecustomer(sizeIcon, border),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'นามสกุล',
                          style: MyContant().h4normalStyle(),
                        ),
                        inputLastname(sizeIcon, border),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            groupBtnsearch(),
            const SizedBox(
              height: 25,
            ),
          ],
        ),
      ),
    );
  }

  Padding line() {
    return const Padding(
      padding: EdgeInsets.all(6.0),
      child: SizedBox(
        height: 10,
        width: double.infinity,
        child: Divider(
          thickness: 2.0,
          color: Color.fromARGB(255, 34, 34, 34),
        ),
      ),
    );
  }

  Padding groupBtnsearch() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.040,
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: ElevatedButton(
                      style: MyContant().myButtonSearchStyle(),
                      onPressed: () {
                        if (custId.text.isEmpty &&
                            smartId.text.isEmpty &&
                            custName.text.isEmpty &&
                            lastnamecust.text.isEmpty) {
                          showProgressDialog(context, 'แจ้งเตือน',
                              'กรุณากรอก รหัส หรือ เลขที่บัตร หรือ ชื่อ-สกุล ลูกค้า');
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MemberCustList(
                                custId.text,
                                smartId.text,
                                custName.text,
                                lastnamecust.text,
                              ),
                            ),
                          );
                        }
                      },
                      child: const Text('ค้นหา'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.040,
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: ElevatedButton(
                      style: MyContant().myButtonCancelStyle(),
                      onPressed: () {
                        clearValuemembar();
                      },
                      child: const Text('ล้างข้อมูล'),
                    ),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  Expanded inputIdcustomer(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: TextField(
          controller: custId,
          onChanged: (keyword) {},
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(8),
            isDense: true,
            enabledBorder: border,
            focusedBorder: border,
            prefixIconConstraints: sizeIcon,
            suffixIconConstraints: sizeIcon,
            filled: true,
            fillColor: Colors.white,
          ),
          style: MyContant().textInputStyle(),
        ),
      ),
    );
  }

  Expanded inputSmartId(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: TextField(
          controller: smartId,
          keyboardType: TextInputType.number,
          maxLength: 13,
          onChanged: (keyword) {},
          decoration: InputDecoration(
            counterText: "",
            contentPadding: const EdgeInsets.all(8),
            isDense: true,
            enabledBorder: border,
            focusedBorder: border,
            prefixIconConstraints: sizeIcon,
            suffixIconConstraints: sizeIcon,
            filled: true,
            fillColor: Colors.white,
          ),
          style: MyContant().textInputStyle(),
        ),
      ),
    );
  }

  Expanded inputNamecustomer(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: TextField(
          controller: custName,
          onChanged: (keyword) {},
          decoration: InputDecoration(
            counterText: "",
            contentPadding: const EdgeInsets.all(8),
            isDense: true,
            enabledBorder: border,
            focusedBorder: border,
            hintStyle: const TextStyle(
              fontSize: 14,
            ),
            prefixIconConstraints: sizeIcon,
            suffixIconConstraints: sizeIcon,
            filled: true,
            fillColor: Colors.white,
          ),
          style: MyContant().textInputStyle(),
        ),
      ),
    );
  }

  Expanded inputLastname(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: TextField(
          controller: lastnamecust,
          onChanged: (keyword) {},
          decoration: InputDecoration(
            counterText: "",
            contentPadding: const EdgeInsets.all(8),
            isDense: true,
            enabledBorder: border,
            focusedBorder: border,
            hintStyle: const TextStyle(
              fontSize: 14,
            ),
            prefixIconConstraints: sizeIcon,
            suffixIconConstraints: sizeIcon,
            filled: true,
            fillColor: Colors.white,
          ),
          style: MyContant().textInputStyle(),
        ),
      ),
    );
  }
}

class CustomerList extends StatefulWidget {
  const CustomerList({super.key});

  @override
  State<CustomerList> createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomerList> {
  String userId = '', empId = '', firstName = '', lastName = '', tokenId = '';
  List list_datavalue = [], dropdown_customer = [];
  String? id = '1';
  bool st_customer = true, st_employee = false;
  bool statusLoading = false,
      statusLoad404 = false,
      isLoading = false,
      isLoadScroll = false,
      isLoadendPage = false;
  var selectValue_customer, Texthint;
  final scrollControll = TrackingScrollController();
  int offset = 50, stquery = 0;

  TextEditingController searchData = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController firstnameEm = TextEditingController();
  TextEditingController lastnameEm = TextEditingController();

  @override
  void initState() {
    super.initState();
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
    getSelectCus();
    myScroll(scrollControll, offset);
  }

  Future<void> getSelectCus() async {
    try {
      var respose = await http.get(
        Uri.parse('${api}setup/custCondition'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> data =
            Map<String, dynamic>.from(json.decode(respose.body));
        setState(() {
          dropdown_customer = data['data'];
        });
        statusLoading = true;
      } else {
        print(respose.statusCode);
      }
    } catch (e) {
      print("ไม่มีข้อมูล $e");
      showProgressDialog(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
  }

  Future<void> getData_condition(String? custType, conditionType,
      String searchData, String firstName, String lastName, offset) async {
    try {
      var respose = await http.post(
        Uri.parse('${api}customer/list'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
        body: jsonEncode(<String, String>{
          'custType': custType.toString(),
          'conditionType': conditionType.toString(),
          'searchData': searchData.toString(),
          'firstName': firstName.toString(),
          'lastName': lastName.toString(),
          'page': '1',
          'limit': '$offset'
        }),
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> dataList =
            Map<String, dynamic>.from(json.decode(respose.body));

        setState(() {
          list_datavalue = dataList['data'];
        });
        statusLoading = true;
      } else if (respose.statusCode == 400) {
        showProgressDialog_400(
            context, 'แจ้งเตือน', 'ไม่พบข้อมูล (${respose.statusCode})');
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
        setState(() {
          statusLoading = true;
          statusLoad404 = true;
        });
      } else if (respose.statusCode == 405) {
        showProgressDialog_405(
            context, 'แจ้งเตือน', 'ไม่พบข้อมูล (${respose.statusCode})');
      } else if (respose.statusCode == 500) {
        showProgressDialog_500(
            context, 'แจ้งเตือน', 'ข้อมูลผิดพลาด (${respose.statusCode})');
      } else {
        showProgressDialog(context, 'แจ้งเตือน', 'กรุณาติดต่อผู้ดูแลระบบ!');
      }
    } catch (e) {
      print("ไม่มีข้อมูล $e");
      showProgressDialogNotdata(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
  }

  Future<void> getData_search(offset) async {
    if (id == '1') {
      if (selectValue_customer.toString() == "2") {
        getData_condition(id, selectValue_customer, '', searchData.text,
            lastname.text, offset);
      } else {
        getData_condition(
            id, selectValue_customer, searchData.text, '', '', offset);
      }
    } else {
      getData_condition(id, '2', '', firstnameEm.text, lastnameEm.text, offset);
    }
  }

  void myScroll(ScrollController scrollController, int offset) {
    scrollController.addListener(() async {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        setState(() {
          isLoadScroll = true;
        });
        await Future.delayed(const Duration(seconds: 1), () {
          offset = offset + 20;
          getData_search(offset);
        });
      }
    });
  }

  clearValueDialog() {
    setState(() {
      id = '1';
      st_customer = true;
      st_employee = false;
      selectValue_customer = null;
      list_datavalue = [];
      Texthint = '';
      isLoadScroll = false;
    });
    searchData.clear();
    firstnameEm.clear();
    lastnameEm.clear();
    lastname.clear();
  }

  @override
  Widget build(BuildContext context) {
    const sizeIcon = BoxConstraints(minWidth: 40, minHeight: 40);
    const border = OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.transparent,
        width: 0,
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(4.0),
      ),
    );
    return Scaffold(
      appBar: CustomAppbar(title: 'ค้นหาข้อมูลลูกค้า'),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        behavior: HitTestBehavior.opaque,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                  color: const Color.fromRGBO(64, 203, 203, 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withAlpha(130),
                      spreadRadius: 0.5,
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    )
                  ],
                ),
                padding: const EdgeInsets.all(6),
                width: double.infinity,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: ['1', '2'].map((val) {
                          final isCustomer = val == '1';
                          return Expanded(
                            child: RadioListTile(
                              activeColor: Colors.black,
                              value: val,
                              groupValue: id,
                              title: Text(
                                isCustomer ? 'ลูกค้าทั่วไป' : 'พนักงาน',
                                style: MyContant().h4normalStyle(),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  st_customer = isCustomer;
                                  st_employee = !isCustomer;
                                  id = value.toString();
                                  searchData.clear();
                                });
                              },
                              visualDensity: VisualDensity.compact,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            ),
                          );
                        }).toList(),
                      ),
                      if (st_employee == true) ...[
                        Row(
                          children: [
                            Text(
                              'ชื่อ',
                              style: MyContant().h4normalStyle(),
                            ),
                            inputNameEmploDia(sizeIcon, border),
                            Text(
                              'สกุล',
                              style: MyContant().h4normalStyle(),
                            ),
                            inputLastNameEmploDia(sizeIcon, border),
                          ],
                        ),
                      ],
                      if (st_customer == true) ...[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(4),
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.width * 0.095,
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 4),
                                    child: DropdownButton(
                                      items: dropdown_customer
                                          .map((value) => DropdownMenuItem(
                                                value: value['id'],
                                                child: Text(
                                                  value['name'],
                                                  style: MyContant()
                                                      .textInputStyle(),
                                                ),
                                              ))
                                          .toList(),
                                      onChanged: (newvalue) {
                                        setState(() {
                                          selectValue_customer = newvalue;
                                          Texthint = newvalue.toString() == '2'
                                              ? 'ชื่อ'
                                              : '';
                                          searchData.clear();
                                        });
                                      },
                                      value: selectValue_customer,
                                      isExpanded: true,
                                      underline: const SizedBox(),
                                      hint: Align(
                                        child: Text(
                                          'กรุณาเลือกข้อมูล',
                                          style: MyContant().TextInputSelect(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            inputSearchCus(sizeIcon, border),
                            if (selectValue_customer.toString() == "2") ...[
                              inputLastnameCus(sizeIcon, border)
                            ],
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            groupBtnsearch(),
            const SizedBox(height: 10),
            Expanded(
              child: statusLoading == false
                  ? Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 24, 24, 24)
                              .withValues(alpha: 0.9),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 30),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(cupertinoActivityIndicator, scale: 4),
                            Text(
                              'กำลังโหลด',
                              style: MyContant().textLoading(),
                            ),
                          ],
                        ),
                      ),
                    )
                  : statusLoad404 == true
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(40.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'images/noresults.png',
                                      color: const Color.fromARGB(
                                          255, 158, 158, 158),
                                      width: 60,
                                      height: 60,
                                    )
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'ไม่พบรายการข้อมูล',
                                      style: MyContant().h5NotData(),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      : SingleChildScrollView(
                          controller: scrollControll,
                          physics: const BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics(),
                          ),
                          child: Column(
                            children: [
                              for (var i = 0; i < list_datavalue.length; i++)
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context, {
                                      'id': list_datavalue[i]['custId'],
                                      // 'name': list_datavalue[i]['custName'],
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 8),
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        color: const Color.fromRGBO(
                                            64, 203, 203, 1),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey
                                                .withValues(alpha: 0.5),
                                            spreadRadius: 0.2,
                                            blurRadius: 2,
                                            offset: const Offset(0, 1),
                                          )
                                        ],
                                      ),
                                      child: Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: Colors.white
                                              .withValues(alpha: 0.7),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  'รหัส : ${list_datavalue[i]['custId']}',
                                                  style: MyContant()
                                                      .h4normalStyle(),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 5),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'ชื่อ : ',
                                                  style: MyContant()
                                                      .h4normalStyle(),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    '${list_datavalue[i]['custName']}',
                                                    style: MyContant()
                                                        .h4normalStyle(),
                                                    overflow: TextOverflow.clip,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 5),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'ที่อยู่ : ',
                                                  style: MyContant()
                                                      .h4normalStyle(),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    '${list_datavalue[i]['address']}',
                                                    style: MyContant()
                                                        .h4normalStyle(),
                                                    overflow: TextOverflow.clip,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 5),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'โทร : ',
                                                  style: MyContant()
                                                      .h4normalStyle(),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    '${list_datavalue[i]['telephone']}',
                                                    style: MyContant()
                                                        .h4normalStyle(),
                                                    overflow: TextOverflow.clip,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              if (isLoadScroll == true &&
                                  isLoadendPage == false) ...[
                                const LoadData(),
                              ] else if (isLoadendPage == true) ...[
                                const EndPage(),
                              ],
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
            )
          ],
        ),
      ),
    );
  }

  Padding groupBtnsearch() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.040,
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: ElevatedButton(
                      style: MyContant().myButtonSearchStyle(),
                      onPressed: () {
                        setState(() {
                          if (id == '1') {
                            if (selectValue_customer == null ||
                                searchData.text.isEmpty &&
                                    lastname.text.isEmpty) {
                              showProgressDialog(
                                  context, 'แจ้งเตือน', 'กรุณากรอกข้อมูล');
                            } else {
                              getData_search(offset);
                              statusLoading = false;
                            }
                          } else {
                            if (firstnameEm.text.isEmpty &&
                                lastnameEm.text.isEmpty) {
                              showProgressDialog(
                                  context, 'แจ้งเตือน', 'กรุณากรอกข้อมูล');
                            } else {
                              getData_search(offset);
                              statusLoading = false;
                            }
                          }
                        });
                      },
                      child: const Text('ค้นหา'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.040,
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: ElevatedButton(
                      style: MyContant().myButtonCancelStyle(),
                      onPressed: () {
                        clearValueDialog();
                      },
                      child: const Text('ล้างข้อมูล'),
                    ),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  Expanded inputSearchCus(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: MediaQuery.of(context).size.width * 0.095,
          child: TextField(
            controller: searchData,
            onChanged: (keyword) {},
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(8),
              isDense: true,
              enabledBorder: border,
              focusedBorder: border,
              hintText: Texthint,
              hintStyle: MyContant().hintTextStyle(),
              prefixIconConstraints: sizeIcon,
              suffixIconConstraints: sizeIcon,
              filled: true,
              fillColor: Colors.white,
            ),
            style: MyContant().textInputStyle(),
          ),
        ),
      ),
    );
  }

  Expanded inputNameEmploDia(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: firstnameEm,
          onChanged: (keyword) {},
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(6),
            isDense: true,
            enabledBorder: border,
            focusedBorder: border,
            hintStyle: const TextStyle(
              fontSize: 14,
            ),
            prefixIconConstraints: sizeIcon,
            suffixIconConstraints: sizeIcon,
            filled: true,
            fillColor: Colors.white,
          ),
          style: MyContant().textInputStyle(),
        ),
      ),
    );
  }

  Expanded inputLastNameEmploDia(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: lastnameEm,
          onChanged: (keyword) {},
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(6),
            isDense: true,
            enabledBorder: border,
            focusedBorder: border,
            hintStyle: const TextStyle(
              fontSize: 14,
            ),
            prefixIconConstraints: sizeIcon,
            suffixIconConstraints: sizeIcon,
            filled: true,
            fillColor: Colors.white,
          ),
          style: MyContant().textInputStyle(),
        ),
      ),
    );
  }

  Expanded inputLastnameCus(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(right: 4),
        child: SizedBox(
          height: MediaQuery.of(context).size.width * 0.095,
          child: TextField(
            controller: lastname,
            onChanged: (keyword) {},
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(8),
              isDense: true,
              enabledBorder: border,
              focusedBorder: border,
              hintText: 'นามสกุล',
              hintStyle: MyContant().hintTextStyle(),
              prefixIconConstraints: sizeIcon,
              suffixIconConstraints: sizeIcon,
              filled: true,
              fillColor: Colors.white,
            ),
            style: MyContant().textInputStyle(),
          ),
        ),
      ),
    );
  }
}
