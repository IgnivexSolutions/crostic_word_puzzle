import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/levels_dataset.dart';
import '../models/user_account.dart';
import '../models/level_data.dart';
import '../services/sound_service.dart';
import '../services/storage_service.dart';
import 'gameplay_screen.dart';

class LevelMapScreen extends StatefulWidget {
  final UserAccount user;
  final Function(UserAccount updated) onUserUpdated;

  const LevelMapScreen({
    super.key,
    required this.user,
    required this.onUserUpdated,
  });

  @override
  State<LevelMapScreen> createState() => _LevelMapScreenState();
}

class _LevelMapScreenState extends State<LevelMapScreen> {
  final SoundService _sound = SoundService();
  final StorageService _storage = StorageService();
  final ScrollController _scrollController = ScrollController();
  late String _selectedClass;

  final List<Map<String, dynamic>> _classTabs = [
    {
      'id': 'Class 1 - 3',
      'label': 'Class 1 - 3',
      'title': 'Junior Stars',
      'icon': '🎒',
      'color': const Color(0xFF10B981),
    },
    {
      'id': 'Class 4 - 5',
      'label': 'Class 4 - 5',
      'title': 'Young Explorers',
      'icon': '🚀',
      'color': const Color(0xFF0284C7),
    },
    {
      'id': 'Class 6 - 8',
      'label': 'Class 6 - 8',
      'title': 'Middle Scholars',
      'icon': '🔬',
      'color': const Color(0xFF6366F1),
    },
    {
      'id': 'Class 9 - 10+',
      'label': 'Class 9 - 10+',
      'title': 'Senior Masters',
      'icon': '🎓',
      'color': const Color(0xFFD97706),
    },
  ];

  @override
  void initState() {
    super.initState();
    _selectedClass = widget.user.selectedClass.isNotEmpty
        ? widget.user.selectedClass
        : 'Class 1 - 3';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrentLevel();
    });
  }

  void _scrollToCurrentLevel() {
    final levels = LevelRepository().getLevelsForClass(_selectedClass);
    final highestUnlocked = widget.user.unlockedLevels.isNotEmpty
        ? widget.user.unlockedLevels.reduce((a, b) => a > b ? a : b)
        : 1;
    final index = levels.indexWhere((l) => l.id == highestUnlocked);
    if (index > 0 && _scrollController.hasClients) {
      final targetOffset = (index * 110.0) - 150.0;
      _scrollController.animateTo(
        targetOffset.clamp(0.0, _scrollController.position.maxScrollExtent),
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _selectClassTab(String classId) {
    _sound.playKeyTap();
    setState(() {
      _selectedClass = classId;
      widget.user.selectedClass = classId;
    });
    _storage.saveSelectedClass(classId);
    _storage.saveUserAccount(widget.user);
    widget.onUserUpdated(widget.user);
  }

  void _playLevel(int levelId) {
    if (!widget.user.unlockedLevels.contains(levelId)) {
      _sound.playError();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Level $levelId is locked! Complete earlier levels to unlock.'),
          backgroundColor: const Color(0xFFEF4444),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    _sound.playKeyTap();
    final level = LevelRepository().getLevel(levelId);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (c) => GameplayScreen(
          level: level,
          user: widget.user,
          onLevelCompleted: () {
            setState(() {});
            widget.onUserUpdated(widget.user);
          },
        ),
      ),
    ).then((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final classLevels = LevelRepository().getLevelsForClass(_selectedClass);
    final activeTab = _classTabs.firstWhere(
      (t) => t['id'] == _selectedClass,
      orElse: () => _classTabs.first,
    );

    final highestUnlocked = widget.user.unlockedLevels.isNotEmpty
        ? widget.user.unlockedLevels.reduce((a, b) => a > b ? a : b)
        : 1;

    int totalStars = 0;
    widget.user.levelStars.forEach((key, val) => totalStars += val);

    return Scaffold(
      backgroundColor: const Color(0xFFF0F6FA),
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              decoration: const BoxDecoration(
                color: Color(0xFF0284C7),
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 4.0, offset: Offset(0, 2)),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    'Curriculum Level Map',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 19.0,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  // Coin Counter
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.monetization_on_rounded, color: Color(0xFFFBBF24), size: 18),
                        const SizedBox(width: 4.0),
                        Text(
                          '${widget.user.coins}',
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Class Selection Filter Tabs
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: _classTabs.map((tab) {
                    final isSelected = tab['id'] == _selectedClass;
                    return GestureDetector(
                      onTap: () => _selectClassTab(tab['id'] as String),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                        decoration: BoxDecoration(
                          color: isSelected ? (tab['color'] as Color) : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(14.0),
                          border: Border.all(
                            color: isSelected ? (tab['color'] as Color) : const Color(0xFFE2E8F0),
                            width: 1.2,
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(tab['icon'] as String, style: const TextStyle(fontSize: 14)),
                            const SizedBox(width: 6.0),
                            Text(
                              tab['label'] as String,
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w800,
                                color: isSelected ? Colors.white : const Color(0xFF475569),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            // Curriculum Chapter Summary Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: const Color(0xFFE2E8F0))),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${activeTab['label']} • ${activeTab['title']}',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                      Text(
                        '10 Verified Curriculum Levels',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: activeTab['color'] as Color,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF3C7),
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(color: const Color(0xFFF59E0B)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star_rounded, color: Color(0xFFD97706), size: 16),
                        const SizedBox(width: 4.0),
                        Text(
                          '$totalStars Stars',
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF92400E),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Winding Level Nodes
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                itemCount: classLevels.length,
                itemBuilder: (context, index) {
                  final level = classLevels[index];
                  final isUnlocked = widget.user.unlockedLevels.contains(level.id);
                  final isCompleted = widget.user.completedLevels.contains(level.id);
                  final isCurrent = level.id == highestUnlocked;
                  final stars = widget.user.levelStars['${level.id}'] ?? (isCompleted ? 3 : 0);

                  final double waveOffset = ((index % 4) == 0)
                      ? 0.0
                      : ((index % 4) == 1)
                          ? 60.0
                          : ((index % 4) == 2)
                              ? 0.0
                              : -60.0;

                  return Container(
                    height: 110.0,
                    alignment: Alignment.center,
                    child: Transform.translate(
                      offset: Offset(waveOffset, 0),
                      child: GestureDetector(
                        onTap: () => _playLevel(level.id),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isCurrent)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
                                margin: const EdgeInsets.only(bottom: 4.0),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF97316),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Text(
                                  'Level ${level.id} • PLAY',
                                  style: GoogleFonts.spaceGrotesk(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                              ),

                            // Main Node
                            Container(
                              width: isCurrent ? 62.0 : 52.0,
                              height: isCurrent ? 62.0 : 52.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isCompleted
                                    ? const Color(0xFF10B981)
                                    : isCurrent
                                        ? const Color(0xFF10B981)
                                        : isUnlocked
                                            ? (activeTab['color'] as Color)
                                            : const Color(0xFFE2E8F0),
                                border: Border.all(
                                  color: isCurrent
                                      ? const Color(0xFFA7F3D0)
                                      : isUnlocked
                                          ? Colors.white
                                          : const Color(0xFFCBD5E1),
                                  width: isCurrent ? 4.0 : 2.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: isCompleted
                                        ? const Color(0xFF10B981).withOpacity(0.35)
                                        : isCurrent
                                            ? const Color(0xFF10B981).withOpacity(0.4)
                                            : Colors.black.withOpacity(0.08),
                                    blurRadius: isCurrent ? 12.0 : 6.0,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: isCompleted
                                    ? const Icon(Icons.check_rounded, color: Colors.white, size: 28.0)
                                    : isCurrent
                                        ? Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 26.0),
                                              Text(
                                                'PLAY',
                                                style: GoogleFonts.spaceGrotesk(
                                                  fontSize: 8.0,
                                                  fontWeight: FontWeight.w900,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          )
                                        : isUnlocked
                                            ? Text(
                                                '${level.id}',
                                                style: GoogleFonts.spaceGrotesk(
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.w800,
                                                  color: Colors.white,
                                                ),
                                              )
                                            : const Icon(Icons.lock_rounded, color: Color(0xFF94A3B8), size: 16.0),
                              ),
                            ),

                            const SizedBox(height: 3.5),

                            Text(
                              '${level.title}',
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w800,
                                color: isUnlocked ? const Color(0xFF0F172A) : const Color(0xFF94A3B8),
                              ),
                            ),
                            if (isCompleted)
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: List.generate(
                                  3,
                                  (sIdx) => Icon(
                                    Icons.star_rounded,
                                    size: 13.0,
                                    color: sIdx < stars ? const Color(0xFFF59E0B) : const Color(0xFFCBD5E1),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
