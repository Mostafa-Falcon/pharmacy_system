// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'expense_model.freezed.dart';
part 'expense_model.g.dart';

@freezed
abstract class ExpenseModel with _$ExpenseModel {
  const factory ExpenseModel({
    required String id,
    @JsonKey(name: 'branch_id') required String branchId,
    @JsonKey(name: 'expense_number') required int expenseNumber,
    @JsonKey(name: 'expense_date') required DateTime expenseDate,
    required String category,
    String? description,
    required double amount,
    @JsonKey(name: 'payment_method') @Default('cash') String paymentMethod,
    @JsonKey(name: 'created_by_id') required String createdById,
    @JsonKey(name: 'created_by_name') String? createdByName,
    String? notes,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _ExpenseModel;

  factory ExpenseModel.fromJson(Map<String, dynamic> json) =>
      _$ExpenseModelFromJson(json);
}
