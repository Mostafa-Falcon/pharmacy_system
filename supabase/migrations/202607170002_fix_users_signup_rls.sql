-- ═══════════════════════════════════════════════════════════════
-- Auto-provision public.users row on auth signup + safe RLS
-- Goals:
--   1) الحساب يتخزن فوراً في جدول public.users عند signUp (مرة واحدة).
--   2) مفيش تكرار: الصف بـ id = auth.uid()، والـ trigger بيعمل
--      ON CONFLICT DO NOTHING، والـ upsert المباشر + الـ sync queue
--      كلهم بيستخدموا نفس الـ id → مستحيل يتكرر.
--   3) التسجيل مبسّط: الـ trigger بيكتب الحقول الأساسية بس (مفيش assigned_branch_id)
--      عشان نتجنب "Database error saving new user" الناتج عن تعارض القيود في
--      لحظة التسجيل الحرجة. الفرع يتربط لاحقاً عبر upsert من التطبيق.
--   4) مفيش تأكيد إيميل إجباري: نطفي "Confirm email" من Supabase Dashboard
--      (Authentication → Providers → Email) بدل تعديل auth.users جوه الـ trigger
--      (ده اللي كان بيسبب الخطأ).
-- Idempotent / safe to re-run.
-- ═══════════════════════════════════════════════════════════════

-- ─── 1) Trigger function: create users row on signup ───────────
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  -- صف الملف التعريفي في public.users (مرة واحدة، بدون تكرار).
  -- نكتب الحقول الأساسية بس (اللي ليها defaults في الجدول) عشان
  -- نتجنب أي تعارض مع قيود NOT NULL على أعمدة تانية (مثل الفرع).
  -- الفرع والبيانات الإضافية بتتحدّث لاحقاً عبر upsert من التطبيق
  -- بعد نجاح التسجيل، مش جوه الـ trigger.
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

  -- ملاحظة: متأكدناش الإيميل من جوه الـ trigger لأن تعديل auth.users
  -- جوه الـ SECURITY DEFINER بيرمي أحياناً "Database error saving new user".
  -- بدل ذلك نطفي "Confirm email" من Supabase Dashboard (Authentication →
  -- Providers → Email) عشان الدخول يشتغل فوراً بدون تأكيد.

  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- ─── 2) Safe RLS for public.users ──────────────────────────────
-- Drop the old blanket policy so a user cannot read/write all rows.
DROP POLICY IF EXISTS "Authenticated full access" ON public.users;

-- Allow the user to insert their OWN row (id must equal auth.uid()).
DO $$ BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE policyname = 'users_insert_self' AND tablename = 'users'
  ) THEN
    CREATE POLICY "users_insert_self" ON public.users
      FOR INSERT
      WITH CHECK (id = auth.uid()::text);
  END IF;
END $$;

-- Allow the user to select their OWN row.
DO $$ BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE policyname = 'users_select_self' AND tablename = 'users'
  ) THEN
    CREATE POLICY "users_select_self" ON public.users
      FOR SELECT
      USING (id = auth.uid()::text);
  END IF;
END $$;

-- Allow the user to update their OWN row.
DO $$ BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE policyname = 'users_update_self' AND tablename = 'users'
  ) THEN
    CREATE POLICY "users_update_self" ON public.users
      FOR UPDATE
      USING (id = auth.uid()::text)
      WITH CHECK (id = auth.uid()::text);
  END IF;
END $$;
