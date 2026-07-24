import 'fullscreen_stub.dart'
    if (dart.library.html) 'fullscreen_web.dart';

class FullScreenUtils {
  static void toggle(bool full) {
    FullScreenImpl().toggle(full);
  }
}


