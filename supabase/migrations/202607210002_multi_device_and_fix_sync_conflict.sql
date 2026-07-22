-- ═══════════════════════════════════════════════════════════════
-- إصلاح شامل لتعارض المزامنة (Sync Conflict Root Cause Fix)
-- ═══════════════════════════════════════════════════════════════
--
-- التعارضات اللي كانت بتمنع العمليات المحلية من الوصول لـ Supabase:
--
-- 1) المستخدم الوحيد كان is_active = false → كل سياسات RLS اللي
--    بتعتمد على current_user_is_active() كانت بترجع false وأي
--    insert/update بيرفض. (تم تنشيطه).
--
-- 2) active_device_id كان مقفول على جهاز قديم (single-device lock)
--    → تم إلغاء القفل (multi-device) عبر تحييد acquire_session_lock.
--
-- 3) الـ models بتعت أعمدة مش موجودة في السيرفر (sales: customer_id,
--    paid_amount, tax_amount, receipt_number | purchases: status,
--    source_type, receipt_number, shipping_amount, delivery_amount)
--    → PostgREST كان بيرجع error 42703 ويرمي العملية في dead_letter.
--    (تمت إضافة الأعمدة).
--
-- 4) مفيش unique constraint على id → upsert بيتحول لـ insert مكرر.
--    (تمت إضافة unique indexes).
-- ═══════════════════════════════════════════════════════════════

-- 1) تنشيط كل المستخدمين + مسح أي قفل جهاز قديم
UPDATE public.users
SET is_active = true,
    active_device_id = NULL
WHERE is_active = false OR active_device_id IS NOT NULL;

-- 2) تحييد قفل الجهاز الواحد (multi-device)
CREATE OR REPLACE FUNCTION public.acquire_session_lock(
  p_user_id text,
  p_device_id text
) RETURNS boolean
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  UPDATE public.users SET last_login = now() WHERE id::text = p_user_id;
  RETURN TRUE;
END;
$$;

-- 3) إضافة الأعمدة الناقصة
ALTER TABLE public.sales
  ADD COLUMN IF NOT EXISTS customer_id text,
  ADD COLUMN IF NOT EXISTS paid_amount numeric,
  ADD COLUMN IF NOT EXISTS tax_amount numeric,
  ADD COLUMN IF NOT EXISTS receipt_number text;

ALTER TABLE public.purchases
  ADD COLUMN IF NOT EXISTS status text NOT NULL DEFAULT 'completed',
  ADD COLUMN IF NOT EXISTS source_type text,
  ADD COLUMN IF NOT EXISTS receipt_number text,
  ADD COLUMN IF NOT EXISTS shipping_amount numeric,
  ADD COLUMN IF NOT EXISTS delivery_amount numeric;

-- 4) unique indexes لدعم upsert بلا تكرار
CREATE UNIQUE INDEX IF NOT EXISTS sales_id_key ON public.sales (id);
CREATE UNIQUE INDEX IF NOT EXISTS purchases_id_key ON public.purchases (id);
CREATE UNIQUE INDEX IF NOT EXISTS returns_id_key ON public.returns (id);
CREATE UNIQUE INDEX IF NOT EXISTS quotes_id_key ON public.quotes (id);
CREATE UNIQUE INDEX IF NOT EXISTS cashier_shifts_id_key ON public.cashier_shifts (id);
CREATE UNIQUE INDEX IF NOT EXISTS customer_ledgers_id_key ON public.customer_ledgers (id);
CREATE UNIQUE INDEX IF NOT EXISTS supplier_ledgers_id_key ON public.supplier_ledgers (id);
CREATE UNIQUE INDEX IF NOT EXISTS customer_suppliers_id_key ON public.customer_suppliers (id);
CREATE UNIQUE INDEX IF NOT EXISTS customer_groups_id_key ON public.customer_groups (id);
