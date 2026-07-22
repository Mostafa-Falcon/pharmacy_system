import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;

import 'package:drift/drift.dart';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:pharmacy_system/app/core/constants/strings/excel_strings.dart';
import 'package:pharmacy_system/app/core/data/services/sync/sync_service.dart';
import 'package:pharmacy_system/app/modules/accounting/models/expense_model.dart';
import 'package:pharmacy_system/app/modules/inventory/models/import_step_info.dart';
import 'package:uuid/uuid.dart';

import 'package:pharmacy_system/app/core/injection.dart';
import 'package:pharmacy_system/app/core/utils/app_utils.dart';
import 'package:pharmacy_system/app/core/data/database/daos/customer_ledgers_dao.dart';
import 'package:pharmacy_system/app/core/data/database/daos/expenses_dao.dart';
import 'package:pharmacy_system/app/core/data/database/daos/supplier_ledgers_dao.dart';
import 'package:pharmacy_system/app/core/data/database/daos/sync_dao.dart';
import 'package:pharmacy_system/app/core/data/database/database.dart';
import 'package:pharmacy_system/app/core/data/repositories/customers_repository.dart';
import 'package:pharmacy_system/app/core/data/repositories/suppliers_repository.dart';
import 'package:pharmacy_system/app/core/data/services/admin/branch_data_service.dart';
import 'package:pharmacy_system/app/core/data/services/auth/auth_service.dart';
import 'package:pharmacy_system/app/core/data/services/sync/sync_engine.dart';
import 'package:pharmacy_system/app/modules/contacts/models/customer_ledger_model.dart';
import 'package:pharmacy_system/app/modules/contacts/models/customer_model.dart';
import 'package:pharmacy_system/app/modules/inventory/models/medicine_model.dart';
import 'package:pharmacy_system/app/modules/inventory/models/medicine_unit_model.dart';
import 'package:pharmacy_system/app/modules/inventory/services/unit_normalizer.dart';
import 'package:pharmacy_system/app/modules/contacts/models/supplier_ledger_model.dart';
import 'package:pharmacy_system/app/modules/contacts/models/supplier_model.dart';

class ExcelImportService {
  static String? _cell(List<dynamic> row, int i) {
    if (i >= row.length) return null;
    final c = row[i];
    if (c == null) return null;

    dynamic v;
    if (c is Data) {
      v = c.value;
    } else {
      v = c;
    }
    if (v == null) return null;

    if (v is TextCellValue) {
      final str = v.value.toString().trim();
      return str.isEmpty ? null : str;
    }
    if (v is IntCellValue) {
      return v.value.toString();
    }
    if (v is DoubleCellValue) {
      final d = v.value;
      if (d.isInfinite || d.isNaN) return null;
      if (d == d.toInt()) return d.toInt().toString();
      return d.toString();
    }
    if (v is DateCellValue) {
      return '${v.year}-${v.month.toString().padLeft(2, '0')}-${v.day.toString().padLeft(2, '0')}';
    }
    if (v is double) {
      if (v.isInfinite || v.isNaN) return null;
      if (v == v.toInt()) return v.toInt().toString();
      return v.toString();
    }
    final str = v.toString().trim();
    if (str.isEmpty) return null;
    return str;
  }

  static String _normalizeBarcode(String? barcode) {
    if (barcode == null || barcode.isEmpty) return '';
    final trimmed = barcode.trim();
    if (trimmed.isEmpty) return '';
    final parsed = double.tryParse(trimmed);
    if (parsed != null && parsed == parsed.toInt()) {
      return parsed.toInt().toString();
    }
    return trimmed;
  }

  static double _parseMoney(String? text) {
    if (text == null || text.isEmpty) return 0;
    final cleaned = text
        .replaceAll(ExcelStrings.currencyEgp, '')
        .replaceAll(',', '')
        .replaceAll(RegExp(r'[^\d.]'), '') // Remove non-numeric characters
        .trim();
    return double.tryParse(cleaned) ?? 0;
  }

  static DateTime? _parseDate(String? text) {
    if (text == null || text.isEmpty) return null;
    final cleaned = text.trim();
    try {
      return DateTime.parse(cleaned);
    } catch (_) {
      try {
        final parts = cleaned.split(RegExp(r'[-/ ]'));
        if (parts.length >= 3) {
          int day = int.parse(parts[0]);
          int month = int.parse(parts[1]);
          int year = int.parse(parts[2].substring(0, 4));
          int hour = 0, minute = 0;
          if (cleaned.toLowerCase().contains('pm') && parts.length >= 4) {
            hour = (int.tryParse(parts[3].split(':')[0]) ?? 0) + 12;
          }
          return DateTime(year, month, day, hour, minute);
        }
      } catch (_) {}
    }
    return null;
  }

  static int _parseSmartQuantity(String text, UnitParsedInfo? unit) {
    // تنظيف النص من أي فواصل أو مسافات (زي 1,500)
    final cleaned = text.replaceAll(',', '').replaceAll(' ', '').trim();
    final d = double.tryParse(cleaned) ?? 0;
    if (unit == null || unit.levels.isEmpty) return d.toInt();

    final whole = d.toInt();
    final fraction = (d - whole);

    // 1. لو مفيش كسر، نضرب في معامل التحويل الكلي للمستوى الأول
    if (fraction.abs() < 0.0001) {
      return whole * unit.piecesPerUnit;
    }

    // 2. لو فيه كسر، نطبق قاعدة التوزيع (المستوى الأول . المستوى الثاني)
    // مثال: 10.1 تعني 10 علب و 1 شريط
    // أو 10.1 تعني 10 شرائط و 1 حبة (لو الوحدة بدأت بشريط)
    
    // نجيب عدد القطع الكلي في الوحدة الكبيرة
    final piecesInMain = unit.piecesPerUnit;
    
    // نجيب عدد القطع الكلي في الوحدة الوسيطة (لو موجودة) أو الصغرى
    final piecesInSub = unit.levels.length > 1 ? unit.piecesPerSubUnit : 1;
    
    // استخراج رقم الكسر كعدد صحيح (10.1 -> 1, 10.05 -> 5)
    final fractionStr = cleaned.split('.').last;
    final subCount = int.tryParse(fractionStr) ?? 0;

    return (whole * piecesInMain) + (subCount * piecesInSub);
  }

  static _CustomerImportColumns _resolveCustomerColumnIndexes(
    List<dynamic> headerRow,
  ) {
    final names = headerRow.map((c) {
      if (c is Data) return (c.value?.toString() ?? '').toLowerCase();
      return c?.toString().toLowerCase() ?? '';
    }).toList();

    int idx(List<String> keys) {
      for (final k in keys) {
        final i = names.indexWhere((n) => n.contains(k.toLowerCase()));
        if (i >= 0) return i;
      }
      return -1;
    }

    return _CustomerImportColumns(
      name: idx(ExcelStrings.colName),
      contactId: idx(ExcelStrings.colContactId),
      phone: idx(ExcelStrings.colPhone),
      email: idx(ExcelStrings.colEmail),
      address: idx(ExcelStrings.colAddress),
      company: idx(ExcelStrings.colCompany),
      taxId: idx(ExcelStrings.colTaxId),
      creditLimit: idx(ExcelStrings.colCreditLimit),
      discount: idx(ExcelStrings.colDiscount),
      kind: idx(ExcelStrings.colType),
      totalDue: idx(ExcelStrings.colTotalDue),
    );
  }

  static _SupplierImportColumns _resolveSupplierColumnIndexes(
    List<dynamic> headerRow,
  ) {
    final names = headerRow.map((c) {
      if (c is Data) return (c.value?.toString() ?? '').toLowerCase();
      return c?.toString().toLowerCase() ?? '';
    }).toList();

    int idx(List<String> keys) {
      for (final k in keys) {
        final i = names.indexWhere((n) => n.contains(k.toLowerCase()));
        if (i >= 0) return i;
      }
      return -1;
    }

    return _SupplierImportColumns(
      name: idx(ExcelStrings.colName),
      contactId: idx(ExcelStrings.colContactId),
      phone: idx(ExcelStrings.colPhone),
      email: idx(ExcelStrings.colEmail),
      address: idx(ExcelStrings.colAddress),
      company: idx(ExcelStrings.colCompany),
      taxId: idx(ExcelStrings.colTaxId),
      openingBalance: idx(ExcelStrings.colOpeningBalance),
    );
  }

  static List<List<dynamic>> decodeExcelRows(Uint8List bytes) {
    try {
      final excel = Excel.decodeBytes(bytes);
      for (final table in excel.tables.values) {
        if (table.rows.isNotEmpty) return table.rows;
      }
    } catch (e) {
      safeDebugPrint('Excel decode failed: $e');
    }
    return [];
  }

  static Future<int> importFromExcel(
    String? filePath, {
    Uint8List? fileBytes,
    Function(double)? onProgress,
    Function(ImportStepInfo)? onStep,
  }) async {
    final branchId = AuthService.currentBranchId;
    if (branchId == null) throw Exception('No branch ID');

    final Uint8List bytes;
    if (fileBytes != null) {
      bytes = fileBytes;
    } else if (filePath != null && !kIsWeb) {
      bytes = await io.File(filePath).readAsBytes();
    } else {
      throw Exception(
        'File path is not supported on Web, please provide fileBytes.',
      );
    }
    final rows = decodeExcelRows(bytes);
    if (rows.isEmpty) return 0;

    // كشف العنوان الأولي للجدول
    int headerIndex = -1;
    for (int i = 0; i < rows.length && i < 20; i++) {
      final rowStr = rows[i].map((e) => e?.toString() ?? '').join(' ').toLowerCase();
      // تأكيد إن ده سطر العناوين بوجود كلمتين مفتاحيتين على الأقل
      bool hasName = rowStr.contains('اسم') || rowStr.contains('name');
      bool hasStock = rowStr.contains('كمية') || rowStr.contains('qty') || rowStr.contains('رصيد');
      bool hasPrice = rowStr.contains('سعر') || rowStr.contains('price') || rowStr.contains('selling');
      
      if ((hasName && hasStock) || (hasName && hasPrice)) {
        headerIndex = i;
        break;
      }
    }
    
    if (headerIndex == -1) headerIndex = 0;

    // تحليل العنوان لمعرفة الأعمدة
    final headerRow = rows[headerIndex]
        .map((c) {
          if (c is Data) return (c.value?.toString() ?? '').toLowerCase();
          return c?.toString().toLowerCase() ?? '';
        })
        .toList();

    int col(List<String> keys) {
      // 1. أولوية التطابق التام (Exact Match)
      for (final k in keys) {
        final i = headerRow.indexWhere((n) => n.trim().toLowerCase() == k.toLowerCase());
        if (i >= 0) return i;
      }
      // 2. تطابق جزئي (Contains)
      for (final k in keys) {
        final i = headerRow.indexWhere((n) => n.toLowerCase().contains(k.toLowerCase()));
        if (i >= 0) return i;
      }
      return -1;
    }

    final colName = col(ExcelStrings.colName);
    final colBarcode = col(ExcelStrings.colMedicineBarcode);
    final colUnit = col(ExcelStrings.colMedicineUnit);
    final colCategory = col(ExcelStrings.colMedicineCategory);
    final colBuyPrice = col(ExcelStrings.colMedicineBuyPrice);
    final colSellPrice = col(ExcelStrings.colMedicineSellPrice);
    final colStock = col(ExcelStrings.colMedicineStock);
    final colBrand = col(ExcelStrings.colMedicineBrand);
    final colRack = col(ExcelStrings.colMedicineRack);
    final colRow = col(ExcelStrings.colMedicineRow);
    final colPos = col(ExcelStrings.colMedicinePosition);
    final colExpiry = col(ExcelStrings.colMedicineExpiry);
    final colVat = col(ExcelStrings.colMedicineVat);

    if (colName < 0) return 0;

    onStep?.call(ImportStepInfo(step: 'reading', itemsFound: rows.length - headerIndex - 1));

    final medicines = <MedicineModel>[];
    int skipped = 0;
    
    final totalRowsToProcess = rows.length - (headerIndex + 1);
    
    onStep?.call(ImportStepInfo(step: 'parsing', itemsFound: totalRowsToProcess));
    
    for (var i = headerIndex + 1; i < rows.length; i++) {
      final row = rows[i];
      final name = _cell(row, colName);
      if (name == null || name.isEmpty) { skipped++; continue; }

      final rawBarcode = colBarcode >= 0 ? _cell(row, colBarcode) : null;
      final cleanBarcode = _normalizeBarcode(rawBarcode);

      final rawUnit = colUnit >= 0 ? _cell(row, colUnit) : null;
      final parsedUnit = rawUnit != null ? UnitNormalizer.parse(rawUnit) : null;

      final rawStock = colStock >= 0 ? _cell(row, colStock) : null;
      
      // ذكاء مهندسة: معالجة الكمية الذكية (10.1 تعني 10 علب و 1 شريط)
      int quantityInPieces = 0;
      if (rawStock != null) {
        quantityInPieces = _parseSmartQuantity(rawStock, parsedUnit);
      }

      final buyPriceStr = colBuyPrice >= 0 ? _cell(row, colBuyPrice) : null;
      final buyPrice = _parseMoney(buyPriceStr);
      final sellPriceStr = colSellPrice >= 0 ? _cell(row, colSellPrice) : null;
      final sellPrice = _parseMoney(sellPriceStr);

      final manufacturer = colBrand >= 0 ? _cell(row, colBrand) : null;
      
      // دمج بيانات الموقع من أكثر من عمود
      String? location;
      final rack = colRack >= 0 ? _cell(row, colRack) : null;
      final rowIdx = colRow >= 0 ? _cell(row, colRow) : null;
      final pos = colPos >= 0 ? _cell(row, colPos) : null;
      if (rack != null || rowIdx != null || pos != null) {
        location = [
          if (rack != null) 'Rack: $rack',
          if (rowIdx != null) 'Row: $rowIdx',
          if (pos != null) 'Pos: $pos',
        ].join(' • ');
      }

      final expiryStr = colExpiry >= 0 ? _cell(row, colExpiry) : null;
      final expiryDate = _parseDate(expiryStr);

      final vatStr = colVat >= 0 ? _cell(row, colVat) : null;
      final isTaxable = vatStr?.toLowerCase().contains('yes') ?? vatStr?.toLowerCase().contains('inclusive') ?? false;

      final id = const Uuid().v4();
      final units = <MedicineUnitModel>[];
      
      if (parsedUnit != null) {
        // توزيع الأسعار على الوحدات
        final mainUnit = parsedUnit.toMainUnit(id).copyWith(
          buyPrice: buyPrice,
          sellPrice: sellPrice > 0 ? sellPrice : buyPrice,
        );
        units.add(mainUnit);
        
        final sub = parsedUnit.toSubUnit(id);
        if (sub != null) {
          // سعر الشريط = سعر العلبة / (عدد الشرائط في العلبة)
          // هنا بنفترض إن piecesPerUnit هي العدد الكلي للحبات، و piecesPerSubUnit هي الحبات في الشريط
          final subFactor = parsedUnit.piecesPerUnit / parsedUnit.piecesPerSubUnit;
          units.add(sub.copyWith(
            buyPrice: buyPrice / subFactor,
            sellPrice: (sellPrice > 0 ? sellPrice : buyPrice) / subFactor,
          ));
        }
        
        final base = parsedUnit.baseUnit(id);
        units.add(base.copyWith(
          buyPrice: buyPrice / parsedUnit.piecesPerUnit,
          sellPrice: (sellPrice > 0 ? sellPrice : buyPrice) / parsedUnit.piecesPerUnit,
        ));
      } else {
        units.add(MedicineUnitModel.createMain(medicineId: id).copyWith(
          buyPrice: buyPrice,
          sellPrice: sellPrice > 0 ? sellPrice : buyPrice,
        ));
      }

      medicines.add(
        MedicineModel(
          id: id,
          name: name,
          branchId: branchId,
          barcodes: cleanBarcode.isNotEmpty ? [cleanBarcode] : [],
          category: colCategory >= 0 ? _cell(row, colCategory) : null,
          buyPrice: buyPrice,
          sellPrice: sellPrice > 0 ? sellPrice : buyPrice,
          quantity: quantityInPieces,
          units: units,
          manufacturer: manufacturer,
          location: location,
          expiryDate: expiryDate,
          isTaxable: isTaxable,
          lastModified: DateTime.now(),
        ),
      );
      
      if (i % 50 == 0 || i == rows.length - 1) {
        onStep?.call(ImportStepInfo(
          step: 'parsing',
          itemsFound: totalRowsToProcess,
          itemsParsed: medicines.length + skipped,
          itemsSkipped: skipped,
        ));
      }
    }

    if (medicines.isNotEmpty) {
      onStep?.call(ImportStepInfo(
        step: 'saving',
        itemsFound: totalRowsToProcess,
        itemsParsed: medicines.length + skipped,
        itemsSaved: 0,
        itemsSkipped: skipped,
      ));

      await BranchDataService.batchAddMedicines(medicines, skipSync: true);

      final syncDao = sl<SyncDao>();
      for (var i = 0; i < medicines.length; i++) {
        final m = medicines[i];
        await syncDao.enqueue(
          operation: SyncOperationType.create.name,
          tableName: 'medicines',
          recordId: m.id,
          data: json.encode(m.toJson()),
          branchId: branchId,
        );
        
        if (i % 50 == 0 || i == medicines.length - 1) {
          onStep?.call(ImportStepInfo(
            step: 'saving',
            itemsFound: totalRowsToProcess,
            itemsParsed: medicines.length + skipped,
            itemsSaved: i + 1,
            itemsSkipped: skipped,
          ));
        }
      }
      await sl<SyncEngine>().updatePendingCount();
      onProgress?.call(1.0);
    }

    if (SyncService.isOnline) {
      unawaited(SyncService.syncAll());
    }
    return medicines.length;
  }

  static Future<int> importCustomersFromExcel(
    String? filePath, {
    Uint8List? fileBytes,
    Function(double)? onProgress,
    Function(ImportStepInfo)? onStep,
  }) async {
    final branchId = AuthService.currentBranchId;
    if (branchId == null) throw Exception('No branch ID');

    final Uint8List bytes;
    if (fileBytes != null) {
      bytes = fileBytes;
    } else if (filePath != null && !kIsWeb) {
      bytes = await io.File(filePath).readAsBytes();
    } else {
      throw Exception('File path is not supported on Web');
    }
    final rows = decodeExcelRows(bytes);
    if (rows.isEmpty) return 0;

    int headerIndex = -1;
    for (int i = 0; i < rows.length && i < 20; i++) {
      final row = rows[i];
      final rowStr = row
          .map((e) {
            if (e is Data) return e.value?.toString().toLowerCase() ?? '';
            return e?.toString().toLowerCase() ?? '';
          })
          .join(' ');

      if (rowStr.contains('الاسم') ||
          rowStr.contains('name') ||
          rowStr.contains('الإسم') ||
          rowStr.contains('المستحق')) {
        headerIndex = i;
        break;
      }
    }

    if (headerIndex == -1) {
      safeDebugPrint('ExcelImport: Header row not found in first 20 rows');
      return 0;
    }

    final col = _resolveCustomerColumnIndexes(rows[headerIndex]);
    final customers = <CustomerModel>[];
    final ledgerEntries = <CustomerLedgerModel>[];

    for (var i = headerIndex + 1; i < rows.length; i++) {
      final row = rows[i];
      final name = _cell(row, col.name);
      if (name == null || name.isEmpty || name.contains(ExcelStrings.totalRowKey)) continue;

      final customer = CustomerModel(
        id: const Uuid().v4(),
        name: name,
        phone: _cell(row, col.phone),
        companyName: _cell(row, col.company),
        address: _cell(row, col.address),
      );
      customers.add(customer);

      // نتحقق من "إجمالي المستحق" أولاً ثم "الرصيد الافتتاحي"
      double openBal = 0;
      if (col.totalDue != -1) {
        openBal = _parseMoney(_cell(row, col.totalDue));
      } else {
        // البحث عن عمود الرصيد الافتتاحي لو ملقاش "اجمالي المستحق"
        final opIdx = rows[headerIndex].indexWhere(
          (c) => (c?.toString() ?? '').contains('افتتاحي'),
        );
        if (opIdx != -1) openBal = _parseMoney(_cell(row, opIdx));
      }

      if (openBal > 0) {
        ledgerEntries.add(
          CustomerLedgerModel(
            id: const Uuid().v4(),
            customerId: customer.id,
            branchId: branchId,
            type: CustomerLedgerEntryType.openingBalance,
            debit: openBal,
            credit: 0,
            balanceAfter: openBal,
            entryDate: DateTime.now(),
          ),
        );
      }
    }

    if (customers.isNotEmpty) {
      // ذكاء مهندسة: نستخدم Repository بـ skipSync
      await sl<CustomersRepository>().batchCreate(customers, skipSync: true);

      final syncDao = GetIt.instance<SyncDao>();

      for (var c in customers) {
        await syncDao.enqueue(
          operation: SyncOperationType.create.name,
          tableName: 'customers',
          recordId: c.id,
          data: json.encode(c.toJson()),
          branchId: branchId,
        );
      }

      if (ledgerEntries.isNotEmpty) {
        final dao = sl<CustomerLedgersDao>();
        for (var e in ledgerEntries) {
          final companion = _customerLedgerToCompanion(e);
          await dao.upsert(companion);
          await syncDao.enqueue(
            operation: SyncOperationType.create.name,
            tableName: 'customer_ledgers',
            recordId: e.id,
            data: json.encode({
              'id': e.id,
              'customer_id': e.customerId,
              'branch_id': branchId,
              'type': e.type.name,
              'debit': e.debit,
              'credit': e.credit,
              'balance_after': e.balanceAfter,
              'entry_date': e.entryDate.toIso8601String(),
            }),
            branchId: branchId,
          );
        }
      }
      await sl<SyncEngine>().updatePendingCount();
    }
    if (SyncService.isOnline) unawaited(SyncService.syncAll());
    return customers.length;
  }

  static Future<int> importSuppliersFromExcel(
    String? filePath, {
    Uint8List? fileBytes,
    Function(double)? onProgress,
    Function(ImportStepInfo)? onStep,
  }) async {
    final branchId = AuthService.currentBranchId;
    if (branchId == null) throw Exception('No branch ID');

    final Uint8List bytes;
    if (fileBytes != null) {
      bytes = fileBytes;
    } else if (filePath != null && !kIsWeb) {
      bytes = await io.File(filePath).readAsBytes();
    } else {
      throw Exception('File path is not supported on Web');
    }
    final rows = decodeExcelRows(bytes);
    if (rows.isEmpty) return 0;

    int headerIndex = -1;
    for (int i = 0; i < rows.length && i < 20; i++) {
      final row = rows[i];
      final rowStr = row
          .map((e) {
            if (e is Data) return e.value?.toString().toLowerCase() ?? '';
            return e?.toString().toLowerCase() ?? '';
          })
          .join(' ');

      if (rowStr.contains('الإسم') ||
          rowStr.contains('اسم المورد') ||
          rowStr.contains('name') ||
          rowStr.contains('المورد')) {
        headerIndex = i;
        break;
      }
    }

    if (headerIndex == -1) {
      safeDebugPrint('ExcelImport: Header row not found for suppliers');
      return 0;
    }

    final col = _resolveSupplierColumnIndexes(rows[headerIndex]);
    final suppliers = <SupplierModel>[];
    final ledgerEntries = <SupplierLedgerModel>[];

    for (var i = headerIndex + 1; i < rows.length; i++) {
      final row = rows[i];
      final name = _cell(row, col.name);
      if (name == null || name.isEmpty || name.contains(ExcelStrings.totalRowKey)) continue;

      final supplier = SupplierModel(
        id: const Uuid().v4(),
        name: name,
        phone: _cell(row, col.phone),
        companyName: _cell(row, col.company),
        address: _cell(row, col.address),
      );
      suppliers.add(supplier);

      final openBal = _parseMoney(_cell(row, col.openingBalance));
      if (openBal > 0) {
        ledgerEntries.add(
          SupplierLedgerModel(
            id: const Uuid().v4(),
            supplierId: supplier.id,
            branchId: branchId,
            type: SupplierLedgerEntryType.openingBalance,
            debit: openBal,
            credit: 0,
            balanceAfter: openBal,
            entryDate: DateTime.now(),
          ),
        );
      }
    }

    if (suppliers.isNotEmpty) {
      await sl<SuppliersRepository>().batchCreate(suppliers, skipSync: true);

      final syncDao = GetIt.instance<SyncDao>();
      for (var s in suppliers) {
        await syncDao.enqueue(
          operation: SyncOperationType.create.name,
          tableName: 'suppliers',
          recordId: s.id,
          data: json.encode(s.toJson()),
          branchId: branchId,
        );
      }

      if (ledgerEntries.isNotEmpty) {
        final dao = sl<SupplierLedgersDao>();
        for (var e in ledgerEntries) {
          final companion = _supplierLedgerToCompanion(e);
          await dao.upsert(companion);
          await syncDao.enqueue(
            operation: SyncOperationType.create.name,
            tableName: 'supplier_ledgers',
            recordId: e.id,
            data: json.encode({
              'id': e.id,
              'supplier_id': e.supplierId,
              'branch_id': branchId,
              'type': e.type.name,
              'debit': e.debit,
              'credit': e.credit,
              'balance_after': e.balanceAfter,
              'entry_date': e.entryDate.toIso8601String(),
            }),
            branchId: branchId,
          );
        }
      }
      await sl<SyncEngine>().updatePendingCount();
    }
    if (SyncService.isOnline) unawaited(SyncService.syncAll());
    return suppliers.length;
  }

  static Future<int> importExpensesFromExcel(
    String? filePath, {
    Uint8List? fileBytes,
    Function(double)? onProgress,
    Function(ImportStepInfo)? onStep,
  }) async {
    final branchId = AuthService.currentBranchId;
    if (branchId == null) throw Exception('No branch ID');

    final Uint8List bytes;
    if (fileBytes != null) {
      bytes = fileBytes;
    } else if (filePath != null && !kIsWeb) {
      bytes = await io.File(filePath).readAsBytes();
    } else {
      throw Exception('File path is not supported on Web');
    }
    final rows = decodeExcelRows(bytes);
    if (rows.length < 2) return 0;

    int headerIndex = 0;
    for (int i = 0; i < rows.length; i++) {
      final rowStr = rows[i].map((e) => e?.toString() ?? '').join(' ');
      if (rowStr.contains('تاريخ') ||
          rowStr.contains('مصروف') ||
          rowStr.contains('المبلغ')) {
        headerIndex = i;
        break;
      }
    }

    int count = 0;
    final expensesDao = sl<ExpensesDao>();
    for (var i = headerIndex + 1; i < rows.length; i++) {
      final row = rows[i];
      final category = _cell(row, 3);
      final amount = _parseMoney(_cell(row, 6));
      if (category == null || amount <= 0 || category.contains(ExcelStrings.totalRowKey)) {
        continue;
      }

      final id = const Uuid().v4();
      final expense = ExpenseModel(
        id: id,
        branchId: branchId,
        expenseNumber: i,
        expenseDate: _parseDate(_cell(row, 1)) ?? DateTime.now(),
        category: category,
        amount: amount,
        description: _cell(row, 10) ?? category,
        paymentMethod: 'cash',
        createdById: AuthService.currentUser?.id ?? '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      final companion = _expenseToCompanion(expense);
      await expensesDao.upsert(companion);
      await SyncService.queueOperation(
        type: SyncOperationType.create,
        table: 'expenses',
        data: expense.toJson(),
        branchId: branchId,
      );
      count++;
    }
    if (SyncService.isOnline) unawaited(SyncService.syncAll());
    return count;
  }

  static Future<int> importSalesFromExcel(
    String? filePath, {
    Uint8List? fileBytes,
    Function(double)? onProgress,
    Function(ImportStepInfo)? onStep,
  }) async {
    return 0; // Not implemented yet based on provided files
  }

  static Future<int> importProductsFromExcel(
    String? filePath, {
    Uint8List? fileBytes,
    Function(double)? onProgress,
    Function(ImportStepInfo)? onStep,
  }) async {
    return importFromExcel(
      filePath,
      fileBytes: fileBytes,
      onProgress: onProgress,
      onStep: onStep,
    );
  }
}

class _CustomerImportColumns {
  final int name,
      contactId,
      phone,
      email,
      address,
      company,
      taxId,
      creditLimit,
      discount,
      kind,
      totalDue;
  const _CustomerImportColumns({
    this.name = -1,
    this.contactId = -1,
    this.phone = -1,
    this.email = -1,
    this.address = -1,
    this.company = -1,
    this.taxId = -1,
    this.creditLimit = -1,
    this.discount = -1,
    this.kind = -1,
    this.totalDue = -1,
  });
}

class _SupplierImportColumns {
  final int name,
      contactId,
      phone,
      email,
      address,
      company,
      taxId,
      openingBalance;
  const _SupplierImportColumns({
    this.name = -1,
    this.contactId = -1,
    this.phone = -1,
    this.email = -1,
    this.address = -1,
    this.company = -1,
    this.taxId = -1,
    this.openingBalance = -1,
  });
}

// ─── Converters ──────────────────────────────────────────────────

CustomerLedgersTableCompanion _customerLedgerToCompanion(
  CustomerLedgerModel m,
) {
  return CustomerLedgersTableCompanion(
    id: Value(m.id),
    customerId: Value(m.customerId),
    branchId: Value(m.branchId),
    type: Value(m.type.name),
    debit: Value(m.debit),
    credit: Value(m.credit),
    balanceAfter: Value(m.balanceAfter),
    entryDate: Value(m.entryDate),
    isDeleted: const Value(false),
    lastModified: Value(DateTime.now()),
    syncVersion: const Value(1),
  );
}

SupplierLedgersTableCompanion _supplierLedgerToCompanion(
  SupplierLedgerModel m,
) {
  return SupplierLedgersTableCompanion(
    id: Value(m.id),
    supplierId: Value(m.supplierId),
    branchId: Value(m.branchId),
    type: Value(m.type.name),
    debit: Value(m.debit),
    credit: Value(m.credit),
    balanceAfter: Value(m.balanceAfter),
    entryDate: Value(m.entryDate),
    isDeleted: const Value(false),
    lastModified: Value(DateTime.now()),
    syncVersion: const Value(1),
  );
}

ExpensesTableCompanion _expenseToCompanion(ExpenseModel m) {
  return ExpensesTableCompanion(
    id: Value(m.id),
    branchId: Value(m.branchId),
    expenseNumber: Value(m.expenseNumber),
    expenseDate: Value(m.expenseDate),
    category: Value(m.category),
    description: Value(m.description),
    amount: Value(m.amount),
    paymentMethod: Value(m.paymentMethod),
    createdById: Value(m.createdById),
    createdByName: Value(m.createdByName),
    notes: Value(m.notes),
    createdAt: Value(m.createdAt),
    updatedAt: Value(m.updatedAt),
    isDeleted: const Value(false),
  );
}

