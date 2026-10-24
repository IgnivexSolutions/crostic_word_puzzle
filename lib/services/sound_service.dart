import 'dart:typed_data';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

class SoundService {
  static final SoundService _instance = SoundService._internal();
  factory SoundService() => _instance;
  SoundService._internal();

  final AudioPlayer _player = AudioPlayer();
  final AudioPlayer _bgmPlayer = AudioPlayer();

  bool isBgmEnabled = true;
  bool isSfxEnabled = true;
  double bgmVolume = 0.4;
  double sfxVolume = 1.0;
  bool _isBgmPlaying = false;

  // Cached sound bytes for instantaneous Android playback
  Uint8List? _tapBytes;
  Uint8List? _revealBytes;
  Uint8List? _wordBytes;
  Uint8List? _errorBytes;
  Uint8List? _hintBytes;
  Uint8List? _victoryBytes;
  Uint8List? _bgmBytes;

  Future<void> init() async {
    try {
      // Configure audio context for optimal Android low-latency gameplay
      await AudioPlayer.global.setAudioContext(AudioContext(
        android: const AudioContextAndroid(
          isSpeakerphoneOn: false,
          stayAwake: false,
          contentType: AndroidContentType.sonification,
          usageType: AndroidUsageType.game,
          audioFocus: AndroidAudioFocus.gainTransientMayDuck,
        ),
      ));

      await _player.setReleaseMode(ReleaseMode.stop);
      await _bgmPlayer.setReleaseMode(ReleaseMode.loop);

      // Pre-load all sound bytes into memory from Flutter assets
      _tapBytes = (await rootBundle.load('assets/audio/key_tap.wav')).buffer.asUint8List();
      _revealBytes = (await rootBundle.load('assets/audio/letter_reveal.wav')).buffer.asUint8List();
      _wordBytes = (await rootBundle.load('assets/audio/word_complete.wav')).buffer.asUint8List();
      _errorBytes = (await rootBundle.load('assets/audio/error.wav')).buffer.asUint8List();
      _hintBytes = (await rootBundle.load('assets/audio/hint.wav')).buffer.asUint8List();
      _victoryBytes = (await rootBundle.load('assets/audio/level_victory.wav')).buffer.asUint8List();
      _bgmBytes = (await rootBundle.load('assets/audio/bgm_loop.wav')).buffer.asUint8List();

      if (isBgmEnabled) {
        await startBgm();
      }
    } catch (e) {
      // Audio fallback
    }
  }

  Future<void> startBgm() async {
    if (!isBgmEnabled || _isBgmPlaying) return;
    try {
      if (_bgmBytes != null) {
        await _bgmPlayer.setVolume(bgmVolume);
        await _bgmPlayer.play(BytesSource(_bgmBytes!));
        _isBgmPlaying = true;
      }
    } catch (_) {}
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

  Future<void> _playSfx(Uint8List? bytes, {bool vibrateOnKey = false}) async {
    if (!isSfxEnabled) return;

    // Haptic feedback ensures tactile response even if system volume is muted
    if (vibrateOnKey) {
      try {
        HapticFeedback.lightImpact();
      } catch (_) {}
    }

    if (bytes == null) return;

    try {
      await _player.stop();
      await _player.setVolume(sfxVolume);
      await _player.play(BytesSource(bytes), mode: PlayerMode.lowLatency);
    } catch (_) {
      try {
        await _player.play(BytesSource(bytes));
      } catch (_) {}
    }
  }

  Future<void> playKeyTap() async {
    await _playSfx(_tapBytes, vibrateOnKey: true);
  }

  Future<void> playLetterReveal() async {
    await _playSfx(_revealBytes, vibrateOnKey: true);
  }

  Future<void> playWordComplete() async {
    try {
      HapticFeedback.mediumImpact();
    } catch (_) {}
    await _playSfx(_wordBytes);
  }

  Future<void> playError() async {
    try {
      HapticFeedback.heavyImpact();
    } catch (_) {}
    await _playSfx(_errorBytes);
  }

  Future<void> playHint() async {
    await _playSfx(_hintBytes);
  }

  Future<void> playVictory() async {
    try {
      HapticFeedback.heavyImpact();
    } catch (_) {}
    await _playSfx(_victoryBytes);
  }

  void dispose() {
    _bgmPlayer.dispose();
    _player.dispose();
  }
}
