-- ═══════════════════════════════════════════════════════════════════
-- Pharmacy System — 5/9 Purchases
-- الجداول: purchase_invoices, purchase_items, supplied_items
-- ═══════════════════════════════════════════════════════════════════

-- ─── فواتير المشتريات (Purchase Invoices) ──────────────────────────
CREATE TABLE IF NOT EXISTS public.purchase_invoices (
  id               TEXT PRIMARY KEY,
  invoice_number   TEXT NOT NULL,
  supplier_id      TEXT NOT NULL,
  supplier_name    TEXT NOT NULL,
  subtotal_amount  NUMERIC NOT NULL DEFAULT 0,
  discount_amount  NUMERIC NOT NULL DEFAULT 0,
  final_amount     NUMERIC NOT NULL DEFAULT 0,
  paid_amount      NUMERIC NOT NULL DEFAULT 0,
  remaining_amount NUMERIC NOT NULL DEFAULT 0,
  payment_method   TEXT NOT NULL DEFAULT 'cash',
  created_by       TEXT NOT NULL,
  branch_id        TEXT NOT NULL DEFAULT '',
  account_id       TEXT NOT NULL DEFAULT '',
  notes            TEXT,
  created_at       TIMESTAMPTZ NOT NULL DEFAULT now(),
  last_modified    TIMESTAMPTZ NOT NULL DEFAULT now(),
  is_deleted       BOOLEAN NOT NULL DEFAULT false
);

CREATE INDEX IF NOT EXISTS idx_purchase_invoices_supplier ON public.purchase_invoices(supplier_id);
CREATE INDEX IF NOT EXISTS idx_purchase_invoices_branch ON public.purchase_invoices(branch_id);
CREATE INDEX IF NOT EXISTS idx_purchase_invoices_account ON public.purchase_invoices(account_id);
CREATE INDEX IF NOT EXISTS idx_purchase_invoices_last_modified ON public.purchase_invoices(last_modified);

-- ─── سطور المشتريات (Purchase Items) ───────────────────────────────
CREATE TABLE IF NOT EXISTS public.purchase_items (
  id            TEXT PRIMARY KEY,
  invoice_id    TEXT NOT NULL REFERENCES public.purchase_invoices(id) ON DELETE CASCADE,
  medicine_id   TEXT NOT NULL,
  medicine_name TEXT NOT NULL,
  unit_level    INT NOT NULL DEFAULT 1,
  unit_name     TEXT NOT NULL DEFAULT 'علبة',
  quantity      INT NOT NULL DEFAULT 1,
  buy_price     NUMERIC NOT NULL DEFAULT 0,
  sell_price    NUMERIC NOT NULL DEFAULT 0,
  expiry_date   DATE,
  batch_number  TEXT,
  total_price   NUMERIC NOT NULL DEFAULT 0
);

CREATE INDEX IF NOT EXISTS idx_purchase_items_invoice ON public.purchase_items(invoice_id);
CREATE INDEX IF NOT EXISTS idx_purchase_items_medicine ON public.purchase_items(medicine_id);

-- ─── أصناف الموردين (Supplied Items) ────────────────────────────────
CREATE TABLE IF NOT EXISTS public.supplied_items (
  id            TEXT PRIMARY KEY,
  contact_id    TEXT NOT NULL,
  medicine_id   TEXT NOT NULL,
  medicine_name TEXT NOT NULL,
  unit_level    INT NOT NULL DEFAULT 1,
  unit_name     TEXT NOT NULL DEFAULT 'علبة',
  quantity      NUMERIC NOT NULL DEFAULT 0,
  unit_price    NUMERIC NOT NULL DEFAULT 0,
  discount_type TEXT NOT NULL DEFAULT 'percent',
  discount_value NUMERIC NOT NULL DEFAULT 0,
  tax_amount    NUMERIC NOT NULL DEFAULT 0,
  price_with_tax NUMERIC NOT NULL DEFAULT 0,
  total_amount  NUMERIC NOT NULL DEFAULT 0,
  date          TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_supplied_items_contact ON public.supplied_items(contact_id);
CREATE INDEX IF NOT EXISTS idx_supplied_items_medicine ON public.supplied_items(medicine_id);
