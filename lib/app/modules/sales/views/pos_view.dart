import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/injection.dart';
import '../bloc/pos_bloc.dart';
import '../bloc/catalog_cubit.dart';
import '../bloc/cart_cubit.dart';
import 'pos_nav_drawer.dart';
import 'desktop_pos/layout.dart';
import 'mobile_pos/layout.dart';
import 'open_shift_view.dart';
import 'package:pharmacy_system/app/core/presentation/widgets/index.dart';

class PosView extends StatelessWidget {
  const PosView({super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<PosBloc>()..add(const PosInitialize()),
        ),
        BlocProvider(
          create: (context) => sl<CatalogCubit>()..initialize(),
        ),
        BlocProvider(
          create: (context) => sl<CartCubit>(),
        ),
      ],
      child: BlocBuilder<PosBloc, PosState>(
        builder: (context, state) {
          // إذا كان هناك تحميل للبيانات الأساسية (مثل الكتالوج)
          if (state.isLoading && state.medicines.isEmpty) {
            return const Center(child: LoadingIndicator());
          }

          final content = Stack(
            children: [
              // الطبقة الأولى: واجهة الكاشير الأساسية
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth > 950) {
                    return DesktopLayout(scaffoldKey: scaffoldKey);
                  }
                  return const MobileLayout();
                },
              ),

              // الطبقة الثانية: شاشة فتح الوردية
              // تظهر فقط إذا انتهى التحميل ولم يتم العثور على وردية مفتوحة
              if (!state.isLoading && state.currentShift == null)
                const Positioned.fill(
                  child: OpenShiftView(isOverlay: true),
                ),
            ],
          );

          // في وضع ملء الشاشة نلغي SafeArea لإعطاء مساحة أكبر
          return Scaffold(
            key: scaffoldKey,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            drawer: state.isFullScreen ? null : const PosNavDrawer(),
            body: state.isFullScreen 
                ? content 
                : SafeArea(child: content),
          );
        },
      ),
    );
  }
}
