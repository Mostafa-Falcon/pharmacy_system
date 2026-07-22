-- ═════════════════════════════════════════════════════════════
-- FIX: RLS recursion (stack depth limit exceeded / error 54001)
-- ═════════════════════════════════════════════════════════════
--
-- المشكلة: الدوال current_user_can_access_branch / current_user_is_active /
-- current_user_is_owner_or_admin كانت تستعلم من public.users، والجدول ده
-- عليه سياسات RLS بتستدعي نفس الدوال → سلسلة لا نهائية
-- (recursion) → كل عمليات القراءة/الكتابة بتفشل بـ 54001 stack depth limit.
-- ده كان السبب الجذري لعدم وصول أي بيانات (أدوية/عمليات) لـ Supabase.
--
-- الحل: نعيد تعريف الدوال الثلاثة كـ SECURITY DEFINER، فالاستعلام الداخلي
-- على public.users بيتنفّذ بصلاحيات المالك (يمرّ فوق RLS) → بيتجنّب
-- التكرار تماماً، ويبقى الفحص الأمني سليم (مبني على auth.uid() الحقيقي).
-- ═════════════════════════════════════════════════════════════

CREATE OR REPLACE FUNCTION public.current_user_is_active()
 RETURNS boolean
 LANGUAGE plpgsql
 STABLE
 SECURITY DEFINER
 SET search_path = public
AS $function$
BEGIN
  RETURN EXISTS (
    SELECT 1
    FROM public.users
    WHERE id = auth.uid()::text
      AND is_deleted = false
  );
END;
$function$;

CREATE OR REPLACE FUNCTION public.current_user_can_access_branch(p_branch_id text)
 RETURNS boolean
 LANGUAGE plpgsql
 STABLE
 SECURITY DEFINER
 SET search_path = public
AS $function$
BEGIN
  RETURN EXISTS (
    SELECT 1
    FROM public.users
    WHERE id = auth.uid()::text
      AND is_deleted = false
      AND (
        role = 'owner'
        OR assigned_branch_id = p_branch_id
      )
  );
END;
$function$;

CREATE OR REPLACE FUNCTION public.current_user_is_owner_or_admin()
 RETURNS boolean
 LANGUAGE plpgsql
 STABLE
 SECURITY DEFINER
 SET search_path = public
AS $function$
BEGIN
  RETURN EXISTS (
    SELECT 1
    FROM public.users
    WHERE id = auth.uid()::text
      AND is_deleted = false
      AND role IN ('owner', 'admin')
  );
END;
$function$;
