import 'package:application_thaweeyont/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

/// หน้ากล้องสแกนบาร์โค้ด / QR
/// เปิดด้วย Navigator.push<String>() — สแกนได้ค่าแรกแล้วปิดหน้าและส่งค่ากลับ (rawValue)
class StockScannerPage extends StatefulWidget {
  const StockScannerPage({super.key});

  @override
  State<StockScannerPage> createState() => _StockScannerPageState();
}

class _StockScannerPageState extends State<StockScannerPage> {
  final MobileScannerController _controller = MobileScannerController(
    // ไม่ส่งค่าเดิมซ้ำๆ ขณะกล้องยังเล็งบาร์โค้ดเดิมอยู่
    detectionSpeed: DetectionSpeed.noDuplicates,
  );

  bool _handled = false; // กันปิดหน้าซ้ำ
  bool _torchOn = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_handled) return;

    // แสดงข้อมูลทุกบาร์โค้ดที่กล้องเจอในเฟรมนี้
    for (final b in capture.barcodes) {
      debugPrint('[สแกน] format=${b.format.name} type=${b.type.name} '
          'rawValue=${b.rawValue} displayValue=${b.displayValue}');
    }

    for (final b in capture.barcodes) {
      final raw = b.rawValue?.trim();
      if (raw == null || raw.isEmpty) continue;

      _handled = true;
      // ดูชนิดบาร์โค้ดและค่าที่อ่านได้ใน Debug Console
      debugPrint(
          '[สแกน] ใช้ค่า: "$raw" (format=${b.format.name}, ความยาว ${raw.length})');
      HapticFeedback.mediumImpact();
      Navigator.pop(context, raw);
      return;
    }
  }

  Future<void> _toggleTorch() async {
    try {
      await _controller.toggleTorch();
      if (mounted) setState(() => _torchOn = !_torchOn);
    } catch (e) {
      debugPrint('เปิด/ปิดไฟฉายไม่ได้: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: const CustomAppbar(title: 'สแกนบาร์โค้ด'),
      body: Stack(
        children: [
          Positioned.fill(
            child: MobileScanner(
              controller: _controller,
              onDetect: _onDetect,
            ),
          ),
          // กรอบแนวทางเล็ง (ไม่ได้จำกัดพื้นที่อ่าน)
          Center(
            child: IgnorePointer(
              child: Container(
                width: 280,
                height: 160,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 3),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
          Align(
            alignment: const Alignment(0, 0.38),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'วางบาร์โค้ดให้อยู่ในกรอบ',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 40,
            child: Center(
              child: Material(
                color: Colors.black54,
                shape: const CircleBorder(),
                child: IconButton(
                  iconSize: 28,
                  padding: const EdgeInsets.all(12),
                  icon: Icon(
                    _torchOn ? Icons.flash_on : Icons.flash_off,
                    color: Colors.white,
                  ),
                  tooltip: 'ไฟฉาย',
                  onPressed: _toggleTorch,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
