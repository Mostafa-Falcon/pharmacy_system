import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

void main() {
  const supabaseUrl = 'https://vhsngfalnltxnaiabvaa.supabase.co';
  const serviceRoleKey = String.fromEnvironment('SUPABASE_SERVICE_ROLE_KEY', defaultValue: '');

  late final SupabaseClient client;
  final testBranchId = 'test-branch-${const Uuid().v4().substring(0, 8)}';

  setUpAll(() {
    client = SupabaseClient(supabaseUrl, serviceRoleKey);
  });

  test(
    'End-to-end: create medicine appears in remote and keeps consistent',
    () async {
      final medicineId = 'sync-e2e-${const Uuid().v4()}';
      final payload = <String, dynamic>{
        'id': medicineId,
        'name': 'E2E Medicine',
        'name_en': 'E2E Medicine EN',
        'branch_id': testBranchId,
        'buy_price': 25,
        'sell_price': 50,
        'quantity': 200,
        'category': 'TestCategory',
        'barcodes': <String>['E2E-${const Uuid().v4()}'],
        'dosage_form': 'Tablet',
        'strength': '500mg',
        'package_size': '30',
        'expiry_tracking_enabled': true,
        'supplier_name': 'Test Supplier',
        'description': 'Sync E2E test',
        'old_sell_price': 45,
        'item_type_id': 'item-type-1',
        'group_id': 'group-1',
        'units': <dynamic>[],
        'alert_enabled': true,
        'dosage_form_enabled': true,
        'image_url': 'https://example.com/image.png',
        'container_shape': 'Bottle',
        'allow_negative_stock': false,
        'is_taxable': true,
        'tax_type': 'vat',
        'tax_value': 15,
        'prices_include_tax': false,
        'location': 'A1',
        'is_active': true,
        'is_deleted': false,
        'last_modified': DateTime.now().toIso8601String(),
        'sync_version': 1,
      };

      await client.from('medicines').upsert(payload);

      final fetched = await client
          .from('medicines')
          .select('*')
          .eq('id', medicineId)
          .single();
      expect(fetched['id'], medicineId);
      expect(fetched['name'], 'E2E Medicine');
      expect(fetched['name_en'], 'E2E Medicine EN');
      expect(fetched['branch_id'], testBranchId);

      final localLm = DateTime.parse(fetched['last_modified'] as String);
      final remoteLm = fetched['last_modified'] as Object?;

      expect(remoteLm, isNotNull);
      expect(
        localLm.isBefore(DateTime.now().add(const Duration(seconds: 5))),
        isTrue,
      );

      await client.from('medicines').delete().eq('id', medicineId);
    },
  );

  test('End-to-end: update medicine persists correctly', () async {
    final medicineId = 'sync-e2e-update-${const Uuid().v4()}';

    await client.from('medicines').upsert({
      'id': medicineId,
      'name': 'Before Update',
      'branch_id': testBranchId,
      'buy_price': 10,
      'sell_price': 20,
      'quantity': 50,
      'is_deleted': false,
    });

    final before = await client
        .from('medicines')
        .select('name, last_modified')
        .eq('id', medicineId)
        .single();
    final lmBefore = DateTime.parse(before['last_modified'] as String);

    await Future<void>.delayed(const Duration(seconds: 1));

    await client
        .from('medicines')
        .update({'name': 'After Update'})
        .eq('id', medicineId);

    final after = await client
        .from('medicines')
        .select('name, last_modified')
        .eq('id', medicineId)
        .single();
    expect(after['name'], 'After Update');
    final lmAfter = DateTime.parse(after['last_modified'] as String);
    expect(lmAfter.isAfter(lmBefore), isTrue);

    await client.from('medicines').delete().eq('id', medicineId);
  });

  test('End-to-end: soft delete sets is_deleted flag', () async {
    final medicineId = 'sync-e2e-delete-${const Uuid().v4()}';

    await client.from('medicines').upsert({
      'id': medicineId,
      'name': 'To Delete',
      'branch_id': testBranchId,
      'buy_price': 10,
      'sell_price': 20,
      'quantity': 50,
      'is_deleted': false,
    });

    await client
        .from('medicines')
        .update({'is_deleted': true})
        .eq('id', medicineId);

    final deleted = await client
        .from('medicines')
        .select('is_deleted')
        .eq('id', medicineId)
        .single();
    expect(deleted['is_deleted'], true);

    await client.from('medicines').delete().eq('id', medicineId);
  });
}
