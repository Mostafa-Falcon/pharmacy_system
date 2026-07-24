import 'package:equatable/equatable.dart';

abstract class ImportMedicinesEvent extends Equatable {
  const ImportMedicinesEvent();

  @override
  List<Object?> get props => [];
}

/// اختيار ملف Excel واستيراده
class PickAndImportMedicines extends ImportMedicinesEvent {
  const PickAndImportMedicines();
}

/// إعادة ضبط حالة الاستيراد
class ResetImport extends ImportMedicinesEvent {
  const ResetImport();
}


