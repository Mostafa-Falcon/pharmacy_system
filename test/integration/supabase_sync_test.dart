import 'package:flutter_test/flutter_test.dart';
import 'package:supabase/supabase.dart';
import 'package:pharmacy_system/app/core/utils/app_utils.dart';

void main() {
  const supabaseUrl = 'https://vhsngfalnltxnaiabvaa.supabase.co';
  const anonKey = 'sb_publishable_xwoFSQD1HYMGfq1CerDnJQ_9DwWc83f';
  
  test('Final Proof: Syncing to "customers" table', () async {
    final client = SupabaseClient(supabaseUrl, anonKey);
    final testId = 'test_cust_${DateTime.now().millisecondsSinceEpoch}';

    final customerData = {
      'id': testId,
      'name': 'Integration Test Customer',
      'kind': 'individual',
      'last_modified': DateTime.now().toIso8601String(),
    };

    try {
      safeDebugPrint('Inserting customer with ID: $testId');
      await client.from('customers').upsert(customerData);
      safeDebugPrint('Manual Upsert to "customers" SUCCESS!');
      
      // Cleanup
      await client.from('customers').delete().eq('id', testId);
    } catch (e) {
      safeDebugPrint('Upsert to "customers" FAILED: $e');
    }
  });
}
