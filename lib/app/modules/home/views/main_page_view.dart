import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:pharmacy_system/app/shared/constants/strings/home_strings.dart';
import 'package:pharmacy_system/app/shared/constants/ui/app_colors.dart';
import 'package:pharmacy_system/app/shared/constants/ui/app_sizes.dart';
import '../../../routes/app_routes.dart';
import 'package:pharmacy_system/app/shared/presentation/widgets/index.dart';

enum HomeQuickActionType {
  cashier,
  salesReturn,
  salesReport,
  customers,
  priceQuotes,
  addPurchase,
  suppliers,
  purchaseReturn,
  expenses,
  addItem,
  items,
  inventoryHealth,
  stockTransfer,
  barcodeLabel,
  settings,
  activityLog,
  users,
  profitLoss,
  permissions,
}

class MainPageView extends StatelessWidget {
  const MainPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return HomeShell(
      title: HomeStrings.mainPageTitle,
      child: const MainPageContent(),
    );
  }
}

class MainPageContent extends StatelessWidget {
  const MainPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser;
    final branch = AuthService.currentBranch;
    final userName = user?.name ?? HomeStrings.mainPageDefaultUser;
    final branchName = branch?.name ?? HomeStrings.mainPageDefaultBranch;

    return LayoutBuilder(
      builder: (context, constraints) {
        final horizontalPadding = constraints.maxWidth < 600
            ? AppSpacing.sm
            : (constraints.maxWidth < 1024 ? AppSpacing.lg : AppSpacing.xl);

        return CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            SliverPadding(
              padding: EdgeInsetsDirectional.fromSTEB(
                horizontalPadding,
                AppSpacing.mdH,
                horizontalPadding,
                0,
              ),
              sliver: SliverToBoxAdapter(
                child: _HomeWelcomeBanner(
                  userName: userName,
                  branchName: branchName,
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsetsDirectional.fromSTEB(
                horizontalPadding,
                AppSpacing.lgH,
                horizontalPadding,
                AppSpacing.xlH,
              ),
              sliver: SliverToBoxAdapter(
                child: _QuickSectionsGrid(
                  onActionTap: (type) => _handleAction(context, type),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _handleAction(BuildContext context, HomeQuickActionType type) {
    final route = switch (type) {
      HomeQuickActionType.cashier => Routes.SALES_POS,
      HomeQuickActionType.salesReturn => Routes.SALES_RETURN,
      HomeQuickActionType.salesReport => Routes.SALES_REPORT,
      HomeQuickActionType.customers => Routes.CUSTOMERS,
      HomeQuickActionType.priceQuotes => Routes.PRICE_QUOTES,
      HomeQuickActionType.addPurchase => Routes.PURCHASE_ADD,
      HomeQuickActionType.suppliers => Routes.SUPPLIERS,
      HomeQuickActionType.purchaseReturn => Routes.PURCHASE_RETURN,
      HomeQuickActionType.expenses => Routes.ACCOUNTING,
      HomeQuickActionType.addItem => Routes.INVENTORY_ADD,
      HomeQuickActionType.items => Routes.INVENTORY_LIST,
      HomeQuickActionType.inventoryHealth => Routes.INVENTORY_HEALTH,
      HomeQuickActionType.stockTransfer => Routes.STOCK_TRANSFER,
      HomeQuickActionType.barcodeLabel => Routes.BARCODE_LABELS,
      HomeQuickActionType.settings => Routes.SETTINGS,
      HomeQuickActionType.activityLog => Routes.ACTIVITY_LOG,
      HomeQuickActionType.users => Routes.EMPLOYEES,
      HomeQuickActionType.profitLoss => Routes.PROFIT_REPORT,
      HomeQuickActionType.permissions => Routes.PERMISSIONS,
    };
    context.push(route);
  }
}

class _QuickSectionsGrid extends StatelessWidget {
  final ValueChanged<HomeQuickActionType>? onActionTap;

  const _QuickSectionsGrid({this.onActionTap});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double spacing = 16.w;

        if (constraints.maxWidth >= 1000) {
          final columnWidth = (constraints.maxWidth - (spacing * 3)) / 4;
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children:
                _buildResponsiveColumns(
                    context,
                    columnWidth,
                  ).expand((w) => [w, SizedBox(width: spacing)]).toList()
                  ..removeLast(),
          );
        }

        final columns = constraints.maxWidth >= 700 ? 2 : 1;
        final columnWidth =
            (constraints.maxWidth - (spacing * (columns - 1))) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: 24.h,
          children: _buildResponsiveColumns(context, columnWidth),
        );
      },
    );
  }

  List<Widget> _buildResponsiveColumns(BuildContext context, double width) {
    return [
      _buildSectionColumn(
        context: context,
        width: width,
        title: HomeStrings.sectionSales,
        color: AppColors.homeSales,
        rows: [
          _RowItem.full(
            type: HomeQuickActionType.cashier,
            label: HomeStrings.actionCashier,
            subtitle: HomeStrings.actionCashierSubtitle,
            icon: Icons.point_of_sale_rounded,
          ),
          _RowItem.split(
            left: _RowItem(
              type: HomeQuickActionType.salesReport,
              label: HomeStrings.actionSalesReport,
              icon: Icons.analytics_outlined,
            ),
            right: _RowItem(
              type: HomeQuickActionType.salesReturn,
              label: HomeStrings.actionSalesReturn,
              icon: Icons.currency_exchange_rounded,
            ),
          ),
          _RowItem.split(
            left: _RowItem(
              type: HomeQuickActionType.priceQuotes,
              label: HomeStrings.actionPriceQuotes,
              icon: Icons.sell_outlined,
            ),
            right: _RowItem(
              type: HomeQuickActionType.customers,
              label: HomeStrings.actionCustomers,
              icon: Icons.group_outlined,
            ),
          ),
        ],
      ),
      _buildSectionColumn(
        context: context,
        width: width,
        title: HomeStrings.sectionPurchases,
        color: AppColors.homePurchases,
        rows: [
          _RowItem.full(
            type: HomeQuickActionType.addPurchase,
            label: HomeStrings.actionAddPurchase,
            subtitle: HomeStrings.actionAddPurchaseSubtitle,
            icon: Icons.note_add_outlined,
          ),
          _RowItem.split(
            left: _RowItem(
              type: HomeQuickActionType.purchaseReturn,
              label: HomeStrings.actionPurchaseReturn,
              icon: Icons.assignment_turned_in_outlined,
            ),
            right: _RowItem(
              type: HomeQuickActionType.suppliers,
              label: HomeStrings.actionSuppliers,
              icon: Icons.person_add_alt_1_outlined,
            ),
          ),
          _RowItem.full(
            type: HomeQuickActionType.expenses,
            label: HomeStrings.actionExpenses,
            icon: Icons.account_balance_wallet_outlined,
          ),
        ],
      ),
      _buildSectionColumn(
        context: context,
        width: width,
        title: HomeStrings.sectionInventory,
        color: AppColors.homeInventory,
        rows: [
          _RowItem.full(
            type: HomeQuickActionType.items,
            label: HomeStrings.actionItems,
            subtitle: HomeStrings.actionItemsSubtitle,
            icon: Icons.medication_rounded,
          ),
          _RowItem.split(
            left: _RowItem(
              type: HomeQuickActionType.addItem,
              label: HomeStrings.actionAddItem,
              icon: Icons.inventory_2_outlined,
            ),
            right: _RowItem(
              type: HomeQuickActionType.inventoryHealth,
              label: HomeStrings.actionInventoryHealth,
              icon: Icons.health_and_safety_outlined,
            ),
          ),
          _RowItem.split(
            left: _RowItem(
              type: HomeQuickActionType.barcodeLabel,
              label: HomeStrings.actionBarcodeLabel,
              icon: Icons.document_scanner_outlined,
            ),
            right: _RowItem(
              type: HomeQuickActionType.stockTransfer,
              label: HomeStrings.actionStockTransfer,
              icon: Icons.local_shipping_outlined,
            ),
          ),
        ],
      ),
      _buildSectionColumn(
        context: context,
        width: width,
        title: HomeStrings.sectionAdminFinance,
        color: AppColors.homeAdministration,
        rows: [
          _RowItem.full(
            type: HomeQuickActionType.settings,
            label: HomeStrings.actionSettings,
            subtitle: HomeStrings.actionSettingsSubtitle,
            icon: Icons.settings_rounded,
          ),
          _RowItem.split(
            left: _RowItem(
              type: HomeQuickActionType.users,
              label: HomeStrings.actionUsers,
              icon: Icons.group_outlined,
            ),
            right: _RowItem(
              type: HomeQuickActionType.activityLog,
              label: HomeStrings.actionActivityLog,
              icon: Icons.assignment_outlined,
            ),
          ),
          _RowItem.full(
            type: HomeQuickActionType.profitLoss,
            label: HomeStrings.actionProfitLoss,
            icon: Icons.attach_money_rounded,
          ),
        ],
      ),
    ];
  }

  IconData _getSectionIcon(String title) {
    return switch (title) {
      HomeStrings.sectionSales => Icons.trending_up_rounded,
      HomeStrings.sectionPurchases => Icons.shopping_bag_outlined,
      HomeStrings.sectionInventory => Icons.warehouse_rounded,
      HomeStrings.sectionAdminFinance => Icons.admin_panel_settings_rounded,
      _ => Icons.category_rounded,
    };
  }

  Widget _buildSectionColumn({
    required BuildContext context,
    required double width,
    required String title,
    required Color color,
    required List<_RowItem> rows,
  }) {
    final isDark = AppColors.isDark(context);
    final sectionIcon = _getSectionIcon(title);

    return Container(
      width: width,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: color.withOpacity(isDark ? 0.25 : 0.15),
          width: 1.5.r,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.04),
            blurRadius: 16.r,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(6.r),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(sectionIcon, color: color, size: 18.sp),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: AppText(
                  title,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimaryOf(context),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: rows.map((row) {
              final isLast = rows.indexOf(row) == rows.length - 1;
              return Padding(
                padding: EdgeInsets.only(bottom: isLast ? 0 : 8.h),
                child: row.isSplit
                    ? Row(
                        children: [
                          Expanded(
                            child: _HomeActionCard(
                              item: row.leftItem!,
                              baseColor: color,
                              onTap: () =>
                                  onActionTap?.call(row.leftItem!.type),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: _HomeActionCard(
                              item: row.rightItem!,
                              baseColor: color,
                              onTap: () =>
                                  onActionTap?.call(row.rightItem!.type),
                            ),
                          ),
                        ],
                      )
                    : _HomeActionCard(
                        item: row,
                        baseColor: color,
                        onTap: () => onActionTap?.call(row.type),
                      ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _HomeActionCard extends StatefulWidget {
  final _RowItem item;
  final Color baseColor;
  final VoidCallback onTap;

  const _HomeActionCard({
    required this.item,
    required this.baseColor,
    required this.onTap,
  });

  @override
  State<_HomeActionCard> createState() => _HomeActionCardState();
}

class _HomeActionCardState extends State<_HomeActionCard> {
  bool _isHovered = false;

  LinearGradient _getGradient(Color baseColor) {
    if (baseColor == AppColors.homeSales) {
      return LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: AppColors.homeGradientSales,
      );
    } else if (baseColor == AppColors.homePurchases) {
      return LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: AppColors.homeGradientPurchases,
      );
    } else if (baseColor == AppColors.homeInventory) {
      return LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: AppColors.homeGradientInventory,
      );
    } else if (baseColor == AppColors.homeAdministration) {
      return LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: AppColors.homeGradientAdministration,
      );
    }
    return LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      colors: [baseColor, baseColor.withOpacity(0.85)],
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasSubtitle = widget.item.subtitle != null;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: double.infinity,
        height: hasSubtitle ? 118.h : 88.h,
        transform: Matrix4.diagonal3Values(
          _isHovered ? 1.025 : 1.0,
          _isHovered ? 1.025 : 1.0,
          1.0,
        )..setTranslationRaw(0.0, _isHovered ? -4.h : 0.0, 0.0),
        decoration: BoxDecoration(
          gradient: _getGradient(widget.baseColor),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: Colors.white.withOpacity(_isHovered ? 0.45 : 0.15),
            width: 1.5.r,
          ),
          boxShadow: [
            BoxShadow(
              color: widget.baseColor.withOpacity(_isHovered ? 0.35 : 0.15),
              blurRadius: _isHovered ? 12.r : 6.r,
              offset: Offset(0, _isHovered ? 6.h : 3.h),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(16.r),
            splashColor: Colors.white.withOpacity(0.12),
            highlightColor: Colors.white.withOpacity(0.06),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: EdgeInsets.all(hasSubtitle ? 8.r : 6.r),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(_isHovered ? 0.28 : 0.18),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(
                      widget.item.icon,
                      color: Colors.white,
                      size: hasSubtitle ? 22.sp : 19.sp,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  AppText(
                    widget.item.label,
                    style: TextStyle(
                      fontSize: hasSubtitle ? 13.sp : 12.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (hasSubtitle) ...[
                    SizedBox(height: 3.h),
                    AppText(
                      widget.item.subtitle!,
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withOpacity(0.8),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RowItem {
  final HomeQuickActionType type;
  final String label;
  final String? subtitle;
  final IconData icon;

  final bool isSplit;
  final _RowItem? leftItem;
  final _RowItem? rightItem;

  const _RowItem({required this.type, required this.label, required this.icon})
    : subtitle = null,
      isSplit = false,
      leftItem = null,
      rightItem = null;

  const _RowItem.full({
    required this.type,
    required this.label,
    this.subtitle,
    required this.icon,
  }) : isSplit = false,
       leftItem = null,
       rightItem = null;

  _RowItem.split({required _RowItem left, required _RowItem right})
    : type = HomeQuickActionType.cashier,
      label = '',
      subtitle = null,
      icon = Icons.abc,
      isSplit = true,
      leftItem = left,
      rightItem = right;
}

class _HomeWelcomeBanner extends StatelessWidget {
  final String userName;
  final String branchName;

  const _HomeWelcomeBanner({required this.userName, required this.branchName});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [scheme.primary, scheme.secondary],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24.r,
            backgroundColor: Colors.white.withOpacity(0.2),
            child: Icon(Icons.person_rounded, color: Colors.white, size: 28.sp),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  'مرحباً بك، $userName 👋',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4.h),
                AppText(
                  'فرع: $branchName',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.white.withOpacity(0.85),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
