// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'party_payment_enums.dart';

part 'party_payment_model.freezed.dart';
part 'party_payment_model.g.dart';

PartyPaymentKind _kindFromJson(Object? json) {
    final value = json as String? ?? '';
    return PartyPaymentKind.values.firstWhere(
        (e) => e.name == value,
        orElse: () => PartyPaymentKind.supplierPayment);
}

String _kindToJson(PartyPaymentKind kind) => kind.name;

PartyBalanceEffect? _balanceEffectFromJson(Object? json) =>
    json == null ? null : PartyBalanceEffect.values.firstWhere((e) => e.name == json as String);

String? _balanceEffectToJson(PartyBalanceEffect? effect) => effect?.name;

@freezed
abstract class PartyPaymentModel with _$PartyPaymentModel {
  const PartyPaymentModel._();

  const factory PartyPaymentModel({
    required String id,
    @JsonKey(name: 'branch_id') required String branchId,
    required int number,
    @JsonKey(name: 'payment_date') required DateTime paymentDate,
    @JsonKey(fromJson: _kindFromJson, toJson: _kindToJson) required PartyPaymentKind kind,
    @JsonKey(name: 'party_id') required String partyId,
    @Default('') @JsonKey(name: 'party_name') String partyName,
    required double amount,
    @Default('cash') @JsonKey(name: 'payment_method') String paymentMethod,
    @JsonKey(fromJson: _balanceEffectFromJson, toJson: _balanceEffectToJson) PartyBalanceEffect? balanceEffect,
    @JsonKey(name: 'purchase_receipt_id') String? purchaseReceiptId,
    @JsonKey(name: 'purchase_receipt_number') String? purchaseReceiptNumber,
    @JsonKey(name: 'reference_number') String? referenceNumber,
    String? notes,
    @JsonKey(name: 'created_by_id') required String createdById,
    @JsonKey(name: 'created_by_name') String? createdByName,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _PartyPaymentModel;

  factory PartyPaymentModel.fromJson(Map<String, dynamic> json) =>
      _$PartyPaymentModelFromJson(json);

  String get entityType => kind.isSupplier ? 'supplier' : 'customer';

  PartyBalanceEffect get effectiveBalanceEffect =>
      balanceEffect ??
      (kind == PartyPaymentKind.supplierPayment
          ? PartyBalanceEffect.decrease
          : kind == PartyPaymentKind.supplierDiscountNote
              ? PartyBalanceEffect.decrease
              : PartyBalanceEffect.increase);
}
