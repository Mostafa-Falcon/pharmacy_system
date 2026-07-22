import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:pharmacy_system/app/core/data/services/auth/password_hasher.dart';

void main() {
  group('PasswordHasher', () {
    test('hash produces consistent format', () async {
      final hash = await PasswordHasher.hash('TestPass123!');
      expect(hash, contains(':'));
      final parts = hash.split(':');
      expect(parts.length, 3);
      expect(int.tryParse(parts[0]), isNotNull);
      expect(base64Decode(parts[2]).length, greaterThan(0));
    });

    test('same password produces different salts', () async {
      final hash1 = await PasswordHasher.hash('SamePass');
      final hash2 = await PasswordHasher.hash('SamePass');
      expect(hash1, isNot(hash2));
    });

    test('verify returns true for correct password', () async {
      final hash = await PasswordHasher.hash('CorrectPass');
      final result = await PasswordHasher.verify('CorrectPass', hash);
      expect(result, true);
    });

    test('verify returns false for wrong password', () async {
      final hash = await PasswordHasher.hash('CorrectPass');
      final result = await PasswordHasher.verify('WrongPass', hash);
      expect(result, false);
    });

    test('verify returns false for malformed hash', () async {
      final result = await PasswordHasher.verify('pass', 'not-a-valid-hash');
      expect(result, false);
    });

    test('empty password can be hashed and verified', () async {
      final hash = await PasswordHasher.hash('');
      expect(await PasswordHasher.verify('', hash), true);
      expect(await PasswordHasher.verify('x', hash), false);
    });
  });
}
