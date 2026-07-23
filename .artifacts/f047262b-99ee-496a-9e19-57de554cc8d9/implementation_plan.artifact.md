# Implementation Plan - Professional Bulk Price Update Module

Redesign and complete the "Bulk Price Update" module to match the project's premium design language and ensure robust, branch-aware logic with cloud synchronization.

## User Review Required

> [!IMPORTANT]
> **Data Integrity**: I will use `BranchDataService.batchUpdateMedicines` to ensure that all price changes are correctly recorded in the local database and queued for synchronization to Supabase. This ensures all branches stay updated.

> [!TIP]
> **Visual Progress**: I will add a progress overlay during the bulk update operation so you can see the status when updating thousands of items.

## Proposed Changes

### [Component] Inventory Module (Bloc)

#### [MODIFY] [bulk_price_update_bloc.dart](file:///D:/projects/work/project-pharmacy/pharmacy_system/lib/app/modules/inventory/bloc/bulk_price/bulk_price_update_bloc.dart)
- Replace direct `_dao` usage with `BranchDataService` and `sl<MedicinesRepository>()`.
- Update `_onConfirmApply` to use `BranchDataService.batchUpdateMedicines(updatedItems)` for efficiency and sync support.
- Ensure categories are loaded for the current active branch only.

### [Component] Inventory Module (View)

#### [MODIFY] [bulk_price_update_view.dart](file:///D:/projects/work/project-pharmacy/pharmacy_system/lib/app/modules/inventory/views/bulk_price_update_view.dart)
- **Reorganization**: Use `StandardModuleLayout`.
- **Card 1: Scope (Apply To)**:
    - Toggle between "All Items" and "Specific Category".
    - Clean category dropdown integration.
- **Card 2: Parameters (Field & Operation)**:
    - Choose Target: [Sell Price, Buy Price, Both].
    - Choose Operation: [Set Value, Increase (+), Decrease (-), Increase (%), Decrease (%)].
- **Card 3: Execution (Value & Impact)**:
    - Input for the numeric value/percentage.
    - Live Summary: "Affected Items" summary card.
    - Large, professional "Apply Update" button with a secondary "Reset" option.
- **Visuals**: Use `TableIconBox` or consistent icons and sector colors.

## Verification Plan

### Manual Verification
1. **Simulation Test**: Select a category and an operation. Verify the "Affected Items" count updates in real-time before applying.
2. **Buy Price Test**: Increase buy price by 10% for a category. Verify in the Medicines list that the items now have the correct updated buy price.
3. **Sync Test**: After applying a bulk update, check the "Sync Status" page to confirm all modified medicines are in the queue to be uploaded.
4. **Validation**: Ensure negative prices are prevented when using the "Decrease" operations.
