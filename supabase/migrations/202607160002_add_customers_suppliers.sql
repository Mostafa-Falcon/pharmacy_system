-- ═══════════════════════════════════════════════════════════════
-- Customers & Suppliers tables
-- Supports the 3 party types used by the system:
--   customers        -> pure customers
--   suppliers        -> pure suppliers  (type = 'supplier')
--                    -> customer+supplier (type = 'customerSupplier')
-- (The unified `customer_suppliers` table is handled by its own box
--  but kept in sync for the contacts screen.)
-- Idempotent / safe to re-run.
-- ═══════════════════════════════════════════════════════════════

-- ─── Customers ────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.customers (
  id               TEXT PRIMARY KEY,
  name             TEXT NOT NULL,
  phone            TEXT,
  address          TEXT,
  is_active        BOOLEAN NOT NULL DEFAULT true,
  kind             TEXT NOT NULL DEFAULT 'regular'
                   CHECK (kind IN ('regular', 'cash')),
  company_name     TEXT,
  email            TEXT,
  tax_id           TEXT,
  credit_limit     NUMERIC NOT NULL DEFAULT 0,
  discount_percent NUMERIC NOT NULL DEFAULT 0,
  payment_term_days INT NOT NULL DEFAULT 0,
  notes            TEXT,
  branch_id        TEXT,
  sync_version     INT NOT NULL DEFAULT 1,
  last_modified    TIMESTAMPTZ NOT NULL DEFAULT now(),
  is_deleted       BOOLEAN NOT NULL DEFAULT false
);
CREATE INDEX IF NOT EXISTS idx_customers_branch ON public.customers(branch_id);
CREATE INDEX IF NOT EXISTS idx_customers_phone ON public.customers(phone);

-- ─── Suppliers ────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.suppliers (
  id               TEXT PRIMARY KEY,
  name             TEXT NOT NULL,
  type             TEXT NOT NULL DEFAULT 'supplier'
                   CHECK (type IN ('supplier', 'customerSupplier')),
  party_type       TEXT NOT NULL DEFAULT 'company'
                   CHECK (party_type IN ('company', 'individual')),
  phone            TEXT,
  address          TEXT,
  is_active        BOOLEAN NOT NULL DEFAULT true,
  company_name     TEXT,
  email            TEXT,
  tax_id           TEXT,
  credit_limit     NUMERIC NOT NULL DEFAULT 0,
  discount_percent NUMERIC NOT NULL DEFAULT 0,
  payment_term_days INT NOT NULL DEFAULT 0,
  notes            TEXT,
  branch_id        TEXT,
  sync_version     INT NOT NULL DEFAULT 1,
  last_modified    TIMESTAMPTZ NOT NULL DEFAULT now(),
  is_deleted       BOOLEAN NOT NULL DEFAULT false
);
CREATE INDEX IF NOT EXISTS idx_suppliers_branch ON public.suppliers(branch_id);
CREATE INDEX IF NOT EXISTS idx_suppliers_phone ON public.suppliers(phone);
CREATE INDEX IF NOT EXISTS idx_suppliers_type ON public.suppliers(type);

-- ─── RLS ──────────────────────────────────────────────────────
DO $$ BEGIN
  ALTER TABLE public.customers ENABLE ROW LEVEL SECURITY;
  ALTER TABLE public.suppliers ENABLE ROW LEVEL SECURITY;
EXCEPTION WHEN OTHERS THEN NULL;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'Authenticated full access' AND tablename = 'customers') THEN
    CREATE POLICY "Authenticated full access" ON public.customers FOR ALL USING (auth.role() = 'authenticated');
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'Authenticated full access' AND tablename = 'suppliers') THEN
    CREATE POLICY "Authenticated full access" ON public.suppliers FOR ALL USING (auth.role() = 'authenticated');
  END IF;
END $$;
