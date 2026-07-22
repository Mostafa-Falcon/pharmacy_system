// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'account_enums.dart';

part 'journal_entry_model.freezed.dart';
part 'journal_entry_model.g.dart';

JournalEntryType _journalEntryTypeFromJson(Object? json) {
  final value = json as String? ?? '';
  return JournalEntryType.values.firstWhere(
    (e) => e.name == value,
    orElse: () => JournalEntryType.other,
  );
}

String _journalEntryTypeToJson(JournalEntryType type) => type.name;

@freezed
abstract class JournalEntryLineModel with _$JournalEntryLineModel {
  const JournalEntryLineModel._();

  const factory JournalEntryLineModel({
    required String id,
    @JsonKey(name: 'account_id') required String accountId,
    @Default('') @JsonKey(name: 'account_name') String accountName,
    @Default('') @JsonKey(name: 'account_code') String accountCode,
    @Default(0) double debit,
    @Default(0) double credit,
    String? description,
  }) = _JournalEntryLineModel;

  factory JournalEntryLineModel.fromJson(Map<String, dynamic> json) =>
      _$JournalEntryLineModelFromJson(json);
}

@freezed
abstract class JournalEntryModel with _$JournalEntryModel {
  const JournalEntryModel._();

  const factory JournalEntryModel({
    required String id,
    @JsonKey(name: 'branch_id') required String branchId,
    @JsonKey(name: 'entry_number') required int entryNumber,
    @JsonKey(name: 'entry_date') required DateTime entryDate,
    @JsonKey(
      fromJson: _journalEntryTypeFromJson,
      toJson: _journalEntryTypeToJson,
    )
    @Default(JournalEntryType.other)
    JournalEntryType entryType,
    @JsonKey(name: 'reference_id') String? referenceId,
    @JsonKey(name: 'reference_number') String? referenceNumber,
    String? description,
    @Default([]) List<JournalEntryLineModel> lines,
    @Default(0) @JsonKey(name: 'total_debit') double totalDebit,
    @Default(0) @JsonKey(name: 'total_credit') double totalCredit,
    @JsonKey(name: 'created_by_id') required String createdById,
    @JsonKey(name: 'created_by_name') String? createdByName,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _JournalEntryModel;

  factory JournalEntryModel.fromJson(Map<String, dynamic> json) =>
      _$JournalEntryModelFromJson(json);
}
