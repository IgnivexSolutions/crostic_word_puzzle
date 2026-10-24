import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/sound_service.dart';
import '../services/storage_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final SoundService _sound = SoundService();
  final StorageService _storage = StorageService();

  late bool _bgm;
  late bool _sfx;
  late bool _highContrast;
  late bool _dyslexic;
  double _bgmVolume = 0.5;
  double _sfxVolume = 0.8;

  @override
  void initState() {
    super.initState();
    _bgm = _sound.isBgmEnabled;
    _sfx = _sound.isSfxEnabled;
    _bgmVolume = _sound.bgmVolume;
    _sfxVolume = _sound.sfxVolume;
    _highContrast = _storage.getHighContrastSetting();
    _dyslexic = _storage.getDyslexicFontSetting();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F1F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF1E293B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Game Settings',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 18.0,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF0F172A),
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(18.0),
          children: [
            // Audio Section
            Text(
              'AUDIO & MUSIC',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 13.0,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
                color: const Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 8.0),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(color: const Color(0xFFCBD5E1)),
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    title: Text(
                      'Background Music',
                      style: GoogleFonts.spaceGrotesk(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    subtitle: const Text('Gentle ambient study progression loop'),
                    value: _bgm,
                    activeColor: const Color(0xFF0284C7),
                    onChanged: (val) {
                      setState(() => _bgm = val);
                      _sound.toggleBgm(val);
                      _storage.saveBgmSetting(val);
                    },
                  ),
                  if (_bgm)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          const Icon(Icons.volume_down_rounded, color: Color(0xFF64748B), size: 20),
                          Expanded(
                            child: Slider(
                              value: _bgmVolume,
                              min: 0.0,
                              max: 1.0,
                              activeColor: const Color(0xFF0284C7),
                              onChanged: (val) {
                                setState(() => _bgmVolume = val);
                                _sound.setBgmVolume(val);
                              },
                            ),
                          ),
                          const Icon(Icons.volume_up_rounded, color: Color(0xFF64748B), size: 20),
                        ],
                      ),
                    ),
                  const Divider(height: 1.0),
                  SwitchListTile(
                    title: Text(
                      'Sound Effects',
                      style: GoogleFonts.spaceGrotesk(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    subtitle: const Text('Tactile clicks, chimes, and victory fanfares'),
                    value: _sfx,
                    activeColor: const Color(0xFF0284C7),
                    onChanged: (val) {
                      setState(() => _sfx = val);
                      _sound.isSfxEnabled = val;
                      _storage.saveSfxSetting(val);
                    },
                  ),
                  if (_sfx)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          const Icon(Icons.volume_down_rounded, color: Color(0xFF64748B), size: 20),
                          Expanded(
                            child: Slider(
                              value: _sfxVolume,
                              min: 0.0,
                              max: 1.0,
                              activeColor: const Color(0xFF0284C7),
                              onChanged: (val) {
                                setState(() => _sfxVolume = val);
                                _sound.setSfxVolume(val);
                              },
                            ),
                          ),
                          const Icon(Icons.volume_up_rounded, color: Color(0xFF64748B), size: 20),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 24.0),

            // Accessibility Section
            Text(
              'ACCESSIBILITY & LEARNING',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 13.0,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
                color: const Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 8.0),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(color: const Color(0xFFCBD5E1)),
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    title: Text(
                      'High Contrast Tiles',
                      style: GoogleFonts.spaceGrotesk(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    subtitle: const Text('Boost letter number visibility & cell outlines'),
                    value: _highContrast,
                    activeColor: const Color(0xFF0284C7),
                    onChanged: (val) {
                      setState(() => _highContrast = val);
                      _storage.saveHighContrastSetting(val);
                    },
                  ),
                  const Divider(height: 1.0),
                  SwitchListTile(
                    title: Text(
                      'Dyslexia-Friendly Open Typography',
                      style: GoogleFonts.spaceGrotesk(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    subtitle: const Text('Increase character apertures and spacing'),
                    value: _dyslexic,
                    activeColor: const Color(0xFF0284C7),
                    onChanged: (val) {
                      setState(() => _dyslexic = val);
                      _storage.saveDyslexicFontSetting(val);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30.0),

            // App Version & Educational Tag
            Center(
              child: Column(
                children: [
                  Text(
                    'Crostic Cryptogram • Educational Scholar Edition',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    'Version 1.0.0 • Mathematical Cipher Verified',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 11.0,
                      color: const Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
