-- ═══════════════════════════════════════════════════════════════════
-- Pharmacy System — 6/9 Sales (Model-Driven Alignment)
-- الجداول: sale_invoices, cashier_shifts, invoice_returns, free_returns,
--          quotations, shipping_orders, promotions
-- ═══════════════════════════════════════════════════════════════════

-- ─── فواتير المبيعات (Sale Invoices) - مطابقة لـ SaleInvoiceModel ───
CREATE TABLE IF NOT EXISTS public.sale_invoices (
  id               TEXT PRIMARY KEY,
  invoice_number   TEXT NOT NULL,
  customer_name    TEXT NOT NULL DEFAULT 'زبون نقدي',
  customer_id      TEXT,
  cash_register_id TEXT NOT NULL,

  items            JSONB NOT NULL DEFAULT '[]', -- List<SaleItemModel>

  subtotal_amount  NUMERIC NOT NULL DEFAULT 0,
  discount_amount  NUMERIC NOT NULL DEFAULT 0,
  final_amount     NUMERIC NOT NULL DEFAULT 0,
  paid_amount      NUMERIC NOT NULL DEFAULT 0,
  remaining_amount NUMERIC NOT NULL DEFAULT 0,

  payment_method   TEXT NOT NULL DEFAULT 'cash',
  created_by       TEXT NOT NULL,
  branch_id        TEXT NOT NULL,
  account_id       TEXT NOT NULL,
  notes            TEXT,

  created_at       TIMESTAMPTZ NOT NULL DEFAULT now(),
  last_modified    TIMESTAMPTZ NOT NULL DEFAULT now(),
  is_deleted       BOOLEAN NOT NULL DEFAULT false,
  sync_version     INT NOT NULL DEFAULT 1
);

-- ─── ورديات الكاشير (Cashier Shifts) ────────────────────────────────
CREATE TABLE IF NOT EXISTS public.cashier_shifts (
  id            TEXT PRIMARY KEY,
  shift_number  INT NOT NULL DEFAULT 1,
  branch_id     TEXT NOT NULL,
  cashier_id    TEXT NOT NULL,
  cashier_name  TEXT NOT NULL DEFAULT '',
  device_id     TEXT NOT NULL DEFAULT 'POS-1',
  opened_at     TIMESTAMPTZ NOT NULL DEFAULT now(),
  opening_cash  NUMERIC NOT NULL DEFAULT 0,
  status        TEXT NOT NULL DEFAULT 'open',
  closed_at     TIMESTAMPTZ,
  expected_cash NUMERIC,
  counted_cash  NUMERIC,
  difference    NUMERIC,
  account_id    TEXT NOT NULL,
  notes         TEXT,
  last_modified TIMESTAMPTZ NOT NULL DEFAULT now(),
  is_deleted    BOOLEAN NOT NULL DEFAULT false,
  sync_version  INT NOT NULL DEFAULT 1
);

-- ─── مرتجعات الفواتير (Invoice Returns) ────────────────────────────
CREATE TABLE IF NOT EXISTS public.invoice_returns (
  id                     TEXT PRIMARY KEY,
  return_number          TEXT NOT NULL,
  original_invoice_number TEXT NOT NULL,
  original_invoice_id    TEXT NOT NULL,
  customer_name          TEXT NOT NULL DEFAULT 'زبون نقدي',
  customer_id            TEXT,

  items                  JSONB NOT NULL DEFAULT '[]', -- List<InvoiceReturnItemModel>

  return_discount        NUMERIC NOT NULL DEFAULT 0,
  total_return_amount    NUMERIC NOT NULL DEFAULT 0,
  created_by             TEXT NOT NULL,
  branch_id              TEXT NOT NULL,
  account_id             TEXT NOT NULL,
  notes                  TEXT,
  created_at             TIMESTAMPTZ NOT NULL DEFAULT now(),
  last_modified          TIMESTAMPTZ NOT NULL DEFAULT now(),
  is_deleted             BOOLEAN NOT NULL DEFAULT false,
  sync_version           INT NOT NULL DEFAULT 1
);

-- ─── المرتجعات الحرة (Free Returns) ─────────────────────────────────
CREATE TABLE IF NOT EXISTS public.free_returns (
  id               TEXT PRIMARY KEY,
  return_number    TEXT NOT NULL,
  return_category  TEXT NOT NULL,
  party_type       TEXT NOT NULL DEFAULT 'cash',
  party_id         TEXT,
  party_name       TEXT NOT NULL DEFAULT 'نقدي',
  cash_register_id TEXT NOT NULL,

  items            JSONB NOT NULL DEFAULT '[]', -- List<FreeReturnItemModel>

  reason_notes     TEXT,
  total_amount     NUMERIC NOT NULL DEFAULT 0,
  created_by       TEXT NOT NULL,
  branch_id        TEXT NOT NULL,
  account_id       TEXT NOT NULL,
  created_at       TIMESTAMPTZ NOT NULL DEFAULT now(),
  last_modified    TIMESTAMPTZ NOT NULL DEFAULT now(),
  is_deleted       BOOLEAN NOT NULL DEFAULT false,
  sync_version     INT NOT NULL DEFAULT 1
);

-- ─── عروض الأسعار (Quotations) ─────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.quotations (
  id                TEXT PRIMARY KEY,
  quotation_number  TEXT NOT NULL,
  customer_id       TEXT,
  customer_name     TEXT NOT NULL DEFAULT 'زبون نقدي',
  customer_phone    TEXT,

  items             JSONB NOT NULL DEFAULT '[]', -- List<QuotationItemModel>

  subtotal_amount   NUMERIC NOT NULL DEFAULT 0,
  discount_amount   NUMERIC NOT NULL DEFAULT 0,
  final_amount      NUMERIC NOT NULL DEFAULT 0,
  status            TEXT NOT NULL DEFAULT 'draft',
  created_by        TEXT NOT NULL,
  branch_id         TEXT NOT NULL,
  account_id        TEXT NOT NULL,
  notes             TEXT,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  last_modified     TIMESTAMPTZ NOT NULL DEFAULT now(),
  is_deleted        BOOLEAN NOT NULL DEFAULT false,
  sync_version      INT NOT NULL DEFAULT 1
);

-- ─── أوامر الشحن (Shipping Orders) ──────────────────────────────────
CREATE TABLE IF NOT EXISTS public.shipping_orders (
  id                TEXT PRIMARY KEY,
  invoice_number    TEXT NOT NULL,
  invoice_id        TEXT NOT NULL,
  shipping_date     TIMESTAMPTZ NOT NULL DEFAULT now(),
  customer_name     TEXT NOT NULL DEFAULT 'زبون نقدي',
  customer_phone    TEXT,
  shipping_address  TEXT NOT NULL DEFAULT '',
  shipping_details  TEXT,
  delivered_to      TEXT,
  delivery_agent_id TEXT,
  delivery_agent_name TEXT,
  shipping_status   TEXT NOT NULL DEFAULT 'pending',
  is_paid           BOOLEAN NOT NULL DEFAULT false,
  notes             TEXT,
  document_urls     JSONB, -- List of strings as JSON
  created_by        TEXT NOT NULL,
  branch_id         TEXT NOT NULL,
  account_id        TEXT NOT NULL,
  last_modified     TIMESTAMPTZ NOT NULL DEFAULT now(),
  is_deleted        BOOLEAN NOT NULL DEFAULT false,
  sync_version      INT NOT NULL DEFAULT 1
);

-- ─── العروض الترويجية (Promotions) ─────────────────────────────────
CREATE TABLE IF NOT EXISTS public.promotions (
  id                   TEXT PRIMARY KEY,
  name                 TEXT NOT NULL,
  selected_medicine_ids JSONB,
  category_id          TEXT,
  brand_id             TEXT,
  priority             INT NOT NULL DEFAULT 1,
  discount_type        TEXT NOT NULL DEFAULT 'percentage',
  discount_value       NUMERIC NOT NULL DEFAULT 0,
  start_date           TIMESTAMPTZ NOT NULL,
  end_date             TIMESTAMPTZ NOT NULL,
  is_active            BOOLEAN NOT NULL DEFAULT true,
  branch_id            TEXT NOT NULL,
  account_id           TEXT NOT NULL,
  last_modified        TIMESTAMPTZ NOT NULL DEFAULT now(),
  is_deleted           BOOLEAN NOT NULL DEFAULT false,
  sync_version         INT NOT NULL DEFAULT 1
);

-- ─── Indexes ──────────────────────────────────────────────────────
CREATE INDEX IF NOT EXISTS idx_sale_invoices_last_modified ON public.sale_invoices(last_modified);
CREATE INDEX IF NOT EXISTS idx_cashier_shifts_last_modified ON public.cashier_shifts(last_modified);
