import 'package:application_thaweeyont/utility/my_constant.dart';
import 'package:application_thaweeyont/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

class FixedTablePage extends StatefulWidget {
  const FixedTablePage({super.key});

  @override
  State<FixedTablePage> createState() => _FixedTablePageState();
}

class _FixedTablePageState extends State<FixedTablePage> {
  // ---- tableData ----
  final Map<String, dynamic> tableData = {
    "headers": {
      "fixed": ["ประเภท/ยี่ห้อ/รุ่น"], // คอลัมน์ที่ล็อคไว้
      "columns": [
        "GWSP",
        "Inc VAT",
        "SRP",
        "ม.ค.67",
        "ก.พ.67",
        "มี.ค.67",
        "เม.ย.67",
      ],
      "groups": {
        "สาขาแม่กรณ์ / MK": ["Sale", "Stock"],
        "สาขาแม่สาย / MS": ["Sale", "Stock"],
        "สาขาพะเยา / PY": ["Sale", "Stock"],
        "Total": ["Sale", "Stock"],
      },
    },
    "rows": [
      {
        "model": "เครื่องซักผ้า/SAMSUNG/WA15CG5441BYST",
        "data": [
          "7141",
          "7640.87",
          "8490",
          "36",
          "22",
          "24",
          "23",
          "0",
          "0",
          "0",
          "0",
          "0",
          "0",
          "0",
          "0"
        ],
      },
      {
        "model": "เครื่องซักผ้า/SAMSUNG/WA15N6780C/ST",
        "data": [
          "10085",
          "10791",
          "0",
          "0",
          "0",
          "0",
          "0",
          "0",
          "1",
          "0",
          "1",
          "0",
          "1",
          "0",
          "2"
        ],
      },
      {
        "model": "ตู้เย็น/SAMSUNG/RT38K501JS8/ST",
        "data": [
          "12500",
          "13375",
          "14590",
          "12",
          "15",
          "10",
          "8",
          "2",
          "1",
          "1",
          "0",
          "0",
          "1",
          "3",
          "2"
        ],
      },
      {
        "model": "ทีวี/SAMSUNG/UA55AU7700KXXT",
        "data": [
          "15990",
          "17110",
          "18990",
          "20",
          "18",
          "22",
          "15",
          "3",
          "2",
          "2",
          "1",
          "1",
          "1",
          "6",
          "4"
        ],
      },
      {
        "model": "แอร์/SAMSUNG/AR13TYHYEWKNEU",
        "data": [
          "13200",
          "14124",
          "15900",
          "8",
          "10",
          "7",
          "9",
          "1",
          "1",
          "0",
          "1",
          "1",
          "0",
          "2",
          "2"
        ],
      },
      {
        "model": "ไมโครเวฟ/SAMSUNG/ME711K",
        "data": [
          "2490",
          "2664",
          "2990",
          "30",
          "28",
          "25",
          "27",
          "4",
          "3",
          "3",
          "2",
          "2",
          "1",
          "9",
          "6"
        ],
      },
      {
        "model": "เครื่องดูดฝุ่น/SAMSUNG/VC18M2120SB",
        "data": [
          "3890",
          "4153",
          "4590",
          "14",
          "12",
          "11",
          "13",
          "1",
          "1",
          "1",
          "0",
          "0",
          "1",
          "2",
          "2"
        ],
      },

      // ===== เพิ่มอีก 10 อัน =====
      {
        "model": "พัดลมไอเย็น/SAMSUNG/ARCTIC-20L",
        "data": [
          "2990",
          "3199",
          "3590",
          "18",
          "20",
          "16",
          "15",
          "2",
          "2",
          "1",
          "1",
          "1",
          "1",
          "4",
          "4"
        ],
      },
      {
        "model": "เตาไฟฟ้า/SAMSUNG/IR2023",
        "data": [
          "1890",
          "2019",
          "2290",
          "25",
          "23",
          "27",
          "22",
          "3",
          "2",
          "2",
          "2",
          "1",
          "2",
          "6",
          "6"
        ],
      },
      {
        "model": "ตู้แช่แข็ง/SAMSUNG/CF300",
        "data": [
          "10500",
          "11070",
          "11990",
          "6",
          "7",
          "5",
          "6",
          "1",
          "1",
          "0",
          "1",
          "0",
          "1",
          "2",
          "3"
        ],
      },
      {
        "model": "ทีวี/SAMSUNG/QLED65Q60B",
        "data": [
          "22990",
          "24600",
          "26900",
          "10",
          "12",
          "11",
          "9",
          "2",
          "1",
          "1",
          "1",
          "1",
          "1",
          "4",
          "3"
        ],
      },
      {
        "model": "ลำโพงบลูทูธ/SAMSUNG/SPK-BT500",
        "data": [
          "1290",
          "1380",
          "1590",
          "40",
          "38",
          "42",
          "39",
          "5",
          "4",
          "3",
          "3",
          "2",
          "2",
          "10",
          "9"
        ],
      },
      {
        "model": "โน้ตบุ๊ก/SAMSUNG/NB-15i5-8GB",
        "data": [
          "17900",
          "19153",
          "20900",
          "8",
          "6",
          "7",
          "6",
          "1",
          "1",
          "1",
          "0",
          "1",
          "0",
          "3",
          "2"
        ],
      },
      {
        "model": "แท็บเล็ต/SAMSUNG/TAB-A9",
        "data": [
          "6990",
          "7480",
          "7990",
          "15",
          "14",
          "13",
          "16",
          "2",
          "2",
          "1",
          "1",
          "1",
          "1",
          "4",
          "4"
        ],
      },
      {
        "model": "สมาร์ทโฟน/SAMSUNG/Galaxy S23",
        "data": [
          "25900",
          "27713",
          "29900",
          "30",
          "28",
          "26",
          "27",
          "4",
          "3",
          "3",
          "2",
          "2",
          "2",
          "9",
          "7"
        ],
      },
      {
        "model": "เครื่องปริ้นเตอร์/SAMSUNG/PR-L3250",
        "data": [
          "4490",
          "4820",
          "5290",
          "20",
          "19",
          "18",
          "21",
          "2",
          "2",
          "2",
          "1",
          "1",
          "1",
          "5",
          "4"
        ],
      },
      {
        "model": "กล้องวงจรปิด/SAMSUNG/CCTV-4CH",
        "data": [
          "5590",
          "6000",
          "6590",
          "12",
          "11",
          "10",
          "13",
          "1",
          "1",
          "1",
          "1",
          "1",
          "1",
          "3",
          "3"
        ],
      },
    ]
  };

  // --- Layout constants ---
  static const double leftColWidth = 200;
  static const double cellWidth = 100;
  static const double simpleHeaderHeight = 60;
  static const double groupHeaderTop = 30;
  static const double groupHeaderSub = 30;
  static const double rowHeight = 70;

  // --- Scroll controllers (sync X & Y) ---
  final ScrollController _hHeaderCtrl = ScrollController();
  final ScrollController _hBodyCtrl = ScrollController();
  final ScrollController _vLeftCtrl = ScrollController();
  final ScrollController _vBodyCtrl = ScrollController();

  bool _syncingHFromHeader = false;
  bool _syncingHFromBody = false;
  bool _syncingVFromLeft = false;
  bool _syncingVFromBody = false;

  @override
  void initState() {
    super.initState();

    // sync horizontal: header <-> body
    _hHeaderCtrl.addListener(() {
      if (_syncingHFromBody) return;
      _syncingHFromHeader = true;
      _hBodyCtrl.jumpTo(_hHeaderCtrl.offset);
      _syncingHFromHeader = false;
    });
    _hBodyCtrl.addListener(() {
      if (_syncingHFromHeader) return;
      _syncingHFromBody = true;
      _hHeaderCtrl.jumpTo(_hBodyCtrl.offset);
      _syncingHFromBody = false;
    });

    // sync vertical: left column <-> body
    _vLeftCtrl.addListener(() {
      if (_syncingVFromBody) return;
      _syncingVFromLeft = true;
      _vBodyCtrl.jumpTo(_vLeftCtrl.offset);
      _syncingVFromLeft = false;
    });
    _vBodyCtrl.addListener(() {
      if (_syncingVFromLeft) return;
      _syncingVFromBody = true;
      _vLeftCtrl.jumpTo(_vBodyCtrl.offset);
      _syncingVFromBody = false;
    });
  }

  @override
  void dispose() {
    _hHeaderCtrl.dispose();
    _hBodyCtrl.dispose();
    _vLeftCtrl.dispose();
    _vBodyCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fixedHeader = tableData["headers"]["fixed"] as List;
    final columns = (tableData["headers"]["columns"] as List).cast<String>();
    final groups = (tableData["headers"]["groups"] as Map).cast<String, List>();
    final rows = tableData["rows"] as List;

    return Scaffold(
      appBar: const CustomAppbar(title: 'รายงาน SKU SALE'),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
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
                  _buildInfoBox(
                      "กลุ่มสินค้า : เครื่องใช้ไฟฟ้าในบ้าน   ประเภท : เครื่องซักผ้า"),
                  _buildInfoBox("ณ วันที่ : 19/08/2568"),
                  _buildInfoBox("ผู้จำหน่าย : บริษัท ทวียนต์มาเก็ตติ้ง จำกัด"),
                  _buildInfoBox("ช่องทางการขาย : ทั้งหมด"),
                ],
              ),
            ),

            // ======= ตารางหลัก (หัวคงที่ + ซิงก์สก롤) =======
            // โครงสร้าง:
            // Row( [ LeftTopFixed , RightHeaderScrollable ] )
            // Expanded Row(
            //   [ LeftColumnScrollable(vertical) , RightBodyScrollable(h & v, h sync with header, v sync with left) ]
            // )
            // ทำให้หัวฝั่งขวาและข้อมูลเลื่อนซ้ายขวาพร้อมกัน
            // และคอลัมน์ซ้ายเลื่อนขึ้นลงพร้อมกับข้อมูล
            Row(
              children: [
                // มุมซ้ายบน (หัวคอลัมน์)
                _buildHeaderCell(fixedHeader.first,
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
            SizedBox(height: 35),
          ],
        ),
      ),
    );
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
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromRGBO(239, 204, 249, 1)),
        color: Colors.purple[50],
      ),
      child: Text(
        text,
        textAlign: isCenter ? TextAlign.center : TextAlign.start,
        style: MyContant().h4normalStyle(),
      ),
    );
  }
}
