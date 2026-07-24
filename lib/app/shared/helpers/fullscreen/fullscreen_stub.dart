import 'fullscreen_base.dart';

class FullScreenImpl implements FullScreenBase {
  @override
  void toggle(bool full) {
    // لا يفعل شيئاً هنا، الـ Bloc سيتعامل مع الـ SystemChrome/windowManager
  }
}


