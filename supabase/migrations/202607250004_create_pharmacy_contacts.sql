-- ═══════════════════════════════════════════════════════════════════
-- Pharmacy System — 4/9 Contacts (Model-Driven Alignment)
-- الجداول: customers, suppliers, supplier_customers, customer_groups,
--          sales_agents, contact_ledger
-- ═══════════════════════════════════════════════════════════════════

-- ─── مجموعات العملاء (Customer Groups) ─────────────────────────────
CREATE TABLE IF NOT EXISTS public.customer_groups (
  id               TEXT PRIMARY KEY,
  name             TEXT NOT NULL,
  discount_percent NUMERIC NOT NULL DEFAULT 0,
  price_group_id   TEXT,
  description      TEXT,
  is_active        BOOLEAN NOT NULL DEFAULT true,
  account_id       TEXT NOT NULL,
  last_modified    TIMESTAMPTZ NOT NULL DEFAULT now(),
  is_deleted       BOOLEAN NOT NULL DEFAULT false,
  sync_version     INT NOT NULL DEFAULT 1
);

-- ─── العملاء (Customers) - مطابقة لـ CustomerModel ──────────────────
CREATE TABLE IF NOT EXISTS public.customers (
  id               TEXT PRIMARY KEY,
  name             TEXT NOT NULL,
  phone            TEXT,
  address          TEXT,
  email            TEXT,
  credit_limit     NUMERIC NOT NULL DEFAULT 0,
  discount_percent NUMERIC NOT NULL DEFAULT 0,

  debit_amount     NUMERIC NOT NULL DEFAULT 0,
  credit_amount    NUMERIC NOT NULL DEFAULT 0,

  is_active        BOOLEAN NOT NULL DEFAULT true,
  notes            TEXT,
  branch_id        TEXT,
  account_id       TEXT NOT NULL,
  last_modified    TIMESTAMPTZ NOT NULL DEFAULT now(),
  is_deleted       BOOLEAN NOT NULL DEFAULT false,
  sync_version     INT NOT NULL DEFAULT 1
);

-- ─── الموردين (Suppliers) - مطابقة لـ SupplierModel ──────────────────
CREATE TABLE IF NOT EXISTS public.suppliers (
  id                TEXT PRIMARY KEY,
  name              TEXT NOT NULL,
  phone             TEXT,
  address           TEXT,
  email             TEXT,
  contact_person    TEXT,
  tax_id            TEXT,

  credit_amount     NUMERIC NOT NULL DEFAULT 0,
  debit_amount      NUMERIC NOT NULL DEFAULT 0,

  payment_term_days INT NOT NULL DEFAULT 0,
  is_active         BOOLEAN NOT NULL DEFAULT true,
  notes             TEXT,
  branch_id         TEXT,
  account_id        TEXT NOT NULL,
  last_modified     TIMESTAMPTZ NOT NULL DEFAULT now(),
  is_deleted        BOOLEAN NOT NULL DEFAULT false,
  sync_version      INT NOT NULL DEFAULT 1
);

-- ─── مورد/عميل موحد (Supplier Customers) ────────────────────────────
CREATE TABLE IF NOT EXISTS public.supplier_customers (
  id                TEXT PRIMARY KEY,
  name              TEXT NOT NULL,
  phone             TEXT,
  address           TEXT,
  email             TEXT,
  company_name      TEXT,
  tax_id            TEXT,
  credit_limit      NUMERIC NOT NULL DEFAULT 0,
  discount_percent  NUMERIC NOT NULL DEFAULT 0,
  payment_term_days INT NOT NULL DEFAULT 0,
  supplier_balance  NUMERIC NOT NULL DEFAULT 0,
  customer_balance  NUMERIC NOT NULL DEFAULT 0,
  is_active         BOOLEAN NOT NULL DEFAULT true,
  notes             TEXT,
  branch_id         TEXT,
  account_id        TEXT NOT NULL,
  last_modified     TIMESTAMPTZ NOT NULL DEFAULT now(),
  is_deleted        BOOLEAN NOT NULL DEFAULT false,
  sync_version      INT NOT NULL DEFAULT 1
);

-- ─── مندوبي المبيعات (Sales Agents) ────────────────────────────────
CREATE TABLE IF NOT EXISTS public.sales_agents (
  id                      TEXT PRIMARY KEY,
  name                    TEXT NOT NULL,
  phone                   TEXT,
  email                   TEXT,
  commission_percentage   NUMERIC NOT NULL DEFAULT 0,
  total_commission_earned NUMERIC NOT NULL DEFAULT 0,
  is_active               BOOLEAN NOT NULL DEFAULT true,
  notes                   TEXT,
  branch_id               TEXT,
  account_id              TEXT NOT NULL,
  last_modified           TIMESTAMPTZ NOT NULL DEFAULT now(),
  is_deleted              BOOLEAN NOT NULL DEFAULT false,
  sync_version            INT NOT NULL DEFAULT 1
);

-- ─── دفتر الأستاذ الموحد (Contact Ledger) ───────────────────────────
CREATE TABLE IF NOT EXISTS public.contact_ledger (
  id                TEXT PRIMARY KEY,
  contact_id        TEXT NOT NULL,
  entry_date        TIMESTAMPTZ NOT NULL DEFAULT now(),
  reference_number  TEXT NOT NULL,
  entry_type        TEXT NOT NULL,
  debit             NUMERIC NOT NULL DEFAULT 0,
  credit            NUMERIC NOT NULL DEFAULT 0,
  balance_after     NUMERIC NOT NULL DEFAULT 0,
  description       TEXT,
  branch_id         TEXT,
  account_id        TEXT NOT NULL,
  last_modified     TIMESTAMPTZ NOT NULL DEFAULT now(),
  is_deleted        BOOLEAN NOT NULL DEFAULT false,
  sync_version      INT NOT NULL DEFAULT 1
);

-- ─── Indexes ──────────────────────────────────────────────────────
CREATE INDEX IF NOT EXISTS idx_customers_account ON public.customers(account_id);
CREATE INDEX IF NOT EXISTS idx_suppliers_account ON public.suppliers(account_id);
CREATE INDEX IF NOT EXISTS idx_contact_ledger_contact ON public.contact_ledger(contact_id);
