# Implementation Plan - Heuristic "Expert" Pharmacy Unit Engine

The goal is to implement a heuristic-based parsing engine that understands the context and hierarchy of pharmacy units, effectively "thinking" like a pharmacist to normalize chaotic Excel data into structured stock levels (Level : Quantity).

## User Review Required

> [!IMPORTANT]
> **Level-Based Decomposition**: The system will decompose every unit string into a hierarchy:
> - **Level 1 (Main)**: The outer container (e.g., Box).
> - **Level 2 (Sub)**: The intermediate unit (e.g., Strip).
> - **Level 3 (Base)**: The smallest unit (e.g., Pill).
> Every level will be assigned a "Quantity Number" (Multiplier).

> [!TIP]
> **Smart Notation Handling**: If the unit is "6 شريط" and the inventory quantity is `10.2`, the system interprets this as **10 Level-1 units** and **2 Level-2 units**, mapping the decimal notation directly to the levels.

## Proposed Changes

### [Component] Inventory Module (Models)

#### [MODIFY] [unit_normalizer.dart](file:///D:/projects/work/project-pharmacy/pharmacy_system/lib/app/modules/inventory/services/unit_normalizer.dart)
- **New `UnitLevelInfo` class**:
    - `String name` (e.g., "شريط")
    - `double multiplier` (How many of this unit are in the parent unit).
- **Update `UnitParsedInfo`**:
    - `List<UnitLevelInfo> levels` (Stored from largest to smallest).

### [Component] Inventory Module (Services)

#### [MODIFY] [unit_normalizer.dart](file:///D:/projects/work/project-pharmacy/pharmacy_system/lib/app/modules/inventory/services/unit_normalizer.dart)
- **Heuristic Resolver**:
    - Extract all numbers and identify their associated keywords.
    - **Pattern: "N Keyword" vs "Keyword N"**:
        - "6 شريط" -> Box contains 6 strips.
        - "شريط 10" -> Strip contains 10 pills.
    - **Hierarchy Construction**:
        - If "علبة" is mentioned, it's Level 1.
        - If "شريط/امبول" mentioned, it's Level 2.
        - If "قرص/حبة" mentioned, it's Level 3.
- **Auto-Correction**: typo handling like "قلرص" -> "قرص".

### [Component] Core Data Services

#### [MODIFY] [excel_import_service.dart](file:///D:/projects/work/project-pharmacy/pharmacy_system/lib/app/core/data/services/excel_import_service.dart)
- **Mathematical Total Resolution**:
    - Total Pieces = `(WholePart * L1_Total_Multiplier) + (FractionPart * L2_Multiplier)`.
    - This allows `10.1` to mean **10 Boxes and 1 Strip**.

## Verification Plan

### Automated Test Cases (Mocked Inputs)
- [ ] "علبة 3 شريط 10 قرص" -> L1: علبة(1), L2: شريط(3), L3: حباية(10). Total = 30.
- [ ] "6 شريط" -> L1: علبة(1), L2: شريط(6), L3: حباية(10). Total = 60.
- [ ] "شريط 5" -> L1: شريط(1), L2: حباية(5). Total = 5.
- [ ] "12 قرص" -> L1: علبة(1), L2: قرص(12). Total = 12.

### Manual Verification
1. Import Excel and verify that an item with unit "6 شريط" and quantity "10.2" shows a total stock of **620** (10 boxes * 60 pills + 2 strips * 10 pills).
