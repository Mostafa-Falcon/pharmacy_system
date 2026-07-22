-- ═══════════════════════════════════════════════════════════════
-- Fix RLS Policies: restrict access to authenticated app users
-- instead of allowing any authenticated role full access.
-- ═══════════════════════════════════════════════════════════════

-- ─── Helper Function ────────────────────────────────────────────
-- Returns true if the current Supabase Auth user matches an active
-- app user in public.users and has access to the given branch.
-- Owners (role = 'owner') can access any branch.
CREATE OR REPLACE FUNCTION public.current_user_can_access_branch(
  p_branch_id TEXT
) RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1
    FROM public.users
    WHERE id = auth.uid()::text
      AND is_deleted = false
      AND (
        role = 'owner'
        OR assigned_branch_id = p_branch_id
      )
  );
END;
$$ LANGUAGE plpgsql STABLE;

-- Returns true if the current Supabase Auth user matches any active
-- app user (used for tables without branch_id).
CREATE OR REPLACE FUNCTION public.current_user_is_active()
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1
    FROM public.users
    WHERE id = auth.uid()::text
      AND is_deleted = false
  );
END;
$$ LANGUAGE plpgsql STABLE;

-- ─── Drop Old Permissive Policies ────────────────────────────────
DO $$
DECLARE
  pol RECORD;
BEGIN
  FOR pol IN
    SELECT policyname, tablename
    FROM pg_policies
    WHERE schemaname = 'public'
      AND policyname = 'Authenticated full access'
  LOOP
    EXECUTE format('DROP POLICY IF EXISTS "Authenticated full access" ON public.%I', pol.tablename);
  END LOOP;
END
$$;

-- ─── Branches ───────────────────────────────────────────────────
CREATE POLICY "Users access branches" ON public.branches
  FOR ALL USING (current_user_is_active());

-- ─── Users ──────────────────────────────────────────────────────
CREATE POLICY "Users access users" ON public.users
  FOR ALL USING (current_user_is_active());

-- ─── Permissions ────────────────────────────────────────────────
CREATE POLICY "Users access permissions" ON public.permissions
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM public.users
      WHERE id = auth.uid()::text
        AND is_deleted = false
    )
  );

-- ─── Medicines ──────────────────────────────────────────────────
CREATE POLICY "Users access medicines" ON public.medicines
  FOR ALL USING (current_user_can_access_branch(branch_id));

-- ─── Sales ──────────────────────────────────────────────────────
CREATE POLICY "Users access sales" ON public.sales
  FOR ALL USING (current_user_can_access_branch(branch_id));

-- ─── Purchases ──────────────────────────────────────────────────
CREATE POLICY "Users access purchases" ON public.purchases
  FOR ALL USING (current_user_can_access_branch(branch_id));

-- ─── Inventory ──────────────────────────────────────────────────
CREATE POLICY "Users access inventory" ON public.inventory
  FOR ALL USING (current_user_can_access_branch(branch_id));

-- ─── Returns ────────────────────────────────────────────────────
CREATE POLICY "Users access returns" ON public.returns
  FOR ALL USING (current_user_can_access_branch(branch_id));

-- ─── Cashier Shifts ─────────────────────────────────────────────
CREATE POLICY "Users access cashier_shifts" ON public.cashier_shifts
  FOR ALL USING (current_user_can_access_branch(branch_id));

-- ─── Quotes ─────────────────────────────────────────────────────
CREATE POLICY "Users access quotes" ON public.quotes
  FOR ALL USING (current_user_can_access_branch(branch_id));

-- ─── Customer Ledgers ───────────────────────────────────────────
CREATE POLICY "Users access customer_ledgers" ON public.customer_ledgers
  FOR ALL USING (current_user_can_access_branch(branch_id));

-- ─── Supplier Ledgers ───────────────────────────────────────────
CREATE POLICY "Users access supplier_ledgers" ON public.supplier_ledgers
  FOR ALL USING (current_user_can_access_branch(branch_id));

-- ─── Customer Groups ────────────────────────────────────────────
CREATE POLICY "Users access customer_groups" ON public.customer_groups
  FOR ALL USING (current_user_is_active());

-- ─── Customers ──────────────────────────────────────────────────
CREATE POLICY "Users access customers" ON public.customers
  FOR ALL USING (current_user_is_active());

-- ─── Suppliers ──────────────────────────────────────────────────
CREATE POLICY "Users access suppliers" ON public.suppliers
  FOR ALL USING (current_user_is_active());
