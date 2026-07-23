# Implementation Plan - Unified Table Design (Contacts & Suppliers)

Unify the design of Suppliers, Customers, and Supplier/Customer tables to match the premium "Medicines" table design. This includes creating reusable table components for consistent UI across the application.

## User Review Required

> [!IMPORTANT]
> **Design Shift**: I will use the "Icon Box" design (rounded square containers) for avatars instead of simple circles, matching the Medicines table's aesthetic.

> [!TIP]
> **Reusable Components**: I will extract these patterns into a new `shared_table_cells.dart` file in the `@tables` directory so they can be easily reused in any future module.

## Proposed Changes

### [Component] Core Presentation (Tables)

#### [NEW] [shared_table_cells.dart](file:///D:/projects/work/project-pharmacy/pharmacy_system/lib/app/core/presentation/widgets/reusables/tables/shared_table_cells.dart)
- `TableIconBox`: The rounded square icon container with background.
- `TableContactNameCell`: The row identity cell (Icon + Name + Subtitle).
- `TableMoneyCell`: Styled currency display (e.g., for balances).
- `TableOptionsButton`: Standardized row action button.

### [Component] Contacts Module (Views)

#### [MODIFY] [suppliers_list_view.dart](file:///D:/projects/work/project-pharmacy/pharmacy_system/lib/app/modules/contacts/suppliers/views/suppliers_list_view.dart)
- Update columns to use `TableContactNameCell` and `TableMoneyCell`.
- Update `rowActions` to use the standardized button.
- Ensure consistent spacing and layout.

#### [MODIFY] [customers_list_view.dart](file:///D:/projects/work/project-pharmacy/pharmacy_system/lib/app/modules/contacts/customers/views/customers_list_view.dart)
- Update columns to match the new design.
- Switch to `StandardModuleLayout` if not already using it.

#### [MODIFY] [supplier_customers_list_view.dart](file:///D:/projects/work/project-pharmacy/pharmacy_system/lib/app/modules/contacts/supplier_customers/views/supplier_customers_list_view.dart)
- Refactor to use the new shared components for 100% parity with other tables.

## Verification Plan

### Manual Verification
1. **Visual Consistency Check**: Open Medicines, Suppliers, and Customers pages and verify they look like they belong to the same "Premium" suite.
2. **Responsive Check**: Verify that columns still resize correctly on different screen widths.
3. **Action Test**: Ensure all row actions (Ledger, Edit, Delete) still trigger the correct Bloc events and dialogs.
