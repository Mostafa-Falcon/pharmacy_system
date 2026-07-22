// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_movement_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StockMovementModel _$StockMovementModelFromJson(Map<String, dynamic> json) =>
    _StockMovementModel(
      id: json['id'] as String,
      operationId: json['operation_id'] as String,
      pharmacyId: json['pharmacy_id'] as String,
      branchId: json['branch_id'] as String,
      medicineId: json['medicine_id'] as String,
      medicineName: json['medicine_name'] as String?,
      batchId: json['batch_id'] as String?,
      unitId: json['unit_id'] as String?,
      type: _parseMovementType(json['type'] as String),
      quantity: (json['quantity'] as num).toDouble(),
      unitCost: (json['unit_cost'] as num?)?.toDouble() ?? 0,
      beforeQuantity: (json['before_quantity'] as num?)?.toDouble(),
      afterQuantity: (json['after_quantity'] as num?)?.toDouble(),
      referenceType: json['reference_type'] as String,
      referenceId: json['reference_id'] as String,
      actorId: json['actor_id'] as String,
      occurredAt: _parseOccurredAt(json['occurred_at'] as String?),
    );

Map<String, dynamic> _$StockMovementModelToJson(_StockMovementModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'operation_id': instance.operationId,
      'pharmacy_id': instance.pharmacyId,
      'branch_id': instance.branchId,
      'medicine_id': instance.medicineId,
      'medicine_name': instance.medicineName,
      'batch_id': instance.batchId,
      'unit_id': instance.unitId,
      'type': _movementTypeToJson(instance.type),
      'quantity': instance.quantity,
      'unit_cost': instance.unitCost,
      'before_quantity': instance.beforeQuantity,
      'after_quantity': instance.afterQuantity,
      'reference_type': instance.referenceType,
      'reference_id': instance.referenceId,
      'actor_id': instance.actorId,
      'occurred_at': _occurredAtToJson(instance.occurredAt),
    };
