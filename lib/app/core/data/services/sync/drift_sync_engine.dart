import 'dart:async';
import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pharmacy_system/app/core/data/database/database.dart';
import 'package:pharmacy_system/app/core/data/database/daos/sync_dao.dart';
import 'package:pharmacy_system/app/core/data/database/daos/medicines_dao.dart';
import 'package:pharmacy_system/app/core/data/database/daos/customers_dao.dart';
import 'package:pharmacy_system/app/core/data/database/daos/suppliers_dao.dart';
import 'package:pharmacy_system/app/core/data/database/daos/sales_dao.dart';
import 'package:pharmacy_system/app/core/data/database/daos/purchases_dao.dart';
import 'package:pharmacy_system/app/core/utils/app_utils.dart';
import 'package:pharmacy_system/app/core/injection.dart';
import '../auth/auth_service.dart';

class DriftSyncEngine {
  static SupabaseClient get _client => Supabase.instance.client;
  static SyncDao get _syncDao => sl<SyncDao>();

  static bool _isSyncing = false;
  static final StreamController<bool> _syncController = StreamController<bool>.broadcast();
  static Stream<bool> get syncStream => _syncController.stream;

  /// دورة مزامنة كاملة: دفع ثم سحب (رايح جاي)
  static Future<void> syncAll() async {
    if (_isSyncing) return;
    _isSyncing = true;
    _syncController.add(true);

    try {
      safeDebugPrint('SyncEngine: Starting push cycle...');
      await pushAll();
      
      safeDebugPrint('SyncEngine: Starting pull cycle...');
      await pullAll();
      
      safeDebugPrint('SyncEngine: Global sync completed successfully.');
    } catch (e, s) {
      safeDebugPrint('SyncEngine: Global sync failed: $e\n$s');
    } finally {
      _isSyncing = false;
      _syncController.add(false);
    }
  }

  /// ─── دفع التعديلات المحلية للسيرفر (رايح) ───
  static Future<void> pushAll() async {
    final pending = await _syncDao.peekPending(50);
    if (pending.isEmpty) return;

    for (final item in pending) {
      try {
        final data = jsonDecode(item.data) as Map<String, dynamic>;
        
        if (item.operation == 'delete') {
          await _client.from(item.targetTable).update({
            'is_deleted': true,
            'last_modified': DateTime.now().toIso8601String(),
          }).eq('id', item.recordId);
        } else {
          // الرفع بنظام Upsert لضمان الاستقرار
          await _client.from(item.targetTable).upsert(data);
        }

        await _syncDao.markSynced(item.id);
      } catch (e) {
        safeDebugPrint('SyncEngine: Push failed for ${item.targetTable}/${item.recordId}: $e');
        await _syncDao.markFailed(item.id, e.toString());
        break; 
      }
    }
  }

  /// ─── سحب التحديثات من السيرفر (جاي) ───
  static Future<void> pullAll() async {
    final branchId = AuthService.currentBranchId;
    if (branchId == null) return;

    final tables = ['medicines', 'customers', 'suppliers', 'sales', 'purchases'];

    for (final table in tables) {
      await _pullTable(table, branchId);
    }
  }

  static Future<void> _pullTable(String tableName, String branchId) async {
    final watermarkRow = await _syncDao.getWatermark(tableName, branchId);
    final lastWatermark = watermarkRow?.lastWatermark ?? DateTime.fromMillisecondsSinceEpoch(0);

    try {
      final response = await _client
          .from(tableName)
          .select()
          .eq('branch_id', branchId)
          .gt('last_modified', lastWatermark.toIso8601String())
          .order('last_modified', ascending: true);

      // ignore: unnecessary_null_comparison
      if (response == null || (response as List).isEmpty) return;

      final records = response as List<dynamic>;
      await _applyPulledRecords(tableName, records);

      final newestAt = DateTime.parse(records.last['last_modified'] as String);
      await _syncDao.upsertWatermark(
        tableName: tableName,
        watermark: newestAt,
        branchId: branchId,
      );
      safeDebugPrint('SyncEngine: Pulled ${records.length} records for $tableName');
    } catch (e) {
      safeDebugPrint('SyncEngine: Pull failed for table $tableName: $e');
    }
  }

  static Future<void> _applyPulledRecords(String table, List<dynamic> records) async {
    for (final r in records) {
      switch (table) {
        case 'medicines':
          await sl<MedicinesDao>().upsert(_mapMedicine(r));
          break;
        case 'customers':
          await sl<CustomersDao>().upsert(_mapCustomer(r));
          break;
        case 'suppliers':
          await sl<SuppliersDao>().upsert(_mapSupplier(r));
          break;
        case 'sales':
          await sl<SalesDao>().upsert(_mapSale(r));
          break;
        case 'purchases':
          await sl<PurchasesDao>().upsert(_mapPurchase(r));
          break;
      }
    }
  }

  // ─── محولات البيانات (Mappers) ───

  static MedicinesTableCompanion _mapMedicine(Map<String, dynamic> json) {
    return MedicinesTableCompanion(
      id: Value(json['id'] as String),
      name: Value(json['name'] as String),
      nameEn: Value(json['name_en'] as String?),
      category: Value(json['category'] as String?),
      barcodes: Value(jsonEncode(json['barcodes'] ?? [])),
      buyPrice: Value((json['buy_price'] as num).toDouble()),
      sellPrice: Value((json['sell_price'] as num).toDouble()),
      quantity: Value((json['quantity'] as num).toInt()),
      minStock: Value((json['min_stock'] as num? ?? 10).toInt()),
      expiryDate: Value(json['expiry_date'] != null ? DateTime.parse(json['expiry_date'] as String) : null),
      manufacturer: Value(json['manufacturer'] as String?),
      branchId: Value(json['branch_id'] as String),
      syncVersion: Value((json['sync_version'] as num? ?? 1).toInt()),
      lastModified: Value(DateTime.parse(json['last_modified'] as String)),
      isDeleted: Value(json['is_deleted'] as bool? ?? false),
      dosageForm: Value(json['dosage_form'] as String?),
      strength: Value(json['strength'] as String?),
      packageSize: Value(json['package_size'] as String?),
      expiryTrackingEnabled: Value(json['expiry_tracking_enabled'] as bool? ?? false),
      supplierName: Value(json['supplier_name'] as String?),
      description: Value(json['description'] as String?),
      oldSellPrice: Value((json['old_sell_price'] as num?)?.toDouble()),
      itemTypeId: Value(json['item_type_id'] as String?),
      groupId: Value(json['group_id'] as String?),
      units: Value(jsonEncode(json['units'] ?? [])),
      alertEnabled: Value(json['alert_enabled'] as bool? ?? false),
      dosageFormEnabled: Value(json['dosage_form_enabled'] as bool? ?? false),
      imageUrl: Value(json['image_url'] as String?),
      containerShape: Value(json['container_shape'] as String?),
      allowNegativeStock: Value(json['allow_negative_stock'] as bool? ?? false),
      isTaxable: Value(json['is_taxable'] as bool? ?? false),
      taxType: Value(json['tax_type'] as String?),
      taxValue: Value((json['tax_value'] as num?)?.toDouble()),
      pricesIncludeTax: Value(json['prices_include_tax'] as bool? ?? false),
      location: Value(json['location'] as String?),
      isActive: Value(json['is_active'] as bool? ?? true),
      createdAt: Value(json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null),
    );
  }

  static CustomersTableCompanion _mapCustomer(Map<String, dynamic> json) {
    return CustomersTableCompanion(
      id: Value(json['id'] as String),
      name: Value(json['name'] as String),
      phone: Value(json['phone'] as String?),
      address: Value(json['address'] as String?),
      isActive: Value(json['is_active'] as bool? ?? true),
      kind: Value(json['kind'] as String? ?? 'regular'),
      companyName: Value(json['company_name'] as String?),
      email: Value(json['email'] as String?),
      taxId: Value(json['tax_id'] as String?),
      creditLimit: Value((json['credit_limit'] as num? ?? 0).toDouble()),
      discountPercent: Value((json['discount_percent'] as num? ?? 0).toDouble()),
      paymentTermDays: Value((json['payment_term_days'] as num? ?? 0).toInt()),
      notes: Value(json['notes'] as String?),
      lastModified: Value(DateTime.parse(json['last_modified'] as String)),
      isDeleted: Value(json['is_deleted'] as bool? ?? false),
      salesRepId: Value(json['sales_rep_id'] as String?),
    );
  }

  static SuppliersTableCompanion _mapSupplier(Map<String, dynamic> json) {
    return SuppliersTableCompanion(
      id: Value(json['id'] as String),
      name: Value(json['name'] as String),
      type: Value(json['type'] as String? ?? 'supplier'),
      phone: Value(json['phone'] as String?),
      address: Value(json['address'] as String?),
      isActive: Value(json['is_active'] as bool? ?? true),
      isDeleted: Value(json['is_deleted'] as bool? ?? false),
      lastModified: Value(DateTime.parse(json['last_modified'] as String)),
      partyType: Value(json['party_type'] as String? ?? 'company'),
      companyName: Value(json['company_name'] as String?),
      email: Value(json['email'] as String?),
      taxId: Value(json['tax_id'] as String?),
      creditLimit: Value((json['credit_limit'] as num? ?? 0).toDouble()),
      discountPercent: Value((json['discount_percent'] as num? ?? 0).toDouble()),
      paymentTermDays: Value((json['payment_term_days'] as num? ?? 0).toInt()),
      notes: Value(json['notes'] as String?),
    );
  }

  static SalesTableCompanion _mapSale(Map<String, dynamic> json) {
    return SalesTableCompanion(
      id: Value(json['id'] as String),
      branchId: Value(json['branch_id'] as String),
      customerId: Value(json['customer_id'] as String?),
      customerName: Value(json['customer_name'] as String?),
      items: Value(jsonEncode(json['items'])),
      totalAmount: Value((json['total_amount'] as num).toDouble()),
      discount: Value((json['discount'] as num?)?.toDouble()),
      finalAmount: Value((json['final_amount'] as num).toDouble()),
      taxAmount: Value((json['tax_amount'] as num?)?.toDouble()),
      paymentMethod: Value(json['payment_method'] as String),
      notes: Value(json['notes'] as String?),
      createdBy: Value(json['created_by'] as String),
      createdAt: Value(DateTime.parse(json['created_at'] as String)),
      syncVersion: Value((json['sync_version'] as num? ?? 1).toInt()),
      lastModified: Value(DateTime.parse(json['last_modified'] as String)),
      isDeleted: Value(json['is_deleted'] as bool? ?? false),
      paidAmount: Value((json['paid_amount'] as num?)?.toDouble()),
      receiptNumber: Value(json['receipt_number'] as String?),
      salesRepId: Value(json['sales_rep_id'] as String?),
    );
  }

  static PurchasesTableCompanion _mapPurchase(Map<String, dynamic> json) {
    return PurchasesTableCompanion(
      id: Value(json['id'] as String),
      branchId: Value(json['branch_id'] as String),
      supplierName: Value(json['supplier_name'] as String),
      supplierPhone: Value(json['supplier_phone'] as String?),
      items: Value(jsonEncode(json['items'])),
      totalAmount: Value((json['total_amount'] as num).toDouble()),
      discount: Value((json['discount'] as num?)?.toDouble()),
      tax: Value((json['tax'] as num?)?.toDouble()),
      finalAmount: Value((json['final_amount'] as num).toDouble()),
      paymentMethod: Value(json['payment_method'] as String),
      paidAmount: Value((json['paid_amount'] as num?)?.toDouble()),
      notes: Value(json['notes'] as String?),
      createdBy: Value(json['created_by'] as String),
      createdAt: Value(DateTime.parse(json['createdAt'] ?? json['created_at'] as String)),
      syncVersion: Value((json['sync_version'] as num? ?? 1).toInt()),
      lastModified: Value(DateTime.parse(json['last_modified'] as String)),
      isDeleted: Value(json['is_deleted'] as bool? ?? false),
      status: Value(json['status'] as String? ?? 'completed'),
      supplierId: Value(json['supplier_id'] as String?),
      sourceType: Value(json['source_type'] as String?),
      receiptNumber: Value(json['receipt_number'] as String?),
      shippingAmount: Value((json['shipping_amount'] as num?)?.toDouble()),
      deliveryAmount: Value((json['delivery_amount'] as num?)?.toDouble()),
      supplierPartyType: Value(json['supplier_party_type'] as String?),
      invoiceDiscountType: Value(json['invoice_discount_type'] as String?),
      invoiceDiscountValue: Value((json['invoice_discount_value'] as num?)?.toDouble()),
      invoiceDiscountAmount: Value((json['invoice_discount_amount'] as num?)?.toDouble()),
      invoiceTaxType: Value(json['invoice_tax_type'] as String?),
      invoiceTaxValue: Value((json['invoice_tax_value'] as num?)?.toDouble()),
      invoiceTaxAmount: Value((json['invoice_tax_amount'] as num?)?.toDouble()),
      paymentAccountId: Value(json['payment_account_id'] as String?),
      paymentAccountName: Value(json['payment_account_name'] as String?),
    );
  }
}
