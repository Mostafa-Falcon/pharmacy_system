// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'stock_movement_model.freezed.dart';
part 'stock_movement_model.g.dart';

enum MovementType {
  opening,
  sale,
  salesReturn,
  purchase,
  purchaseReturn,
  adjustmentIncrease,
  adjustmentDecrease,
  transferOut,
  transferIn,
  damaged,
  expired;
}

@freezed
abstract class StockMovementModel with _$StockMovementModel {
  const factory StockMovementModel({
    required String id,
    @JsonKey(name: 'operation_id') required String operationId,
    @JsonKey(name: 'pharmacy_id') required String pharmacyId,
    @JsonKey(name: 'branch_id') required String branchId,
    @JsonKey(name: 'medicine_id') required String medicineId,
    @JsonKey(name: 'medicine_name') String? medicineName,
    @JsonKey(name: 'batch_id') String? batchId,
    @JsonKey(name: 'unit_id') String? unitId,
    @JsonKey(fromJson: _parseMovementType, toJson: _movementTypeToJson)
    required MovementType type,
    required double quantity,
    @Default(0) @JsonKey(name: 'unit_cost') double unitCost,
    @JsonKey(name: 'before_quantity') double? beforeQuantity,
    @JsonKey(name: 'after_quantity') double? afterQuantity,
    @JsonKey(name: 'reference_type') required String referenceType,
    @JsonKey(name: 'reference_id') required String referenceId,
    @JsonKey(name: 'actor_id') required String actorId,
    @JsonKey(
      name: 'occurred_at',
      fromJson: _parseOccurredAt,
      toJson: _occurredAtToJson,
    )
    required DateTime occurredAt,
  }) = _StockMovementModel;

  factory StockMovementModel.fromJson(Map<String, dynamic> json) =>
      _$StockMovementModelFromJson(json);
}

MovementType _parseMovementType(String json) =>
    MovementType.values.firstWhere(
      (e) => e.name == json,
      orElse: () => MovementType.adjustmentIncrease,
    );

String _movementTypeToJson(MovementType type) => type.name;

DateTime _parseOccurredAt(String? json) =>
    json != null ? DateTime.parse(json) : DateTime.now().toUtc();

String _occurredAtToJson(DateTime date) => date.toUtc().toIso8601String();
