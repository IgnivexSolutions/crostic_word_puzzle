import 'package:audioplayers/audioplayers.dart';

class SoundService {
  static final SoundService _instance = SoundService._internal();
  factory SoundService() => _instance;
  SoundService._internal();

  final AudioPlayer _bgmPlayer = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();

  bool isBgmEnabled = true;
  bool isSfxEnabled = true;
  double bgmVolume = 0.5;
  double sfxVolume = 0.8;
  bool _isBgmPlaying = false;

  Future<void> init() async {
    try {
      await _bgmPlayer.setReleaseMode(ReleaseMode.loop);
      await _bgmPlayer.setVolume(bgmVolume);
      await _sfxPlayer.setVolume(sfxVolume);
      if (isBgmEnabled) {
        await startBgm();
      }
    } catch (e) {
      // Graceful fallback for non-audio testing environments
    }
  }

  Future<void> startBgm() async {
    if (!isBgmEnabled || _isBgmPlaying) return;
    try {
      await _bgmPlayer.play(AssetSource('audio/bgm_loop.wav'));
      _isBgmPlaying = true;
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
    try {
      await _sfxPlayer.setVolume(sfxVolume);
    } catch (_) {}
  }

  Future<void> playKeyTap() async {
    if (!isSfxEnabled) return;
    try {
      final player = AudioPlayer();
      await player.setVolume(sfxVolume * 0.7);
      await player.play(AssetSource('audio/key_tap.wav'));
      player.onPlayerComplete.listen((_) => player.dispose());
    } catch (_) {}
  }

  Future<void> playLetterReveal() async {
    if (!isSfxEnabled) return;
    try {
      final player = AudioPlayer();
      await player.setVolume(sfxVolume);
      await player.play(AssetSource('audio/letter_reveal.wav'));
      player.onPlayerComplete.listen((_) => player.dispose());
    } catch (_) {}
  }

  Future<void> playWordComplete() async {
    if (!isSfxEnabled) return;
    try {
      final player = AudioPlayer();
      await player.setVolume(sfxVolume);
      await player.play(AssetSource('audio/word_complete.wav'));
      player.onPlayerComplete.listen((_) => player.dispose());
    } catch (_) {}
  }

  Future<void> playError() async {
    if (!isSfxEnabled) return;
    try {
      final player = AudioPlayer();
      await player.setVolume(sfxVolume * 0.8);
      await player.play(AssetSource('audio/error.wav'));
      player.onPlayerComplete.listen((_) => player.dispose());
    } catch (_) {}
  }

  Future<void> playHint() async {
    if (!isSfxEnabled) return;
    try {
      final player = AudioPlayer();
      await player.setVolume(sfxVolume);
      await player.play(AssetSource('audio/hint.wav'));
      player.onPlayerComplete.listen((_) => player.dispose());
    } catch (_) {}
  }

  Future<void> playVictory() async {
    if (!isSfxEnabled) return;
    try {
      final player = AudioPlayer();
      await player.setVolume(sfxVolume);
      await player.play(AssetSource('audio/level_victory.wav'));
      player.onPlayerComplete.listen((_) => player.dispose());
    } catch (_) {}
  }

  void dispose() {
    _bgmPlayer.dispose();
    _sfxPlayer.dispose();
  }
}
