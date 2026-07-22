// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'party_payment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PartyPaymentModel _$PartyPaymentModelFromJson(Map<String, dynamic> json) =>
    _PartyPaymentModel(
      id: json['id'] as String,
      branchId: json['branch_id'] as String,
      number: (json['number'] as num).toInt(),
      paymentDate: DateTime.parse(json['payment_date'] as String),
      kind: _kindFromJson(json['kind']),
      partyId: json['party_id'] as String,
      partyName: json['party_name'] as String? ?? '',
      amount: (json['amount'] as num).toDouble(),
      paymentMethod: json['payment_method'] as String? ?? 'cash',
      balanceEffect: _balanceEffectFromJson(json['balanceEffect']),
      purchaseReceiptId: json['purchase_receipt_id'] as String?,
      purchaseReceiptNumber: json['purchase_receipt_number'] as String?,
      referenceNumber: json['reference_number'] as String?,
      notes: json['notes'] as String?,
      createdById: json['created_by_id'] as String,
      createdByName: json['created_by_name'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$PartyPaymentModelToJson(_PartyPaymentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'branch_id': instance.branchId,
      'number': instance.number,
      'payment_date': instance.paymentDate.toIso8601String(),
      'kind': _kindToJson(instance.kind),
      'party_id': instance.partyId,
      'party_name': instance.partyName,
      'amount': instance.amount,
      'payment_method': instance.paymentMethod,
      'balanceEffect': _balanceEffectToJson(instance.balanceEffect),
      'purchase_receipt_id': instance.purchaseReceiptId,
      'purchase_receipt_number': instance.purchaseReceiptNumber,
      'reference_number': instance.referenceNumber,
      'notes': instance.notes,
      'created_by_id': instance.createdById,
      'created_by_name': instance.createdByName,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
