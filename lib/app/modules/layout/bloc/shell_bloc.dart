import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacy_system/app/core/data/services/auth/auth_service.dart';
import 'package:pharmacy_system/app/core/models/auth/user_model.dart';
import 'package:pharmacy_system/app/shared/ui_core.dart';
import 'package:pharmacy_system/app/shared/widgets/layouts/sidebar.dart';
import 'shell_event.dart';
import 'shell_state.dart';

class ShellBloc extends Bloc<ShellEvent, ShellState> {
  ShellBloc() : super(const ShellState()) {
    on<LoadShell>(_onLoad);
    on<ToggleSidebar>(_onToggleSidebar);
    on<SelectBranch>(_onSelectBranch);
  }

  Future<void> _onLoad(LoadShell event, Emitter<ShellState> emit) async {
    emit(state.copyWith(status: ShellStatus.loading));

    try {
      final user = AuthService.currentUser;
      if (user == null) {
        emit(state.copyWith(status: ShellStatus.error, error: 'لم يتم تسجيل الدخول'));
        return;
      }

      final branches = _buildBranchOptions();
      final groups = _buildSidebarGroups(user);

      emit(state.copyWith(
        status: ShellStatus.loaded,
        user: user,
        groups: groups,
        branches: branches,
        activeBranchId: AuthService.currentBranchId ?? branches.firstOrNull?.id ?? '',
        sidebarVisible: true,
      ));
    } catch (e, s) {
      safeDebugPrint('ShellBloc.LoadShell failed: $e\n$s');
      emit(state.copyWith(status: ShellStatus.error, error: e.toString()));
    }
  }

  void _onToggleSidebar(ToggleSidebar event, Emitter<ShellState> emit) {
    emit(state.copyWith(sidebarVisible: !state.sidebarVisible));
  }

  void _onSelectBranch(SelectBranch event, Emitter<ShellState> emit) {
    emit(state.copyWith(activeBranchId: event.branchId));
  }

  List<BranchOption> _buildBranchOptions() {
    final branch = AuthService.currentBranch;
    if (branch != null) {
      return [BranchOption(id: branch.id, label: branch.name)];
    }
    return [const BranchOption(id: 'default', label: 'الفرع الرئيسي')];
  }

  List<SidebarGroup> _buildSidebarGroups(UserModel user) {
    final isOwner = user.isOwner;
    return [
      SidebarGroup(
        id: 'dashboard', label: 'الشاشة الرئيسية',
        icon: Icons.dashboard_rounded,
        children: const [
          SidebarItem(id: 'main_page', icon: Icons.dashboard_rounded, label: 'لوحة التحكم'),
        ],
      ),
      SidebarGroup(
        id: 'sales', label: 'المبيعات',
        icon: Icons.shopping_cart_rounded,
        children: const [
          SidebarItem(id: 'pos', icon: Icons.point_of_sale_rounded, label: 'نقطة البيع'),
          SidebarItem(id: 'cashier_shifts', icon: Icons.account_balance_wallet_rounded, label: 'ورديات الكاشير'),
          SidebarItem(id: 'sales_invoice', icon: Icons.receipt_long_rounded, label: 'فواتير المبيعات'),
          SidebarItem(id: 'sales_return', icon: Icons.keyboard_return_rounded, label: 'مرتجعات المبيعات'),
          SidebarItem(id: 'price_quotes', icon: Icons.request_quote_rounded, label: 'عروض الأسعار'),
          SidebarItem(id: 'sales_report', icon: Icons.bar_chart_rounded, label: 'تقارير المبيعات'),
        ],
      ),
      SidebarGroup(
        id: 'inventory', label: 'المخزون',
        icon: Icons.inventory_2_rounded,
        children: const [
          SidebarItem(id: 'items_list', icon: Icons.medication_rounded, label: 'الأصناف'),
          SidebarItem(id: 'add_item', icon: Icons.add_circle_outline_rounded, label: 'إضافة صنف'),
          SidebarItem(id: 'inventory_health', icon: Icons.health_and_safety_rounded, label: 'صحة المخزون'),
          SidebarItem(id: 'stock_adjustment', icon: Icons.balance_rounded, label: 'تسويات المخزون'),
          SidebarItem(id: 'inventory_stock_transfer', icon: Icons.swap_horiz_rounded, label: 'تحويل مخزون'),
          SidebarItem(id: 'inventory_stocktaking', icon: Icons.inventory_rounded, label: 'الجرد الفعلي'),
          SidebarItem(id: 'inventory_import', icon: Icons.file_upload_rounded, label: 'استيراد الأصناف'),
          SidebarItem(id: 'brands', icon: Icons.branding_watermark_rounded, label: 'الماركات'),
          SidebarItem(id: 'price_groups', icon: Icons.price_change_rounded, label: 'شرائح التسعير'),
          SidebarItem(id: 'variants', icon: Icons.tune_rounded, label: 'المتغيرات'),
          SidebarItem(id: 'bulk_price_update', icon: Icons.update_rounded, label: 'تحديث أسعار'),
          SidebarItem(id: 'inventory_promotions', icon: Icons.discount_rounded, label: 'العروض'),
          SidebarItem(id: 'items_archive', icon: Icons.archive_rounded, label: 'أرشيف الأصناف'),
        ],
      ),
      SidebarGroup(
        id: 'purchases', label: 'المشتريات',
        icon: Icons.shopping_basket_rounded,
        children: const [
          SidebarItem(id: 'purchase_invoice', icon: Icons.receipt_rounded, label: 'فواتير المشتريات'),
          SidebarItem(id: 'purchase_order', icon: Icons.add_shopping_cart_rounded, label: 'فاتورة مشتريات جديدة'),
          SidebarItem(id: 'purchase_return', icon: Icons.undo_rounded, label: 'مرتجعات المشتريات'),
          SidebarItem(id: 'free_return', icon: Icons.swap_vertical_circle_rounded, label: 'مرتجع حر'),
        ],
      ),
      SidebarGroup(
        id: 'contacts', label: 'جهات الاتصال',
        icon: Icons.contacts_rounded,
        children: const [
          SidebarItem(id: 'customers', icon: Icons.people_rounded, label: 'العملاء'),
          SidebarItem(id: 'suppliers', icon: Icons.local_shipping_rounded, label: 'الموردين'),
          SidebarItem(id: 'customer_groups', icon: Icons.group_work_rounded, label: 'مجموعات العملاء'),
          SidebarItem(id: 'supplier_customers', icon: Icons.handshake_rounded, label: 'مورد/عميل'),
        ],
      ),
      SidebarGroup(
        id: 'accounting', label: 'المحاسبة',
        icon: Icons.account_balance_rounded,
        children: const [
          SidebarItem(id: 'accounting', icon: Icons.account_tree_rounded, label: 'شجرة الحسابات'),
          SidebarItem(id: 'accounting_journal', icon: Icons.book_rounded, label: 'قيود اليومية'),
          SidebarItem(id: 'accounting_expenses', icon: Icons.money_off_rounded, label: 'المصاريف'),
          SidebarItem(id: 'accounting_payments', icon: Icons.payments_rounded, label: 'سندات القبض والدفع'),
        ],
      ),
      SidebarGroup(
        id: 'reports', label: 'التقارير',
        icon: Icons.assessment_rounded,
        children: const [
          SidebarItem(id: 'sales_report', icon: Icons.bar_chart_rounded, label: 'تقارير المبيعات'),
          SidebarItem(id: 'contacts_report', icon: Icons.people_alt_rounded, label: 'تقارير العملاء'),
          SidebarItem(id: 'purchase_report', icon: Icons.shopping_cart_checkout_rounded, label: 'تقارير المشتريات'),
          SidebarItem(id: 'profit_report', icon: Icons.trending_up_rounded, label: 'تقارير الأرباح'),
          SidebarItem(id: 'extra_reports', icon: Icons.more_horiz_rounded, label: 'تقارير إضافية'),
          SidebarItem(id: 'advanced_ledger_report', icon: Icons.bookmark_rounded, label: 'دفتر الأستاذ'),
        ],
      ),
      if (isOwner)
        SidebarGroup(
          id: 'admin', label: 'الإدارة',
          icon: Icons.admin_panel_settings_rounded,
          children: const [
            SidebarItem(id: 'admin_dashboard', icon: Icons.dashboard_customize_rounded, label: 'لوحة الإدارة'),
            SidebarItem(id: 'employees', icon: Icons.badge_rounded, label: 'الموظفين'),
            SidebarItem(id: 'branches', icon: Icons.business_rounded, label: 'الفروع'),
            SidebarItem(id: 'permissions', icon: Icons.security_rounded, label: 'الصلاحيات'),
            SidebarItem(id: 'settings', icon: Icons.settings_rounded, label: 'الإعدادات'),
          ],
        ),
      SidebarGroup(
        id: 'more', label: 'أخرى',
        icon: Icons.more_horiz_rounded,
        children: const [
          SidebarItem(id: 'tasks', icon: Icons.task_alt_rounded, label: 'المهام'),
          SidebarItem(id: 'notifications', icon: Icons.notifications_rounded, label: 'الإشعارات'),
          SidebarItem(id: 'sync_status', icon: Icons.sync_rounded, label: 'حالة المزامنة'),
          SidebarItem(id: 'activity_log', icon: Icons.history_rounded, label: 'سجل النشاطات'),
          SidebarItem(id: 'advanced_archive', icon: Icons.archive_rounded, label: 'الأرشيف'),
          SidebarItem(id: 'void_operations', icon: Icons.cancel_schedule_send_rounded, label: 'العمليات الملغية'),
        ],
      ),
    ];
  }
}
