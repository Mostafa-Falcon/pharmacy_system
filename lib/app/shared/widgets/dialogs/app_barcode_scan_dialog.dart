import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pharmacy_system/app/shared/ui_core.dart';


class BarcodeScanDialog extends StatefulWidget {
  const BarcodeScanDialog({super.key});

  /// Shows the scan dialog and returns the scanned barcode, or null if cancelled.
  static Future<String?> show(BuildContext context) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const BarcodeScanDialog(),
    );
  }

  @override
  State<BarcodeScanDialog> createState() => _BarcodeScanDialogState();
}

class _BarcodeScanDialogState extends State<BarcodeScanDialog> {
  late final MobileScannerController _scannerController;
  bool _isScanned = false;
  bool _hasPermission = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initScanner();
  }

  void _initScanner() {
    _scannerController = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
      torchEnabled: false,
    );
  }

  @override
  void dispose() {
    _scannerController.dispose(); // إغلاق صريح للمحرك لمنع سخونة الجهاز
    super.dispose();
  }

  void _onBarcodeDetected(BarcodeCapture capture) {
    if (_isScanned) return;
    final barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final code = barcodes.first.rawValue;
    if (code == null || code.isEmpty) return;

    setState(() => _isScanned = true);

    // إرجاع الكود فوراً وإغلاق الـ BottomSheet
    if (mounted) {
      Navigator.of(context).pop(code);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.xl.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Handle bar
          SizedBox(height: AppSpacing.sm.h),
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: scheme.outlineVariant,
                borderRadius: BorderRadius.circular(AppRadius.pill.r),
              ),
            ),
          ),
          SizedBox(height: AppSpacing.md.h),

          // Title Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
            child: Row(
              children: [
                Icon(
                  Icons.qr_code_scanner_rounded,
                  size: AppIconSize.md.value,
                  color: scheme.primary,
                ),
                SizedBox(width: AppSpacing.sm.w),
                Expanded(
                  child: ReusableText(
                    WidgetStrings.barcodeScannerTitle,
                    style: AppTextStyles.title(
                      context,
                    ).copyWith(color: AppColors.textPrimaryOf(context)),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(
                    Icons.close_rounded,
                    size: AppIconSize.md.value,
                    color: AppColors.textSecondaryOf(context),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.md.h),

          // Scanner Area
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.lg.r),
                child: _buildScannerBody(context),
              ),
            ),
          ),

          // Hint Footer Text
          Padding(
            padding: EdgeInsets.all(AppSpacing.lg.w),
            child: Center(
              child: ReusableText(
                WidgetStrings.barcodeScannerHint,
                style: AppTextStyles.body(context).copyWith(
                  color: AppColors.textSecondaryOf(context),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScannerBody(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    if (!_hasPermission) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.lg.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.no_photography_rounded,
                size: AppIconSize.xl.value,
                color: AppColors.error,
              ),
              SizedBox(height: AppSpacing.md.h),
              ReusableText(
                _error ?? WidgetStrings.barcodeCameraDenied,
                style: AppTextStyles.body(
                  context,
                ).copyWith(color: AppColors.error, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        MobileScanner(
          controller: _scannerController,
          onDetect: _onBarcodeDetected,
          errorBuilder: (context, error, child) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted && _hasPermission) {
                setState(() {
                  _hasPermission = false;
                  _error = WidgetStrings.barcodeCameraError.replaceFirst(
                    '%s',
                    error.errorCode.name,
                  );
                });
              }
            });
            return const SizedBox.shrink();
          },
        ),

        // Scan overlay frame (تثبيت الحجم لتجنب التمطيط)
        Container(
          width: 200.w,
          height: 200.w, // استخدام الـ .w لتثبيت مربع مثالي هندسياً
          decoration: BoxDecoration(
            border: Border.all(color: scheme.primary, width: 2.5.w),
            borderRadius: BorderRadius.circular(AppRadius.md.r),
          ),
        ),

        // Scanned indicator overlay
        if (_isScanned)
          Positioned.fill(
            child: Container(
              color: AppColors.success.withValues(alpha: 0.3),
              child: Center(
                child: Icon(
                  Icons.check_circle_rounded,
                  size: AppIconSize.xxl.value,
                  color: AppColors.success,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
