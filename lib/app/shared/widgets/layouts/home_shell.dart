import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pharmacy_system/app/shared/ui_core.dart';

import 'package:pharmacy_system/app/core/sync/sync_service.dart';
import 'package:pharmacy_system/app/core/data/services/ui/sound_service.dart';
import 'package:pharmacy_system/app/core/theme/sidebar_theme.dart';
import 'package:pharmacy_system/app/modules/auth/bloc/auth_bloc.dart';
import 'package:pharmacy_system/app/modules/layout/index.dart';
import 'package:pharmacy_system/app/routes/app_routes.dart';

String? destinationForCurrentRoute(BuildContext context) =>
    Routes.routeToDestination[GoRouterState.of(context).uri.path];

class HomeShell extends StatelessWidget {
  final Widget child;
  final String title;
  final String? subtitle;

  const HomeShell({
    super.key,
    required this.child,
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return _ShellBody(title: title, subtitle: subtitle, child: child);
  }
}

class _ShellBody extends StatelessWidget {
  final Widget child;
  final String title;
  final String? subtitle;

  const _ShellBody({required this.child, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShellBloc, ShellState>(
      builder: (context, state) {
        if (state.status == ShellStatus.initial ||
            state.status == ShellStatus.loading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state.status == ShellStatus.error) {
          final scheme = Theme.of(context).colorScheme;
          return Scaffold(
            backgroundColor: AppColors.backgroundOf(context),
            body: Center(
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        color: scheme.error.withValues(alpha: 0.08),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.error_outline_rounded,
                        size: 64.sp,
                        color: scheme.error,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    ReusableText(
                      state.error ?? 'خطأ في تحميل الواجهة',
                      style: AppTextStyles.title(context).copyWith(
                        color: scheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    ReusableText(
                      'يرجى التأكد من تسجيل الدخول أو إعادة المحاولة',
                      style: AppTextStyles.caption(context).copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: 32.h),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ReusableButton(
                          text: 'إعادة المحاولة',
                          prefixIcon: Icons.refresh_rounded,
                          onPressed: () => context.read<ShellBloc>().add(const LoadShell()),
                        ),
                        SizedBox(width: 12.w),
                        ReusableButton(
                          text: 'تسجيل الخروج',
                          type: ButtonType.outlined,
                          color: scheme.error,
                          onPressed: () => context.read<AuthBloc>().add(const LogoutRequested()),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final isDark = AppColors.isDark(context);
        final selectedId = destinationForCurrentRoute(context);
        final selectedIndex = _resolveIndex(state.groups, selectedId);
        final isDesktop = ScreenTierResolver.of(context) != ScreenTier.mobile;
        final sectorColor = AppHomeColors.getSectorColor(selectedId);
        final currentTheme = Theme.of(context);

        final sidebarTheme = currentTheme.extension<SidebarTheme>();
        if (sidebarTheme == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // تطبيق ثيم القطاع ديناميكياً بناءً على الصفحة الحالية
        final sectorTheme = currentTheme.copyWith(
          colorScheme: currentTheme.colorScheme.copyWith(primary: sectorColor),
          extensions: [
            sidebarTheme.copyWith(selectedIndicatorColor: sectorColor),
          ],
        );

        return Theme(
          data: sectorTheme,
          child: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: isDark
                  ? Brightness.light
                  : Brightness.dark,
              statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
              systemNavigationBarColor: AppColors.backgroundOf(context),
              systemNavigationBarIconBrightness: isDark
                  ? Brightness.light
                  : Brightness.dark,
            ),
            child: isDesktop
                ? _desktopLayout(context, state, selectedIndex)
                : _mobileLayout(context, state, selectedIndex),
          ),
        );
      },
    );
  }

  int _resolveIndex(List<SidebarGroup> groups, String? selectedId) {
    if (selectedId == null) return 0;
    var idx = 0;
    for (final group in groups) {
      for (final item in group.children) {
        if (item.id == selectedId) return idx;
        idx++;
        if (item.children != null) {
          for (final child in item.children!) {
            if (child.id == selectedId) return idx;
            idx++;
          }
        }
      }
    }
    return 0;
  }

  // ─── Desktop ───

  Widget _desktopLayout(
    BuildContext context,
    ShellState state,
    int selectedIndex,
  ) {
    final isDark = AppColors.isDark(context);
    final bloc = context.read<ShellBloc>();

    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      body: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            width: state.sidebarVisible ? 250.w : 68.w,
            child: HomeSidebar(
              isSidebarVisible: state.sidebarVisible,
              selectedIndex: selectedIndex,
              groups: state.groups,
              branches: state.branches,
              activeBranchId: state.activeBranchId,
              onNavigate: (index) => _onNavigate(context, state.groups, index),
              onBranchChanged: (id) => _onBranchChanged(context, id),
            ),
          ),
          Container(
            width: 1.w,
            color: AppColors.borderOf(
              context,
            ).withValues(alpha: isDark ? 0.25 : 0.45),
          ),
          Expanded(
            child: Column(
              children: [
                HomeNavbar(
                  title: title,
                  subtitle: subtitle ?? '',
                  isSidebarVisible: state.sidebarVisible,
                  onToggleSidebar: () {
                    HapticFeedback.lightImpact();
                    bloc.add(const ToggleSidebar());
                  },
                  userName: state.user?.name ?? '',
                  userRole: (state.user?.isOwner ?? false)
                      ? 'صاحب الصيدلية'
                      : 'موظف',
                  isOnline: SyncService.isOnline,
                  notificationCount: SyncService.pendingOperationsCount,
                  onCalculatorTap: () => ReusableCalculator.show(context),
                  onCashierTap: () => _navigateToDestination(context, 'pos'),
                ),
                Expanded(
                  child: Container(
                    color: AppColors.backgroundOf(context),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 180),
                      switchInCurve: Curves.easeIn,
                      switchOutCurve: Curves.easeOut,
                      child: KeyedSubtree(
                        key: ValueKey(GoRouterState.of(context).uri.path),
                        child: child,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Mobile ───

  Widget _mobileLayout(
    BuildContext context,
    ShellState state,
    int selectedIndex,
  ) {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: AppColors.backgroundOf(context),
      drawer: Drawer(
        elevation: 12,
        width: 260.w,
        backgroundColor: Colors.transparent,
        child: HomeSidebar(
          isDrawer: true,
          isSidebarVisible: true,
          selectedIndex: selectedIndex,
          groups: state.groups,
          branches: state.branches,
          activeBranchId: state.activeBranchId,
          onNavigate: (index) {
            _onNavigate(context, state.groups, index);
            scaffoldKey.currentState?.closeDrawer();
          },
          onBranchChanged: (id) => _onBranchChanged(context, id),
        ),
      ),
      body: Column(
        children: [
          HomeNavbar(
            title: title,
            subtitle: subtitle ?? '',
            isSidebarVisible: true,
            onMenuPressed: () => scaffoldKey.currentState?.openDrawer(),
            userName: state.user?.name ?? '',
            userRole: (state.user?.isOwner ?? false) ? 'صاحب الصيدلية' : 'موظف',
            isOnline: SyncService.isOnline,
            notificationCount: SyncService.pendingOperationsCount,
            onCalculatorTap: () => ReusableCalculator.show(context),
            onCashierTap: () => _navigateToDestination(context, 'pos'),
          ),
          Expanded(
            child: Container(
              color: AppColors.backgroundOf(context),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                child: KeyedSubtree(
                  key: ValueKey(GoRouterState.of(context).uri.path),
                  child: child,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Navigation ───

  void _onNavigate(BuildContext context, List<SidebarGroup> groups, int index) {
    SoundService.instance.play(SoundEffect.click);
    var idx = 0;
    for (final group in groups) {
      for (final item in group.children) {
        if (idx == index) {
          _navigateToDestination(context, item.id);
          return;
        }
        idx++;
        if (item.children != null) {
          for (final child in item.children!) {
            if (idx == index) {
              _navigateToDestination(context, child.id);
              return;
            }
            idx++;
          }
        }
      }
    }
  }

  void _navigateToDestination(BuildContext context, String destinationId) {
    final route = Routes.routeForDestination(destinationId);
    if (route != null) {
      final currentRoute = GoRouterState.of(context).uri.path;
      if (currentRoute == route) return;
      GoRouter.of(context).go(route);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: ReusableText(
            'هذا القسم سيتم تفعيله وتطويره قريباً بالتعاون مع لوجيسكا ديجيتال سيستم',
            style: AppTextStyles.caption(
              context,
            ).copyWith(fontWeight: FontWeight.bold),
          ),
          backgroundColor: AppColors.surfaceOf(context),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md.r),
            side: BorderSide(
              color: AppColors.borderOf(context).withValues(alpha: 0.3),
              width: 1.w,
            ),
          ),
          margin: EdgeInsets.all(16.w),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  // ─── Branch Change ───

  void _onBranchChanged(BuildContext context, String branchId) {
    SoundService.instance.play(SoundEffect.click);
    context.read<ShellBloc>().add(SelectBranch(branchId));
    GoRouter.of(context).go(Routes.HOME);
  }

  // ─── Support Dialog ───

  void _showSupportDialog(BuildContext context) {
    const waNumber = '01034145441';
    ReusableDialog.show(
      context,
      title: GeneralStrings.techSupportTitle,
      headerIcon: const Icon(Icons.chat_outlined, color: AppColors.success),
      maxWidth: 360,
      children: [
        ReusableText(
          GeneralStrings.supportContactPrefix,
          style: AppTextStyles.caption(context),
        ),
        SizedBox(height: 12.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: AppColors.success.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(AppRadius.md.r),
            border: Border.all(
              color: AppColors.success.withValues(alpha: 0.18),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.chat_outlined,
                size: AppIconSize.sm.value,
                color: AppColors.success,
              ),
              SizedBox(width: 10.w),
              ReusableText(
                waNumber,
                style: AppTextStyles.body(
                  context,
                ).copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        SizedBox(height: 20.h),
        Row(
          children: [
            Expanded(
              child: ReusableButton(
                text: GeneralStrings.copyNumber,
                prefixIcon: Icons.copy_rounded,
                type: ButtonType.text,
                onPressed: () {
                  Clipboard.setData(const ClipboardData(text: waNumber));
                  Navigator.of(context).pop();
                  AppSnackbar.success('تم نسخ رقم واتساب الدعم الفني');
                },
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: ReusableButton(
                text: GeneralStrings.openWhatsapp,
                prefixIcon: Icons.open_in_new_rounded,
                type: ButtonType.primary,
                onPressed: () {
                  Navigator.of(context).pop();
                  AppSnackbar.info(waNumber, title: 'رقم الدعم');
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ─── Logout ───

  void _logout(BuildContext context) {
    SoundService.instance.play(SoundEffect.error);

    ReusableDialog.show(
      context,
      title: AuthStrings.logoutTitle,
      headerIcon: const Icon(Icons.logout_rounded, color: AppColors.error),
      maxWidth: 360,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: ReusableText(
            AuthStrings.logoutConfirm,
            style: AppTextStyles.caption(context).copyWith(height: 1.35),
          ),
        ),
        SizedBox(height: 24.h),
        DialogActions(
          cancelText: AuthStrings.cancelAndBack,
          confirmText: AuthStrings.yesLogout,
          confirmType: ButtonType.error,
          onCancel: () => Navigator.of(context).pop(),
          onConfirm: () {
            Navigator.of(context).pop();
            context.read<AuthBloc>().add(const LogoutRequested());
          },
        ),
      ],
    );
  }
}






