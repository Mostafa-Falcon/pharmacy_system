-- ═══════════════════════════════════════════════════════════════
-- Ensure archive_records and other sync tables are selectable
-- Safe to re-run.
-- ═══════════════════════════════════════════════════════════════

DROP POLICY IF EXISTS "archive_records_select_all" ON public.archive_records;
DROP POLICY IF EXISTS "archive_records_insert_all" ON public.archive_records;
DROP POLICY IF EXISTS "archive_records_update_all" ON public.archive_records;
DROP POLICY IF EXISTS "archive_records_delete_all" ON public.archive_records;

CREATE POLICY "archive_records_select_all" ON public.archive_records
  FOR SELECT USING (true);
CREATE POLICY "archive_records_insert_all" ON public.archive_records
  FOR INSERT WITH CHECK (true);
CREATE POLICY "archive_records_update_all" ON public.archive_records
  FOR UPDATE USING (true) WITH CHECK (true);
CREATE POLICY "archive_records_delete_all" ON public.archive_records
  FOR DELETE USING (true);

ALTER TABLE public.archive_records ENABLE ROW LEVEL SECURITY;
