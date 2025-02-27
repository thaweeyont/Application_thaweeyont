import 'package:application_thaweeyont/utility/my_constant.dart';
import 'package:flutter/material.dart';

import '../../widgets/custom_appbar.dart';

class BranchSalesList extends StatefulWidget {
  const BranchSalesList({super.key});

  @override
  State<BranchSalesList> createState() => _BranchSalesListState();
}

class _BranchSalesListState extends State<BranchSalesList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: 'ยอดขายสินค้ารวมสาขาในแต่ละวัน'),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        behavior: HitTestBehavior.opaque,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
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
                            'ยอดขายสินค้าเดือน มกราคม 2568',
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
              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(180),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'ผู้จำหน่าย : ทั้งหมด',
                            style: MyContant().h4normalStyle(),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(180),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'ช่องทางการขาย : ขายหน้าร้าน, ขาย Event, ขาย Expo',
                              style: MyContant().h4normalStyle(),
                              textAlign: TextAlign.left,
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
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: [],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
