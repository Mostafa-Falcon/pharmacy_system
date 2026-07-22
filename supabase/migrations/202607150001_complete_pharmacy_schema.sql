-- ═══════════════════════════════════════════════════════════════
-- Pharmacy System — Complete Schema (Clean + Idempotent)
-- All 12 sync tables + customer_groups in one migration.
-- Uses IF NOT EXISTS for safe re-runs.
-- ═══════════════════════════════════════════════════════════════

-- ─── Branches ────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.branches (
  id            TEXT PRIMARY KEY,
  name          TEXT NOT NULL,
  address       TEXT,
  phone         TEXT,
  is_active     BOOLEAN NOT NULL DEFAULT true,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  sync_version  INT NOT NULL DEFAULT 1,
  last_modified TIMESTAMPTZ NOT NULL DEFAULT now(),
  is_deleted    BOOLEAN NOT NULL DEFAULT false
);

-- ─── Users ───────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.users (
  id                 TEXT PRIMARY KEY,
  name               TEXT NOT NULL,
  email              TEXT NOT NULL UNIQUE,
  password_hash      TEXT NOT NULL DEFAULT '',
  role               TEXT NOT NULL DEFAULT 'employee' CHECK (role IN ('owner', 'employee')),
  assigned_branch_id TEXT,
  is_active          BOOLEAN NOT NULL DEFAULT true,
  created_at         TIMESTAMPTZ NOT NULL DEFAULT now(),
  last_login         TIMESTAMPTZ,
  sync_version       INT NOT NULL DEFAULT 1,
  last_modified      TIMESTAMPTZ NOT NULL DEFAULT now(),
  is_deleted         BOOLEAN NOT NULL DEFAULT false
);

-- ─── Permissions ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.permissions (
  id               TEXT PRIMARY KEY,
  user_id          TEXT NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  permission_key   TEXT NOT NULL,
  is_allowed       BOOLEAN NOT NULL DEFAULT false,
  created_at       TIMESTAMPTZ NOT NULL DEFAULT now(),
  sync_version     INT NOT NULL DEFAULT 1,
  last_modified    TIMESTAMPTZ NOT NULL DEFAULT now(),
  is_deleted       BOOLEAN NOT NULL DEFAULT false,
  UNIQUE(user_id, permission_key)
);

-- ─── Medicines ───────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.medicines (
  id               TEXT PRIMARY KEY,
  name             TEXT NOT NULL,
  scientific_name  TEXT,
  category         TEXT,
  barcode          TEXT,
  buy_price        NUMERIC NOT NULL DEFAULT 0,
  sell_price       NUMERIC NOT NULL DEFAULT 0,
  quantity         INT NOT NULL DEFAULT 0,
  min_stock        INT NOT NULL DEFAULT 10,
  expiry_date      DATE,
  manufacturer     TEXT,
  branch_id        TEXT NOT NULL REFERENCES public.branches(id),
  sync_version     INT NOT NULL DEFAULT 1,
  last_modified    TIMESTAMPTZ NOT NULL DEFAULT now(),
  is_deleted       BOOLEAN NOT NULL DEFAULT false
);
CREATE INDEX IF NOT EXISTS idx_medicines_branch ON public.medicines(branch_id);
CREATE INDEX IF NOT EXISTS idx_medicines_barcode ON public.medicines(barcode);

-- ─── Sales ───────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.sales (
  id               TEXT PRIMARY KEY,
  branch_id        TEXT NOT NULL REFERENCES public.branches(id),
  customer_name    TEXT,
  items            JSONB NOT NULL DEFAULT '[]',
  total_amount     NUMERIC NOT NULL DEFAULT 0,
  discount         NUMERIC,
  final_amount     NUMERIC NOT NULL DEFAULT 0,
  payment_method   TEXT NOT NULL DEFAULT 'cash',
  notes            TEXT,
  created_by       TEXT NOT NULL,
  created_at       TIMESTAMPTZ NOT NULL DEFAULT now(),
  sync_version     INT NOT NULL DEFAULT 1,
  last_modified    TIMESTAMPTZ NOT NULL DEFAULT now(),
  is_deleted       BOOLEAN NOT NULL DEFAULT false
);
CREATE INDEX IF NOT EXISTS idx_sales_branch ON public.sales(branch_id);
CREATE INDEX IF NOT EXISTS idx_sales_created ON public.sales(created_at);

-- ─── Purchases ───────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.purchases (
  id               TEXT PRIMARY KEY,
  branch_id        TEXT NOT NULL REFERENCES public.branches(id),
  supplier_name    TEXT NOT NULL,
  supplier_phone   TEXT,
  supplier_id      TEXT,
  items            JSONB NOT NULL DEFAULT '[]',
  total_amount     NUMERIC NOT NULL DEFAULT 0,
  discount         NUMERIC,
  final_amount     NUMERIC NOT NULL DEFAULT 0,
  payment_method   TEXT NOT NULL DEFAULT 'cash',
  paid_amount      NUMERIC,
  tax              NUMERIC,
  notes            TEXT,
  created_by       TEXT NOT NULL,
  created_at       TIMESTAMPTZ NOT NULL DEFAULT now(),
  sync_version     INT NOT NULL DEFAULT 1,
  last_modified    TIMESTAMPTZ NOT NULL DEFAULT now(),
  is_deleted       BOOLEAN NOT NULL DEFAULT false
);
CREATE INDEX IF NOT EXISTS idx_purchases_branch ON public.purchases(branch_id);
CREATE INDEX IF NOT EXISTS idx_purchases_created ON public.purchases(created_at);

-- ─── Inventory ───────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.inventory (
  id               TEXT PRIMARY KEY,
  medicine_id      TEXT NOT NULL,
  branch_id        TEXT NOT NULL REFERENCES public.branches(id),
  current_quantity INT NOT NULL DEFAULT 0,
  min_stock        INT NOT NULL DEFAULT 10,
  max_stock        INT NOT NULL DEFAULT 1000,
  last_restocked   TIMESTAMPTZ NOT NULL DEFAULT now(),
  sync_version     INT NOT NULL DEFAULT 1,
  last_modified    TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_inventory_branch ON public.inventory(branch_id);
CREATE INDEX IF NOT EXISTS idx_inventory_medicine ON public.inventory(medicine_id);

-- ─── Returns ─────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.returns (
  id               TEXT PRIMARY KEY,
  branch_id        TEXT NOT NULL REFERENCES public.branches(id),
  sale_id          TEXT,
  purchase_id      TEXT,
  items            JSONB NOT NULL DEFAULT '[]',
  total_amount     NUMERIC NOT NULL DEFAULT 0,
  reason           TEXT NOT NULL DEFAULT 'other',
  notes            TEXT,
  created_by       TEXT NOT NULL,
  created_at       TIMESTAMPTZ NOT NULL DEFAULT now(),
  sync_version     INT NOT NULL DEFAULT 1,
  last_modified    TIMESTAMPTZ NOT NULL DEFAULT now(),
  is_deleted       BOOLEAN NOT NULL DEFAULT false
);
CREATE INDEX IF NOT EXISTS idx_returns_branch ON public.returns(branch_id);

-- ─── Cashier Shifts ──────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.cashier_shifts (
  id               TEXT PRIMARY KEY,
  branch_id        TEXT NOT NULL REFERENCES public.branches(id),
  shift_number     INT NOT NULL DEFAULT 1,
  cashier_id       TEXT NOT NULL,
  cashier_name     TEXT NOT NULL DEFAULT '',
  device_id        TEXT NOT NULL DEFAULT '',
  opened_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  opening_cash     NUMERIC NOT NULL DEFAULT 0,
  status           TEXT NOT NULL DEFAULT 'open' CHECK (status IN ('open', 'closed')),
  closed_at        TIMESTAMPTZ,
  expected_cash    NUMERIC,
  counted_cash     NUMERIC,
  difference       NUMERIC,
  notes            TEXT,
  sync_version     INT NOT NULL DEFAULT 1,
  last_modified    TIMESTAMPTZ NOT NULL DEFAULT now(),
  is_deleted       BOOLEAN NOT NULL DEFAULT false
);
CREATE INDEX IF NOT EXISTS idx_cashier_shifts_branch ON public.cashier_shifts(branch_id);

-- ─── Quotes ──────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.quotes (
  id               TEXT PRIMARY KEY,
  branch_id        TEXT NOT NULL REFERENCES public.branches(id),
  number           INT NOT NULL DEFAULT 1,
  customer_name    TEXT NOT NULL DEFAULT '',
  notes            TEXT,
  items            JSONB NOT NULL DEFAULT '[]',
  subtotal         NUMERIC NOT NULL DEFAULT 0,
  discount         NUMERIC NOT NULL DEFAULT 0,
  total            NUMERIC NOT NULL DEFAULT 0,
  status           TEXT NOT NULL DEFAULT 'draft' CHECK (status IN ('draft', 'sent', 'accepted', 'rejected')),
  created_at       TIMESTAMPTZ NOT NULL DEFAULT now(),
  sync_version     INT NOT NULL DEFAULT 1,
  last_modified    TIMESTAMPTZ NOT NULL DEFAULT now(),
  is_deleted       BOOLEAN NOT NULL DEFAULT false
);
CREATE INDEX IF NOT EXISTS idx_quotes_branch ON public.quotes(branch_id);

-- ─── Customer Ledgers ────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.customer_ledgers (
  id               TEXT PRIMARY KEY,
  customer_id      TEXT NOT NULL,
  branch_id        TEXT NOT NULL REFERENCES public.branches(id),
  type             TEXT NOT NULL,
  debit            NUMERIC NOT NULL DEFAULT 0,
  credit           NUMERIC NOT NULL DEFAULT 0,
  balance_after    NUMERIC NOT NULL DEFAULT 0,
  reference_id     TEXT,
  reference_number TEXT,
  notes            TEXT,
  created_by       TEXT,
  entry_date       TIMESTAMPTZ NOT NULL DEFAULT now(),
  sync_version     INT NOT NULL DEFAULT 1,
  last_modified    TIMESTAMPTZ NOT NULL DEFAULT now(),
  is_deleted       BOOLEAN NOT NULL DEFAULT false
);
CREATE INDEX IF NOT EXISTS idx_customer_ledgers_customer ON public.customer_ledgers(customer_id);
CREATE INDEX IF NOT EXISTS idx_customer_ledgers_branch ON public.customer_ledgers(branch_id);

-- ─── Supplier Ledgers ────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.supplier_ledgers (
  id               TEXT PRIMARY KEY,
  supplier_id      TEXT NOT NULL,
  branch_id        TEXT NOT NULL REFERENCES public.branches(id),
  type             TEXT NOT NULL,
  debit            NUMERIC NOT NULL DEFAULT 0,
  credit           NUMERIC NOT NULL DEFAULT 0,
  balance_after    NUMERIC NOT NULL DEFAULT 0,
  reference_id     TEXT,
  reference_number TEXT,
  notes            TEXT,
  created_by       TEXT,
  entry_date       TIMESTAMPTZ NOT NULL DEFAULT now(),
  sync_version     INT NOT NULL DEFAULT 1,
  last_modified    TIMESTAMPTZ NOT NULL DEFAULT now(),
  is_deleted       BOOLEAN NOT NULL DEFAULT false
);
CREATE INDEX IF NOT EXISTS idx_supplier_ledgers_supplier ON public.supplier_ledgers(supplier_id);
CREATE INDEX IF NOT EXISTS idx_supplier_ledgers_branch ON public.supplier_ledgers(branch_id);

-- ─── Customer Groups ─────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.customer_groups (
  id               TEXT PRIMARY KEY,
  name             TEXT NOT NULL,
  description      TEXT,
  discount_percent NUMERIC NOT NULL DEFAULT 0,
  is_active        BOOLEAN NOT NULL DEFAULT true,
  created_at       TIMESTAMPTZ NOT NULL DEFAULT now(),
  sync_version     INT NOT NULL DEFAULT 1,
  last_modified    TIMESTAMPTZ NOT NULL DEFAULT now(),
  is_deleted       BOOLEAN NOT NULL DEFAULT false
);

-- ─── RLS Policies ───────────────────────────────────────────
DO $$ BEGIN
  ALTER TABLE public.branches ENABLE ROW LEVEL SECURITY;
  ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
  ALTER TABLE public.permissions ENABLE ROW LEVEL SECURITY;
  ALTER TABLE public.medicines ENABLE ROW LEVEL SECURITY;
  ALTER TABLE public.sales ENABLE ROW LEVEL SECURITY;
  ALTER TABLE public.purchases ENABLE ROW LEVEL SECURITY;
  ALTER TABLE public.inventory ENABLE ROW LEVEL SECURITY;
  ALTER TABLE public.returns ENABLE ROW LEVEL SECURITY;
  ALTER TABLE public.cashier_shifts ENABLE ROW LEVEL SECURITY;
  ALTER TABLE public.quotes ENABLE ROW LEVEL SECURITY;
  ALTER TABLE public.customer_ledgers ENABLE ROW LEVEL SECURITY;
  ALTER TABLE public.supplier_ledgers ENABLE ROW LEVEL SECURITY;
  ALTER TABLE public.customer_groups ENABLE ROW LEVEL SECURITY;
EXCEPTION WHEN OTHERS THEN NULL;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'Authenticated full access' AND tablename = 'branches') THEN
    CREATE POLICY "Authenticated full access" ON public.branches FOR ALL USING (auth.role() = 'authenticated');
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'Authenticated full access' AND tablename = 'users') THEN
    CREATE POLICY "Authenticated full access" ON public.users FOR ALL USING (auth.role() = 'authenticated');
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'Authenticated full access' AND tablename = 'permissions') THEN
    CREATE POLICY "Authenticated full access" ON public.permissions FOR ALL USING (auth.role() = 'authenticated');
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'Authenticated full access' AND tablename = 'medicines') THEN
    CREATE POLICY "Authenticated full access" ON public.medicines FOR ALL USING (auth.role() = 'authenticated');
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'Authenticated full access' AND tablename = 'sales') THEN
    CREATE POLICY "Authenticated full access" ON public.sales FOR ALL USING (auth.role() = 'authenticated');
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'Authenticated full access' AND tablename = 'purchases') THEN
    CREATE POLICY "Authenticated full access" ON public.purchases FOR ALL USING (auth.role() = 'authenticated');
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'Authenticated full access' AND tablename = 'inventory') THEN
    CREATE POLICY "Authenticated full access" ON public.inventory FOR ALL USING (auth.role() = 'authenticated');
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'Authenticated full access' AND tablename = 'returns') THEN
    CREATE POLICY "Authenticated full access" ON public.returns FOR ALL USING (auth.role() = 'authenticated');
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'Authenticated full access' AND tablename = 'cashier_shifts') THEN
    CREATE POLICY "Authenticated full access" ON public.cashier_shifts FOR ALL USING (auth.role() = 'authenticated');
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'Authenticated full access' AND tablename = 'quotes') THEN
    CREATE POLICY "Authenticated full access" ON public.quotes FOR ALL USING (auth.role() = 'authenticated');
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'Authenticated full access' AND tablename = 'customer_ledgers') THEN
    CREATE POLICY "Authenticated full access" ON public.customer_ledgers FOR ALL USING (auth.role() = 'authenticated');
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'Authenticated full access' AND tablename = 'supplier_ledgers') THEN
    CREATE POLICY "Authenticated full access" ON public.supplier_ledgers FOR ALL USING (auth.role() = 'authenticated');
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'Authenticated full access' AND tablename = 'customer_groups') THEN
    CREATE POLICY "Authenticated full access" ON public.customer_groups FOR ALL USING (auth.role() = 'authenticated');
  END IF;
END $$;
