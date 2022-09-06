import 'package:flutter/material.dart';

enum ProductTypeEum { Customer, Employee }

class Page_Checkpurchase_info extends StatefulWidget {
  const Page_Checkpurchase_info({Key? key}) : super(key: key);

  @override
  State<Page_Checkpurchase_info> createState() =>
      _Page_Checkpurchase_infoState();
}

class _Page_Checkpurchase_infoState extends State<Page_Checkpurchase_info> {
  String dropdownValue = 'ขายของ';
  String dropdownValueCus = 'รหัส';
  ProductTypeEum? _productTypeEum;

  bool st_customer = true, st_employee = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _productTypeEum = ProductTypeEum.Customer;
    });
  }

  Future<Null> search_idcustomer(sizeIcon, border) async {
    double size = MediaQuery.of(context).size.width;
    // bool btn_edit = false;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        behavior: HitTestBehavior.opaque,
        child: StatefulBuilder(
          builder: (context, setState) => Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(5),
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    elevation: 0,
                    color: Colors.white,
                    child: Container(
                      margin: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          SizedBox(
                            height: size * 0.03,
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                left: 15, right: 15, bottom: 15),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () => Navigator.pop(context),
                                      child: Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                            color:
                                                Color.fromRGBO(202, 71, 150, 1),
                                            shape: BoxShape.circle),
                                        child: Icon(
                                          Icons.close,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              color: Color.fromRGBO(229, 188, 244, 1),
                            ),
                            padding: EdgeInsets.all(8),
                            width: double.infinity,
                            child: Column(children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: RadioListTile<ProductTypeEum>(
                                      contentPadding: EdgeInsets.all(0.0),
                                      tileColor: Colors.blue.shade100,
                                      value: ProductTypeEum.Customer,
                                      groupValue: _productTypeEum,
                                      title: Text('ลูกค้าทั่วไป'),
                                      onChanged: (val) {
                                        print(val);
                                        setState(() {
                                          st_customer = true;
                                          st_employee = false;
                                          _productTypeEum = val;
                                        });
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: RadioListTile<ProductTypeEum>(
                                      value: ProductTypeEum.Employee,
                                      groupValue: _productTypeEum,
                                      title: Text('พนักงาน'),
                                      onChanged: (val) {
                                        setState(() {
                                          st_customer = false;
                                          st_employee = true;
                                          _productTypeEum = val;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              if (st_employee == true) ...[
                                Row(
                                  children: [
                                    Text('ชื่อ'),
                                    input_nameCusDia(sizeIcon, border),
                                    Text('สกุล'),
                                    input_lastNameCusDia(sizeIcon, border),
                                  ],
                                ),
                              ],
                              if (st_customer == true) ...[
                                Row(
                                  children: [
                                    // Text('ชื่อ'),
                                    select_searchCus(sizeIcon, border),
                                    // Text('สกุล'),
                                    input_searchCus(sizeIcon, border),
                                  ],
                                ),
                              ],
                            ]),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  height: 30,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    color: Color.fromRGBO(76, 83, 146, 1),
                                  ),
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.all(0),
                                      primary: Colors.white,
                                      textStyle: const TextStyle(fontSize: 16),
                                    ),
                                    onPressed: () {},
                                    child: const Text('ค้นหา'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Text('รายการที่ค้นหา'),
                            ],
                          ),
                          SizedBox(height: 10),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.4,
                            child: Scrollbar(
                              child: ListView(
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(vertical: 5),
                                    padding: EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                      color: Color.fromRGBO(229, 188, 244, 1),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text('รหัส : M181505470255'),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                                'ชื่อ-สกุล : นางสาว กรรณิการ์ ทาทัน (13914)'),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('ที่อยู่ : '),
                                            Expanded(
                                              child: Text(
                                                'เลขประจำตัวผู้เสียภาษี 1570400205606 25 ม.2 ต.ปล้อง อ.เทิง จ.เชียงราย 57230',
                                                overflow: TextOverflow.clip,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            Text('โทร : 097-1931096'),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sizeIcon = BoxConstraints(minWidth: 40, minHeight: 40);
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
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        behavior: HitTestBehavior.opaque,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(229, 188, 244, 1),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text('รหัสลูกค้า'),
                        input_idcustomer(sizeIcon, border),
                        InkWell(
                          onTap: () {
                            search_idcustomer(sizeIcon, border);
                          },
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(202, 71, 150, 1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.search,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text('ชื่อลูกค้า'),
                        input_namecustomer(sizeIcon, border),
                      ],
                    ),
                    Row(
                      children: [
                        Text('ประเภทการขาย'),
                        input_sale_type(sizeIcon, border),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            group_btnsearch(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text('รายการที่ค้นหา'),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.6,
              child: Scrollbar(
                child: ListView(
                  children: [
                    for (var i = 0; i <= 5; i++) ...[
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          color: Color.fromRGBO(229, 188, 244, 1),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('ลำดับ : ${i + 1}'),
                                Text('วันที่ขาย : 16/08/2565'),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text('เลขที่เอกสาร : RC0122080179'),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text('ชื่อลูกค้า : กรรณิการ์ ทาทัน'),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text('รายการสินค้า : เตารีด PHILIPS GCI426'),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('ราคา : 590.00'),
                                Text('ประเภทการขาย : ขายแคช'),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text('พนักงานขาย : นิมิตร สุวรรณประภา'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding group_btnsearch() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Container(
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Color.fromRGBO(76, 83, 146, 1),
                      ),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.all(0),
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                        onPressed: () {},
                        child: const Text('ค้นหา'),
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Color.fromRGBO(248, 40, 78, 1),
                      ),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.all(0),
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                        onPressed: () {},
                        child: const Text('ยกเลิก'),
                      ),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Expanded input_idcustomer(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          keyboardType: TextInputType.number,
          onChanged: (keyword) {},
          decoration: InputDecoration(
            counterText: "",
            contentPadding: EdgeInsets.all(4),
            isDense: true,
            enabledBorder: border,
            focusedBorder: border,
            hintStyle: TextStyle(
              fontSize: 14,
            ),
            prefixIconConstraints: sizeIcon,
            suffixIconConstraints: sizeIcon,
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ),
    );
  }

  Expanded input_namecustomer(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          onChanged: (keyword) {},
          decoration: InputDecoration(
            counterText: "",
            contentPadding: EdgeInsets.all(4),
            isDense: true,
            enabledBorder: border,
            focusedBorder: border,
            hintStyle: TextStyle(
              fontSize: 14,
            ),
            prefixIconConstraints: sizeIcon,
            suffixIconConstraints: sizeIcon,
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ),
    );
  }

  Expanded input_sale_type(sizeIcon, border) {
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
            items: <String>['ขายของ', 'ขายน้ำ', 'ขายอาหาร', 'ขายฝัน']
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

  Expanded input_nameCusDia(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          onChanged: (keyword) {},
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(4),
            isDense: true,
            enabledBorder: border,
            focusedBorder: border,
            hintStyle: TextStyle(
              fontSize: 14,
            ),
            prefixIconConstraints: sizeIcon,
            suffixIconConstraints: sizeIcon,
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ),
    );
  }

  Expanded input_lastNameCusDia(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          onChanged: (keyword) {},
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(4),
            isDense: true,
            enabledBorder: border,
            focusedBorder: border,
            hintStyle: TextStyle(
              fontSize: 14,
            ),
            prefixIconConstraints: sizeIcon,
            suffixIconConstraints: sizeIcon,
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ),
    );
  }

  Expanded select_searchCus(sizeIcon, border) {
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
            value: dropdownValueCus,
            elevation: 16,
            style: TextStyle(
                fontFamily: 'Prompt', fontSize: 14, color: Colors.black),
            underline: SizedBox(),
            onChanged: (String? newValue) {
              setState(() {
                dropdownValueCus = newValue!;
              });
            },
            items: <String>['รหัส', 'ชื่อ', 'ที่อยู่ ', 'เบอร์โทร']
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

  Expanded input_searchCus(sizeIcon, border) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          onChanged: (keyword) {},
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(4),
            isDense: true,
            enabledBorder: border,
            focusedBorder: border,
            hintStyle: TextStyle(
              fontSize: 14,
            ),
            prefixIconConstraints: sizeIcon,
            suffixIconConstraints: sizeIcon,
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ),
    );
  }
}
