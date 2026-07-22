import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacy_system/app/core/presentation/widgets/reusables/feedback/app_snackbar.dart';
import 'package:pharmacy_system/app/modules/inventory/models/price_group_model.dart';
import 'package:pharmacy_system/app/modules/inventory/services/price_group_service.dart';

// --- Events ---
abstract class PriceGroupsEvent extends Equatable {
  const PriceGroupsEvent();
  @override
  List<Object?> get props => [];
}

class LoadPriceGroups extends PriceGroupsEvent {
  const LoadPriceGroups();
}

class AddPriceGroup extends PriceGroupsEvent {
  final String name;
  final double markupPercentage;
  final double discountPercentage;
  final bool isDefault;
  const AddPriceGroup({
    required this.name,
    this.markupPercentage = 0,
    this.discountPercentage = 0,
    this.isDefault = false,
  });
  @override
  List<Object?> get props => [name, markupPercentage, discountPercentage, isDefault];
}

class UpdatePriceGroup extends PriceGroupsEvent {
  final PriceGroupModel group;
  const UpdatePriceGroup(this.group);
  @override
  List<Object?> get props => [group];
}

class DeletePriceGroup extends PriceGroupsEvent {
  final String id;
  const DeletePriceGroup(this.id);
  @override
  List<Object?> get props => [id];
}

class SetPriceGroupDefault extends PriceGroupsEvent {
  final String id;
  const SetPriceGroupDefault(this.id);
  @override
  List<Object?> get props => [id];
}

class FilterPriceGroups extends PriceGroupsEvent {
  final String query;
  const FilterPriceGroups(this.query);
  @override
  List<Object?> get props => [query];
}

// --- State ---
class PriceGroupsState extends Equatable {
  final List<PriceGroupModel> priceGroups;
  final List<PriceGroupModel> filteredPriceGroups;
  final bool isLoading;
  final String searchQuery;

  const PriceGroupsState({
    this.priceGroups = const [],
    this.filteredPriceGroups = const [],
    this.isLoading = false,
    this.searchQuery = '',
  });

  PriceGroupsState copyWith({
    List<PriceGroupModel>? priceGroups,
    List<PriceGroupModel>? filteredPriceGroups,
    bool? isLoading,
    String? searchQuery,
  }) {
    return PriceGroupsState(
      priceGroups: priceGroups ?? this.priceGroups,
      filteredPriceGroups: filteredPriceGroups ?? this.filteredPriceGroups,
      isLoading: isLoading ?? this.isLoading,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [priceGroups, filteredPriceGroups, isLoading, searchQuery];
}

// --- Bloc ---
class PriceGroupsBloc extends Bloc<PriceGroupsEvent, PriceGroupsState> {
  PriceGroupsBloc() : super(const PriceGroupsState()) {
    on<LoadPriceGroups>(_onLoad);
    on<AddPriceGroup>(_onAdd);
    on<UpdatePriceGroup>(_onUpdate);
    on<DeletePriceGroup>(_onDelete);
    on<SetPriceGroupDefault>(_onSetDefault);
    on<FilterPriceGroups>(_onFilter);
  }

  void _applyFilter(Emitter<PriceGroupsState> emit) {
    final q = state.searchQuery.toLowerCase();
    final filtered = q.isEmpty
        ? state.priceGroups
        : state.priceGroups.where((g) => g.name.toLowerCase().contains(q)).toList();
    emit(state.copyWith(filteredPriceGroups: filtered));
  }

  Future<void> _onLoad(LoadPriceGroups event, Emitter<PriceGroupsState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final groups = PriceGroupService.getAll();
      emit(state.copyWith(priceGroups: groups, filteredPriceGroups: groups));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _onAdd(AddPriceGroup event, Emitter<PriceGroupsState> emit) async {
    if (PriceGroupService.nameExists(event.name)) {
      AppSnackbar.error('اسم مجموعة الأسعار موجود مسبقاً');
      return;
    }
    await PriceGroupService.add(
      name: event.name,
      markupPercentage: event.markupPercentage,
      discountPercentage: event.discountPercentage,
      isDefault: event.isDefault,
    );
    add(const LoadPriceGroups());
  }

  Future<void> _onUpdate(UpdatePriceGroup event, Emitter<PriceGroupsState> emit) async {
    if (PriceGroupService.nameExists(event.group.name, excludeId: event.group.id)) {
      AppSnackbar.error('اسم مجموعة الأسعار موجود مسبقاً');
      return;
    }
    await PriceGroupService.update(event.group);
    add(const LoadPriceGroups());
  }

  Future<void> _onDelete(DeletePriceGroup event, Emitter<PriceGroupsState> emit) async {
    await PriceGroupService.delete(event.id);
    add(const LoadPriceGroups());
  }

  Future<void> _onSetDefault(SetPriceGroupDefault event, Emitter<PriceGroupsState> emit) async {
    final group = PriceGroupService.getById(event.id);
    if (group != null) {
      await PriceGroupService.update(group.copyWith(isDefault: true));
      add(const LoadPriceGroups());
    }
  }

  void _onFilter(FilterPriceGroups event, Emitter<PriceGroupsState> emit) {
    emit(state.copyWith(searchQuery: event.query));
    _applyFilter(emit);
  }
}

