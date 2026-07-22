-- ═══════════════════════════════════════════════════════════════
-- Harden RLS: add WITH CHECK for INSERT/UPDATE and restrict sensitive writes
-- ═══════════════════════════════════════════════════════════════

-- ─── Helper: owner/admin check ──────────────────────────────────
CREATE OR REPLACE FUNCTION public.current_user_is_owner_or_admin()
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1
    FROM public.users
    WHERE id = auth.uid()::text
      AND is_deleted = false
      AND role IN ('owner', 'admin')
  );
END;
$$ LANGUAGE plpgsql STABLE;

-- ─── Drop existing policies ──────────────────────────────────────
DO $$
DECLARE
  pol RECORD;
BEGIN
  FOR pol IN
    SELECT policyname, tablename
    FROM pg_policies
    WHERE schemaname = 'public'
      AND policyname LIKE 'Users access %'
  LOOP
    EXECUTE format('DROP POLICY IF EXISTS %I ON public.%I', pol.policyname, pol.tablename);
  END LOOP;
END
$$;

-- ─── Branches ───────────────────────────────────────────────────
CREATE POLICY "Users access branches" ON public.branches
  FOR ALL USING (current_user_is_active())
  WITH CHECK (current_user_is_owner_or_admin());

-- ─── Users ──────────────────────────────────────────────────────
CREATE POLICY "Users access users" ON public.users
  FOR SELECT USING (current_user_is_active());

CREATE POLICY "Users modify users" ON public.users
  FOR INSERT WITH CHECK (current_user_is_owner_or_admin());

CREATE POLICY "Users modify users update" ON public.users
  FOR UPDATE USING (current_user_is_active())
  WITH CHECK (current_user_is_owner_or_admin());

-- ─── Permissions ────────────────────────────────────────────────
CREATE POLICY "Users access permissions" ON public.permissions
  FOR SELECT USING (current_user_is_active());

CREATE POLICY "Users modify permissions" ON public.permissions
  FOR INSERT WITH CHECK (current_user_is_owner_or_admin());

CREATE POLICY "Users modify permissions update" ON public.permissions
  FOR UPDATE USING (current_user_is_active())
  WITH CHECK (current_user_is_owner_or_admin());

-- ─── Medicines ──────────────────────────────────────────────────
CREATE POLICY "Users access medicines" ON public.medicines
  FOR ALL USING (current_user_can_access_branch(branch_id))
  WITH CHECK (current_user_can_access_branch(branch_id));

-- ─── Sales ──────────────────────────────────────────────────────
CREATE POLICY "Users access sales" ON public.sales
  FOR ALL USING (current_user_can_access_branch(branch_id))
  WITH CHECK (current_user_can_access_branch(branch_id));

-- ─── Purchases ──────────────────────────────────────────────────
CREATE POLICY "Users access purchases" ON public.purchases
  FOR ALL USING (current_user_can_access_branch(branch_id))
  WITH CHECK (current_user_can_access_branch(branch_id));

-- ─── Inventory ──────────────────────────────────────────────────
CREATE POLICY "Users access inventory" ON public.inventory
  FOR ALL USING (current_user_can_access_branch(branch_id))
  WITH CHECK (current_user_can_access_branch(branch_id));

-- ─── Returns ────────────────────────────────────────────────────
CREATE POLICY "Users access returns" ON public.returns
  FOR ALL USING (current_user_can_access_branch(branch_id))
  WITH CHECK (current_user_can_access_branch(branch_id));

-- ─── Cashier Shifts ─────────────────────────────────────────────
CREATE POLICY "Users access cashier_shifts" ON public.cashier_shifts
  FOR ALL USING (current_user_can_access_branch(branch_id))
  WITH CHECK (current_user_can_access_branch(branch_id));

-- ─── Quotes ─────────────────────────────────────────────────────
CREATE POLICY "Users access quotes" ON public.quotes
  FOR ALL USING (current_user_can_access_branch(branch_id))
  WITH CHECK (current_user_can_access_branch(branch_id));

-- ─── Customer Ledgers ───────────────────────────────────────────
CREATE POLICY "Users access customer_ledgers" ON public.customer_ledgers
  FOR ALL USING (current_user_can_access_branch(branch_id))
  WITH CHECK (current_user_can_access_branch(branch_id));

-- ─── Supplier Ledgers ───────────────────────────────────────────
CREATE POLICY "Users access supplier_ledgers" ON public.supplier_ledgers
  FOR ALL USING (current_user_can_access_branch(branch_id))
  WITH CHECK (current_user_can_access_branch(branch_id));

-- ─── Customer Groups ────────────────────────────────────────────
CREATE POLICY "Users access customer_groups" ON public.customer_groups
  FOR ALL USING (current_user_is_active())
  WITH CHECK (current_user_is_active());

-- ─── Customers ──────────────────────────────────────────────────
CREATE POLICY "Users access customers" ON public.customers
  FOR ALL USING (current_user_is_active())
  WITH CHECK (current_user_is_active());

-- ─── Suppliers ──────────────────────────────────────────────────
CREATE POLICY "Users access suppliers" ON public.suppliers
  FOR ALL USING (current_user_is_active())
  WITH CHECK (current_user_is_active());
