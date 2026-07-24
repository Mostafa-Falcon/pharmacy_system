import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_system/app/shared/ui_core.dart';

// ── Local barcode helpers (self-contained, no external service needed) ──
String _digitsOnly(String code) => code.replaceAll(RegExp(r'[^\d]'), '');

bool _isValidEan13(String digits) {
  if (digits.length != 13) return false;
  int sum = 0;
  for (int i = 0; i < 12; i++) {
    final d = int.parse(digits[i]);
    sum += i.isEven ? d : d * 3;
  }
  final check = (10 - (sum % 10)) % 10;
  return check == int.parse(digits[12]);
}

class LinearBarcodePreview extends StatelessWidget {
  const LinearBarcodePreview({
    super.key,
    required this.code,
    this.height = 64,
    this.width = double.infinity,
    this.showText = true,
    this.borderRadius = 8,
    this.color,
  });

  final String code;
  final double height;
  final double width;
  final bool showText;
  final double borderRadius;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final foreground = color ?? Theme.of(context).colorScheme.onSurface;
    final digits = _digitsOnly(code);

    // Determine which real encoding to use
    final bits = _isValidEan13(digits)
        ? _Ean13Pattern.encode(digits)
        : _Code128Pattern.encode(code);

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            width: width == double.infinity ? 150.w : width,
            height: height,
            child: CustomPaint(
              painter: _LinearBarcodePainter(bits: bits, color: foreground),
            ),
          ),
          if (showText) ...<Widget>[
            SizedBox(height: 4.h),
            Directionality(
              textDirection: TextDirection.ltr,
              child: Text(
                code,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption(context).copyWith(
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w900,
                  color: foreground.withValues(alpha: 0.8),
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _LinearBarcodePainter extends CustomPainter {
  const _LinearBarcodePainter({required this.bits, required this.color});

  final String bits;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (bits.isEmpty || size.width <= 0 || size.height <= 0) return;

    // We use a small quiet zone on each side
    const quietModules = 4;
    final totalModules = bits.length + (quietModules * 2);
    final moduleWidth = size.width / totalModules;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..isAntiAlias = false;

    for (var index = 0; index < bits.length; index++) {
      if (bits.codeUnitAt(index) != 49) continue; // ASCII '1'

      final x = (quietModules + index) * moduleWidth;
      // We use ceilToDouble to avoid sub-pixel gaps which make barcodes look thin/broken
      canvas.drawRect(
        Rect.fromLTWH(x, 0, moduleWidth.ceilToDouble(), size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _LinearBarcodePainter oldDelegate) =>
      oldDelegate.bits != bits || oldDelegate.color != color;
}

/// Real Code 128 Subset B Encoding
abstract final class _Code128Pattern {
  static const List<String> _table = [
    "11011001100",
    "11001101100",
    "11001100110",
    "10010011000",
    "10010001100",
    "10001001100",
    "10011001000",
    "10011000100",
    "10001100100",
    "11000100100",
    "11001000100",
    "11001001100",
    "11011101110",
    "11001110110",
    "11001101110",
    "11011100110",
    "11000111011",
    "11001110001",
    "11011101100",
    "11011001110",
    "11011011100",
    "11011000110",
    "11000110110",
    "10101111000",
    "10100011110",
    "10001011110",
    "10111101000",
    "10111100010",
    "10001111010",
    "10111011110",
    "10111101110",
    "11101011000",
    "11101000110",
    "11100010110",
    "11101101000",
    "11101100010",
    "11100011010",
    "11101111010",
    "11010111100",
    "11010001110",
    "11000101110",
    "11011101000",
    "11011100010",
    "11011101011",
    "11011101101",
    "11011011110",
    "11011110110",
    "11011110101",
    "11110110110",
    "10101111000",
    "10100011110",
    "10001011110",
    "10111101000",
    "10111100010",
    "10001111010",
    "10111011110",
    "10111101110",
    "11101011000",
    "11101000110",
    "11100010110",
    "11101101000",
    "11101100010",
    "11100011010",
    "11101111010",
    "11010111100",
    "11010001110",
    "11000101110",
    "11011101000",
    "11011100010",
    "11011101011",
    "11011101101",
    "11011011110",
    "11011110110",
    "11011110101",
    "11110110110",
    "11110101101",
    "11111010110",
    "10011011011",
    "11110101101",
    "11111010110",
    "10011011011",
    "10111001101",
    "10111011001",
    "11010110011",
    "11010111001",
    "11011010011",
    "11011011001",
    "11011011011",
    "10110110011",
    "10110111001",
    "10111011011",
    "11101011011",
    "11011010111",
    "11011011101",
    "11101011101",
    "11101110101",
    "11101110110",
    "11101101110",
    "11101100111",
    "11001110110",
  ];

  static const String _startB = "11010010000";
  static const String _stop = "1100011101011";

  static String encode(String value) {
    if (value.isEmpty) return "";
    final buffer = StringBuffer(_startB);
    var checksum = 104; // Start B index

    for (var i = 0; i < value.length; i++) {
      final charCode = value.codeUnitAt(i);
      final index = charCode - 32;
      if (index >= 0 && index < _table.length) {
        buffer.write(_table[index]);
        checksum += index * (i + 1);
      }
    }

    final stopIndex = checksum % 103;
    buffer.write(_table[stopIndex]);
    buffer.write(_stop);
    return buffer.toString();
  }
}

abstract final class _Ean13Pattern {
  static const _leftOdd = <String>[
    '0001101',
    '0011001',
    '0010011',
    '0111101',
    '0100011',
    '0110001',
    '0101111',
    '0111011',
    '0110111',
    '0001011',
  ];

  static const _leftEven = <String>[
    '0100111',
    '0110011',
    '0011011',
    '0100001',
    '0011101',
    '0111001',
    '0000101',
    '0010001',
    '0001001',
    '0010111',
  ];

  static const _right = <String>[
    '1110010',
    '1100110',
    '1101100',
    '1000010',
    '1011100',
    '1001110',
    '1010000',
    '1000100',
    '1001000',
    '1110100',
  ];

  static const _parity = <String>[
    'OOOOOO',
    'OOEOEE',
    'OOEEOE',
    'OOEEEO',
    'OEOOEE',
    'OEEOOE',
    'OEEEOO',
    'OEOEOE',
    'OEOEEO',
    'OEEOEO',
  ];

  static String encode(String digits) {
    if (!_isValidEan13(digits)) return '';
    final first = int.parse(digits[0]);
    final parity = _parity[first];
    final buffer = StringBuffer('101');
    for (var index = 1; index <= 6; index++) {
      final digit = int.parse(digits[index]);
      buffer.write(
        parity[index - 1] == 'O' ? _leftOdd[digit] : _leftEven[digit],
      );
    }
    buffer.write('01010');
    for (var index = 7; index <= 12; index++) {
      buffer.write(_right[int.parse(digits[index])]);
    }
    buffer.write('101');
    return buffer.toString();
  }
}
