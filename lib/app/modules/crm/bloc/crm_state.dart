import 'package:equatable/equatable.dart';
import 'package:pharmacy_system/app/modules/crm/models/crm_model.dart';

enum CrmStatus { initial, loading, loaded, error }

class CrmState extends Equatable {
  final CrmStatus status;
  final List<CrmLeadModel> allLeads;
  final List<CrmLeadModel> filteredLeads;
  final String searchQuery;
  final Map<String, int> stats;
  final String? error;

  const CrmState({
    this.status = CrmStatus.initial,
    this.allLeads = const [],
    this.filteredLeads = const [],
    this.searchQuery = '',
    this.stats = const {},
    this.error,
  });

  CrmState copyWith({
    CrmStatus? status,
    List<CrmLeadModel>? allLeads,
    List<CrmLeadModel>? filteredLeads,
    String? searchQuery,
    Map<String, int>? stats,
    String? error,
    bool clearError = false,
  }) {
    return CrmState(
      status: status ?? this.status,
      allLeads: allLeads ?? this.allLeads,
      filteredLeads: filteredLeads ?? this.filteredLeads,
      searchQuery: searchQuery ?? this.searchQuery,
      stats: stats ?? this.stats,
      error: clearError ? null : (error ?? this.error),
    );
  }

  static Map<String, int> computeStats(List<CrmLeadModel> leads) {
    return {
      'total': leads.length,
      'new': leads.where((l) => l.status == CrmLeadStatus.newLead).length,
      'contacted': leads.where((l) => l.status == CrmLeadStatus.contacted).length,
      'interested': leads.where((l) => l.status == CrmLeadStatus.interested).length,
      'converted': leads.where((l) => l.status == CrmLeadStatus.converted).length,
      'notInterested': leads.where((l) => l.status == CrmLeadStatus.notInterested).length,
    };
  }

  static List<CrmLeadModel> filterLeads(List<CrmLeadModel> leads, String query) {
    if (query.isEmpty) return leads;
    final q = query.toLowerCase();
    return leads.where((l) =>
      l.name.toLowerCase().contains(q) ||
      (l.phone?.contains(q) ?? false) ||
      (l.source?.toLowerCase().contains(q) ?? false)
    ).toList();
  }

  @override
  List<Object?> get props => [status, allLeads, filteredLeads, searchQuery, stats, error];
}

