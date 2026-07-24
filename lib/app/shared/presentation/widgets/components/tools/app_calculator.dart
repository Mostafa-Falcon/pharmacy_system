import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pharmacy_system/app/shared/ui_core.dart';
import 'package:pharmacy_system/app/shared/presentation/widgets/index.dart';

class ReusableCalculator {
  ReusableCalculator._();

  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Container(
          width: 360.w,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(24.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 36,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: const _CalculatorDialog(),
        ),
      ),
    );
  }
}

class _CalculatorDialog extends StatefulWidget {
  const _CalculatorDialog();

  @override
  State<_CalculatorDialog> createState() => _CalculatorDialogState();
}

class _CalculatorDialogState extends State<_CalculatorDialog> {
  String _display = '0';
  String _history = '';
  double? _operand1;
  String? _operator;
  bool _shouldReset = false;

  final FocusNode _focusNode = FocusNode();

  static const List<List<String>> _buttonRows = [
    ['C', '⌫', '+/-', '÷'],
    ['7', '8', '9', '×'],
    ['4', '5', '6', '−'],
    ['1', '2', '3', '+'],
    ['0', '00', '.', '='],
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _focusNode.canRequestFocus) {
        _focusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _handlePress(String rawLabel) {
    HapticFeedback.lightImpact();

    final v = switch (rawLabel) {
      '÷' => '/',
      '×' => '*',
      '−' => '-',
      _ => rawLabel,
    };

    setState(() {
      if (v == 'C') {
        _display = '0';
        _history = '';
        _operand1 = null;
        _operator = null;
        _shouldReset = false;
      } else if (v == '⌫') {
        if (_display.length > 1) {
          _display = _display.substring(0, _display.length - 1);
        } else {
          _display = '0';
        }
      } else if (v == '+/-') {
        if (_display != '0') {
          _display = _display.startsWith('-')
              ? _display.substring(1)
              : '-$_display';
        }
      } else if (['/', '*', '-', '+'].contains(v)) {
        _onOperator(v);
      } else if (v == '=') {
        _calculate();
        _shouldReset = true;
      } else if (v == '.') {
        if (_shouldReset || _display == 'error') {
          _display = '0.';
          _shouldReset = false;
        } else if (!_display.contains('.')) {
          _display += '.';
        }
      } else {
        if (_shouldReset || _display == '0' || _display == 'error') {
          _display = v;
          _shouldReset = false;
        } else if (!(v == '00' && _display == '0')) {
          _display += v;
        }
      }
    });
  }

  void _onOperator(String op) {
    final cur = double.tryParse(_display);
    if (cur == null) return;
    final displayOp = _getDisplayOp(op);
    if (_operand1 != null && _operator != null && !_shouldReset) {
      _calculate();
      _operand1 = double.tryParse(_display);
    } else {
      _operand1 = cur;
    }
    _operator = op;
    _history = '${_formatNum(_operand1!)} $displayOp';
    _shouldReset = true;
  }

  String _getDisplayOp(String op) => switch (op) {
    '/' => '÷',
    '*' => '×',
    '-' => '−',
    _ => op,
  };

  void _calculate() {
    if (_operand1 == null || _operator == null) return;
    final cur = double.tryParse(_display);
    if (cur == null) return;
    double r;
    switch (_operator) {
      case '+': r = _operand1! + cur; break;
      case '-': r = _operand1! - cur; break;
      case '*': r = _operand1! * cur; break;
      case '/':
        if (cur == 0) {
          _display = 'error';
          _history = '';
          _operand1 = null;
          _operator = null;
          return;
        }
        r = _operand1! / cur;
        break;
      default: return;
    }
    final displayOp = _getDisplayOp(_operator!);
    _history = '${_formatNum(_operand1!)} $displayOp ${_formatNum(cur)} =';
    _display = _formatNum(r);
    _operand1 = null;
    _operator = null;
  }

  String _formatNum(double v) {
    if (v == v.toInt()) return v.toInt().toString();
    var s = v.toStringAsFixed(8);
    while (s.contains('.') && (s.endsWith('0') || s.endsWith('.'))) {
      s = s.substring(0, s.length - 1);
    }
    return s;
  }

  void _handleKey(KeyEvent e) {
    if (e is! KeyDownEvent) return;
    final key = e.logicalKey;

    if (key == LogicalKeyboardKey.digit0 || key == LogicalKeyboardKey.numpad0) {
      _handlePress('0');
    } else if (key == LogicalKeyboardKey.digit1 || key == LogicalKeyboardKey.numpad1) {
      _handlePress('1');
    } else if (key == LogicalKeyboardKey.digit2 || key == LogicalKeyboardKey.numpad2) {
      _handlePress('2');
    } else if (key == LogicalKeyboardKey.digit3 || key == LogicalKeyboardKey.numpad3) {
      _handlePress('3');
    } else if (key == LogicalKeyboardKey.digit4 || key == LogicalKeyboardKey.numpad4) {
      _handlePress('4');
    } else if (key == LogicalKeyboardKey.digit5 || key == LogicalKeyboardKey.numpad5) {
      _handlePress('5');
    } else if (key == LogicalKeyboardKey.digit6 || key == LogicalKeyboardKey.numpad6) {
      _handlePress('6');
    } else if (key == LogicalKeyboardKey.digit7 || key == LogicalKeyboardKey.numpad7) {
      _handlePress('7');
    } else if (key == LogicalKeyboardKey.digit8 || key == LogicalKeyboardKey.numpad8) {
      _handlePress('8');
    } else if (key == LogicalKeyboardKey.digit9 || key == LogicalKeyboardKey.numpad9) {
      _handlePress('9');
    } else if (key == LogicalKeyboardKey.period || key == LogicalKeyboardKey.numpadDecimal) {
      _handlePress('.');
    } else if (key == LogicalKeyboardKey.numpadAdd || (HardwareKeyboard.instance.isShiftPressed && key == LogicalKeyboardKey.equal)) {
      _handlePress('+');
    } else if (key == LogicalKeyboardKey.numpadSubtract || key == LogicalKeyboardKey.minus) {
      _handlePress('−');
    } else if (key == LogicalKeyboardKey.numpadMultiply || (HardwareKeyboard.instance.isShiftPressed && key == LogicalKeyboardKey.digit8)) {
      _handlePress('×');
    } else if (key == LogicalKeyboardKey.numpadDivide || key == LogicalKeyboardKey.slash) {
      _handlePress('÷');
    } else if (key == LogicalKeyboardKey.enter || key == LogicalKeyboardKey.numpadEnter || key == LogicalKeyboardKey.equal) {
      _handlePress('=');
    } else if (key == LogicalKeyboardKey.backspace) {
      _handlePress('⌫');
    } else if (key == LogicalKeyboardKey.escape || key == LogicalKeyboardKey.delete) {
      _handlePress('C');
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _handleKey,
      child: Padding(
        padding: EdgeInsets.all(18.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Bar
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(7.w),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        scheme.primary.withValues(alpha: 0.2),
                        scheme.primary.withValues(alpha: 0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: scheme.primary.withValues(alpha: 0.25)),
                  ),
                  child: Icon(Icons.calculate_rounded, color: scheme.primary, size: 20.sp),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: ReusableText(
                    WidgetStrings.calculatorTitle,
                    style: AppTextStyles.title(context).copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: 16.sp,
                      color: AppColors.textPrimaryOf(context),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.close_rounded, size: 18.sp),
                  style: IconButton.styleFrom(
                    backgroundColor: scheme.surfaceContainerHigh,
                    padding: EdgeInsets.all(6.w),
                  ),
                ),
              ],
            ),
            SizedBox(height: 14.h),

            // Display Box
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.4)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      // Copy Button Badge
                      Material(
                        color: scheme.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(6.r),
                        child: InkWell(
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: _display));
                            AppSnackbar.info(WidgetStrings.calculatorResultCopied.replaceFirst('%s', _display));
                          },
                          borderRadius: BorderRadius.circular(6.r),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.copy_rounded, size: 12.sp, color: scheme.primary),
                                SizedBox(width: 4.w),
                                ReusableText(
                                  GeneralStrings.copyText,
                                  style: AppTextStyles.caption(context).copyWith(
                                    color: scheme.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      // History Line
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          reverse: true,
                          child: ReusableText(
                            _history.isEmpty ? ' ' : _history,
                            style: AppTextStyles.caption(context).copyWith(
                              color: scheme.onSurfaceVariant.withValues(alpha: 0.7),
                              fontSize: 12.5.sp,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  // Display Digits
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    reverse: true,
                    child: ReusableText(
                      _display,
                      style: AppTextStyles.headline(context).copyWith(
                        fontWeight: FontWeight.w900,
                        fontSize: 30.sp,
                        color: scheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 14.h),

            // Explicit Rows to GUARANTEE NO SCROLLING / CLIPPING of Row 5!
            Column(
              children: _buttonRows.map((row) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: Row(
                    children: row.map((label) {
                      return Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: _buildBtn(label),
                        ),
                      );
                    }).toList(),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBtn(String label) {
    final scheme = Theme.of(context).colorScheme;
    final isOp = ['÷', '×', '−', '+'].contains(label);
    final isEq = label == '=';
    final isAct = ['C', '⌫', '+/-'].contains(label);

    Color bg;
    Color fg;
    BoxBorder? border;

    if (isEq) {
      bg = AppColors.primary;
      fg = Colors.white;
    } else if (isOp) {
      bg = AppColors.primary.withValues(alpha: 0.12);
      fg = AppColors.primary;
      border = Border.all(color: AppColors.primary.withValues(alpha: 0.3));
    } else if (isAct) {
      bg = AppColors.error.withValues(alpha: 0.1);
      fg = AppColors.error;
      border = Border.all(color: AppColors.error.withValues(alpha: 0.25));
    } else {
      bg = scheme.surfaceContainerHigh.withValues(alpha: 0.65);
      fg = scheme.onSurface;
      border = Border.all(color: scheme.outlineVariant.withValues(alpha: 0.35));
    }

    return SizedBox(
      height: 46.h,
      child: Material(
        color: bg,
        borderRadius: BorderRadius.circular(12.r),
        child: InkWell(
          borderRadius: BorderRadius.circular(12.r),
          onTap: () => _handlePress(label),
          hoverColor: isEq
              ? Colors.white.withValues(alpha: 0.15)
              : scheme.primary.withValues(alpha: 0.08),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              border: border,
              boxShadow: isEq
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: label == '⌫'
                  ? Icon(Icons.backspace_rounded, size: 18.sp, color: fg)
                  : ReusableText(
                      label,
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 17.sp,
                        color: fg,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}




