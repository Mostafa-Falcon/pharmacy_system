-- ═══════════════════════════════════════════════════════════════
-- Unified customer_suppliers table
-- Matches CustomerSupplierModel.toJson() used by the local Hive box
-- and the Supabase sync pull/push. Idempotent / safe to re-run.
-- ═══════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS public.customer_suppliers (
  id                        TEXT PRIMARY KEY,
  name                      TEXT NOT NULL,
  phone                     TEXT,
  address                   TEXT,
  email                     TEXT,
  company_name              TEXT,
  tax_id                    TEXT,
  is_active                 BOOLEAN NOT NULL DEFAULT true,
  notes                     TEXT,
  customer_kind_index       INT NOT NULL DEFAULT 0,
  credit_limit              NUMERIC NOT NULL DEFAULT 0,
  discount_percent          NUMERIC NOT NULL DEFAULT 0,
  payment_term_days         INT NOT NULL DEFAULT 0,
  supplier_party_type_index INT NOT NULL DEFAULT 0,
  branch_id                 TEXT,
  sync_version              INT NOT NULL DEFAULT 1,
  last_modified             TIMESTAMPTZ NOT NULL DEFAULT now(),
  is_deleted                BOOLEAN NOT NULL DEFAULT false
);
CREATE INDEX IF NOT EXISTS idx_customer_suppliers_branch ON public.customer_suppliers(branch_id);
CREATE INDEX IF NOT EXISTS idx_customer_suppliers_phone ON public.customer_suppliers(phone);

-- ─── RLS ──────────────────────────────────────────────────────
DO $$ BEGIN
  ALTER TABLE public.customer_suppliers ENABLE ROW LEVEL SECURITY;
EXCEPTION WHEN OTHERS THEN NULL;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'Authenticated full access' AND tablename = 'customer_suppliers') THEN
    CREATE POLICY "Authenticated full access" ON public.customer_suppliers FOR ALL USING (auth.role() = 'authenticated');
  END IF;
END $$;
