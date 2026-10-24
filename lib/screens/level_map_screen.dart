import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/levels_dataset.dart';
import '../models/user_account.dart';
import '../models/level_data.dart';
import '../services/sound_service.dart';
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
  final ScrollController _scrollController = ScrollController();
  late List<LevelData> _allLevels;

  @override
  void initState() {
    super.initState();
    _allLevels = LevelRepository().levels;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrentLevel();
    });
  }

  void _scrollToCurrentLevel() {
    final highestUnlocked = widget.user.unlockedLevels.isNotEmpty
        ? widget.user.unlockedLevels.reduce((a, b) => a > b ? a : b)
        : 1;
    final index = (highestUnlocked - 1).clamp(0, _allLevels.length - 1);
    final targetOffset = (index * 110.0) - 200.0;
    if (_scrollController.hasClients && targetOffset > 0) {
      _scrollController.animateTo(
        targetOffset.clamp(0.0, _scrollController.position.maxScrollExtent),
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutCubic,
      );
    }
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

  void _openAiGenerator() {
    _sound.playKeyTap();
    final topicController = TextEditingController(text: 'Space & Satellites');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        title: Row(
          children: [
            const Icon(Icons.auto_awesome_rounded, color: Color(0xFF0284C7)),
            const SizedBox(width: 8.0),
            Text(
              'AI Online Puzzle Arena',
              style: GoogleFonts.spaceGrotesk(fontSize: 18.0, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Our curriculum AI generates fresh real-time levels dynamically from scientific textbooks and geography knowledge:',
              style: GoogleFonts.plusJakartaSans(fontSize: 13.0, color: const Color(0xFF475569)),
            ),
            const SizedBox(height: 14.0),
            TextField(
              controller: topicController,
              decoration: InputDecoration(
                labelText: 'Enter Topic (e.g. Physics, Rivers, Space)',
                labelStyle: GoogleFonts.plusJakartaSans(fontSize: 12.0),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                prefixIcon: const Icon(Icons.psychology_rounded, color: Color(0xFF0284C7)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0284C7),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              final aiLevel = await LevelRepository().generateOnlineAiLevel(
                levelId: 1001,
                topic: topicController.text,
              );
              if (mounted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (c) => GameplayScreen(
                      level: aiLevel,
                      user: widget.user,
                      onLevelCompleted: () {
                        setState(() {});
                        widget.onUserUpdated(widget.user);
                      },
                    ),
                  ),
                );
              }
            },
            child: const Text('Generate & Play', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
            // Top Bar matching screenshot
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
                    'Level Map',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 20.0,
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
                  const SizedBox(width: 8.0),
                  // Streak Counter
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.local_fire_department_rounded, color: Color(0xFFFB923C), size: 18),
                        const SizedBox(width: 2.0),
                        Text(
                          '5d',
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

            // Chapter / Quest Path Ribbon with Stars
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'QUEST PATH',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF0284C7),
                          letterSpacing: 0.8,
                        ),
                      ),
                      Text(
                        'Chapter 1: Academic Explorer',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                  // Star Counter Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF3C7),
                      borderRadius: BorderRadius.circular(16.0),
                      border: Border.all(color: const Color(0xFFF59E0B)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star_rounded, color: Color(0xFFD97706), size: 18),
                        const SizedBox(width: 4.0),
                        Text(
                          '$totalStars / ${_allLevels.length * 3}',
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 12.5,
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

            // AI Online Quest floating banner
            Container(
              margin: const EdgeInsets.all(12.0),
              padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0284C7), Color(0xFF0369A1)],
                ),
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0284C7).withOpacity(0.3),
                    blurRadius: 8.0,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.cloud_sync_rounded, color: Colors.white, size: 28),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AI Online Endless Generator',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Generate endless online school curriculum levels',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11.0,
                            color: const Color(0xFFE0F2FE),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF0284C7),
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                    ),
                    onPressed: _openAiGenerator,
                    child: Text(
                      'AI Level',
                      style: GoogleFonts.spaceGrotesk(fontSize: 12.0, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),

            // The Level Progression Road Map (Winding S-Curve nodes matching screenshot!)
            Expanded(
              child: Stack(
                children: [
                  ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 20.0),
                    itemCount: _allLevels.length,
                    itemBuilder: (context, index) {
                      final level = _allLevels[index];
                      final isUnlocked = widget.user.unlockedLevels.contains(level.id);
                      final isCompleted = widget.user.completedLevels.contains(level.id);
                      final isCurrent = level.id == highestUnlocked;
                      final stars = widget.user.levelStars['${level.id}'] ?? (isCompleted ? 3 : 0);

                      // Calculate alternating wave alignment (sinusoidal path like screenshot)
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
                                // Current level highlight tooltip tag
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
                                        fontSize: 11.0,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),

                                // Main Circular Node matching WordSpark screenshot
                                Container(
                                  width: isCurrent ? 64.0 : 54.0,
                                  height: isCurrent ? 64.0 : 54.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isCompleted
                                        ? const Color(0xFF10B981) // Green check
                                        : isCurrent
                                            ? const Color(0xFF10B981) // Pulsing active start
                                            : isUnlocked
                                                ? const Color(0xFF0284C7)
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
                                                  const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 28.0),
                                                  Text(
                                                    'START',
                                                    style: GoogleFonts.spaceGrotesk(
                                                      fontSize: 8.5,
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
                                                      fontSize: 16.0,
                                                      fontWeight: FontWeight.w800,
                                                      color: Colors.white,
                                                    ),
                                                  )
                                                : const Icon(Icons.lock_rounded, color: Color(0xFF94A3B8), size: 22.0),
                                  ),
                                ),

                                const SizedBox(height: 4.0),

                                // Stars or Level Label below node
                                if (isCompleted)
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: List.generate(
                                      3,
                                      (sIdx) => Icon(
                                        Icons.star_rounded,
                                        size: 14.0,
                                        color: sIdx < stars ? const Color(0xFFF59E0B) : const Color(0xFFCBD5E1),
                                      ),
                                    ),
                                  )
                                else
                                  Text(
                                    'Lv ${level.id}',
                                    style: GoogleFonts.spaceGrotesk(
                                      fontSize: 11.0,
                                      fontWeight: FontWeight.w700,
                                      color: isUnlocked ? const Color(0xFF334155) : const Color(0xFF94A3B8),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
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
