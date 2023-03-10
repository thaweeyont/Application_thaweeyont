import 'package:application_thaweeyont/utility/my_constant.dart';
import 'package:flutter/material.dart';

class Data_debtor_list extends StatefulWidget {
  const Data_debtor_list({Key? key}) : super(key: key);

  @override
  State<Data_debtor_list> createState() => _Data_debtor_listState();
}

class _Data_debtor_listState extends State<Data_debtor_list> {
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
      body: Container(
        height: MediaQuery.of(context).size.height * 0.9,
        child: Scrollbar(
          child: ListView(
            children: [],
          ),
        ),
      ),
    );
  }
}
