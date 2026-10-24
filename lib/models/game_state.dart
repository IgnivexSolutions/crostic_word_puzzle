import '../models/level_data.dart';

class GameState {
  final LevelData level;
  final Map<int, String> guessedLetters; // letterNumber -> typed uppercase letter
  final Set<int> revealedLetterNumbers; // letterNumbers revealed by hints
  int? selectedLetterNumber; // Number currently selected by user (glows across board)
  String? selectedClueId; // Clue ID where the user is currently focused
  int selectedCharIndexInClue; // Index within the selected clue
  bool isQuoteFocused; // True if user is typing directly in top quote
  int? selectedQuoteWordIndex;
  int selectedCharIndexInQuote;
  int hintsUsed;
  int mistakesCount;
  bool isCompleted;

  GameState({
    required this.level,
    Map<int, String>? guessedLetters,
    Set<int>? revealedLetterNumbers,
    this.selectedLetterNumber,
    this.selectedClueId,
    this.selectedCharIndexInClue = 0,
    this.isQuoteFocused = false,
    this.selectedQuoteWordIndex,
    this.selectedCharIndexInQuote = 0,
    this.hintsUsed = 0,
    this.mistakesCount = 0,
    this.isCompleted = false,
  })  : guessedLetters = guessedLetters ?? {},
        revealedLetterNumbers = revealedLetterNumbers ?? {};

  /// Initial state for a level with default selection on the first cell of the first clue
  factory GameState.initial(LevelData level) {
    int? initialNum;
    String? initialClueId;
    if (level.clues.isNotEmpty && level.clues.first.letterNumbers.isNotEmpty) {
      initialClueId = level.clues.first.id;
      initialNum = level.clues.first.letterNumbers.first;
    }

    return GameState(
      level: level,
      selectedClueId: initialClueId,
      selectedLetterNumber: initialNum,
      selectedCharIndexInClue: 0,
    );
  }

  /// Check if a specific letter number is correctly solved
  bool isNumberSolved(int number) {
    final expectedChar = level.numberToLetterMap[number];
    return guessedLetters[number]?.toUpperCase() == expectedChar;
  }

  /// Get current character for a specific letter number
  String getLetterForNumber(int number) {
    return guessedLetters[number]?.toUpperCase() ?? '';
  }

  /// Check if a clue's word is completely solved
  bool isClueComplete(ClueData clue) {
    for (int i = 0; i < clue.letterNumbers.length; i++) {
      final num = clue.letterNumbers[i];
      final expected = clue.targetWord[i];
      if (guessedLetters[num]?.toUpperCase() != expected) {
        return false;
      }
    }
    return true;
  }

  /// Check if the main quote is completely solved
  bool isQuoteComplete() {
    for (final qw in level.quoteWords) {
      for (int i = 0; i < qw.letterNumbers.length; i++) {
        final num = qw.letterNumbers[i];
        final expected = qw.word[i];
        if (guessedLetters[num]?.toUpperCase() != expected) {
          return false;
        }
      }
    }
    return true;
  }

  /// Check if the entire level is won
  bool checkEntireLevelWon() {
    return isQuoteComplete();
  }

  /// Calculate completion progress percentage (0.0 to 1.0)
  double get progressPercentage {
    final totalNumbers = level.numberToLetterMap.length;
    if (totalNumbers == 0) return 0.0;
    int solvedCount = 0;
    level.numberToLetterMap.forEach((num, char) {
      if (guessedLetters[num]?.toUpperCase() == char) {
        solvedCount++;
      }
    });
    return (solvedCount / totalNumbers).clamp(0.0, 1.0);
  }
}
