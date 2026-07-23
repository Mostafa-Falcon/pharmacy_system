# Implementation Plan - Fix Synchronization Issues

Resolve the failure in "Supplier/Customer" and "Customer Ledger" synchronization by fixing critical bugs in the branch ID propagation and improving the robustness of the Sync Engine.

## User Review Required

> [!IMPORTANT]
> **Branch ID Fix**: I found a critical bug where financial movements (ledgers) were being recorded without a branch ID. This caused the cloud database (Supabase) to reject them due to security policies (RLS).

> [!WARNING]
> **Schema Check**: If "Supplier/Customer" still fails after this fix, it might indicate that the table is missing in the cloud backend. I will add detailed error logging to help identify if this is the case.

## Proposed Changes

### [Component] Core Services (Sync)

#### [MODIFY] [sync_push_service.dart](file:///D:/projects/work/project-pharmacy/pharmacy_system/lib/app/core/data/services/sync/sync_push_service.dart)
- Update `globalTables` set to include `medicine_units` and `item_batches`. This prevents the sync engine from incorrectly injecting a `branch_id` into tables that don't have that column.
- Improve error reporting in the `catch` block to provide clearer diagnostic information.

### [Component] Core Data (Ledgers)

#### [MODIFY] [party_ledger_service.dart](file:///D:/projects/work/project-pharmacy/pharmacy_system/lib/app/core/data/services/party_ledger_service.dart)
- **CRITICAL FIX**: Update all method calls (`recordSaleInvoice`, `recordCashReceipt`, `recordOpeningBalance`, etc.) to pass `AuthService.currentBranchId ?? ''` instead of hardcoded empty strings `''`.
- This ensures that every financial movement is correctly tagged with the branch it belongs to, allowing the cloud to accept the data.

### [Component] Contacts Module (Services)

#### [MODIFY] [supplier_customer_service.dart](file:///D:/projects/work/project-pharmacy/pharmacy_system/lib/app/modules/contacts/supplier_customers/services/supplier_customer_service.dart)
- Ensure `branchId` is explicitly set and verified before queuing sync operations for new contacts. (Currently looks okay but will double-check during execution).

## Verification Plan

### Manual Verification
1. **Ledger Sync Test**: Create a new customer/supplier with an opening balance. Verify that both the contact AND the ledger entry appear in the sync status queue.
2. **Push Test**: Click "Full Sync" and verify that "Customer Ledgers" (دفاتر العملاء) no longer show a red "X" and finish successfully.
3. **Audit**: Monitor the "Last Sync Error" in the sync dashboard for any remaining "404" or "403" errors.
