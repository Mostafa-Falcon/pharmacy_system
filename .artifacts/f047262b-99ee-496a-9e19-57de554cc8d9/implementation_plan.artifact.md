# Implementation Plan - Free Return (مرتجع حر) Module

Add a new "Free Return" module that allows pharmacists to record sales and purchase returns without being linked to a specific original invoice. This module will handle stock updates and financial ledger entries automatically.

## User Review Required

> [!IMPORTANT]
> **Unified View**: I will implement a single view that toggles between "Sales Return" and "Purchase Return" as shown in the provided screenshots. This ensures a clean and efficient workflow.

> [!NOTE]
> **Financial Integration**: For Sales Returns, the system will record a cash outflow (if cash) or update the customer ledger (if credit). For Purchase Returns, it will record a cash inflow or update the supplier ledger.

## Proposed Changes

### [Component] Routes

#### [MODIFY] [app_routes.dart](file:///D:/projects/work/project-pharmacy/pharmacy_system/lib/app/routes/app_routes.dart)
- Add `FREE_RETURN = '/returns/free'`.
- Map it to destination `free_return`.

### [Component] Returns Module (New Bloc)

#### [NEW] [free_return_bloc.dart](file:///D:/projects/work/project-pharmacy/pharmacy_system/lib/app/modules/returns/bloc/free_return_bloc.dart)
- State management for the free return form.
- Handles adding/removing items, calculating totals with discount, and toggling return/party types.
- Events: `AddItem`, `RemoveItem`, `UpdateItem`, `SetReturnType`, `SetPartyType`, `SubmitReturn`.

### [Component] Returns Module (View)

#### [NEW] [free_return_view.dart](file:///D:/projects/work/project-pharmacy/pharmacy_system/lib/app/modules/returns/views/free_return_view.dart)
- Professional UI based on the provided screenshots.
- Includes:
    - **Header**: Tab switch (Sales vs Purchase).
    - **Party Section**: Segmented control (Cash, Customer, Supplier) + Dynamic Dropdown.
    - **Note Section**: Reason/Notes + Safe selection.
    - **Items Table**: Dynamic item entry with inline editing (Qty, Price, Expiry).
    - **Footer**: Discount percentage input + Grand Total + Submit Button.

### [Component] Data Layer

#### [MODIFY] [return_model.dart](file:///D:/projects/work/project-pharmacy/pharmacy_system/lib/app/modules/sales/models/return_model.dart)
- Add `discountPercent` and `safeId` fields to `ReturnModel` if necessary for persistence.
- Update `toJson` and `fromJson`.

#### [NEW] [free_return_service.dart](file:///D:/projects/work/project-pharmacy/pharmacy_system/lib/app/modules/returns/services/free_return_service.dart)
- Handle the business logic of saving the return.
- Call `StockMutationService` to update inventory.
- Call `PartyLedgerService` to record financial effects.

## Verification Plan

### Manual Verification
1. **Sales Return Test**: Add a "Free Sales Return" for a customer. Verify that the medicine stock increases and the customer's debt decreases (or safe balance decreases).
2. **Purchase Return Test**: Add a "Free Purchase Return" for a supplier. Verify that the medicine stock decreases and the supplier's debt decreases (or safe balance increases).
3. **Discount Test**: Apply a 10% discount and verify that the final amount is calculated correctly in the footer.
4. **Validation Test**: Try to submit without adding items or selecting a party when required.
