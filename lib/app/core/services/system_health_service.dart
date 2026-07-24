import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase_pkg;
import 'package:pharmacy_system/app/core/data/database/daos/system_dao.dart';
import 'package:pharmacy_system/app/core/data/database/drift_init.dart';
import 'package:pharmacy_system/app/core/data/services/auth/auth_service.dart';
import 'package:pharmacy_system/app/core/data/services/lookup_service.dart';
import 'package:pharmacy_system/app/core/sync/sync_engine.dart';
import 'package:pharmacy_system/app/shared/ui_core.dart';

enum HealthStatus { healthy, degraded, down }

class SystemHealthResult {
  final HealthStatus status;
  final bool supabaseReachable;
  final bool localDbReady;
  final bool syncEngineRunning;
  final bool authActive;
  final bool servicesRegistered;
  final String? lastError;
  final DateTime checkTime;

  const SystemHealthResult({
    required this.status,
    required this.supabaseReachable,
    required this.localDbReady,
    required this.syncEngineRunning,
    required this.authActive,
    required this.servicesRegistered,
    this.lastError,
    required this.checkTime,
  });

  bool get isHealthy => status == HealthStatus.healthy;
  bool get isDegraded => status == HealthStatus.degraded;

  Map<String, dynamic> toJson() => {
    'status': status.name,
    'supabaseReachable': supabaseReachable,
    'localDbReady': localDbReady,
    'syncEngineRunning': syncEngineRunning,
    'authActive': authActive,
    'servicesRegistered': servicesRegistered,
    'lastError': lastError,
    'checkTime': checkTime.toIso8601String(),
  };
}

class SystemHealthService {
  static final SystemHealthService instance = SystemHealthService._();
  SystemHealthService._();

  final StreamController<SystemHealthResult> _healthController =
      StreamController<SystemHealthResult>.broadcast();

  Stream<SystemHealthResult> get healthStream => _healthController.stream;
  SystemHealthResult? _lastResult;
  SystemHealthResult? get lastResult => _lastResult;

  Future<SystemHealthResult> checkHealth({bool triggerSyncOnRecovery = true}) async {
    String? error;
    try {
      final connResult = await Connectivity().checkConnectivity();
      final hasNetwork = connResult != ConnectivityResult.none;

      bool supabaseOk = false;
      if (hasNetwork) {
        supabaseOk = await _checkSupabase();
      }

      bool dbOk = _checkDatabase();
      bool syncOk = _checkSyncEngine();
      bool authOk = _checkAuth();
      bool servicesOk = _checkServices();

      final checks = [supabaseOk, dbOk, syncOk, servicesOk];
      final failed = checks.where((c) => !c).length;

      HealthStatus status;
      if (failed == 0) {
        status = HealthStatus.healthy;
      } else if (failed <= 2) {
        status = HealthStatus.degraded;
      } else {
        status = HealthStatus.down;
      }

      final result = SystemHealthResult(
        status: status,
        supabaseReachable: supabaseOk,
        localDbReady: dbOk,
        syncEngineRunning: syncOk,
        authActive: authOk,
        servicesRegistered: servicesOk,
        lastError: error,
        checkTime: DateTime.now(),
      );

      _lastResult = result;
      _healthController.add(result);

      if (triggerSyncOnRecovery && status == HealthStatus.healthy) {
        _syncAfterRecovery();
      }

      return result;
    } catch (e, s) {
      safeDebugPrint('SystemHealthService.checkHealth error: $e\n$s');
      final result = SystemHealthResult(
        status: HealthStatus.down,
        supabaseReachable: false,
        localDbReady: false,
        syncEngineRunning: false,
        authActive: false,
        servicesRegistered: false,
        lastError: e.toString(),
        checkTime: DateTime.now(),
      );
      _lastResult = result;
      _healthController.add(result);
      return result;
    }
  }

  void _syncAfterRecovery() {
    try {
      final syncEngine = SyncEngine.instance;
      if (syncEngine.isOnline) {
        syncEngine.syncAll();
      }
    } catch (e, s) {
      safeDebugPrint('SystemHealthService._syncAfterRecovery error: $e\n$s');
    }
  }

  bool _checkDatabase() {
    try {
      appDatabase;
      return true;
    } catch (_) {
      return false;
    }
  }

  bool _checkSyncEngine() {
    try {
      return SyncEngine.instance.isOnline;
    } catch (_) {
      return false;
    }
  }

  bool _checkAuth() {
    try {
      return AuthService.currentUser != null;
    } catch (_) {
      return false;
    }
  }

  bool _checkServices() {
    try {
      final sl = GetIt.instance;
      return sl.isRegistered<SystemDao>() && sl.isRegistered<LookupService>();
    } catch (_) {
      return false;
    }
  }

  Future<bool> _checkSupabase() async {
    try {
      final client = supabase_pkg.Supabase.instance.client;
      await client.from('_health').select('1').limit(1).maybeSingle();
      return true;
    } catch (_) {
      try {
        final client = supabase_pkg.Supabase.instance.client;
        final session = client.auth.currentSession;
        return session != null;
      } catch (_) {
        return false;
      }
    }
  }

  Timer? _periodicCheckTimer;

  void startPeriodicChecks({Duration interval = const Duration(minutes: 5)}) {
    _periodicCheckTimer?.cancel();
    _periodicCheckTimer = Timer.periodic(interval, (_) {
      checkHealth();
    });
  }

  void stopPeriodicChecks() {
    _periodicCheckTimer?.cancel();
    _periodicCheckTimer = null;
  }

  void dispose() {
    stopPeriodicChecks();
    _healthController.close();
  }
}
