-- ============================================================
-- Migration: Fix returns + create missing sync tables
-- 2026-07-23
-- ============================================================

-- 1. Returns: إضافة الحقول الناقصة للمرتجع الحر
ALTER TABLE public.returns
  ADD COLUMN IF NOT EXISTS return_type       TEXT NOT NULL DEFAULT 'sales',
  ADD COLUMN IF NOT EXISTS party_id          TEXT,
  ADD COLUMN IF NOT EXISTS party_name        TEXT,
  ADD COLUMN IF NOT EXISTS party_type        TEXT,  -- cash, customer, supplier
  ADD COLUMN IF NOT EXISTS discount_percent  NUMERIC NOT NULL DEFAULT 0,
  ADD COLUMN IF NOT EXISTS final_amount      NUMERIC NOT NULL DEFAULT 0,
  ADD COLUMN IF NOT EXISTS safe_id           TEXT;

CREATE INDEX IF NOT EXISTS idx_returns_return_type ON public.returns(return_type);

-- 2. Medicine Units (وحدات الأصناف)
CREATE TABLE IF NOT EXISTS public.medicine_units (
  id                TEXT PRIMARY KEY,
  medicine_id       TEXT NOT NULL,
  name              TEXT NOT NULL,
  level             INT NOT NULL DEFAULT 0,
  conversion_factor NUMERIC NOT NULL DEFAULT 1,
  buy_price         NUMERIC NOT NULL DEFAULT 0,
  sell_price        NUMERIC NOT NULL DEFAULT 0,
  old_sell_price    NUMERIC,
  discount_percent  NUMERIC,
  allow_sale        BOOLEAN NOT NULL DEFAULT true,
  quantity          INT NOT NULL DEFAULT 0,
  barcode           TEXT,
  last_modified     TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_medicine_units_medicine ON public.medicine_units(medicine_id);

-- 3. Item Batches (الباتشات / تواريخ الصلاحية المتعددة)
CREATE TABLE IF NOT EXISTS public.item_batches (
  id                TEXT PRIMARY KEY,
  medicine_id       TEXT NOT NULL,
  batch_number      TEXT,
  expiry_date       DATE,
  quantity          INT NOT NULL DEFAULT 0,
  damaged_quantity  INT NOT NULL DEFAULT 0,
  purchase_price    NUMERIC,
  is_active         BOOLEAN NOT NULL DEFAULT true,
  is_deleted        BOOLEAN NOT NULL DEFAULT false,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  last_modified     TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_item_batches_medicine ON public.item_batches(medicine_id);
CREATE INDEX IF NOT EXISTS idx_item_batches_expiry ON public.item_batches(expiry_date);

-- 4. Trigger: auto-update last_modified
CREATE OR REPLACE FUNCTION public.set_last_modified()
RETURNS TRIGGER AS $$
BEGIN
  NEW.last_modified = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'set_returns_last_modified') THEN
    CREATE TRIGGER set_returns_last_modified BEFORE UPDATE ON public.returns
      FOR EACH ROW EXECUTE FUNCTION public.set_last_modified();
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'set_medicine_units_last_modified') THEN
    CREATE TRIGGER set_medicine_units_last_modified BEFORE UPDATE ON public.medicine_units
      FOR EACH ROW EXECUTE FUNCTION public.set_last_modified();
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'set_item_batches_last_modified') THEN
    CREATE TRIGGER set_item_batches_last_modified BEFORE UPDATE ON public.item_batches
      FOR EACH ROW EXECUTE FUNCTION public.set_last_modified();
  END IF;
END $$;
