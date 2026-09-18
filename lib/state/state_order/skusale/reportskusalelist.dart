import 'dart:convert';

import 'package:application_thaweeyont/api.dart';
import 'package:application_thaweeyont/state/authen.dart';
import 'package:application_thaweeyont/utility/my_constant.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_gifs/loading_gifs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:linked_scroll_controller/linked_scroll_controller.dart';

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
  List<String>? itemBrandPC;

  Map<String, dynamic> tableData = {"headers": {}, "rows": []};
  bool isLoading = true;

  final LinkedScrollControllerGroup _linkedScrollGroup =
      LinkedScrollControllerGroup();
  late ScrollController _vLeftCtrl;
  late ScrollController _vBodyCtrl;
  final ScrollController _hHeaderCtrl = ScrollController();
  final ScrollController _hBodyCtrl = ScrollController();

  final double leftColWidth = 200;
  final double cellWidth = 100;
  final double rowHeight = 70;
  final double simpleHeaderHeight = 60;

  String itemGroupName = '';
  String itemTypeName = '';
  String itemBrandName = '';
  String supplyName = '';
  String channelSaleName = '';
  String reportDate = '';

  @override
  void initState() {
    super.initState();
    _vLeftCtrl = _linkedScrollGroup.addAndGet();
    _vBodyCtrl = _linkedScrollGroup.addAndGet();
    // ✅ sync แนวนอน (header ↔ body)
    _hHeaderCtrl.addListener(() {
      if (_hBodyCtrl.hasClients && _hHeaderCtrl.offset != _hBodyCtrl.offset) {
        _hBodyCtrl.jumpTo(_hHeaderCtrl.offset);
      }
    });
    _hBodyCtrl.addListener(() {
      if (_hHeaderCtrl.hasClients && _hBodyCtrl.offset != _hHeaderCtrl.offset) {
        _hHeaderCtrl.jumpTo(_hBodyCtrl.offset);
      }
    });
    getdata();
  }

  @override
  void dispose() {
    _vLeftCtrl.dispose();
    _vBodyCtrl.dispose();
    _hHeaderCtrl.dispose();
    _hBodyCtrl.dispose();

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
      itemBrandPC = preferences.getStringList('itemBrandPC')!;
    });

    await getSaleSku();

    if (mounted) {
      setState(() {
        isLoading = false;
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

  String _formatDate(String dateStr) {
    if (dateStr.isEmpty || dateStr.length != 8) return '';
    final year = dateStr.substring(0, 4);
    final month = dateStr.substring(4, 6);
    final day = dateStr.substring(6, 8);
    return '$day/$month/$year';
  }

  Future<void> getSaleSku() async {
    try {
      // ✅ แปลงค่าให้เป็น String หรือว่าง
      String str(dynamic value) => (value?.toString() ?? '').trim();

      // ✅ ฟังก์ชันแปลง list ให้เป็น array ของ string (แยกค่าที่คั่นด้วย comma)
      List<String> strList(dynamic list) {
        if (list == null) return [];
        if (list is List) {
          final clean = list
              .where((e) => e != null && e.toString().trim().isNotEmpty)
              .expand((e) => e.toString().split(','))
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .toList();
          return clean;
        }
        // ถ้าไม่ใช่ list (อาจเป็น string เดียว)
        final single = list.toString().trim();
        return single.isEmpty
            ? []
            : single.split(',').map((e) => e.trim()).toList();
      }

      // ✅ ฟอร์แมตตัวเลข (มีทศนิยมเฉพาะเมื่อมีจริง)
      final formatter = NumberFormat('#,##0.##');
      bool isNumeric(value) =>
          value != null && double.tryParse(value.toString()) != null;
      String fmt(value) => isNumeric(value)
          ? formatter.format(double.parse(value.toString()))
          : (value?.toString() ?? '');

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

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final head = data['data']['head'][0];
        final detail = data['data']['detail'] as List;
        final branchHead = head['branchHead'] as Map<String, dynamic>;

        // ✅ ดึงชื่อเดือนจาก API
        final months = [
          head['monthName1'],
          head['monthName2'],
          head['monthName3'],
          head['monthName4'],
          "ย้อนหลัง 1 เดือน",
          head['monthName5'],
        ].where((m) => m != null && m.toString().isNotEmpty).toList();

        setState(() {
          itemGroupName = head['itemGroupName'] ?? '';
          itemTypeName = head['itemTypeName'] ?? '';
          itemBrandName = head['itemBrandName'] ?? '';
          supplyName = head['supplyName'] ?? '';
          channelSaleName = head['channelSaleName'] ?? '';
          reportDate = _formatDate(head['date'] ?? '');
        });

        final tableHeader = {
          "fixed": ["Model"],
          "columns": [
            "GWSP",
            "IncVat",
            "SRP",
            ...months,
            "WH",
            "WS",
            "MP",
            "CL"
          ],
          "groups": {
            for (var branchCode in branchHead.keys)
              branchHead[branchCode]: ["Stock", "Sale"],
          },
          "col_extra": [
            "จำนวนค้างรับ",
            "TOTAL Stock",
            "TOTAL Sale",
            "TOTAL AMT",
            "Aging Stock"
          ],
        };

        // ✅ สร้างแถวข้อมูล
        final tableRows = detail.map((e) {
          final Map<String, dynamic> item = Map<String, dynamic>.from(e);
          final qtyBranch = item['qtyBranch'] ?? {};

          final monthValues = [
            fmt(item.containsKey('salePriceMonth1')
                ? item['salePriceMonth1']
                : ''),
            fmt(item.containsKey('salePriceMonth2')
                ? item['salePriceMonth2']
                : ''),
            fmt(item.containsKey('salePriceMonth3')
                ? item['salePriceMonth3']
                : ''),
            fmt(item.containsKey('salePriceMonth4')
                ? item['salePriceMonth4']
                : ''),
            fmt(item.containsKey('lastOneMonth') ? item['lastOneMonth'] : ''),
            fmt(item.containsKey('lastYear') ? item['lastYear'] : ''),
          ];

          final cells = [
            fmt(item['GWSP']),
            fmt(item['incVat']),
            fmt(item['SRP']),
            ...monthValues, // ✅ แสดงข้อมูลเดือน
            fmt(item['stockWH']),
            fmt(item['stockWS']),
            fmt(item['stockMP']),
            fmt(item['stockCLAM']),
            for (var b in branchHead.keys) ...[
              fmt(qtyBranch[b]?['stock']),
              fmt(qtyBranch[b]?['sale']),
            ],
            fmt(item['qtyOrder']),
            fmt(item['qtyAll']),
            fmt(item['qtySaleAll']),
            fmt(item['amt']),
            fmt(item['ageStock']),
          ];

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

  Widget _buildHeaderRight(
    List<String> columns,
    Map<String, List> groups,
    List<String> col_extra,
  ) {
    return Row(
      children: [
        ...columns.map((col) => _buildHeaderCell(col)),
        for (var groupEntry in groups.entries)
          Column(
            children: [
              Container(
                width: groupEntry.value.length * cellWidth,
                height: simpleHeaderHeight / 2,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: Color.fromRGBO(239, 204, 249, 1)),
                  color: Color.fromRGBO(249, 233, 249, 1),
                ),
                child: Text(
                  groupEntry.key,
                  style: MyContant().h4normalStyle(),
                ),
              ),
              Row(
                children: groupEntry.value
                    .map((sub) =>
                        _buildHeaderCell(sub, height: simpleHeaderHeight / 2))
                    .toList(),
              ),
            ],
          ),
        ...col_extra.map((extra) => _buildHeaderCell(extra)),
      ],
    );
  }

  double _calcBodyWidth(
    List<String> columns,
    Map<String, List> groups,
    List<String> col_extra,
  ) {
    int totalCols = columns.length; // GWSP + IncVat + เดือน
    // รวมทุก sub-column ของแต่ละ group
    for (var g in groups.values) {
      totalCols += g.length;
    }
    // บวกจำนวนคอลัมน์ extra ต่อท้าย
    totalCols += col_extra.length;

    // ✅ สรุป: ทุกคอลัมน์ใช้ cellWidth เหมือนกัน (หรือจะคูณแยกก็ได้)
    return totalCols * cellWidth;
  }

  Widget _buildHeaderCell(String text, {double? width, double? height}) {
    return Container(
      width: width ?? cellWidth,
      height: height ?? simpleHeaderHeight,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromRGBO(239, 204, 249, 1)),
        color: Color.fromRGBO(249, 233, 249, 1),
      ),
      child: Text(
        text,
        style: MyContant().h4normalStyle(),
        maxLines: 2,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildCell(
    String text, {
    double? width,
    double? height,
    Alignment alignment = Alignment.center,
  }) {
    return RepaintBoundary(
      child: Container(
        width: width ?? cellWidth,
        height: height ?? rowHeight,
        alignment: alignment,
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: Color.fromRGBO(239, 204, 249, 1),
          ),
        ),
        child: Text(
          text,
          style: MyContant().h4normalStyle(),
        ),
      ),
    );
  }

  Widget _buildInfoBox(String text, {bool isCenter = false}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(4),
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
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
    final columns =
        ((tableData["headers"]?["columns"] as List?) ?? []).cast<String>();
    final groups =
        ((tableData["headers"]?["groups"] as Map?) ?? {}).cast<String, List>();
    final col_extra =
        ((tableData["headers"]?["col_extra"] as List?) ?? []).cast<String>();
    final rows = (tableData["rows"] as List?) ?? [];

    // ถ้ายังโหลดข้อมูล ให้แสดง loading ก่อน
    if (isLoading) {
      return Scaffold(
        appBar: CustomAppbar(title: "รายงาน SKU Sale"),
        body: Loading(),
      );
    }

    return Scaffold(
      appBar: CustomAppbar(title: "รายงาน SKU Sale"),
      body: ScrollConfiguration(
        behavior: NoGlowBehavior(),
        child: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 8),
          child: Column(
            children: [
              // ======= รายละเอียดหัวรายงาน =======
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // _buildInfoBox("รายงาน SKU SALE", isCenter: true),
                    // const SizedBox(height: 5),
                    _buildInfoBox(
                        "กลุ่มสินค้า : $itemGroupName  ประเภท : $itemTypeName  ยี่ห้อ : $itemBrandName"),
                    _buildInfoBox("ณ วันที่ : $reportDate"),
                    _buildInfoBox("ผู้จำหน่าย : $supplyName"),
                    _buildInfoBox("ช่องทางการขาย : $channelSaleName"),
                  ],
                ),
              ),

              // ======= หัวตาราง =======
              Row(
                children: [
                  _buildHeaderCell('ประเภท/ยี่ห้อ/รุ่น',
                      width: leftColWidth, height: simpleHeaderHeight),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      controller: _hHeaderCtrl,
                      scrollDirection: Axis.horizontal,
                      child: _buildHeaderRight(columns, groups, col_extra),
                    ),
                  ),
                ],
              ),

              // ======= เนื้อหาตาราง =======
              Expanded(
                child: rows.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.info_outline,
                                color: Colors.grey[500], size: 50),
                            const SizedBox(height: 12),
                            Text(
                              'ไม่พบข้อมูลรายงาน',
                              style: MyContant().h5NotData(),
                            ),
                          ],
                        ),
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // คอลัมน์ซ้าย
                          SizedBox(
                            width: leftColWidth,
                            child: ListView.builder(
                              physics: const ClampingScrollPhysics(),
                              controller: _vLeftCtrl,
                              itemCount: rows.length,
                              itemBuilder: (context, index) {
                                final row = rows[index];
                                return _buildCell(
                                  row["model"].toString(),
                                  width: leftColWidth,
                                  height: rowHeight,
                                  alignment: Alignment.centerLeft,
                                );
                              },
                            ),
                          ),

                          // บอดี้ฝั่งขวา
                          Expanded(
                            child: SingleChildScrollView(
                              physics: const ClampingScrollPhysics(),
                              controller: _hBodyCtrl,
                              scrollDirection: Axis.horizontal,
                              child: SizedBox(
                                width:
                                    _calcBodyWidth(columns, groups, col_extra),
                                child: ListView.builder(
                                  physics: const ClampingScrollPhysics(),
                                  controller: _vBodyCtrl,
                                  itemCount: rows.length,
                                  itemBuilder: (context, index) {
                                    final row = rows[index];
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
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NoGlowBehavior extends ScrollBehavior {
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
