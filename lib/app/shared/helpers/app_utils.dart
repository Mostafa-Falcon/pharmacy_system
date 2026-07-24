import 'package:flutter/foundation.dart';

void safeDebugPrint(Object? object) {
  if (!kReleaseMode) debugPrint(object?.toString());
}


