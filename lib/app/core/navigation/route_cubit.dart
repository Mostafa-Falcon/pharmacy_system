import 'package:flutter_bloc/flutter_bloc.dart';

/// يتتبّع المسار الحالي للتطبيق ليحل محل [Get.currentRoute] المستخدم في
/// تظليل عنصر الشريط الجانبي وتبديل محتوى الشاشة في [HomeShell].
class RouteCubit extends Cubit<String> {
  RouteCubit() : super('/splash');

  void setRoute(String route) {
    if (route != state) emit(route);
  }

  String get currentRoute => state;
}

/// مزوّد عام للمسار الحالي يُسجَّل مرة واحدة في [initInjection].
final routeCubit = RouteCubit();


