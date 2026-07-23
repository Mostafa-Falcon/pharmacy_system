# Implementation Plan - Purchase Invoice Improvements & Super Smart Units

The goal is to fix supplier display, resolve the medicine search issue, implement automatic item addition, and deploy a heuristic-based unit parsing engine.

## User Review Required

> [!IMPORTANT]
> **Unified Suppliers**: The supplier dropdown will now show the **Name** instead of UUID and include all contacts from both "Suppliers" and "Supplier-Customers".

> [!IMPORTANT]
> **Heuristic Unit Engine**: The system will now "read" unit strings like "علبة 3 شريط 10 قرص" and automatically build the 3-level hierarchy (Box -> Strip -> Pill) with correct multipliers.

> [!TIP]
> **Immediate Addition**: Selecting a medicine now adds it **instantly** to the invoice list with a default quantity of 1. You can then edit the details directly in the table.

## Proposed Changes

### [Component] Inventory Module (Services)

#### [MODIFY] [unit_normalizer.dart](file:///D:/projects/work/project-pharmacy/pharmacy_system/lib/app/modules/inventory/services/unit_normalizer.dart)
- Implement a **Tokenization Engine** to break down unit strings.
- Use a **Hierarchy Resolver** to infer the relationship between containers and base items.
- Support complex pharmacy notations found in the provided Excel list.

### [Component] Purchases Module

#### [MODIFY] [add_purchase_view.dart](file:///D:/projects/work/project-pharmacy/pharmacy_system/lib/app/modules/purchases/views/add_purchase_view.dart)
- **Unified Vendor List**: Merge `SupplierService` and `SupplierCustomerService` for the dropdown.
- **Auto-Add Logic**: Modify `onMedicineSelected` to call `bloc.add(AddPurchaseLine(...))` directly.
- **Shortcut Support**: Ensure the search field is focused by default or via shortcuts.

### [Component] Core Presentation (Inputs)

#### [MODIFY] [medicine_search_field.dart](file:///D:/projects/work/project-pharmacy/pharmacy_system/lib/app/core/presentation/widgets/reusables/inputs/medicine_search_field.dart)
- **Async Warm-up**: Ensure medicines are fetched from the database if the local repository cache is empty.
- **Search Optimization**: Improve fuzzy matching for name, nameEn, and barcodes.

## Verification Plan

### Manual Verification
1. **Search Test**: Type "بار" in the search field and verify medicines appear.
2. **Auto-Add Test**: Click a result or scan a barcode and verify the item is added to the table immediately.
3. **Unit Test**: Verify that "شريط 5" and "6 شريط" result in correct stock calculations (e.g., Qty 10.1 = 10 units + 1 sub-unit).
4. **Supplier Test**: Verify names are displayed instead of UUIDs in the header.
