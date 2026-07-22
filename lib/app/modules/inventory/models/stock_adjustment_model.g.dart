// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_adjustment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StockAdjustmentModel _$StockAdjustmentModelFromJson(
  Map<String, dynamic> json,
) => _StockAdjustmentModel(
  id: json['id'] as String,
  pharmacyId: json['pharmacy_id'] as String,
  branchId: json['branch_id'] as String,
  adjustmentNumber: json['adjustment_number'] as String,
  adjustmentDate: DateTime.parse(json['adjustment_date'] as String),
  items:
      (json['items'] as List<dynamic>?)
          ?.map(
            (e) => StockAdjustmentItemModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
  createdById: json['created_by_id'] as String?,
  createdByName: json['created_by_name'] as String?,
  notes: json['notes'] as String?,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$StockAdjustmentModelToJson(
  _StockAdjustmentModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'pharmacy_id': instance.pharmacyId,
  'branch_id': instance.branchId,
  'adjustment_number': instance.adjustmentNumber,
  'adjustment_date': instance.adjustmentDate.toIso8601String(),
  'items': instance.items,
  'created_by_id': instance.createdById,
  'created_by_name': instance.createdByName,
  'notes': instance.notes,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
};

_StockAdjustmentItemModel _$StockAdjustmentItemModelFromJson(
  Map<String, dynamic> json,
) => _StockAdjustmentItemModel(
  id: json['id'] as String,
  itemId: json['item_id'] as String,
  itemName: json['item_name'] as String?,
  barcode: json['barcode'] as String?,
  unitId: json['unit_id'] as String?,
  unitName: json['unit_name'] as String?,
  batchId: json['batch_id'] as String?,
  batchNumber: json['batch_number'] as String?,
  type: _adjustmentTypeFromJson(json['type']),
  reason: _adjustmentReasonFromJson(json['reason']),
  quantity: (json['quantity'] as num).toDouble(),
  unitCost: (json['unit_cost'] as num?)?.toDouble(),
);

Map<String, dynamic> _$StockAdjustmentItemModelToJson(
  _StockAdjustmentItemModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'item_id': instance.itemId,
  'item_name': instance.itemName,
  'barcode': instance.barcode,
  'unit_id': instance.unitId,
  'unit_name': instance.unitName,
  'batch_id': instance.batchId,
  'batch_number': instance.batchNumber,
  'type': _adjustmentTypeToJson(instance.type),
  'reason': _adjustmentReasonToJson(instance.reason),
  'quantity': instance.quantity,
  'unit_cost': instance.unitCost,
};
