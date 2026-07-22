import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:sentry_flutter/sentry_flutter.dart';

const _dsn = String.fromEnvironment('SENTRY_DSN');

Future<void> initSentry() async {
  if (_dsn.isEmpty) return;
  await Sentry.init(
    (options) {
      options.dsn = _dsn;
      options.environment = kReleaseMode ? 'production' : 'development';
    },
  );
}
