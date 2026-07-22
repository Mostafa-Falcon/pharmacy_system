-- ═══════════════════════════════════════════════════════════════
-- Auto-update last_modified on INSERT/UPDATE for all sync tables
-- Safe to re-run (idempotent).
-- ═══════════════════════════════════════════════════════════════

CREATE OR REPLACE FUNCTION public.set_last_modified()
RETURNS TRIGGER AS $$
BEGIN
  NEW.last_modified = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DO $$
DECLARE
  r record;
BEGIN
  FOR r IN SELECT tablename FROM pg_tables WHERE schemaname = 'public' AND tablename IN (
    'medicines','sales','purchases','returns','cashier_shifts','quotes',
    'inventory','branches','users','permissions','customers','suppliers',
    'customer_suppliers','customer_groups','customer_ledgers','supplier_ledgers',
    'archive_records','stocktaking_periods','stocktaking_counts','promotions','expenses'
  ) LOOP
    EXECUTE format('DROP TRIGGER IF EXISTS set_last_modified ON public.%I', r.tablename);
    EXECUTE format('CREATE TRIGGER set_last_modified BEFORE INSERT OR UPDATE ON public.%I FOR EACH ROW EXECUTE FUNCTION public.set_last_modified()', r.tablename);
  END LOOP;
END;
$$;
