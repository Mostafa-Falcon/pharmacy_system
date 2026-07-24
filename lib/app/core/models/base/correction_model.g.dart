// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'correction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CorrectionEntry _$CorrectionEntryFromJson(Map<String, dynamic> json) =>
    _CorrectionEntry(
      id: json['id'] as String,
      referenceType: $enumDecode(
        _$CorrectionReferenceTypeEnumMap,
        json['reference_type'],
      ),
      referenceId: json['reference_id'] as String,
      action: $enumDecode(_$CorrectionActionEnumMap, json['action']),
      userId: json['user_id'] as String,
      userDisplayName: json['user_display_name'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      details: json['details'] as String?,
    );

Map<String, dynamic> _$CorrectionEntryToJson(
  _CorrectionEntry instance,
) => <String, dynamic>{
  'id': instance.id,
  'reference_type': _$CorrectionReferenceTypeEnumMap[instance.referenceType]!,
  'reference_id': instance.referenceId,
  'action': _$CorrectionActionEnumMap[instance.action]!,
  'user_id': instance.userId,
  'user_display_name': instance.userDisplayName,
  'timestamp': instance.timestamp.toIso8601String(),
  'details': instance.details,
};

const _$CorrectionReferenceTypeEnumMap = {
  CorrectionReferenceType.purchase: 'purchase',
  CorrectionReferenceType.sale: 'sale',
  CorrectionReferenceType.purchaseReturn: 'purchaseReturn',
  CorrectionReferenceType.saleReturn: 'saleReturn',
  CorrectionReferenceType.shift: 'shift',
};

const _$CorrectionActionEnumMap = {
  CorrectionAction.created: 'created',
  CorrectionAction.modified: 'modified',
  CorrectionAction.voided: 'voided',
  CorrectionAction.returned: 'returned',
  CorrectionAction.paymentUpdated: 'paymentUpdated',
};
