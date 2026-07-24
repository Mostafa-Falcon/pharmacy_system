import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacy_system/app/shared/ui_core.dart';
import 'package:pharmacy_system/app/core/bloc/import/import_data_bloc.dart';
import 'package:pharmacy_system/app/core/bloc/import/import_data_event.dart';
import 'package:pharmacy_system/app/core/bloc/import/import_data_state.dart';
import 'package:pharmacy_system/app/core/data/services/ui/sound_service.dart';

class ImportDataView extends StatelessWidget {
  final ImportEntityType entityType;
  final String title;
  final String description;

  const ImportDataView({
    super.key,
    required this.entityType,
    required this.title,
    required this.description,
  });

  String _stepLabel(String? step) {
    return switch (step) {
      'reading' => InventoryStrings.importStepReading,
      'parsing' => InventoryStrings.importStepParsing,
      'saving' => InventoryStrings.importStepSaving,
      'done' => InventoryStrings.importStepDone,
      _ => '',
    };
  }

  IconData _stepIcon(String? step, bool hasError) {
    if (hasError) return Icons.error_outline_rounded;
    return switch (step) {
      'reading' => Icons.folder_open_rounded,
      'parsing' => Icons.analytics_rounded,
      'saving' => Icons.save_rounded,
      'done' => Icons.check_circle_rounded,
      _ => Icons.upload_file_rounded,
    };
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return HomeShell(
      title: title,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.lg.w,
                vertical: AppSpacing.xl.h,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    constraints: BoxConstraints(maxWidth: 720.w),
                    padding: EdgeInsets.all(AppSpacing.xl.w),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceOf(context),
                      borderRadius: BorderRadius.circular(AppRadius.lg.r),
                      border: Border.all(
                        color: AppColors.borderOf(
                          context,
                        ).withValues(alpha: 0.3),
                        width: 1.2.w,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: BlocConsumer<ImportDataBloc, ImportDataState>(
                      listenWhen: (prev, current) =>
                          prev.status != current.status,
                      listener: (context, state) {
                        if (state.status == ImportDataStatus.success) {
                          SoundService.instance.play(SoundEffect.itemAdded);
                          AppSnackbar.success(
                            state.resultMessage ?? 'تم الاستيراد بنجاح',
                            title: InventoryStrings.importSnackbarTitleSuccess,
                          );
                        } else if (state.status == ImportDataStatus.error) {
                          SoundService.instance.play(SoundEffect.error);
                          AppSnackbar.error(
                            state.resultMessage ?? 'خطأ في عملية الاستيراد',
                            title: InventoryStrings.importSnackbarTitleError,
                          );
                        }
                      },
                      builder: (context, state) {
                        final bloc = context.read<ImportDataBloc>();
                        final isImporting =
                            state.status == ImportDataStatus.importing;
                        final isDone = state.status == ImportDataStatus.success;
                        final isError = state.status == ImportDataStatus.error;
                        final showProgress = isImporting || isDone;
                        final stepLabel = _stepLabel(state.currentStep);

                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: EdgeInsets.all(AppSpacing.md.w),
                              decoration: BoxDecoration(
                                color:
                                    (isDone
                                            ? AppColors.success
                                            : (isError
                                                  ? scheme.error
                                                  : scheme.primary))
                                        .withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                _stepIcon(state.currentStep, state.hasError),
                                size: 56.sp,
                                color: isDone
                                    ? AppColors.success
                                    : isError
                                    ? scheme.error
                                    : scheme.primary,
                              ),
                            ),
                            SizedBox(height: AppSpacing.lg.h),
                            AppText(
                              isImporting
                                  ? InventoryStrings.importButtonLoading
                                  : title,
                              style: AppTextStyles.title(
                                context,
                              ).copyWith(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: AppSpacing.xs.h),
                            AppText(
                              isImporting && stepLabel.isNotEmpty
                                  ? stepLabel
                                  : description,
                              textAlign: TextAlign.center,
                              style: AppTextStyles.body(
                                context,
                              ).copyWith(color: Colors.grey.shade600),
                            ),
                            SizedBox(height: AppSpacing.xl.h),

                            if (state.fileName != null)
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                  horizontal: AppSpacing.md.w,
                                  vertical: AppSpacing.md.h,
                                ),
                                decoration: BoxDecoration(
                                  color: scheme.primary.withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(
                                    AppRadius.md.r,
                                  ),
                                  border: Border.all(
                                    color: scheme.primary.withValues(
                                      alpha: 0.15,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.description_rounded,
                                      size: AppIconSize.md.value,
                                      color: scheme.primary,
                                    ),
                                    SizedBox(width: 12.w),
                                    Expanded(
                                      child: AppText(
                                        state.fileName!,
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            if (state.fileName == null)
                              Padding(
                                padding: EdgeInsets.only(
                                  bottom: AppSpacing.lg.h,
                                ),
                                child: AppStateView.empty(
                                  icon: Icons.table_chart_outlined,
                                  title: InventoryStrings.importMedicinesNoFile,
                                ),
                              ),

                            if (showProgress) ...[
                              SizedBox(height: AppSpacing.xl.h),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  AppText(
                                    '${InventoryStrings.importProgress}${(state.progress.clamp(0.0, 1.0) * 100).toInt()}%',
                                    style: AppTextStyles.body(context).copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: scheme.primary,
                                    ),
                                  ),
                                  if (isImporting)
                                    SizedBox(
                                      width: 14.w,
                                      height: 14.w,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        color: scheme.primary,
                                      ),
                                    ),
                                ],
                              ),
                              SizedBox(height: 10.h),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  AppRadius.sm.r,
                                ),
                                child: LinearProgressIndicator(
                                  value: state.progress.clamp(0.0, 1.0),
                                  minHeight: 12.h,
                                  backgroundColor: scheme.primary.withValues(
                                    alpha: 0.1,
                                  ),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    isDone ? AppColors.success : scheme.primary,
                                  ),
                                ),
                              ),

                              SizedBox(height: AppSpacing.xl.h),
                              _StepRow(
                                icon: Icons.folder_open_rounded,
                                label: InventoryStrings.importStepReading,
                                isActive: state.currentStep == 'reading',
                                isDone:
                                    state.currentStep != null &&
                                    state.currentStep != 'reading' &&
                                    state.currentStep != 'parsing' &&
                                    state.currentStep != 'saving',
                              ),
                              SizedBox(height: 14.h),
                              _StepRow(
                                icon: Icons.analytics_rounded,
                                label: InventoryStrings.importStepParsing,
                                isActive: state.currentStep == 'parsing',
                                isDone:
                                    state.currentStep != null &&
                                    state.currentStep != 'reading' &&
                                    state.currentStep != 'parsing',
                              ),
                              SizedBox(height: 14.h),
                              _StepRow(
                                icon: Icons.save_rounded,
                                label: InventoryStrings.importStepSaving,
                                isActive: state.currentStep == 'saving',
                                isDone: state.currentStep == 'done',
                              ),

                              if (state.currentStep == 'saving' ||
                                  state.currentStep == 'done') ...[
                                SizedBox(height: AppSpacing.xl.h),
                                _StatsRow(
                                  itemsFound: state.itemsFound,
                                  itemsSaved: state.itemsSaved,
                                  itemsUpdated: state.itemsUpdated,
                                  itemsSkipped: state.itemsSkipped,
                                ),
                              ],
                            ],

                            SizedBox(height: AppSpacing.xxl.h),

                            if (isImporting)
                              AppButton(
                                text: InventoryStrings.importButtonLoading,
                                type: ButtonType.primary,
                                isLoading: true,
                                prefixIcon: Icons.file_upload_rounded,
                                width: double.infinity,
                                height: 54.h,
                                onPressed: null,
                              )
                            else if (isDone || isError)
                              Column(
                                children: [
                                  if (state.resultMessage != null)
                                    Container(
                                      margin: EdgeInsets.only(
                                        bottom: AppSpacing.lg.h,
                                      ),
                                      padding: EdgeInsets.all(AppSpacing.md.w),
                                      decoration: BoxDecoration(
                                        color: isError
                                            ? scheme.error.withValues(
                                                alpha: 0.1,
                                              )
                                            : AppColors.success.withValues(
                                                alpha: 0.1,
                                              ),
                                        borderRadius: BorderRadius.circular(
                                          AppRadius.md.r,
                                        ),
                                        border: Border.all(
                                          color: isError
                                              ? scheme.error.withValues(
                                                  alpha: 0.2,
                                                )
                                              : AppColors.success.withValues(
                                                  alpha: 0.2,
                                                ),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            isError
                                                ? Icons.error_outline_rounded
                                                : Icons
                                                      .check_circle_outline_rounded,
                                            color: isError
                                                ? scheme.error
                                                : AppColors.success,
                                            size: AppIconSize.lg.value,
                                          ),
                                          SizedBox(width: 12.w),
                                          Expanded(
                                            child: AppText(
                                              state.resultMessage!,
                                              style: AppTextStyles.body(context)
                                                  .copyWith(
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  AppButton(
                                    text: InventoryStrings.importNewImport,
                                    type: ButtonType.primary,
                                    prefixIcon: Icons.file_upload_rounded,
                                    width: double.infinity,
                                    height: 54.h,
                                    onPressed: () =>
                                        bloc.add(const ResetImportData()),
                                  ),
                                ],
                              )
                            else
                              AppButton(
                                text: InventoryStrings.importButton,
                                type: ButtonType.primary,
                                prefixIcon: Icons.file_upload_rounded,
                                width: double.infinity,
                                height: 54.h,
                                onPressed: () =>
                                    bloc.add(PickAndImportData(entityType)),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                  SizedBox(height: AppSpacing.xl.h),
                  _FormatGuide(entityType: entityType),
                  SizedBox(height: AppSpacing.xxxl.h),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _FormatGuide extends StatelessWidget {
  final ImportEntityType entityType;

  const _FormatGuide({required this.entityType});

  List<String> get _expectedColumns {
    return switch (entityType) {
      ImportEntityType.medicines || ImportEntityType.products => [
        'اسم الصنف (مطلوب)',
        'باركود',
        'سعر الشراء',
        'سعر البيع',
        'الكمية الحالية',
        'الشركة المصنعة',
        'التصنيف',
        'حد الطلب',
      ],
      ImportEntityType.customers => [
        'الاسم (مطلوب)',
        'الموبايل',
        'العنوان',
        'الشركة/المشروع',
        'حد الائتمان',
        'نسبة الخصم',
      ],
      ImportEntityType.suppliers => [
        'الاسم (مطلوب)',
        'الموبايل',
        'العنوان',
        'اسم المشروع/الشركة',
        'الرصيد الافتتاحي',
        'الرقم الضريبي',
      ],
      ImportEntityType.expenses => [
        'التاريخ',
        'فئة المصروف (مطلوب)',
        'المبلغ (مطلوب)',
        'السبب/الوصف',
        'بواسطة',
      ],
      _ => ['الاسم', 'البيانات الأساسية'],
    };
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      constraints: BoxConstraints(maxWidth: 720.w),
      padding: EdgeInsets.all(AppSpacing.lg.w),
      decoration: BoxDecoration(
        color: scheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppRadius.md.r),
        border: Border.all(color: scheme.primary.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline_rounded,
                color: scheme.primary,
                size: AppIconSize.md.value,
              ),
              SizedBox(width: 8.w),
              AppText(
                'تلميح: التنسيق المتوقع لملف الإكسيل',
                style: AppTextStyles.body(
                  context,
                ).copyWith(fontWeight: FontWeight.bold, color: scheme.primary),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.sm.h),
          AppText(
            'تأكد من وجود هذه الكلمات في صف العناوين (الهيدر) بملفك:',
            style: AppTextStyles.caption(
              context,
            ).copyWith(color: Colors.grey.shade700),
          ),
          SizedBox(height: AppSpacing.md.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: _expectedColumns.map((col) {
              final isRequired = col.contains('مطلوب');
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: isRequired
                      ? scheme.primary.withValues(alpha: 0.1)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.sm.r),
                  border: Border.all(
                    color: isRequired
                        ? scheme.primary.withValues(alpha: 0.3)
                        : Colors.grey.shade300,
                  ),
                ),
                child: AppText(
                  col,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: isRequired
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: isRequired ? scheme.primary : Colors.grey.shade700,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final bool isDone;

  const _StepRow({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.isDone,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = isDone
        ? AppColors.success
        : isActive
        ? scheme.primary
        : Colors.grey.shade400;

    return Row(
      children: [
        Container(
          width: 28.w,
          height: 28.w,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(
            isDone ? Icons.check_rounded : icon,
            size: 16.sp,
            color: color,
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: AppText(
            label,
            style: AppTextStyles.body(context).copyWith(
              fontWeight: isActive || isDone
                  ? FontWeight.w600
                  : FontWeight.normal,
              color: isDone || isActive
                  ? AppColors.textPrimaryOf(context)
                  : Colors.grey,
            ),
          ),
        ),
        if (isActive)
          SizedBox(
            width: 16.w,
            height: 16.w,
            child: CircularProgressIndicator(strokeWidth: 2, color: color),
          ),
      ],
    );
  }
}

class _StatsRow extends StatelessWidget {
  final int itemsFound;
  final int itemsSaved;
  final int itemsUpdated;
  final int itemsSkipped;

  const _StatsRow({
    required this.itemsFound,
    required this.itemsSaved,
    required this.itemsUpdated,
    required this.itemsSkipped,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.all(AppSpacing.md.w),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppRadius.md.r),
      ),
      child: Column(
        children: [
          _StatItem(
            label: InventoryStrings.importStatsTotal,
            value: '$itemsFound',
            color: scheme.primary,
          ),
          SizedBox(height: 8.h),
          Divider(height: 1, color: Colors.grey.shade300),
          SizedBox(height: 8.h),
          Row(
            children: [
              Expanded(
                child: _StatItem(
                  label: InventoryStrings.importStatsNew,
                  value: '$itemsSaved',
                  color: AppColors.success,
                  compact: true,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _StatItem(
                  label: InventoryStrings.importStatsUpdated,
                  value: '$itemsUpdated',
                  color: scheme.secondary,
                  compact: true,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _StatItem(
                  label: InventoryStrings.importStatsSkipped,
                  value: '$itemsSkipped',
                  color: Colors.orange,
                  compact: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final bool compact;

  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppText(
          value,
          style: AppTextStyles.title(
            context,
          ).copyWith(fontWeight: FontWeight.bold, color: color),
        ),
        SizedBox(height: 2.h),
        AppText(
          label,
          style: AppTextStyles.caption(context).copyWith(color: Colors.grey),
        ),
      ],
    );
  }
}
