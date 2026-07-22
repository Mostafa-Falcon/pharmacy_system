import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pharmacy_system/app/modules/inventory/models/medicine_model.dart';
import 'package:pharmacy_system/app/core/data/services/auth/auth_service.dart';
import 'package:pharmacy_system/app/core/data/repositories/medicines_repository.dart';
import 'package:pharmacy_system/app/core/injection.dart';

class CatalogState extends Equatable {
  final List<MedicineModel> medicines;
  final List<MedicineModel> filteredMedicines;
  final List<String> categories;
  final String searchQuery;
  final String? selectedCategory;
  final bool isLoading;
  final int nearExpiryCount;
  final int lowStockCount;
  final int expiredCount;

  const CatalogState({
    this.medicines = const [],
    this.filteredMedicines = const [],
    this.categories = const [],
    this.searchQuery = '',
    this.selectedCategory,
    this.isLoading = false,
    this.nearExpiryCount = 0,
    this.lowStockCount = 0,
    this.expiredCount = 0,
  });

  CatalogState copyWith({
    List<MedicineModel>? medicines,
    List<MedicineModel>? filteredMedicines,
    List<String>? categories,
    String? searchQuery,
    String? selectedCategory,
    bool? isLoading,
    int? nearExpiryCount,
    int? lowStockCount,
    int? expiredCount,
  }) {
    return CatalogState(
      medicines: medicines ?? this.medicines,
      filteredMedicines: filteredMedicines ?? this.filteredMedicines,
      categories: categories ?? this.categories,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      isLoading: isLoading ?? this.isLoading,
      nearExpiryCount: nearExpiryCount ?? this.nearExpiryCount,
      lowStockCount: lowStockCount ?? this.lowStockCount,
      expiredCount: expiredCount ?? this.expiredCount,
    );
  }

  @override
  List<Object?> get props => [
        medicines,
        filteredMedicines,
        categories,
        searchQuery,
        selectedCategory,
        isLoading,
        nearExpiryCount,
        lowStockCount,
        expiredCount,
      ];
}

class CatalogCubit extends Cubit<CatalogState> {
  CatalogCubit() : super(const CatalogState());

  StreamSubscription? _subscription;
  String get _branchId => AuthService.currentBranchId ?? '';

  void initialize() {
    emit(state.copyWith(isLoading: true));
    _subscription?.cancel();
    _subscription = sl<MedicinesRepository>().watchMedicines(_branchId).listen((items) {
      _onMedicinesUpdated(items);
    });
  }

  void _onMedicinesUpdated(List<MedicineModel> items) {
    final activeItems = items.where((m) => m.isActive && !m.isDeleted).toList();
    final cats = activeItems.map((m) => m.category).whereType<String>().toSet().toList()..sort();
    
    final now = DateTime.now();
    final expired = activeItems.where((m) => m.expiryDate != null && m.expiryDate!.isBefore(now)).length;
    final near = activeItems.where((m) => m.expiryDate != null && m.expiryDate!.isAfter(now) && m.expiryDate!.difference(now).inDays <= 30).length;
    final low = activeItems.where((m) => m.quantity <= m.minStock).length;

    final newState = state.copyWith(
      medicines: activeItems,
      categories: cats,
      isLoading: false,
      expiredCount: expired,
      nearExpiryCount: near,
      lowStockCount: low,
    );
    emit(_recompute(newState));
  }

  void updateSearch(String query) {
    emit(_recompute(state.copyWith(searchQuery: query)));
  }

  void updateCategory(String? category) {
    emit(_recompute(state.copyWith(selectedCategory: category)));
  }

  CatalogState _recompute(CatalogState s) {
    final now = DateTime.now();
    final q = s.searchQuery.trim().toLowerCase();
    final cat = s.selectedCategory;
    
    var filtered = s.medicines.toList();
    
    if (cat != null) {
      filtered = filtered.where((m) => m.category == cat).toList();
    }
    
    if (q.isNotEmpty) {
      filtered = filtered.where((m) =>
        m.name.toLowerCase().contains(q) ||
        (m.nameEn?.toLowerCase().contains(q) ?? false) ||
        m.barcodes.any((b) => b.toLowerCase().contains(q))).toList();
    }

    filtered.sort((a, b) {
      final aExpired = a.expiryDate != null && a.expiryDate!.isBefore(now);
      final bExpired = b.expiryDate != null && b.expiryDate!.isBefore(now);
      if (aExpired && !bExpired) return -1;
      if (!aExpired && bExpired) return 1;
      return a.name.compareTo(b.name);
    });

    return s.copyWith(filteredMedicines: filtered);
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}

