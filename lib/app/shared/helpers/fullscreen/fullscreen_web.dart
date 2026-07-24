// ignore_for_file: avoid_web_libraries_in_flutter

import 'package:web/web.dart' as web;
import 'fullscreen_base.dart';

class FullScreenImpl implements FullScreenBase {
  @override
  void toggle(bool full) {
    try {
      if (full) {
        web.document.documentElement?.requestFullscreen();
      } else {
        if (web.document.fullscreenElement != null) {
          web.document.exitFullscreen();
        }
      }
    } catch (e) {
      // ignore
    }
  }
}


