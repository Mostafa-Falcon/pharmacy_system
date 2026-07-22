-- ═══════════════════════════════════════════════════════════════
-- Add missing columns to align Supabase schema with Flutter models
-- Safe to re-run (idempotent).
-- ═══════════════════════════════════════════════════════════════

-- ─── Medicines ────────────────────────────────────────────────
ALTER TABLE public.medicines
  ADD COLUMN IF NOT EXISTS name_en TEXT,
  ADD COLUMN IF NOT EXISTS barcodes JSONB DEFAULT '[]',
  ADD COLUMN IF NOT EXISTS dosage_form TEXT,
  ADD COLUMN IF NOT EXISTS strength TEXT,
  ADD COLUMN IF NOT EXISTS package_size TEXT,
  ADD COLUMN IF NOT EXISTS expiry_tracking_enabled BOOLEAN NOT NULL DEFAULT false,
  ADD COLUMN IF NOT EXISTS supplier_name TEXT,
  ADD COLUMN IF NOT EXISTS description TEXT,
  ADD COLUMN IF NOT EXISTS old_sell_price NUMERIC,
  ADD COLUMN IF NOT EXISTS item_type_id TEXT,
  ADD COLUMN IF NOT EXISTS group_id TEXT,
  ADD COLUMN IF NOT EXISTS units JSONB DEFAULT '[]',
  ADD COLUMN IF NOT EXISTS alert_enabled BOOLEAN NOT NULL DEFAULT false,
  ADD COLUMN IF NOT EXISTS dosage_form_enabled BOOLEAN NOT NULL DEFAULT false,
  ADD COLUMN IF NOT EXISTS image_url TEXT,
  ADD COLUMN IF NOT EXISTS container_shape TEXT,
  ADD COLUMN IF NOT EXISTS allow_negative_stock BOOLEAN NOT NULL DEFAULT false,
  ADD COLUMN IF NOT EXISTS is_taxable BOOLEAN NOT NULL DEFAULT false,
  ADD COLUMN IF NOT EXISTS tax_type TEXT,
  ADD COLUMN IF NOT EXISTS tax_value NUMERIC,
  ADD COLUMN IF NOT EXISTS prices_include_tax BOOLEAN NOT NULL DEFAULT false,
  ADD COLUMN IF NOT EXISTS location TEXT,
  ADD COLUMN IF NOT EXISTS is_active BOOLEAN NOT NULL DEFAULT true,
  ADD COLUMN IF NOT EXISTS created_at TIMESTAMPTZ;

-- ─── Sales ────────────────────────────────────────────────────
ALTER TABLE public.sales
  ADD COLUMN IF NOT EXISTS customer_id TEXT,
  ADD COLUMN IF NOT EXISTS paid_amount NUMERIC,
  ADD COLUMN IF NOT EXISTS tax_amount NUMERIC,
  ADD COLUMN IF NOT EXISTS receipt_number TEXT,
  ADD COLUMN IF NOT EXISTS sales_rep_id TEXT;

CREATE INDEX IF NOT EXISTS idx_sales_customer ON public.sales(customer_id);

-- ─── Purchases ────────────────────────────────────────────────
ALTER TABLE public.purchases
  ADD COLUMN IF NOT EXISTS status TEXT NOT NULL DEFAULT 'completed',
  ADD COLUMN IF NOT EXISTS source_type TEXT,
  ADD COLUMN IF NOT EXISTS receipt_number TEXT,
  ADD COLUMN IF NOT EXISTS shipping_amount NUMERIC,
  ADD COLUMN IF NOT EXISTS delivery_amount NUMERIC,
  ADD COLUMN IF NOT EXISTS supplier_party_type TEXT,
  ADD COLUMN IF NOT EXISTS invoice_discount_type TEXT,
  ADD COLUMN IF NOT EXISTS invoice_discount_value NUMERIC,
  ADD COLUMN IF NOT EXISTS invoice_discount_amount NUMERIC,
  ADD COLUMN IF NOT EXISTS invoice_tax_type TEXT,
  ADD COLUMN IF NOT EXISTS invoice_tax_value NUMERIC,
  ADD COLUMN IF NOT EXISTS invoice_tax_amount NUMERIC,
  ADD COLUMN IF NOT EXISTS payment_account_id TEXT,
  ADD COLUMN IF NOT EXISTS payment_account_name TEXT;

-- ─── Customers ────────────────────────────────────────────────
ALTER TABLE public.customers
  ADD COLUMN IF NOT EXISTS kind TEXT NOT NULL DEFAULT 'regular',
  ADD COLUMN IF NOT EXISTS company_name TEXT,
  ADD COLUMN IF NOT EXISTS email TEXT,
  ADD COLUMN IF NOT EXISTS tax_id TEXT,
  ADD COLUMN IF NOT EXISTS credit_limit NUMERIC NOT NULL DEFAULT 0,
  ADD COLUMN IF NOT EXISTS discount_percent NUMERIC NOT NULL DEFAULT 0,
  ADD COLUMN IF NOT EXISTS payment_term_days INT NOT NULL DEFAULT 0,
  ADD COLUMN IF NOT EXISTS sales_rep_id TEXT;

CREATE INDEX IF NOT EXISTS idx_customers_kind ON public.customers(kind);

-- ─── Suppliers ────────────────────────────────────────────────
ALTER TABLE public.suppliers
  ADD COLUMN IF NOT EXISTS party_type TEXT NOT NULL DEFAULT 'company',
  ADD COLUMN IF NOT EXISTS company_name TEXT,
  ADD COLUMN IF NOT EXISTS email TEXT,
  ADD COLUMN IF NOT EXISTS tax_id TEXT,
  ADD COLUMN IF NOT EXISTS credit_limit NUMERIC NOT NULL DEFAULT 0,
  ADD COLUMN IF NOT EXISTS discount_percent NUMERIC NOT NULL DEFAULT 0,
  ADD COLUMN IF NOT EXISTS payment_term_days INT NOT NULL DEFAULT 0;

CREATE INDEX IF NOT EXISTS idx_suppliers_party_type ON public.suppliers(party_type);

-- ─── Customer Suppliers ───────────────────────────────────────
ALTER TABLE public.customer_suppliers
  ADD COLUMN IF NOT EXISTS email TEXT,
  ADD COLUMN IF NOT EXISTS company_name TEXT,
  ADD COLUMN IF NOT EXISTS tax_id TEXT,
  ADD COLUMN IF NOT EXISTS customer_kind_index INT NOT NULL DEFAULT 0,
  ADD COLUMN IF NOT EXISTS credit_limit NUMERIC NOT NULL DEFAULT 0,
  ADD COLUMN IF NOT EXISTS discount_percent NUMERIC NOT NULL DEFAULT 0,
  ADD COLUMN IF NOT EXISTS payment_term_days INT NOT NULL DEFAULT 0,
  ADD COLUMN IF NOT EXISTS supplier_party_type_index INT NOT NULL DEFAULT 0;

-- ─── Customer Groups ──────────────────────────────────────────
ALTER TABLE public.customer_groups
  ADD COLUMN IF NOT EXISTS discount_percent NUMERIC NOT NULL DEFAULT 0,
  ADD COLUMN IF NOT EXISTS price_group_id TEXT,
  ADD COLUMN IF NOT EXISTS description TEXT;

-- ─── Promotions ───────────────────────────────────────────────
ALTER TABLE public.promotions
  ADD COLUMN IF NOT EXISTS medicine_id TEXT,
  ADD COLUMN IF NOT EXISTS name TEXT,
  ADD COLUMN IF NOT EXISTS description TEXT,
  ADD COLUMN IF NOT EXISTS discount_type TEXT,
  ADD COLUMN IF NOT EXISTS discount_value NUMERIC,
  ADD COLUMN IF NOT EXISTS start_date TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS end_date TIMESTAMPTZ;

-- ─── Expenses ────────────────────────────────────────────────
ALTER TABLE public.expenses
  ADD COLUMN IF NOT EXISTS last_modified TIMESTAMPTZ NOT NULL DEFAULT NOW();

-- Ensure last_modified is present and indexed for pull watermark
CREATE INDEX IF NOT EXISTS idx_medicines_last_modified ON public.medicines(last_modified);
CREATE INDEX IF NOT EXISTS idx_sales_last_modified ON public.sales(last_modified);
CREATE INDEX IF NOT EXISTS idx_purchases_last_modified ON public.purchases(last_modified);
CREATE INDEX IF NOT EXISTS idx_customers_last_modified ON public.customers(last_modified);
CREATE INDEX IF NOT EXISTS idx_suppliers_last_modified ON public.suppliers(last_modified);
CREATE INDEX IF NOT EXISTS idx_customer_suppliers_last_modified ON public.customer_suppliers(last_modified);
CREATE INDEX IF NOT EXISTS idx_customer_groups_last_modified ON public.customer_groups(last_modified);
CREATE INDEX IF NOT EXISTS idx_promotions_last_modified ON public.promotions(last_modified);
CREATE INDEX IF NOT EXISTS idx_archive_records_last_modified ON public.archive_records(last_modified);
CREATE INDEX IF NOT EXISTS idx_stocktaking_periods_last_modified ON public.stocktaking_periods(last_modified);
CREATE INDEX IF NOT EXISTS idx_stocktaking_counts_last_modified ON public.stocktaking_counts(last_modified);
CREATE INDEX IF NOT EXISTS idx_branches_last_modified ON public.branches(last_modified);
CREATE INDEX IF NOT EXISTS idx_users_last_modified ON public.users(last_modified);
CREATE INDEX IF NOT EXISTS idx_permissions_last_modified ON public.permissions(last_modified);
CREATE INDEX IF NOT EXISTS idx_customer_ledgers_last_modified ON public.customer_ledgers(last_modified);
CREATE INDEX IF NOT EXISTS idx_supplier_ledgers_last_modified ON public.supplier_ledgers(last_modified);
CREATE INDEX IF NOT EXISTS idx_quotes_last_modified ON public.quotes(last_modified);
CREATE INDEX IF NOT EXISTS idx_cashier_shifts_last_modified ON public.cashier_shifts(last_modified);
CREATE INDEX IF NOT EXISTS idx_returns_last_modified ON public.returns(last_modified);
CREATE INDEX IF NOT EXISTS idx_expenses_last_modified ON public.expenses(last_modified);
