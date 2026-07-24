import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/injection.dart';
import 'package:pharmacy_system/app/shared/presentation/widgets/index.dart';
import 'package:pharmacy_system/app/core/models/auth/branch_model.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_colors.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../bloc/branches_bloc.dart';
import '../bloc/branches_event.dart';
import '../bloc/branches_state.dart';

class AdminDashboardView extends StatelessWidget {
  const AdminDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<BranchesBloc>(),
      child: const _AdminDashboardBody(),
    );
  }
}

class _AdminDashboardBody extends StatelessWidget {
  const _AdminDashboardBody();

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<BranchesBloc>(),
      child: BlocBuilder<BranchesBloc, BranchesState>(
        builder: (context, state) {
          if (state.isLoading && state.branches.isEmpty) {
            return const HomeShell(
              title: AdminStrings.branchesManagementTitle,
              child: Center(child: LoadingIndicator()),
            );
          }

          return StandardModuleLayout(
            title: AdminStrings.branchesManagementTitle,
            subtitle: AdminStrings.branchesManagementSubtitle,
            actions: [
              AppButton(
                text: AdminStrings.addBranchAction,
                prefixIcon: Icons.add_rounded,
                type: ButtonType.primary,
                onPressed: () => _showAddBranchDialog(context),
              ),
            ],
            content: _buildBranchesList(context, state),
          );
        },
      ),
    );
  }

  Widget _buildBranchesList(BuildContext context, BranchesState state) {
    final scheme = Theme.of(context).colorScheme;

    if (state.error != null && state.branches.isEmpty) {
      return Center(child: AppText(state.error!));
    }

    final branches = state.branches;
    if (branches.isEmpty) {
      return const AppStateView.empty(
        icon: Icons.storefront_rounded,
        title: AdminStrings.noBranchesFound,
      );
    }

    return ListView.builder(
      itemCount: branches.length,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        final branch = branches[index];
        return AppCard(
          margin: EdgeInsets.only(bottom: AppSpacing.sm),
          padding: EdgeInsets.zero,
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(
                horizontal: AppSpacing.md, vertical: AppSpacing.xs),
            leading: CircleAvatar(
              radius: 22.r,
              backgroundColor: AppColors.primarySoftOf(context),
              child:
                  Icon(Icons.store_rounded, color: scheme.primary, size: 20.sp),
            ),
            title: AppText(
              branch.name,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15.sp,
                  color: AppColors.textPrimaryOf(context)),
            ),
            subtitle: Padding(
              padding: EdgeInsets.only(top: 4.h),
              child: Row(
                children: [
                  Icon(Icons.location_on_rounded,
                      size: 13.sp, color: AppColors.textMutedOf(context)),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: AppText(
                      branch.address ?? AdminStrings.noAddressDefined,
                      style: TextStyle(
                          fontSize: 12.5.sp,
                          color: AppColors.textSecondaryOf(context)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit_note_rounded,
                      size: 22.sp, color: scheme.primary),
                  tooltip: AdminStrings.editBranchTooltip,
                  onPressed: () => _showEditBranchDialog(context, branch),
                ),
                IconButton(
                  icon: Icon(Icons.delete_sweep_rounded,
                      size: 22.sp, color: scheme.error),
                  tooltip: AdminStrings.deleteBranchTooltip,
                  onPressed: () => _confirmDeleteBranch(context, branch),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAddBranchDialog(BuildContext context) {
    final nameController = TextEditingController();
    final addressController = TextEditingController();
    final phoneController = TextEditingController();
    final scheme = Theme.of(context).colorScheme;
    final bloc = context.read<BranchesBloc>();

    showDialog(
      context: context,
      builder: (context) => AppDialog(
        title: AdminStrings.addBranchDialogTitle,
        headerIcon: Icon(Icons.add_business_rounded, color: scheme.primary),
        children: [
          AppInput(
            controller: nameController,
            label: AdminStrings.branchFullNameLabel,
            hint: AdminStrings.branchNameExampleHint,
          ),
          SizedBox(height: AppSpacing.md.h),
          AppInput(
            controller: addressController,
            label: AdminStrings.branchDetailedAddressLabel,
            hint: AdminStrings.branchAddressExampleHint,
          ),
          SizedBox(height: AppSpacing.md.h),
          AppInput(
            controller: phoneController,
            label: AdminStrings.branchPhoneLabel,
            hint: AdminStrings.branchPhoneExampleHint,
            keyboardType: TextInputType.phone,
          ),
          SizedBox(height: 16.h),
          DialogActions(
            cancelText: AdminStrings.cancelAddBranchAction,
            confirmText: AdminStrings.confirmAddBranchAction,
            onCancel: () => Navigator.pop(context),
            onConfirm: () {
              if (nameController.text.trim().isEmpty) {
                AppSnackbar.info(
                  AdminStrings.enterBranchNameWarning,
                  title: AdminStrings.importantWarningTitle,
                );
                return;
              }
              bloc.add(
                AddBranch(
                  name: nameController.text.trim(),
                  address: addressController.text.trim(),
                  phone: phoneController.text.trim(),
                ),
              );
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _showEditBranchDialog(BuildContext context, BranchModel branch) {
    final nameController = TextEditingController(text: branch.name);
    final addressController = TextEditingController(text: branch.address ?? '');
    final phoneController = TextEditingController(text: branch.phone ?? '');
    final scheme = Theme.of(context).colorScheme;
    final bloc = context.read<BranchesBloc>();

    showDialog(
      context: context,
      builder: (context) => AppDialog(
        title: AdminStrings.editBranchDialogTitle,
        headerIcon: Icon(Icons.edit_road_rounded, color: scheme.primary),
        children: [
          AppInput(controller: nameController, label: AdminStrings.branchFullNameLabel),
          SizedBox(height: AppSpacing.md.h),
          AppInput(
            controller: addressController,
            label: AdminStrings.branchDetailedAddressLabel,
          ),
          SizedBox(height: AppSpacing.md.h),
          AppInput(
            controller: phoneController,
            label: AdminStrings.branchPhoneLabel,
            keyboardType: TextInputType.phone,
          ),
          SizedBox(height: 16.h),
          DialogActions(
            cancelText: AdminStrings.cancelEditBranchAction,
            confirmText: AdminStrings.saveBranchChangesAction,
            onCancel: () => Navigator.pop(context),
            onConfirm: () {
              if (nameController.text.trim().isEmpty) {
                AppSnackbar.info(
                  AdminStrings.cannotClearBranchNameWarning,
                  title: AdminStrings.importantWarningTitle,
                );
                return;
              }
              bloc.add(
                UpdateBranch(
                  branch.id,
                  name: nameController.text.trim(),
                  address: addressController.text.trim(),
                  phone: phoneController.text.trim(),
                ),
              );
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _confirmDeleteBranch(BuildContext context, BranchModel branch) {
    final bloc = context.read<BranchesBloc>();
    ConfirmDeleteDialog.show(
      context,
      title: AdminStrings.importantSecurityWarningTitle,
      message: AdminStrings.deleteBranchConfirmFormat.replaceFirst('%s', branch.name),
      confirmText: AdminStrings.confirmDeleteBranchAction,
      onConfirm: () => bloc.add(DeleteBranch(branch.id)),
    );
  }
}






