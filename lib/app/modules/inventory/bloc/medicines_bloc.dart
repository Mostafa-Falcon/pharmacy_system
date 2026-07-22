import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacy_system/app/core/utils/app_utils.dart';

import '../../../core/injection.dart';
import 'package:pharmacy_system/app/modules/inventory/models/medicine_model.dart';
import 'package:pharmacy_system/app/core/data/repositories/medicines_repository.dart';
import 'package:pharmacy_system/app/core/data/services/auth/auth_service.dart';
import 'package:pharmacy_system/app/core/data/services/admin/branch_data_service.dart';
import 'package:pharmacy_system/app/core/data/services/excel_import_service.dart';
import 'package:pharmacy_system/app/core/data/services/sound_service.dart';
import 'package:pharmacy_system/app/core/data/services/inventory/stock_mutation_service.dart';
import 'package:pharmacy_system/app/core/presentation/widgets/reusables/feedback/app_snackbar.dart';
import 'package:pharmacy_system/app/modules/inventory/models/inventory_enums.dart';
import 'package:pharmacy_system/app/modules/inventory/models/stock_adjustment_model.dart';
import '../services/inventory_transaction_service.dart';
import 'medicines_event.dart';
import 'medicines_state.dart';

export 'medicines_event.dart';
export 'medicines_state.dart';

/// Bloc مركزي لإدارة شاشة الأدوية: العرض، الفلترة، الترتيب،
/// الصفحات، التحديد المتعدد، وكل عمليات CRUD مع كفاءة عالية.
class MedicinesBloc extends Bloc<MedicinesEvent, MedicinesState> {
  StreamSubscription? _subscription;

  MedicinesBloc() : super(const MedicinesState()) {
    on<LoadMedicines>(_onLoad);
    on<SearchMedicines>(_onSearch);
    on<FilterMedicines>(_onFilter);
    on<FilterByCategory>(_onFilterByCategory);
    on<SortMedicines>(_onSort);
    on<ChangePageSize>(_onChangePageSize);
    on<GoToPage>(_onGoToPage);
    on<NextPage>(_onNextPage);
    on<PreviousPage>(_onPreviousPage);
    on<ToggleSelectRow>(_onToggleSelectRow);
    on<ToggleSelectAll>(_onToggleSelectAll);
    on<AddMedicine>(_onAdd);
    on<UpdateMedicine>(_onUpdate);
    on<DeleteMedicine>(_onDelete);
    on<DeleteSelectedMedicines>(_onDeleteSelected);
    on<DeleteAllMedicines>(_onDeleteAll);
    on<AdjustMedicineQuantity>(_onAdjustQuantity);
    on<ImportMedicinesFromExcel>(_onImportExcel);
    on<UpdateImportProgress>(_onUpdateImportProgress);
    
    // اشتراك في التحديثات الحية من المستودع
    _subscription = sl<MedicinesRepository>().watchMedicines(_branchId).listen((data) {
      if (!isClosed) {
        add(const LoadMedicines());
      }
    });

    add(const LoadMedicines());
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }

  String get _branchId => AuthService.currentBranchId ?? '';

  // ─── ثوابت الفلترة والصلاحية ───
  static const int _expiringThresholdDays = 90;
  // ════════════════ Load ════════════════
  Future<void> _onLoad(LoadMedicines event, Emitter<MedicinesState> emit) async {
    // نرفع حالة التحميل فقط إذا كانت القائمة فارغة لتجنب الوميض (Flicker) عند التحديث التلقائي
    if (state.allMedicines.isEmpty) {
      emit(state.copyWith(isLoading: true));
    }
    
    try {
      // إعطاء فرصة بسيطة للمعالج لضمان استقرار حالة Hive
      await Future.delayed(Duration.zero);

      final all = (await BranchDataService.getMedicinesAsync(branchId: _branchId))
          .where((m) => !m.isDeleted)
          .toList()
        ..sort((a, b) {
          if (a.expiryDate == null && b.expiryDate == null) return 0;
          if (a.expiryDate == null) return 1;
          if (b.expiryDate == null) return -1;
          return a.expiryDate!.compareTo(b.expiryDate!);
        });

      final filtered = _applyFilterAndSort(all);
      final totalPages = _computePages(filtered.length, state.pageSize);
      final safePage = state.currentPage.clamp(0, totalPages - 1);
      emit(state.copyWith(
        data: all,
        filteredMedicines: filtered,
        currentPage: safePage,
        totalPages: totalPages,
        pagedMedicines: _paginate(filtered, safePage, state.pageSize),
        selectedIds: const {},
        isLoadingAction: false,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'فشل في تحميل الأدوية: $e',
        isLoadingAction: false,
        isLoading: false,
      ));
    }
  }

  // ════════════════ Search / Filter / Sort ════════════════
  void _onSearch(SearchMedicines event, Emitter<MedicinesState> emit) {
    final filtered = _applyFilterAndSort(state.allMedicines, query: event.query);
    emit(state.copyWith(
      searchQuery: event.query,
      filteredMedicines: filtered,
      currentPage: 0,
      totalPages: _computePages(filtered.length, state.pageSize),
      pagedMedicines: _paginate(filtered, 0, state.pageSize),
    ));
  }

  void _onFilter(FilterMedicines event, Emitter<MedicinesState> emit) {
    final filtered = _applyFilterAndSort(state.allMedicines, filter: event.filter);
    emit(state.copyWith(
      selectedFilter: event.filter,
      filteredMedicines: filtered,
      currentPage: 0,
      totalPages: _computePages(filtered.length, state.pageSize),
      pagedMedicines: _paginate(filtered, 0, state.pageSize),
    ));
  }

  void _onFilterByCategory(FilterByCategory event, Emitter<MedicinesState> emit) {
    final filtered = _applyFilterAndSort(state.allMedicines, category: event.category);
    emit(state.copyWith(
      selectedCategory: event.category,
      filteredMedicines: filtered,
      currentPage: 0,
      totalPages: _computePages(filtered.length, state.pageSize),
      pagedMedicines: _paginate(filtered, 0, state.pageSize),
    ));
  }

  void _onSort(SortMedicines event, Emitter<MedicinesState> emit) {
    final ascending = state.sortColumnId == event.columnId
        ? !state.isSortAscending
        : true;
    final filtered = _applyFilterAndSort(
      state.allMedicines,
      query: state.searchQuery,
      filter: state.selectedFilter,
      category: state.selectedCategory,
      sortColumnId: event.columnId,
      ascending: ascending,
    );
    emit(state.copyWith(
      sortColumnId: event.columnId,
      isSortAscending: ascending,
      filteredMedicines: filtered,
      currentPage: 0,
      totalPages: _computePages(filtered.length, state.pageSize),
      pagedMedicines: _paginate(filtered, 0, state.pageSize),
    ));
  }

  // ════════════════ Pagination ════════════════
  void _onChangePageSize(ChangePageSize event, Emitter<MedicinesState> emit) {
    final filtered = state.filteredMedicines;
    final totalPages = _computePages(filtered.length, event.pageSize);
    final safePage = state.currentPage.clamp(0, totalPages - 1);
    
    emit(state.copyWith(
      pageSize: event.pageSize,
      currentPage: safePage,
      totalPages: totalPages,
      pagedMedicines: _paginate(filtered, safePage, event.pageSize),
    ));
  }

  void _onGoToPage(GoToPage event, Emitter<MedicinesState> emit) {
    final page = event.page.clamp(0, state.totalPages - 1);
    emit(state.copyWith(
      currentPage: page,
      pagedMedicines: _paginate(state.filteredMedicines, page, state.pageSize),
    ));
  }

  void _onNextPage(NextPage event, Emitter<MedicinesState> emit) {
    if (state.currentPage < state.totalPages - 1) {
      final page = state.currentPage + 1;
      emit(state.copyWith(
        currentPage: page,
        pagedMedicines: _paginate(state.filteredMedicines, page, state.pageSize),
      ));
    }
  }

  void _onPreviousPage(PreviousPage event, Emitter<MedicinesState> emit) {
    if (state.currentPage > 0) {
      final page = state.currentPage - 1;
      emit(state.copyWith(
        currentPage: page,
        pagedMedicines: _paginate(state.filteredMedicines, page, state.pageSize),
      ));
    }
  }

  // ════════════════ Selection ════════════════
  void _onToggleSelectRow(ToggleSelectRow event, Emitter<MedicinesState> emit) {
    final ids = Set<String>.from(state.selectedIds);
    if (ids.contains(event.id)) {
      ids.remove(event.id);
    } else {
      ids.add(event.id);
    }
    emit(state.copyWith(selectedIds: ids));
  }

  void _onToggleSelectAll(ToggleSelectAll event, Emitter<MedicinesState> emit) {
    final ids = Set<String>.from(state.selectedIds);
    if (event.selectAll) {
      for (final m in state.pagedMedicines) {
        ids.add(m.id.toString());
      }
    } else {
      ids.clear();
    }
    emit(state.copyWith(selectedIds: ids));
  }

  // ════════════════ CRUD ════════════════
  Future<void> _onAdd(AddMedicine event, Emitter<MedicinesState> emit) async {
    await _performAction(
      emit,
      action: () => BranchDataService.addMedicine(event.medicine),
      successMessage: 'تم إضافة الدواء "${event.medicine.name}" بنجاح',
      errorMessage: 'فشل في إضافة الدواء',
      soundEffect: SoundEffect.itemAdded,
    );
  }

  Future<void> _onUpdate(UpdateMedicine event, Emitter<MedicinesState> emit) async {
    await _performAction(
      emit,
      action: () => BranchDataService.updateMedicine(event.medicine),
      successMessage: 'تم تحديث بيانات الدواء "${event.medicine.name}"',
      errorMessage: 'فشل في تحديث الدواء',
    );
  }

  Future<void> _onDelete(DeleteMedicine event, Emitter<MedicinesState> emit) async {
    await _performAction(
      emit,
      action: () => BranchDataService.deleteMedicine(event.medicine),
      successMessage: 'تم حذف الدواء "${event.medicine.name}" بنجاح',
      errorMessage: 'فشل في حذف الدواء',
      soundEffect: SoundEffect.error,
    );
  }

  Future<void> _onDeleteSelected(
    DeleteSelectedMedicines event,
    Emitter<MedicinesState> emit,
  ) async {
    if (state.selectedIds.isEmpty) return;
    
    final selectedIdsList = state.selectedIds.toList();
    final total = selectedIdsList.length;
    
    emit(state.copyWith(
      isLoadingAction: true, 
      bulkActionProgress: 0.0,
      bulkActionTitle: 'جاري حذف الأدوية المحددة...',
    ));

    try {
      // تحسين الأداء: تحويل القائمة لماب للبحث السريع O(1) بدلاً من البحث المتكرر O(N)
      final medicineMap = {for (var m in state.allMedicines) m.id.toString(): m};
      
      int successCount = 0;
      for (int i = 0; i < total; i++) {
        final idStr = selectedIdsList[i];
        final medicine = medicineMap[idStr];
        
        if (medicine != null) {
          await BranchDataService.deleteMedicine(medicine);
          successCount++;
        }

        // تحديث التقدم بنسبة حقيقية
        emit(state.copyWith(bulkActionProgress: (i + 1) / total));
        
        // إعطاء فرصة للمعالج لتحديث الواجهة ومنع التجمد (Microtask yield)
        if (i % 5 == 0) await Future.delayed(Duration.zero);
      }

      SoundService.instance.play(SoundEffect.error);
      AppSnackbar.success('تم حذف $successCount دواء بنجاح', title: 'نجح');
      
      emit(state.copyWith(isLoadingAction: false, bulkActionProgress: 1.0));
      if (!isClosed) add(const LoadMedicines());
    } catch (e) {
      SoundService.instance.play(SoundEffect.error);
      AppSnackbar.error('فشل في حذف الأدوية المحددة: $e', title: 'خطأ');
      emit(state.copyWith(isLoadingAction: false, bulkActionProgress: 0));
    }
  }

  Future<void> _onDeleteAll(
    DeleteAllMedicines event,
    Emitter<MedicinesState> emit,
  ) async {
    final total = state.allMedicines.length;
    if (total == 0) return;

    emit(state.copyWith(
      isLoadingAction: true, 
      bulkActionProgress: 0.0,
      bulkActionTitle: 'جاري حذف كافة الأدوية بالمخزن...',
    ));

    try {
      // إذا كان عدد الأدوية كبيراً جداً، نقوم بالحذف على دفعات لإظهار التقدم وتجنب التهنيج
      if (total > 50) {
        final allList = state.allMedicines.toList();
        for (int i = 0; i < total; i++) {
          await BranchDataService.deleteMedicine(allList[i]);
          
          if (i % 10 == 0 || i == total - 1) {
            emit(state.copyWith(bulkActionProgress: (i + 1) / total));
            await Future.delayed(Duration.zero);
          }
        }
      } else {
        final allList = state.allMedicines.toList();
        for (int i = 0; i < total; i++) {
          await BranchDataService.deleteMedicine(allList[i]);
        }
      }

      emit(state.copyWith(isLoadingAction: false, bulkActionProgress: 1.0, selectedIds: const {}));
      SoundService.instance.play(SoundEffect.error);
      AppSnackbar.success('تم حذف كل الأدوية بنجاح', title: 'نجح');
      if (!isClosed) add(const LoadMedicines());
    } catch (e) {
      SoundService.instance.play(SoundEffect.error);
      AppSnackbar.error('فشل في حذف كل الأدوية: $e', title: 'خطأ');
      emit(state.copyWith(isLoadingAction: false, bulkActionProgress: 0));
    }
  }

  Future<void> _onAdjustQuantity(
    AdjustMedicineQuantity event,
    Emitter<MedicinesState> emit,
  ) async {
    final oldQty = event.medicine.quantity;
    final newQty = event.newQuantity;
    final diff = newQty - oldQty;
    if (diff == 0) return;

    await _performAction(
      emit,
      action: () async {
        // تحريك الكمية عبر StockMutationService (القفل + طابور المزامنة)
        await StockMutationService.adjustStock(
          medicineId: event.medicine.id,
          delta: diff,
          branchId: event.medicine.branchId,
        );
        // تسجيل حركة التسوية في سجل الحركات (audit trail)
        final now = DateTime.now();
        await InventoryTransactionService.to.adjustStock(
          adjustment: StockAdjustmentModel(
            id: 'adj_${now.millisecondsSinceEpoch}',
            pharmacyId: event.medicine.branchId,
            branchId: event.medicine.branchId,
            adjustmentNumber: 'ADJ-${now.millisecondsSinceEpoch}',
            adjustmentDate: now,
            createdAt: now,
            updatedAt: now,
            createdById: AuthService.currentUser?.id,
            createdByName: AuthService.currentUser?.name,
            items: [
              StockAdjustmentItemModel(
                id: event.medicine.id,
                itemId: event.medicine.id,
                itemName: event.medicine.name,
                quantity: diff.abs().toDouble(),
                type: diff > 0
                    ? AdjustmentType.addition
                    : AdjustmentType.reduction,
                reason: AdjustmentReason.other,
                unitCost: event.medicine.buyPrice,
              ),
            ],
          ),
          actorId: AuthService.currentUser?.id ?? '',
        );
      },
      successMessage: 'تم تسوية رصيد "${event.medicine.name}" بنجاح',
      errorMessage: 'فشل في تسوية الرصيد',
    );
  }

  Future<void> _onImportExcel(
    ImportMedicinesFromExcel event,
    Emitter<MedicinesState> emit,
  ) async {
    emit(state.copyWith(
      isLoadingAction: true, 
      bulkActionProgress: 0, 
      bulkActionTitle: 'جاري استيراد البيانات من Excel...',
    ));
    try {
      final count = await ExcelImportService.importFromExcel(
        event.fileBytes != null ? null : event.filePath,
        fileBytes: event.fileBytes,
        onProgress: (p) {
          if (!isClosed) add(UpdateImportProgress(p));
        },
      );
      SoundService.instance.play(SoundEffect.itemAdded);
      AppSnackbar.success('تم استيراد $count صنف بنجاح', title: 'نجح');
      emit(state.copyWith(isLoadingAction: false, bulkActionProgress: 1.0));
      if (!isClosed) add(const LoadMedicines());
    } catch (e) {
      SoundService.instance.play(SoundEffect.error);
      AppSnackbar.error('فشل الاستيراد: $e', title: 'خطأ');
      emit(state.copyWith(isLoadingAction: false, bulkActionProgress: 0));
    }
  }

  void _onUpdateImportProgress(UpdateImportProgress event, Emitter<MedicinesState> emit) {
    emit(state.copyWith(bulkActionProgress: event.progress));
  }

  // ════════════════ Helpers ════════════════
  Future<void> _performAction(
    Emitter<MedicinesState> emit, {
    required Future<void> Function() action,
    required String successMessage,
    required String errorMessage,
    SoundEffect? soundEffect,
  }) async {
    emit(state.copyWith(isLoadingAction: true));
    try {
      await action();
      if (soundEffect != null) SoundService.instance.play(soundEffect);
      AppSnackbar.success(successMessage, title: 'نجح');
      
      // نتحقق من حالة الـ Bloc قبل إضافة الحدث
      if (!isClosed) {
        try {
          add(const LoadMedicines());
        } catch (e) {
          safeDebugPrint('MedicinesBloc: Failed to add LoadMedicines: $e');
        }
      }
    } catch (e) {
      if (isClosed) return;
      SoundService.instance.play(SoundEffect.error);
      AppSnackbar.error('$errorMessage: $e', title: 'خطأ');
      emit(state.copyWith(isLoadingAction: false));
    }
  }

  List<MedicineModel> _applyFilterAndSort(
    List<MedicineModel> list, {
    String? query,
    String? filter,
    String? category,
    String? sortColumnId,
    bool? ascending,
  }) {
    final rawQuery = (query ?? state.searchQuery).trim();
    final q = rawQuery.toLowerCase();
    final f = filter ?? state.selectedFilter;
    final cat = category ?? state.selectedCategory;
    final col = sortColumnId ?? state.sortColumnId;
    final asc = ascending ?? state.isSortAscending;

    var result = list;

    if (q.isNotEmpty) {
      result = result.where((m) => _isMatch(m, q)).toList();
    }

    if (cat != null && cat != 'الكل') {
      result = result.where((m) => m.category == cat).toList();
    }

    final now = DateTime.now();
    final threshold = now.add(const Duration(days: _expiringThresholdDays));
    switch (f) {
      case 'low_stock':
        result = result
            .where((m) => m.alertEnabled && m.quantity <= m.minStock && m.quantity > 0)
            .toList();
        break;
      case 'out_of_stock':
        result = result.where((m) => m.quantity <= 0).toList();
        break;
      case 'expiring':
        result = result.where((m) => _isExpiring(m, now, threshold)).toList();
        break;
      case 'expired':
        result = result.where((m) => _isExpired(m, now)).toList();
        break;
    }

    if (col != null) {
      // تحسين أداء الترتيب: نقوم بالترتيب فقط عند الحاجة
      final sortedList = List<MedicineModel>.from(result);
      sortedList.sort((a, b) => _compareByColumn(col, a, b));
      result = asc ? sortedList : sortedList.reversed.toList();
    }

    return result;
  }

  bool _isMatch(MedicineModel m, String query) {
    // بحث ذكي وشامل (الاسم، الاسم الأجنبي، الباركود، الفئة، الشركة، المكان)
    if (m.name.toLowerCase().contains(query)) return true;
    if (m.nameEn?.toLowerCase().contains(query) ?? false) return true;
    
    // البحث في قائمة الباركودات الرئيسية
    if (m.barcodes.any((b) => b.toLowerCase().contains(query))) return true;
    
    // البحث في باركودات الوحدات (fallback)
    if (m.units.any((u) => u.barcode?.toLowerCase().contains(query) ?? false)) return true;

    if (m.category?.toLowerCase().contains(query) ?? false) return true;
    if (m.manufacturer?.toLowerCase().contains(query) ?? false) return true;
    if (m.location?.toLowerCase().contains(query) ?? false) return true;
    
    return false;
  }

  bool _isExpiring(MedicineModel m, DateTime now, DateTime threshold) {
    return m.expiryTrackingEnabled &&
        m.expiryDate != null &&
        m.expiryDate!.isAfter(now) &&
        m.expiryDate!.isBefore(threshold);
  }

  bool _isExpired(MedicineModel m, DateTime now) {
    return m.expiryTrackingEnabled &&
        m.expiryDate != null &&
        m.expiryDate!.isBefore(now);
  }

  int _compareByColumn(String col, MedicineModel a, MedicineModel b) {
    switch (col) {
      case 'name':
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      case 'barcode':
        final ba = a.barcodes.firstOrNull ?? a.units.firstOrNull?.barcode ?? '';
        final bb = b.barcodes.firstOrNull ?? b.units.firstOrNull?.barcode ?? '';
        return ba.compareTo(bb);
      case 'category':
        return (a.category ?? '').compareTo(b.category ?? '');
      case 'location':
        return (a.location ?? '').compareTo(b.location ?? '');
      case 'sellPrice':
        return a.sellPrice.compareTo(b.sellPrice);
      case 'quantity':
        return a.quantity.compareTo(b.quantity);
      case 'expiry':
        if (a.expiryDate == null && b.expiryDate == null) return 0;
        if (a.expiryDate == null) return 1;
        if (b.expiryDate == null) return -1;
        return a.expiryDate!.compareTo(b.expiryDate!);
      case 'createdDate':
      case 'createdTime':
        final ca = a.createdAt ?? DateTime(0);
        final cb = b.createdAt ?? DateTime(0);
        return ca.compareTo(cb);
      default:
        return 0;
    }
  }

  List<MedicineModel> _paginate(List<MedicineModel> list, int page, int pageSize) {
    if (list.isEmpty) return const [];
    final start = (page * pageSize).clamp(0, list.length);
    final end = (start + pageSize).clamp(0, list.length);
    return list.sublist(start, end);
  }

  int _computePages(int total, int pageSize) {
    if (pageSize <= 0) return 1;
    return (total / pageSize).ceil().clamp(1, 1000000);
  }
}

