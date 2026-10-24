import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/level_data.dart';

class LevelCompleteDialog extends StatelessWidget {
  final LevelData level;
  final int coinsEarned;
  final int starsEarned;
  final int hintsUsed;
  final VoidCallback onNextLevel;
  final VoidCallback onReviewBoard;
  final VoidCallback onReplay;

  const LevelCompleteDialog({
    super.key,
    required this.level,
    required this.coinsEarned,
    this.starsEarned = 3,
    this.hintsUsed = 0,
    required this.onNextLevel,
    required this.onReviewBoard,
    required this.onReplay,
  });

  @override
  Widget build(BuildContext context) {
    final wordsSolvedCount = level.clues.length;
    final wordsScore = wordsSolvedCount * 50;
    final speedStreakBonus = 50;
    final hintDeduction = hintsUsed * 20;
    final totalScore = wordsScore + speedStreakBonus - hintDeduction;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28.0)),
      elevation: 20.0,
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 24.0),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 720),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top Bar with Level Cleared pill & Close button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F2FE),
                      borderRadius: BorderRadius.circular(16.0),
                      border: Border.all(color: const Color(0xFFBAE6FD)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.school_rounded, color: Color(0xFF0284C7), size: 14),
                        const SizedBox(width: 4.0),
                        Text(
                          'LEVEL ${level.id} CLEARED',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 11.0,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF0369A1),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: Color(0xFF94A3B8)),
                    onPressed: onReviewBoard,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),

              const SizedBox(height: 12.0),

              // Trophy Illustration
              Container(
                width: 76.0,
                height: 76.0,
                decoration: BoxDecoration(
                  gradient: const RadialGradient(
                    colors: [Color(0xFFFEF3C7), Color(0xFFFDE68A)],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFF59E0B).withOpacity(0.3),
                      blurRadius: 16.0,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(Icons.emoji_events_rounded, color: Color(0xFFD97706), size: 44.0),
                ),
              ),

              const SizedBox(height: 10.0),

              // VICTORY! Heading
              Text(
                'VICTORY!',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 26.0,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF0284C7),
                  letterSpacing: 1.0,
                ),
              ),

              const SizedBox(height: 4.0),

              // Category Mastery Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F766E),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.verified_rounded, color: Colors.white, size: 14),
                    const SizedBox(width: 4.0),
                    Text(
                      '${level.category.toUpperCase()} • MASTERED!',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14.0),

              // 3 Stars Box (Speedy, Accuracy, Flawless)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStarBadge('Speedy', starsEarned >= 1),
                        _buildStarBadge('Accuracy', starsEarned >= 2),
                        _buildStarBadge('Flawless', starsEarned >= 3),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      '$starsEarned / 3 Stars Earned',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      'Brilliant Work! Perfect vocabulary and substitution logic.',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11.0,
                        color: const Color(0xFF64748B),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12.0),

              // Score Breakdown matching screenshot
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  children: [
                    _buildScoreRow(
                      icon: Icons.check_circle_rounded,
                      iconColor: const Color(0xFF10B981),
                      label: 'Words Solved ($wordsSolvedCount / $wordsSolvedCount)',
                      points: '+$wordsScore pts',
                      pointsColor: const Color(0xFF10B981),
                    ),
                    const SizedBox(height: 6.0),
                    _buildScoreRow(
                      icon: Icons.bolt_rounded,
                      iconColor: const Color(0xFFF97316),
                      label: 'Speed & Streak Bonus',
                      points: '+$speedStreakBonus pts',
                      pointsColor: const Color(0xFFF97316),
                    ),
                    const SizedBox(height: 6.0),
                    _buildScoreRow(
                      icon: Icons.help_outline_rounded,
                      iconColor: const Color(0xFFEF4444),
                      label: 'Hint Deduction ($hintsUsed used)',
                      points: hintsUsed > 0 ? '-$hintDeduction pts' : '0 pts',
                      pointsColor: hintsUsed > 0 ? const Color(0xFFEF4444) : const Color(0xFF64748B),
                    ),
                    const Divider(height: 16.0, color: Color(0xFFCBD5E1)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Quest Score',
                          style: GoogleFonts.spaceGrotesk(fontSize: 14.0, fontWeight: FontWeight.w800),
                        ),
                        Text(
                          '$totalScore pts',
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w900,
                            color: const Color(0xFF0284C7),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12.0),

              // Coins Reward Box
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFBEB),
                  borderRadius: BorderRadius.circular(14.0),
                  border: Border.all(color: const Color(0xFFFDE68A)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.monetization_on_rounded, color: Color(0xFFD97706), size: 28),
                    const SizedBox(width: 10.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '+$coinsEarned Coins',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF92400E),
                          ),
                        ),
                        Text(
                          'Added to Quest Wallet',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11.0,
                            color: const Color(0xFFB45309),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.local_fire_department_rounded, color: Color(0xFFEA580C), size: 16),
                          const SizedBox(width: 2.0),
                          Text(
                            '+1 Day',
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 11.0,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFFC2410C),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16.0),

              // Next Level Button (Green Primary Button)
              SizedBox(
                width: double.infinity,
                height: 48.0,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
                    elevation: 3.0,
                  ),
                  onPressed: onNextLevel,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'NEXT LEVEL ${level.id + 1}',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 6.0),
                      const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10.0),

              // Replay and Review Row
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        side: const BorderSide(color: Color(0xFFCBD5E1)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                      ),
                      onPressed: onReplay,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.replay_rounded, size: 16, color: Color(0xFF475569)),
                          const SizedBox(width: 4.0),
                          Text(
                            'Replay',
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 13.0,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF475569),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        side: const BorderSide(color: Color(0xFFCBD5E1)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                      ),
                      onPressed: onReviewBoard,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.menu_book_rounded, size: 16, color: Color(0xFF475569)),
                          const SizedBox(width: 4.0),
                          Text(
                            'Review (${level.clues.length})',
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 13.0,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF475569),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStarBadge(String label, bool isEarned) {
    return Column(
      children: [
        Container(
          width: 50.0,
          height: 50.0,
          decoration: BoxDecoration(
            color: isEarned ? const Color(0xFFFBBF24) : const Color(0xFFE2E8F0),
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: isEarned
                ? [
                    BoxShadow(
                      color: const Color(0xFFF59E0B).withOpacity(0.4),
                      blurRadius: 8.0,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Icon(
              Icons.star_rounded,
              color: isEarned ? Colors.white : const Color(0xFF94A3B8),
              size: 32.0,
            ),
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          label,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 11.0,
            fontWeight: FontWeight.w700,
            color: isEarned ? const Color(0xFF92400E) : const Color(0xFF94A3B8),
          ),
        ),
      ],
    );
  }

  Widget _buildScoreRow({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String points,
    required Color pointsColor,
  }) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 16),
        const SizedBox(width: 8.0),
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12.0,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF334155),
            ),
          ),
        ),
        Text(
          points,
          style: GoogleFonts.jetBrainsMono(
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
            color: pointsColor,
          ),
        ),
      ],
    );
  }
}
