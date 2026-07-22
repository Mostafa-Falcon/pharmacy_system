-- إضافة عمود created_at لجدول الأدوية لتتبع وقت/تاريخ إنشاء كل دواء (حتى وقت الرفع)
-- يمكن تنفيذ هذا الملف عدة مرات بأمان (idempotent).

DO $$ BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_schema = 'public'
      AND table_name = 'medicines'
      AND column_name = 'created_at'
  ) THEN
    ALTER TABLE public.medicines
      ADD COLUMN created_at TIMESTAMPTZ NOT NULL DEFAULT now();
  END IF;
END $$;

CREATE INDEX IF NOT EXISTS idx_medicines_created_at
  ON public.medicines(created_at);
