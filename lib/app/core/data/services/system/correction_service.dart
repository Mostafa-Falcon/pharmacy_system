import 'package:drift/drift.dart';
import 'package:pharmacy_system/app/core/data/database/daos/system_dao.dart';
import 'package:pharmacy_system/app/core/data/database/database.dart';
import 'package:pharmacy_system/app/core/models/base/correction_model.dart';
import 'package:pharmacy_system/app/core/data/services/auth/auth_service.dart';
import 'package:pharmacy_system/app/core/injection.dart';
import 'package:pharmacy_system/app/shared/ui_core.dart';

/// 🔧 خدمة تسجيل وتتبع تاريخ العمليات والتعديلات (Corrections Service)
class CorrectionService {
  CorrectionService._();

  static SystemDao get _dao => sl<SystemDao>();

  /// تسجيل عملية جديدة في النظام
  static Future<void> record({
    required CorrectionReferenceType referenceType,
    required String referenceId,
    required CorrectionAction action,
    String? details,
  }) async {
    try {
      final user = AuthService.currentUser;
      final now = DateTime.now();
      
      final entry = CorrectionsTableCompanion.insert(
        id: '${now.microsecondsSinceEpoch}',
        referenceType: referenceType.name,
        referenceId: referenceId,
        action: action.name,
        userId: user?.id ?? 'system',
        userDisplayName: user?.name ?? 'النظام',
        timestamp: now,
        details: Value(details),
      );

      await _dao.insertCorrection(entry);
    } catch (e, s) {
      safeDebugPrint('CorrectionService.record failed: $e\n$s');
    }
  }

  /// جلب سلسلة التصحيحات لسجل معين
  static Future<List<CorrectionEntry>> getChain({
    required CorrectionReferenceType referenceType,
    required String referenceId,
  }) async {
    try {
      final rows = await _dao.getCorrectionsByReference(referenceType.name, referenceId);
      return rows.map(_toModel).toList();
    } catch (e) {
      safeDebugPrint('CorrectionService.getChain failed: $e');
      return [];
    }
  }

  /// جلب كل سجلات التصحيح (Activity Log)
  static Future<List<CorrectionEntry>> getAll({int limit = 100}) async {
    try {
      final rows = await _dao.getAllCorrections(limit: limit);
      return rows.map(_toModel).toList();
    } catch (e) {
      safeDebugPrint('CorrectionService.getAll failed: $e');
      return [];
    }
  }

  static CorrectionEntry _toModel(CorrectionsTableData d) {
    return CorrectionEntry(
      id: d.id,
      referenceType: CorrectionReferenceType.values.firstWhere(
        (v) => v.name == d.referenceType,
        orElse: () => CorrectionReferenceType.sale,
      ),
      referenceId: d.referenceId,
      action: CorrectionAction.values.firstWhere(
        (v) => v.name == d.action,
        orElse: () => CorrectionAction.modified,
      ),
      userId: d.userId,
      userDisplayName: d.userDisplayName,
      timestamp: d.timestamp,
      details: d.details,
    );
  }
}
