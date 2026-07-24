-- ═══════════════════════════════════════════════════════════════════
-- Pharmacy System — 11/11 RLS & Triggers for Ops Support Tables
-- ═══════════════════════════════════════════════════════════════════

-- ─── 1. Trigger: auto-update last_modified on new tables ─────────

DO $$
DECLARE
  r record;
BEGIN
  FOR r IN SELECT tablename FROM pg_tables WHERE schemaname = 'public' AND tablename IN (
    'suspended_sales', 'bulk_price_updates', 'items_archive',
    'inventory_transactions', 'notifications', 'lookups',
    'receipt_counters', 'sync_outbox', 'sync_state',
    'tasks', 'notes', 'reminders', 'messages',
    'supplier_ledgers', 'stocktaking_items',
    'stock_adjustment_items', 'swap_items'
  ) LOOP
    EXECUTE format('DROP TRIGGER IF EXISTS set_last_modified ON public.%I', r.tablename);
    EXECUTE format('CREATE TRIGGER set_last_modified BEFORE INSERT OR UPDATE ON public.%I FOR EACH ROW EXECUTE FUNCTION public.set_last_modified()', r.tablename);
  END LOOP;
END;
$$;

-- ─── 2. RLS Policies for new tables ──────────────────────────────

DO $$ BEGIN
  EXECUTE 'ALTER TABLE public.suspended_sales ENABLE ROW LEVEL SECURITY';
  EXECUTE 'ALTER TABLE public.bulk_price_updates ENABLE ROW LEVEL SECURITY';
  EXECUTE 'ALTER TABLE public.items_archive ENABLE ROW LEVEL SECURITY';
  EXECUTE 'ALTER TABLE public.inventory_transactions ENABLE ROW LEVEL SECURITY';
  EXECUTE 'ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY';
  EXECUTE 'ALTER TABLE public.lookups ENABLE ROW LEVEL SECURITY';
  EXECUTE 'ALTER TABLE public.sync_outbox ENABLE ROW LEVEL SECURITY';
  EXECUTE 'ALTER TABLE public.sync_state ENABLE ROW LEVEL SECURITY';
  EXECUTE 'ALTER TABLE public.tasks ENABLE ROW LEVEL SECURITY';
  EXECUTE 'ALTER TABLE public.notes ENABLE ROW LEVEL SECURITY';
  EXECUTE 'ALTER TABLE public.reminders ENABLE ROW LEVEL SECURITY';
  EXECUTE 'ALTER TABLE public.messages ENABLE ROW LEVEL SECURITY';
EXCEPTION WHEN OTHERS THEN NULL;
END $$;

-- ─── 3. Access policies for all new tables ───────────────────────

CREATE POLICY IF NOT EXISTS "access_suspended_sales" ON public.suspended_sales FOR ALL USING (current_user_is_active());
CREATE POLICY IF NOT EXISTS "access_bulk_price_updates" ON public.bulk_price_updates FOR ALL USING (current_user_is_active());
CREATE POLICY IF NOT EXISTS "access_items_archive" ON public.items_archive FOR ALL USING (current_user_is_active());
CREATE POLICY IF NOT EXISTS "access_inventory_transactions" ON public.inventory_transactions FOR ALL USING (current_user_is_active());
CREATE POLICY IF NOT EXISTS "access_notifications" ON public.notifications FOR ALL USING (current_user_is_active());
CREATE POLICY IF NOT EXISTS "access_lookups" ON public.lookups FOR ALL USING (current_user_is_active());
CREATE POLICY IF NOT EXISTS "access_sync_outbox" ON public.sync_outbox FOR ALL USING (current_user_is_active());
CREATE POLICY IF NOT EXISTS "access_sync_state" ON public.sync_state FOR ALL USING (current_user_is_active());
CREATE POLICY IF NOT EXISTS "access_tasks" ON public.tasks FOR ALL USING (current_user_is_active());
CREATE POLICY IF NOT EXISTS "access_notes" ON public.notes FOR ALL USING (current_user_is_active());
CREATE POLICY IF NOT EXISTS "access_reminders" ON public.reminders FOR ALL USING (current_user_is_active());
CREATE POLICY IF NOT EXISTS "access_messages" ON public.messages FOR ALL USING (current_user_is_active());

-- ─── 4. Grant RPC execution to authenticated users ───────────────

GRANT EXECUTE ON FUNCTION public.fefo_get_oldest_batch TO authenticated;
GRANT EXECUTE ON FUNCTION public.get_supplier_discount_stats TO authenticated;
GRANT EXECUTE ON FUNCTION public.find_medicine_by_barcode TO authenticated;
