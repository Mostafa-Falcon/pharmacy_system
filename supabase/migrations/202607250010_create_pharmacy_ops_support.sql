-- ═══════════════════════════════════════════════════════════════════
-- Pharmacy System — 10/10 Operations Support Tables
-- الجداول: suspended_sales, bulk_price_updates, items_archive,
--          inventory_transactions, notifications, lookups,
--          app_settings, receipt_counters, archive_records,
--          audit_logs
-- ═══════════════════════════════════════════════════════════════════

-- ─── المبيعات المعلقة (Suspended Sales) ────────────────────────────
CREATE TABLE IF NOT EXISTS public.suspended_sales (
  id            TEXT PRIMARY KEY,
  label         TEXT NOT NULL DEFAULT '',
  items_json    TEXT NOT NULL DEFAULT '[]',
  total_amount  NUMERIC NOT NULL DEFAULT 0,
  created_by    TEXT NOT NULL,
  branch_id     TEXT NOT NULL DEFAULT '',
  account_id    TEXT NOT NULL DEFAULT '',
  notes         TEXT,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  last_modified TIMESTAMPTZ NOT NULL DEFAULT now(),
  is_deleted    BOOLEAN NOT NULL DEFAULT false
);

CREATE INDEX IF NOT EXISTS idx_suspended_sales_branch ON public.suspended_sales(branch_id);
CREATE INDEX IF NOT EXISTS idx_suspended_sales_account ON public.suspended_sales(account_id);
CREATE INDEX IF NOT EXISTS idx_suspended_sales_last_modified ON public.suspended_sales(last_modified);

-- ─── تحديثات الأسعار المجمعة (Bulk Price Updates) ──────────────────
CREATE TABLE IF NOT EXISTS public.bulk_price_updates (
  id              TEXT PRIMARY KEY,
  update_type     TEXT NOT NULL CHECK (update_type IN ('markup', 'discount', 'fixed')),
  update_value    NUMERIC NOT NULL DEFAULT 0,
  apply_to        TEXT NOT NULL DEFAULT 'all' CHECK (apply_to IN ('all', 'category', 'brand', 'supplier', 'selected')),
  category_id     TEXT,
  brand_id        TEXT,
  supplier_id     TEXT,
  selected_ids    JSONB,
  affected_count  INT NOT NULL DEFAULT 0,
  created_by      TEXT NOT NULL,
  branch_id       TEXT NOT NULL DEFAULT '',
  account_id      TEXT NOT NULL DEFAULT '',
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_bulk_price_updates_branch ON public.bulk_price_updates(branch_id);

-- ─── أرشيف الأصناف المحذوفة (Items Archive) ───────────────────────
CREATE TABLE IF NOT EXISTS public.items_archive (
  id            TEXT PRIMARY KEY,
  original_id   TEXT NOT NULL,
  medicine_name TEXT NOT NULL,
  archived_data JSONB NOT NULL DEFAULT '{}',
  archived_by   TEXT NOT NULL,
  branch_id     TEXT NOT NULL DEFAULT '',
  account_id    TEXT NOT NULL DEFAULT '',
  archived_at   TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_items_archive_branch ON public.items_archive(branch_id);
CREATE INDEX IF NOT EXISTS idx_items_archive_account ON public.items_archive(account_id);

-- ─── سجل حركات المخزون (Inventory Transactions) ───────────────────
CREATE TABLE IF NOT EXISTS public.inventory_transactions (
  id            TEXT PRIMARY KEY,
  medicine_id   TEXT NOT NULL,
  medicine_name TEXT NOT NULL,
  transaction_type TEXT NOT NULL CHECK (transaction_type IN ('purchase', 'sale', 'return', 'adjustment', 'swap', 'transfer', 'opening')),
  unit_level    INT NOT NULL DEFAULT 1,
  quantity      INT NOT NULL DEFAULT 0,
  unit_price    NUMERIC NOT NULL DEFAULT 0,
  reference_id  TEXT,
  reference_number TEXT,
  before_qty    INT NOT NULL DEFAULT 0,
  after_qty     INT NOT NULL DEFAULT 0,
  batch_number  TEXT,
  created_by    TEXT NOT NULL,
  branch_id     TEXT NOT NULL DEFAULT '',
  account_id    TEXT NOT NULL DEFAULT '',
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_inventory_transactions_medicine ON public.inventory_transactions(medicine_id);
CREATE INDEX IF NOT EXISTS idx_inventory_transactions_branch ON public.inventory_transactions(branch_id);
CREATE INDEX IF NOT EXISTS idx_inventory_transactions_created ON public.inventory_transactions(created_at);

-- ─── الإشعارات والتنبيهات (Notifications) ─────────────────────────
CREATE TABLE IF NOT EXISTS public.notifications (
  id            TEXT PRIMARY KEY,
  title         TEXT NOT NULL,
  message       TEXT NOT NULL,
  type          TEXT NOT NULL DEFAULT 'systemAlert' CHECK (type IN ('lowStock', 'expiryWarning', 'newOrder', 'systemAlert')),
  target_route  TEXT,
  is_read       BOOLEAN NOT NULL DEFAULT false,
  account_id    TEXT,
  branch_id     TEXT,
  user_id       TEXT,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_notifications_account ON public.notifications(account_id);
CREATE INDEX IF NOT EXISTS idx_notifications_branch ON public.notifications(branch_id);
CREATE INDEX IF NOT EXISTS idx_notifications_user ON public.notifications(user_id);

-- ─── القوائم المرجعية (Lookups) ────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.lookups (
  id            TEXT PRIMARY KEY,
  lookup_type   TEXT NOT NULL,
  code          TEXT NOT NULL,
  name          TEXT NOT NULL,
  name_en       TEXT,
  sort_order    INT NOT NULL DEFAULT 0,
  is_active     BOOLEAN NOT NULL DEFAULT true,
  account_id    TEXT,
  last_modified TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE(lookup_type, code)
);

CREATE INDEX IF NOT EXISTS idx_lookups_type ON public.lookups(lookup_type);
CREATE INDEX IF NOT EXISTS idx_lookups_account ON public.lookups(account_id);

-- ─── إعدادات التطبيق (App Settings) ────────────────────────────────
CREATE TABLE IF NOT EXISTS public.app_settings (
  id                      TEXT PRIMARY KEY DEFAULT 'default',
  pharmacy_name           TEXT NOT NULL DEFAULT 'صيدليتي',
  pharmacy_name_en        TEXT NOT NULL DEFAULT 'My Pharmacy',
  currency                TEXT NOT NULL DEFAULT 'ج.م',
  tax_number              TEXT,
  commercial_register     TEXT,
  logo_url                TEXT,
  address                 TEXT,
  phone                   TEXT,
  email                   TEXT,
  default_low_stock_threshold INT NOT NULL DEFAULT 10,
  near_expiry_alert_days  INT NOT NULL DEFAULT 90,
  auto_open_cash_drawer   BOOLEAN NOT NULL DEFAULT true,
  auto_print_receipt      BOOLEAN NOT NULL DEFAULT true,
  account_id              TEXT,
  last_modified           TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ─── عدادات المستندات (Receipt Counters) ───────────────────────────
CREATE TABLE IF NOT EXISTS public.receipt_counters (
  branch_id     TEXT NOT NULL,
  counter_type  TEXT NOT NULL,
  current_value INT NOT NULL DEFAULT 1,
  PRIMARY KEY (branch_id, counter_type)
);

-- ─── سجل الأرشفة (Archive Records) ─────────────────────────────────
CREATE TABLE IF NOT EXISTS public.archive_records (
  id            TEXT PRIMARY KEY,
  entity_type   TEXT NOT NULL,
  entity_id     TEXT NOT NULL,
  entity_name   TEXT,
  archived_data JSONB NOT NULL DEFAULT '{}',
  action        TEXT NOT NULL DEFAULT 'delete',
  archived_by   TEXT NOT NULL,
  branch_id     TEXT,
  account_id    TEXT,
  archived_at   TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_archive_records_entity ON public.archive_records(entity_type, entity_id);
CREATE INDEX IF NOT EXISTS idx_archive_records_account ON public.archive_records(account_id);

-- ─── سجل التدقيق (Audit Logs) ─────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.audit_logs (
  id            TEXT PRIMARY KEY,
  action        TEXT NOT NULL,
  entity_type   TEXT NOT NULL,
  entity_id     TEXT NOT NULL,
  actor_id      TEXT NOT NULL,
  actor_name    TEXT,
  branch_id     TEXT,
  summary       TEXT,
  details       JSONB,
  occurred_at   TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_audit_logs_entity ON public.audit_logs(entity_type, entity_id);
CREATE INDEX IF NOT EXISTS idx_audit_logs_actor ON public.audit_logs(actor_id);
CREATE INDEX IF NOT EXISTS idx_audit_logs_occurred ON public.audit_logs(occurred_at);

-- ─── المهام والملاحظات (Tasks, Notes, Reminders, Messages) ─────────
CREATE TABLE IF NOT EXISTS public.tasks (
  id            TEXT PRIMARY KEY,
  branch_id     TEXT NOT NULL DEFAULT '',
  title         TEXT NOT NULL,
  description   TEXT,
  priority      TEXT NOT NULL DEFAULT 'medium' CHECK (priority IN ('low', 'medium', 'high')),
  status        TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'in_progress', 'completed', 'cancelled')),
  assigned_to   TEXT,
  assigned_name TEXT,
  due_date      TIMESTAMPTZ,
  completed_at  TIMESTAMPTZ,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  sync_version  INT NOT NULL DEFAULT 1,
  last_modified TIMESTAMPTZ NOT NULL DEFAULT now(),
  is_deleted    BOOLEAN NOT NULL DEFAULT false
);

CREATE INDEX IF NOT EXISTS idx_tasks_branch ON public.tasks(branch_id);
CREATE INDEX IF NOT EXISTS idx_tasks_assigned ON public.tasks(assigned_to);

CREATE TABLE IF NOT EXISTS public.notes (
  id            TEXT PRIMARY KEY,
  branch_id     TEXT NOT NULL DEFAULT '',
  title         TEXT NOT NULL,
  content       TEXT NOT NULL,
  pinned        BOOLEAN NOT NULL DEFAULT false,
  color         TEXT,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  sync_version  INT NOT NULL DEFAULT 1,
  last_modified TIMESTAMPTZ NOT NULL DEFAULT now(),
  is_deleted    BOOLEAN NOT NULL DEFAULT false
);

CREATE INDEX IF NOT EXISTS idx_notes_branch ON public.notes(branch_id);

CREATE TABLE IF NOT EXISTS public.reminders (
  id            TEXT PRIMARY KEY,
  branch_id     TEXT NOT NULL DEFAULT '',
  title         TEXT NOT NULL,
  message       TEXT,
  remind_at     TIMESTAMPTZ NOT NULL,
  repeat        TEXT NOT NULL DEFAULT 'none' CHECK (repeat IN ('none', 'daily', 'weekly', 'monthly')),
  dismissed     BOOLEAN NOT NULL DEFAULT false,
  last_triggered TIMESTAMPTZ,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  sync_version  INT NOT NULL DEFAULT 1,
  last_modified TIMESTAMPTZ NOT NULL DEFAULT now(),
  is_deleted    BOOLEAN NOT NULL DEFAULT false
);

CREATE INDEX IF NOT EXISTS idx_reminders_branch ON public.reminders(branch_id);
CREATE INDEX IF NOT EXISTS idx_reminders_remind ON public.reminders(remind_at);

CREATE TABLE IF NOT EXISTS public.messages (
  id            TEXT PRIMARY KEY,
  branch_id     TEXT NOT NULL DEFAULT '',
  from_user_id  TEXT NOT NULL,
  from_name     TEXT NOT NULL,
  to_user_id    TEXT NOT NULL,
  to_name       TEXT NOT NULL,
  subject       TEXT NOT NULL,
  body          TEXT NOT NULL,
  priority      TEXT NOT NULL DEFAULT 'normal' CHECK (priority IN ('low', 'normal', 'high', 'urgent')),
  read_at       TIMESTAMPTZ,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  sync_version  INT NOT NULL DEFAULT 1,
  last_modified TIMESTAMPTZ NOT NULL DEFAULT now(),
  is_deleted    BOOLEAN NOT NULL DEFAULT false
);

CREATE INDEX IF NOT EXISTS idx_messages_from ON public.messages(from_user_id);
CREATE INDEX IF NOT EXISTS idx_messages_to ON public.messages(to_user_id);

-- ─── جدول المزامنة الداخلية للـ Outbox (Sync Outbox) ──────────────
CREATE TABLE IF NOT EXISTS public.sync_outbox (
  id            TEXT PRIMARY KEY,
  operation     TEXT NOT NULL CHECK (operation IN ('create', 'update', 'delete')),
  target_table  TEXT NOT NULL,
  record_id     TEXT NOT NULL,
  data          JSONB NOT NULL DEFAULT '{}',
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  retry_count   INT NOT NULL DEFAULT 0,
  last_error    TEXT,
  synced_at     TIMESTAMPTZ,
  branch_id     TEXT NOT NULL DEFAULT ''
);

CREATE INDEX IF NOT EXISTS idx_sync_outbox_branch ON public.sync_outbox(branch_id);
CREATE INDEX IF NOT EXISTS idx_sync_outbox_synced ON public.sync_outbox(synced_at);

-- ─── حالة المزامنة (Sync State) ─────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.sync_state (
  sync_table    TEXT NOT NULL,
  last_watermark TIMESTAMPTZ,
  last_sync_at  TIMESTAMPTZ,
  branch_id     TEXT NOT NULL,
  PRIMARY KEY (sync_table, branch_id)
);

-- ═══════════════════════════════════════════════════════════════════
-- 🧠 FEFO: إنشاء دالة لاختيار التشغيلة الأقرب انتهاءً تلقائياً
-- ═══════════════════════════════════════════════════════════════════

CREATE OR REPLACE FUNCTION public.fefo_get_oldest_batch(
  p_medicine_id TEXT,
  p_quantity INT
)
RETURNS TABLE(
  batch_id TEXT,
  batch_number TEXT,
  expiry_date DATE,
  available_qty INT,
  purchase_price NUMERIC
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  RETURN QUERY
  SELECT
    ib.id,
    ib.batch_number,
    ib.expiry_date::DATE,
    (ib.quantity - ib.damaged_quantity)::INT,
    ib.purchase_price
  FROM public.item_batches ib
  WHERE ib.medicine_id = p_medicine_id
    AND ib.is_active = true
    AND ib.is_deleted = false
    AND (ib.quantity - ib.damaged_quantity) >= p_quantity
    AND (ib.expiry_date IS NULL OR ib.expiry_date >= CURRENT_DATE)
  ORDER BY ib.expiry_date ASC NULLS LAST, ib.created_at ASC
  LIMIT 1;
END;
$$;

-- ═══════════════════════════════════════════════════════════════════
-- 📊 Supplier Discount Analyzer: إحصائيات خصم الموردين للصنف
-- ═══════════════════════════════════════════════════════════════════

CREATE OR REPLACE FUNCTION public.get_supplier_discount_stats(
  p_medicine_id TEXT
)
RETURNS TABLE(
  supplier_id TEXT,
  supplier_name TEXT,
  avg_discount_percent NUMERIC,
  max_discount_percent NUMERIC,
  min_discount_percent NUMERIC,
  total_supplied_qty NUMERIC,
  last_supply_date TIMESTAMPTZ
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  RETURN QUERY
  SELECT
    s.id,
    s.name,
    ROUND(AVG(CASE WHEN si.discount_type = 'percent' THEN si.discount_value ELSE 0 END), 2)::NUMERIC,
    MAX(CASE WHEN si.discount_type = 'percent' THEN si.discount_value ELSE 0 END)::NUMERIC,
    MIN(CASE WHEN si.discount_type = 'percent' THEN si.discount_value ELSE 0 END)::NUMERIC,
    SUM(si.quantity)::NUMERIC,
    MAX(si.date)
  FROM public.supplied_items si
  JOIN public.suppliers s ON s.id = si.contact_id
  WHERE si.medicine_id = p_medicine_id
  GROUP BY s.id, s.name
  ORDER BY avg_discount_percent DESC;
END;
$$;

-- ═══════════════════════════════════════════════════════════════════
-- 🔍 Smart Barcode Search: البحث بالباركود عبر الجدول المنفصل
-- ═══════════════════════════════════════════════════════════════════

CREATE OR REPLACE FUNCTION public.find_medicine_by_barcode(
  p_barcode TEXT
)
RETURNS TABLE(
  medicine_id TEXT,
  medicine_name TEXT,
  barcode TEXT,
  is_primary BOOLEAN
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  RETURN QUERY
  SELECT
    mb.medicine_id,
    m.name,
    mb.barcode,
    mb.is_primary
  FROM public.medicine_barcodes mb
  JOIN public.medicines m ON m.id = mb.medicine_id
  WHERE mb.barcode = p_barcode
    AND m.is_active = true
    AND m.is_deleted = false
  LIMIT 1;
END;
$$;

-- ═══════════════════════════════════════════════════════════════════
-- 🔄 إنشاء التريجر التلقائي لتحديث last_modified
-- ═══════════════════════════════════════════════════════════════════

CREATE OR REPLACE FUNCTION public.update_last_modified()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
  NEW.last_modified = now();
  RETURN NEW;
END;
$$;
