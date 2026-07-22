// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'inventory_enums.dart';

part 'stock_adjustment_model.freezed.dart';
part 'stock_adjustment_model.g.dart';

AdjustmentType _adjustmentTypeFromJson(Object? json) {
  final value = json as String? ?? '';
  return AdjustmentType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => AdjustmentType.addition);
}

String _adjustmentTypeToJson(AdjustmentType type) => type.name;

AdjustmentReason _adjustmentReasonFromJson(Object? json) {
  final value = json as String? ?? '';
  return AdjustmentReason.values.firstWhere(
      (e) => e.name == value,
      orElse: () => AdjustmentReason.other);
}

String _adjustmentReasonToJson(AdjustmentReason reason) => reason.name;

@freezed
abstract class StockAdjustmentModel with _$StockAdjustmentModel {
  const StockAdjustmentModel._();

  const factory StockAdjustmentModel({
    required String id,
    @JsonKey(name: 'pharmacy_id') required String pharmacyId,
    @JsonKey(name: 'branch_id') required String branchId,
    @JsonKey(name: 'adjustment_number') required String adjustmentNumber,
    @JsonKey(name: 'adjustment_date') required DateTime adjustmentDate,
    @Default([]) List<StockAdjustmentItemModel> items,
    @JsonKey(name: 'created_by_id') String? createdById,
    @JsonKey(name: 'created_by_name') String? createdByName,
    String? notes,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _StockAdjustmentModel;

  factory StockAdjustmentModel.fromJson(Map<String, dynamic> json) =>
      _$StockAdjustmentModelFromJson(json);
}

@freezed
abstract class StockAdjustmentItemModel with _$StockAdjustmentItemModel {
  const StockAdjustmentItemModel._();

  const factory StockAdjustmentItemModel({
    required String id,
    @JsonKey(name: 'item_id') required String itemId,
    @JsonKey(name: 'item_name') String? itemName,
    String? barcode,
    @JsonKey(name: 'unit_id') String? unitId,
    @JsonKey(name: 'unit_name') String? unitName,
    @JsonKey(name: 'batch_id') String? batchId,
    @JsonKey(name: 'batch_number') String? batchNumber,
    @JsonKey(fromJson: _adjustmentTypeFromJson, toJson: _adjustmentTypeToJson)
    required AdjustmentType type,
    @JsonKey(fromJson: _adjustmentReasonFromJson, toJson: _adjustmentReasonToJson)
    required AdjustmentReason reason,
    required double quantity,
    @JsonKey(name: 'unit_cost') double? unitCost,
  }) = _StockAdjustmentItemModel;

  factory StockAdjustmentItemModel.fromJson(Map<String, dynamic> json) =>
      _$StockAdjustmentItemModelFromJson(json);
}
