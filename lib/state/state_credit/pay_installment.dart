import 'package:flutter/material.dart';

class Pay_installment extends StatefulWidget {
  const Pay_installment({Key? key}) : super(key: key);

  @override
  State<Pay_installment> createState() => _Pay_installmentState();
}

class _Pay_installmentState extends State<Pay_installment> {
  String dropdownValue = '1';

  @override
  Widget build(BuildContext context) {
    final sizeIcon = BoxConstraints(minWidth: 20, minHeight: 20);
    final border = OutlineInputBorder(
      borderSide: const BorderSide(
        color: Colors.transparent,
        width: 0,
      ),
      borderRadius: const BorderRadius.all(
        const Radius.circular(4.0),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('ค้นหาข้อมูล'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                color: Color.fromRGBO(255, 218, 249, 1),
              ),
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('งวดที่ : '),
                  input_pay_installment(sizeIcon, border),
                ],
              ),
            ),
            Container(
              color: Color.fromRGBO(255, 218, 249, 1),
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('งวดที่ : 1'),
                      Text('วันที่ใบเสร็จ : 20/07/62'),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('เลขที่ใบเสร็จ : R301190778395'),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('จำนวนเงิน : 1,065.00'),
                      Text('ค่าปรับ : '),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Text('ประเภทการรับ : เงินสด'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Expanded input_pay_installment(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(1),
        child: Container(
          height: MediaQuery.of(context).size.width * 0.07,
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: DropdownButton<String>(
            isExpanded: true,
            value: dropdownValue,
            elevation: 16,
            style: TextStyle(
                fontFamily: 'Prompt', fontSize: 14, color: Colors.black),
            underline: SizedBox(),
            onChanged: (String? newValue) {
              setState(() {
                dropdownValue = newValue!;
              });
            },
            items: <String>['1', '2', '3', '4']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
