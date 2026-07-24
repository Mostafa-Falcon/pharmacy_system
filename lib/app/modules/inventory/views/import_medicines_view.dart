import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_strings.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_colors.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_sizes.dart';
import 'package:pharmacy_system/app/core/data/services/sound_service.dart';
import '../bloc/import_medicines_bloc.dart';
import '../bloc/import_medicines_event.dart';
import '../bloc/import_medicines_state.dart';
import 'package:pharmacy_system/app/shared/presentation/widgets/index.dart';

class ImportMedicinesView extends StatelessWidget {
  const ImportMedicinesView({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ImportMedicinesBody();
  }
}

class _ImportMedicinesBody extends StatelessWidget {
  const _ImportMedicinesBody();

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
      title: InventoryStrings.importMedicinesTitle,
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
                    constraints: BoxConstraints(
                      maxWidth: 720.w,
                    ),
                    padding: EdgeInsets.all(AppSpacing.xl.w),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceOf(context),
                      borderRadius: BorderRadius.circular(AppRadius.lg.r),
                      border: Border.all(
                        color: AppColors.borderOf(context).withValues(alpha: 0.3),
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
                    child: BlocConsumer<ImportMedicinesBloc, ImportMedicinesState>(
                      listenWhen: (prev, current) => prev.status != current.status,
                      listener: (context, state) {
                        if (state.status == ImportMedicinesStatus.success) {
                          SoundService.instance.play(SoundEffect.itemAdded);
                          AppSnackbar.success(
                            '${InventoryStrings.importSnackbarSuccessPrefix}${state.itemsFound}${InventoryStrings.importSnackbarSuccessSuffix}',
                            title: InventoryStrings.importSnackbarTitleSuccess,
                          );
                        } else if (state.status == ImportMedicinesStatus.error) {
                          SoundService.instance.play(SoundEffect.error);
                          if (state.resultMessage == '${InventoryStrings.importFailPrefix}${InventoryStrings.importNoData}' || state.resultMessage == InventoryStrings.importNoData) {
                            AppSnackbar.warning(
                              InventoryStrings.importSnackbarNoData,
                              title: InventoryStrings.importSnackbarTitleWarning,
                            );
                          } else {
                            AppSnackbar.error(
                              state.resultMessage ?? '??? ?? ????? ?????????',
                              title: InventoryStrings.importSnackbarTitleError,
                            );
                          }
                        }
                      },
                      builder: (context, state) {
                        final bloc = context.read<ImportMedicinesBloc>();
                        final isImporting = state.status == ImportMedicinesStatus.importing;
                        final isDone = state.status == ImportMedicinesStatus.success;
                        final isError = state.status == ImportMedicinesStatus.error;
                        final showProgress = isImporting || isDone;
                        final stepLabel = _stepLabel(state.currentStep);

                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: EdgeInsets.all(AppSpacing.md.w),
                              decoration: BoxDecoration(
                                color: (isDone ? AppColors.success : (isError ? scheme.error : scheme.primary)).withValues(alpha: 0.1),
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
                            ReusableText(
                              isImporting ? InventoryStrings.importButtonLoading : InventoryStrings.importMedicinesTitle,
                              style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: AppSpacing.xs.h),
                            ReusableText(
                              isImporting && stepLabel.isNotEmpty
                                  ? stepLabel
                                  : InventoryStrings.importMedicinesDesc,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600),
                            ),
                            SizedBox(height: AppSpacing.xl.h),

                            // ??? ????? ???????
                            if (state.fileName != null)
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                  horizontal: AppSpacing.md.w,
                                  vertical: AppSpacing.md.h,
                                ),
                                decoration: BoxDecoration(
                                  color: scheme.primary.withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(AppRadius.md.r),
                                  border: Border.all(color: scheme.primary.withValues(alpha: 0.15)),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.description_rounded,
                                        size: 20.sp, color: scheme.primary),
                                    SizedBox(width: 12.w),
                                    Expanded(
                                      child: ReusableText(
                                        state.fileName!,
                                        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            if (state.fileName == null)
                              Padding(
                                padding: EdgeInsets.only(bottom: AppSpacing.lg.h),
                                child: EmptyState(
                                  icon: Icons.table_chart_outlined,
                                  title: InventoryStrings.importMedicinesNoFile,
                                ),
                              ),

                            // ???? ?????? + ???????
                            if (showProgress) ...[
                              SizedBox(height: AppSpacing.xl.h),
                              
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  ReusableText(
                                    '${InventoryStrings.importProgress}${(state.progress.clamp(0.0, 1.0) * 100).toInt()}%',
                                    style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold, color: scheme.primary),
                                  ),
                                  if (isImporting)
                                    SizedBox(
                                      width: 14.w,
                                      height: 14.w,
                                      child: CircularProgressIndicator(strokeWidth: 2.5, color: scheme.primary),
                                    ),
                                ],
                              ),
                              SizedBox(height: 10.h),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(AppRadius.sm.r),
                                child: LinearProgressIndicator(
                                  value: state.progress.clamp(0.0, 1.0),
                                  minHeight: 12.h,
                                  backgroundColor: scheme.primary.withValues(alpha: 0.1),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    isDone ? AppColors.success : scheme.primary,
                                  ),
                                ),
                              ),

                              // ????? ???????
                              SizedBox(height: AppSpacing.xl.h),
                              _StepRow(
                                icon: Icons.folder_open_rounded,
                                label: InventoryStrings.importStepReading,
                                isActive: state.currentStep == 'reading',
                                isDone: ['parsing', 'saving', 'done'].contains(state.currentStep),
                              ),
                              SizedBox(height: 14.h),
                              _StepRow(
                                icon: Icons.analytics_rounded,
                                label: InventoryStrings.importStepParsing,
                                isActive: state.currentStep == 'parsing',
                                isDone: ['saving', 'done'].contains(state.currentStep),
                              ),
                              SizedBox(height: 14.h),
                              _StepRow(
                                icon: Icons.save_rounded,
                                label: InventoryStrings.importStepSaving,
                                isActive: state.currentStep == 'saving',
                                isDone: state.currentStep == 'done',
                              ),

                              // ???????? ?????
                              if (state.currentStep == 'parsing' || state.currentStep == 'saving' || state.currentStep == 'done') ...[
                                SizedBox(height: AppSpacing.xl.h),
                                _StatsRow(
                                  itemsFound: state.itemsFound,
                                  itemsSaved: state.itemsSaved,
                                  itemsUpdated: state.itemsUpdated,
                                  itemsSkipped: state.itemsSkipped,
                                  currentStep: state.currentStep,
                                ),
                              ],
                            ],

                            SizedBox(height: AppSpacing.xxl.h),

                            // ???????
                            if (isImporting)
                              ReusableButton(
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
                                      margin: EdgeInsets.only(bottom: AppSpacing.lg.h),
                                      padding: EdgeInsets.all(AppSpacing.md.w),
                                      decoration: BoxDecoration(
                                        color: isError
                                            ? scheme.error.withValues(alpha: 0.1)
                                            : AppColors.success.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(AppRadius.md.r),
                                        border: Border.all(
                                          color: isError 
                                              ? scheme.error.withValues(alpha: 0.2)
                                              : AppColors.success.withValues(alpha: 0.2),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            isError
                                                ? Icons.error_outline_rounded
                                                : Icons.check_circle_outline_rounded,
                                            color: isError ? scheme.error : AppColors.success,
                                            size: 22.sp,
                                          ),
                                          SizedBox(width: 12.w),
                                          Expanded(
                                            child: ReusableText(
                                              state.resultMessage!,
                                              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ReusableButton(
                                    text: InventoryStrings.importNewImport,
                                    type: ButtonType.primary,
                                    prefixIcon: Icons.file_upload_rounded,
                                    width: double.infinity,
                                    height: 54.h,
                                    onPressed: () => bloc.add(const ResetImport()),
                                  ),
                                ],
                              )
                            else
                              ReusableButton(
                                text: InventoryStrings.importButton,
                                type: ButtonType.primary,
                                prefixIcon: Icons.file_upload_rounded,
                                width: double.infinity,
                                height: 54.h,
                                onPressed: () => bloc.add(const PickAndImportMedicines()),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
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
          child: ReusableText(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isActive || isDone ? FontWeight.w600 : FontWeight.normal,
              color: isDone || isActive ? AppColors.textPrimaryOf(context) : Colors.grey,
            ),
          ),
        ),
        if (isActive)
          SizedBox(
            width: 16.w,
            height: 16.w,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: color,
            ),
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
  final String? currentStep;

  const _StatsRow({
    required this.itemsFound,
    required this.itemsSaved,
    required this.itemsUpdated,
    required this.itemsSkipped,
    this.currentStep,
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
          if (currentStep == 'parsing')
            _StatItem(
              label: '???? ????? ???????...',
              value: '$itemsFound',
              color: scheme.primary,
            )
          else
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
              Expanded(child: _StatItem(
                label: InventoryStrings.importStatsNew,
                value: '$itemsSaved',
                color: AppColors.success,
                compact: true,
              )),
              SizedBox(width: 8.w),
              Expanded(child: _StatItem(
                label: InventoryStrings.importStatsUpdated,
                value: '$itemsUpdated',
                color: scheme.secondary,
                compact: true,
              )),
              SizedBox(width: 8.w),
              Expanded(child: _StatItem(
                label: InventoryStrings.importStatsSkipped,
                value: '$itemsSkipped',
                color: Colors.orange,
                compact: true,
              )),
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
        ReusableText(
          value,
          style: TextStyle(
            fontSize: compact ? 18.sp : 22.sp,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        SizedBox(height: 2.h),
        ReusableText(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}





