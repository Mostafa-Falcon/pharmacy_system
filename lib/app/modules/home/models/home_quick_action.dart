import 'package:flutter/material.dart';

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

class HomeQuickAction {
  final HomeQuickActionType type;
  final String label;
  final IconData icon;
  final int span;
  final bool isPrimary;

  const HomeQuickAction({
    required this.type,
    required this.label,
    required this.icon,
    this.span = 1,
    this.isPrimary = false,
  }) : assert(span == 1 || span == 2);
}

class HomeQuickSection {
  final String title;
  final Color color;
  final List<HomeQuickAction> actions;

  const HomeQuickSection({
    required this.title,
    required this.color,
    required this.actions,
  });
}
