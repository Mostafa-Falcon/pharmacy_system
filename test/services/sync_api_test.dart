import 'package:flutter_test/flutter_test.dart';
import 'package:pharmacy_system/app/core/data/services/sync/sync_push_service.dart';
import 'package:pharmacy_system/app/core/data/services/sync/sync_pull_service.dart';
import 'package:pharmacy_system/app/core/data/services/sync/sync_dead_letter_service.dart';
import 'package:pharmacy_system/app/core/data/services/sync/sync_compaction_service.dart';
import 'package:pharmacy_system/app/core/data/services/sync/sync_engine.dart';

// اختبارات واجهة برمجة التطبيق (API) - بدون اتصال فعلي
void main() {
  group('Sync Service API Contract Tests', () {
    test('SyncPushService class exists', () {
      expect(SyncPushService, isNotNull);
    });

    test('SyncPullService class exists', () {
      expect(SyncPullService, isNotNull);
    });

    test('SyncDeadLetterService class exists', () {
      expect(SyncDeadLetterService, isNotNull);
    });

    test('SyncCompactionService class exists', () {
      expect(SyncCompactionService, isNotNull);
    });

    test('SyncEngine singleton exists', () {
      expect(SyncEngine.instance, isNotNull);
    });
  });
}
