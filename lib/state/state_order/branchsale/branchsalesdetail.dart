import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_gifs/loading_gifs.dart';

import '../../../utility/my_constant.dart';
import '../../../widgets/custom_appbar.dart';

class BranchSalesDetail extends StatefulWidget {
  final Map<String, dynamic> saleBranchList;
  final dynamic saleBranchHead;

  const BranchSalesDetail({
    super.key,
    required this.saleBranchList,
    required this.saleBranchHead,
  });

  @override
  State<BranchSalesDetail> createState() => _BranchSalesDetailState();
}

class _BranchSalesDetailState extends State<BranchSalesDetail> {
  List<Map<String, dynamic>>? dailyList;
  String? areaName;
  bool isScrolled = false;
  bool statusLoading = false, statusLoad404 = false;
  final GlobalKey _containerKey = GlobalKey();
  double _containerHeight = 0; // เก็บค่าความสูง

  @override
  void initState() {
    super.initState();
    checkDataList();
  }

  void checkDataList() {
    setState(() {
      areaName = (widget.saleBranchList['branchAreaName'] as String)
          .replaceAll("เขต ", "");

      // ✅ ตรวจสอบให้แน่ใจว่า dailyTotal เป็น Map<String, dynamic>
      Map<String, dynamic> dailyTotalMap =
          Map<String, dynamic>.from(widget.saleBranchList["dailyTotal"]);

      // ✅ แปลง dailyTotal เป็น List<Map<String, dynamic>>
      dailyList = dailyTotalMap.entries
          .map((e) => {"date": e.key, "amount": e.value})
          .toList();
      statusLoading = true;
    });
  }

  var formatter = NumberFormat('#,##0.00');

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _getContainerHeight());
    return Scaffold(
      appBar: const CustomAppbar(title: 'ยอดขายสินค้ารวมสาขาในแต่ละวัน'),
      body: statusLoading == false
          ? Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 24, 24, 24).withAlpha(230),
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
                              color: const Color.fromARGB(255, 158, 158, 158),
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
              : Stack(
                  children: [
                    Column(
                      children: [
                        SizedBox(
                            height: _containerHeight), // ✅ ปรับขนาดอัตโนมัติ
                        Expanded(
                          child: NotificationListener<ScrollNotification>(
                            onNotification: (scrollInfo) {
                              setState(() {
                                isScrolled = scrollInfo.metrics.pixels > 0;
                              });
                              return true;
                            },
                            child: CustomScrollView(
                              slivers: [
                                SliverPadding(
                                  padding: const EdgeInsets.all(8.0),
                                  sliver: SliverGrid(
                                    delegate: SliverChildBuilderDelegate(
                                      (context, index) {
                                        final items = dailyList?[index];
                                        return Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            boxShadow: [
                                              BoxShadow(
                                                color:
                                                    Colors.grey.withAlpha(130),
                                                spreadRadius: 0.2,
                                                blurRadius: 2,
                                                offset: const Offset(0, 1),
                                              )
                                            ],
                                            color: const Color.fromRGBO(
                                                239, 191, 239, 1),
                                          ),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'วันที่ : ${items?['date']}',
                                                    style: MyContant()
                                                        .h4normalStyle(),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 3),
                                              Expanded(
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 8,
                                                      horizontal: 8),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white
                                                        .withAlpha(180),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            formatter.format(
                                                                items?[
                                                                    'amount']),
                                                            style: MyContant()
                                                                .h4normalStyle(),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      childCount: dailyList?.length,
                                    ),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 8,
                                      mainAxisSpacing: 8,
                                      childAspectRatio: 2.25,
                                    ),
                                  ),
                                ),
                                SliverToBoxAdapter(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8, right: 8, top: 4, bottom: 40),
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withAlpha(130),
                                            spreadRadius: 0.2,
                                            blurRadius: 2,
                                            offset: const Offset(0, 1),
                                          )
                                        ],
                                        color: const Color.fromRGBO(
                                            239, 191, 239, 1),
                                      ),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8, horizontal: 8),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withAlpha(180),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'ยอดรวม : ${formatter.format(widget.saleBranchList['branchTotal'])}',
                                              style:
                                                  MyContant().h4normalStyle(),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              'ทำได้ : ${widget.saleBranchList['percent']} %',
                                              style:
                                                  MyContant().h4normalStyle(),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    /// ✅ Header ที่อยู่ด้านบนสุด (ใช้ Positioned)
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: AnimatedContainer(
                        key: _containerKey, // ✅ ใส่ key เพื่อนำไปวัดขนาด
                        duration: Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: isScrolled
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withAlpha(130),
                                    blurRadius: 12,
                                    spreadRadius: 5,
                                    offset: Offset(0, 5),
                                  )
                                ]
                              : [],
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withAlpha(130),
                                      spreadRadius: 0.2,
                                      blurRadius: 2,
                                      offset: const Offset(0, 1),
                                    )
                                  ],
                                  color: const Color.fromRGBO(239, 191, 239, 1),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withAlpha(180),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'ยอดขายสินค้าเดือน ${widget.saleBranchHead['month']} พ.ศ. ${widget.saleBranchHead['year']}',
                                            style: MyContant().h4normalStyle(),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 8, right: 8, bottom: 6),
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withAlpha(130),
                                      spreadRadius: 0.2,
                                      blurRadius: 2,
                                      offset: const Offset(0, 1),
                                    )
                                  ],
                                  color: const Color.fromRGBO(239, 191, 239, 1),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withAlpha(180),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'เขตสาขา : $areaName',
                                            style: MyContant().h4normalStyle(),
                                          ),
                                          Text(
                                            'สาขา : ${widget.saleBranchList['branchShortName']}',
                                            style: MyContant().h4normalStyle(),
                                          ),
                                          Text(
                                            'เป้า : ${formatter.format(widget.saleBranchList['targetTotal'])}',
                                            style: MyContant().h4normalStyle(),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }

  void _getContainerHeight() {
    final RenderBox? renderBox =
        _containerKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      double newHeight = renderBox.size.height;
      if (_containerHeight != newHeight) {
        setState(() {
          _containerHeight = newHeight;
        });
      }
    }
  }
}
