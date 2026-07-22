import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacy_system/app/modules/crm/models/crm_model.dart';
import 'package:pharmacy_system/app/core/data/services/auth/auth_service.dart';
import 'package:pharmacy_system/app/core/data/services/crm/crm_service.dart';
import 'package:pharmacy_system/app/core/presentation/widgets/reusables/feedback/app_snackbar.dart';
import 'crm_event.dart';
import 'crm_state.dart';

class CrmBloc extends Bloc<CrmEvent, CrmState> {
  CrmBloc() : super(const CrmState()) {
    on<LoadCrmLeads>(_onLoad);
    on<AddCrmLead>(_onAdd);
    on<UpdateCrmLead>(_onUpdate);
    on<UpdateCrmLeadStatus>(_onUpdateStatus);
    on<AddCrmFollowUp>(_onAddFollowUp);
    on<SearchCrmLeads>(_onSearch);
    add(const LoadCrmLeads());
  }

  String get _branchId => AuthService.currentBranchId ?? '';
  String get _userId => AuthService.currentUser?.id ?? '';

  Future<void> _onLoad(LoadCrmLeads event, Emitter<CrmState> emit) async {
    emit(state.copyWith(status: CrmStatus.loading));
    try {
      final leads = await CrmService.getLeads(_branchId);
      final stats = CrmState.computeStats(leads);
      final filtered = CrmState.filterLeads(leads, state.searchQuery);
      emit(state.copyWith(
        status: CrmStatus.loaded,
        allLeads: leads,
        filteredLeads: filtered,
        stats: stats,
      ));
    } catch (e) {
      emit(state.copyWith(status: CrmStatus.error, error: e.toString()));
    }
  }

  Future<void> _onAdd(AddCrmLead event, Emitter<CrmState> emit) async {
    try {
      final lead = CrmLeadModel(
        id: 'crm_${DateTime.now().millisecondsSinceEpoch}',
        branchId: _branchId,
        name: event.name,
        phone: event.phone,
        email: event.email,
        status: CrmLeadStatus.newLead,
        source: event.source,
        notes: event.notes,
        assignedTo: _userId,
        createdAt: DateTime.now(),
      );
      await CrmService.addLead(lead);
      add(const LoadCrmLeads());
      AppSnackbar.success('تم إضافة العميل المحتمل');
    } catch (e) {
      AppSnackbar.error('فشل في الإضافة: $e');
    }
  }

  Future<void> _onUpdate(UpdateCrmLead event, Emitter<CrmState> emit) async {
    try {
      await CrmService.updateLead(event.lead);
      add(const LoadCrmLeads());
      AppSnackbar.success('تم تحديث البيانات');
    } catch (e) {
      AppSnackbar.error('فشل في التحديث: $e');
    }
  }

  Future<void> _onUpdateStatus(UpdateCrmLeadStatus event, Emitter<CrmState> emit) async {
    try {
      final updated = event.lead.copyWith(status: event.status);
      await CrmService.updateLead(updated);
      add(const LoadCrmLeads());
    } catch (e) {
      AppSnackbar.error('فشل في تحديث الحالة: $e');
    }
  }

  Future<void> _onAddFollowUp(AddCrmFollowUp event, Emitter<CrmState> emit) async {
    try {
      final updatedNotes = '${event.lead.notes ?? ''}\n[${event.followUpDate.toString().substring(0, 10)}] ${event.notes}';
      final updated = event.lead.copyWith(
        notes: updatedNotes,
        nextFollowUp: event.followUpDate,
        status: CrmLeadStatus.contacted,
      );
      await CrmService.updateLead(updated);
      add(const LoadCrmLeads());
      AppSnackbar.success('تم إضافة المتابعة');
    } catch (e) {
      AppSnackbar.error('فشل في إضافة المتابعة: $e');
    }
  }

  void _onSearch(SearchCrmLeads event, Emitter<CrmState> emit) {
    final filtered = CrmState.filterLeads(state.allLeads, event.query);
    emit(state.copyWith(searchQuery: event.query, filteredLeads: filtered));
  }
}

