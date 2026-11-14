// ประวัติการตรวจนับ: model + ฟังก์ชันวันที่ + ข้อมูลตัวอย่าง (รอ API)

enum CountType { serial, qty }

extension CountTypeLabel on CountType {
  String get label =>
      this == CountType.serial ? 'สแกนเลขเครื่อง' : 'นับจำนวนสินค้า';
  String get shortLabel =>
      this == CountType.serial ? 'สแกนเลขเครื่อง' : 'นับจำนวน';
}

/// รายการหนึ่งแถวในรอบการตรวจนับ
/// - แบบสแกนเลขเครื่อง: ใช้ serial + found
/// - แบบนับจำนวน: ใช้ product + systemQty + actualQty
class HistoryLine {
  final String serial;
  final bool found; // พบในระบบ / ไม่พบในระบบ
  final String product;
  final int systemQty;
  final int actualQty;
  final String note;

  const HistoryLine({
    this.serial = '',
    this.found = true,
    this.product = '',
    this.systemQty = 0,
    this.actualQty = 0,
    this.note = '',
  });
}

/// การตรวจนับหนึ่งรอบ
class HistorySession {
  final String tranId; // รหัสรอบ (ส่งให้ API checkHistoryDetail)
  final DateTime date;
  final int round;
  final CountType type;
  final String inspector;
  final String whName;
  final String timeText; // เช่น "09:12 - 09:25 น."
  final List<HistoryLine> lines;

  const HistorySession({
    this.tranId = '',
    required this.date,
    required this.round,
    required this.type,
    required this.inspector,
    required this.whName,
    required this.timeText,
    required this.lines,
  });

  int get count => lines.length;
}

// ───────────── วันที่ (พ.ศ.) ─────────────
const _thMonths = [
  'ม.ค.',
  'ก.พ.',
  'มี.ค.',
  'เม.ย.',
  'พ.ค.',
  'มิ.ย.',
  'ก.ค.',
  'ส.ค.',
  'ก.ย.',
  'ต.ค.',
  'พ.ย.',
  'ธ.ค.',
];

String _two(int n) => n.toString().padLeft(2, '0');

/// 01/08/2568
String formatBeDate(DateTime d) =>
    '${_two(d.day)}/${_two(d.month)}/${d.year + 543}';

/// รูปแบบส่ง API: พ.ศ. yyyyMMdd เช่น 25690113
String formatBeApiDate(DateTime d) =>
    '${d.year + 543}${_two(d.month)}${_two(d.day)}';

/// 23 ส.ค. 2568
String formatBeLong(DateTime d) =>
    '${_two(d.day)} ${_thMonths[d.month - 1]} ${d.year + 543}';

// ───────────── ข้อมูลประวัติ ─────────────
class StockHistoryRepo {
  /// TODO: เปลี่ยนเป็นเรียก API จริง (ส่ง from / to / whId / type)
  /// ตอนนี้เป็นข้อมูลตัวอย่างตามแบบ — กรองเฉพาะประเภท ไม่กรองวันที่/คลัง
  static Future<List<HistorySession>> search({
    required DateTime from,
    required DateTime to,
    String whId = '',
    CountType? type,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final all = _mock();
    return type == null ? all : all.where((e) => e.type == type).toList();
  }

  static List<HistorySession> _mock() {
    const qtyNames = [
      ['พัดลมตั้งพื้น 16"', 120, 118],
      ['เตารีด', 50, 50],
      ['หม้อหุงข้าว', 30, 28],
      ['ไมโครเวฟ', 20, 20],
      ['เครื่องดูดฝุ่น', 15, 15],
      ['กระติกน้ำร้อน', 40, 39],
      ['ตู้เย็น 2 ประตู', 12, 12],
      ['เครื่องซักผ้า', 8, 7],
    ];
    return [
      HistorySession(
        date: DateTime(2025, 8, 23),
        round: 3,
        type: CountType.serial,
        inspector: 'จักรภัทร ส.',
        whName: 'คลังแม่กรณ์',
        timeText: '09:12 - 09:25 น.',
        lines: const [
          HistoryLine(serial: 'T2207331962', found: true),
          HistoryLine(serial: 'T2207331963', found: true),
          HistoryLine(serial: 'T2207331964', found: false),
          HistoryLine(serial: 'T2207331965', found: true),
          HistoryLine(serial: 'T2207331966', found: true),
        ],
      ),
      HistorySession(
        date: DateTime(2025, 8, 16),
        round: 2,
        type: CountType.qty,
        inspector: 'สมชาย ไ.',
        whName: 'คลังแม่กรณ์',
        timeText: '13:40 - 14:20 น.',
        lines: [
          for (final r in qtyNames)
            HistoryLine(
              product: r[0] as String,
              systemQty: r[1] as int,
              actualQty: r[2] as int,
            ),
        ],
      ),
      HistorySession(
        date: DateTime(2025, 8, 8),
        round: 1,
        type: CountType.qty,
        inspector: 'อนุวัฒน์ ว.',
        whName: 'คลังแม่กรณ์',
        timeText: '10:05 - 11:30 น.',
        lines: [
          for (var i = 1; i <= 12; i++)
            HistoryLine(
              product: 'สินค้าตัวอย่าง $i',
              systemQty: 10 + i,
              actualQty: 10 + i,
            ),
        ],
      ),
    ];
  }
}
