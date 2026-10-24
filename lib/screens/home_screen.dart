import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/levels_dataset.dart';
import '../models/user_account.dart';
import '../services/sound_service.dart';
import '../services/storage_service.dart';
import 'gameplay_screen.dart';
import 'category_levels_screen.dart';
import 'level_map_screen.dart';
import 'vocabulary_book_screen.dart';
import 'account_sync_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final StorageService _storage = StorageService();
  final SoundService _sound = SoundService();
  UserAccount? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final user = await _storage.loadUserAccount();
    setState(() {
      _user = user;
      _isLoading = false;
    });
  }

  void _openLevel(int levelId) {
    if (_user == null) return;
    _sound.playKeyTap();
    final level = LevelRepository().getLevel(levelId);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (c) => GameplayScreen(
          level: level,
          user: _user!,
          onLevelCompleted: () {
            _loadData();
          },
        ),
      ),
    );
  }

  void _openLevelMap() {
    if (_user == null) return;
    _sound.playKeyTap();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (c) => LevelMapScreen(
          user: _user!,
          onUserUpdated: (u) => setState(() => _user = u),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _user == null) {
      return const Scaffold(
        backgroundColor: Color(0xFFE8F1F5),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Find next playable level
    final currentLvlId = _user!.unlockedLevels.last;

    return Scaffold(
      backgroundColor: const Color(0xFFE8F1F5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar: Profile avatar & Coins counter
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      _sound.playKeyTap();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (c) => AccountSyncScreen(
                            user: _user!,
                            onUserUpdated: (u) => setState(() => _user = u),
                          ),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: const Color(0xFFBAE6FD),
                          child: Text(
                            _user!.displayName.isNotEmpty ? _user!.displayName[0].toUpperCase() : 'S',
                            style: GoogleFonts.spaceGrotesk(
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF0369A1),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _user!.displayName,
                              style: GoogleFonts.spaceGrotesk(fontSize: 14.0, fontWeight: FontWeight.w700),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.sync_rounded, color: Color(0xFF059669), size: 12),
                                const SizedBox(width: 2.0),
                                Text(
                                  _user!.syncCode,
                                  style: GoogleFonts.jetBrainsMono(
                                    fontSize: 11.0,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF059669),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Coins Counter & Settings
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.0),
                          border: Border.all(color: const Color(0xFFCBD5E1)),
                        ),
                        child: Row(
                          children: [
                            const Text('🪙', style: TextStyle(fontSize: 14)),
                            const SizedBox(width: 4.0),
                            Text(
                              '${_user!.coins}',
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 13.0,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF0F172A),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      IconButton(
                        icon: const Icon(Icons.settings_rounded, color: Color(0xFF64748B)),
                        onPressed: () {
                          _sound.playKeyTap();
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (c) => const SettingsScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20.0),

              // Title Header
              Text(
                'Crostic Cryptograms',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 28.0,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0F172A),
                  letterSpacing: -0.5,
                ),
              ),
              Text(
                'Decode historical quotes & master advanced vocabulary',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF64748B),
                ),
              ),

              const SizedBox(height: 20.0),

              // Main Play Card (Continues directly into Level 1 or current)
              GestureDetector(
                onTap: () => _openLevel(currentLvlId),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22.0),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0284C7), Color(0xFF0369A1)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(22.0),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0284C7).withOpacity(0.35),
                        blurRadius: 14.0,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Text(
                          'FEATURED PUZZLE • LEVEL $currentLvlId',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      Text(
                        'Declaration of Independence',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 22.0,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'History • 8 Clues • Thomas Jefferson (1776)',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13.0,
                          color: Colors.white.withOpacity(0.85),
                        ),
                      ),
                      const SizedBox(height: 18.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.star_rounded, color: Color(0xFFFBBF24), size: 22),
                              Icon(Icons.star_rounded, color: Color(0xFFFBBF24), size: 22),
                              Icon(Icons.star_rounded, color: Color(0xFFFBBF24), size: 22),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 6.0,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Text(
                                  'Play Level',
                                  style: GoogleFonts.spaceGrotesk(
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFF0369A1),
                                  ),
                                ),
                                const SizedBox(width: 6.0),
                                const Icon(Icons.play_arrow_rounded, color: Color(0xFF0369A1)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 18.0),

              // Action Tiles Grid
              Row(
                children: [
                  // Level Map Quest Path (Matching User's screenshot)
                  Expanded(
                    child: GestureDetector(
                      onTap: _openLevelMap,
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18.0),
                          border: Border.all(color: const Color(0xFF0284C7), width: 1.5),
                          boxShadow: [
                            BoxShadow(color: const Color(0xFF0284C7).withOpacity(0.08), blurRadius: 8.0, offset: const Offset(0, 3)),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE0F2FE),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: const Icon(Icons.alt_route_rounded, color: Color(0xFF0284C7)),
                            ),
                            const SizedBox(height: 12.0),
                            Text(
                              'Level Map',
                              style: GoogleFonts.spaceGrotesk(fontSize: 16.0, fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(height: 2.0),
                            Text(
                              '1,000 Verified Levels',
                              style: GoogleFonts.plusJakartaSans(fontSize: 12.0, color: const Color(0xFF0284C7), fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14.0),

                  // Student Lexicon / Vocabulary Book
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        _sound.playKeyTap();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (c) => VocabularyBookScreen(user: _user!),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18.0),
                          border: Border.all(color: const Color(0xFFCBD5E1)),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6.0, offset: const Offset(0, 2)),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: const Color(0xFFECFDF5),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: const Icon(Icons.auto_stories_rounded, color: Color(0xFF059669)),
                            ),
                            const SizedBox(height: 12.0),
                            Text(
                              'Vocabulary Book',
                              style: GoogleFonts.spaceGrotesk(fontSize: 16.0, fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 2.0),
                            Text(
                              '${_user!.learnedWords.length} Words Mastered',
                              style: GoogleFonts.plusJakartaSans(fontSize: 12.0, color: const Color(0xFF64748B)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14.0),

              // Device Sync & Cloud Account Banner
              GestureDetector(
                onTap: () {
                  _sound.playKeyTap();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (c) => AccountSyncScreen(
                        user: _user!,
                        onUserUpdated: (u) => setState(() => _user = u),
                      ),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.0),
                    border: Border.all(color: const Color(0xFFCBD5E1)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0F2FE),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: const Icon(Icons.devices_rounded, color: Color(0xFF0284C7)),
                      ),
                      const SizedBox(width: 14.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Cross-Device Sync',
                              style: GoogleFonts.spaceGrotesk(fontSize: 15.0, fontWeight: FontWeight.w700),
                            ),
                            Text(
                              'Code: ${_user!.syncCode} • Tap to pair other phones or computers',
                              style: GoogleFonts.plusJakartaSans(fontSize: 12.0, color: const Color(0xFF64748B)),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios_rounded, size: 16.0, color: Color(0xFF94A3B8)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
