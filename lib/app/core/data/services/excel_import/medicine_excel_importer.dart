import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;

import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';
import 'package:pharmacy_system/app/core/data/database/daos/sync_dao.dart';
import 'package:pharmacy_system/app/core/data/services/admin/branch_data_service.dart';
import 'package:pharmacy_system/app/core/data/services/auth/auth_service.dart';

import 'package:pharmacy_system/app/core/injection.dart';
import 'package:pharmacy_system/app/core/models/inventory/import_step_info.dart';
import 'package:pharmacy_system/app/core/models/inventory/medicine_model.dart';
import 'package:pharmacy_system/app/core/sync/sync_engine.dart';
import 'package:pharmacy_system/app/core/sync/sync_service.dart';
import 'package:pharmacy_system/app/modules/inventory/services/unit_normalizer.dart';
import 'package:pharmacy_system/app/shared/constants/strings/excel_strings.dart';
import 'package:uuid/uuid.dart';

import 'excel_import_helper.dart';

/// خدمة استيراد الأدوية والأصناف المخزنية من أكسيل
abstract class MedicineExcelImporter {
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
    final rows = ExcelImportHelper.decodeExcelRows(bytes);
    if (rows.isEmpty) return 0;

    int headerIndex = -1;
    for (int i = 0; i < rows.length && i < 20; i++) {
      final rowStr = rows[i]
          .map((e) => e?.toString() ?? '')
          .join(' ')
          .toLowerCase();
      bool hasName = rowStr.contains('اسم') || rowStr.contains('name');
      bool hasStock =
          rowStr.contains('كمية') ||
          rowStr.contains('qty') ||
          rowStr.contains('رصيد');
      bool hasPrice =
          rowStr.contains('سعر') ||
          rowStr.contains('price') ||
          rowStr.contains('selling');

      if ((hasName && hasStock) || (hasName && hasPrice)) {
        headerIndex = i;
        break;
      }
    }

    if (headerIndex == -1) headerIndex = 0;

    final headerRow = rows[headerIndex].map((c) {
      if (c is Data) return (c.value?.toString() ?? '').toLowerCase();
      return c?.toString().toLowerCase() ?? '';
    }).toList();

    int col(List<String> keys) {
      for (final k in keys) {
        final i = headerRow.indexWhere(
          (n) => n.trim().toLowerCase() == k.toLowerCase(),
        );
        if (i >= 0) return i;
      }
      for (final k in keys) {
        final i = headerRow.indexWhere(
          (n) => n.toLowerCase().contains(k.toLowerCase()),
        );
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

    onStep?.call(
      ImportStepInfo(
        step: 'reading',
        itemsFound: rows.length - headerIndex - 1,
      ),
    );

    final medicines = <MedicineModel>[];
    int skipped = 0;

    final totalRowsToProcess = rows.length - (headerIndex + 1);

    onStep?.call(
      ImportStepInfo(step: 'parsing', itemsFound: totalRowsToProcess),
    );

    for (var i = headerIndex + 1; i < rows.length; i++) {
      final row = rows[i];
      final name = ExcelImportHelper.cell(row, colName);
      if (name == null || name.isEmpty) {
        skipped++;
        continue;
      }

      final rawBarcode = colBarcode >= 0 ? ExcelImportHelper.cell(row, colBarcode) : null;
      final cleanBarcode = ExcelImportHelper.normalizeBarcode(rawBarcode);

      final rawUnit = colUnit >= 0 ? ExcelImportHelper.cell(row, colUnit) : null;
      final parsedUnit = rawUnit != null ? UnitNormalizer.parse(rawUnit) : null;

      final rawStock = colStock >= 0 ? ExcelImportHelper.cell(row, colStock) : null;

      int quantityInPieces = 0;
      if (rawStock != null) {
        quantityInPieces = ExcelImportHelper.parseSmartQuantity(rawStock, parsedUnit);
      }

      final buyPriceStr = colBuyPrice >= 0 ? ExcelImportHelper.cell(row, colBuyPrice) : null;
      final buyPrice = ExcelImportHelper.parseMoney(buyPriceStr);
      final sellPriceStr = colSellPrice >= 0 ? ExcelImportHelper.cell(row, colSellPrice) : null;
      final sellPrice = ExcelImportHelper.parseMoney(sellPriceStr);

      final manufacturer = colBrand >= 0 ? ExcelImportHelper.cell(row, colBrand) : null;

      String? location;
      final rack = colRack >= 0 ? ExcelImportHelper.cell(row, colRack) : null;
      final rowIdx = colRow >= 0 ? ExcelImportHelper.cell(row, colRow) : null;
      final pos = colPos >= 0 ? ExcelImportHelper.cell(row, colPos) : null;
      if (rack != null || rowIdx != null || pos != null) {
        location = [
          if (rack != null) 'Rack: $rack',
          if (rowIdx != null) 'Row: $rowIdx',
          if (pos != null) 'Pos: $pos',
        ].join(' • ');
      }

      final expiryStr = colExpiry >= 0 ? ExcelImportHelper.cell(row, colExpiry) : null;
      final expiryDate = ExcelImportHelper.parseDate(expiryStr);

      final vatStr = colVat >= 0 ? ExcelImportHelper.cell(row, colVat) : null;
      final isTaxable =
          vatStr?.toLowerCase().contains('yes') ??
          vatStr?.toLowerCase().contains('inclusive') ??
          false;

      final id = const Uuid().v4();

      final mainUnitName = (parsedUnit != null && parsedUnit.levels.isNotEmpty)
          ? parsedUnit.levels[0].name
          : 'علبة';
      final subUnitName = parsedUnit?.subUnitName;
      final subCount = (parsedUnit != null && parsedUnit.levels.length > 1)
          ? parsedUnit.levels[1].multiplier.toInt()
          : null;

      final itemLevels = ItemLevelsModel(
        unit1Name: mainUnitName,
        unit1Count: 1,
        unit1Quantity: quantityInPieces,
        unit1BuyPrice: buyPrice,
        unit1SellPrice: sellPrice > 0 ? sellPrice : buyPrice,
        unit2Enabled: subUnitName != null && subCount != null,
        unit2Name: subUnitName,
        unit2Count: subCount,
        unit2BuyPrice: (subCount != null && subCount > 0) ? buyPrice / subCount : null,
        unit2SellPrice: (subCount != null && subCount > 0) ? (sellPrice > 0 ? sellPrice : buyPrice) / subCount : null,
      );

      final categoryName = colCategory >= 0 ? (ExcelImportHelper.cell(row, colCategory) ?? 'عام') : 'عام';

      medicines.add(
        MedicineModel(
          id: id,
          name: name,
          branchId: branchId,
          itemTypes: [],
          therapeuticGroup: TherapeuticGroupModel(id: 'gen', name: categoryName),
          barcodes: cleanBarcode.isNotEmpty ? [BarcodeModel(code: cleanBarcode, isPrimary: true)] : [],
          manufacturer: manufacturer,
          location: location,
          expiryDates: expiryDate != null ? [expiryDate] : null,
          isTaxable: isTaxable,
          itemLevels: itemLevels,
          lastModified: DateTime.now(),
        ),
      );

      if (i % 50 == 0 || i == rows.length - 1) {
        onStep?.call(
          ImportStepInfo(
            step: 'parsing',
            itemsFound: totalRowsToProcess,
            itemsSaved: medicines.length + skipped,
            itemsSkipped: skipped,
          ),
        );
      }
    }

    if (medicines.isNotEmpty) {
      onStep?.call(
        ImportStepInfo(
          step: 'saving',
          itemsFound: totalRowsToProcess,
          itemsSaved: 0,
          itemsSkipped: skipped,
        ),
      );

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
          onStep?.call(
            ImportStepInfo(
              step: 'saving',
              itemsFound: totalRowsToProcess,
              itemsSaved: i + 1,
              itemsSkipped: skipped,
            ),
          );
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
}
