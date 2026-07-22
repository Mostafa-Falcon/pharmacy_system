# Refactoring & Cleanup Implementation Plan

This plan aims to improve the project's maintainability, readability, and adherence to Clean Architecture principles by cleaning up duplicates, removing empty directories, reorganizing models, and streamlining Dependency Injection.

## User Review Required

> [!IMPORTANT]
> **Refactoring Impacts**: This task involves moving many files (Models and Services). While I will update imports, please ensure you have a clean git state to revert if needed.
> **Base Classes**: I will migrate `CashierShiftBloc` to use `BaseBloc` as a pilot. If you prefer another Bloc, please let me know.

## Proposed Changes

### 1. Cleanup Duplicates & Services [Component: Core Data Services]

I will remove redundant service files and ensure a flat, clear hierarchy.

#### [DELETE] `lib/app/core/data/services/party_ledger_service.dart`
*Reason*: Consolidate into `customer_ledger_service.dart` and `supplier_ledger_service.dart` if redundant, or keep only if it truly serves as a shared base not covered by specialized ones.

### 2. Remove Empty Directories [Component: Modules]

I will remove all empty `widgets/` folders and other empty directories in modules to reduce noise.

#### [DELETE] Empty `widgets/` folders in:
* `accounting`, `admin`, `archive`, `auth`, `crm`, `employee`, `hr`, `inventory`, `notifications`, `purchases`, `returns`, `stocktaking`, `sync`, `tasks`, `void_operations`.

### 3. Reorganize Models [Component: Domain Models]

Move module-specific models from `core/domain/models/` to their respective modules.

#### [MOVE] `lib/app/core/domain/models/accounting/*` -> `lib/app/modules/accounting/models/`
#### [MOVE] `lib/app/core/domain/models/admin/*` -> `lib/app/modules/admin/models/`
#### [MOVE] `lib/app/core/domain/models/hr/*` -> `lib/app/modules/hr/models/`
#### [MOVE] `lib/app/core/domain/models/inventory/*` -> `lib/app/modules/inventory/models/`
#### [MOVE] `lib/app/core/domain/models/sales/*` -> `lib/app/modules/sales/models/`
*(And so on for other modules)*

### 4. Streamline Dependency Injection [Component: DI]

Split large DI files and ensure module-level DI handles its own concerns.

#### [NEW] `lib/app/core/di/daos_di.dart`
*Extract all DAO registrations from `database_di.dart` to this new file.*

#### [MODIFY] `lib/app/core/di/database_di.dart`
*Keep only the main `AppDatabase` registration.*

### 5. Adopt Base Classes [Component: Bloc]

Migrate a pilot Bloc to use the established `BaseBloc` and `BaseState`.

#### [MODIFY] `lib/app/modules/sales/bloc/cashier_shift_bloc.dart`
*Update to extend `BaseBloc` and use `BaseState` for common handling (loading, success, error).*

## Verification Plan

### Automated Tests
- Run `flutter test` to ensure logic remains intact after moving files.
- Run `flutter analyze` to verify all imports are correctly updated.

### Manual Verification
- Verify that the app still builds and runs correctly on the desktop layout.
- Check the Sales/Cashier Shift module specifically since its Bloc will be refactored.
