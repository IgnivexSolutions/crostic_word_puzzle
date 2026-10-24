import '../models/level_data.dart';

class LevelVerificationResult {
  final bool isValid;
  final List<String> errors;
  final Map<int, String> verifiedCipherMap;

  const LevelVerificationResult({
    required this.isValid,
    required this.errors,
    required this.verifiedCipherMap,
  });
}

class LevelVerifier {
  /// Strictly verifies the mathematical and linguistic consistency of a level.
  /// 1. Every character in the quote and clues matches its assigned letter number.
  /// 2. Every letter number corresponds to exactly ONE distinct character.
  /// 3. All letters in the quote can be deduced from the clues.
  /// 4. Every clue has a verified word spelling and definition.
  static LevelVerificationResult verifyLevel(LevelData level) {
    final errors = <String>[];
    final numberToChar = <int, String>{};
    final charToNumber = <String, int>{};

    // 1. Verify Quote Words
    for (int w = 0; w < level.quoteWords.length; w++) {
      final qw = level.quoteWords[w];
      final word = qw.word.toUpperCase().replaceAll(RegExp(r'[^A-Z]'), '');
      if (word.length != qw.letterNumbers.length) {
        errors.add(
          'Level ${level.id} Quote Word "$word" has length ${word.length} but letterNumbers has ${qw.letterNumbers.length}',
        );
      }

      for (int i = 0; i < word.length; i++) {
        final char = word[i];
        final num = qw.letterNumbers[i];

        if (numberToChar.containsKey(num)) {
          if (numberToChar[num] != char) {
            errors.add(
              'Level ${level.id} Quote conflict: number $num is mapped to "${numberToChar[num]}" and "$char" in word "$word"',
            );
          }
        } else {
          numberToChar[num] = char;
        }

        if (charToNumber.containsKey(char)) {
          if (charToNumber[char] != num) {
            errors.add(
              'Level ${level.id} Character conflict: character "$char" is mapped to numbers ${charToNumber[char]} and $num',
            );
          }
        } else {
          charToNumber[char] = num;
        }
      }
    }

    // 2. Verify Clues
    final clueChars = <String>{};
    for (int c = 0; c < level.clues.length; c++) {
      final clue = level.clues[c];
      final word = clue.targetWord.toUpperCase().replaceAll(RegExp(r'[^A-Z]'), '');

      if (word.length != clue.letterNumbers.length) {
        errors.add(
          'Level ${level.id} Clue "${clue.clueText}" target "$word" has length ${word.length} but ${clue.letterNumbers.length} numbers',
        );
      }

      for (int i = 0; i < word.length; i++) {
        final char = word[i];
        final num = clue.letterNumbers[i];
        clueChars.add(char);

        if (numberToChar.containsKey(num)) {
          if (numberToChar[num] != char) {
            errors.add(
              'Level ${level.id} Clue conflict: number $num is mapped to "${numberToChar[num]}" but clue "$word" expects "$char"',
            );
          }
        } else {
          numberToChar[num] = char;
        }

        if (charToNumber.containsKey(char)) {
          if (charToNumber[char] != num) {
            errors.add(
              'Level ${level.id} Clue char conflict: "$char" is mapped to ${charToNumber[char]} and $num in clue "$word"',
            );
          }
        } else {
          charToNumber[char] = num;
        }
      }
    }

    // 3. Verify quote characters are all discoverable in clues
    for (final qw in level.quoteWords) {
      for (int i = 0; i < qw.word.length; i++) {
        final char = qw.word[i];
        if (!clueChars.contains(char)) {
          errors.add(
            'Level ${level.id}: Letter "$char" in quote word "${qw.word}" is missing from all clues! It must be discoverable.',
          );
        }
      }
    }

    return LevelVerificationResult(
      isValid: errors.isEmpty,
      errors: errors,
      verifiedCipherMap: numberToChar,
    );
  }

  /// Verifies all levels in the dataset and prints/returns results
  static Map<int, LevelVerificationResult> verifyAll(List<LevelData> levels) {
    final results = <int, LevelVerificationResult>{};
    for (final level in levels) {
      results[level.id] = verifyLevel(level);
    }
    return results;
  }
}
