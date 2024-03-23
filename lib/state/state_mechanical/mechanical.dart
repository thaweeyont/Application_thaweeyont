import 'package:application_thaweeyont/state/state_mechanical/mechanicaldetail.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../utility/my_constant.dart';

class Mechanical extends StatefulWidget {
  const Mechanical({Key? key}) : super(key: key);

  @override
  State<Mechanical> createState() => _MechanicalState();
}

class _MechanicalState extends State<Mechanical> {
  bool actionButton = false;

  TextEditingController date = TextEditingController();
  TextEditingController saleTranId = TextEditingController();
  TextEditingController workReqTranId = TextEditingController();

  @override
  void initState() {
    super.initState();
    actionButton = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            actionButton = true;
                          });
                        },
                        style: ButtonStyle(
                          backgroundColor: actionButton == true
                              ? MaterialStateProperty.all(
                                  const Color.fromARGB(255, 196, 154, 4),
                                )
                              : MaterialStateProperty.all(
                                  const Color.fromARGB(255, 241, 209, 89),
                                ),
                          shape: MaterialStateProperty.all(
                            const RoundedRectangleBorder(
                              borderRadius: BorderRadiusDirectional.only(
                                topStart: Radius.circular(20),
                                bottomStart: Radius.circular(20),
                              ),
                            ),
                          ),
                        ),
                        child: Text(
                          "งานของฉัน",
                          style: MyContant().h1MenuStyle(),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            actionButton = false;
                          });
                        },
                        style: ButtonStyle(
                          backgroundColor: actionButton == false
                              ? MaterialStateProperty.all(
                                  const Color.fromARGB(255, 196, 154, 4),
                                )
                              : MaterialStateProperty.all(
                                  const Color.fromARGB(255, 241, 209, 89),
                                ),
                          shape: MaterialStateProperty.all(
                            const RoundedRectangleBorder(
                              borderRadius: BorderRadiusDirectional.only(
                                topEnd: Radius.circular(20),
                                bottomEnd: Radius.circular(20),
                              ),
                            ),
                          ),
                        ),
                        child: Text(
                          'ค้นหางาน',
                          style: MyContant().h1MenuStyle(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (actionButton == true) ...[
              myJob()
            ] else ...[
              searchJob(),
              groupBtnsearch(),
            ]
          ],
        ),
      ),
    );
  }

  Padding searchJob() {
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 241, 209, 89),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Text(
                          'วันที่ : ',
                          style: MyContant().h6Style(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    Row(
                      children: [
                        Text(
                          'เลขที่ใบขาย : ',
                          style: MyContant().h6Style(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    Row(
                      children: [
                        Text(
                          'เลขที่ใบขอช่าง : ',
                          style: MyContant().h6Style(),
                        ),
                      ],
                    ),
                  ],
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          inputDate(sizeIcon, border),
                        ],
                      ),
                      Row(
                        children: [
                          inputsaleTranId(sizeIcon, border),
                        ],
                      ),
                      Row(
                        children: [
                          inputworkReqTranId(sizeIcon, border),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  GestureDetector myJob() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MechanicalDetail(),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 241, 209, 89),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
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
                    'เลขที่ใบขอช่าง : ',
                    style: MyContant().h6Style(),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  Text(
                    'เลขที่ใบขาย : ',
                    style: MyContant().h6Style(),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  Text(
                    'ชื่อ-สกุล : ',
                    style: MyContant().h6Style(),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  Text(
                    'วันที่จัดส่ง : ',
                    style: MyContant().h6Style(),
                  ),
                ],
              ),
            ],
          ),
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
                      onPressed: () {},
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

  Expanded inputDate(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: TextField(
          controller: date,
          onChanged: (keyword) {},
          readOnly: true,
          decoration: InputDecoration(
            suffixIcon: const Icon(
              Icons.calendar_today,
              color: Colors.black,
            ),
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
                date.text =
                    '$newYear$formattedDate'; //set output date to TextField value.
              });
            } else {}
          },
        ),
      ),
    );
  }

  Expanded inputsaleTranId(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: TextField(
          controller: saleTranId,
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

  Expanded inputworkReqTranId(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: TextField(
          controller: workReqTranId,
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
}
