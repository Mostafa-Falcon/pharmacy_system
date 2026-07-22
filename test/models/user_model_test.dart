import 'package:flutter_test/flutter_test.dart';
import 'package:pharmacy_system/app/modules/auth/models/user_model.dart';

void main() {
  group('UserModel', () {
    test('fromJson creates valid model', () {
      final json = {
        'id': 'usr_001',
        'name': 'أحمد',
        'email': 'ahmed@test.com',
        'password_hash': '',
        'role': 'owner',
        'assigned_branch_id': 'br_001',
        'is_active': true,
        'created_at': DateTime.now().toIso8601String(),
      };
      final user = UserModel.fromJson(json);
      expect(user.id, 'usr_001');
      expect(user.name, 'أحمد');
      expect(user.isOwner, true);
    });

    test('copyWith updates fields', () {
      final now = DateTime.now();
      final user = UserModel(
        id: 'usr_001',
        name: 'أحمد',
        email: 'ahmed@test.com',
        passwordHash: 'hash123',
        role: UserRole.owner,
        assignedBranchId: 'br_001',
        isActive: true,
        createdAt: now,
      );
      final updated = user.copyWith(name: 'مصطفى', role: UserRole.employee);
      expect(updated.name, 'مصطفى');
      expect(updated.isEmployee, true);
      expect(updated.id, 'usr_001');
    });

    test('toJson produces correct map', () {
      final now = DateTime.now();
      final user = UserModel(
        id: 'usr_001',
        name: 'أحمد',
        email: 'ahmed@test.com',
        passwordHash: 'hash123',
        role: UserRole.owner,
        assignedBranchId: 'br_001',
        isActive: true,
        createdAt: now,
      );
      final json = user.toJson();
      expect(json['name'], 'أحمد');
      expect(json['email'], 'ahmed@test.com');
    });
  });
}
