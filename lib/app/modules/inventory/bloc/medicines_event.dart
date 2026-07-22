import 'dart:typed_data';
import 'package:equatable/equatable.dart';
import 'package:pharmacy_system/app/modules/inventory/models/medicine_model.dart';

abstract class MedicinesEvent extends Equatable {
  const MedicinesEvent();

  @override
  List<Object?> get props => [];
}

/// تحميل قائمة الأدوية (يدوي أو عند فتح الشاشة)
class LoadMedicines extends MedicinesEvent {
  const LoadMedicines();
}

/// تغيير نص البحث
class SearchMedicines extends MedicinesEvent {
  final String query;
  const SearchMedicines(this.query);

  @override
  List<Object?> get props => [query];
}

/// تغيير الفلتر السريع (all, low_stock, out_of_stock, expiring, expired)
class FilterMedicines extends MedicinesEvent {
  final String filter;
  const FilterMedicines(this.filter);

  @override
  List<Object?> get props => [filter];
}

/// تصفية حسب التصنيف
class FilterByCategory extends MedicinesEvent {
  final String? category;
  const FilterByCategory(this.category);

  @override
  List<Object?> get props => [category];
}

/// تغيير ترتيب العمود
class SortMedicines extends MedicinesEvent {
  final String columnId;
  const SortMedicines(this.columnId);

  @override
  List<Object?> get props => [columnId];
}

/// تغيير حجم الصفحة
class ChangePageSize extends MedicinesEvent {
  final int pageSize;
  const ChangePageSize(this.pageSize);

  @override
  List<Object?> get props => [pageSize];
}

/// الانتقال لصفحة محددة
class GoToPage extends MedicinesEvent {
  final int page;
  const GoToPage(this.page);

  @override
  List<Object?> get props => [page];
}

/// الصفحة التالية
class NextPage extends MedicinesEvent {
  const NextPage();
}

/// الصفحة السابقة
class PreviousPage extends MedicinesEvent {
  const PreviousPage();
}

/// تحديد/إلغاء تحديد صف (للعمليات المتعددة)
class ToggleSelectRow extends MedicinesEvent {
  final String id;
  const ToggleSelectRow(this.id);

  @override
  List<Object?> get props => [id];
}

/// تحديد/إلغاء تحديد الكل في الصفحة الحالية
class ToggleSelectAll extends MedicinesEvent {
  final bool selectAll;
  const ToggleSelectAll(this.selectAll);

  @override
  List<Object?> get props => [selectAll];
}

/// إضافة دواء جديد
class AddMedicine extends MedicinesEvent {
  final MedicineModel medicine;
  const AddMedicine(this.medicine);

  @override
  List<Object?> get props => [medicine];
}

/// تحديث دواء موجود
class UpdateMedicine extends MedicinesEvent {
  final MedicineModel medicine;
  const UpdateMedicine(this.medicine);

  @override
  List<Object?> get props => [medicine];
}

/// حذف دواء مفرد
class DeleteMedicine extends MedicinesEvent {
  final MedicineModel medicine;
  const DeleteMedicine(this.medicine);

  @override
  List<Object?> get props => [medicine];
}

/// حذف الأدوية المحددة (عملية مجمعة)
class DeleteSelectedMedicines extends MedicinesEvent {
  const DeleteSelectedMedicines();
}

/// حذف كل الأدوية
class DeleteAllMedicines extends MedicinesEvent {
  const DeleteAllMedicines();
}

/// تسوية (تعديل) كمية دواء مباشرة
class AdjustMedicineQuantity extends MedicinesEvent {
  final MedicineModel medicine;
  final int newQuantity;
  const AdjustMedicineQuantity(this.medicine, this.newQuantity);

  @override
  List<Object?> get props => [medicine, newQuantity];
}

/// استيراد أدوية من ملف Excel
class ImportMedicinesFromExcel extends MedicinesEvent {
  final String? filePath;
  final Uint8List? fileBytes;
  const ImportMedicinesFromExcel({this.filePath, this.fileBytes});

  @override
  List<Object?> get props => [filePath, fileBytes];
}

/// تحديث نسبة تقدم الاستيراد
class UpdateImportProgress extends MedicinesEvent {
  final double progress;
  const UpdateImportProgress(this.progress);

  @override
  List<Object?> get props => [progress];
}

