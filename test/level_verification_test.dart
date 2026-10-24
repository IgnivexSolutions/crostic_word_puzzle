import 'package:flutter_test/flutter_test.dart';
import 'package:crostic_word_puzzle/data/levels_dataset.dart';
import 'package:crostic_word_puzzle/services/level_verifier.dart';

void main() {
  group('Crostic Level Mathematical & Spelling Verification (Under-Matric Curriculum)', () {
    test('Verify all 6 school levels have zero cipher conflicts and 100% letter bijection', () {
      final verificationResults = LevelVerifier.verifyAll(allGameLevels);

      for (final entry in verificationResults.entries) {
        final levelId = entry.key;
        final result = entry.value;

        expect(
          result.isValid,
          isTrue,
          reason: 'Level $levelId verification failed with errors: \n${result.errors.join("\n")}',
        );

        // Verify clue counts is 8 per level
        final level = allGameLevels.firstWhere((l) => l.id == levelId);
        expect(
          level.clues.length,
          greaterThanOrEqualTo(7),
          reason: 'Level $levelId must have at least 7-8 clues as requested',
        );

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

    test('Verify Level 1 is General Science (Plant Photosynthesis)', () {
      final level1 = allGameLevels.firstWhere((l) => l.id == 1);
      expect(level1.quoteText, equals('GREEN PLANTS PRODUCE FOOD'));
      expect(level1.category, equals('General Science'));

      // Check verified school clues
      final leafClue = level1.clues.firstWhere((c) => c.targetWord == 'LEAF');
      expect(leafClue.letterNumbers, equals([1, 2, 3, 4]));

      final rootClue = level1.clues.firstWhere((c) => c.targetWord == 'ROOT');
      expect(rootClue.letterNumbers, equals([5, 6, 6, 7]));

      final stemClue = level1.clues.firstWhere((c) => c.targetWord == 'STEM');
      expect(stemClue.letterNumbers, equals([8, 7, 2, 9]));

      final seedClue = level1.clues.firstWhere((c) => c.targetWord == 'SEED');
      expect(seedClue.letterNumbers, equals([8, 2, 2, 10]));
    });

    test('Verify Level 5 is South Asian Geography (Indus, Delta, Island, Himalaya)', () {
      final level5 = allGameLevels.firstWhere((l) => l.id == 5);
      expect(level5.quoteText, equals('MONSOON RAIN FEEDS SOUTH ASIA'));

      final indusClue = level5.clues.firstWhere((c) => c.targetWord == 'INDUS');
      expect(indusClue.letterNumbers, equals([1, 2, 3, 4, 5]));

      final himalayaClue = level5.clues.firstWhere((c) => c.targetWord == 'HIMALAYA');
      expect(himalayaClue.letterNumbers, equals([10, 1, 11, 9, 7, 9, 12, 9]));
    });
  });
}
