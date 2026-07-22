-- Fix RPC overload conflict: drop uuid-parameter versions and recreate with TEXT only
-- The previous migration (202607180001) created functions with TEXT params,
-- but an earlier manual run created uuid-param versions, causing PostgREST
-- to fail with PGRST203 (cannot resolve overload).

DROP FUNCTION IF EXISTS public.acquire_session_lock(p_user_id uuid, p_device_id text);
DROP FUNCTION IF EXISTS public.acquire_session_lock(p_user_id text, p_device_id text);
CREATE OR REPLACE FUNCTION public.acquire_session_lock(
  p_user_id TEXT, p_device_id TEXT
) RETURNS BOOLEAN LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE
  v_current TEXT;
BEGIN
  SELECT active_device_id INTO v_current FROM public.users WHERE id::text = p_user_id;
  IF v_current IS NULL OR v_current = p_device_id THEN
    UPDATE public.users SET active_device_id = p_device_id, last_login = now() WHERE id::text = p_user_id;
    RETURN TRUE;
  END IF;
  RETURN FALSE;
END;
$$;

DROP FUNCTION IF EXISTS public.release_session_lock(p_user_id uuid, p_device_id text);
DROP FUNCTION IF EXISTS public.release_session_lock(p_user_id text, p_device_id text);
CREATE OR REPLACE FUNCTION public.release_session_lock(
  p_user_id TEXT, p_device_id TEXT
) RETURNS VOID LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  IF p_device_id = '__any__' THEN
    UPDATE public.users SET active_device_id = NULL WHERE id::text = p_user_id;
  ELSE
    UPDATE public.users SET active_device_id = NULL
    WHERE id::text = p_user_id AND active_device_id = p_device_id;
  END IF;
END;
$$;
