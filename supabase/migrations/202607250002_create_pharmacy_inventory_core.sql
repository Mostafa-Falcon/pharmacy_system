-- ═══════════════════════════════════════════════════════════════════
-- Pharmacy System — 2/9 Inventory Core (Model-Driven Alignment)
-- الجداول: medicines, item_batches, item_categories, medicine_brands,
--          item_variants, item_warranties, price_groups, barcode_settings
-- ═══════════════════════════════════════════════════════════════════

-- ─── فئات الأصناف (Item Categories) ───────────────────────────────
CREATE TABLE IF NOT EXISTS public.item_categories (
  id            TEXT PRIMARY KEY,
  name          TEXT NOT NULL,
  code          TEXT,
  description   TEXT,
  parent_id     TEXT,
  is_active     BOOLEAN NOT NULL DEFAULT true,
  account_id    TEXT,
  sync_version  INT NOT NULL DEFAULT 1,
  last_modified TIMESTAMPTZ NOT NULL DEFAULT now(),
  is_deleted    BOOLEAN NOT NULL DEFAULT false
);

-- ─── ماركات الأصناف (Medicine Brands) ──────────────────────────────
CREATE TABLE IF NOT EXISTS public.medicine_brands (
  id             TEXT PRIMARY KEY,
  name           TEXT NOT NULL,
  description    TEXT,
  use_for_repair BOOLEAN NOT NULL DEFAULT false,
  is_active      BOOLEAN NOT NULL DEFAULT true,
  account_id     TEXT,
  sync_version   INT NOT NULL DEFAULT 1,
  last_modified  TIMESTAMPTZ NOT NULL DEFAULT now(),
  is_deleted     BOOLEAN NOT NULL DEFAULT false
);

-- ─── متغيرات الأصناف (Item Variants) ───────────────────────────────
CREATE TABLE IF NOT EXISTS public.item_variants (
  id            TEXT PRIMARY KEY,
  name          TEXT NOT NULL,
  values        JSONB NOT NULL DEFAULT '[]',
  is_active     BOOLEAN NOT NULL DEFAULT true,
  account_id    TEXT,
  sync_version  INT NOT NULL DEFAULT 1,
  last_modified TIMESTAMPTZ NOT NULL DEFAULT now(),
  is_deleted    BOOLEAN NOT NULL DEFAULT false
);

-- ─── ضمانات الأصناف (Item Warranties) ──────────────────────────────
CREATE TABLE IF NOT EXISTS public.item_warranties (
  id             TEXT PRIMARY KEY,
  name           TEXT NOT NULL,
  description    TEXT,
  duration       INT NOT NULL DEFAULT 1,
  duration_unit  TEXT NOT NULL DEFAULT 'year',
  is_active      BOOLEAN NOT NULL DEFAULT true,
  account_id     TEXT,
  sync_version   INT NOT NULL DEFAULT 1,
  last_modified  TIMESTAMPTZ NOT NULL DEFAULT now(),
  is_deleted     BOOLEAN NOT NULL DEFAULT false
);

-- ─── شرائح التسعير (Price Groups) ──────────────────────────────────
CREATE TABLE IF NOT EXISTS public.price_groups (
  id                  TEXT PRIMARY KEY,
  name                TEXT NOT NULL,
  markup_percentage   NUMERIC NOT NULL DEFAULT 0,
  discount_percentage NUMERIC NOT NULL DEFAULT 0,
  is_default          BOOLEAN NOT NULL DEFAULT false,
  is_active           BOOLEAN NOT NULL DEFAULT true,
  account_id          TEXT,
  sync_version        INT NOT NULL DEFAULT 1,
  last_modified       TIMESTAMPTZ NOT NULL DEFAULT now(),
  is_deleted          BOOLEAN NOT NULL DEFAULT false
);

-- ─── إعدادات الباركود (Barcode Settings) ────────────────────────────
CREATE TABLE IF NOT EXISTS public.barcode_settings (
  id                TEXT PRIMARY KEY,
  prefix            TEXT NOT NULL DEFAULT '20',
  label_width_mm    NUMERIC NOT NULL DEFAULT 62.0,
  label_height_mm   NUMERIC NOT NULL DEFAULT 32.0,
  copies_per_item   INT NOT NULL DEFAULT 1,
  show_price        BOOLEAN NOT NULL DEFAULT true,
  show_item_name    BOOLEAN NOT NULL DEFAULT true,
  show_unit_name    BOOLEAN NOT NULL DEFAULT true,
  show_pharmacy_name BOOLEAN NOT NULL DEFAULT false,
  pharmacy_name     TEXT NOT NULL DEFAULT '',
  show_expiry       BOOLEAN NOT NULL DEFAULT false,
  show_batch        BOOLEAN NOT NULL DEFAULT false,
  print_layout      TEXT NOT NULL DEFAULT 'labelPrinter',
  direct_print      BOOLEAN NOT NULL DEFAULT false,
  printer_name      TEXT NOT NULL DEFAULT '',
  account_id        TEXT,
  sync_version      INT NOT NULL DEFAULT 1,
  last_modified     TIMESTAMPTZ NOT NULL DEFAULT now(),
  is_deleted        BOOLEAN NOT NULL DEFAULT false
);

-- ─── الأدوية الرئيسي (Medicines Master) - مطابقة لـ MedicineModel ───
CREATE TABLE IF NOT EXISTS public.medicines (
  id                      TEXT PRIMARY KEY,
  name                    TEXT NOT NULL,
  name_en                 TEXT,
  item_types              JSONB NOT NULL DEFAULT '[]',
  therapeutic_group       JSONB NOT NULL DEFAULT '{}',
  barcodes                JSONB NOT NULL DEFAULT '[]',
  item_levels             JSONB NOT NULL DEFAULT '{}',
  expiry_dates            JSONB, -- List of ISO dates

  supplier_id             TEXT,
  manufacturer            TEXT,
  dosage_form             TEXT,
  strength                TEXT,
  package_size            TEXT,
  container_shape         TEXT,
  location                TEXT,

  is_taxable              BOOLEAN NOT NULL DEFAULT false,
  tax_type                TEXT,
  tax_value               NUMERIC,
  prices_include_tax      BOOLEAN NOT NULL DEFAULT false,

  alert_enabled           BOOLEAN NOT NULL DEFAULT true,
  min_stock               INT NOT NULL DEFAULT 10,
  expiry_tracking_enabled BOOLEAN NOT NULL DEFAULT true,
  allow_negative_stock    BOOLEAN NOT NULL DEFAULT false,
  is_active               BOOLEAN NOT NULL DEFAULT true,

  image_url               TEXT,
  description             TEXT,

  account_id              TEXT,
  branch_id               TEXT,
  sync_version            INT NOT NULL DEFAULT 1,
  last_modified           TIMESTAMPTZ NOT NULL DEFAULT now(),
  is_deleted              BOOLEAN NOT NULL DEFAULT false,
  created_at              TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ─── تشغيلات الأصناف (Item Batches) ────────────────────────────────
CREATE TABLE IF NOT EXISTS public.item_batches (
  id               TEXT PRIMARY KEY,
  medicine_id      TEXT NOT NULL REFERENCES public.medicines(id) ON DELETE CASCADE,
  batch_number     TEXT,
  expiry_date      DATE,
  quantity         INT NOT NULL DEFAULT 0,
  damaged_quantity INT NOT NULL DEFAULT 0,
  purchase_price   NUMERIC,
  is_active        BOOLEAN NOT NULL DEFAULT true,
  account_id       TEXT,
  branch_id        TEXT,
  sync_version     INT NOT NULL DEFAULT 1,
  last_modified    TIMESTAMPTZ NOT NULL DEFAULT now(),
  is_deleted       BOOLEAN NOT NULL DEFAULT false,
  created_at       TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ─── Indexes ──────────────────────────────────────────────────────
CREATE INDEX IF NOT EXISTS idx_medicines_account ON public.medicines(account_id);
CREATE INDEX IF NOT EXISTS idx_medicines_last_modified ON public.medicines(last_modified);
CREATE INDEX IF NOT EXISTS idx_item_batches_medicine ON public.item_batches(medicine_id);
