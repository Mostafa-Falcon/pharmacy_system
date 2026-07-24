import 'package:pharmacy_system/app/modules/crm/models/crm_model.dart';
import 'package:pharmacy_system/app/core/sync/sync_service.dart';

class CrmService {
  static const String leadsBox = 'crm_leads';
  static const String followUpsBox = 'crm_followups';

  static Future<List<CrmLeadModel>> getLeads(String branchId) async {
    final data = await SyncService.getLocalData(
      boxName: leadsBox,
      branchId: branchId,
    );
    return data.whereType<CrmLeadModel>().where((e) => !e.isDeleted).toList();
  }

  static Future<void> addLead(CrmLeadModel lead) async {
    lead.lastModified = DateTime.now();
    await SyncService.create(
      boxName: leadsBox,
      entity: lead,
      branchId: lead.branchId,
      toJson: lead.toJson(),
    );
  }

  static Future<void> updateLead(CrmLeadModel lead) async {
    lead.lastModified = DateTime.now();
    await SyncService.update(
      boxName: leadsBox,
      entity: lead,
      branchId: lead.branchId,
      toJson: lead.toJson(),
    );
  }

  static Future<Map<String, int>> getStats(String branchId) async {
    final leads = await getLeads(branchId);

    return {
      'total': leads.length,
      'new': leads.where((l) => l.status == CrmLeadStatus.newLead).length,
      'contacted': leads
          .where((l) => l.status == CrmLeadStatus.contacted)
          .length,
      'interested': leads
          .where((l) => l.status == CrmLeadStatus.interested)
          .length,
      'converted': leads
          .where((l) => l.status == CrmLeadStatus.converted)
          .length,
      'lost': leads.where((l) => l.status == CrmLeadStatus.notInterested).length,
    };
  }

  static Future<List<CrmLeadModel>> search(String query, String branchId) async {
    final leads = await getLeads(branchId);
    final q = query.toLowerCase();
    return leads
        .where((l) =>
            l.name.toLowerCase().contains(q) ||
            (l.phone?.toLowerCase().contains(q) ?? false))
        .toList();
  }

  static Future<void> deleteLead(CrmLeadModel lead) async {
    lead.isDeleted = true;
    lead.lastModified = DateTime.now();
    await SyncService.softDelete(
      boxName: leadsBox,
      key: lead.id,
      branchId: lead.branchId,
      currentData: lead.toJson(),
    );
  }

  static Future<void> leadWon(CrmLeadModel lead) async {
    lead.status = CrmLeadStatus.converted;
    await updateLead(lead);
  }

  static Future<void> leadLost(CrmLeadModel lead) async {
    lead.status = CrmLeadStatus.notInterested;
    await updateLead(lead);
  }
}




