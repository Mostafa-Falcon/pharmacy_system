import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:ui';

import 'package:pharmacy_system/app/core/data/services/sales/cashier_shift_service.dart';
import 'package:pharmacy_system/app/core/data/services/auth/auth_service.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_colors.dart';
import 'package:pharmacy_system/app/core/presentation/widgets/index.dart';
import '../../../core/constants/app_strings.dart';
import '../bloc/pos_bloc.dart';

class OpenShiftView extends StatelessWidget {
  final bool isOverlay;
  const OpenShiftView({super.key, this.isOverlay = false});

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);
    final bgColor = isDark ? AppColors.surfaceTintDark : AppColors.surfaceTintLight;

    final content = Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Container(
          constraints: BoxConstraints(maxWidth: 420.w),
          padding: EdgeInsets.all(32.w),
          decoration: BoxDecoration(
            color: AppColors.surfaceOf(context),
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
                blurRadius: 40,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.account_balance_wallet_rounded,
                size: 64.sp,
                color: AppColors.primary,
              ),
              SizedBox(height: 16.h),
              ReusableText(
                AppStrings.startNewShift,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
              SizedBox(height: 8.h),
              ReusableText(
                AppStrings.enterInitialCashHint,
                fontSize: 13,
                color: Colors.grey,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 28.h),
              _OpenShiftForm(isOverlay: isOverlay),
            ],
          ),
        ),
      ),
    );

    if (isOverlay) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          color: Colors.black.withValues(alpha: 0.4),
          child: content,
        ),
      );
    }

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: ReusableText(AppStrings.openShiftAction, style: const TextStyle(color: Colors.white)),
        backgroundColor: AppColors.surfaceTintDarkAlt,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(child: content),
    );
  }
}

class _OpenShiftForm extends StatefulWidget {
  final bool isOverlay;
  const _OpenShiftForm({required this.isOverlay});

  @override
  State<_OpenShiftForm> createState() => _OpenShiftFormState();
}

class _OpenShiftFormState extends State<_OpenShiftForm> {
  final _cashCtrl = TextEditingController(text: '0');
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // فحص إضافي: لو فيه وردية مفتوحة أصلاً، نقفل الشاشة دي
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final shift = CashierShiftService.findOpenShift(
        cashierId: AuthService.currentUser?.id ?? '',
        branchId: AuthService.currentBranchId ?? '',
      );
      if (shift != null && mounted) {
        if (widget.isOverlay) {
          context.read<PosBloc>().add(const PosRefreshShift());
        } else {
          context.pop(true);
        }
      }
    });
  }

  @override
  void dispose() {
    _cashCtrl.dispose();
    super.dispose();
  }

  Future<void> _openShift() async {
    final cash = double.tryParse(_cashCtrl.text) ?? 0;
    if (cash < 0) {
      AppSnackbar.warning(AppStrings.invalidAmount);
      return;
    }

    setState(() => _isLoading = true);
    try {
      await CashierShiftService.openShift(
        openingCash: cash,
        branchId: AuthService.currentBranchId ?? '',
      );
      
      if (mounted) {
        if (widget.isOverlay) {
          // تحديث الـ Bloc مباشرة إذا كان موجوداً في الـ Context
          try {
            context.read<PosBloc>().add(const PosRefreshShift());
          } catch (_) {
            // إذا لم يكن الـ Bloc موجوداً (حالة نادرة هنا) نعود للخلف
            context.pop(true);
          }
        } else {
          context.pop(true);
        }
        AppSnackbar.success(AppStrings.shiftOpenedSuccess);
      }
    } catch (e) {
      if (mounted) {
        AppSnackbar.error(AppStrings.shiftOpenFailedFormat.replaceFirst('%s', e.toString()));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ReusableInput(
          controller: _cashCtrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          hint: AppStrings.enterOpeningBalanceHint,
          prefixIcon: const Icon(Icons.monetization_on_outlined),
        ),
        SizedBox(height: 24.h),
        SizedBox(
          width: double.infinity,
          height: 48.h,
          child: ReusableButton(
            text: AppStrings.openShiftAction,
            isLoading: _isLoading,
            onPressed: _isLoading ? null : _openShift,
          ),
        ),
      ],
    );
  }
}
