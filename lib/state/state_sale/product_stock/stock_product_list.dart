import 'dart:convert';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:application_thaweeyont/api.dart';
import 'package:application_thaweeyont/state/authen.dart';
import 'package:application_thaweeyont/state/state_sale/product_stock/stock_product_detail.dart';
import 'package:application_thaweeyont/utility/my_constant.dart';
import 'package:flutter/material.dart';
import 'package:loading_gifs/loading_gifs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class StockProductList extends StatefulWidget {
  final String? selectStockTypeList,
      selectBranchList,
      idItemWareHouse,
      nameProduct,
      selectGroupFreeList,
      idItemFree,
      idItemGroup,
      idItemType,
      idItemBrand,
      idItemModel,
      idItemStyle,
      idItemSize,
      idItemColor;
  const StockProductList(
      this.selectStockTypeList,
      this.selectBranchList,
      this.idItemWareHouse,
      this.nameProduct,
      this.selectGroupFreeList,
      this.idItemFree,
      this.idItemGroup,
      this.idItemType,
      this.idItemBrand,
      this.idItemModel,
      this.idItemStyle,
      this.idItemSize,
      this.idItemColor,
      {Key? key})
      : super(key: key);

  @override
  State<StockProductList> createState() => _StockProductListState();
}

class _StockProductListState extends State<StockProductList> {
  String userId = '',
      empId = '',
      firstName = '',
      lastName = '',
      tokenId = '',
      branchId = '',
      branchName = '';
  bool? allowApproveStatus;
  bool statusLoading = false,
      statusLoad404 = false,
      isLoad = false,
      isLoadendPage = false;
  var newqty = 0;
  List dataStockList = [], totalStockList = [];
  Map<String, dynamic>? totalStock;
  var valueDetailStock, valueStockType = '';
  final scrollControll = TrackingScrollController();
  int offset = 30;
  @override
  void initState() {
    super.initState();
    getdata();
    print('stock> ${widget.selectStockTypeList}');
    print('branch> ${widget.selectBranchList}');
    print('warehouse> ${widget.idItemWareHouse}');
    print('nameproduct> ${widget.nameProduct}');
    print('groupfree> ${widget.selectGroupFreeList}');
    print('itemfree> ${widget.idItemFree}');
    print('itemgroup> ${widget.idItemGroup}');
    print('itemtype> ${widget.idItemType}');
    print('itembrand> ${widget.idItemBrand}');
    print('itemmodel> ${widget.idItemModel}');
    print('itemtype> ${widget.idItemStyle}');
    print('itemsize> ${widget.idItemSize}');
    print('itemcolor> ${widget.idItemColor}');
  }

  Future<void> getdata() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      userId = preferences.getString('userId')!;
      empId = preferences.getString('empId')!;
      firstName = preferences.getString('firstName')!;
      lastName = preferences.getString('lastName')!;
      tokenId = preferences.getString('tokenId')!;
      branchId = preferences.getString('branchId')!;
      branchName = preferences.getString('branchName')!;
      allowApproveStatus = preferences.getBool('allowApproveStatus');
    });
    // await Future.delayed(const Duration(milliseconds: 100));
    if (mounted) {
      setState(() {
        getDataStockList(offset);
      });
      valueStockType = widget.selectStockTypeList.toString();
    }
    myScroll(scrollControll, offset);
  }

  void myScroll(scrollControll, offset) {
    scrollControll.addListener(() async {
      // double currentScroll = scrollControll.position.pixels;
      if (scrollControll.position.pixels ==
          scrollControll.position.maxScrollExtent) {
        setState(() {
          isLoad = true;
        });
        await Future.delayed(const Duration(seconds: 1), () {
          offset = offset + 10;
          getDataStockList(offset);
        });
      }
    });
  }

  Future<void> getDataStockList(offset) async {
    try {
      var respose = await http.post(
        Uri.parse('${api}stock/list'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
        body: jsonEncode(<String, String>{
          'stockType': '${widget.selectStockTypeList}',
          'branchId': '${widget.selectBranchList}',
          'whId': '${widget.idItemWareHouse}',
          'itemName': '${widget.nameProduct}',
          'groupFree': '${widget.selectGroupFreeList}',
          'freeItemId': '${widget.idItemFree}',
          'groupId': '${widget.idItemGroup}',
          'itemTypeId': '${widget.idItemType}',
          'brandId': '${widget.idItemBrand}',
          'modelId': '${widget.idItemModel}',
          'styleId': '${widget.idItemStyle}',
          'sizeId': '${widget.idItemSize}',
          'colorId': '${widget.idItemColor}',
          'page': '1',
          'limit': '$offset'
        }),
      );

      if (respose.statusCode == 200) {
        Map<String, dynamic> stocklist =
            Map<String, dynamic>.from(json.decode(respose.body));
        valueDetailStock = stocklist['data'];
        setState(() {
          dataStockList = valueDetailStock['detail'];
          totalStock =
              Map<String, dynamic>.from(valueDetailStock['totalStock']);
          statusLoading = true;
          isLoad = false;
        });
        var news = int.parse(valueDetailStock['totalStock']['qty'].toString());
        if (newqty < news) {
          isLoadendPage = false;
          newqty = news;
        } else if (newqty >= news) {
          setState(() {
            isLoadendPage = true;
          });
        }
        // print('dataStockList>> $dataStockList');
        // print('totalStock>> $totalStock');
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
        showProgressDialog(context, 'แจ้งเตือน', 'กรุณาติดต่อผู้ดูแลระบบ');
      }
    } catch (e) {
      print("ไม่มีข้อมูล $e");
      showProgressDialog(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'รายการที่ค้นหา',
          style: MyContant().TitleStyle(),
        ),
      ),
      body: statusLoading == false
          ? Center(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 24, 24, 24).withOpacity(0.9),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
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
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    height: MediaQuery.of(context).size.height * 0.15,
                    child: Column(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'images/Nodata.png',
                                  width: 55,
                                  height: 55,
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'ไม่พบรายการข้อมูล',
                                  style: MyContant().h5NotData(),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              : valueStockType == '1' || valueStockType == '2'
                  ? SingleChildScrollView(
                      controller: scrollControll,
                      physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          if (dataStockList.isNotEmpty) ...[
                            for (var i = 0; i < dataStockList.length; i++) ...[
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => StockProductDetail(
                                        dataStockList[i]['branchId'],
                                        dataStockList[i]['branchName'],
                                        dataStockList[i]['whId'],
                                        dataStockList[i]['whName'],
                                        dataStockList[i]['itemId'],
                                        dataStockList[i]['itemName'],
                                        dataStockList[i]['itemTypeName'],
                                        dataStockList[i]['brandName'],
                                      ),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 8),
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(5),
                                      ),
                                      color: const Color.fromRGBO(
                                          176, 218, 255, 1),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 0.2,
                                          blurRadius: 2,
                                          offset: const Offset(0, 1),
                                        )
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${dataStockList[i]['branchName']}',
                                              style:
                                                  MyContant().h4normalStyle(),
                                            ),
                                            Text(
                                              'คลังสินค้า : ${dataStockList[i]['whName']}',
                                              style:
                                                  MyContant().h4normalStyle(),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 5),
                                        Row(
                                          children: [
                                            Text(
                                              'ประเภท : ${dataStockList[i]['itemTypeName']}',
                                              style:
                                                  MyContant().h4normalStyle(),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 5),
                                        Row(
                                          children: [
                                            Text(
                                              'ยี่ห้อ : ${dataStockList[i]['brandName']}',
                                              style:
                                                  MyContant().h4normalStyle(),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 5),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'รุ่น : ',
                                              style:
                                                  MyContant().h4normalStyle(),
                                            ),
                                            Expanded(
                                              child: Text(
                                                '${dataStockList[i]['itemName']}',
                                                overflow: TextOverflow.clip,
                                                style:
                                                    MyContant().h4normalStyle(),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Divider(thickness: 1),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'คงเหลือ : ${dataStockList[i]['qty']}',
                                              style:
                                                  MyContant().h4normalStyle(),
                                            ),
                                            Text(
                                              'ยืม : ${dataStockList[i]['borrowQty']}',
                                              style:
                                                  MyContant().h4normalStyle(),
                                            ),
                                            Text(
                                              'เคลื่อนย้าย : ${dataStockList[i]['outQty']}',
                                              style:
                                                  MyContant().h4normalStyle(),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 5),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'ส่งเคลม : ${dataStockList[i]['returnQty']}',
                                              style:
                                                  MyContant().h4normalStyle(),
                                            ),
                                            Text(
                                              'รวม : ${dataStockList[i]['totalQty']}',
                                              style:
                                                  MyContant().h4normalStyle(),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 8),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                  color:
                                      const Color.fromARGB(255, 130, 196, 255),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 0.2,
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
                                          'รวมทั้งหมด',
                                          style: MyContant().h4normalStyle(),
                                        ),
                                      ],
                                    ),
                                    const Divider(thickness: 1),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'คงเหลือ : ${totalStock!['qty']}',
                                          style: MyContant().h4normalStyle(),
                                        ),
                                        Text(
                                          'ยืม : ${totalStock!['borrowQty']}',
                                          style: MyContant().h4normalStyle(),
                                        ),
                                        Text(
                                          'เคลื่อนย้าย : ${totalStock!['outQty']}',
                                          style: MyContant().h4normalStyle(),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'ส่งเคลม : ${totalStock!['returnQty']}',
                                          style: MyContant().h4normalStyle(),
                                        ),
                                        Text(
                                          'รวม : ${totalStock!['totalQty']}',
                                          style: MyContant().h4normalStyle(),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (isLoad == true && isLoadendPage == false) ...[
                              const LoadData(),
                            ] else if (isLoadendPage == true) ...[
                              EndPage()
                            ]
                          ],
                          const SizedBox(height: 40),
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      controller: scrollControll,
                      physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          if (dataStockList.isNotEmpty) ...[
                            for (var i = 0; i < dataStockList.length; i++) ...[
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => StockProductDetail(
                                        dataStockList[i]['branchId'],
                                        dataStockList[i]['branchName'],
                                        dataStockList[i]['whId'],
                                        dataStockList[i]['whName'],
                                        dataStockList[i]['itemId'],
                                        dataStockList[i]['itemName'],
                                        dataStockList[i]['itemTypeName'],
                                        dataStockList[i]['brandName'],
                                      ),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 8),
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(5),
                                      ),
                                      color: const Color.fromRGBO(
                                          176, 218, 255, 1),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 0.2,
                                          blurRadius: 2,
                                          offset: const Offset(0, 1),
                                        )
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${dataStockList[i]['branchName']}',
                                              style:
                                                  MyContant().h4normalStyle(),
                                            ),
                                            Text(
                                              'คลังสินค้า : ${dataStockList[i]['whName']}',
                                              style:
                                                  MyContant().h4normalStyle(),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 5),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '',
                                              style:
                                                  MyContant().h4normalStyle(),
                                            ),
                                            Expanded(
                                              child: Text(
                                                '${dataStockList[i]['itemName']}',
                                                overflow: TextOverflow.clip,
                                                style:
                                                    MyContant().h4normalStyle(),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Divider(thickness: 1),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'คงเหลือ : ${dataStockList[i]['qty']}',
                                              style:
                                                  MyContant().h4normalStyle(),
                                            ),
                                            Text(
                                              'ยืม : ${dataStockList[i]['borrowQty']}',
                                              style:
                                                  MyContant().h4normalStyle(),
                                            ),
                                            Text(
                                              'เคลื่อนย้าย : ${dataStockList[i]['outQty']}',
                                              style:
                                                  MyContant().h4normalStyle(),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 5),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'ส่งเคลม : ${dataStockList[i]['returnQty']}',
                                              style:
                                                  MyContant().h4normalStyle(),
                                            ),
                                            Text(
                                              'รวม : ${dataStockList[i]['totalQty']}',
                                              style:
                                                  MyContant().h4normalStyle(),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 8),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                  color:
                                      const Color.fromARGB(255, 130, 196, 255),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 0.2,
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
                                          'รวมทั้งหมด',
                                          style: MyContant().h4normalStyle(),
                                        ),
                                      ],
                                    ),
                                    const Divider(thickness: 1),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'คงเหลือ : ${totalStock!['qty']}',
                                          style: MyContant().h4normalStyle(),
                                        ),
                                        Text(
                                          'ยืม : ${totalStock!['borrowQty']}',
                                          style: MyContant().h4normalStyle(),
                                        ),
                                        Text(
                                          'เคลื่อนย้าย : ${totalStock!['outQty']}',
                                          style: MyContant().h4normalStyle(),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'ส่งเคลม : ${totalStock!['returnQty']}',
                                          style: MyContant().h4normalStyle(),
                                        ),
                                        Text(
                                          'รวม : ${totalStock!['totalQty']}',
                                          style: MyContant().h4normalStyle(),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (isLoad == true && isLoadendPage == false) ...[
                              const LoadData(),
                            ] else if (isLoadendPage == true) ...[
                              EndPage()
                            ]
                          ],
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
    );
  }
}

class LoadData extends StatelessWidget {
  const LoadData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "กำลังโหลด",
            style: TextStyle(
              color: Colors.red[400],
              fontFamily: 'prompt',
              fontSize: 14,
            ),
          ),
          AnimatedTextKit(
            animatedTexts: [
              WavyAnimatedText(
                '.......',
                textStyle: TextStyle(
                  color: Colors.red[400],
                  fontFamily: 'prompt',
                  fontSize: 16,
                ),
              ),
              WavyAnimatedText(
                '.......',
                textStyle: TextStyle(
                  color: Colors.red[400],
                  fontFamily: 'prompt',
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class EndPage extends StatelessWidget {
  const EndPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "สิ้นสุดหน้า",
            style: TextStyle(
              color: Colors.red[400],
              fontFamily: 'prompt',
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
