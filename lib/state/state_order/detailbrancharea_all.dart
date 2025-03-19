import 'package:flutter/material.dart';

import '../../widgets/custom_appbar.dart';

class DetailBranchAreaAll extends StatefulWidget {
  const DetailBranchAreaAll({super.key});

  @override
  State<DetailBranchAreaAll> createState() => _DetailBranchAreaAllState();
}

class _DetailBranchAreaAllState extends State<DetailBranchAreaAll> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: 'ยอดขายสินค้ารวมสาขาในแต่ละวัน'),
    );
  }
}
