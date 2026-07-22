import 'package:pharmacy_system/app/core/injection.dart';
import 'package:pharmacy_system/app/core/data/database/daos/receipt_counters_dao.dart';

class ReceiptNumberService {
  static Future<String> nextForBranch(String branchId) async {
    final dao = sl<ReceiptCountersDao>();
    final next = await dao.increment(branchId, 'sales');
    return '#${next.toString().padLeft(6, '0')}';
  }
}
