// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_transfer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StockTransferItemModel _$StockTransferItemModelFromJson(
  Map<String, dynamic> json,
) => _StockTransferItemModel(
  medicineId: json['medicine_id'] as String,
  medicineName: json['medicine_name'] as String,
  quantity: (json['quantity'] as num).toInt(),
  unitCost: (json['unit_cost'] as num).toDouble(),
  barcode: json['barcode'] as String?,
  batchId: json['batch_id'] as String?,
  batchNumber: json['batch_number'] as String?,
);

Map<String, dynamic> _$StockTransferItemModelToJson(
  _StockTransferItemModel instance,
) => <String, dynamic>{
  'medicine_id': instance.medicineId,
  'medicine_name': instance.medicineName,
  'quantity': instance.quantity,
  'unit_cost': instance.unitCost,
  'barcode': instance.barcode,
  'batch_id': instance.batchId,
  'batch_number': instance.batchNumber,
};

_StockTransferModel _$StockTransferModelFromJson(Map<String, dynamic> json) =>
    _StockTransferModel(
      id: json['id'] as String,
      branchId: json['branch_id'] as String,
      fromBranchId: json['from_branch_id'] as String,
      toBranchId: json['to_branch_id'] as String,
      fromBranchName: json['from_branch_name'] as String,
      toBranchName: json['to_branch_name'] as String,
      transferNumber: (json['transfer_number'] as num).toInt(),
      items: (json['items'] as List<dynamic>)
          .map(
            (e) => StockTransferItemModel.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      status: json['status'] == null
          ? TransferStatus.draft
          : _transferStatusFromJson(json['status']),
      notes: json['notes'] as String?,
      createdBy: json['created_by'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      receivedAt: json['received_at'] == null
          ? null
          : DateTime.parse(json['received_at'] as String),
      receivedBy: json['received_by'] as String?,
    );

Map<String, dynamic> _$StockTransferModelToJson(_StockTransferModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'branch_id': instance.branchId,
      'from_branch_id': instance.fromBranchId,
      'to_branch_id': instance.toBranchId,
      'from_branch_name': instance.fromBranchName,
      'to_branch_name': instance.toBranchName,
      'transfer_number': instance.transferNumber,
      'items': instance.items,
      'status': _transferStatusToJson(instance.status),
      'notes': instance.notes,
      'created_by': instance.createdBy,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'received_at': instance.receivedAt?.toIso8601String(),
      'received_by': instance.receivedBy,
    };
