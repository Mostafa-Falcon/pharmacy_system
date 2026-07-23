# Implementation Plan - Unified Contact Redesign (Supplier/Customer)

Fix the data visibility issue and redesign the "Supplier/Customer" (Unified contact) module to follow the premium, professional standard established in the rest of the application.

## User Review Required

> [!IMPORTANT]
> **Architecture Change**: I will switch this module from a split-view (List/Detail) to a full-width **Advanced Table View**. This provides more space for data and matches the UI of the Medicines and Purchases pages.

> [!TIP]
> **Live Updates**: The list will now be "Live". Any contact added via a dialog or another screen will appear **instantly** without needing a refresh.

## Proposed Changes

### [Component] Core Infrastructure (Database)

#### [MODIFY] [supplier_customers_dao.dart](file:///D:/projects/work/project-pharmacy/pharmacy_system/lib/app/core/data/database/daos/supplier_customers_dao.dart)
- Add `watchAll()` stream method to enable reactive UI updates.

### [Component] Contacts Module (Services)

#### [MODIFY] [supplier_customer_service.dart](file:///D:/projects/work/project-pharmacy/pharmacy_system/lib/app/modules/contacts/supplier_customers/services/supplier_customer_service.dart)
- Ensure cache is cleared/updated during `add`, `update`, and `delete` operations.
- Add `watchAll()` wrapper to expose the DAO stream.

### [Component] Contacts Module (Bloc)

#### [MODIFY] [supplier_customers_state.dart](file:///D:/projects/work/project-pharmacy/pharmacy_system/lib/app/modules/contacts/supplier_customers/bloc/supplier_customers_state.dart)
- Add `isSuccess` status for navigation control.
- Ensure all relevant data (balances, totals) are tracked correctly.

#### [MODIFY] [supplier_customers_bloc.dart](file:///D:/projects/work/project-pharmacy/pharmacy_system/lib/app/modules/contacts/supplier_customers/bloc/supplier_customers_bloc.dart)
- Implement a database subscription to trigger `LoadSupplierCustomers` automatically.
- Update `_onAdd` and `_onUpdate` to emit `success`.

### [Component] Contacts Module (View)

#### [MODIFY] [supplier_customers_list_view.dart](file:///D:/projects/work/project-pharmacy/pharmacy_system/lib/app/modules/contacts/supplier_customers/views/supplier_customers_list_view.dart)
- **Redesign**: Use `StandardModuleLayout` and `ReusableTable`.
- **Operations**: Add a "Options" button to each row (Ledger, Edit, Delete, Toggle).
- **Metric Cards**: Display professional cards for Total Count, Active Count, and Total Combined Balance.

#### [MODIFY] [add_supplier_customer_view.dart](file:///D:/projects/work/project-pharmacy/pharmacy_system/lib/app/modules/contacts/supplier_customers/views/add_supplier_customer_view.dart)
- Implement `BlocListener` to handle automatic navigation back to the list upon success.

## Verification Plan

### Manual Verification
1. **Visibility Test**: Add a new contact and verify it appears immediately in the table.
2. **UI Test**: Verify the new full-width table layout looks consistent with the "Medicines" page.
3. **Operations Test**: Open the "Ledger" from a row action and verify financial movements.
4. **Navigation Test**: Verify the "Add" page closes automatically after saving.
