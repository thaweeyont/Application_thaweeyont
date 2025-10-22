import 'dart:convert';

import 'package:application_thaweeyont/api.dart';
import 'package:application_thaweeyont/state/authen.dart';
import 'package:application_thaweeyont/utility/my_constant.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_gifs/loading_gifs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../widgets/custom_appbar.dart';

class ReportSKUSaleList extends StatefulWidget {
  final dynamic itemGroupIds,
      itemTypeIds,
      idBrandlist,
      idModellist,
      idStylellist,
      idSizelist,
      idColorlist,
      selectProvinbranchlist,
      selectBranchgrouplist,
      selectAreaBranchlist,
      itemSupplyIds,
      selectMonthId1,
      selectMonthId2,
      selectMonthId3,
      selectMonthId4,
      selectYearlist1,
      selectYearlist2,
      selectYearlist3,
      selectYearlist4,
      idChkExclude;

  final String? startdate, startdatePO, enddatePO, startDatesale, endDatesale;
  const ReportSKUSaleList({
    super.key,
    this.itemGroupIds,
    this.itemTypeIds,
    this.idBrandlist,
    this.idModellist,
    this.idStylellist,
    this.idSizelist,
    this.idColorlist,
    this.selectProvinbranchlist,
    this.selectBranchgrouplist,
    this.selectAreaBranchlist,
    this.itemSupplyIds,
    this.startdate,
    this.startdatePO,
    this.enddatePO,
    this.startDatesale,
    this.endDatesale,
    this.selectMonthId1,
    this.selectMonthId2,
    this.selectMonthId3,
    this.selectMonthId4,
    this.selectYearlist1,
    this.selectYearlist2,
    this.selectYearlist3,
    this.selectYearlist4,
    this.idChkExclude,
  });

  @override
  State<ReportSKUSaleList> createState() => _ReportSKUSaleListState();
}

class _ReportSKUSaleListState extends State<ReportSKUSaleList> {
  String userId = '',
      empId = '',
      firstName = '',
      lastName = '',
      tokenId = '',
      branchId = '',
      branchAreaId = '',
      branchAreaName = '',
      appGroupId = '';

  Map<String, dynamic> tableData = {"headers": {}, "rows": []};
  bool isLoading = true;

  final _hHeaderCtrl = ScrollController();
  final _hBodyCtrl = ScrollController();
  final _vLeftCtrl = ScrollController();
  final _vBodyCtrl = ScrollController();

  static const double leftColWidth = 200;
  static const double cellWidth = 100;
  static const double simpleHeaderHeight = 60;
  static const double groupHeaderTop = 30;
  static const double groupHeaderSub = 30;
  static const double rowHeight = 70;

  var formatter = NumberFormat('#,##0.00');
  var formatterAmount = NumberFormat('#,##0');

  @override
  void initState() {
    super.initState();
    _hHeaderCtrl.addListener(() {
      if (_hBodyCtrl.offset != _hHeaderCtrl.offset) {
        _hBodyCtrl.jumpTo(_hHeaderCtrl.offset);
      }
    });
    _hBodyCtrl.addListener(() {
      if (_hHeaderCtrl.offset != _hBodyCtrl.offset) {
        _hHeaderCtrl.jumpTo(_hBodyCtrl.offset);
      }
    });
    _vLeftCtrl.addListener(() {
      if (_vBodyCtrl.offset != _vLeftCtrl.offset) {
        _vBodyCtrl.jumpTo(_vLeftCtrl.offset);
      }
    });
    _vBodyCtrl.addListener(() {
      if (_vLeftCtrl.offset != _vBodyCtrl.offset) {
        _vLeftCtrl.jumpTo(_vBodyCtrl.offset);
      }
    });
    getdata();
  }

  @override
  void dispose() {
    _hHeaderCtrl.dispose();
    _hBodyCtrl.dispose();
    _vLeftCtrl.dispose();
    _vBodyCtrl.dispose();
    super.dispose();
  }

  Future<void> getdata() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      userId = preferences.getString('userId')!;
      empId = preferences.getString('empId')!;
      firstName = preferences.getString('firstName')!;
      lastName = preferences.getString('lastName')!;
      tokenId = preferences.getString('tokenId')!;
      branchId = preferences.getString('branchId')!;
      branchAreaId = preferences.getString('branchAreaId')!;
      branchAreaName = preferences.getString('branchAreaName')!;
      appGroupId = preferences.getString('appGroupId')!;
    });
    // showProgressLoading(context);
    await getSaleSku();
    // printIncomingData();

    if (mounted) {
      // Navigator.pop(context);
      setState(() {
        isLoading = false; // โหลดเสร็จแล้ว
      });
    }
  }

  void printIncomingData() {
    print('itemGroupIds:> ${widget.itemGroupIds}');
    print('itemTypeIds:> ${widget.itemTypeIds}');
    print('idBrandlist:> ${widget.idBrandlist ?? ''}');
    print('idModellist:> ${widget.idModellist ?? ''}');
    print('idStylellist:> ${widget.idStylellist ?? ''}');
    print('idSizelist:> ${widget.idSizelist ?? ''}');
    print('idColorlist:> ${widget.idColorlist ?? ''}');
    print('selectProvinbranchlist:> ${widget.selectProvinbranchlist ?? ''}');
    print('selectBranchgrouplist:> ${widget.selectBranchgrouplist ?? ''}');
    print('selectAreaBranchlist:> ${widget.selectAreaBranchlist ?? ''}');
    print('itemSupplyIds:> ${widget.itemSupplyIds}');
    print('startdate:> ${widget.startdate ?? ''}');
    print('startdatePO:> ${widget.startdatePO ?? ''}');
    print('enddatePO:> ${widget.enddatePO ?? ''}');
    print('startDatesale:> ${widget.startDatesale ?? ''}');
    print('endDatesale:> ${widget.endDatesale ?? ''}');
    print('month1:> ${widget.selectMonthId1 ?? ''}');
    print('month2:> ${widget.selectMonthId2 ?? ''}');
    print('month3:> ${widget.selectMonthId3 ?? ''}');
    print('month4:> ${widget.selectMonthId4 ?? ''}');
    print('year1:> ${widget.selectYearlist1 ?? ''}');
    print('year2:> ${widget.selectYearlist2 ?? ''}');
    print('year3:> ${widget.selectYearlist3 ?? ''}');
    print('year4:> ${widget.selectYearlist4 ?? ''}');
    print('idChkExclude:> ${widget.idChkExclude ?? ''}');
  }

  Future<void> getSaleSku() async {
    try {
      // ✅ แปลงค่าให้เป็น String หรือว่าง
      String str(dynamic value) => (value?.toString() ?? '').trim();

      // ✅ ถ้าเป็น list และมีค่า (ไม่ว่าง) -> แปลงเป็น string ทั้งหมด
      // ถ้าไม่มีค่า -> ส่ง []
      List<String> strList(dynamic list) {
        if (list == null) return [];
        if (list is List) {
          final clean = list
              .where((e) => e != null && e.toString().trim().isNotEmpty)
              .map((e) => e.toString())
              .toList();
          return clean.isEmpty ? [] : clean;
        }
        // ถ้าไม่ใช่ list (อาจเป็น string เดี่ยว)
        return list.toString().trim().isEmpty ? [] : [list.toString()];
      }

      final bodyData = <String, dynamic>{
        'supplyArrs': strList(widget.itemSupplyIds),
        'itemGroupArrs': strList(widget.itemGroupIds),
        'itemTypeArrs': strList(widget.itemTypeIds),
        'itemBrandId': str(widget.idBrandlist),
        'itemModel': str(widget.idModellist),
        'itemStyleId': str(widget.idStylellist),
        'itemSizeId': str(widget.idSizelist),
        'colorId': str(widget.idColorlist),
        'shippingId': '',
        'channelSaleArrs': strList([]),
        'branchProvinc': str(widget.selectProvinbranchlist),
        'branchGroup': str(widget.selectBranchgrouplist),
        'branchArea': str(widget.selectAreaBranchlist),
        'year1': str(widget.selectYearlist1),
        'year2': str(widget.selectYearlist2),
        'year3': str(widget.selectYearlist3),
        'year4': str(widget.selectYearlist4),
        'month1': str(widget.selectMonthId1),
        'month2': str(widget.selectMonthId2),
        'month3': str(widget.selectMonthId3),
        'month4': str(widget.selectMonthId4),
        'startDate': str(widget.startdate),
        'startDatePo': str(widget.startdatePO),
        'endDatePo': str(widget.enddatePO),
        'startDateSale': str(widget.startDatesale),
        'endDateSale': str(widget.endDatesale),
        'chkExclude': str(widget.idChkExclude),
      };

      // ✅ แสดงข้อมูลที่จะส่ง
      // const JsonEncoder encoder = JsonEncoder.withIndent('  ');
      // print('🔹 ส่งข้อมูลไปที่ API:');
      // print(encoder.convert(bodyData));

      // ✅ เรียก API
      var response = await http.post(
        Uri.parse('${api}sale/sku'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': tokenId.toString(),
        },
        body: jsonEncode(bodyData),
      );

      // ✅ ตรวจสอบผลลัพธ์
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final head = data['data']['head'][0];
        final detail = data['data']['detail'] as List;
        final branchHead = head['branchHead'] as Map<String, dynamic>;

        final tableHeader = {
          "fixed": ["Model"],
          "columns": ["GWSP", "IncVat"],
          "groups": {
            for (var branchCode in branchHead.keys)
              branchHead[branchCode]: ["Stock", "Sale"],
          }
        };

        final tableRows = detail.map((item) {
          final qtyBranch = item['qtyBranch'] ?? {};
          final cells = [
            item['GWSP'] ?? '',
            item['incVat'] ?? '',
            for (var b in branchHead.keys) ...[
              qtyBranch[b]?['stock'] ?? '',
              qtyBranch[b]?['sale'] ?? '',
            ]
          ];

          // รวมประเภท/ยี่ห้อ/รุ่น ด้วย '/'
          final modelString = [
            item['itemTypeName'] ?? '',
            item['brandName'] ?? '',
            item['modelName'] ?? '',
          ].where((e) => e.toString().isNotEmpty).join('/');

          return {
            "model": modelString,
            "data": cells,
          };
        }).toList();

        setState(() {
          tableData = {"headers": tableHeader, "rows": tableRows};
        });
        // final datasalesku = jsonDecode(response.body);
        // print("✅ ได้ข้อมูลจาก API แล้ว:");
        // print(encoder.convert(datasalesku));
        // print('ข้อมูล: $datasalesku');
        // print("✅ แยก detail:");
        // print("detail: ${datasalesku['data']?['detail']}");
      } else {
        handleHttpError(response.statusCode);
      }
    } catch (e) {
      print("❌ ไม่มีข้อมูล / เกิดข้อผิดพลาด: $e");
      showProgressDialog(
          context, 'แจ้งเตือน', 'เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
  }

  // แยกฟังก์ชัน handle error HTTP
  void handleHttpError(int statusCode) async {
    if (statusCode == 400) {
      showProgressDialog_400(context, 'แจ้งเตือน', 'ไม่พบข้อมูล ($statusCode)');
    } else if (statusCode == 401) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.clear();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Authen()),
        (Route<dynamic> route) => false,
      );
      showProgressDialog_401(
          context, 'แจ้งเตือน', 'กรุณา Login เข้าสู่ระบบใหม่');
    } else if (statusCode == 404) {
      showProgressDialog_404(context, 'แจ้งเตือน', 'ไม่พบข้อมูล ($statusCode)');
    } else if (statusCode == 405) {
      showProgressDialog_405(context, 'แจ้งเตือน', 'ไม่พบข้อมูล ($statusCode)');
    } else if (statusCode == 500) {
      showProgressDialog_500(
          context, 'แจ้งเตือน', 'ข้อมูลผิดพลาด ($statusCode)');
    } else {
      showProgressDialog(context, 'แจ้งเตือน', 'กรุณาติดต่อผู้ดูแลระบบ');
    }
  }

  // ---------- Header Right (2 ชั้น: columns + groups) ----------
  Widget _buildHeaderRight(List<String> columns, Map<String, List> groups) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // simple columns
        ...columns.map(
          (c) =>
              _buildHeaderCell(c, width: cellWidth, height: simpleHeaderHeight),
        ),
        // grouped headers
        ...groups.entries.map((entry) {
          final subs = entry.value;
          return Column(
            children: [
              _buildHeaderCell(entry.key,
                  width: subs.length * cellWidth, height: groupHeaderTop),
              Row(
                children: subs
                    .map<Widget>((sub) => _buildHeaderCell(sub.toString(),
                        width: cellWidth, height: groupHeaderSub))
                    .toList(),
              ),
            ],
          );
        }),
      ],
    );
  }

  double _calcBodyWidth(List<String> columns, Map<String, List> groups) {
    final simpleCols = columns.length;
    final groupedCols =
        groups.values.fold<int>(0, (sum, list) => sum + list.length);
    return (simpleCols + groupedCols) * cellWidth;
  }

  // ---------------- UI Helper ----------------
  Widget _buildHeaderCell(String text,
      {double width = 100, double height = 50}) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromRGBO(239, 204, 249, 1)),
        color: Color.fromRGBO(249, 233, 249, 1),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: MyContant().h4normalStyle(),
      ),
    );
  }

  Widget _buildCell(
    String text, {
    double width = 100,
    double height = 50,
    Alignment alignment = Alignment.center,
  }) {
    return Container(
      width: width,
      height: height,
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromRGBO(239, 204, 249, 1)),
        color: Colors.white,
      ),
      child: Text(
        text,
        style: MyContant().h4normalStyle(),
      ),
    );
  }

  Widget _buildInfoBox(String text, {bool isCenter = false}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(4),
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        // border: Border.all(color: Color.fromRGBO(239, 204, 249, 1)),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        // color: Colors.purple[50],
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
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          text,
          textAlign: isCenter ? TextAlign.center : TextAlign.start,
          style: MyContant().h4normalStyle(),
        ),
      ),
    );
  }

  Center Loading() {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 24, 24, 24).withAlpha(230),
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    // final fixedHeader = tableData["headers"]["fixed"];
    final columns =
        ((tableData["headers"]?["columns"] as List?) ?? []).cast<String>();
    final groups =
        ((tableData["headers"]?["groups"] as Map?) ?? {}).cast<String, List>();
    final rows = (tableData["rows"] as List?) ?? [];

    // ถ้ายังโหลดข้อมูล ให้แสดง loading ก่อน
    if (isLoading) {
      return Scaffold(
        appBar: CustomAppbar(title: "ตารางรายงาน SKU Sale"),
        body: Loading(),
      );
    }

    return Scaffold(
      appBar: CustomAppbar(title: "ตารางรายงาน SKU Sale"),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              // ======= รายละเอียดหัวรายงาน (คงที่) =======
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoBox("รายงาน SKU SALE", isCenter: true),
                    const SizedBox(height: 5),
                    _buildInfoBox("กลุ่มสินค้า :    ประเภท : "),
                    _buildInfoBox("ณ วันที่ : "),
                    _buildInfoBox("ผู้จำหน่าย : "),
                    _buildInfoBox("ช่องทางการขาย : "),
                  ],
                ),
              ),
              // หัวตาราง
              Row(
                children: [
                  // มุมซ้ายบน (หัวคอลัมน์)
                  _buildHeaderCell('ประเภท/ยี่ห้อ/รุ่น',
                      width: leftColWidth, height: simpleHeaderHeight),
                  // หัวตารางฝั่งขวา (scroll แนวนอน)
                  Expanded(
                    child: SingleChildScrollView(
                      controller: _hHeaderCtrl,
                      scrollDirection: Axis.horizontal,
                      child: _buildHeaderRight(columns, groups),
                    ),
                  ),
                ],
              ),
              // บอดี้
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // คอลัมน์ซ้าย (ล็อค) แต่เลื่อนแนวตั้งร่วมกับบอดี้
                    SizedBox(
                      width: leftColWidth,
                      child: SingleChildScrollView(
                        controller: _vLeftCtrl,
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: rows.map((row) {
                            return _buildCell(
                              row["model"].toString(),
                              width: leftColWidth,
                              height: rowHeight,
                              alignment: Alignment.centerLeft,
                            );
                          }).toList(),
                        ),
                      ),
                    ),

                    // บอดี้ฝั่งขวา (เลื่อน 2 แกน) + ซิงก์แนวนอนกับหัว และแนวตั้งกับคอลัมน์ซ้าย
                    Expanded(
                      child: SingleChildScrollView(
                        controller: _hBodyCtrl,
                        scrollDirection: Axis.horizontal,
                        child: SizedBox(
                          // กำหนดความกว้างรวมของบอดี้ = คอลัมน์ธรรมดา + คอลัมน์ย่อยในกรุ๊ป
                          width: _calcBodyWidth(columns, groups),
                          child: SingleChildScrollView(
                            controller: _vBodyCtrl,
                            scrollDirection: Axis.vertical,
                            child: Column(
                              children: rows.map((row) {
                                final List cells = row["data"] as List;
                                return Row(
                                  children: cells.map<Widget>((cell) {
                                    return _buildCell(
                                      cell.toString(),
                                      width: cellWidth,
                                      height: rowHeight,
                                      alignment: Alignment.centerRight,
                                    );
                                  }).toList(),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
