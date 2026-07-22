import '../../../core/bloc/base_state.dart';
import 'package:pharmacy_system/app/modules/inventory/models/medicine_model.dart';

/// حالة شاشة الأدوية — مركزية وكاملة لكل العمليات (عرض/فلترة/ترتيب/صفحات/تحديد/CRUD).
class MedicinesState extends BaseState<List<MedicineModel>> {
  final List<MedicineModel> filteredMedicines;
  final List<MedicineModel> pagedMedicines;
  final Set<String> selectedIds;
  final bool isLoadingAction;
  final double bulkActionProgress; // من 0.0 إلى 1.0
  final String? bulkActionTitle;
  final double importProgress; // من 0.0 إلى 1.0

  // ─── بحث وفلترة وترتيب ───
  final String searchQuery;
  final String selectedFilter; // all, low_stock, out_of_stock, expiring, expired
  final String? selectedCategory;
  final String? sortColumnId;
  final bool isSortAscending;

  // ─── صفحات ───
  final int currentPage; // صفر-based
  final int totalPages;
  final int pageSize;

  List<int> get pageSizeOptions => const [50, 100, 150, 200, 500, 1000];

  const MedicinesState({
    super.data,
    super.isLoading = false,
    super.errorMessage,
    super.isInitial = false,
    super.isEmpty = false,
    super.fromDate,
    super.toDate,
    this.filteredMedicines = const [],
    this.pagedMedicines = const [],
    this.selectedIds = const {},
    this.isLoadingAction = false,
    this.bulkActionProgress = 0,
    this.bulkActionTitle,
    this.importProgress = 0,
    this.searchQuery = '',
    this.selectedFilter = 'all',
    this.selectedCategory,
    this.sortColumnId,
    this.isSortAscending = true,
    this.currentPage = 0,
    this.totalPages = 1,
    this.pageSize = 100,
  });

  List<MedicineModel> get allMedicines => data ?? [];
  BaseState<List<MedicineModel>> get dataState => this;

  // ─── إحصائيات الشريط العلوي ───
  int get totalCount => allMedicines.length;

  int get lowStockCount => allMedicines
      .where((m) => m.alertEnabled && m.quantity <= m.minStock && m.quantity > 0)
      .length;

  int get outOfStockCount => allMedicines.where((m) => m.quantity <= 0).length;

  int get expiringCount {
    final now = DateTime.now();
    final threshold = now.add(const Duration(days: 90));
    return allMedicines
        .where((m) =>
            m.expiryTrackingEnabled &&
            m.expiryDate != null &&
            m.expiryDate!.isAfter(now) &&
            m.expiryDate!.isBefore(threshold))
        .length;
  }

  int get expiredCount {
    final now = DateTime.now();
    return allMedicines
        .where((m) =>
            m.expiryTrackingEnabled &&
            m.expiryDate != null &&
            m.expiryDate!.isBefore(now))
        .length;
  }

  @override
  MedicinesState copyWith({
    List<MedicineModel>? data,
    bool? isLoading,
    String? errorMessage,
    bool? isInitial,
    bool? isEmpty,
    DateTime? fromDate,
    DateTime? toDate,
    List<MedicineModel>? filteredMedicines,
    List<MedicineModel>? pagedMedicines,
    Set<String>? selectedIds,
    bool? isLoadingAction,
    double? bulkActionProgress,
    String? bulkActionTitle,
    double? importProgress,
    String? searchQuery,
    String? selectedFilter,
    String? selectedCategory,
    String? sortColumnId,
    bool? isSortAscending,
    int? currentPage,
    int? totalPages,
    int? pageSize,
  }) {
    return MedicinesState(
      data: data ?? this.data,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      isInitial: isInitial ?? this.isInitial,
      isEmpty: isEmpty ?? this.isEmpty,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      filteredMedicines: filteredMedicines ?? this.filteredMedicines,
      pagedMedicines: pagedMedicines ?? this.pagedMedicines,
      selectedIds: selectedIds ?? this.selectedIds,
      isLoadingAction: isLoadingAction ?? this.isLoadingAction,
      bulkActionProgress: bulkActionProgress ?? this.bulkActionProgress,
      bulkActionTitle: bulkActionTitle ?? this.bulkActionTitle,
      importProgress: importProgress ?? this.importProgress,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      sortColumnId: sortColumnId ?? this.sortColumnId,
      isSortAscending: isSortAscending ?? this.isSortAscending,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      pageSize: pageSize ?? this.pageSize,
    );
  }

  @override
  List<Object?> get props => [
        data,
        isLoading,
        errorMessage,
        fromDate,
        toDate,
        filteredMedicines,
        pagedMedicines,
        selectedIds,
        isLoadingAction,
        bulkActionProgress,
        bulkActionTitle,
        importProgress,
        searchQuery,
        selectedFilter,
        selectedCategory,
        sortColumnId,
        isSortAscending,
        currentPage,
        totalPages,
        pageSize,
      ];
}

