import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../utility/my_constant.dart';
import '../../widgets/custom_appbar.dart';

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
  ScrollController _scrollController = ScrollController();
  bool isScrolled = false;

  @override
  void initState() {
    super.initState();
    checkDataList();
    _scrollController.addListener(() {
      if (_scrollController.offset > 5 && !isScrolled) {
        setState(() {
          isScrolled = true;
        });
      } else if (_scrollController.offset <= 5 && isScrolled) {
        setState(() {
          isScrolled = false;
        });
      }
    });
  }

  void checkDataList() {
    areaName = (widget.saleBranchList['branchAreaName'] as String)
        .replaceAll("เขต ", "");

    // ✅ ตรวจสอบให้แน่ใจว่า dailyTotal เป็น Map<String, dynamic>
    Map<String, dynamic> dailyTotalMap =
        Map<String, dynamic>.from(widget.saleBranchList["dailyTotal"]);

    // ✅ แปลง dailyTotal เป็น List<Map<String, dynamic>>
    dailyList = dailyTotalMap.entries
        .map((e) => {"date": e.key, "amount": e.value})
        .toList();
  }

  var formatter = NumberFormat('#,##0.00');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: 'ยอดขายสินค้ารวมสาขาในแต่ละวัน'),
      body: Stack(
        children: [
          /// ✅ รายการข้อมูลที่เลื่อนได้ (CustomScrollView)
          Column(
            children: [
              SizedBox(height: 120),
              Expanded(
                // padding:
                //     const EdgeInsets.only(top: 0), // ✅ ปรับให้ Header ไม่โดนทับ
                child: NotificationListener<ScrollNotification>(
                  onNotification: (scrollNotification) {
                    if (scrollNotification.metrics.pixels > 5) {
                      setState(() => isScrolled = true);
                    } else {
                      setState(() => isScrolled = false);
                    }
                    return true;
                  },
                  child: CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.all(8.0),
                        sliver: SliverGrid(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final items = dailyList?[index];
                              return Container(
                                padding: const EdgeInsets.all(8),
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
                                  color: const Color.fromRGBO(239, 191, 239, 1),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'วันที่ : ${items?['date']}',
                                          style: MyContant().h4normalStyle(),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 3),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 8),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withAlpha(180),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                formatter
                                                    .format(items?['amount']),
                                                style:
                                                    MyContant().h4normalStyle(),
                                              ),
                                            ],
                                          ),
                                        ],
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
                              left: 8, right: 8, top: 4, bottom: 50),
                          child: Container(
                            padding: const EdgeInsets.all(8),
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
                              color: const Color.fromRGBO(239, 191, 239, 1),
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 8),
                              decoration: BoxDecoration(
                                color: Colors.white.withAlpha(180),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'ยอดรวม : ${formatter.format(widget.saleBranchList['branchTotal'])}',
                                    style: MyContant().h4normalStyle(),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'ทำได้ : ${widget.saleBranchList['percent']} %',
                                    style: MyContant().h4normalStyle(),
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
              duration: Duration(milliseconds: 200),
              // padding: const EdgeInsets.all(8),
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
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
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
                            vertical: 4, horizontal: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(180),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
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
                    padding:
                        const EdgeInsets.only(left: 8, right: 8, bottom: 0),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
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
                            vertical: 4, horizontal: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(180),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'เขตสาขา : $areaName',
                                  style: MyContant().h4normalStyle(),
                                ),
                                Text(
                                  'สาขา : ${widget.saleBranchList['branchName']}',
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
}
