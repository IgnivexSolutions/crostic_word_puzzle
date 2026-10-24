import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/level_data.dart';

class LevelCompleteDialog extends StatelessWidget {
  final LevelData level;
  final int coinsEarned;
  final VoidCallback onNextLevel;
  final VoidCallback onReviewBoard;

  const LevelCompleteDialog({
    super.key,
    required this.level,
    required this.coinsEarned,
    required this.onNextLevel,
    required this.onReviewBoard,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
      elevation: 16.0,
      backgroundColor: Colors.white,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420, maxHeight: 680),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header trophy & stars
              Container(
                width: 64.0,
                height: 64.0,
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFF59E0B), width: 2.0),
                ),
                child: const Center(
                  child: Icon(Icons.emoji_events_rounded, color: Color(0xFFD97706), size: 36.0),
                ),
              ),
              const SizedBox(height: 10.0),
              Text(
                'PUZZLE SOLVED!',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0F172A),
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 4.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 28),
                  Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 34),
                  Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 28),
                ],
              ),
              const SizedBox(height: 6.0),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(color: const Color(0xFFA7F3D0)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.monetization_on_rounded, color: Color(0xFF059669), size: 18),
                    const SizedBox(width: 4.0),
                    Text(
                      '+$coinsEarned Coins & Vocabulary Unlocked!',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF065F46),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14.0),

              // Educational Fact Scrollable Box
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Solved Quote Display
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Column(
                          children: [
                            Text(
                              '"${level.quoteText}"',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 16.5,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF1E293B),
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            const SizedBox(height: 6.0),
                            Text(
                              '— ${level.educationalFact.attribution} (${level.educationalFact.yearOrEra})',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13.0,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12.0),

                      // Historical / Educational Context
                      Text(
                        'Educational Insight',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        level.educationalFact.historicalContext,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12.5,
                          height: 1.45,
                          color: const Color(0xFF475569),
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        '💡 Key Takeaway: ${level.educationalFact.keyTakeaway}',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF0284C7),
                        ),
                      ),
                      const SizedBox(height: 14.0),

                      // Vocabulary Unlocked Section
                      Text(
                        'Words Added to Your Student Lexicon:',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 6.0),
                      ...level.vocabularyList.map((vocab) => Container(
                            margin: const EdgeInsets.only(bottom: 8.0),
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(color: const Color(0xFFCBD5E1)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      vocab.word,
                                      style: GoogleFonts.spaceGrotesk(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w800,
                                        color: const Color(0xFF1E293B),
                                      ),
                                    ),
                                    const SizedBox(width: 6.0),
                                    Text(
                                      '(${vocab.partOfSpeech})',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 11.5,
                                        fontStyle: FontStyle.italic,
                                        color: const Color(0xFF64748B),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2.0),
                                Text(
                                  vocab.definition,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12.0,
                                    color: const Color(0xFF334155),
                                  ),
                                ),
                                if (vocab.etymology.isNotEmpty) ...[
                                  const SizedBox(height: 2.0),
                                  Text(
                                    'Etymology: ${vocab.etymology}',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 11.0,
                                      color: const Color(0xFF64748B),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14.0),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        side: const BorderSide(color: Color(0xFFCBD5E1)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                      ),
                      onPressed: onReviewBoard,
                      child: Text(
                        'Review Board',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF475569),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0284C7),
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                        elevation: 3.0,
                      ),
                      onPressed: onNextLevel,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Next Level',
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 4.0),
                          const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
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
}
