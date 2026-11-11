import 'package:flutter/material.dart';
import '../models/level_data.dart';
import '../models/game_state.dart';
import 'letter_tile.dart';

class QuoteMatrix extends StatelessWidget {
  final LevelData level;
  final GameState gameState;
  final bool highContrast;
  final bool openApertures;
  final Function(int wordIdx, int charIdx, int letterNumber) onTileTap;

  const QuoteMatrix({
    super.key,
    required this.level,
    required this.gameState,
    this.highContrast = false,
    this.openApertures = false,
    required this.onTileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: highContrast ? const Color(0xFF0F172A) : const Color(0xFFCDE1EC),
          width: highContrast ? 2.0 : 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withOpacity(0.06),
            blurRadius: 10.0,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 12.0, // Space between distinct words
          runSpacing: 8.0, // Space between lines of words
          children: List.generate(level.quoteWords.length, (wordIdx) {
            final qw = level.quoteWords[wordIdx];
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(qw.word.length, (charIdx) {
                final num = qw.letterNumbers[charIdx];
                final typedChar = gameState.getLetterForNumber(num);
                final isSelected = gameState.isQuoteFocused &&
                    gameState.selectedQuoteWordIndex == wordIdx &&
                    gameState.selectedCharIndexInQuote == charIdx;
                final isLinked = !isSelected && gameState.selectedLetterNumber == num;
                final isSolved = gameState.isNumberSolved(num);

                return LetterTile(
                  letter: typedChar,
                  number: num,
                  isSelected: isSelected,
                  isLinked: isLinked,
                  isSolved: isSolved,
                  isSmall: true,
                  highContrast: highContrast,
                  openApertures: openApertures,
                  onTap: () => onTileTap(wordIdx, charIdx, num),
                );
              }),
            );
          }),
        ),
      ),
    );
  }
}
