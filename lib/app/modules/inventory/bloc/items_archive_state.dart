import 'package:equatable/equatable.dart';
import 'package:pharmacy_system/app/core/models/inventory/medicine_model.dart';

enum ItemsArchiveStatus { initial, loading, loaded, error }

class ItemsArchiveState extends Equatable {
  final ItemsArchiveStatus status;
  final List<MedicineModel> items;
  final Set<String> selectedIds;
  final bool isWorking;
  final String? error;

  const ItemsArchiveState({
    this.status = ItemsArchiveStatus.initial,
    this.items = const [],
    this.selectedIds = const {},
    this.isWorking = false,
    this.error,
  });

  ItemsArchiveState copyWith({
    ItemsArchiveStatus? status,
    List<MedicineModel>? items,
    Set<String>? selectedIds,
    bool? isWorking,
    String? error,
    bool clearError = false,
  }) {
    return ItemsArchiveState(
      status: status ?? this.status,
      items: items ?? this.items,
      selectedIds: selectedIds ?? this.selectedIds,
      isWorking: isWorking ?? this.isWorking,
      error: clearError ? null : (error ?? this.error),
    );
  }

  @override
  List<Object?> get props => [status, items, selectedIds, isWorking, error];
}




