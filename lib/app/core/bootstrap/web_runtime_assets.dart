import 'package:flutter/foundation.dart' show kReleaseMode, kIsWeb;
import 'package:http/http.dart' as http;

import 'package:pharmacy_system/app/core/utils/app_utils.dart';

Future<void> validateWebRuntimeAssets() async {
  if (!kIsWeb || kReleaseMode) return;

  const requiredAssets = <String, String>{
    'sqlite3.wasm': 'application/wasm',
    'drift_worker.js': 'javascript',
  };

  for (final entry in requiredAssets.entries) {
    final uri = Uri.base.resolve(entry.key);
    try {
      final response = await http.get(
        uri,
        headers: const {'Cache-Control': 'no-cache'},
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode < 200 || response.statusCode >= 300) {
        safeDebugPrint('Web runtime asset missing: ${entry.key} (status ${response.statusCode})');
        continue;
      }

      if (entry.key.endsWith('.wasm')) {
        final contentType = response.headers['content-type'] ?? '';
        if (!contentType.toLowerCase().contains(entry.value)) {
          safeDebugPrint('${entry.key} has invalid Content-Type: $contentType');
        }
      }
    } catch (e) {
      safeDebugPrint('Web runtime asset check failed for ${entry.key}: $e');
    }
  }
}
