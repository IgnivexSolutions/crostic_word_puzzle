import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/levels_dataset.dart';
import '../models/level_data.dart';
import '../models/user_account.dart';
import '../services/sound_service.dart';
import 'gameplay_screen.dart';

class CategoryLevelsScreen extends StatelessWidget {
  final UserAccount user;
  final Function(UserAccount updated) onUserUpdated;

  const CategoryLevelsScreen({
    super.key,
    required this.user,
    required this.onUserUpdated,
  });

  IconData _getCategoryIcon(String cat) {
    switch (cat.toLowerCase()) {
      case 'history':
        return Icons.history_edu_rounded;
      case 'science':
        return Icons.science_rounded;
      case 'literature':
        return Icons.menu_book_rounded;
      case 'nature':
        return Icons.eco_rounded;
      case 'astronomy':
        return Icons.nights_stay_rounded;
      case 'inventions':
        return Icons.lightbulb_circle_rounded;
      default:
        return Icons.category_rounded;
    }
  }

  Color _getCategoryColor(String cat) {
    switch (cat.toLowerCase()) {
      case 'history':
        return const Color(0xFFD97706);
      case 'science':
        return const Color(0xFF0284C7);
      case 'literature':
        return const Color(0xFF8B5CF6);
      case 'nature':
        return const Color(0xFF059669);
      case 'astronomy':
        return const Color(0xFF4F46E5);
      case 'inventions':
        return const Color(0xFFEA580C);
      default:
        return const Color(0xFF64748B);
    }
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
          'Select Level & Category',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 18.0,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF0F172A),
          ),
        ),
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: allGameLevels.length,
          itemBuilder: (context, index) {
            final level = allGameLevels[index];
            final isUnlocked = user.unlockedLevels.contains(level.id);
            final isCompleted = user.completedLevels.contains(level.id);
            final stars = user.levelStars['${level.id}'] ?? (isCompleted ? 3 : 0);
            final themeColor = _getCategoryColor(level.category);

            return Container(
              margin: const EdgeInsets.only(bottom: 14.0),
              decoration: BoxDecoration(
                color: isUnlocked ? Colors.white : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(
                  color: isCompleted
                      ? const Color(0xFFA7F3D0)
                      : isUnlocked
                          ? const Color(0xFFCBD5E1)
                          : const Color(0xFFE2E8F0),
                  width: isCompleted ? 2.0 : 1.2,
                ),
                boxShadow: isUnlocked
                    ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 6.0,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                leading: Container(
                  width: 48.0,
                  height: 48.0,
                  decoration: BoxDecoration(
                    color: isUnlocked ? themeColor.withOpacity(0.12) : const Color(0xFFE2E8F0),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      _getCategoryIcon(level.category),
                      color: isUnlocked ? themeColor : const Color(0xFF94A3B8),
                      size: 26.0,
                    ),
                  ),
                ),
                title: Row(
                  children: [
                    Text(
                      'Level ${level.id} • ${level.category}',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w700,
                        color: isUnlocked ? const Color(0xFF0F172A) : const Color(0xFF94A3B8),
                      ),
                    ),
                    const SizedBox(width: 6.0),
                    if (isCompleted)
                      const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 18),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 2.0),
                    Text(
                      level.title,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13.0,
                        fontWeight: FontWeight.w600,
                        color: isUnlocked ? const Color(0xFF475569) : const Color(0xFFA0AEC0),
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Row(
                      children: [
                        ...List.generate(3, (starIdx) {
                          return Icon(
                            Icons.star_rounded,
                            size: 18.0,
                            color: starIdx < stars ? const Color(0xFFF59E0B) : const Color(0xFFCBD5E1),
                          );
                        }),
                        const SizedBox(width: 8.0),
                        Text(
                          '${level.clues.length} Clues • +${level.coinsReward} 🪙',
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 11.0,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                trailing: isUnlocked
                    ? ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: themeColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
                        ),
                        onPressed: () {
                          SoundService().playKeyTap();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (c) => GameplayScreen(
                                level: level,
                                user: user,
                                onLevelCompleted: () {
                                  onUserUpdated(user);
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          );
                        },
                        child: Text(
                          isCompleted ? 'Replay' : 'Play',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      )
                    : const Icon(Icons.lock_rounded, color: Color(0xFF94A3B8)),
              ),
            );
          },
        ),
      ),
    );
  }
}
