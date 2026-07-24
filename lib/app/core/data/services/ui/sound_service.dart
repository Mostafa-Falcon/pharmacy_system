import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pharmacy_system/app/shared/ui_core.dart';

enum SoundEffect {
  click,
  itemAdded,
  itemRemoved,
  error,
  saleComplete,
  saleError,
  syncComplete,
}

class SoundService {
  SoundService._();
  static final SoundService instance = SoundService._();

  static const _enabledKey = 'sound_enabled';

  bool _initialized = false;
  bool _enabled = true;
  final _pool = <String, AudioPlayer>{};

  bool get enabled => _enabled;

  set enabled(bool value) {
    _enabled = value;
    SharedPreferences.getInstance().then((p) => p.setBool(_enabledKey, value));
  }

  void initialize() {
    if (_initialized) return;
    _initialized = true;
    SharedPreferences.getInstance().then((p) {
      _enabled = p.getBool(_enabledKey) ?? true;
    });
  }

  void play(SoundEffect effect) {
    if (!_enabled) return;
    final assetPath = _assetPath(effect);
    if (assetPath == null) return;

    try {
      final player = _pool.putIfAbsent(assetPath, () => AudioPlayer());
      player.setAsset(assetPath);
      player.seek(Duration.zero);
      player.play();
    } catch (e, s) {
      safeDebugPrint('SoundService.play($effect) failed: $e\n$s');
    }
  }

  String? _assetPath(SoundEffect effect) {
    switch (effect) {
      case SoundEffect.click:
        return 'assets/sounds/click.wav';
      case SoundEffect.itemAdded:
      case SoundEffect.itemRemoved:
        return 'assets/sounds/item_added.wav';
      case SoundEffect.error:
      case SoundEffect.saleError:
        return 'assets/sounds/error.wav';
      case SoundEffect.saleComplete:
        return 'assets/sounds/cash_drawer.wav';
      case SoundEffect.syncComplete:
        return 'assets/sounds/scan_success.wav';
    }
  }

  void dispose() {
    for (final player in _pool.values) {
      player.dispose();
    }
    _pool.clear();
    _initialized = false;
  }
}
