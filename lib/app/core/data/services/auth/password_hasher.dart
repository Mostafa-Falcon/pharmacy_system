import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

class PasswordHasher {
  static const _saltLength = 16;
  static const _iterations = 100000;

  static Future<String> hash(String password) async {
    final salt = _generateSalt();
    final bytes = utf8.encode(password + salt);
    final hashedPassword = await _executeCryptoHash(bytes, salt, _iterations);
    return '$_iterations:$salt:${base64.encode(hashedPassword)}';
  }

  static Future<bool> verify(String password, String storedHash) async {
    final parts = storedHash.split(':');
    if (parts.length != 3) return false;

    final iterations = int.tryParse(parts[0]) ?? _iterations;
    final salt = parts[1];
    final expectedHash = base64.decode(parts[2]);

    final bytes = utf8.encode(password + salt);
    final hash = await _executeCryptoHash(bytes, salt, iterations);

    if (hash.length != expectedHash.length) return false;

    // حماية ضد هجمات التوقيت (Timing Attacks) أثناء مقارنة الهاش
    var result = 0;
    for (var i = 0; i < hash.length; i++) {
      result |= hash[i] ^ expectedHash[i];
    }
    return result == 0;
  }

  static String _generateSalt() {
    final random = Random.secure();
    final values = List<int>.generate(_saltLength, (_) => random.nextInt(256));
    return base64.encode(values);
  }

  // معالج الهاش المطور المحمي من مشاكل الـ sublist والـ RangeError للأبد
  static Future<List<int>> _executeCryptoHash(List<int> data, String salt, int iterations) async {
    final hmac = Hmac(sha256, utf8.encode(salt));
    var currentHash = hmac.convert(data).bytes;

    for (var i = 1; i < iterations; i++) {
      currentHash = hmac.convert(currentHash).bytes;
      // تسليم الحدث (yield) كل 1000 تكرار عشان ما يتجمدش الـ UI
      if (i % 1000 == 0) {
        await Future<void>.delayed(Duration.zero);
      }
    }
    return currentHash;
  }
}


