import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacy_system/app/shared/constants/strings/app_strings.dart';
import 'import_data_event.dart';
import 'import_data_state.dart';
import 'package:pharmacy_system/app/core/models/inventory/import_step_info.dart';

class ImportDataBloc extends Bloc<ImportDataEvent, ImportDataState> {
  ImportDataBloc() : super(const ImportDataState()) {
    on<PickAndImportData>(_onPickAndImport);
    on<ResetImportData>(_onReset);
  }

  Future<void> _onPickAndImport(
    PickAndImportData event,
    Emitter<ImportDataState> emit,
  ) async {
    if (state.status == ImportDataStatus.importing) return;

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls'],
      withData: true,
    );

    if (result == null || result.files.isEmpty) return;
    final file = result.files.single;
    final bytes = file.bytes;
    if (bytes == null) return;

    emit(
      state.copyWith(
        status: ImportDataStatus.importing,
        progress: 0.0,
        fileName: file.name,
        hasError: false,
        resultMessage: null,
        itemsFound: 0,
        itemsSaved: 0,
        itemsUpdated: 0,
        itemsSkipped: 0,
      ),
    );

    try {
      int count;
      switch (event.entityType) {
        case ImportEntityType.medicines:
          count = await ExcelImportService.importFromExcel(
            null,
            fileBytes: bytes,
            onProgress: (p) => emit(state.copyWith(progress: p)),
            onStep: (stepInfo) => _emitStep(emit, stepInfo),
          );
          break;
        case ImportEntityType.customers:
          count = await ExcelImportService.importCustomersFromExcel(
            null,
            fileBytes: bytes,
            onProgress: (p) => emit(state.copyWith(progress: p)),
            onStep: (stepInfo) => _emitStep(emit, stepInfo),
          );
          break;
        case ImportEntityType.suppliers:
          count = await ExcelImportService.importSuppliersFromExcel(
            null,
            fileBytes: bytes,
            onProgress: (p) => emit(state.copyWith(progress: p)),
            onStep: (stepInfo) => _emitStep(emit, stepInfo),
          );
          break;
        case ImportEntityType.expenses:
          count = await ExcelImportService.importExpensesFromExcel(
            null,
            fileBytes: bytes,
            onProgress: (p) => emit(state.copyWith(progress: p)),
            onStep: (stepInfo) => _emitStep(emit, stepInfo),
          );
          break;
        case ImportEntityType.sales:
          count = await ExcelImportService.importSalesFromExcel(
            null,
            fileBytes: bytes,
            onProgress: (p) => emit(state.copyWith(progress: p)),
            onStep: (stepInfo) => _emitStep(emit, stepInfo),
          );
          break;
        case ImportEntityType.products:
          count = await ExcelImportService.importProductsFromExcel(
            null,
            fileBytes: bytes,
            onProgress: (p) => emit(state.copyWith(progress: p)),
            onStep: (stepInfo) => _emitStep(emit, stepInfo),
          );
          break;
      }

      if (count > 0) {
        emit(
          state.copyWith(
            status: ImportDataStatus.success,
            progress: 1.0,
            currentStep: 'done',
            resultMessage: _successMessage(event.entityType, count),
            hasError: false,
            itemsFound: count,
            itemsSaved: count,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: ImportDataStatus.error,
            progress: 1.0,
            resultMessage: InventoryStrings.importNoData,
            hasError: true,
            currentStep: null,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: ImportDataStatus.error,
          progress: 1.0,
          resultMessage: '${InventoryStrings.importFailPrefix}$e',
          hasError: true,
          currentStep: null,
        ),
      );
    }
  }

  void _emitStep(Emitter<ImportDataState> emit, dynamic stepInfo) {
    if (stepInfo is ImportStepInfo) {
      emit(
        state.copyWith(
          currentStep: stepInfo.step,
          itemsFound: stepInfo.itemsFound,
          itemsSaved: stepInfo.itemsSaved,
          itemsUpdated: stepInfo.itemsUpdated,
          itemsSkipped: stepInfo.itemsSkipped,
        ),
      );
    } else if (stepInfo is Map) {
      emit(
        state.copyWith(
          currentStep: stepInfo['step'] as String?,
          itemsFound: stepInfo['itemsFound'] as int? ?? 0,
          itemsSaved: stepInfo['itemsSaved'] as int? ?? 0,
          itemsUpdated: stepInfo['itemsUpdated'] as int? ?? 0,
          itemsSkipped: stepInfo['itemsSkipped'] as int? ?? 0,
        ),
      );
    }
  }

  String _successMessage(ImportEntityType type, int count) {
    return switch (type) {
      ImportEntityType.medicines =>
        '${InventoryStrings.importSuccessPrefix}$count${InventoryStrings.importSuccessSuffix}',
      ImportEntityType.customers => 'تم استيراد $count عميل بنجاح',
      ImportEntityType.suppliers => 'تم استيراد $count مورد بنجاح',
      ImportEntityType.expenses => 'تم استيراد $count مصروف بنجاح',
      ImportEntityType.sales => 'تم استيراد $count فاتورة بنجاح',
      ImportEntityType.products => 'تم استيراد $count صنف بنجاح',
    };
  }

  void _onReset(ResetImportData event, Emitter<ImportDataState> emit) {
    emit(const ImportDataState());
  }
}
