import 'package:flutter_test/flutter_test.dart';
import 'package:crostic_word_puzzle/data/levels_dataset.dart';
import 'package:crostic_word_puzzle/services/level_verifier.dart';

void main() {
  group('Crostic Level Mathematical & Spelling Verification (School Curriculum)', () {
    test('Verify all school levels have zero cipher conflicts and 100% letter bijection', () {
      final verificationResults = LevelVerifier.verifyAll(allGameLevels);

      expect(allGameLevels.length, equals(40), reason: 'Must have 40 verified curriculum levels');

      for (final entry in verificationResults.entries) {
        final levelId = entry.key;
        final result = entry.value;

        expect(
          result.isValid,
          isTrue,
          reason: 'Level $levelId verification failed with errors: \n${result.errors.join("\n")}',
        );

        final level = allGameLevels.firstWhere((l) => l.id == levelId);

        // Verify clue count is sufficient for student gameplay (at least 5 clues)
        expect(
          level.clues.length,
          greaterThanOrEqualTo(5),
          reason: 'Level $levelId must have at least 5 clues',
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

    test('Verify Class Level Tiers Distribution', () {
      final class13 = allGameLevels.where((l) => l.classLevel == 'Class 1 - 3').toList();
      final class45 = allGameLevels.where((l) => l.classLevel == 'Class 4 - 5').toList();
      final class68 = allGameLevels.where((l) => l.classLevel == 'Class 6 - 8').toList();
      final class910 = allGameLevels.where((l) => l.classLevel == 'Class 9 - 10+').toList();

      expect(class13.length, equals(10), reason: 'Class 1-3 must have 10 levels');
      expect(class45.length, equals(10), reason: 'Class 4-5 must have 10 levels');
      expect(class68.length, equals(10), reason: 'Class 6-8 must have 10 levels');
      expect(class910.length, equals(10), reason: 'Class 9-10+ must have 10 levels');
    });

    test('Verify Level 1 (Cats at Night)', () {
      final level1 = allGameLevels.firstWhere((l) => l.id == 1);
      expect(level1.quoteText, equals('CATS CAN SEE AT NIGHT'));
      expect(level1.classLevel, equals('Class 1 - 3'));
      expect(level1.clues.any((c) => c.targetWord == 'CAT'), isTrue);
    });

    test('Verify Level 11 (Blue Oceans)', () {
      final level11 = allGameLevels.firstWhere((l) => l.id == 11);
      expect(level11.quoteText, equals('OCEANS COVER MOST OF EARTH'));
      expect(level11.classLevel, equals('Class 4 - 5'));
      expect(level11.clues.any((c) => c.targetWord == 'OCEAN'), isTrue);
    });
  });
}
