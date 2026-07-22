-- ═══════════════════════════════════════════════════════════════
-- Harden Production RLS — fix leftovers from earlier migrations
-- ═══════════════════════════════════════════════════════════════
--
-- الثغرات المُعالَجة (مكتشفة عبر فحص pg_policies الحي):
--   1) customer_suppliers لا يزال "Authenticated full access" (أي مستخدم مصادق
--      يقرأ/يعدّل/يحذف كل السجلات في كل الفروع).
--   2) users لا يزال فيه users_select_any / users_update_any / users_delete_any
--      المفتوحة (auth.role()='authenticated') → تصعيد صلاحيات كامل.
--   3) customers / suppliers / customer_groups محمية بـ current_user_is_active()
--      فقط (بلا تقييد فرع) و with_check = is_active فقط → أي موظف يعدّل أي سجل
--      بأي فرع. نوحّدها مع باقي الجداول على current_user_can_access_branch.
--
-- ملاحظة: التطبيق (Dart) يملأ branch_id = AuthService.currentBranchId عند الحفظ،
-- لذا تشديد القراءة/الكتابة حسب الفرع لا يكسر العمليات الطبيعية.
-- ═══════════════════════════════════════════════════════════════

-- ─── 1) customer_suppliers ─────────────────────────────────────
DROP POLICY IF EXISTS "Authenticated full access" ON public.customer_suppliers;
DROP POLICY IF EXISTS "Users access customer_suppliers" ON public.customer_suppliers;

CREATE POLICY "Users access customer_suppliers" ON public.customer_suppliers
  FOR ALL
  USING (current_user_can_access_branch(branch_id))
  WITH CHECK (current_user_can_access_branch(branch_id));

-- ─── 2) users — إسقاط السياسات المفتوحة الباقية ──────────────────
DROP POLICY IF EXISTS "users_select_any" ON public.users;
DROP POLICY IF EXISTS "users_update_any" ON public.users;
DROP POLICY IF EXISTS "users_delete_any" ON public.users;

-- إعادة إنشاء سياسات users المقيدة (متسقة مع 202607190001)
DROP POLICY IF EXISTS "Users access users" ON public.users;
CREATE POLICY "Users access users" ON public.users
  FOR SELECT USING (current_user_is_active());

DROP POLICY IF EXISTS "Users modify users" ON public.users;
CREATE POLICY "Users modify users" ON public.users
  FOR INSERT WITH CHECK (current_user_is_owner_or_admin());

DROP POLICY IF EXISTS "Users modify users update" ON public.users;
CREATE POLICY "Users modify users update" ON public.users
  FOR UPDATE USING (current_user_is_active())
  WITH CHECK (current_user_is_owner_or_admin());

-- منع الحذف المباشر — الـ app يستخدم soft-delete (is_deleted = true) فقط
DROP POLICY IF EXISTS "Users delete users" ON public.users;
CREATE POLICY "Users delete users" ON public.users
  FOR DELETE USING (current_user_is_owner_or_admin());

-- ─── 3) customers / suppliers / customer_groups — تقييد بالفرع ──
DROP POLICY IF EXISTS "Users access customers" ON public.customers;
CREATE POLICY "Users access customers" ON public.customers
  FOR ALL
  USING (current_user_can_access_branch(branch_id))
  WITH CHECK (current_user_can_access_branch(branch_id));

DROP POLICY IF EXISTS "Users access suppliers" ON public.suppliers;
CREATE POLICY "Users access suppliers" ON public.suppliers
  FOR ALL
  USING (current_user_can_access_branch(branch_id))
  WITH CHECK (current_user_can_access_branch(branch_id));

-- customer_groups ليس له عمود branch_id (إعدادات عامة)؛ نقيّده بصلاحية
-- المالك/الأدمن للكتابة وقراءة لأي مستخدم نشط (متسق مع branches/permissions).
DROP POLICY IF EXISTS "Users access customer_groups" ON public.customer_groups;
CREATE POLICY "Users access customer_groups" ON public.customer_groups
  FOR SELECT USING (current_user_is_active());

DROP POLICY IF EXISTS "Users modify customer_groups" ON public.customer_groups;
CREATE POLICY "Users modify customer_groups" ON public.customer_groups
  FOR INSERT WITH CHECK (current_user_is_owner_or_admin());

DROP POLICY IF EXISTS "Users modify customer_groups update" ON public.customer_groups;
CREATE POLICY "Users modify customer_groups update" ON public.customer_groups
  FOR UPDATE USING (current_user_is_active())
  WITH CHECK (current_user_is_owner_or_admin());

DROP POLICY IF EXISTS "Users delete customer_groups" ON public.customer_groups;
CREATE POLICY "Users delete customer_groups" ON public.customer_groups
  FOR DELETE USING (current_user_is_owner_or_admin());

-- ─── 4) release_session_lock — منع فتح قفل أي مستخدم عبر '__any__' ─
-- الدالة SECURITY DEFINER؛ السماح بـ '__any__' (إطلاق قسري) للـ owner/admin فقط،
-- وأي مستخدم يقدر يطلق قفله الخاص فقط. يمنع تصعيد/تلاعب بالجلسات.
CREATE OR REPLACE FUNCTION public.release_session_lock(p_user_id text, p_device_id text)
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
BEGIN
  IF p_device_id = '__any__' THEN
    -- إطلاق قسري: يقتصر على الـ owner/admin
    IF NOT current_user_is_owner_or_admin() THEN
      RAISE EXCEPTION 'not authorized to force-release session lock';
    END IF;
    UPDATE public.users SET active_device_id = NULL WHERE id::text = p_user_id;
  ELSE
    -- المستخدم يطلق قفله الخاص فقط
    UPDATE public.users SET active_device_id = NULL
    WHERE id::text = p_user_id AND active_device_id = p_device_id;
  END IF;
END;
$function$;
