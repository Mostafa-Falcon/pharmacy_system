import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_strings.dart';
import 'package:pharmacy_system/app/core/data/services/excel_import_service.dart';
import 'import_medicines_event.dart';
import 'import_medicines_state.dart';

/// Bloc شاشة استيراد الأدوية من Excel — يعتمد على [ExcelImportService]
/// ويرفع التقدم والنتيجة للواجهة بشكل تفاعلي.
class ImportMedicinesBloc extends Bloc<ImportMedicinesEvent, ImportMedicinesState> {
  ImportMedicinesBloc() : super(const ImportMedicinesState()) {
    on<PickAndImportMedicines>(_onPickAndImport);
    on<ResetImport>(_onReset);
  }

  Future<void> _onPickAndImport(
    PickAndImportMedicines event,
    Emitter<ImportMedicinesState> emit,
  ) async {
    if (state.status == ImportMedicinesStatus.importing) return;

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls'],
      withData: true,
    );

    if (result == null || result.files.isEmpty) return;
    final file = result.files.single;
    final bytes = file.bytes;
    if (bytes == null) return;

    emit(state.copyWith(
      status: ImportMedicinesStatus.importing,
      progress: 0.0,
      fileName: file.name,
      hasError: false,
      resultMessage: null,
      itemsFound: 0,
      itemsSaved: 0,
      itemsUpdated: 0,
      itemsSkipped: 0,
    ));

    try {
      final count = await ExcelImportService.importFromExcel(
        null,
        fileBytes: bytes,
        onProgress: (p) => emit(state.copyWith(progress: p)),
        onStep: (stepInfo) {
          double stageProgress = 0.0;
          
          if (stepInfo.step == 'reading') {
            stageProgress = 0.05;
          } else if (stepInfo.step == 'parsing') {
            final subProgress = stepInfo.itemsFound > 0 
                ? (stepInfo.itemsParsed / stepInfo.itemsFound) 
                : 0.0;
            stageProgress = 0.05 + (subProgress * 0.45);
          } else if (stepInfo.step == 'saving') {
            final subProgress = stepInfo.itemsFound > 0 
                ? (stepInfo.itemsSaved / stepInfo.itemsFound) 
                : 0.0;
            stageProgress = 0.50 + (subProgress * 0.50);
          } else if (stepInfo.step == 'done') {
            stageProgress = 1.0;
          }

          emit(state.copyWith(
            currentStep: stepInfo.step,
            itemsFound: stepInfo.itemsFound,
            itemsParsed: stepInfo.itemsParsed,
            itemsSaved: stepInfo.itemsSaved,
            itemsUpdated: stepInfo.itemsUpdated,
            itemsSkipped: stepInfo.itemsSkipped,
            progress: stageProgress,
          ));
        },
      );
      if (count > 0) {
        emit(state.copyWith(
          status: ImportMedicinesStatus.success,
          progress: 1.0,
          currentStep: 'done',
          resultMessage: '${InventoryStrings.importSuccessPrefix}$count${InventoryStrings.importSuccessSuffix}',
          hasError: false,
          itemsFound: count,
        ));
      } else {
        emit(state.copyWith(
          status: ImportMedicinesStatus.error,
          progress: 1.0,
          resultMessage: InventoryStrings.importNoData,
          hasError: true,
          currentStep: null,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: ImportMedicinesStatus.error,
        progress: 1.0,
        resultMessage: '${InventoryStrings.importFailPrefix}$e',
        hasError: true,
        currentStep: null,
      ));
    }
  }

  void _onReset(ResetImport event, Emitter<ImportMedicinesState> emit) {
    emit(const ImportMedicinesState());
  }
}




