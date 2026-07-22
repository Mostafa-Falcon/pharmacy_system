-- ═══════════════════════════════════════════════════════════════
-- Fix: Session Lock RPCs + RLS for app upsert + active_device_id
-- Safe to re-run (idempotent).
-- ═══════════════════════════════════════════════════════════════

-- ─── 1) active_device_id column ───────────────────────────────
DO $$ BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_schema = 'public' AND table_name = 'users' AND column_name = 'active_device_id'
  ) THEN
    ALTER TABLE public.users ADD COLUMN active_device_id TEXT;
  END IF;
END $$;

-- ─── 2) acquire_session_lock RPC ──────────────────────────────
CREATE OR REPLACE FUNCTION public.acquire_session_lock(
  p_user_id TEXT, p_device_id TEXT
) RETURNS BOOLEAN LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE
  v_current TEXT;
BEGIN
  SELECT active_device_id INTO v_current FROM public.users WHERE id = p_user_id;
  IF v_current IS NULL OR v_current = p_device_id THEN
    UPDATE public.users SET active_device_id = p_device_id, last_login = now() WHERE id = p_user_id;
    RETURN TRUE;
  END IF;
  RETURN FALSE;
END;
$$;

-- ─── 3) release_session_lock RPC ──────────────────────────────
CREATE OR REPLACE FUNCTION public.release_session_lock(
  p_user_id TEXT, p_device_id TEXT
) RETURNS VOID LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  IF p_device_id = '__any__' THEN
    UPDATE public.users SET active_device_id = NULL WHERE id = p_user_id;
  ELSE
    UPDATE public.users SET active_device_id = NULL
    WHERE id = p_user_id AND active_device_id = p_device_id;
  END IF;
END;
$$;

-- ─── 4) Fix RLS for public.users to allow app upsert ──────────
DROP POLICY IF EXISTS "users_insert_self" ON public.users;
DROP POLICY IF EXISTS "users_select_self" ON public.users;
DROP POLICY IF EXISTS "users_update_self" ON public.users;

-- Allow authenticated users to insert their own row
DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'users_insert_self' AND tablename = 'users') THEN
    CREATE POLICY "users_insert_self" ON public.users
      FOR INSERT WITH CHECK (id = auth.uid()::text);
  END IF;
END $$;

-- Allow authenticated users to select any row (needed for sync)
DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'users_select_any' AND tablename = 'users') THEN
    CREATE POLICY "users_select_any" ON public.users
      FOR SELECT USING (auth.role() = 'authenticated');
  END IF;
END $$;

-- Allow authenticated users to update any row (needed for sync upsert)
DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'users_update_any' AND tablename = 'users') THEN
    CREATE POLICY "users_update_any" ON public.users
      FOR UPDATE USING (auth.role() = 'authenticated')
      WITH CHECK (auth.role() = 'authenticated');
  END IF;
END $$;

-- Allow authenticated users to delete (soft-delete) any row for sync
DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'users_delete_any' AND tablename = 'users') THEN
    CREATE POLICY "users_delete_any" ON public.users
      FOR DELETE USING (auth.role() = 'authenticated');
  END IF;
END $$;
