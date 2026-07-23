# Implementation Plan - Professional Redesign of Unified Contacts (Supplier/Customer)

Fix data visibility issues and redesign the "Supplier/Customer" module to follow the premium, professional standard (Advanced Table Layout) used in the rest of the application.

## User Review Required

> [!IMPORTANT]
> **Layout Change**: I am switching the module from a split-view (Side list + Detail panel) to a **Full-Width Advanced Table**. This matches the "Medicines" and "Purchases" pages, offering more space for data and a cleaner look.

> [!TIP]
> **Live Synchronization**: The list will now be "Live". Any contact added will appear **instantly** without needing a page refresh, as the UI will directly watch the database.

## Proposed Changes

### [Component] Core Infrastructure (Database)

#### [MODIFY] [supplier_customers_dao.dart](file:///D:/projects/work/project-pharmacy/pharmacy_system/lib/app/core/data/database/daos/supplier_customers_dao.dart)
- Already contains `watchAll()`, which will be leveraged.

### [Component] Contacts Module (Services)

#### [MODIFY] [supplier_customer_service.dart](file:///D:/projects/work/project-pharmacy/pharmacy_system/lib/app/modules/contacts/supplier_customers/services/supplier_customer_service.dart)
- Ensure the static cache is invalidated or updated when `add`, `update`, or `delete` is called.

### [Component] Contacts Module (Bloc)

#### [MODIFY] [supplier_customers_state.dart](file:///D:/projects/work/project-pharmacy/pharmacy_system/lib/app/modules/contacts/supplier_customers/bloc/supplier_customers_state.dart)
- Add `isSuccess` status to handle navigation/reset logic.
- Ensure all metric totals (Active, Balance, Total) are calculated in the state.

#### [MODIFY] [supplier_customers_bloc.dart](file:///D:/projects/work/project-pharmacy/pharmacy_system/lib/app/modules/contacts/supplier_customers/bloc/supplier_customers_bloc.dart)
- Subscribe to the `SupplierCustomerService.watchAll()` stream in the constructor.
- Automatically trigger `LoadSupplierCustomers` whenever a change is detected in the database.
- Emit `isSuccess: true` after adding or updating a contact.

### [Component] Contacts Module (View)

#### [MODIFY] [supplier_customers_list_view.dart](file:///D:/projects/work/project-pharmacy/pharmacy_system/lib/app/modules/contacts/supplier_customers/views/supplier_customers_list_view.dart)
- **Redesign**: Switch to `StandardModuleLayout` and `ReusableTable`.
- **Metric Cards**: Add professional summary cards for Total, Active, and Total Combined Balance.
- **Row Actions**: Move operations (Ledger, Edit, Delete) to a clean "Options" button in each row.
- **Ledger Dialog**: Improve the ledger view to be more professional and clear.

#### [MODIFY] [add_supplier_customer_view.dart](file:///D:/projects/work/project-pharmacy/pharmacy_system/lib/app/modules/contacts/supplier_customers/views/add_supplier_customer_view.dart)
- Implement `BlocListener` to handle automatic navigation back to the list upon success.

## Verification Plan

### Manual Verification
1. **Visibility Test**: Add a new contact and verify it appears immediately in the full-width table.
2. **UI Test**: Verify that the table matches the zebra-row and premium styling of the Medicines table.
3. **Ledger Test**: Open the ledger for a contact and verify all financial records (Sales/Purchases/Receipts) are shown correctly.
4. **Consistency**: Verify that search and quick filters work smoothly on the new table.
