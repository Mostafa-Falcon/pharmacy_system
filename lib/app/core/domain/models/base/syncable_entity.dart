/// واجهة موحّدة لكل النماذج القابلة للمزامنة مع Supabase.
///
/// يسمح ذلك لمحرك المزامنة بالتعامل مع أي نوع دون الحاجة لـ `if (entity is X)`
/// المتكررة في عشرات الأماكن.
abstract interface class SyncableEntity {
  /// معرّف الفرع المالك لهذا السجل.
  /// يُرجع `null` للنماذج غير المرتبطة بفرع (مثل: branches, users, permissions).
  String? get syncBranchId;

  /// آخر وقت تعديل — يُستخدم للـ Watermark والـ Conflict Shield.
  DateTime get lastModified;

  /// هل السجل محذوف ناعماً (soft-deleted)؟
  bool get isDeleted;
}

/// نموذج غير مرتبط بفرع (عالمي — مثل الفروع والمستخدمين والصلاحيات).
/// يُرجع `null` لـ `syncBranchId` لأنه لا ينتمي لفرع واحد.
abstract interface class GlobalSyncableEntity implements SyncableEntity {
  @override
  String? get syncBranchId => null;
}
