-- ═══════════════════════════════════════════════════════════════════
-- Pharmacy System — 9/9 RLS Policies, Triggers & Sync Functions
-- ═══════════════════════════════════════════════════════════════════

-- ─── 1. Helper Functions ────────────────────────────────────────────

CREATE OR REPLACE FUNCTION public.current_user_is_active()
RETURNS boolean
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM public.users
    WHERE id = auth.uid()::text AND is_deleted = false
  );
END;
$$;

CREATE OR REPLACE FUNCTION public.current_user_can_access_branch(p_branch_id text)
RETURNS boolean
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM public.users
    WHERE id = auth.uid()::text
      AND is_deleted = false
      AND (role = 'owner' OR assigned_branch_id = p_branch_id)
  );
END;
$$;

CREATE OR REPLACE FUNCTION public.current_user_is_owner()
RETURNS boolean
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM public.users
    WHERE id = auth.uid()::text
      AND is_deleted = false
      AND role = 'owner'
  );
END;
$$;

-- ─── 2. Trigger: auto-update last_modified ──────────────────────────

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
    'branches','users','permissions',
    'medicines','medicine_levels','item_batches','item_categories','medicine_brands',
    'item_variants','item_warranties','price_groups','barcode_settings',
    'stocktaking','stock_adjustments','item_swaps',
    'customers','suppliers','supplier_customers','customer_groups','sales_agents',
    'purchase_invoices',
    'sale_invoices','cashier_shifts','promotions','free_returns','invoice_returns',
    'quotations','shipping_orders',
    'expenses','expense_categories','account_tree',
    'app_settings','archive_records'
  ) LOOP
    EXECUTE format('DROP TRIGGER IF EXISTS set_last_modified ON public.%I', r.tablename);
    EXECUTE format('CREATE TRIGGER set_last_modified BEFORE INSERT OR UPDATE ON public.%I FOR EACH ROW EXECUTE FUNCTION public.set_last_modified()', r.tablename);
  END LOOP;
END;
$$;

-- ─── 3. Trigger: auto-create user row on auth signup ────────────────

CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  INSERT INTO public.users (id, name, email, role, is_active, created_at, last_modified)
  VALUES (
    NEW.id,
    COALESCE(
      NEW.raw_user_meta_data ->> 'full_name',
      NEW.raw_user_meta_data ->> 'name',
      split_part(NEW.email, '@', 1)
    ),
    NEW.email,
    COALESCE(NEW.raw_user_meta_data ->> 'role', 'employee'),
    true,
    now(),
    now()
  )
  ON CONFLICT (id) DO NOTHING;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- ─── 4. RLS Policies ────────────────────────────────────────────────

DO $$ BEGIN
  EXECUTE 'ALTER TABLE public.branches ENABLE ROW LEVEL SECURITY';
  EXECUTE 'ALTER TABLE public.users ENABLE ROW LEVEL SECURITY';
  EXECUTE 'ALTER TABLE public.permissions ENABLE ROW LEVEL SECURITY';
  EXECUTE 'ALTER TABLE public.medicines ENABLE ROW LEVEL SECURITY';
  EXECUTE 'ALTER TABLE public.medicine_levels ENABLE ROW LEVEL SECURITY';
  EXECUTE 'ALTER TABLE public.item_batches ENABLE ROW LEVEL SECURITY';
  EXECUTE 'ALTER TABLE public.medicine_barcodes ENABLE ROW LEVEL SECURITY';
  EXECUTE 'ALTER TABLE public.item_categories ENABLE ROW LEVEL SECURITY';
  EXECUTE 'ALTER TABLE public.medicine_brands ENABLE ROW LEVEL SECURITY';
  EXECUTE 'ALTER TABLE public.item_variants ENABLE ROW LEVEL SECURITY';
  EXECUTE 'ALTER TABLE public.item_warranties ENABLE ROW LEVEL SECURITY';
  EXECUTE 'ALTER TABLE public.price_groups ENABLE ROW LEVEL SECURITY';
  EXECUTE 'ALTER TABLE public.barcode_settings ENABLE ROW LEVEL SECURITY';
  EXECUTE 'ALTER TABLE public.stocktaking ENABLE ROW LEVEL SECURITY';
  EXECUTE 'ALTER TABLE public.stocktaking_items ENABLE ROW LEVEL SECURITY';
  EXECUTE 'ALTER TABLE public.stock_adjustments ENABLE ROW LEVEL SECURITY';
  EXECUTE 'ALTER TABLE public.stock_adjustment_items ENABLE ROW LEVEL SECURITY';
  EXECUTE 'ALTER TABLE public.item_swaps ENABLE ROW LEVEL SECURITY';
  EXECUTE 'ALTER TABLE public.swap_items ENABLE ROW LEVEL SECURITY';
  EXECUTE 'ALTER TABLE public.opening_stock ENABLE ROW LEVEL SECURITY';
  EXECUTE 'ALTER TABLE public.customers ENABLE ROW LEVEL SECURITY';
  EXECUTE 'ALTER TABLE public.suppliers ENABLE ROW LEVEL SECURITY';
  EXECUTE 'ALTER TABLE public.supplier_customers ENABLE ROW LEVEL SECURITY';
  EXECUTE 'ALTER TABLE public.customer_groups ENABLE ROW LEVEL SECURITY';
  EXECUTE 'ALTER TABLE public.sales_agents ENABLE ROW LEVEL SECURITY';
  EXECUTE 'ALTER TABLE public.contact_ledger ENABLE ROW LEVEL SECURITY';
  EXECUTE 'ALTER TABLE public.purchase_invoices ENABLE ROW LEVEL SECURITY';
  EXECUTE 'ALTER TABLE public.purchase_items ENABLE ROW LEVEL SECURITY';
  EXECUTE 'ALTER TABLE public.supplied_items ENABLE ROW LEVEL SECURITY';
  EXECUTE 'ALTER TABLE public.sale_invoices ENABLE ROW LEVEL SECURITY';
  EXECUTE 'ALTER TABLE public.sale_items ENABLE ROW LEVEL SECURITY';
  EXECUTE 'ALTER TABLE public.cashier_shifts ENABLE ROW LEVEL SECURITY';
  EXECUTE 'ALTER TABLE public.promotions ENABLE ROW LEVEL SECURITY';
  EXECUTE 'ALTER TABLE public.free_returns ENABLE ROW LEVEL SECURITY';
  EXECUTE 'ALTER TABLE public.free_return_items ENABLE ROW LEVEL SECURITY';
  EXECUTE 'ALTER TABLE public.invoice_returns ENABLE ROW LEVEL SECURITY';
  EXECUTE 'ALTER TABLE public.invoice_return_items ENABLE ROW LEVEL SECURITY';
  EXECUTE 'ALTER TABLE public.quotations ENABLE ROW LEVEL SECURITY';
  EXECUTE 'ALTER TABLE public.quotation_items ENABLE ROW LEVEL SECURITY';
  EXECUTE 'ALTER TABLE public.shipping_orders ENABLE ROW LEVEL SECURITY';
  EXECUTE 'ALTER TABLE public.expenses ENABLE ROW LEVEL SECURITY';
  EXECUTE 'ALTER TABLE public.expense_categories ENABLE ROW LEVEL SECURITY';
  EXECUTE 'ALTER TABLE public.account_tree ENABLE ROW LEVEL SECURITY';
  EXECUTE 'ALTER TABLE public.journal_entries ENABLE ROW LEVEL SECURITY';
  EXECUTE 'ALTER TABLE public.journal_entry_lines ENABLE ROW LEVEL SECURITY';
  EXECUTE 'ALTER TABLE public.payment_vouchers ENABLE ROW LEVEL SECURITY';
  EXECUTE 'ALTER TABLE public.attendance ENABLE ROW LEVEL SECURITY';
  EXECUTE 'ALTER TABLE public.employee_messages ENABLE ROW LEVEL SECURITY';
  EXECUTE 'ALTER TABLE public.payroll ENABLE ROW LEVEL SECURITY';
  EXECUTE 'ALTER TABLE public.app_settings ENABLE ROW LEVEL SECURITY';
  EXECUTE 'ALTER TABLE public.app_notifications ENABLE ROW LEVEL SECURITY';
  EXECUTE 'ALTER TABLE public.archive_records ENABLE ROW LEVEL SECURITY';
  EXECUTE 'ALTER TABLE public.audit_logs ENABLE ROW LEVEL SECURITY';
EXCEPTION WHEN OTHERS THEN NULL;
END $$;

CREATE POLICY "access_branches" ON public.branches FOR ALL USING (current_user_is_active());
CREATE POLICY "access_permissions" ON public.permissions FOR ALL USING (current_user_is_active());

CREATE POLICY "access_medicines" ON public.medicines FOR ALL USING (current_user_is_active());
CREATE POLICY "access_medicine_levels" ON public.medicine_levels FOR ALL USING (current_user_is_active());
CREATE POLICY "access_item_batches" ON public.item_batches FOR ALL USING (current_user_is_active());
CREATE POLICY "access_medicine_barcodes" ON public.medicine_barcodes FOR ALL USING (current_user_is_active());
CREATE POLICY "access_item_categories" ON public.item_categories FOR ALL USING (current_user_is_active());
CREATE POLICY "access_medicine_brands" ON public.medicine_brands FOR ALL USING (current_user_is_active());
CREATE POLICY "access_item_variants" ON public.item_variants FOR ALL USING (current_user_is_active());
CREATE POLICY "access_item_warranties" ON public.item_warranties FOR ALL USING (current_user_is_active());
CREATE POLICY "access_price_groups" ON public.price_groups FOR ALL USING (current_user_is_active());
CREATE POLICY "access_barcode_settings" ON public.barcode_settings FOR ALL USING (current_user_is_active());
CREATE POLICY "access_stocktaking" ON public.stocktaking FOR ALL USING (current_user_is_active());
CREATE POLICY "access_stocktaking_items" ON public.stocktaking_items FOR ALL USING (current_user_is_active());
CREATE POLICY "access_stock_adjustments" ON public.stock_adjustments FOR ALL USING (current_user_is_active());
CREATE POLICY "access_stock_adjustment_items" ON public.stock_adjustment_items FOR ALL USING (current_user_is_active());
CREATE POLICY "access_item_swaps" ON public.item_swaps FOR ALL USING (current_user_is_active());
CREATE POLICY "access_swap_items" ON public.swap_items FOR ALL USING (current_user_is_active());
CREATE POLICY "access_opening_stock" ON public.opening_stock FOR ALL USING (current_user_is_active());
CREATE POLICY "access_customers" ON public.customers FOR ALL USING (current_user_is_active());
CREATE POLICY "access_suppliers" ON public.suppliers FOR ALL USING (current_user_is_active());
CREATE POLICY "access_supplier_customers" ON public.supplier_customers FOR ALL USING (current_user_is_active());
CREATE POLICY "access_customer_groups" ON public.customer_groups FOR ALL USING (current_user_is_active());
CREATE POLICY "access_sales_agents" ON public.sales_agents FOR ALL USING (current_user_is_active());
CREATE POLICY "access_contact_ledger" ON public.contact_ledger FOR ALL USING (current_user_is_active());
CREATE POLICY "access_purchase_invoices" ON public.purchase_invoices FOR ALL USING (current_user_is_active());
CREATE POLICY "access_purchase_items" ON public.purchase_items FOR ALL USING (current_user_is_active());
CREATE POLICY "access_supplied_items" ON public.supplied_items FOR ALL USING (current_user_is_active());
CREATE POLICY "access_sale_invoices" ON public.sale_invoices FOR ALL USING (current_user_is_active());
CREATE POLICY "access_sale_items" ON public.sale_items FOR ALL USING (current_user_is_active());
CREATE POLICY "access_cashier_shifts" ON public.cashier_shifts FOR ALL USING (current_user_is_active());
CREATE POLICY "access_promotions" ON public.promotions FOR ALL USING (current_user_is_active());
CREATE POLICY "access_free_returns" ON public.free_returns FOR ALL USING (current_user_is_active());
CREATE POLICY "access_free_return_items" ON public.free_return_items FOR ALL USING (current_user_is_active());
CREATE POLICY "access_invoice_returns" ON public.invoice_returns FOR ALL USING (current_user_is_active());
CREATE POLICY "access_invoice_return_items" ON public.invoice_return_items FOR ALL USING (current_user_is_active());
CREATE POLICY "access_quotations" ON public.quotations FOR ALL USING (current_user_is_active());
CREATE POLICY "access_quotation_items" ON public.quotation_items FOR ALL USING (current_user_is_active());
CREATE POLICY "access_shipping_orders" ON public.shipping_orders FOR ALL USING (current_user_is_active());
CREATE POLICY "access_expenses" ON public.expenses FOR ALL USING (current_user_is_active());
CREATE POLICY "access_expense_categories" ON public.expense_categories FOR ALL USING (current_user_is_active());
CREATE POLICY "access_account_tree" ON public.account_tree FOR ALL USING (current_user_is_active());
CREATE POLICY "access_journal_entries" ON public.journal_entries FOR ALL USING (current_user_is_active());
CREATE POLICY "access_journal_entry_lines" ON public.journal_entry_lines FOR ALL USING (current_user_is_active());
CREATE POLICY "access_payment_vouchers" ON public.payment_vouchers FOR ALL USING (current_user_is_active());
CREATE POLICY "access_attendance" ON public.attendance FOR ALL USING (current_user_is_active());
CREATE POLICY "access_employee_messages" ON public.employee_messages FOR ALL USING (current_user_is_active());
CREATE POLICY "access_payroll" ON public.payroll FOR ALL USING (current_user_is_active());
CREATE POLICY "access_app_settings" ON public.app_settings FOR ALL USING (current_user_is_active());
CREATE POLICY "access_app_notifications" ON public.app_notifications FOR ALL USING (current_user_is_active());
CREATE POLICY "access_archive_records" ON public.archive_records FOR ALL USING (current_user_is_active());
CREATE POLICY "access_audit_logs" ON public.audit_logs FOR ALL USING (current_user_is_active());

DROP POLICY IF EXISTS "access_users" ON public.users;
CREATE POLICY "access_users" ON public.users FOR SELECT USING (current_user_is_active());
CREATE POLICY "modify_users" ON public.users FOR INSERT WITH CHECK (current_user_is_owner());
CREATE POLICY "update_users" ON public.users FOR UPDATE USING (current_user_is_active()) WITH CHECK (current_user_is_owner());

-- ─── 5. Sync RPCs ────────────────────────────────────────────────────

CREATE OR REPLACE FUNCTION public.acquire_session_lock(
  p_user_id TEXT, p_device_id TEXT
) RETURNS BOOLEAN LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  UPDATE public.users SET last_login = now() WHERE id::text = p_user_id;
  RETURN TRUE;
END;
$$;

CREATE OR REPLACE FUNCTION public.release_session_lock(
  p_user_id TEXT, p_device_id TEXT
) RETURNS VOID LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  IF p_device_id = '__any__' THEN
    IF NOT current_user_is_owner() THEN
      RAISE EXCEPTION 'not authorized to force-release session lock';
    END IF;
    UPDATE public.users SET active_device_id = NULL WHERE id::text = p_user_id;
  ELSE
    UPDATE public.users SET active_device_id = NULL
    WHERE id::text = p_user_id AND active_device_id = p_device_id;
  END IF;
END;
$$;

GRANT EXECUTE ON FUNCTION public.acquire_session_lock TO authenticated;
GRANT EXECUTE ON FUNCTION public.release_session_lock TO authenticated;
