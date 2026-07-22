// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'correction_model.freezed.dart';
part 'correction_model.g.dart';

@JsonEnum()
enum CorrectionAction { created, modified, voided, returned, paymentUpdated }

@JsonEnum()
enum CorrectionReferenceType { purchase, sale, purchaseReturn, saleReturn, shift }

@freezed
abstract class CorrectionEntry with _$CorrectionEntry {
  const CorrectionEntry._();

  const factory CorrectionEntry({
    required String id,
    @JsonKey(name: 'reference_type') required CorrectionReferenceType referenceType,
    @JsonKey(name: 'reference_id') required String referenceId,
    required CorrectionAction action,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'user_display_name') required String userDisplayName,
    required DateTime timestamp,
    String? details,
  }) = _CorrectionEntry;

  factory CorrectionEntry.fromJson(Map<String, dynamic> json) =>
      _$CorrectionEntryFromJson({
        ...json,
        'user_display_name': json['user_display_name'] ?? '',
      });
}
