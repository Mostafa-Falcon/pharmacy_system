// views/user_profile_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_system/app/core/constants/app_strings.dart';
import 'package:pharmacy_system/app/core/presentation/widgets/index.dart';
import 'package:pharmacy_system/app/modules/auth/models/user_model.dart';
import 'package:pharmacy_system/app/core/data/services/auth/auth_service.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_colors.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_sizes.dart';
import 'package:pharmacy_system/app/core/presentation/design_system/screen_tier.dart';

class UserProfileView extends StatelessWidget {
  const UserProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isWeb = ScreenTierResolver.isDesktop(context);

    return HomeShell(
      title: AppStrings.profileTitle,
      subtitle: AppStrings.profileSubtitle,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.all(AppSpacing.lg.w),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 1100.w),
            child: isWeb
                ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 4, child: _buildProfileCard(context, user, scheme)),
                SizedBox(width: AppSpacing.lg.w),
                Expanded(flex: 7, child: _buildDetailsAndActions(context, user, scheme)),
              ],
            )
                : Column(
              children: [
                _buildProfileCard(context, user, scheme),
                SizedBox(height: AppSpacing.md.h),
                _buildDetailsAndActions(context, user, scheme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context, UserModel? user, ColorScheme scheme) {
    return AppCard(
      padding: EdgeInsets.symmetric(vertical: 32.h, horizontal: AppSpacing.md.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 100.w, height: 100.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight, end: Alignment.bottomLeft,
                colors: [scheme.primary, scheme.primary.withValues(alpha: 0.85)],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: scheme.primary.withValues(alpha: 0.2), blurRadius: 20, offset: const Offset(0, 8)),
              ],
            ),
            child: Icon(Icons.person_rounded, size: AppIconSize.xxl.value, color: Colors.white),
          ),
          SizedBox(height: AppSpacing.md.h),
          ReusableText(
            user?.name ?? AppStrings.mainPageActiveUser,
            style: AppTextStyles.title(context).copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimaryOf(context)),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 6.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: scheme.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(AppRadius.pill.r),
            ),
            child: ReusableText(
              user?.role == UserRole.owner ? AppStrings.roleSupervisor : AppStrings.roleShiftPharmacist,
              style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.bold, color: scheme.primary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsAndActions(BuildContext context, UserModel? user, ColorScheme scheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionContainer(
          context,
          title: AppStrings.profilePersonalInfo,
          children: [
            _ProfileField(label: AppStrings.profileFullName, value: user?.name ?? '', icon: Icons.person_outline_rounded),
            _ProfileField(label: AppStrings.profileEmail, value: user?.email ?? '', icon: Icons.email_outlined),
            _ProfileField(label: AppStrings.profileRole, value: user?.role == UserRole.owner ? AppStrings.roleSupervisor : AppStrings.roleShiftPharmacist, icon: Icons.shield_outlined),
            _ProfileField(label: AppStrings.profileBranch, value: user?.assignedBranchId ?? AppStrings.profileDefaultBranch, icon: Icons.storefront_rounded),
          ],
        ),
        SizedBox(height: AppSpacing.md.h),
        _buildSectionContainer(
          context,
          title: AppStrings.profileDeviceManagement,
          children: [
            _DeviceStatusTile(currentDeviceId: AuthService.currentDeviceId, lockedDeviceId: user?.activeDeviceId),
            const _MultiDeviceInfoTile(),
          ],
        ),
        SizedBox(height: AppSpacing.md.h),
        _buildSectionContainer(
          context,
          title: AppStrings.profileSecurity,
          children: [
            _ActionTile(icon: Icons.edit_note_rounded, title: AppStrings.profileEditData, onTap: () => _showEditProfileDialog(context)),
            _ActionTile(icon: Icons.lock_open_rounded, title: AppStrings.profileChangePassword, onTap: () => _showChangePasswordDialog(context)),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionContainer(BuildContext context, {required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.only(start: 6.w, bottom: 8.h),
          child: ReusableText(title, style: AppTextStyles.body(context).copyWith(fontWeight: FontWeight.bold, color: AppColors.textSecondaryOf(context))),
        ),
        SectionCard(padding: EdgeInsets.zero, children: children),
      ],
    );
  }

  void _showEditProfileDialog(BuildContext context) {
    final user = AuthService.currentUser;
    final nameController = TextEditingController(text: user?.name ?? '');
    final scheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (context) => ReusableDialog(
        title: AppStrings.profileEditDialog,
        headerIcon: Icon(Icons.edit_rounded, color: scheme.primary),
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 340.w),
            child: ReusableInput(
              label: AppStrings.profileEditName,
              controller: nameController,
              prefixIcon: const Icon(Icons.person_outline_rounded),
            ),
          ),
          SizedBox(height: 16.h),
          DialogActions(
            cancelText: AppStrings.empCancelAction,
            confirmText: AppStrings.profileSaveEdit,
            onCancel: () => Navigator.pop(context),
            onConfirm: () {
              if (nameController.text.trim().isEmpty) {
                AppSnackbar.info(
                  AppStrings.profileNameRequired,
                  title: AppStrings.profileSecurityAlert,
                );
                return;
              }
              Navigator.pop(context);
              AppSnackbar.success(AppStrings.profileEditSuccess);
            },
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final scheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (context) => ReusableDialog(
        title: AppStrings.profileChangePasswordDialog,
        headerIcon: Icon(Icons.security_rounded, color: scheme.primary),
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 360.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ReusableInput.password(
                  label: AppStrings.profileCurrentPassword,
                  controller: currentPasswordController,
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                ),
                SizedBox(height: AppSpacing.md.h),
                ReusableInput.password(
                  label: AppStrings.profileNewPassword,
                  controller: newPasswordController,
                  prefixIcon: const Icon(Icons.add_moderator_rounded),
                ),
                SizedBox(height: AppSpacing.md.h),
                ReusableInput.password(
                  label: AppStrings.profileConfirmPassword,
                  controller: confirmPasswordController,
                  prefixIcon: const Icon(Icons.gpp_good_outlined),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          DialogActions(
            cancelText: AppStrings.empCancelAction,
            confirmText: AppStrings.profileUpdateAccount,
            onCancel: () => Navigator.pop(context),
            onConfirm: () {
              if (newPasswordController.text.isEmpty ||
                  confirmPasswordController.text.isEmpty) {
                AppSnackbar.warning(AppStrings.profilePasswordFieldsRequired);
                return;
              }
              Navigator.pop(context);
              AppSnackbar.success(AppStrings.profilePasswordChanged);
            },
          ),
        ],
      ),
    );
  }
}

class _ProfileField extends StatelessWidget {
  final String label; final String value; final IconData icon;
  const _ProfileField({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.w, vertical: AppSpacing.sm.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(color: scheme.primary.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(AppRadius.sm.r)),
            child: Icon(icon, size: AppIconSize.md.value, color: scheme.primary),
          ),
          SizedBox(width: AppSpacing.md.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ReusableText(label, style: AppTextStyles.caption(context).copyWith(color: AppColors.textSecondaryOf(context))),
                SizedBox(height: 2.h),
                ReusableText(value, style: AppTextStyles.body(context).copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimaryOf(context))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DeviceStatusTile extends StatelessWidget {
  final String? currentDeviceId;
  final String? lockedDeviceId;
  const _DeviceStatusTile({this.currentDeviceId, this.lockedDeviceId});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.w, vertical: AppSpacing.sm.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(AppRadius.sm.r),
            ),
            child: Icon(
              Icons.phone_android_rounded,
              size: AppIconSize.md.value,
              color: Colors.green,
            ),
          ),
          SizedBox(width: AppSpacing.md.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ReusableText(
                  AppStrings.deviceAccountOpen,
                  style: AppTextStyles.caption(context).copyWith(color: AppColors.textSecondaryOf(context)),
                ),
                SizedBox(height: 2.h),
                ReusableText(
                  'الجهاز الحالي: ${currentDeviceId != null ? currentDeviceId!.substring(0, 8) : 'غير معروف'}…',
                  style: AppTextStyles.body(context).copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimaryOf(context)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MultiDeviceInfoTile extends StatelessWidget {
  const _MultiDeviceInfoTile();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.w, vertical: AppSpacing.sm.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: scheme.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(AppRadius.sm.r),
            ),
            child: Icon(Icons.devices_rounded, size: AppIconSize.md.value, color: scheme.primary),
          ),
          SizedBox(width: AppSpacing.md.w),
          Expanded(
            child: ReusableText(
              AppStrings.multiDeviceInfo,
              style: AppTextStyles.body(context).copyWith(color: AppColors.textSecondaryOf(context)),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon; final String title; final VoidCallback onTap;
  const _ActionTile({required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        hoverColor: scheme.primary.withValues(alpha: 0.015),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.w, vertical: AppSpacing.sm.h),
          child: Row(
            children: [
              Container(
                width: 34.w, height: 34.w,
                decoration: BoxDecoration(color: scheme.primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(AppRadius.sm.r)),
                child: Icon(icon, size: 18.sp, color: scheme.primary),
              ),
              SizedBox(width: AppSpacing.md.w),
                Expanded(
                  child: ReusableText(title, style: AppTextStyles.body(context).copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimaryOf(context))),
                ),
                Icon(Icons.chevron_left_rounded, size: AppIconSize.md.value, color: AppColors.textSecondaryOf(context).withValues(alpha: 0.6)),
            ],
          ),
        ),
      ),
    );
  }
}


