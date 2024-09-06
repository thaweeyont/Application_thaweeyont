import 'package:application_thaweeyont/state/state_payment/payment/paymentreportlist.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../utility/my_constant.dart';
import '../../../widgets/custom_appbar.dart';

class SearchPaymentReport extends StatefulWidget {
  const SearchPaymentReport({super.key});

  @override
  State<SearchPaymentReport> createState() => _SearchPaymentReportState();
}

class _SearchPaymentReportState extends State<SearchPaymentReport> {
  List dropdownbranch = [],
      dropdownsupplylist = [],
      dropdownemployeelist = [],
      dropdownpaymenttypeliist = [];
  var selectBranchlist,
      selectSupplylist,
      selectEmployeelist,
      selectpaymentTypelist;
  TextEditingController supplylist = TextEditingController();
  TextEditingController startdate = TextEditingController();
  TextEditingController enddate = TextEditingController();
  TextEditingController employeelist = TextEditingController();
  TextEditingController paydetail = TextEditingController();
  TextEditingController paytypeId = TextEditingController();

  @override
  void initState() {
    super.initState();
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
      appBar: const CustomAppbar(title: 'ค้นหารายงานการจ่ายเงิน'),
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
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 0.2,
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    )
                  ],
                  color: const Color.fromRGBO(226, 199, 132, 1),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'สาขา',
                          style: MyContant().h4normalStyle(),
                        ),
                        selectBranch(sizeIcon, border)
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'ผู้จำหน่าย',
                          style: MyContant().h4normalStyle(),
                        ),
                        selectSupplyList(sizeIcon, border),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'วันที่',
                          style: MyContant().h4normalStyle(),
                        ),
                        inputStartdate(sizeIcon, border),
                        Text(
                          'ถึง',
                          style: MyContant().h4normalStyle(),
                        ),
                        inputEnddate(sizeIcon, border)
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'ผู้จ่าย',
                          style: MyContant().h4normalStyle(),
                        ),
                        selectEmployeeList(sizeIcon, border),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'รายการจ่าย',
                          style: MyContant().h4normalStyle(),
                        ),
                        inputPaydetail(sizeIcon, border)
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'ประเภทการจ่าย',
                          style: MyContant().h4normalStyle(),
                        ),
                        selectPaytypeList(sizeIcon, border),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            groupBtnsearch(),
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
                    width: MediaQuery.of(context).size.width * 0.22,
                    child: ElevatedButton(
                      style: MyContant().myButtonSearchStyle(),
                      onPressed: () {
                        // if (date.text.isEmpty &&
                        //     saleTranId.text.isEmpty &&
                        //     workReqTranId.text.isEmpty) {
                        //   showProgressDialog(
                        //       context, 'แจ้งเตือน', 'กรุณากรอกข้อมูล!');
                        // } else {
                        //   var changeDate =
                        //       date.text.toString().replaceAll('-', '');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PaymentReportList(),
                          ),
                        );
                        // }
                      },
                      child: const Text('ค้นหา'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.038,
                    width: MediaQuery.of(context).size.width * 0.22,
                    child: ElevatedButton(
                      style: MyContant().myButtonCancelStyle(),
                      onPressed: () {},
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

  Expanded selectBranch(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: MediaQuery.of(context).size.width * 0.1,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: Padding(
            padding: const EdgeInsets.only(left: 4),
            child: DropdownButton(
              items: dropdownbranch
                  .map((value) => DropdownMenuItem(
                        value: value['id'],
                        child: Text(
                          value['name'],
                          style: MyContant().TextInputStyle(),
                        ),
                      ))
                  .toList(),
              onChanged: (newvalue) {
                setState(() {
                  selectBranchlist = newvalue;
                });
              },
              value: selectBranchlist,
              isExpanded: true,
              underline: const SizedBox(),
              hint: Align(
                child: Text(
                  'เลือกสาขา',
                  style: MyContant().TextInputSelect(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Expanded selectSupplyList(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: MediaQuery.of(context).size.width * 0.1,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: Padding(
            padding: const EdgeInsets.only(left: 4),
            child: DropdownButton(
              items: dropdownsupplylist
                  .map((value) => DropdownMenuItem(
                        value: value['id'],
                        child: Text(
                          value['name'],
                          style: MyContant().TextInputStyle(),
                        ),
                      ))
                  .toList(),
              onChanged: (newvalue) {
                setState(() {
                  selectSupplylist = newvalue;
                });
              },
              value: selectSupplylist,
              isExpanded: true,
              underline: const SizedBox(),
              hint: Align(
                child: Text(
                  'เลือกผู้จำหน่าย',
                  style: MyContant().TextInputSelect(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Expanded inputStartdate(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: TextField(
          controller: startdate,
          onChanged: (keyword) {},
          readOnly: true,
          decoration: InputDecoration(
            suffixIcon: const Icon(
              Icons.calendar_today,
              color: Colors.black,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            isDense: true,
            enabledBorder: border,
            focusedBorder: border,
            prefixIconConstraints: sizeIcon,
            suffixIconConstraints: sizeIcon,
            filled: true,
            fillColor: Colors.white,
          ),
          style: MyContant().TextInputDate(),
          onTap: () async {
            DateTime? pickeddate = await showDatePicker(
              context: context,
              locale: const Locale("th", "TH"),
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );
            if (pickeddate != null) {
              var formattedDate = DateFormat('-MM-dd').format(pickeddate);
              var formattedyear = DateFormat('yyyy').format(pickeddate);
              var year = int.parse(formattedyear);
              final newYear =
                  [year, 543].reduce((value, element) => value + element);

              setState(() {
                startdate.text =
                    '$newYear$formattedDate'; //set output date to TextField value.
              });
            } else {}
          },
        ),
      ),
    );
  }

  Expanded inputEnddate(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: TextField(
          controller: enddate,
          onChanged: (keyword) {},
          readOnly: true,
          decoration: InputDecoration(
            suffixIcon: const Icon(
              Icons.calendar_today,
              color: Colors.black,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            isDense: true,
            enabledBorder: border,
            focusedBorder: border,
            prefixIconConstraints: sizeIcon,
            suffixIconConstraints: sizeIcon,
            filled: true,
            fillColor: Colors.white,
          ),
          style: MyContant().TextInputDate(),
          onTap: () async {
            DateTime? pickeddate = await showDatePicker(
              context: context,
              locale: const Locale("th", "TH"),
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );
            if (pickeddate != null) {
              var formattedDate = DateFormat('-MM-dd').format(pickeddate);
              var formattedyear = DateFormat('yyyy').format(pickeddate);
              var year = int.parse(formattedyear);
              final newYear =
                  [year, 543].reduce((value, element) => value + element);

              setState(() {
                enddate.text =
                    '$newYear$formattedDate'; //set output date to TextField value.
              });
            } else {}
          },
        ),
      ),
    );
  }

  Expanded selectEmployeeList(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: MediaQuery.of(context).size.width * 0.1,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: Padding(
            padding: const EdgeInsets.only(left: 4),
            child: DropdownButton(
              items: dropdownemployeelist
                  .map((value) => DropdownMenuItem(
                        value: value['id'],
                        child: Text(
                          value['name'],
                          style: MyContant().TextInputStyle(),
                        ),
                      ))
                  .toList(),
              onChanged: (newvalue) {
                setState(() {
                  selectEmployeelist = newvalue;
                });
              },
              value: selectEmployeelist,
              isExpanded: true,
              underline: const SizedBox(),
              hint: Align(
                child: Text(
                  'เลือกผู้จ่าย',
                  style: MyContant().TextInputSelect(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Expanded inputPaydetail(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: TextField(
          controller: paydetail,
          onChanged: (keyword) {},
          decoration: InputDecoration(
            counterText: "",
            contentPadding: const EdgeInsets.all(6),
            isDense: true,
            enabledBorder: border,
            focusedBorder: border,
            prefixIconConstraints: sizeIcon,
            suffixIconConstraints: sizeIcon,
            filled: true,
            fillColor: Colors.white,
          ),
          style: MyContant().TextInputStyle(),
        ),
      ),
    );
  }

  Expanded selectPaytypeList(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: MediaQuery.of(context).size.width * 0.1,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: Padding(
            padding: const EdgeInsets.only(left: 4),
            child: DropdownButton(
              items: dropdownpaymenttypeliist
                  .map((value) => DropdownMenuItem(
                        value: value['id'],
                        child: Text(
                          value['name'],
                          style: MyContant().TextInputStyle(),
                        ),
                      ))
                  .toList(),
              onChanged: (newvalue) {
                setState(() {
                  selectpaymentTypelist = newvalue;
                });
              },
              value: selectpaymentTypelist,
              isExpanded: true,
              underline: const SizedBox(),
              hint: Align(
                child: Text(
                  'เลือกประเภทการจ่าย',
                  style: MyContant().TextInputSelect(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PaymentType extends StatelessWidget {
  const PaymentType({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: 'ค้นหาผู้จำหน่าย'),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(
                context, 'Hello from SecondPage'); // ย้อนกลับไปหน้าก่อนหน้า
          },
          child: const Text('Back to Home Page'),
        ),
      ),
    );
  }
}
