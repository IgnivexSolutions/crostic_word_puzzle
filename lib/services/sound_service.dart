import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'storage_service.dart';

class SoundService {
  static final SoundService _instance = SoundService._internal();
  factory SoundService() => _instance;
  SoundService._internal();

  // Dedicated AudioPlayer instances for each sound event to prevent race conditions & cutoffs
  final AudioPlayer _bgmPlayer = AudioPlayer();
  final AudioPlayer _tapPlayer = AudioPlayer();
  final AudioPlayer _revealPlayer = AudioPlayer();
  final AudioPlayer _wordPlayer = AudioPlayer();
  final AudioPlayer _errorPlayer = AudioPlayer();
  final AudioPlayer _hintPlayer = AudioPlayer();
  final AudioPlayer _victoryPlayer = AudioPlayer();

  bool isBgmEnabled = true;
  bool isSfxEnabled = true;
  double bgmVolume = 0.85;
  double sfxVolume = 1.0;
  bool _isBgmPlaying = false;

  Future<void> init() async {
    // 1. Load preferences
    final storage = StorageService();
    await storage.init();
    isBgmEnabled = storage.getBgmSetting();
    isSfxEnabled = storage.getSfxSetting();

    // 2. Configure global audio context for Android sonification
    try {
      await AudioPlayer.global.setAudioContext(AudioContext(
        android: const AudioContextAndroid(
          isSpeakerphoneOn: false,
          stayAwake: false,
          contentType: AndroidContentType.sonification,
          usageType: AndroidUsageType.game,
          audioFocus: AndroidAudioFocus.gainTransientMayDuck,
        ),
      ));
    } catch (_) {}

    // 3. Configure individual player release modes
    try {
      await _bgmPlayer.setReleaseMode(ReleaseMode.loop);
      await _tapPlayer.setReleaseMode(ReleaseMode.stop);
      await _revealPlayer.setReleaseMode(ReleaseMode.stop);
      await _wordPlayer.setReleaseMode(ReleaseMode.stop);
      await _errorPlayer.setReleaseMode(ReleaseMode.stop);
      await _hintPlayer.setReleaseMode(ReleaseMode.stop);
      await _victoryPlayer.setReleaseMode(ReleaseMode.stop);
    } catch (_) {}

    if (isBgmEnabled) {
      await startBgm();
    }
  }

  Future<void> startBgm() async {
    if (!isBgmEnabled || _isBgmPlaying) return;
    try {
      await _bgmPlayer.setReleaseMode(ReleaseMode.loop);
      await _bgmPlayer.setVolume(bgmVolume);
      await _bgmPlayer.play(AssetSource('audio/bgm_loop.wav'));
      _isBgmPlaying = true;
    } catch (_) {
      try {
        await _bgmPlayer.play(AssetSource('assets/audio/bgm_loop.wav'));
        _isBgmPlaying = true;
      } catch (_) {}
    }
  }

  Future<void> stopBgm() async {
    try {
      await _bgmPlayer.stop();
      _isBgmPlaying = false;
    } catch (_) {}
  }

  Future<void> toggleBgm(bool enabled) async {
    isBgmEnabled = enabled;
    if (enabled) {
      await startBgm();
    } else {
      await stopBgm();
    }
  }

  Future<void> setBgmVolume(double volume) async {
    bgmVolume = volume.clamp(0.0, 1.0);
    try {
      await _bgmPlayer.setVolume(bgmVolume);
    } catch (_) {}
  }

  Future<void> setSfxVolume(double volume) async {
    sfxVolume = volume.clamp(0.0, 1.0);
  }

  Future<void> _safePlay(AudioPlayer player, String fileName, {bool isLowLatency = false}) async {
    if (!isSfxEnabled) return;
    try {
      await player.stop();
      await player.setVolume(sfxVolume);
      await player.play(
        AssetSource('audio/$fileName'),
        mode: isLowLatency ? PlayerMode.lowLatency : PlayerMode.mediaPlayer,
      );
    } catch (_) {
      try {
        await player.play(AssetSource('audio/$fileName'), mode: PlayerMode.mediaPlayer);
      } catch (_) {
        try {
          await player.play(AssetSource('assets/audio/$fileName'));
        } catch (_) {}
      }
    }
  }

  Future<void> playKeyTap() async {
    try {
      HapticFeedback.lightImpact();
    } catch (_) {}
    await _safePlay(_tapPlayer, 'key_tap.wav', isLowLatency: true);
  }

  Future<void> playLetterReveal() async {
    try {
      HapticFeedback.lightImpact();
    } catch (_) {}
    await _safePlay(_revealPlayer, 'letter_reveal.wav', isLowLatency: true);
  }

  Future<void> playWordComplete() async {
    try {
      HapticFeedback.mediumImpact();
    } catch (_) {}
    await _safePlay(_wordPlayer, 'word_complete.wav', isLowLatency: false);
  }

  Future<void> playError() async {
    try {
      HapticFeedback.heavyImpact();
    } catch (_) {}
    await _safePlay(_errorPlayer, 'error.wav', isLowLatency: true);
  }

  Future<void> playHint() async {
    try {
      HapticFeedback.mediumImpact();
    } catch (_) {}
    await _safePlay(_hintPlayer, 'hint.wav', isLowLatency: false);
  }

  Future<void> playVictory() async {
    try {
      HapticFeedback.heavyImpact();
    } catch (_) {}
    await _safePlay(_victoryPlayer, 'level_victory.wav', isLowLatency: false);
  }

  void dispose() {
    _bgmPlayer.dispose();
    _tapPlayer.dispose();
    _revealPlayer.dispose();
    _wordPlayer.dispose();
    _errorPlayer.dispose();
    _hintPlayer.dispose();
    _victoryPlayer.dispose();
  }
}
