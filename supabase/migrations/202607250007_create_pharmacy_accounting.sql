-- ═══════════════════════════════════════════════════════════════════
-- Pharmacy System — 7/9 Accounting (Model-Driven Alignment)
-- الجداول: account_tree, expense_categories, expenses,
--          journal_entries, payment_vouchers
-- ═══════════════════════════════════════════════════════════════════

-- ─── شجرة الحسابات (Account Tree) - مطابقة لـ AccountTreeModel ─────
CREATE TABLE IF NOT EXISTS public.account_tree (
  id                TEXT PRIMARY KEY,
  account_code      TEXT NOT NULL,
  name              TEXT NOT NULL,
  account_type      TEXT NOT NULL,
  parent_account_id TEXT,
  current_balance   NUMERIC NOT NULL DEFAULT 0,
  is_debit_nature   BOOLEAN NOT NULL DEFAULT true,
  is_sub_account    BOOLEAN NOT NULL DEFAULT true,
  is_active         BOOLEAN NOT NULL DEFAULT true,
  account_id        TEXT NOT NULL,
  description       TEXT,
  last_modified     TIMESTAMPTZ NOT NULL DEFAULT now(),
  is_deleted        BOOLEAN NOT NULL DEFAULT false,
  sync_version      INT NOT NULL DEFAULT 1
);

-- ─── فئات المصاريف (Expense Categories) ───────────────────────────
CREATE TABLE IF NOT EXISTS public.expense_categories (
  id            TEXT PRIMARY KEY,
  name          TEXT NOT NULL,
  code          TEXT,
  description   TEXT,
  is_active     BOOLEAN NOT NULL DEFAULT true,
  account_id    TEXT NOT NULL,
  last_modified TIMESTAMPTZ NOT NULL DEFAULT now(),
  is_deleted    BOOLEAN NOT NULL DEFAULT false,
  sync_version  INT NOT NULL DEFAULT 1
);

-- ─── المصاريف (Expenses) - مطابقة لـ ExpenseModel ──────────────────
CREATE TABLE IF NOT EXISTS public.expenses (
  id               TEXT PRIMARY KEY,
  expense_number   INT NOT NULL,
  category         TEXT NOT NULL, -- Band/Category name
  description      TEXT,
  amount           NUMERIC NOT NULL DEFAULT 0,
  payment_method   TEXT NOT NULL DEFAULT 'cash',
  created_by_id    TEXT NOT NULL,
  created_by_name  TEXT,
  branch_id        TEXT NOT NULL,
  account_id       TEXT NOT NULL,
  notes            TEXT,
  expense_date     TIMESTAMPTZ NOT NULL DEFAULT now(),
  created_at       TIMESTAMPTZ NOT NULL DEFAULT now(),
  last_modified    TIMESTAMPTZ NOT NULL DEFAULT now(),
  is_deleted       BOOLEAN NOT NULL DEFAULT false,
  sync_version     INT NOT NULL DEFAULT 1
);

-- ─── قيود اليومية (Journal Entries) - مطابقة لـ JournalEntryModel ──
CREATE TABLE IF NOT EXISTS public.journal_entries (
  id               TEXT PRIMARY KEY,
  entry_number     INT NOT NULL,
  entry_date       TIMESTAMPTZ NOT NULL DEFAULT now(),
  entry_type       TEXT NOT NULL DEFAULT 'general',
  reference_number TEXT,
  description      TEXT,

  lines            JSONB NOT NULL DEFAULT '[]', -- List<JournalEntryLineModel>

  total_debit      NUMERIC NOT NULL DEFAULT 0,
  total_credit     NUMERIC NOT NULL DEFAULT 0,
  created_by_id    TEXT NOT NULL,
  branch_id        TEXT NOT NULL,
  account_id       TEXT NOT NULL,
  created_at       TIMESTAMPTZ NOT NULL DEFAULT now(),
  last_modified    TIMESTAMPTZ NOT NULL DEFAULT now(),
  is_deleted       BOOLEAN NOT NULL DEFAULT false,
  sync_version     INT NOT NULL DEFAULT 1
);

-- ─── سندات القبض والدفع (Payment Vouchers) ───────────────────────
CREATE TABLE IF NOT EXISTS public.payment_vouchers (
  id               TEXT PRIMARY KEY,
  voucher_number   INT NOT NULL,
  voucher_type     TEXT NOT NULL CHECK (voucher_type IN ('receipt', 'payment')),
  party_id         TEXT,
  party_name       TEXT NOT NULL,
  amount           NUMERIC NOT NULL DEFAULT 0,
  payment_method   TEXT NOT NULL DEFAULT 'cash',
  reference_number TEXT,
  description      TEXT,
  created_by_id    TEXT NOT NULL,
  branch_id        TEXT NOT NULL,
  account_id       TEXT NOT NULL,
  voucher_date     TIMESTAMPTZ NOT NULL DEFAULT now(),
  created_at       TIMESTAMPTZ NOT NULL DEFAULT now(),
  last_modified    TIMESTAMPTZ NOT NULL DEFAULT now(),
  is_deleted       BOOLEAN NOT NULL DEFAULT false,
  sync_version     INT NOT NULL DEFAULT 1
);

-- ─── Indexes ──────────────────────────────────────────────────────
CREATE INDEX IF NOT EXISTS idx_journal_entries_account ON public.journal_entries(account_id);
CREATE INDEX IF NOT EXISTS idx_expenses_branch ON public.expenses(branch_id);
