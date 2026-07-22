import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  const supabaseUrl = 'https://vhsngfalnltxnaiabvaa.supabase.co';
  const serviceRoleKey = String.fromEnvironment('SUPABASE_SERVICE_ROLE_KEY', defaultValue: '');

  late final SupabaseClient client;

  setUpAll(() {
    client = SupabaseClient(supabaseUrl, serviceRoleKey);
  });

  test('Supabase connectivity smoke test', () async {
    final response = await client.from('users').select('id').limit(1);
    expect(response, isA<List>());
  });

  test('Check required columns exist in medicines table', () async {
    final columns = await client
        .from('information_schema.columns')
        .select('column_name, data_type')
        .eq('table_schema', 'public')
        .eq('table_name', 'medicines')
        .order('ordinal_position');

    final columnNames = columns.map((c) => c['column_name'] as String).toList();

    expect(columnNames, containsAll(<String>[
      'id',
      'name',
      'branch_id',
      'buy_price',
      'sell_price',
      'quantity',
      'last_modified',
      'is_deleted',
      'sync_version',
      'barcodes',
      'name_en',
      'dosage_form',
      'strength',
      'package_size',
      'expiry_tracking_enabled',
      'supplier_name',
      'description',
      'old_sell_price',
      'item_type_id',
      'group_id',
      'units',
      'alert_enabled',
      'dosage_form_enabled',
      'image_url',
      'container_shape',
      'allow_negative_stock',
      'is_taxable',
      'tax_type',
      'tax_value',
      'prices_include_tax',
      'location',
      'is_active',
      'created_at',
    ]));
  });

  test('Check trigger set_last_modified exists on medicines', () async {
    final triggers = await client
        .from('information_schema.triggers')
        .select('trigger_name, event_manipulation, action_timing, action_statement')
        .eq('table_schema', 'public')
        .eq('table_name', 'medicines');

    final triggerNames = triggers.map((t) => t['trigger_name'] as String).toList();
    expect(triggerNames, contains('set_last_modified'));
  });

  test('Check RLS policies exist on archive_records', () async {
    final policies = await client
        .from('pg_policies')
        .select('policy_name, cmd')
        .eq('schemaname', 'public')
        .eq('tablename', 'archive_records');

    final policyNames = policies.map((p) => p['policy_name'] as String).toSet();
    expect(policyNames, containsAll(<String>{
      'archive_records_select_all',
      'archive_records_insert_all',
      'archive_records_update_all',
      'archive_records_delete_all',
    }));
  });
}
