import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacy_system/app/shared/presentation/widgets/components/feedback/app_snackbar.dart';
import 'package:pharmacy_system/app/modules/admin/models/settings_model.dart';
import '../services/settings_service.dart';
import '../services/access_control_service.dart';

part 'settings_state.dart';
part 'settings_event.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsService _settingsService = SettingsService.to;
  final AccessControlService _access = AccessControlService.to;

  SettingsBloc() : super(SettingsState()) {
    on<LoadSettings>(_onLoad);
    on<SetActiveTab>(_onSetActiveTab);
    on<SetSearchQuery>(_onSetSearchQuery);
    on<UpdateProjectSettings>(_onUpdateProject);
    on<UpdateTaxSettings>(_onUpdateTax);
    on<UpdateItemsSettings>(_onUpdateItems);
    on<UpdateSalesSettings>(_onUpdateSales);
    on<UpdateSystemSettings>(_onUpdateSystem);
    on<UpdateEmailSettings>(_onUpdateEmail);
    on<UpdateSmsSettings>(_onUpdateSms);
    on<UpdateRewardsSettings>(_onUpdateRewards);
    on<UpdateShortcutsSettings>(_onUpdateShortcuts);
    on<UpdateExtraUnitsSettings>(_onUpdateExtraUnits);
    on<UpdateInvoiceLayoutSettings>(_onUpdateInvoiceLayout);
    add(const LoadSettings());
  }

  Future<void> _onLoad(LoadSettings event, Emitter<SettingsState> emit) async {
    emit(state.copyWith(status: SettingsStatus.loading, clearError: true));
    try {
      await _settingsService.load();
      emit(state.copyWith(status: SettingsStatus.loaded, settings: _settingsService.settings));
    } catch (e) {
      emit(state.copyWith(status: SettingsStatus.error, error: e.toString()));
    }
  }

  void _onSetActiveTab(SetActiveTab event, Emitter<SettingsState> emit) {
    emit(state.copyWith(activeTab: event.tab));
  }

  void _onSetSearchQuery(SetSearchQuery event, Emitter<SettingsState> emit) {
    emit(state.copyWith(searchQuery: event.query));
  }

  Future<void> _onUpdateProject(UpdateProjectSettings event, Emitter<SettingsState> emit) async {
    _access.require('settings.write');
    emit(state.copyWith(status: SettingsStatus.saving, clearError: true));
    try {
      await _settingsService.updateProject(event.updater);
      _markUpdated(emit);
    } catch (e) {
      emit(state.copyWith(status: SettingsStatus.loaded, error: e.toString()));
    }
  }

  Future<void> _onUpdateTax(UpdateTaxSettings event, Emitter<SettingsState> emit) async {
    _access.require('settings.write');
    emit(state.copyWith(status: SettingsStatus.saving, clearError: true));
    try {
      await _settingsService.updateTax(event.updater);
      _markUpdated(emit);
    } catch (e) {
      emit(state.copyWith(status: SettingsStatus.loaded, error: e.toString()));
    }
  }

  Future<void> _onUpdateItems(UpdateItemsSettings event, Emitter<SettingsState> emit) async {
    _access.require('settings.write');
    emit(state.copyWith(status: SettingsStatus.saving, clearError: true));
    try {
      await _settingsService.updateItems(event.updater);
      _markUpdated(emit);
    } catch (e) {
      emit(state.copyWith(status: SettingsStatus.loaded, error: e.toString()));
    }
  }

  Future<void> _onUpdateSales(UpdateSalesSettings event, Emitter<SettingsState> emit) async {
    _access.require('settings.write');
    emit(state.copyWith(status: SettingsStatus.saving, clearError: true));
    try {
      await _settingsService.updateSales(event.updater);
      _markUpdated(emit);
    } catch (e) {
      emit(state.copyWith(status: SettingsStatus.loaded, error: e.toString()));
    }
  }

  Future<void> _onUpdateSystem(UpdateSystemSettings event, Emitter<SettingsState> emit) async {
    _access.require('settings.write');
    emit(state.copyWith(status: SettingsStatus.saving, clearError: true));
    try {
      await _settingsService.updateSystem(event.updater);
      _markUpdated(emit);
    } catch (e) {
      emit(state.copyWith(status: SettingsStatus.loaded, error: e.toString()));
    }
  }

  Future<void> _onUpdateEmail(UpdateEmailSettings event, Emitter<SettingsState> emit) async {
    _access.require('settings.write');
    emit(state.copyWith(status: SettingsStatus.saving, clearError: true));
    try {
      await _settingsService.updateEmail(event.updater);
      _markUpdated(emit);
    } catch (e) {
      emit(state.copyWith(status: SettingsStatus.loaded, error: e.toString()));
    }
  }

  Future<void> _onUpdateSms(UpdateSmsSettings event, Emitter<SettingsState> emit) async {
    _access.require('settings.write');
    emit(state.copyWith(status: SettingsStatus.saving, clearError: true));
    try {
      await _settingsService.updateSms(event.updater);
      _markUpdated(emit);
    } catch (e) {
      emit(state.copyWith(status: SettingsStatus.loaded, error: e.toString()));
    }
  }

  Future<void> _onUpdateRewards(UpdateRewardsSettings event, Emitter<SettingsState> emit) async {
    _access.require('settings.write');
    emit(state.copyWith(status: SettingsStatus.saving, clearError: true));
    try {
      await _settingsService.updateRewards(event.updater);
      _markUpdated(emit);
    } catch (e) {
      emit(state.copyWith(status: SettingsStatus.loaded, error: e.toString()));
    }
  }

  Future<void> _onUpdateShortcuts(UpdateShortcutsSettings event, Emitter<SettingsState> emit) async {
    _access.require('settings.write');
    emit(state.copyWith(status: SettingsStatus.saving, clearError: true));
    try {
      await _settingsService.updateShortcuts(event.updater);
      _markUpdated(emit);
    } catch (e) {
      emit(state.copyWith(status: SettingsStatus.loaded, error: e.toString()));
    }
  }

  Future<void> _onUpdateInvoiceLayout(UpdateInvoiceLayoutSettings event, Emitter<SettingsState> emit) async {
    _access.require('settings.write');
    emit(state.copyWith(status: SettingsStatus.saving, clearError: true));
    try {
      await _settingsService.updateInvoiceLayout(event.updater);
      _markUpdated(emit);
    } catch (e) {
      emit(state.copyWith(status: SettingsStatus.loaded, error: e.toString()));
    }
  }

  Future<void> _onUpdateExtraUnits(UpdateExtraUnitsSettings event, Emitter<SettingsState> emit) async {
    _access.require('settings.write');
    emit(state.copyWith(status: SettingsStatus.saving, clearError: true));
    try {
      await _settingsService.updateExtraUnits(event.updater);
      _markUpdated(emit);
    } catch (e) {
      emit(state.copyWith(status: SettingsStatus.loaded, error: e.toString()));
    }
  }

  void _markUpdated(Emitter<SettingsState> emit) {
    final now = DateTime.now();
    final formatted = '${now.day}/${now.month}/${now.year} - ${now.hour}:${now.minute.toString().padLeft(2, '0')}';
    emit(state.copyWith(
      status: SettingsStatus.loaded,
      settings: _settingsService.settings,
      lastUpdated: formatted,
      clearError: true,
    ));
    AppSnackbar.success('?? ??? ????????? ?????', title: '?? ???????');
  }
}




