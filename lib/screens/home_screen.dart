import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/levels_dataset.dart';
import '../models/user_account.dart';
import '../models/level_data.dart';
import '../services/sound_service.dart';
import '../services/storage_service.dart';
import 'gameplay_screen.dart';
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

  final List<Map<String, dynamic>> _classTiers = [
    {
      'id': 'Class 1 - 3',
      'label': 'Class 1 - 3',
      'title': 'Junior Stars',
      'icon': '🎒',
      'desc': 'Simple words • Animals & Nature',
      'color': const Color(0xFF10B981),
      'bgGradient': [Color(0xFF10B981), Color(0xFF059669)],
    },
    {
      'id': 'Class 4 - 5',
      'label': 'Class 4 - 5',
      'title': 'Young Explorers',
      'icon': '🚀',
      'desc': 'Science facts • Earth, Sea & Body',
      'color': const Color(0xFF0284C7),
      'bgGradient': [Color(0xFF0284C7), Color(0xFF0369A1)],
    },
    {
      'id': 'Class 6 - 8',
      'label': 'Class 6 - 8',
      'title': 'Middle Scholars',
      'icon': '🔬',
      'desc': 'Magnets, Sound, Light & Fossils',
      'color': const Color(0xFF6366F1),
      'bgGradient': [Color(0xFF6366F1), Color(0xFF4F46E5)],
    },
    {
      'id': 'Class 9 - 10+',
      'label': 'Class 9 - 10+',
      'title': 'Senior Masters',
      'icon': '🎓',
      'desc': 'Atoms, Gravity, Universe & Physics',
      'color': const Color(0xFFD97706),
      'bgGradient': [Color(0xFFF59E0B), Color(0xFFD97706)],
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final user = await _storage.loadUserAccount();
    final savedClass = _storage.getSelectedClass();
    if (user.selectedClass.isEmpty) {
      user.selectedClass = savedClass;
    }
    setState(() {
      _user = user;
      _isLoading = false;
    });
  }

  void _selectClass(String classId) {
    if (_user == null) return;
    _sound.playKeyTap();
    setState(() {
      _user!.selectedClass = classId;
    });
    _storage.saveSelectedClass(classId);
    _storage.saveUserAccount(_user!);
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

  int _findNextPlayableLevelForClass(String classId) {
    final levels = LevelRepository().getLevelsForClass(classId);
    for (final l in levels) {
      if (!_user!.completedLevels.contains(l.id) && _user!.unlockedLevels.contains(l.id)) {
        return l.id;
      }
    }
    // If all completed or none found, return first level of that class
    return levels.isNotEmpty ? levels.first.id : 1;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _user == null) {
      return const Scaffold(
        backgroundColor: Color(0xFFF0F5F9),
        body: Center(child: CircularProgressIndicator(color: Color(0xFF0284C7))),
      );
    }

    final currentClass = _user!.selectedClass;
    final activeTier = _classTiers.firstWhere(
      (t) => t['id'] == currentClass,
      orElse: () => _classTiers.first,
    );
    final nextLevelId = _findNextPlayableLevelForClass(currentClass);
    final nextLevel = LevelRepository().getLevel(nextLevelId);
    final classLevels = LevelRepository().getLevelsForClass(currentClass);

    return Scaffold(
      backgroundColor: const Color(0xFFF0F5F9),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Top Bar: Avatar, Sync Code, Coins, Settings
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
                          radius: 21,
                          backgroundColor: (activeTier['color'] as Color).withOpacity(0.18),
                          child: Text(
                            activeTier['icon'] as String,
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _user!.displayName,
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF0F172A),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 1.5),
                              decoration: BoxDecoration(
                                color: (activeTier['color'] as Color).withOpacity(0.12),
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              child: Text(
                                activeTier['label'] as String,
                                style: GoogleFonts.spaceGrotesk(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w700,
                                  color: activeTier['color'] as Color,
                                ),
                              ),
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
                        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.0),
                          border: Border.all(color: const Color(0xFFCBD5E1)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 4.0,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const Text('🪙', style: TextStyle(fontSize: 14)),
                            const SizedBox(width: 4.0),
                            Text(
                              '${_user!.coins}',
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 13.0,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFFD97706),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6.0),
                      IconButton(
                        icon: const Icon(Icons.settings_rounded, color: Color(0xFF475569), size: 24.0),
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

              const SizedBox(height: 16.0),

              // 2. Friendly Educational Banner
              Text(
                'Crostic Scholar',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 27.0,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF0F172A),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 2.0),
              Text(
                'Simple words, fun puzzles & real student knowledge',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13.0,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF64748B),
                ),
              ),

              const SizedBox(height: 16.0),

              // 3. Class Level Selection Bar (Feature for students to select class level!)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'SELECT YOUR CLASS LEVEL',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                      color: const Color(0xFF475569),
                    ),
                  ),
                  Text(
                    'Tap to Switch',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11.0,
                      fontWeight: FontWeight.w600,
                      color: activeTier['color'] as Color,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: _classTiers.map((tier) {
                    final isSelected = tier['id'] == currentClass;
                    return GestureDetector(
                      onTap: () => _selectClass(tier['id'] as String),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(right: 10.0),
                        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
                        decoration: BoxDecoration(
                          color: isSelected ? (tier['color'] as Color) : Colors.white,
                          borderRadius: BorderRadius.circular(16.0),
                          border: Border.all(
                            color: isSelected ? (tier['color'] as Color) : const Color(0xFFCBD5E1),
                            width: isSelected ? 2.0 : 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: isSelected
                                  ? (tier['color'] as Color).withOpacity(0.3)
                                  : Colors.black.withOpacity(0.04),
                              blurRadius: isSelected ? 8.0 : 4.0,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Text(tier['icon'] as String, style: const TextStyle(fontSize: 18)),
                            const SizedBox(width: 8.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tier['label'] as String,
                                  style: GoogleFonts.spaceGrotesk(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w800,
                                    color: isSelected ? Colors.white : const Color(0xFF1E293B),
                                  ),
                                ),
                                Text(
                                  tier['title'] as String,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected ? Colors.white.withOpacity(0.9) : const Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 18.0),

              // 4. Hero Featured Level Card for Chosen Class
              GestureDetector(
                onTap: () => _openLevel(nextLevelId),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: activeTier['bgGradient'] as List<Color>,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(22.0),
                    boxShadow: [
                      BoxShadow(
                        color: (activeTier['color'] as Color).withOpacity(0.35),
                        blurRadius: 14.0,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.22),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Row(
                              children: [
                                Text(activeTier['icon'] as String, style: const TextStyle(fontSize: 12)),
                                const SizedBox(width: 5.0),
                                Text(
                                  'LEVEL $nextLevelId • ${activeTier['label']}',
                                  style: GoogleFonts.spaceGrotesk(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.8,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.18),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Text(
                              nextLevel.category,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11.0,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12.0),
                      Text(
                        nextLevel.title,
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 22.0,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'Fact: "${nextLevel.quoteText}"',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: List.generate(3, (starIdx) {
                              final savedStars = _user!.levelStars['$nextLevelId'] ?? 0;
                              final isEarned = starIdx < savedStars;
                              return Icon(
                                isEarned ? Icons.star_rounded : Icons.star_outline_rounded,
                                color: isEarned ? const Color(0xFFFBBF24) : Colors.white.withOpacity(0.5),
                                size: 22,
                              );
                            }),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 9.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.12),
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
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w800,
                                    color: activeTier['color'] as Color,
                                  ),
                                ),
                                const SizedBox(width: 4.0),
                                Icon(Icons.play_arrow_rounded, color: activeTier['color'] as Color, size: 20),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20.0),

              // 5. Grid of Levels for Active Class (Shows all 10 verified levels)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${activeTier['label']} PUZZLES (${classLevels.length})',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                      color: const Color(0xFF475569),
                    ),
                  ),
                  GestureDetector(
                    onTap: _openLevelMap,
                    child: Text(
                      'View All Map →',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w700,
                        color: activeTier['color'] as Color,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: classLevels.length,
                itemBuilder: (ctx, idx) {
                  final lvl = classLevels[idx];
                  final isUnlocked = _user!.unlockedLevels.contains(lvl.id);
                  final isCompleted = _user!.completedLevels.contains(lvl.id);
                  final stars = _user!.levelStars['${lvl.id}'] ?? 0;

                  return GestureDetector(
                    onTap: () => _openLevel(lvl.id),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8.0),
                      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.0),
                        border: Border.all(
                          color: isCompleted
                              ? const Color(0xFF10B981).withOpacity(0.4)
                              : isUnlocked
                                  ? const Color(0xFFCBD5E1)
                                  : const Color(0xFFE2E8F0),
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 4.0,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40.0,
                            height: 40.0,
                            decoration: BoxDecoration(
                              color: isCompleted
                                  ? const Color(0xFFDCFCE7)
                                  : isUnlocked
                                      ? (activeTier['color'] as Color).withOpacity(0.12)
                                      : const Color(0xFFF1F5F9),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                isCompleted
                                    ? '✓'
                                    : isUnlocked
                                        ? '${lvl.id}'
                                        : '🔒',
                                style: GoogleFonts.spaceGrotesk(
                                  fontSize: isCompleted ? 18.0 : 14.0,
                                  fontWeight: FontWeight.w800,
                                  color: isCompleted
                                      ? const Color(0xFF15803D)
                                      : isUnlocked
                                          ? (activeTier['color'] as Color)
                                          : const Color(0xFF94A3B8),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      lvl.title,
                                      style: GoogleFonts.spaceGrotesk(
                                        fontSize: 14.5,
                                        fontWeight: FontWeight.w700,
                                        color: isUnlocked
                                            ? const Color(0xFF0F172A)
                                            : const Color(0xFF94A3B8),
                                      ),
                                    ),
                                    const SizedBox(width: 6.0),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 1.0),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF1F5F9),
                                        borderRadius: BorderRadius.circular(4.0),
                                      ),
                                      child: Text(
                                        lvl.category,
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 9.5,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF64748B),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2.0),
                                Text(
                                  '${lvl.clues.length} simple clues • Reward: 🪙 ${lvl.coinsReward}',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11.5,
                                    color: const Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isCompleted)
                            Row(
                              children: List.generate(
                                3,
                                (s) => Icon(
                                  s < stars ? Icons.star_rounded : Icons.star_outline_rounded,
                                  size: 16.0,
                                  color: s < stars ? const Color(0xFFFBBF24) : const Color(0xFFCBD5E1),
                                ),
                              ),
                            )
                          else if (isUnlocked)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                              decoration: BoxDecoration(
                                color: (activeTier['color'] as Color).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Text(
                                'Play',
                                style: GoogleFonts.spaceGrotesk(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w800,
                                  color: activeTier['color'] as Color,
                                ),
                              ),
                            )
                          else
                            const Icon(Icons.lock_rounded, size: 18.0, color: Color(0xFF94A3B8)),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16.0),

              // 6. Quick Action Navigation Cards
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: _openLevelMap,
                      child: Container(
                        padding: const EdgeInsets.all(14.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.0),
                          border: Border.all(color: const Color(0xFFCBD5E1)),
                        ),
                        child: Row(
                          children: [
                            const Text('🗺️', style: TextStyle(fontSize: 20)),
                            const SizedBox(width: 8.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Level Map',
                                    style: GoogleFonts.spaceGrotesk(fontSize: 14.0, fontWeight: FontWeight.w800),
                                  ),
                                  Text(
                                    'All Class Quests',
                                    style: GoogleFonts.plusJakartaSans(fontSize: 11.0, color: const Color(0xFF64748B)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10.0),
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
                        padding: const EdgeInsets.all(14.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.0),
                          border: Border.all(color: const Color(0xFFCBD5E1)),
                        ),
                        child: Row(
                          children: [
                            const Text('📖', style: TextStyle(fontSize: 20)),
                            const SizedBox(width: 8.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Word Vault',
                                    style: GoogleFonts.spaceGrotesk(fontSize: 14.0, fontWeight: FontWeight.w800),
                                  ),
                                  Text(
                                    'Learned Words',
                                    style: GoogleFonts.plusJakartaSans(fontSize: 11.0, color: const Color(0xFF64748B)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}
