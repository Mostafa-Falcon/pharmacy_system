import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pharmacy_system/app/core/utils/app_utils.dart';

class SecureStorageHelper {
  SecureStorageHelper._();

  static const _storage = FlutterSecureStorage(
    webOptions: WebOptions(
      dbName: 'PharmacySystemSecureStorage',
      publicKey: 'PharmacySystemSecureStorageKey',
    ),
  );

  static const _credentialsKey = 'auth_credentials';
  static const _sessionKey = 'auth_session';
  static const _deviceIdKey = 'device_id';
  static const _branchIdKey = 'current_branch_id';
  static const _activeSessionPrefix = 'active_session_';

  static Future<void> saveCredentials({
    required String email,
    required String passwordHash,
  }) async {
    try {
      await _storage.write(
        key: _credentialsKey,
        value: jsonEncode({
          'email': email.trim(),
          'password_hash': passwordHash,
        }),
      );
    } catch (e) {
      safeDebugPrint('SecureStorage: saveCredentials failed — $e');
    }
  }

  static Future<Map<String, String>?> loadCredentials() async {
    try {
      final raw = await _storage.read(key: _credentialsKey);
      if (raw == null) return null;
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return {
        'email': map['email'] as String,
        'password_hash': map['password_hash'] as String,
      };
    } catch (e) {
      safeDebugPrint('SecureStorage: loadCredentials failed — $e');
      return null;
    }
  }

  static Future<void> clearCredentials() async {
    try {
      await _storage.delete(key: _credentialsKey);
    } catch (e) {
      safeDebugPrint('SecureStorage: clearCredentials failed — $e');
    }
  }

  static Future<void> saveSession(String sessionJson) async {
    try {
      await _storage.write(key: _sessionKey, value: sessionJson);
    } catch (e) {
      safeDebugPrint('SecureStorage: saveSession failed — $e');
    }
  }

  static Future<String?> loadSession() async {
    try {
      return await _storage.read(key: _sessionKey);
    } catch (e) {
      safeDebugPrint('SecureStorage: loadSession failed — $e');
      return null;
    }
  }

  static Future<void> clearSession() async {
    try {
      await _storage.delete(key: _sessionKey);
    } catch (e) {
      safeDebugPrint('SecureStorage: clearSession failed — $e');
    }
  }

  static Future<String?> getDeviceId() async {
    try {
      return await _storage.read(key: _deviceIdKey);
    } catch (e) {
      safeDebugPrint('SecureStorage: getDeviceId failed — $e');
      return null;
    }
  }

  static Future<void> saveDeviceId(String deviceId) async {
    try {
      await _storage.write(key: _deviceIdKey, value: deviceId);
    } catch (e) {
      safeDebugPrint('SecureStorage: saveDeviceId failed — $e');
    }
  }

  static Future<String?> getBranchId() async {
    try {
      return await _storage.read(key: _branchIdKey);
    } catch (e) {
      safeDebugPrint('SecureStorage: getBranchId failed — $e');
      return null;
    }
  }

  static Future<void> saveBranchId(String branchId) async {
    try {
      await _storage.write(key: _branchIdKey, value: branchId);
    } catch (e) {
      safeDebugPrint('SecureStorage: saveBranchId failed — $e');
    }
  }

  static Future<void> saveActiveSession(String userId, String deviceId) async {
    try {
      await _storage.write(key: '$_activeSessionPrefix$userId', value: deviceId);
    } catch (e) {
      safeDebugPrint('SecureStorage: saveActiveSession failed — $e');
    }
  }

  static Future<void> saveEncryptedValue(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
    } catch (e) {
      safeDebugPrint('SecureStorage: saveEncryptedValue failed — $e');
    }
  }

  static Future<String?> loadEncryptedValue(String key) async {
    try {
      return await _storage.read(key: key);
    } catch (e) {
      safeDebugPrint('SecureStorage: loadEncryptedValue failed — $e');
      return null;
    }
  }

  static Future<void> deleteEncryptedValue(String key) async {
    try {
      await _storage.delete(key: key);
    } catch (e) {
      safeDebugPrint('SecureStorage: deleteEncryptedValue failed — $e');
    }
  }

  static Future<void> clearActiveSession(String userId) async {
    try {
      await _storage.delete(key: '$_activeSessionPrefix$userId');
    } catch (e) {
      safeDebugPrint('SecureStorage: clearActiveSession failed — $e');
    }
  }

  static Future<void> clearAll() async {
    try {
      await _storage.deleteAll();
    } catch (e) {
      safeDebugPrint('SecureStorage: clearAll failed — $e');
    }
  }

  /// ????? ???????? ?? Map ??? SecureStorage (??? ?????)
  static Future<bool> migrateFromHive(Map<String, dynamic> data) async {
    try {
      final existing = await _storage.read(key: _credentialsKey);
      if (existing != null) return false;

      final hiveCredentials = data['credentials'] as String?;
      if (hiveCredentials != null) {
        await _storage.write(key: _credentialsKey, value: hiveCredentials);
      }

      final hiveSession = data['current_session'] as String?;
      if (hiveSession != null) {
        await _storage.write(key: _sessionKey, value: hiveSession);
      }

      final hiveDeviceId = data['device_id'] as String?;
      if (hiveDeviceId != null) {
        await _storage.write(key: _deviceIdKey, value: hiveDeviceId);
      }

      final hiveBranchId = data['current_branch_id'] as String?;
      if (hiveBranchId != null) {
        await _storage.write(key: _branchIdKey, value: hiveBranchId);
      }

      return true;
    } catch (e) {
      safeDebugPrint('SecureStorage: migrateFromHive failed — $e');
      return false;
    }
  }
}


