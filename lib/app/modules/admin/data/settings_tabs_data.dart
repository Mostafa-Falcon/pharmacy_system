import 'package:flutter/material.dart';
import 'package:pharmacy_system/app/core/constants/app_strings.dart';

class SettingsTab {
  final String id;
  final String label;
  final IconData icon;
  final List<String> keywords;

  const SettingsTab({
    required this.id,
    required this.label,
    required this.icon,
    this.keywords = const [],
  });
}

final settingsTabs = [
  const SettingsTab(
    id: 'project',
    label: AdminStrings.settingsTabProject,
    icon: Icons.business_rounded,
    keywords: ['pharmacy', 'name', 'currency', 'باسم', 'عملة'],
  ),
  const SettingsTab(
    id: 'tax',
    label: AdminStrings.settingsTabTax,
    icon: Icons.percent_rounded,
    keywords: ['tax', 'vat', 'ضريبة', 'قيمة مضافة'],
  ),
  const SettingsTab(
    id: 'items',
    label: AdminStrings.settingsTabItem,
    icon: Icons.inventory_2_rounded,
    keywords: ['item', 'product', 'صلاحية', 'مخزون', 'وحدة'],
  ),
  const SettingsTab(
    id: 'sales',
    label: AdminStrings.settingsTabSale,
    icon: Icons.shopping_cart_rounded,
    keywords: ['sale', 'خصم', 'تقسيط', 'credit'],
  ),
  const SettingsTab(
    id: 'system',
    label: AdminStrings.settingsTabSystem,
    icon: Icons.settings_rounded,
    keywords: ['language', 'audit', 'backup', 'offline', 'جلسة'],
  ),
  const SettingsTab(
    id: 'email',
    label: AdminStrings.settingsTabEmail,
    icon: Icons.mail_rounded,
    keywords: ['email', 'smtp', 'mail', 'بريد'],
  ),
  const SettingsTab(
    id: 'sms',
    label: AdminStrings.settingsTabSms,
    icon: Icons.sms_rounded,
    keywords: ['sms', 'message', 'رسالة', 'جوال'],
  ),
  const SettingsTab(
    id: 'rewards',
    label: AdminStrings.settingsTabRewards,
    icon: Icons.card_giftcard_rounded,
    keywords: ['reward', 'points', 'loyalty', 'ولاء', 'نقاط'],
  ),
  const SettingsTab(
    id: 'shortcuts',
    label: AdminStrings.settingsTabShortcuts,
    icon: Icons.keyboard_rounded,
    keywords: ['shortcut', 'prefix', 'اختصار', 'كود'],
  ),
  const SettingsTab(
    id: 'extraUnits',
    label: AdminStrings.settingsTabExtraUnits,
    icon: Icons.extension_rounded,
    keywords: ['extra', 'module', 'وحدة', 'إضافي'],
  ),
  const SettingsTab(
    id: 'invoiceLayout',
    label: AdminStrings.settingsTabInvoiceLayout,
    icon: Icons.receipt_long_rounded,
    keywords: ['invoice', 'receipt', 'print', 'layout', 'فاتورة', 'طباعة', 'تنسيق'],
  ),
];


