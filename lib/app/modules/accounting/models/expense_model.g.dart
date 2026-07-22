// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ExpenseModel _$ExpenseModelFromJson(Map<String, dynamic> json) =>
    _ExpenseModel(
      id: json['id'] as String,
      branchId: json['branch_id'] as String,
      expenseNumber: (json['expense_number'] as num).toInt(),
      expenseDate: DateTime.parse(json['expense_date'] as String),
      category: json['category'] as String,
      description: json['description'] as String?,
      amount: (json['amount'] as num).toDouble(),
      paymentMethod: json['payment_method'] as String? ?? 'cash',
      createdById: json['created_by_id'] as String,
      createdByName: json['created_by_name'] as String?,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$ExpenseModelToJson(_ExpenseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'branch_id': instance.branchId,
      'expense_number': instance.expenseNumber,
      'expense_date': instance.expenseDate.toIso8601String(),
      'category': instance.category,
      'description': instance.description,
      'amount': instance.amount,
      'payment_method': instance.paymentMethod,
      'created_by_id': instance.createdById,
      'created_by_name': instance.createdByName,
      'notes': instance.notes,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
