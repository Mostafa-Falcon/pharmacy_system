// auth_strings.dart — ثوابت المصادقة (تسجيل الدخول/الخروج، التسجيل، الأخطاء)



class AuthStrings {
  AuthStrings._();

  // ─── Auth ───
  static const String loginTitle = 'تسجيل الدخول';
  static const String welcomeBack = 'أهلاً بك مجدداً';
  static const String loginSubtitle = 'سجل دخولك الآن للوصول إلى لوحة التحكم.';
  static const String emailLabel = 'البريد الإلكتروني';
  static const String emailHint = 'name@logixa.com';
  static const String passwordLabel = 'كلمة المرور';
  static const String forgotPassword = 'نسيت كلمة المرور؟';
  static const String loginButton = 'تسجيل الدخول';
  static const String noAccount = 'ليس لديك حساب في النظام؟';
  static const String signupLink = 'إنشاء حساب جديد';
  static const String logout = 'تسجيل الخروج';
  static const String logoutTitle = 'تسجيل خروج من النظام';
  static const String logoutConfirm = 'هل أنت متأكد من رغبتك في تسجيل الخروج الآن؟';
  static const String yesLogout = 'نعم، خروج';
  static const String cancelAndBack = 'إلغاء وتراجع';
  static const String activeAccount = 'حساب نشط';
  static const String emailRequired = 'البريد الإلكتروني مطلوب';
  static const String emailInvalid = 'البريد الإلكتروني غير صحيح';
  static const String passwordRequired = 'كلمة المرور مطلوبة';
  static const String passwordMinLength = 'كلمة المرور يجب أن تكون 8 أحرف على الأقل';
  static const String passwordsNotMatch = 'كلمتا المرور غير متطابقتين';
  static const String nameRequired = 'الاسم مطلوب';
  static const String nameHint = 'د. أحمد محمد كمال';
  static const String emailHintGeneric = 'example@email.com';
  static const String errorLoadingAccount = 'تعذر تحميل بيانات الحساب. حاول مرة أخرى.';
  static const String errorServerConnection = 'تعذر الاتصال بالخادم. تأكد من اتصالك بالإنترنت.';
  static const String errorRegister = 'حدث خطأ أثناء إنشاء الحساب';
  static const String errorServer = 'حدث خطأ من الخادم: ';
  static const String errorGeneral = 'حدث خطأ ما';

  // ─── Auth: Signup ───
  static const String signupTitle = 'إنشاء حساب جديد';
  static const String signupSubtitle = 'أدخل بياناتك لتهيئة بيئة العمل الخاصة بك.';
  static const String fullNameLabel = 'الاسم الكامل';
  static const String confirmPasswordLabel = 'تأكيد كلمة المرور';
  static const String signupButton = 'إنشاء الحساب';
  static const String alreadyHaveAccount = 'لديك حساب بالفعل في النظام؟';
  static const String loginNow = 'سجل دخولك';
  static const String backToLogin = 'العودة لتسجيل الدخول';
  static const String resendLink = 'إرسال الرابط مرة أخرى';
  static const String resetSentTitle = 'تم إرسال رابط إعادة التعيين';
  static const String resetSentSubtitle = 'يرجى فحص بريدك الإلكتروني واتباع الرابط لإعادة تعيين كلمة المرور.';
  static const String resetPasswordTitle = 'استعادة كلمة المرور';
  static const String resetPasswordSubtitle = 'أدخل بريدك الإلكتروني وسنرسل لك رابط إعادة تعيين كلمة المرور.';
  static const String resetPasswordButton = 'إرسال رابط إعادة التعيين';
  static const String forgotPasswordMessage = 'فشل في إرسال رابط إعادة التعيين. تأكد من اتصالك بالإنترنت.';
  static const String validEmailRequired = 'يرجى إدخال بريد إلكتروني صحيح';

  // ─── Auth: Promo ───
  static const String pharmacySystem = 'نظام إدارة الصيدليات الذكي';
  static const String pharmacySystemDesc = 'المنصة الشاملة لإدارة المبيعات والمخازن والتقارير الطبية.';
  static const String appNameSplash = 'نظام الصيدليات';
  static const String appDescSplash = 'المنصة الذكية المتكاملة لإدارة الصيدلية';

  // ─── Auth: Login Errors ───
  static const String loginRequiresInternet = 'تسجيل الدخول يتطلب اتصالاً بالإنترنت.';
  static const String loginInvalidCredentials = 'البريد الإلكتروني أو كلمة المرور غير صحيحة';
  static const String emailNotConfirmed = 'يرجى تأكيد البريد الإلكتروني قبل تسجيل الدخول';
  static const String serverUnavailable = 'خادم المصادقة غير متاح مؤقتاً. حاول مرة أخرى لاحقاً.';
  static const String accountActiveOnOtherDevice = 'الحساب نشط حالياً على جهاز آخر.';
  static const String serverNotAvailable = 'خادم Supabase غير متاح حالياً. حاول لاحقاً.';
  static const String loginFailed = 'تعذر تسجيل الدخول عبر الخادم. تأكد من صحة البيانات.';
  static const String registerRequiresInternet = 'إنشاء حساب جديد يتطلب اتصالاً بالإنترنت.';
  static const String tooManyAttempts = 'محاولات كثيرة جداً. حاول مرة أخرى بعد دقيقة.';
  static const String emailAlreadyRegistered = 'البريد الإلكتروني موجود ومسجل بالفعل';
  static const String registerLocalSuccess = 'تم إنشاء الحساب محلياً (بدون إنترنت). يمكنك تسجيل الدخول لاحقاً.';
  static const String registerLocalProviderDisabled = 'تم إنشاء الحساب محلياً (خادم المصادقة غير مفعّل).';
  static const String registerDisabled = 'تسجيل الحسابات غير مفعّل في Supabase. تم التسجيل محلياً.';
  static const String weakPassword = 'كلمة المرور ضعيفة جداً. استخدم كلمة أطول من 6 أحرف.';
  static const String changePasswordRequiresInternet = 'تغيير كلمة المرور يتطلب اتصالاً بالإنترنت.';
  static const String mustLoginFirst = 'يجب تسجيل الدخول أولاً.';
  static const String emailNotAvailable = 'البريد الإلكتروني غير متوفر.';
  static const String noDataSaved = 'لا توجد بيانات محفوظة.';
  static const String currentPasswordIncorrect = 'كلمة المرور الحالية غير صحيحة.';
  static const String passwordChangedSuccess = 'تم تغيير كلمة المرور بنجاح.';
  static const String resendConfirmRequiresInternet = 'إعادة إرسال رابط التأكيد يتطلب اتصالاً بالإنترنت.';
  static const String resendConfirmFailed = 'تعذر إعادة إرسال رابط التأكيد. حاول مرة أخرى.';
  static const String forceLogoutInternetRequired = 'طرد الجهاز الآخر يتطلب اتصالاً بالإنترنت.';
  static const String remoteLogoutSuccess = 'تم تسجيل خروج الجهاز الآخر بنجاح.';
  static const String remoteLogoutFailed = 'تعذر طرد الجهاز الآخر حالياً.';

  // ─── Auth: Email Confirmation ───
  static const String emailConfirmationTitle = 'تأكيد البريد الإلكتروني';
  static const String emailConfirmationSent = 'تم إنشاء الحساب بنجاح. يرجى التحقق من بريدك الإلكتروني وتأكيد الحساب قبل تسجيل الدخول.';
  static const String emailConfirmationCheck = 'تحقق من البريد الإلكتروني';
  static const String emailConfirmationDesc = 'لقد أرسلنا رابط تأكيد إلى بريدك الإلكتروني. يرجى فتح الرابط لتفعيل الحساب.';
  static const String emailConfirmationResend = 'إعادة إرسال رابط التأكيد';
  static const String emailConfirmationResendSent = 'تم إعادة إرسال رابط التأكيد. يرجى التحقق من بريدك الإلكتروني.';
  static const String emailConfirmationDidntReceive = 'لم يصلك الرابط؟';
}
