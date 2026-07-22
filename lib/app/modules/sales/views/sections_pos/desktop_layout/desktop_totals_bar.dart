import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_colors.dart';
import 'package:pharmacy_system/app/core/presentation/widgets/index.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../bloc/pos_bloc.dart';
import 'desktop_dialogs.dart';

class DesktopTotalsBar extends StatefulWidget {
  final PosBloc controller;
  const DesktopTotalsBar({super.key, required this.controller});

  @override
  State<DesktopTotalsBar> createState() => _DesktopTotalsBarState();
}

class _DesktopTotalsBarState extends State<DesktopTotalsBar> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = AppColors.isDark(context);

    return BlocBuilder<PosBloc, PosState>(
      builder: (context, state) {
        return Container(
          height: 54.h,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: isDark ? scheme.surfaceContainerHigh : AppColors.surfaceTintDark,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  ReusableText(
                    state.grandTotal.toStringAsFixed(2),
                    style: TextStyle(
                      color: isDark ? scheme.primary : Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  ReusableText(
                    AppStrings.currency,
                    style: TextStyle(color: isDark ? scheme.onSurfaceVariant : Colors.white70, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              ReusableText(
                AppStrings.grandTotalLabel,
                style: TextStyle(
                  color: isDark ? scheme.onSurface : Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (_isExpanded)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: scheme.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.5)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _infoItem(context, AppStrings.cartQuantity, '${state.itemCount}'),
                      _divider(context),
                      _infoItem(
                        context,
                        AppStrings.cartDiscount,
                        state.invoiceDiscountTotal.toStringAsFixed(2),
                        onTap:
                            () => DesktopDialogs.showInvoiceDiscountDialog(
                              context,
                              widget.controller,
                            ),
                      ),
                      _divider(context),
                      _infoItem(
                        context,
                        AppStrings.tax,
                        state.invoiceTax.toStringAsFixed(2),
                        onTap: () => DesktopDialogs.showInvoiceTaxDialog(context, widget.controller),
                      ),
                      _divider(context),
                      InkWell(
                        onTap: () => setState(() => _isExpanded = false),
                        child: ReusableText(
                          AppStrings.collapseLabel,
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              else
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ReusableText(
                      AppStrings.itemCountFormat.replaceFirst('%s', '${state.itemCount}'),
                      style: TextStyle(
                        color: isDark ? scheme.onSurfaceVariant : Colors.white70,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    ReusableButton(
                      text: AppStrings.detailsLabel,
                      type: ButtonType.outlined,
                      color: isDark ? scheme.primary : Colors.white,
                      height: 28.h,
                      onPressed: () => setState(() => _isExpanded = true),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _infoItem(BuildContext context, String label, String value, {VoidCallback? onTap}) {
    final scheme = Theme.of(context).colorScheme;
    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ReusableText('$label: ', style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 10.sp)),
        ReusableText(value, style: TextStyle(color: scheme.primary, fontSize: 10.sp, fontWeight: FontWeight.bold)),
      ],
    );
    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
          child: content,
        ),
      );
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      child: content,
    );
  }

  Widget _divider(BuildContext context) {
    return Container(
      height: 14.h,
      width: 1,
      color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5),
      margin: EdgeInsets.symmetric(horizontal: 8.w),
    );
  }
}
