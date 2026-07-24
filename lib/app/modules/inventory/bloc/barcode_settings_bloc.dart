import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pharmacy_system/app/shared/presentation/widgets/reusables/feedback/app_snackbar.dart';
import 'package:pharmacy_system/app/core/models/inventory/barcode_settings_model.dart';
import '../services/barcode_code_service.dart';
import '../services/barcode_settings_service.dart';
import 'barcode_settings_event.dart';
import 'barcode_settings_state.dart';

export 'barcode_settings_event.dart';
export 'barcode_settings_state.dart';

class BarcodeSettingsBloc extends Bloc<BarcodeSettingsEvent, BarcodeSettingsState> {
  BarcodeSettingsBloc() : super(const BarcodeSettingsState()) {
    on<LoadBarcodeSettings>(_onLoad);
    on<UpdatePrefix>(_onUpdatePrefix);
    on<UpdateSerialLength>(_onUpdateSerialLength);
    on<UpdateFormatIndex>(_onUpdateFormatIndex);
    on<UpdateLabelWidth>(_onUpdateLabelWidth);
    on<UpdateLabelHeight>(_onUpdateLabelHeight);
    on<ToggleShowPrice>(_onToggleShowPrice);
    on<ToggleShowName>(_onToggleShowName);
    on<ToggleShowBarcode>(_onToggleShowBarcode);
    on<UpdatePrintLayoutIndex>(_onUpdatePrintLayoutIndex);
    on<UpdateCopiesPerItem>(_onUpdateCopiesPerItem);
    on<UpdatePharmacyName>(_onUpdatePharmacyName);
    on<ToggleUsePharmacySignature>(_onToggleUsePharmacySignature);
    on<SaveBarcodeSettings>(_onSave);
  }

  Future<void> _onLoad(LoadBarcodeSettings event, Emitter<BarcodeSettingsState> emit) async {
    final s = await BarcodeSettingsService.getSettings();
    emit(BarcodeSettingsState.refreshPreview(BarcodeSettingsState(
      status: BarcodeSettingsStatus.loaded,
      prefix: s.prefix,
      serialLength: s.shortCodeLength,
      formatIndex: BarcodeGenerationFormat.values
          .indexOf(s.generationFormat)
          .clamp(0, 1),
      labelWidth: s.labelWidthMm,
      labelHeight: s.labelHeightMm,
      showPrice: s.showPrice,
      showName: s.showItemName,
      showBarcode: s.showHumanReadableCode,
      usePharmacySignature: s.usePharmacySignature,
      pharmacyName: s.pharmacyName,
      printLayoutIndex: BarcodePrintLayout.values
          .indexOf(s.printLayout)
          .clamp(0, 1),
      copiesPerItem: s.copiesPerItem,
    )));
  }

  void _onUpdatePrefix(UpdatePrefix event, Emitter<BarcodeSettingsState> emit) {
    emit(BarcodeSettingsState.refreshPreview(state.copyWith(prefix: event.value)));
  }

  void _onUpdateSerialLength(UpdateSerialLength event, Emitter<BarcodeSettingsState> emit) {
    emit(BarcodeSettingsState.refreshPreview(
        state.copyWith(serialLength: event.value)));
  }

  void _onUpdateFormatIndex(UpdateFormatIndex event, Emitter<BarcodeSettingsState> emit) {
    emit(BarcodeSettingsState.refreshPreview(
        state.copyWith(formatIndex: event.value)));
  }

  void _onUpdateLabelWidth(UpdateLabelWidth event, Emitter<BarcodeSettingsState> emit) {
    emit(BarcodeSettingsState.refreshPreview(
        state.copyWith(labelWidth: event.value)));
  }

  void _onUpdateLabelHeight(UpdateLabelHeight event, Emitter<BarcodeSettingsState> emit) {
    emit(BarcodeSettingsState.refreshPreview(
        state.copyWith(labelHeight: event.value)));
  }

  void _onToggleShowPrice(ToggleShowPrice event, Emitter<BarcodeSettingsState> emit) {
    emit(BarcodeSettingsState.refreshPreview(
        state.copyWith(showPrice: !state.showPrice)));
  }

  void _onToggleShowName(ToggleShowName event, Emitter<BarcodeSettingsState> emit) {
    emit(BarcodeSettingsState.refreshPreview(
        state.copyWith(showName: !state.showName)));
  }

  void _onToggleShowBarcode(ToggleShowBarcode event, Emitter<BarcodeSettingsState> emit) {
    emit(BarcodeSettingsState.refreshPreview(
        state.copyWith(showBarcode: !state.showBarcode)));
  }

  void _onUpdatePrintLayoutIndex(
      UpdatePrintLayoutIndex event, Emitter<BarcodeSettingsState> emit) {
    emit(BarcodeSettingsState.refreshPreview(
        state.copyWith(printLayoutIndex: event.value)));
  }

  void _onUpdateCopiesPerItem(
      UpdateCopiesPerItem event, Emitter<BarcodeSettingsState> emit) {
    emit(BarcodeSettingsState.refreshPreview(
        state.copyWith(copiesPerItem: event.value)));
  }

  void _onUpdatePharmacyName(
      UpdatePharmacyName event, Emitter<BarcodeSettingsState> emit) {
    emit(BarcodeSettingsState.refreshPreview(
        state.copyWith(pharmacyName: event.value)));
  }

  void _onToggleUsePharmacySignature(
      ToggleUsePharmacySignature event, Emitter<BarcodeSettingsState> emit) {
    emit(BarcodeSettingsState.refreshPreview(
        state.copyWith(usePharmacySignature: !state.usePharmacySignature)));
  }

  Future<void> _onSave(SaveBarcodeSettings event, Emitter<BarcodeSettingsState> emit) async {
    if (state.prefix.trim().isEmpty) {
      AppSnackbar.error('?????? ????? ????? ????????');
      return;
    }
    if (state.serialLength < 3 || state.serialLength > 10) {
      AppSnackbar.error('??? ???????? ??? ?? ???? ??? 3 ? 10 ?????');
      return;
    }

    emit(state.copyWith(status: BarcodeSettingsStatus.saving));
    try {
      final model = BarcodeSettingsModel(
        prefix: state.prefix.trim(),
        shortCodeLength: state.serialLength,
        generationFormat: state.generationFormat,
        lastSerial: 0,
        labelWidthMm: state.labelWidth,
        labelHeightMm: state.labelHeight,
        copiesPerItem: state.copiesPerItem,
        showPrice: state.showPrice,
        showItemName: state.showName,
        showUnitName: true,
        showHumanReadableCode: state.showBarcode,
        printLayout: state.printLayout,
        usePharmacySignature: state.usePharmacySignature,
        pharmacyName: state.pharmacyName.trim(),
      );
      await BarcodeSettingsService.save(model);
      emit(BarcodeSettingsState.refreshPreview(state.copyWith(
        status: BarcodeSettingsStatus.loaded,
      )));
      AppSnackbar.success('?? ??? ??????? ???????? ?????', title: '?? ?????');
    } catch (e) {
      AppSnackbar.error('??? ??? ????? ?????: $e');
      emit(state.copyWith(status: BarcodeSettingsStatus.error, error: e.toString()));
    }
  }
}





