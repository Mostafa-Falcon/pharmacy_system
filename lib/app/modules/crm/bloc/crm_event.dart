import 'package:equatable/equatable.dart';
import 'package:pharmacy_system/app/modules/crm/models/crm_model.dart';

abstract class CrmEvent extends Equatable {
  const CrmEvent();

  @override
  List<Object?> get props => [];
}

class LoadCrmLeads extends CrmEvent {
  const LoadCrmLeads();
}

class AddCrmLead extends CrmEvent {
  final String name;
  final String? phone;
  final String? email;
  final String? source;
  final String? notes;

  const AddCrmLead({
    required this.name,
    this.phone,
    this.email,
    this.source,
    this.notes,
  });

  @override
  List<Object?> get props => [name, phone, email, source, notes];
}

class UpdateCrmLead extends CrmEvent {
  final CrmLeadModel lead;
  const UpdateCrmLead(this.lead);

  @override
  List<Object?> get props => [lead];
}

class UpdateCrmLeadStatus extends CrmEvent {
  final CrmLeadModel lead;
  final CrmLeadStatus status;

  const UpdateCrmLeadStatus(this.lead, this.status);

  @override
  List<Object?> get props => [lead, status];
}

class AddCrmFollowUp extends CrmEvent {
  final CrmLeadModel lead;
  final String notes;
  final DateTime followUpDate;

  const AddCrmFollowUp({required this.lead, required this.notes, required this.followUpDate});

  @override
  List<Object?> get props => [lead, notes, followUpDate];
}

class SearchCrmLeads extends CrmEvent {
  final String query;
  const SearchCrmLeads(this.query);

  @override
  List<Object?> get props => [query];
}



