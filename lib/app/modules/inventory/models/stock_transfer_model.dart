// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'inventory_enums.dart';

part 'stock_transfer_model.freezed.dart';
part 'stock_transfer_model.g.dart';

TransferStatus _transferStatusFromJson(Object? json) {
  final value = json as String? ?? '';
  return TransferStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => TransferStatus.draft);
}

String _transferStatusToJson(TransferStatus status) => status.name;

@freezed
abstract class StockTransferItemModel with _$StockTransferItemModel {
  const StockTransferItemModel._();

  const factory StockTransferItemModel({
    @JsonKey(name: 'medicine_id') required String medicineId,
    @JsonKey(name: 'medicine_name') required String medicineName,
    required int quantity,
    @JsonKey(name: 'unit_cost') required double unitCost,
    String? barcode,
    @JsonKey(name: 'batch_id') String? batchId,
    @JsonKey(name: 'batch_number') String? batchNumber,
  }) = _StockTransferItemModel;

  factory StockTransferItemModel.fromJson(Map<String, dynamic> json) =>
      _$StockTransferItemModelFromJson(json);
}

@freezed
abstract class StockTransferModel with _$StockTransferModel {
  const StockTransferModel._();

  const factory StockTransferModel({
    required String id,
    @JsonKey(name: 'branch_id') required String branchId,
    @JsonKey(name: 'from_branch_id') required String fromBranchId,
    @JsonKey(name: 'to_branch_id') required String toBranchId,
    @JsonKey(name: 'from_branch_name') required String fromBranchName,
    @JsonKey(name: 'to_branch_name') required String toBranchName,
    @JsonKey(name: 'transfer_number') required int transferNumber,
    required List<StockTransferItemModel> items,
    @JsonKey(fromJson: _transferStatusFromJson, toJson: _transferStatusToJson)
    @Default(TransferStatus.draft) TransferStatus status,
    String? notes,
    @JsonKey(name: 'created_by') required String createdBy,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    @JsonKey(name: 'received_at') DateTime? receivedAt,
    @JsonKey(name: 'received_by') String? receivedBy,
  }) = _StockTransferModel;

  factory StockTransferModel.fromJson(Map<String, dynamic> json) =>
      _$StockTransferModelFromJson(json);
}
