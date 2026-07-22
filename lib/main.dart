import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toastification/toastification.dart';
import 'package:window_manager/window_manager.dart';

import 'package:pharmacy_system/app/core/bloc/app_cubit.dart';
import 'package:pharmacy_system/app/core/bloc/app_bloc_observer.dart';
import 'app/modules/auth/bloc/auth_bloc.dart';
import 'app/modules/layout/bloc/shell_bloc.dart';
import 'app/modules/notifications/bloc/notifications_bloc.dart';
import 'package:pharmacy_system/app/core/config/app_config.dart';
import 'package:pharmacy_system/app/core/data/services/theme_service.dart';
import 'package:pharmacy_system/app/core/injection.dart';
import 'package:pharmacy_system/app/core/data/services/sync/sync_engine.dart';
import 'package:pharmacy_system/app/core/data/services/sync/supabase_client.dart';
import 'package:pharmacy_system/app/core/data/services/auth/auth_service.dart';
import 'package:pharmacy_system/app/core/data/database/drift_init.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_theme.dart';
import 'package:pharmacy_system/app/core/data/services/sound_service.dart';
import 'app/routes/app_router.dart';
import 'package:pharmacy_system/app/core/bootstrap/sentry_init.dart';
import 'package:pharmacy_system/app/core/bootstrap/web_runtime_assets.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = AppBlocObserver();

  // 1. تحميل الإعدادات أول حاجة عشان الكل يشوفها
  await AppConfig.load();

  // 2. تهيئة الخدمات الأساسية
  await initSentry();
  await validateWebRuntimeAssets();
  await initDrift();

  if (ThemeService.instance.isDesktop) {
    await windowManager.ensureInitialized();
  }

  await Future.wait([
    initSupabase(),
    initInjection(),
  ]);
  await Future.wait([
    AuthService.init(),
    ThemeService.instance.init(),
  ]);
  // Sound service يبدأ في الخلفية — متحملش كل الأصوات دلوقتي
  SoundService.instance.initialize();
  SyncEngine.instance.initialize();

  runApp(const PharmacyApp());
}

class PharmacyApp extends StatelessWidget {
  const PharmacyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AppCubit()..initialize()),
        BlocProvider.value(value: sl<AuthBloc>()),
        BlocProvider.value(value: sl<NotificationsBloc>()),
        BlocProvider.value(value: sl<ShellBloc>()),
      ],
      child: const _PharmacyAppView(),
    );
  }
}

class _PharmacyAppView extends StatelessWidget {
  const _PharmacyAppView();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        return ScreenUtilInit(
          // استخدام حجم تصميم ثابت للديسكتوب والموبايل لضمان عمل الـ Scaling (التكبير والتصغير)
          // عند تغيير حجم النافذة، المكتبة هتحسب النسبة وتكبر العناصر تلقائياً
          designSize: const Size(1440, 900),
          minTextAdapt: true,
          splitScreenMode: true,
          useInheritedMediaQuery: true,
          builder: (context, child) {
            return MaterialApp.router(
              key: ValueKey(ThemeService.instance.currentThemeMode),
              title: 'نظام الصيدلية',
              debugShowCheckedModeBanner: false,
              scrollBehavior: const ScrollBehavior().copyWith(
                overscroll: false,
              ),
              theme: AppTheme.light,
              darkTheme: AppTheme.dark,
              themeMode: ThemeService.instance.currentThemeMode,
              routerConfig: AppRouter.router,
              builder: (context, child) {
                return ToastificationWrapper(
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: child ?? const SizedBox.shrink(),
                  ),
                );
              },
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [Locale('ar')],
            );
          },
        );
      },
    );
  }
}
