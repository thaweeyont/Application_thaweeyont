import 'package:flutter/material.dart';

import '../../widgets/custom_appbar.dart';

class DetailBranchAreaAll extends StatefulWidget {
  final dynamic dataSaleList;
  const DetailBranchAreaAll({super.key, this.dataSaleList});

  @override
  State<DetailBranchAreaAll> createState() => _DetailBranchAreaAllState();
}

class _DetailBranchAreaAllState extends State<DetailBranchAreaAll> {
  List<Map<String, dynamic>>? dailyList;
  @override
  void initState() {
    super.initState();
    buildDataSaleList();
    // print('dataSaleList: ${widget.dataSaleList}');
    // print('dataType: ${widget.dataSaleList.runtimeType}');
  }

  void buildDataSaleList() {
    Map<String, dynamic> dailyTotalMap =
        Map<String, dynamic>.from(widget.dataSaleList);
    print('dataListNew: $dailyTotalMap');
    print('head: ${dailyTotalMap['head']}');
    for (var i = 0; i < dailyTotalMap.length; i++) {
      List<dynamic> dataListNew = dailyTotalMap['detail'];
      for (var j = 0; j < dataListNew.length; j++) {
        print('dataListNew2: ${dailyTotalMap['detail'][j]}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: 'ยอดขายสินค้ารวมสาขาในแต่ละวัน'),
    );
  }
}
