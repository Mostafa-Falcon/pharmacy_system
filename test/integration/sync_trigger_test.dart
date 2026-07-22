import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  const supabaseUrl = 'https://vhsngfalnltxnaiabvaa.supabase.co';
  const serviceRoleKey = String.fromEnvironment('SUPABASE_SERVICE_ROLE_KEY', defaultValue: '');

  late final SupabaseClient client;

  setUpAll(() {
    client = SupabaseClient(supabaseUrl, serviceRoleKey);
  });

  test('Insert triggers auto last_modified on medicines', () async {
    final testId = 'test-med-${DateTime.now().millisecondsSinceEpoch}';
    final now = DateTime.now().toUtc();

    await client.from('medicines').insert({
      'id': testId,
      'name': 'Sync Test Med',
      'branch_id': 'test-branch',
      'buy_price': 10,
      'sell_price': 20,
      'quantity': 100,
      'is_deleted': false,
    });

    final fetched = await client.from('medicines').select('last_modified').eq('id', testId).single();
    final lm = DateTime.parse(fetched['last_modified'] as String);

    expect(lm.isAfter(now.subtract(const Duration(seconds: 5))) || lm.isAtSameMomentAs(now), isTrue,
        reason: 'last_modified should be set automatically by trigger');

    await client.from('medicines').delete().eq('id', testId);
  });

  test('Update refreshes last_modified on medicines', () async {
    final testId = 'test-med-2-${DateTime.now().millisecondsSinceEpoch}';

    await client.from('medicines').insert({
      'id': testId,
      'name': 'Sync Test Med 2',
      'branch_id': 'test-branch',
      'buy_price': 10,
      'sell_price': 20,
      'quantity': 100,
      'is_deleted': false,
    });

    final beforeUpdate = await client.from('medicines').select('last_modified').eq('id', testId).single();
    final lmBefore = DateTime.parse(beforeUpdate['last_modified'] as String);

    await Future<void>.delayed(const Duration(seconds: 1));

    await client.from('medicines').update({'name': 'Sync Test Med 2 Updated'}).eq('id', testId);

    final afterUpdate = await client.from('medicines').select('last_modified').eq('id', testId).single();
    final lmAfter = DateTime.parse(afterUpdate['last_modified'] as String);

    expect(lmAfter.isAfter(lmBefore), isTrue,
        reason: 'last_modified should be refreshed on update');

    await client.from('medicines').delete().eq('id', testId);
  });
}
