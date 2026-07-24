-- ═══════════════════════════════════════════════════════════════════
-- Pharmacy System — 1/9 Auth & Users
-- الجداول: branches, users, permissions
-- ═══════════════════════════════════════════════════════════════════

-- ─── الفروع (Branches) ────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.branches (
  id            TEXT PRIMARY KEY,
  name          TEXT NOT NULL,
  account_id    TEXT,
  address       TEXT,
  phone         TEXT,
  is_active     BOOLEAN NOT NULL DEFAULT true,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  sync_version  INT NOT NULL DEFAULT 1,
  last_modified TIMESTAMPTZ NOT NULL DEFAULT now(),
  is_deleted    BOOLEAN NOT NULL DEFAULT false
);

CREATE INDEX IF NOT EXISTS idx_branches_account ON public.branches(account_id);
CREATE INDEX IF NOT EXISTS idx_branches_last_modified ON public.branches(last_modified);

-- ─── المستخدمين (Users) ────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.users (
  id                 TEXT PRIMARY KEY,
  name               TEXT NOT NULL,
  email              TEXT NOT NULL UNIQUE,
  password_hash      TEXT NOT NULL DEFAULT '',
  role               TEXT NOT NULL DEFAULT 'employee' CHECK (role IN ('owner', 'employee')),
  assigned_branch_id TEXT,
  account_id         TEXT,
  is_active          BOOLEAN NOT NULL DEFAULT true,
  created_at         TIMESTAMPTZ NOT NULL DEFAULT now(),
  last_login         TIMESTAMPTZ,
  active_device_id   TEXT,
  sync_version       INT NOT NULL DEFAULT 1,
  last_modified      TIMESTAMPTZ NOT NULL DEFAULT now(),
  is_deleted         BOOLEAN NOT NULL DEFAULT false
);

CREATE INDEX IF NOT EXISTS idx_users_email ON public.users(email);
CREATE INDEX IF NOT EXISTS idx_users_account ON public.users(account_id);
CREATE INDEX IF NOT EXISTS idx_users_last_modified ON public.users(last_modified);

-- ─── الصلاحيات (Permissions) ───────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.permissions (
  id               TEXT PRIMARY KEY,
  user_id          TEXT NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  permission_key   TEXT NOT NULL,
  is_allowed       BOOLEAN NOT NULL DEFAULT false,
  account_id       TEXT,
  created_at       TIMESTAMPTZ NOT NULL DEFAULT now(),
  sync_version     INT NOT NULL DEFAULT 1,
  last_modified    TIMESTAMPTZ NOT NULL DEFAULT now(),
  is_deleted       BOOLEAN NOT NULL DEFAULT false,
  UNIQUE(user_id, permission_key)
);

CREATE INDEX IF NOT EXISTS idx_permissions_user ON public.permissions(user_id);
CREATE INDEX IF NOT EXISTS idx_permissions_account ON public.permissions(account_id);
CREATE INDEX IF NOT EXISTS idx_permissions_last_modified ON public.permissions(last_modified);
