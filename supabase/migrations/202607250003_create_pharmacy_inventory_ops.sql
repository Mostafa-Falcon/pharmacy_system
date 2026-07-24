-- ═══════════════════════════════════════════════════════════════════
-- Pharmacy System — 3/9 Inventory Operations
-- الجداول: stocktaking, stocktaking_items, stock_adjustments,
--          stock_adjustment_items, item_swaps, swap_items, opening_stock
-- ═══════════════════════════════════════════════════════════════════

-- ─── الجرد المخزني (Stocktaking) ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public.stocktaking (
  id                     TEXT PRIMARY KEY,
  reference_number       TEXT NOT NULL,
  stocktaking_date       TIMESTAMPTZ NOT NULL DEFAULT now(),
  status                 TEXT NOT NULL DEFAULT 'draft' CHECK (status IN ('draft', 'confirmed')),
  total_difference_value NUMERIC NOT NULL DEFAULT 0,
  category_id            TEXT,
  brand_id               TEXT,
  notes                  TEXT,
  created_by             TEXT NOT NULL,
  branch_id              TEXT NOT NULL DEFAULT '',
  account_id             TEXT NOT NULL DEFAULT '',
  last_modified          TIMESTAMPTZ NOT NULL DEFAULT now(),
  is_deleted             BOOLEAN NOT NULL DEFAULT false
);

CREATE INDEX IF NOT EXISTS idx_stocktaking_branch ON public.stocktaking(branch_id);
CREATE INDEX IF NOT EXISTS idx_stocktaking_account ON public.stocktaking(account_id);
CREATE INDEX IF NOT EXISTS idx_stocktaking_last_modified ON public.stocktaking(last_modified);

-- ─── سطور الجرد (Stocktaking Items) ────────────────────────────────
CREATE TABLE IF NOT EXISTS public.stocktaking_items (
  id                 TEXT PRIMARY KEY,
  stocktaking_id     TEXT NOT NULL REFERENCES public.stocktaking(id) ON DELETE CASCADE,
  medicine_id        TEXT NOT NULL,
  medicine_name      TEXT NOT NULL,
  sku                TEXT,
  book_quantity_text TEXT NOT NULL DEFAULT '',
  expiry_date        DATE,
  actual_unit1_qty   INT NOT NULL DEFAULT 0,
  actual_unit2_qty   INT,
  actual_unit3_qty   INT,
  unit_cost          NUMERIC NOT NULL DEFAULT 0,
  difference_quantity INT NOT NULL DEFAULT 0,
  difference_value   NUMERIC NOT NULL DEFAULT 0,
  notes              TEXT
);

CREATE INDEX IF NOT EXISTS idx_stocktaking_items_stocktaking ON public.stocktaking_items(stocktaking_id);
CREATE INDEX IF NOT EXISTS idx_stocktaking_items_medicine ON public.stocktaking_items(medicine_id);

-- ─── تسويات المخزون (Stock Adjustments) ────────────────────────────
CREATE TABLE IF NOT EXISTS public.stock_adjustments (
  id                TEXT PRIMARY KEY,
  adjustment_number TEXT NOT NULL,
  adjustment_type   TEXT NOT NULL CHECK (adjustment_type IN ('damage', 'shortage', 'surplus')),
  total_amount      NUMERIC NOT NULL DEFAULT 0,
  adjusted_by       TEXT NOT NULL,
  branch_id         TEXT NOT NULL DEFAULT '',
  account_id        TEXT NOT NULL DEFAULT '',
  notes             TEXT,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  last_modified     TIMESTAMPTZ NOT NULL DEFAULT now(),
  is_deleted        BOOLEAN NOT NULL DEFAULT false
);

CREATE INDEX IF NOT EXISTS idx_stock_adjustments_branch ON public.stock_adjustments(branch_id);
CREATE INDEX IF NOT EXISTS idx_stock_adjustments_account ON public.stock_adjustments(account_id);

-- ─── سطور التسوية (Stock Adjustment Items) ─────────────────────────
CREATE TABLE IF NOT EXISTS public.stock_adjustment_items (
  id            TEXT PRIMARY KEY,
  adjustment_id TEXT NOT NULL REFERENCES public.stock_adjustments(id) ON DELETE CASCADE,
  medicine_id   TEXT NOT NULL,
  medicine_name TEXT NOT NULL,
  unit_level    INT NOT NULL DEFAULT 1,
  unit_name     TEXT NOT NULL DEFAULT 'علبة',
  quantity      INT NOT NULL DEFAULT 0,
  buy_price     NUMERIC NOT NULL DEFAULT 0,
  total_price   NUMERIC NOT NULL DEFAULT 0,
  item_reason   TEXT
);

CREATE INDEX IF NOT EXISTS idx_stock_adjustment_items_adjustment ON public.stock_adjustment_items(adjustment_id);

-- ─── تبادل الأصناف (Item Swaps) ────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.item_swaps (
  id                   TEXT PRIMARY KEY,
  swap_number          TEXT NOT NULL,
  party_type           TEXT NOT NULL DEFAULT 'customer',
  party_id             TEXT,
  party_name           TEXT NOT NULL,
  cash_register_id     TEXT,
  total_incoming_amount NUMERIC NOT NULL DEFAULT 0,
  total_outgoing_amount NUMERIC NOT NULL DEFAULT 0,
  net_cash_difference  NUMERIC NOT NULL DEFAULT 0,
  created_by           TEXT NOT NULL,
  branch_id            TEXT NOT NULL DEFAULT '',
  account_id           TEXT NOT NULL DEFAULT '',
  notes                TEXT,
  swap_date            TIMESTAMPTZ NOT NULL DEFAULT now(),
  last_modified        TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_item_swaps_branch ON public.item_swaps(branch_id);
CREATE INDEX IF NOT EXISTS idx_item_swaps_account ON public.item_swaps(account_id);

-- ─── سطور التبادل (Swap Items) ─────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.swap_items (
  id            TEXT PRIMARY KEY,
  swap_id       TEXT NOT NULL REFERENCES public.item_swaps(id) ON DELETE CASCADE,
  direction     TEXT NOT NULL CHECK (direction IN ('incoming', 'outgoing')),
  medicine_id   TEXT NOT NULL,
  medicine_name TEXT NOT NULL,
  unit_level    INT NOT NULL DEFAULT 1,
  unit_name     TEXT NOT NULL DEFAULT 'علبة',
  quantity      INT NOT NULL DEFAULT 1,
  unit_price    NUMERIC NOT NULL DEFAULT 0,
  discount_amount NUMERIC NOT NULL DEFAULT 0,
  total_price   NUMERIC NOT NULL DEFAULT 0
);

CREATE INDEX IF NOT EXISTS idx_swap_items_swap ON public.swap_items(swap_id);

-- ─── رصيد أول المدة (Opening Stock) ────────────────────────────────
CREATE TABLE IF NOT EXISTS public.opening_stock (
  id              TEXT PRIMARY KEY,
  medicine_id     TEXT NOT NULL,
  medicine_name   TEXT NOT NULL,
  unit1_quantity  INT NOT NULL DEFAULT 0,
  unit2_quantity  INT,
  unit3_quantity  INT,
  buy_price       NUMERIC NOT NULL DEFAULT 0,
  branch_id       TEXT NOT NULL DEFAULT '',
  recorded_by     TEXT NOT NULL,
  recorded_at     TIMESTAMPTZ NOT NULL DEFAULT now(),
  last_modified   TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_opening_stock_branch ON public.opening_stock(branch_id);
CREATE INDEX IF NOT EXISTS idx_opening_stock_medicine ON public.opening_stock(medicine_id);
