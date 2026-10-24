import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/level_data.dart';
import '../models/game_state.dart';
import 'letter_tile.dart';

class ClueRow extends StatelessWidget {
  final ClueData clue;
  final GameState gameState;
  final Function(String clueId, int charIdx, int letterNumber) onTileTap;

  const ClueRow({
    super.key,
    required this.clue,
    required this.gameState,
    required this.onTileTap,
  });

  @override
  Widget build(BuildContext context) {
    final isComplete = gameState.isClueComplete(clue);
    final isCurrentClue = !gameState.isQuoteFocused && gameState.selectedClueId == clue.id;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: isCurrentClue
            ? Colors.white.withOpacity(0.85)
            : isComplete
                ? const Color(0xFFF0FDF4).withOpacity(0.6)
                : Colors.transparent,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: isCurrentClue
              ? const Color(0xFFBAE6FD)
              : Colors.transparent,
          width: 1.2,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left: Clue description
          Expanded(
            flex: 5,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (isComplete)
                  const Padding(
                    padding: EdgeInsets.only(right: 6.0),
                    child: Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 18),
                  ),
                Expanded(
                  child: Text(
                    clue.clueText,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14.5,
                      fontWeight: isCurrentClue ? FontWeight.w700 : FontWeight.w600,
                      color: isComplete
                          ? const Color(0xFF475569)
                          : const Color(0xFF1E293B),
                      height: 1.25,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8.0),
          // Right: Target word mini-tiles with numbers
          Expanded(
            flex: 6,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              reverse: true, // Right align tiles as in screenshot
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(clue.targetWord.length, (charIdx) {
                  final num = clue.letterNumbers[charIdx];
                  final typedChar = gameState.getLetterForNumber(num);
                  final isSelected = !gameState.isQuoteFocused &&
                      gameState.selectedClueId == clue.id &&
                      gameState.selectedCharIndexInClue == charIdx;
                  final isLinked = !isSelected && gameState.selectedLetterNumber == num;
                  final isSolved = gameState.isNumberSolved(num);

                  return LetterTile(
                    letter: typedChar,
                    number: num,
                    isSelected: isSelected,
                    isLinked: isLinked,
                    isSolved: isSolved,
                    isSmall: false,
                    onTap: () => onTileTap(clue.id, charIdx, num),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
