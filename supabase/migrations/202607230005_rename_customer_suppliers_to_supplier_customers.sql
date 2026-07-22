-- ═══════════════════════════════════════════════════════════════
-- Rename customer_suppliers → supplier_customers
-- Aligns remote Supabase table name with local Drift table name
-- Safe to re-run (idempotent).
-- ═══════════════════════════════════════════════════════════════

-- 1. Rename the table
ALTER TABLE IF EXISTS public.customer_suppliers RENAME TO supplier_customers;

-- 2. Rename indexes
ALTER INDEX IF EXISTS idx_customer_suppliers_branch     RENAME TO idx_supplier_customers_branch;
ALTER INDEX IF EXISTS idx_customer_suppliers_phone      RENAME TO idx_supplier_customers_phone;
ALTER INDEX IF EXISTS idx_customer_suppliers_last_modified RENAME TO idx_supplier_customers_last_modified;

-- 3. Drop old RLS policy on old table name, recreate on new name
DROP POLICY IF EXISTS "Authenticated full access" ON public.customer_suppliers;
DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'Authenticated full access' AND tablename = 'supplier_customers') THEN
    CREATE POLICY "Authenticated full access" ON public.supplier_customers FOR ALL USING (auth.role() = 'authenticated');
  END IF;
END $$;

-- 4. Re-create trigger on renamed table (the bulk trigger in 202607230002
--    still references the old name; this covers the renamed table)
DROP TRIGGER IF EXISTS set_last_modified ON public.supplier_customers;
CREATE TRIGGER set_last_modified BEFORE INSERT OR UPDATE ON public.supplier_customers FOR EACH ROW EXECUTE FUNCTION public.set_last_modified();
