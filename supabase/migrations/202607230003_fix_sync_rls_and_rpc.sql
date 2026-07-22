-- ═══════════════════════════════════════════════════════════════
-- Fix sync tables: add missing columns, RLS policies, and basic RPCs
-- Safe to re-run (idempotent).
-- ═══════════════════════════════════════════════════════════════

-- ─── 1. Ensure last_modified on sync tables ──────────────────
ALTER TABLE public.archive_records
  ADD COLUMN IF NOT EXISTS last_modified TIMESTAMPTZ NOT NULL DEFAULT NOW();

ALTER TABLE public.stocktaking_periods
  ADD COLUMN IF NOT EXISTS last_modified TIMESTAMPTZ NOT NULL DEFAULT NOW();

ALTER TABLE public.stocktaking_counts
  ADD COLUMN IF NOT EXISTS last_modified TIMESTAMPTZ NOT NULL DEFAULT NOW();

ALTER TABLE public.expenses
  ADD COLUMN IF NOT EXISTS last_modified TIMESTAMPTZ NOT NULL DEFAULT NOW();

-- ─── 2. Drop and recreate RLS policies for sync tables ────────
DROP POLICY IF EXISTS "archive_records_select_all" ON public.archive_records;
DROP POLICY IF EXISTS "archive_records_insert_all" ON public.archive_records;
DROP POLICY IF EXISTS "archive_records_update_all" ON public.archive_records;

DROP POLICY IF EXISTS "stocktaking_periods_select_all" ON public.stocktaking_periods;
DROP POLICY IF EXISTS "stocktaking_periods_insert_all" ON public.stocktaking_periods;
DROP POLICY IF EXISTS "stocktaking_periods_update_all" ON public.stocktaking_periods;

DROP POLICY IF EXISTS "stocktaking_counts_select_all" ON public.stocktaking_counts;
DROP POLICY IF EXISTS "stocktaking_counts_insert_all" ON public.stocktaking_counts;
DROP POLICY IF EXISTS "stocktaking_counts_update_all" ON public.stocktaking_counts;

DROP POLICY IF EXISTS "expenses_select_all" ON public.expenses;
DROP POLICY IF EXISTS "expenses_insert_all" ON public.expenses;
DROP POLICY IF EXISTS "expenses_update_all" ON public.expenses;

-- Re-enable RLS
ALTER TABLE public.archive_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.stocktaking_periods ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.stocktaking_counts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.expenses ENABLE ROW LEVEL SECURITY;

-- Recreate policies
CREATE POLICY "archive_records_select_all" ON public.archive_records
  FOR SELECT USING (true);
CREATE POLICY "archive_records_insert_all" ON public.archive_records
  FOR INSERT WITH CHECK (true);
CREATE POLICY "archive_records_update_all" ON public.archive_records
  FOR UPDATE USING (true) WITH CHECK (true);

CREATE POLICY "stocktaking_periods_select_all" ON public.stocktaking_periods
  FOR SELECT USING (true);
CREATE POLICY "stocktaking_periods_insert_all" ON public.stocktaking_periods
  FOR INSERT WITH CHECK (true);
CREATE POLICY "stocktaking_periods_update_all" ON public.stocktaking_periods
  FOR UPDATE USING (true) WITH CHECK (true);

CREATE POLICY "stocktaking_counts_select_all" ON public.stocktaking_counts
  FOR SELECT USING (true);
CREATE POLICY "stocktaking_counts_insert_all" ON public.stocktaking_counts
  FOR INSERT WITH CHECK (true);
CREATE POLICY "stocktaking_counts_update_all" ON public.stocktaking_counts
  FOR UPDATE USING (true) WITH CHECK (true);

CREATE POLICY "expenses_select_all" ON public.expenses
  FOR SELECT USING (true);
CREATE POLICY "expenses_insert_all" ON public.expenses
  FOR INSERT WITH CHECK (true);
CREATE POLICY "expenses_update_all" ON public.expenses
  FOR UPDATE USING (true) WITH CHECK (true);

CREATE POLICY "archive_records_delete_all" ON public.archive_records
  FOR DELETE USING (true);

CREATE POLICY "stocktaking_periods_delete_all" ON public.stocktaking_periods
  FOR DELETE USING (true);

CREATE POLICY "stocktaking_counts_delete_all" ON public.stocktaking_counts
  FOR DELETE USING (true);

CREATE POLICY "expenses_delete_all" ON public.expenses
  FOR DELETE USING (true);

-- ─── 3. Basic domain_operations RPCs ──────────────────────────
CREATE OR REPLACE FUNCTION public.append_domain_operations(p_operations jsonb)
RETURNS TABLE (
  operation_id text,
  revision bigint,
  already_applied boolean
) LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE
  v_op jsonb;
  v_revision bigint;
  v_pharmacy_id text;
  v_operation_id text;
  v_already_applied boolean;
BEGIN
  FOR v_op IN SELECT * FROM jsonb_array_elements(p_operations) LOOP
    v_pharmacy_id := v_op->>'pharmacy_id';
    v_operation_id := v_op->>'id';
    
    IF v_pharmacy_id IS NULL OR v_operation_id IS NULL THEN
      CONTINUE;
    END IF;

    SELECT COALESCE(MAX(revision), 0) + 1 INTO v_revision
    FROM public.domain_operations
    WHERE pharmacy_id = v_pharmacy_id;

    INSERT INTO public.domain_operations (
      pharmacy_id, operation_id, revision, branch_id, operation_type,
      actor_id, device_id, occurred_at, schema_version, payload, payload_hash, created_at
    ) VALUES (
      v_pharmacy_id,
      v_operation_id,
      v_revision,
      (v_op->>'branch_id'),
      (v_op->>'type'),
      (v_op->>'actor_id')::uuid,
      COALESCE(v_op->>'device_id', ''),
      COALESCE((v_op->>'occurred_at')::timestamptz, now()),
      COALESCE((v_op->>'schema_version')::int, 1),
      v_op,
      md5(v_op::text),
      now()
    )
    ON CONFLICT (pharmacy_id, operation_id) DO NOTHING;

    GET DIAGNOSTICS v_already_applied = ROW_COUNT;
    IF v_already_applied THEN
      v_revision := 0;
    END IF;

    operation_id := v_operation_id;
    revision := v_revision;
    already_applied := (v_already_applied = 0);
    RETURN NEXT;
  END LOOP;
END;
$$;

CREATE OR REPLACE FUNCTION public.pull_domain_operations(
  p_pharmacy_id text,
  p_after_revision bigint,
  p_limit integer,
  p_access_signature text DEFAULT NULL
)
RETURNS TABLE (
  revision bigint,
  payload jsonb,
  access_signature text,
  access_context jsonb,
  reset_required boolean
) LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  RETURN QUERY
  SELECT
    d.revision,
    d.payload,
    d.payload_hash AS access_signature,
    NULL::jsonb AS access_context,
    false AS reset_required
  FROM public.domain_operations d
  WHERE d.pharmacy_id = p_pharmacy_id
    AND d.revision > p_after_revision
  ORDER BY d.revision ASC
  LIMIT p_limit;
END;
$$;

REVOKE ALL ON FUNCTION public.append_domain_operations(jsonb) FROM public, anon, authenticated;
REVOKE ALL ON FUNCTION public.pull_domain_operations(text, bigint, integer, text) FROM public, anon, authenticated;
GRANT EXECUTE ON FUNCTION public.append_domain_operations(jsonb) TO authenticated;
GRANT EXECUTE ON FUNCTION public.pull_domain_operations(text, bigint, integer, text) TO authenticated;
