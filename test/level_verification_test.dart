import 'package:flutter_test/flutter_test.dart';
import 'package:crostic_word_puzzle/data/levels_dataset.dart';
import 'package:crostic_word_puzzle/services/level_verifier.dart';

void main() {
  group('Crostic Level Mathematical & Spelling Verification (Short-Word School Curriculum)', () {
    test('Verify all school levels have zero cipher conflicts and 100% letter bijection', () {
      final verificationResults = LevelVerifier.verifyAll(allGameLevels);

      for (final entry in verificationResults.entries) {
        final levelId = entry.key;
        final result = entry.value;

        expect(
          result.isValid,
          isTrue,
          reason: 'Level $levelId verification failed with errors: \n${result.errors.join("\n")}',
        );

        // Verify clue count is 8 per level
        final level = allGameLevels.firstWhere((l) => l.id == levelId);
        expect(
          level.clues.length,
          equals(8),
          reason: 'Level $levelId must have 8 clues',
        );

        // Verify all words are short (<= 6 chars) to avoid clutter
        for (final clue in level.clues) {
          expect(
            clue.targetWord.length,
            lessThanOrEqualTo(6),
            reason: 'Clue word "${clue.targetWord}" in level $levelId exceeds 6 letters',
          );
        }

        // Verify letter coverage: all quote letters must be present in clues
        final quoteLetters = level.quoteText.replaceAll(' ', '').split('').toSet();
        final clueLetters = level.clues.map((c) => c.targetWord.split('')).expand((x) => x).toSet();

        for (final ql in quoteLetters) {
          expect(
            clueLetters.contains(ql),
            isTrue,
            reason: 'Level $levelId: Letter "$ql" in quote "${level.quoteText}" is missing from all clues!',
          );
        }
      }
    });

    test('Verify Level 1 (Sun & Plants)', () {
      final level1 = allGameLevels.firstWhere((l) => l.id == 1);
      expect(level1.quoteText, equals('PLANTS NEED SUN AND RAIN'));
      expect(level1.clues.firstWhere((c) => c.targetWord == 'LEAF').letterNumbers, equals([1, 2, 3, 4]));
      expect(level1.clues.firstWhere((c) => c.targetWord == 'SUN').letterNumbers, equals([8, 12, 11]));
    });

    test('Verify Level 5 (Indus River)', () {
      final level5 = allGameLevels.firstWhere((l) => l.id == 5);
      expect(level5.quoteText, equals('INDUS IS OUR BIG RIVER'));
      expect(level5.clues.firstWhere((c) => c.targetWord == 'INDUS').letterNumbers, equals([1, 2, 3, 4, 5]));
    });
  });
}
