-- ═══════════════════════════════════════════════════════════════════
-- Pharmacy System — 8/9 HR & System
-- الجداول: attendance, employee_messages, payroll, app_settings,
--          app_notifications, archive_records, audit_logs
-- ═══════════════════════════════════════════════════════════════════

-- ─── الحضور والانصراف (Attendance) ──────────────────────────────────
CREATE TABLE IF NOT EXISTS public.attendance (
  id             TEXT PRIMARY KEY,
  employee_id    TEXT NOT NULL,
  employee_name  TEXT NOT NULL DEFAULT '',
  date           DATE NOT NULL,
  check_in_time  TIMESTAMPTZ NOT NULL,
  check_out_time TIMESTAMPTZ,
  work_hours     NUMERIC NOT NULL DEFAULT 0,
  overtime_hours NUMERIC NOT NULL DEFAULT 0,
  late_minutes   INT NOT NULL DEFAULT 0,
  status         TEXT NOT NULL DEFAULT 'present' CHECK (status IN ('present', 'absent', 'leave', 'earlyLeave')),
  account_id     TEXT,
  branch_id      TEXT,
  notes          TEXT
);

CREATE INDEX IF NOT EXISTS idx_attendance_employee ON public.attendance(employee_id);
CREATE INDEX IF NOT EXISTS idx_attendance_date ON public.attendance(date);
CREATE INDEX IF NOT EXISTS idx_attendance_branch ON public.attendance(branch_id);
CREATE INDEX IF NOT EXISTS idx_attendance_account ON public.attendance(account_id);

-- ─── رسائل الموظفين (Employee Messages) ─────────────────────────────
CREATE TABLE IF NOT EXISTS public.employee_messages (
  id                    TEXT PRIMARY KEY,
  title                 TEXT NOT NULL,
  content               TEXT NOT NULL,
  sender_name           TEXT NOT NULL DEFAULT 'الإدارة',
  recipient_employee_ids JSONB,
  is_broadcast          BOOLEAN NOT NULL DEFAULT true,
  read_by_employee_ids  JSONB NOT NULL DEFAULT '[]',
  account_id            TEXT,
  branch_id             TEXT,
  sent_at               TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_employee_messages_branch ON public.employee_messages(branch_id);
CREATE INDEX IF NOT EXISTS idx_employee_messages_account ON public.employee_messages(account_id);

-- ─── الرواتب (Payroll) ──────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.payroll (
  id            TEXT PRIMARY KEY,
  employee_id   TEXT NOT NULL,
  employee_name TEXT NOT NULL DEFAULT '',
  month_year    TEXT NOT NULL,
  basic_salary  NUMERIC NOT NULL DEFAULT 0,
  allowances    NUMERIC NOT NULL DEFAULT 0,
  deductions    NUMERIC NOT NULL DEFAULT 0,
  advances      NUMERIC NOT NULL DEFAULT 0,
  net_salary    NUMERIC NOT NULL DEFAULT 0,
  is_paid       BOOLEAN NOT NULL DEFAULT false,
  paid_at       TIMESTAMPTZ,
  account_id    TEXT,
  branch_id     TEXT,
  notes         TEXT
);

CREATE INDEX IF NOT EXISTS idx_payroll_employee ON public.payroll(employee_id);
CREATE INDEX IF NOT EXISTS idx_payroll_month ON public.payroll(month_year);
CREATE INDEX IF NOT EXISTS idx_payroll_branch ON public.payroll(branch_id);
CREATE INDEX IF NOT EXISTS idx_payroll_account ON public.payroll(account_id);

-- ─── إعدادات التطبيق (App Settings) ─────────────────────────────────
CREATE TABLE IF NOT EXISTS public.app_settings (
  id                       TEXT PRIMARY KEY DEFAULT 'default',
  pharmacy_name            TEXT NOT NULL DEFAULT 'صيدليتي',
  pharmacy_name_en         TEXT NOT NULL DEFAULT 'My Pharmacy',
  currency                 TEXT NOT NULL DEFAULT 'ج.م',
  tax_number               TEXT,
  commercial_register      TEXT,
  logo_url                 TEXT,
  address                  TEXT,
  phone                    TEXT,
  email                    TEXT,
  default_low_stock_threshold INT NOT NULL DEFAULT 10,
  near_expiry_alert_days   INT NOT NULL DEFAULT 90,
  auto_open_cash_drawer    BOOLEAN NOT NULL DEFAULT true,
  auto_print_receipt       BOOLEAN NOT NULL DEFAULT true,
  account_id               TEXT,
  last_modified            TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ─── الإشعارات (App Notifications) ──────────────────────────────────
CREATE TABLE IF NOT EXISTS public.app_notifications (
  id           TEXT PRIMARY KEY,
  title        TEXT NOT NULL,
  message      TEXT NOT NULL,
  type         TEXT NOT NULL DEFAULT 'systemAlert' CHECK (type IN ('lowStock', 'expiryWarning', 'newOrder', 'systemAlert')),
  target_route TEXT,
  is_read      BOOLEAN NOT NULL DEFAULT false,
  account_id   TEXT,
  branch_id    TEXT,
  created_at   TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_app_notifications_account ON public.app_notifications(account_id);
CREATE INDEX IF NOT EXISTS idx_app_notifications_branch ON public.app_notifications(branch_id);
CREATE INDEX IF NOT EXISTS idx_app_notifications_read ON public.app_notifications(is_read);

-- ─── سجل الأرشفة (Archive Records) ──────────────────────────────────
CREATE TABLE IF NOT EXISTS public.archive_records (
  id                     TEXT PRIMARY KEY,
  entity_type            TEXT NOT NULL,
  entity_id              TEXT NOT NULL,
  entity_name            TEXT NOT NULL DEFAULT '',
  entity_data            JSONB NOT NULL DEFAULT '{}',
  deleted_by             TEXT NOT NULL DEFAULT '',
  deleted_by_name        TEXT NOT NULL DEFAULT '',
  deleted_at             TIMESTAMPTZ NOT NULL DEFAULT now(),
  branch_id              TEXT NOT NULL DEFAULT '',
  account_id             TEXT,
  restored_at            TIMESTAMPTZ,
  restored_by            TEXT,
  permanently_deleted_at TIMESTAMPTZ,
  sync_version           INT NOT NULL DEFAULT 1,
  last_modified          TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_archive_records_entity_type ON public.archive_records(entity_type);
CREATE INDEX IF NOT EXISTS idx_archive_records_entity_name ON public.archive_records(entity_name);
CREATE INDEX IF NOT EXISTS idx_archive_records_deleted_at ON public.archive_records(deleted_at DESC);
CREATE INDEX IF NOT EXISTS idx_archive_records_branch ON public.archive_records(branch_id);
CREATE INDEX IF NOT EXISTS idx_archive_records_account ON public.archive_records(account_id);
CREATE INDEX IF NOT EXISTS idx_archive_records_last_modified ON public.archive_records(last_modified);

-- ─── سجل التدقيق (Audit Logs) ───────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.audit_logs (
  id          TEXT PRIMARY KEY,
  action      TEXT NOT NULL,
  entity_type TEXT NOT NULL,
  entity_id   TEXT NOT NULL,
  actor_id    TEXT NOT NULL,
  actor_name  TEXT,
  branch_id   TEXT,
  summary     JSONB,
  occurred_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_audit_logs_action ON public.audit_logs(action);
CREATE INDEX IF NOT EXISTS idx_audit_logs_entity ON public.audit_logs(entity_type, entity_id);
CREATE INDEX IF NOT EXISTS idx_audit_logs_actor ON public.audit_logs(actor_id);
CREATE INDEX IF NOT EXISTS idx_audit_logs_occurred ON public.audit_logs(occurred_at DESC);
