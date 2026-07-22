-- إنشاء جدول سجل الأرشفة لتتبع كل العمليات المحذوفة في المنظومة
CREATE TABLE IF NOT EXISTS archive_records (
  id TEXT PRIMARY KEY,
  entity_type TEXT NOT NULL,
  entity_id TEXT NOT NULL,
  entity_name TEXT NOT NULL DEFAULT '',
  entity_data JSONB NOT NULL DEFAULT '{}'::jsonb,
  deleted_by TEXT NOT NULL DEFAULT '',
  deleted_by_name TEXT NOT NULL DEFAULT '',
  deleted_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  branch_id TEXT NOT NULL DEFAULT '',
  restored_at TIMESTAMPTZ,
  restored_by TEXT,
  permanently_deleted_at TIMESTAMPTZ,
  sync_version INT NOT NULL DEFAULT 1,
  last_modified TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- فهارس للبحث السريع
CREATE INDEX IF NOT EXISTS idx_archive_records_entity_type ON archive_records(entity_type);
CREATE INDEX IF NOT EXISTS idx_archive_records_entity_name ON archive_records(entity_name);
CREATE INDEX IF NOT EXISTS idx_archive_records_deleted_by ON archive_records(deleted_by);
CREATE INDEX IF NOT EXISTS idx_archive_records_deleted_at ON archive_records(deleted_at DESC);
CREATE INDEX IF NOT EXISTS idx_archive_records_branch_id ON archive_records(branch_id);
CREATE INDEX IF NOT EXISTS idx_archive_records_active ON archive_records(restored_at, permanently_deleted_at);

-- صلاحيات RLS: كل المستخدمين المسجلين يقدرون يقرؤون ويسجلون
ALTER TABLE archive_records ENABLE ROW LEVEL SECURITY;

CREATE POLICY "archive_records_select_all" ON archive_records
  FOR SELECT USING (true);

CREATE POLICY "archive_records_insert_all" ON archive_records
  FOR INSERT WITH CHECK (true);

CREATE POLICY "archive_records_update_all" ON archive_records
  FOR UPDATE USING (true) WITH CHECK (true);

-- RPC function لاستعلامات التصفية
CREATE OR REPLACE FUNCTION get_archive_records(
  p_entity_type TEXT DEFAULT NULL,
  p_search TEXT DEFAULT NULL,
  p_page INT DEFAULT 1,
  p_page_size INT DEFAULT 50
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_offset INT;
  v_total INT;
  v_records JSONB;
BEGIN
  v_offset := (p_page - 1) * p_page_size;

  -- Count total
  SELECT COUNT(*) INTO v_total
  FROM archive_records
  WHERE (p_entity_type IS NULL OR entity_type = p_entity_type)
    AND (p_search IS NULL OR entity_name ILIKE '%' || p_search || '%' OR deleted_by_name ILIKE '%' || p_search || '%');

  -- Fetch records
  SELECT COALESCE(jsonb_agg(r ORDER BY r.deleted_at DESC), '[]'::jsonb) INTO v_records
  FROM (
    SELECT *
    FROM archive_records
    WHERE (p_entity_type IS NULL OR entity_type = p_entity_type)
      AND (p_search IS NULL OR entity_name ILIKE '%' || p_search || '%' OR deleted_by_name ILIKE '%' || p_search || '%')
    ORDER BY deleted_at DESC
    LIMIT p_page_size
    OFFSET v_offset
  ) r;

  RETURN jsonb_build_object(
    'records', v_records,
    'total', v_total,
    'page', p_page,
    'page_size', p_page_size
  );
END;
$$;
