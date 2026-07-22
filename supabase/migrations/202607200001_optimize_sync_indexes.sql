-- ═══════════════════════════════════════════════════════════════
-- Performance: indexes to accelerate incremental sync (watermark pull)
-- Pull uses `last_modified >= since` filtered by `is_deleted` and ordered
-- by `last_modified`. These indexes make the watermark scan O(log n)
-- instead of a full table scan — no lag even with millions of rows.
-- Idempotent / safe to re-run.
-- ═══════════════════════════════════════════════════════════════

-- فهرس على last_modified لكل جدول متزامن (أساسي للسحب التزايدي)
DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_medicines_last_modified') THEN
    CREATE INDEX idx_medicines_last_modified ON public.medicines (last_modified);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_sales_last_modified') THEN
    CREATE INDEX idx_sales_last_modified ON public.sales (last_modified);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_purchases_last_modified') THEN
    CREATE INDEX idx_purchases_last_modified ON public.purchases (last_modified);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_returns_last_modified') THEN
    CREATE INDEX idx_returns_last_modified ON public.returns (last_modified);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_cashier_shifts_last_modified') THEN
    CREATE INDEX idx_cashier_shifts_last_modified ON public.cashier_shifts (last_modified);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_quotes_last_modified') THEN
    CREATE INDEX idx_quotes_last_modified ON public.quotes (last_modified);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_branches_last_modified') THEN
    CREATE INDEX idx_branches_last_modified ON public.branches (last_modified);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_users_last_modified') THEN
    CREATE INDEX idx_users_last_modified ON public.users (last_modified);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_permissions_last_modified') THEN
    CREATE INDEX idx_permissions_last_modified ON public.permissions (last_modified);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_customers_last_modified') THEN
    CREATE INDEX idx_customers_last_modified ON public.customers (last_modified);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_suppliers_last_modified') THEN
    CREATE INDEX idx_suppliers_last_modified ON public.suppliers (last_modified);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_customer_suppliers_last_modified') THEN
    CREATE INDEX idx_customer_suppliers_last_modified ON public.customer_suppliers (last_modified);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_customer_groups_last_modified') THEN
    CREATE INDEX idx_customer_groups_last_modified ON public.customer_groups (last_modified);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_customer_ledgers_last_modified') THEN
    CREATE INDEX idx_customer_ledgers_last_modified ON public.customer_ledgers (last_modified);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_supplier_ledgers_last_modified') THEN
    CREATE INDEX idx_supplier_ledgers_last_modified ON public.supplier_ledgers (last_modified);
  END IF;
END $$;

-- فهرس مركّب (branch_id, last_modified) لتسريع الفلترة المزدوجة
-- اللي بتتعمل في كل جولة سحب تزايدي.
DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_medicines_branch_lm') THEN
    CREATE INDEX idx_medicines_branch_lm ON public.medicines (branch_id, last_modified);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_sales_branch_lm') THEN
    CREATE INDEX idx_sales_branch_lm ON public.sales (branch_id, last_modified);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_purchases_branch_lm') THEN
    CREATE INDEX idx_purchases_branch_lm ON public.purchases (branch_id, last_modified);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_returns_branch_lm') THEN
    CREATE INDEX idx_returns_branch_lm ON public.returns (branch_id, last_modified);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_customer_ledgers_branch_lm') THEN
    CREATE INDEX idx_customer_ledgers_branch_lm ON public.customer_ledgers (branch_id, last_modified);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_supplier_ledgers_branch_lm') THEN
    CREATE INDEX idx_supplier_ledgers_branch_lm ON public.supplier_ledgers (branch_id, last_modified);
  END IF;
END $$;
