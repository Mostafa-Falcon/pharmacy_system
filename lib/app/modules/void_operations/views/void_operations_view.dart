import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:intl/intl.dart';



import 'package:pharmacy_system/app/core/constants/app_strings.dart';

import 'package:pharmacy_system/app/modules/sales/models/purchase_model.dart';

import 'package:pharmacy_system/app/modules/sales/models/sale_model.dart';

import 'package:pharmacy_system/app/core/presentation/theme/app_colors.dart';

import 'package:pharmacy_system/app/core/presentation/theme/app_sizes.dart';

import 'package:pharmacy_system/app/core/presentation/widgets/index.dart';



import 'package:pharmacy_system/app/modules/void_operations/bloc/void_operations_bloc.dart';



/// صفحة إلغاء الفواتير (BLoC).

class VoidOperationsView extends StatelessWidget {

  const VoidOperationsView({super.key});



  @override

  Widget build(BuildContext context) {

    final scheme = Theme.of(context).colorScheme;

    return HomeShell(

      title: VoidOperationsStrings.voidOperationsTitle,

      child: BlocBuilder<VoidOperationsBloc, VoidOperationsState>(

        buildWhen: (previous, current) =>

            previous.voidableSales != current.voidableSales ||

            previous.voidablePurchases != current.voidablePurchases ||

            previous.isLoading != current.isLoading,

        builder: (context, state) {

          return DefaultTabController(

            length: 2,

            child: Column(

              children: [

                Container(

                  color: scheme.surface,

                  child: TabBar(

                    tabs: [

                      Tab(text: VoidOperationsStrings.voidOperationsSalesTab.replaceAll('%s', '${state.voidableSales.length}')),

                      Tab(

                        text:

                            VoidOperationsStrings.voidOperationsPurchasesTab.replaceAll('%s', '${state.voidablePurchases.length}'),

                      ),

                    ],

                    labelColor: scheme.primary,

                    unselectedLabelColor: scheme.onSurfaceVariant,

                  ),

                ),

                Expanded(

                  child: TabBarView(

                    children: [

                      _SalesTab(

                        sales: state.voidableSales,

                        onRefresh: () => context

                            .read<VoidOperationsBloc>()

                            .add(LoadVoidOperations()),

                      ),

                      _PurchasesTab(

                        purchases: state.voidablePurchases,

                        onRefresh: () => context

                            .read<VoidOperationsBloc>()

                            .add(LoadVoidOperations()),

                      ),

                    ],

                  ),

                ),

              ],

            ),

          );

        },

      ),

    );

  }

}



class _SalesTab extends StatelessWidget {

  final List<SaleModel> sales;

  final VoidCallback onRefresh;

  const _SalesTab({required this.sales, required this.onRefresh});



  @override

  Widget build(BuildContext context) {

    final scheme = Theme.of(context).colorScheme;

    if (sales.isEmpty) {

      return Center(

        child: Column(

          mainAxisSize: MainAxisSize.min,

          children: [

            Icon(

              Icons.check_circle_outline,

              size: 64.w,

              color: scheme.onSurfaceVariant.withValues(alpha: 0.4),

            ),

            SizedBox(height: AppSpacing.md.h),

            Text(

              VoidOperationsStrings.voidOperationsEmptySales,

              style: AppTextStyles.body(context).copyWith(color: scheme.onSurfaceVariant),

            ),

          ],

        ),

      );

    }



    return ListView.builder(

      padding: EdgeInsets.all(AppSpacing.md.w),

      itemCount: sales.length,

      itemBuilder: (_, i) => _SaleCard(sale: sales[i], onRefresh: onRefresh),

    );

  }

}



class _SaleCard extends StatelessWidget {

  final SaleModel sale;

  final VoidCallback onRefresh;

  const _SaleCard({required this.sale, required this.onRefresh});



  @override

  Widget build(BuildContext context) {

    final scheme = Theme.of(context).colorScheme;

    return AppCard(

      margin: EdgeInsets.only(bottom: AppSpacing.sm.h),

      padding: EdgeInsets.all(AppSpacing.md.w),

      child: Row(

          children: [

            Container(

              width: 4.w,

              height: 70.h,

              decoration: BoxDecoration(

                color: AppColors.primary,

                borderRadius: BorderRadius.circular(AppRadius.xs.r),

              ),

            ),

            SizedBox(width: AppSpacing.md.w),

            Expanded(

              child: Column(

                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  Row(

                    children: [

                      Expanded(

                        child: Text(

                          VoidOperationsStrings.voidOperationsInvoiceFormat.replaceAll('%s', sale.id.substring(0, 8)),

                          style: AppTextStyles.body(context).copyWith(fontWeight: FontWeight.bold),

                        ),

                      ),

                      Container(

                        padding: EdgeInsets.symmetric(

                          horizontal: 8.w,

                          vertical: 2.h,

                        ),

                        decoration: BoxDecoration(

                          color: AppColors.info.withValues(alpha: 0.15),

                          borderRadius: BorderRadius.circular(4.r),

                        ),

                        child: Text(

                          sale.paymentMethod,

                          style: AppTextStyles.caption(context).copyWith(color: AppColors.info),

                        ),

                      ),

                    ],

                  ),

                  SizedBox(height: 4.h),

                  Text(

                    '${VoidOperationsStrings.voidOperationsCustomerFormat.replaceAll('%s', sale.customerName ?? 'نقدي')} | ${VoidOperationsStrings.voidOperationsItemsFormat.replaceAll('%s', sale.items.length.toString())}',

                    style: AppTextStyles.caption(context).copyWith(color: scheme.onSurfaceVariant),

                  ),

                  Row(

                    children: [

                      Text(

                        VoidOperationsStrings.voidOperationsAmountFormat.replaceAll('%s', sale.finalAmount.toStringAsFixed(2)),

                        style: AppTextStyles.body(context).copyWith(fontWeight: FontWeight.bold, color: scheme.primary),

                      ),

                      SizedBox(width: AppSpacing.md.w),

                      Text(

                        DateFormat('yyyy-MM-dd HH:mm').format(sale.createdAt),

                        style: AppTextStyles.caption(context).copyWith(color: scheme.onSurfaceVariant),

                      ),

                    ],

                  ),

                ],

              ),

            ),

            ElevatedButton.icon(

              onPressed: () => _showVoidDialog(context),

              icon: Icon(Icons.cancel_outlined, size: AppIconSize.md.value),

              label: const Text('إلغاء'),

              style: ElevatedButton.styleFrom(

                backgroundColor: AppColors.error,

                foregroundColor: Colors.white,

              ),

            ),

          ],

        ),

      );

  }



  void _showVoidDialog(BuildContext context) {

    final reasons = [

      VoidOperationsStrings.voidOperationsReasonError,

      VoidOperationsStrings.voidOperationsReasonReturn,

      VoidOperationsStrings.voidOperationsReasonCancelOrder,

      VoidOperationsStrings.voidOperationsReasonOther,

    ];



    showDialog(

      context: context,

      builder: (ctx) {

        final reasonCtrl = TextEditingController();

        return StatefulBuilder(

          builder: (context, setState) => AlertDialog(

        title: Text(VoidOperationsStrings.voidOperationsTitleSale),

        content: Column(

          mainAxisSize: MainAxisSize.min,

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

              Text(

                VoidOperationsStrings.voidOperationsInvoiceFormat.replaceAll('%s', sale.id.substring(0, 8)),

                style: AppTextStyles.bodyBold(ctx),

              ),

              Text(

                VoidOperationsStrings.voidOperationsCustomerFormat.replaceAll('%s', sale.customerName ?? 'نقدي'),

                style: AppTextStyles.caption(ctx).copyWith(color: Theme.of(ctx).colorScheme.onSurfaceVariant),

              ),

              Text(

                VoidOperationsStrings.voidOperationsAmountFormat.replaceAll('%s', sale.finalAmount.toStringAsFixed(2)),

                style: AppTextStyles.caption(ctx),

            ),

            SizedBox(height: AppSpacing.md.h),

            Text(VoidOperationsStrings.voidOperationsReasonLabel),

            StatefulBuilder(

              builder: (context, setState) => Column(

                children: reasons

                    .map(

                      (r) => RadioListTile<String>(

                        title: Text(r),
                        value: r,
                        // ignore: deprecated_member_use
                        groupValue: reasons.contains(reasonCtrl.text)
                            ? reasonCtrl.text
                            : (reasonCtrl.text.isEmpty ? null : 'أخرى'),
                        // ignore: deprecated_member_use
                        onChanged: (v) => setState(() => reasonCtrl.text = v ?? ''),

                        contentPadding: EdgeInsets.zero,

                        dense: true,

                        visualDensity: VisualDensity.compact,

                      ),

                    )

                    .toList(),

              ),

            ),

            TextField(

              controller: reasonCtrl,

              decoration: InputDecoration(

                labelText: VoidOperationsStrings.voidOperationsReasonHint,

                border: const OutlineInputBorder(),

              ),

              maxLines: 2,

            ),

            SizedBox(height: AppSpacing.sm.h),

            Text(

              'سيتم إرجاع المخزون وعكس القيود المحاسبية',

              style: AppTextStyles.caption(context).copyWith(color: AppColors.warning),

            ),

          ],

        ),

        actions: [

          ReusableButton(

            text: AppStrings.cancel,

            type: ButtonType.text,

            onPressed: () => Navigator.of(context).pop(),

          ),

          ReusableButton(

            text: 'تأكيد الإلغاء',

            type: ButtonType.error,

            onPressed: () {

              if (reasonCtrl.text.trim().isEmpty) return;

              Navigator.of(context).pop();

              ctx.read<VoidOperationsBloc>().add(

                    VoidSale(saleId: sale.id, reason: reasonCtrl.text.trim()),

                  );

              AppSnackbar.success('تم إلغاء الفاتورة بنجاح');

            },

          ),

        ],

      ),

        );

      },

    );

  }

}



class _PurchasesTab extends StatelessWidget {

  final List<PurchaseModel> purchases;

  final VoidCallback onRefresh;

  const _PurchasesTab({required this.purchases, required this.onRefresh});



  @override

  Widget build(BuildContext context) {

    final scheme = Theme.of(context).colorScheme;

    if (purchases.isEmpty) {

      return Center(

        child: Column(

          mainAxisSize: MainAxisSize.min,

          children: [

            Icon(

              Icons.check_circle_outline,

              size: 64.w,

              color: scheme.onSurfaceVariant.withValues(alpha: 0.4),

            ),

            SizedBox(height: AppSpacing.md.h),

            Text(

              VoidOperationsStrings.voidOperationsEmptyPurchases,

              style: AppTextStyles.body(context).copyWith(color: scheme.onSurfaceVariant),

            ),

          ],

        ),

      );

    }



    return ListView.builder(

      padding: EdgeInsets.all(AppSpacing.md.w),

      itemCount: purchases.length,

      itemBuilder: (_, i) =>

          _PurchaseCard(purchase: purchases[i], onRefresh: onRefresh),

    );

  }

}



class _PurchaseCard extends StatelessWidget {

  final PurchaseModel purchase;

  final VoidCallback onRefresh;

  const _PurchaseCard({required this.purchase, required this.onRefresh});



  @override

  Widget build(BuildContext context) {

    final scheme = Theme.of(context).colorScheme;

    return AppCard(

      margin: EdgeInsets.only(bottom: AppSpacing.sm.h),

      padding: EdgeInsets.all(AppSpacing.md.w),

      child: Row(

          children: [

            Container(

              width: 4.w,

              height: 70.h,

              decoration: BoxDecoration(

                color: AppColors.warning,

                borderRadius: BorderRadius.circular(AppRadius.xs.r),

              ),

            ),

            SizedBox(width: AppSpacing.md.w),

            Expanded(

              child: Column(

                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  Text(

                    'فاتورة مشتريات #${purchase.id.substring(0, 8)}',

                    style: AppTextStyles.bodyBold(context),

                  ),

                  SizedBox(height: 4.h),

                  Text(

                    'المورد: ${purchase.supplierName} | ${purchase.items.length} أصناف',

                    style: AppTextStyles.caption(context).copyWith(color: scheme.onSurfaceVariant),

                  ),

                  Row(

                    children: [

                      Text(

                        'المبلغ: ${purchase.finalAmount.toStringAsFixed(2)}',

                        style: AppTextStyles.body(context).copyWith(fontWeight: FontWeight.bold, color: scheme.primary),

                      ),

                      SizedBox(width: AppSpacing.md.w),

                      Text(

                        DateFormat(

                          'yyyy-MM-dd HH:mm',

                        ).format(purchase.createdAt),

                        style: AppTextStyles.caption(context).copyWith(color: scheme.onSurfaceVariant),

                      ),

                    ],

                  ),

                ],

              ),

            ),

            ElevatedButton.icon(

              onPressed: () => _showVoidDialog(context),

              icon: Icon(Icons.cancel_outlined, size: AppIconSize.md.value),

              label: const Text('إلغاء'),

              style: ElevatedButton.styleFrom(

                backgroundColor: AppColors.error,

                foregroundColor: Colors.white,

              ),

            ),

          ],

        ),

      );

  }



  void _showVoidDialog(BuildContext context) {

    final reasonCtrl = TextEditingController();



    showDialog(

      context: context,

      builder: (ctx) => AlertDialog(

        title: Text(VoidOperationsStrings.voidOperationsTitlePurchase),

        content: Column(

          mainAxisSize: MainAxisSize.min,

          children: [

            Text(

              VoidOperationsStrings.voidOperationsInvoiceFormat.replaceAll('%s', purchase.id.substring(0, 8)),

              style: AppTextStyles.bodyBold(ctx),

            ),

            Text(

              VoidOperationsStrings.voidOperationsSupplierFormat.replaceAll('%s', purchase.supplierName),

              style: AppTextStyles.caption(ctx),

            ),

            Text(

              VoidOperationsStrings.voidOperationsAmountFormat.replaceAll('%s', purchase.finalAmount.toStringAsFixed(2)),

              style: AppTextStyles.caption(ctx),

            ),

            SizedBox(height: AppSpacing.md.h),

            TextField(

              controller: reasonCtrl,

              decoration: InputDecoration(

                labelText: VoidOperationsStrings.voidOperationsReasonHint,

                border: const OutlineInputBorder(),

              ),

              maxLines: 3,

            ),

            SizedBox(height: AppSpacing.sm.h),

            Text(

              VoidOperationsStrings.voidOperationsWarning,

              style: AppTextStyles.caption(context).copyWith(color: AppColors.warning),

            ),

          ],

        ),

        actions: [

          ReusableButton(

            text: VoidOperationsStrings.voidOperationsCancel,

            type: ButtonType.text,

            onPressed: () => Navigator.of(context).pop(),

          ),

          ReusableButton(

            text: VoidOperationsStrings.voidOperationsConfirmCancel,

            type: ButtonType.error,

            onPressed: () {

              if (reasonCtrl.text.trim().isEmpty) return;

              Navigator.of(context).pop();

              context.read<VoidOperationsBloc>().add(

                    VoidPurchase(

                      purchaseId: purchase.id,

                      reason: reasonCtrl.text.trim(),

                    ),

                  );

              AppSnackbar.success(VoidOperationsStrings.voidOperationsSuccess);

            },

          ),

        ],

      ),

    );

  }

}



