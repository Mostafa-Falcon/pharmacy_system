import 'package:flutter_test/flutter_test.dart';
import 'package:pharmacy_system/app/core/data/services/sync/sync_engine.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SyncEngine Unit Tests', () {
    test('SyncEngine singleton instance initialization', () {
      final engine1 = SyncEngine.instance;
      final engine2 = SyncEngine.instance;
      expect(engine1, same(engine2));
      expect(engine1.isSyncing, false);
    });
  });
}
