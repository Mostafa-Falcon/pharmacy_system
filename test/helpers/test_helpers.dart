import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pharmacy_system/app/core/data/database/database.dart';
import 'package:pharmacy_system/app/core/data/database/daos/sync_dao.dart';

/// مساعدات الاختبار العامة
class TestHelpers {
  /// إنشاء عميل Supabase وهمي للاختبار
  static SupabaseClient createMockSupabaseClient() {
    // للاختبارات، نستخدم العميل الفعلي مع anon key
    // أو يمكن استخدام mock إذا كان مطلوباً
    return SupabaseClient(
      'https://vhsngfalnltxnaiabvaa.supabase.co',
      'sb_publishable_xwoFSQD1HYMGfq1CerDnJQ_9DwWc83f',
    );
  }

  /// إنشاء قاعدة بيانات وهمية للاختبار
  static AppDatabase createMockAppDatabase() {
    // ملاحظة: في الاختبارات الفعلية، قد تحتاج إلى استخدام فئة وهمية أو
    // إعداد قاعدة بيانات في الذاكرة (in-memory)
    throw UnsupportedError(
      'Use real database or mock implementation for AppDatabase',
    );
  }

  /// إنشاء SyncDao وهمي للاختبار
  static SyncDao createMockSyncDao() {
    // ملاحظة: إرجاع null لأننا نحتاج AppDatabase حقيقي
    throw UnsupportedError(
      'Use real database or mock implementation for SyncDao',
    );
  }

  /// إنشاء نصف جاهز للتحويل إلى DateTime
  static DateTime parseDateTime(dynamic v) {
    if (v == null) return DateTime.fromMillisecondsSinceEpoch(0);
    if (v is DateTime) return v;
    final parsed = DateTime.tryParse(v.toString());
    return parsed ?? DateTime.fromMillisecondsSinceEpoch(0);
  }

  /// إنشاء معرف فريد للاختبار
  static String generateTestId([String prefix = 'test']) {
    return '$prefix-${DateTime.now().millisecondsSinceEpoch}';
  }
}
