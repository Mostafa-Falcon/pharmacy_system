-- ═══════════════════════════════════════════════════════════════
-- Fix missing / mismatched pharmacy tables on Supabase
-- Safe to re-run: uses IF NOT EXISTS / DROP POLICY IF EXISTS
-- ═══════════════════════════════════════════════════════════════

-- ─── 1. archive_records ────────────────────────────────────────
DROP POLICY IF EXISTS "archive_records_select_all" ON public.archive_records;
DROP POLICY IF EXISTS "archive_records_insert_all" ON public.archive_records;
DROP POLICY IF EXISTS "archive_records_update_all" ON public.archive_records;

CREATE TABLE IF NOT EXISTS public.archive_records (
  id TEXT PRIMARY KEY,
  entity_type TEXT NOT NULL,
  entity_id TEXT NOT NULL,
  entity_name TEXT NOT NULL DEFAULT '',
  entity_data JSONB NOT NULL DEFAULT '{}'::jsonb,
  deleted_by TEXT NOT NULL DEFAULT '',
  deleted_by_name TEXT NOT NULL DEFAULT '',
  deleted_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  branch_id TEXT NOT NULL DEFAULT '',
  restored_at TIMESTAMPTZ,
  restored_by TEXT,
  permanently_deleted_at TIMESTAMPTZ,
  sync_version INT NOT NULL DEFAULT 1,
  last_modified TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_archive_records_entity_type ON public.archive_records(entity_type);
CREATE INDEX IF NOT EXISTS idx_archive_records_entity_name ON public.archive_records(entity_name);
CREATE INDEX IF NOT EXISTS idx_archive_records_deleted_by ON public.archive_records(deleted_by);
CREATE INDEX IF NOT EXISTS idx_archive_records_deleted_at ON public.archive_records(deleted_at DESC);
CREATE INDEX IF NOT EXISTS idx_archive_records_branch_id ON public.archive_records(branch_id);
CREATE INDEX IF NOT EXISTS idx_archive_records_active ON public.archive_records(restored_at, permanently_deleted_at);

ALTER TABLE public.archive_records ENABLE ROW LEVEL SECURITY;

CREATE POLICY "archive_records_select_all" ON public.archive_records
  FOR SELECT USING (true);
CREATE POLICY "archive_records_insert_all" ON public.archive_records
  FOR INSERT WITH CHECK (true);
CREATE POLICY "archive_records_update_all" ON public.archive_records
  FOR UPDATE USING (true) WITH CHECK (true);

-- ─── 2. stocktaking_periods ────────────────────────────────────
DROP POLICY IF EXISTS "stocktaking_periods_select_all" ON public.stocktaking_periods;
DROP POLICY IF EXISTS "stocktaking_periods_insert_all" ON public.stocktaking_periods;
DROP POLICY IF EXISTS "stocktaking_periods_update_all" ON public.stocktaking_periods;

CREATE TABLE IF NOT EXISTS public.stocktaking_periods (
  id TEXT PRIMARY KEY,
  branch_id TEXT NOT NULL REFERENCES public.branches(id),
  start_date TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  end_date TIMESTAMPTZ,
  status TEXT NOT NULL DEFAULT 'open' CHECK (status IN ('open', 'closed')),
  notes TEXT,
  created_by TEXT NOT NULL,
  sync_version INT NOT NULL DEFAULT 1,
  last_modified TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  is_deleted BOOLEAN NOT NULL DEFAULT false
);

CREATE INDEX IF NOT EXISTS idx_stocktaking_periods_branch ON public.stocktaking_periods(branch_id);
CREATE INDEX IF NOT EXISTS idx_stocktaking_periods_status ON public.stocktaking_periods(status);

ALTER TABLE public.stocktaking_periods ENABLE ROW LEVEL SECURITY;

CREATE POLICY "stocktaking_periods_select_all" ON public.stocktaking_periods
  FOR SELECT USING (true);
CREATE POLICY "stocktaking_periods_insert_all" ON public.stocktaking_periods
  FOR INSERT WITH CHECK (true);
CREATE POLICY "stocktaking_periods_update_all" ON public.stocktaking_periods
  FOR UPDATE USING (true) WITH CHECK (true);

-- ─── 3. stocktaking_counts ─────────────────────────────────────
DROP POLICY IF EXISTS "stocktaking_counts_select_all" ON public.stocktaking_counts;
DROP POLICY IF EXISTS "stocktaking_counts_insert_all" ON public.stocktaking_counts;
DROP POLICY IF EXISTS "stocktaking_counts_update_all" ON public.stocktaking_counts;

CREATE TABLE IF NOT EXISTS public.stocktaking_counts (
  id TEXT PRIMARY KEY,
  stocktaking_id TEXT NOT NULL,
  medicine_id TEXT NOT NULL,
  medicine_name TEXT NOT NULL DEFAULT '',
  system_quantity INT NOT NULL DEFAULT 0,
  counted_quantity INT,
  difference INT,
  notes TEXT,
  sync_version INT NOT NULL DEFAULT 1,
  last_modified TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  is_deleted BOOLEAN NOT NULL DEFAULT false
);

CREATE INDEX IF NOT EXISTS idx_stocktaking_counts_stocktaking ON public.stocktaking_counts(stocktaking_id);
CREATE INDEX IF NOT EXISTS idx_stocktaking_counts_medicine ON public.stocktaking_counts(medicine_id);

ALTER TABLE public.stocktaking_counts ENABLE ROW LEVEL SECURITY;

CREATE POLICY "stocktaking_counts_select_all" ON public.stocktaking_counts
  FOR SELECT USING (true);
CREATE POLICY "stocktaking_counts_insert_all" ON public.stocktaking_counts
  FOR INSERT WITH CHECK (true);
CREATE POLICY "stocktaking_counts_update_all" ON public.stocktaking_counts
  FOR UPDATE USING (true) WITH CHECK (true);

-- ─── 4. expenses ───────────────────────────────────────────────
DROP POLICY IF EXISTS "expenses_select_all" ON public.expenses;
DROP POLICY IF EXISTS "expenses_insert_all" ON public.expenses;
DROP POLICY IF EXISTS "expenses_update_all" ON public.expenses;

CREATE TABLE IF NOT EXISTS public.expenses (
  id TEXT PRIMARY KEY,
  branch_id TEXT NOT NULL REFERENCES public.branches(id),
  expense_number INT NOT NULL DEFAULT 1,
  expense_date DATE NOT NULL DEFAULT CURRENT_DATE,
  category TEXT NOT NULL,
  description TEXT,
  amount NUMERIC NOT NULL DEFAULT 0,
  payment_method TEXT NOT NULL DEFAULT 'cash',
  created_by_id TEXT NOT NULL,
  created_by_name TEXT,
  notes TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  last_modified TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  is_deleted BOOLEAN NOT NULL DEFAULT false
);

CREATE INDEX IF NOT EXISTS idx_expenses_branch ON public.expenses(branch_id);
CREATE INDEX IF NOT EXISTS idx_expenses_date ON public.expenses(expense_date);
CREATE INDEX IF NOT EXISTS idx_expenses_category ON public.expenses(category);

ALTER TABLE public.expenses ENABLE ROW LEVEL SECURITY;

CREATE POLICY "expenses_select_all" ON public.expenses
  FOR SELECT USING (true);
CREATE POLICY "expenses_insert_all" ON public.expenses
  FOR INSERT WITH CHECK (true);
CREATE POLICY "expenses_update_all" ON public.expenses
  FOR UPDATE USING (true) WITH CHECK (true);
