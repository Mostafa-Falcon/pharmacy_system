import 'package:flutter/material.dart';

class AppColors {
  // UTF-8 Force Refresh
  AppColors._();

  // ── Brand & Core ──
  static const primary = Color(0xFF2563EB);
  static const primaryDark = Color(0xFF1D4ED8);
  static const primaryLight = Color(0xFF3B82F6);

  // ── Semantic Alerts ──
  static const success = Color(0xFF10B981);
  static const error = Color(0xFFEF4444);
  static const warning = Color(0xFFF59E0B);
  static const info = Color(0xFF3B82F6);

  // ── Home & Dashboard Sections ──
  static const homeSales = Color(0xFF1F82BA);
  static const homePurchases = Color(0xFFD97706);
  static const homeInventory = Color(0xFF168E7B);
  static const homeAdministration = Color(0xFF5C50C9);

  // ── Light Theme Spectrum ──
  static const lightBackground = Color(0xFFF8FAFC);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightText = Color(0xFF0F172A);
  static const lightTextSecondary = Color(0xFF475569);
  static const lightTextMuted = Color(0xFF94A3B8);
  static const lightBorder = Color(0xFFE2E8F0);
  static const lightDivider = Color(0xFFCBD5E1);
  static const lightInputFill = Color(0xFFF1F5F9);

  // ── Dark Theme Spectrum ──
  static const darkBackground = Color(0xFF0F172A);
  static const darkSurface = Color(0xFF1E293B);
  static const darkSurfaceHigh = Color(0xFF334155);
  static const darkText = Color(0xFFE2E8F0);
  static const darkTextSecondary = Color(0xFF94A3B8);
  static const darkTextMuted = Color(0xFF64748B);
  static const darkBorder = Color(0xFF334155);
  static const darkDivider = Color(0xFF1E293B);
  static const darkInputFill = Color(0xFF1E293B);

  // ── Sidebar Light Interface ──
  static const sidebarLightBg = Color(0xFFFFFFFF);
  static const sidebarLightText = Color(0xFF334155);
  static const sidebarLightMuted = Color(0xFF94A3B8);
  static const sidebarLightHover = Color(0xFFF1F5F9);
  static const sidebarLightSelected = Color(0xFFEFF6FF);

  // ── Sidebar Dark Interface ──
  static const sidebarDarkBg = Color(0xFF1E293B);
  static const sidebarDarkText = Color(0xFFCDD6F4);
  static const sidebarDarkMuted = Color(0xFF64748B);
  static const sidebarDarkHover = Color(0xFF334155);
  static const sidebarDarkSelected = Color(0x262563EB); // Blue @ 15%

  // ── Static Getters for Backward Compatibility (حل أخطاء الملفات القديمة) ──
  static Color get surface => lightSurface;
  static Color get onSurface => lightText;
  static Color get onSurfaceVariant => lightTextSecondary;
  static Color get onBackground => lightText;
  static Color get onBackgroundMuted => lightTextMuted;
  static Color get hintLight => lightTextMuted;
  static Color get inputBackground => lightInputFill;
  static Color get dividerLight => lightDivider;
  static Color get primarySoft => const Color(0xFFEFF6FF);
  static Color get shadow => const Color(0x0D000000); // 5% shadow

  // ── Brand / Sector Gradients (مُوحّدة لتُستخدم في كل المنظومة بدل الـ hardcoded) ──
  static const homeGradientSales = [Color(0xFF1F82BA), Color(0xFF0EA5E9)];
  static const homeGradientPurchases = [Color(0xFFD97706), Color(0xFFEA580C)];
  static const homeGradientInventory = [Color(0xFF168E7B), Color(0xFF059669)];
  static const homeGradientAdministration = [Color(0xFF5C50C9), Color(0xFF6D28D9)];

  // ── POS Category Palette (الألوان المعتمدة لفئات نقطة البيع — موحّدة) ──
  static const posCategoryPalette = <Color>[
    Color(0xFFF43F5E),
    Color(0xFF8B5CF6),
    Color(0xFFD97706),
    Color(0xFF0284C7),
    Color(0xFF6366F1),
    Color(0xFF0D9488),
    Color(0xFF10B981),
    Color(0xFFF97316),
    Color(0xFF84CC16),
    Color(0xFFEAB308),
    Color(0xFF06B6D4),
    Color(0xFF64748B),
    Color(0xFFEC4899),
    Color(0xFFEF4444),
  ];

  static Color posCategoryColor(int index) =>
      posCategoryPalette[index % posCategoryPalette.length];

  // ── Chart / Accent Palette (للرسوم البيانية والشارات) ──
  static const chartBlue = Color(0xFF2563EB);
  static const chartTeal = Color(0xFF1E3A5F);
  static const chartTealDark = Color(0xFF0F2640);
  static const chartGreen = Color(0xFF10B981);
  static const chartAmber = Color(0xFFF59E0B);
  static const chartRed = Color(0xFFEF4444);

  // ── Surface Tints (درجات خلفية ثابتة تُستخدم في الـ branded headers) ──
  static const surfaceTintDark = Color(0xFF0F172A);
  static const surfaceTintDarkAlt = Color(0xFF1E293B);
  static const surfaceTintDarkDeep = Color(0xFF0B132B);
  static const surfaceTintDarkNavy = Color(0xFF1E3A8A);
  static const surfaceTintLight = Color(0xFFF1F5F9);
  static const surfaceTintLightAlt = Color(0xFFF8FAFC);
  static const brandBlueDeep = Color(0xFF1E40AF);

  // ── Context-aware Dynamic Resolvers (القلب النابض للـ Live Theme) ──

  static Color surfaceContainer(BuildContext context) =>
      Theme.of(context).colorScheme.surfaceContainerLow.withValues(alpha: 0.15);

  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static Color backgroundOf(BuildContext context) =>
      isDark(context) ? darkBackground : lightBackground;

  static Color surfaceOf(BuildContext context) =>
      isDark(context) ? darkSurface : lightSurface;

  static Color surfaceHighOf(BuildContext context) =>
      isDark(context) ? darkSurfaceHigh : lightInputFill;

  static Color textPrimaryOf(BuildContext context) =>
      isDark(context) ? darkText : lightText;

  static Color textSecondaryOf(BuildContext context) =>
      isDark(context) ? darkTextSecondary : lightTextSecondary;

  static Color textMutedOf(BuildContext context) =>
      isDark(context) ? darkTextMuted : lightTextMuted;

  static Color borderOf(BuildContext context) =>
      isDark(context) ? darkBorder : lightBorder;

  static Color dividerOf(BuildContext context) =>
      isDark(context) ? darkDivider : lightDivider;

  static Color inputFillOf(BuildContext context) =>
      isDark(context) ? darkInputFill : lightInputFill;

  // ── Soft Semantic Alpha Colors ──

  static Color primarySoftOf(BuildContext context) =>
      primary.withValues(alpha: isDark(context) ? 0.15 : 0.06);

  static Color successSoftOf(BuildContext context) =>
      success.withValues(alpha: isDark(context) ? 0.16 : 0.08);

  static Color warningSoftOf(BuildContext context) =>
      warning.withValues(alpha: isDark(context) ? 0.16 : 0.08);

  static Color errorSoftOf(BuildContext context) =>
      error.withValues(alpha: isDark(context) ? 0.16 : 0.08);

  static Color infoSoftOf(BuildContext context) =>
      info.withValues(alpha: isDark(context) ? 0.16 : 0.08);

  // ── Dynamic Sidebar Resolvers ──

  static Color sidebarBgOf(BuildContext context) =>
      isDark(context) ? sidebarDarkBg : sidebarLightBg;

  static Color sidebarTextOf(BuildContext context) =>
      isDark(context) ? sidebarDarkText : sidebarLightText;

  static Color sidebarMutedOf(BuildContext context) =>
      isDark(context) ? sidebarDarkMuted : sidebarLightMuted;

  static Color sidebarHoverOf(BuildContext context) =>
      isDark(context) ? sidebarDarkHover : sidebarLightHover;

  static Color sidebarSelectedOf(BuildContext context) =>
      isDark(context) ? sidebarDarkSelected : sidebarLightSelected;
}

// ── تأمين كلاس الـ Home لمنع أخطاء الـ Dashboard والـ Quick Sections ──
class AppHomeColors {
  AppHomeColors._();
  static const sales = AppColors.homeSales;
  static const purchases = AppColors.homePurchases;
  static const inventory = AppColors.homeInventory;
  static const administration = AppColors.homeAdministration;

  static Color getSectorColor(String? destinationId) {
    if (destinationId == null) return AppColors.primary;

    // Mapping based on sectors in MainPageView
    final salesIds = {
      'pos',
      'cashier_shifts',
      'sales_invoice',
      'sales_return',
      'price_quotes',
      'sales_report',
      'customers',
      'customer_groups'
    };
    final purchaseIds = {
      'purchase_order',
      'purchase_invoice',
      'purchase_return',
      'purchase_report',
      'suppliers'
    };
    final inventoryIds = {
      'items_list',
      'add_item',
      'inventory_health',
      'barcode_label',
      'barcode_settings',
      'items_archive',
      'inventory_import',
      'inventory_stock_transfer',
      'inventory_stocktaking'
    };
    final adminIds = {
      'settings',
      'profile',
      'employees',
      'branches',
      'permissions',
      'activity_log',
      'document_control',
      'archive',
      'accounting',
      'hr',
      'profit_report',
      'admin_dashboard'
    };

    if (salesIds.contains(destinationId)) return sales;
    if (purchaseIds.contains(destinationId)) return purchases;
    if (inventoryIds.contains(destinationId)) return inventory;
    if (adminIds.contains(destinationId)) return administration;

    return AppColors.primary;
  }
}


