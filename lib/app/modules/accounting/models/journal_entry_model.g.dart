// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal_entry_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_JournalEntryLineModel _$JournalEntryLineModelFromJson(
  Map<String, dynamic> json,
) => _JournalEntryLineModel(
  id: json['id'] as String,
  accountId: json['account_id'] as String,
  accountName: json['account_name'] as String? ?? '',
  accountCode: json['account_code'] as String? ?? '',
  debit: (json['debit'] as num?)?.toDouble() ?? 0,
  credit: (json['credit'] as num?)?.toDouble() ?? 0,
  description: json['description'] as String?,
);

Map<String, dynamic> _$JournalEntryLineModelToJson(
  _JournalEntryLineModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'account_id': instance.accountId,
  'account_name': instance.accountName,
  'account_code': instance.accountCode,
  'debit': instance.debit,
  'credit': instance.credit,
  'description': instance.description,
};

_JournalEntryModel _$JournalEntryModelFromJson(Map<String, dynamic> json) =>
    _JournalEntryModel(
      id: json['id'] as String,
      branchId: json['branch_id'] as String,
      entryNumber: (json['entry_number'] as num).toInt(),
      entryDate: DateTime.parse(json['entry_date'] as String),
      entryType: json['entryType'] == null
          ? JournalEntryType.other
          : _journalEntryTypeFromJson(json['entryType']),
      referenceId: json['reference_id'] as String?,
      referenceNumber: json['reference_number'] as String?,
      description: json['description'] as String?,
      lines:
          (json['lines'] as List<dynamic>?)
              ?.map(
                (e) =>
                    JournalEntryLineModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
      totalDebit: (json['total_debit'] as num?)?.toDouble() ?? 0,
      totalCredit: (json['total_credit'] as num?)?.toDouble() ?? 0,
      createdById: json['created_by_id'] as String,
      createdByName: json['created_by_name'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$JournalEntryModelToJson(_JournalEntryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'branch_id': instance.branchId,
      'entry_number': instance.entryNumber,
      'entry_date': instance.entryDate.toIso8601String(),
      'entryType': _journalEntryTypeToJson(instance.entryType),
      'reference_id': instance.referenceId,
      'reference_number': instance.referenceNumber,
      'description': instance.description,
      'lines': instance.lines,
      'total_debit': instance.totalDebit,
      'total_credit': instance.totalCredit,
      'created_by_id': instance.createdById,
      'created_by_name': instance.createdByName,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
