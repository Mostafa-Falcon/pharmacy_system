import 'package:just_audio/just_audio.dart';
import 'package:pharmacy_system/app/core/injection.dart';
import 'package:pharmacy_system/app/shared/ui_core.dart';
import 'package:pharmacy_system/app/core/data/database/daos/system_dao.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_assets.dart';

enum SoundEffect {
  scanSuccess,
  cashDrawer,
  error,
  itemAdded,
  itemRemoved,
  click,
  saleComplete,
  saleError,
  purchaseComplete,
  returnComplete,
  syncComplete,
  notification,
}

class SoundService {
  SoundService._();
  static final SoundService instance = SoundService._();

  final Map<SoundEffect, AudioPlayer> _players = {};
  bool _enabled = true;
  double _volume = 0.7;

  bool get enabled => _enabled;
  set enabled(bool value) {
    _enabled = value;
    _savePrefs();
  }

  double get volume => _volume;
  set volume(double value) {
    _volume = value.clamp(0.0, 1.0);
    _applyVolumeToAll();
    _savePrefs();
  }

  static const _soundPaths = {
    SoundEffect.scanSuccess: AppAssets.scanSuccess,
    SoundEffect.cashDrawer: AppAssets.cashDrawer,
    SoundEffect.error: AppAssets.error,
    SoundEffect.itemAdded: AppAssets.itemAdded,
    SoundEffect.itemRemoved: AppAssets.click,
    SoundEffect.click: AppAssets.click,
    SoundEffect.saleComplete: AppAssets.cashDrawer,
    SoundEffect.saleError: AppAssets.error,
    SoundEffect.purchaseComplete: AppAssets.itemAdded,
    SoundEffect.returnComplete: AppAssets.itemAdded,
    SoundEffect.syncComplete: AppAssets.scanSuccess,
    SoundEffect.notification: AppAssets.scanSuccess,
  };

  Future<void> initialize() async {
    await _loadPrefs();
  }

  Future<void> _loadPlayer(SoundEffect effect) async {
    if (_players.containsKey(effect)) return;
    final player = AudioPlayer();
    try {
      await player.setAsset(_soundPaths[effect]!);
      await player.setVolume(_volume);
      _players[effect] = player;
    } catch (_) {
      await player.dispose();
    }
  }

  Future<void> play(SoundEffect effect) async {
    if (!_enabled) return;

    await _loadPlayer(effect);

    final player = _players[effect];
    if (player == null) return;

    try {
      if (player.playing) {
        await player.stop();
      }
      await player.setVolume(_volume);
      await player.seek(Duration.zero);
      player.play();
    } catch (e, s) {
      safeDebugPrint('SoundService.play failed: $e\n$s');
    }
  }

  void _applyVolumeToAll() {
    for (final player in _players.values) {
      try {
        player.setVolume(_volume);
      } catch (e, s) {
        safeDebugPrint('SoundService._applyVolumeToAll failed: $e\n$s');
      }
    }
  }

  Future<void> _loadPrefs() async {
    try {
      final dao = sl<AppSettingsDao>();
      final enabledData = await dao.get('sound_enabled');
      _enabled = enabledData?.value == 'true';
      final volumeData = await dao.get('sound_volume');
      _volume = double.tryParse(volumeData?.value ?? '') ?? 0.7;
    } catch (e, s) {
      safeDebugPrint('SoundService._loadPrefs failed: $e\n$s');
    }
  }

  void _savePrefs() {
    try {
      final dao = sl<AppSettingsDao>();
      dao.set('sound_enabled', _enabled.toString());
      dao.set('sound_volume', _volume.toString());
    } catch (e, s) {
      safeDebugPrint('SoundService._savePrefs failed: $e\n$s');
    }
  }

  Future<void> dispose() async {
    for (final player in _players.values) {
      try {
        await player.dispose();
      } catch (e, s) {
        safeDebugPrint('SoundService.dispose player failed: $e\n$s');
      }
    }
    _players.clear();
  }
}

