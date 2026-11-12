class WordDefinition {
  final String word;
  final String definition;
  final String partOfSpeech;
  final String exampleSentence;
  final String etymology;

  const WordDefinition({
    required this.word,
    required this.definition,
    required this.partOfSpeech,
    required this.exampleSentence,
    required this.etymology,
  });

  Map<String, dynamic> toJson() => {
        'word': word,
        'definition': definition,
        'partOfSpeech': partOfSpeech,
        'exampleSentence': exampleSentence,
        'etymology': etymology,
      };

  factory WordDefinition.fromJson(Map<String, dynamic> json) => WordDefinition(
        word: json['word'] ?? '',
        definition: json['definition'] ?? '',
        partOfSpeech: json['partOfSpeech'] ?? '',
        exampleSentence: json['exampleSentence'] ?? '',
        etymology: json['etymology'] ?? '',
      );
}

class EducationalFact {
  final String title;
  final String historicalContext;
  final String attribution;
  final String yearOrEra;
  final String keyTakeaway;

  const EducationalFact({
    required this.title,
    required this.historicalContext,
    required this.attribution,
    required this.yearOrEra,
    required this.keyTakeaway,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'historicalContext': historicalContext,
        'attribution': attribution,
        'yearOrEra': yearOrEra,
        'keyTakeaway': keyTakeaway,
      };

  factory EducationalFact.fromJson(Map<String, dynamic> json) =>
      EducationalFact(
        title: json['title'] ?? '',
        historicalContext: json['historicalContext'] ?? '',
        attribution: json['attribution'] ?? '',
        yearOrEra: json['yearOrEra'] ?? '',
        keyTakeaway: json['keyTakeaway'] ?? '',
      );
}

class ClueData {
  final String id;
  final String clueText;
  final String targetWord; // Always uppercase
  final List<int> letterNumbers; // The assigned number for each character

  const ClueData({
    required this.id,
    required this.clueText,
    required this.targetWord,
    required this.letterNumbers,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'clueText': clueText,
        'targetWord': targetWord,
        'letterNumbers': letterNumbers,
      };

  factory ClueData.fromJson(Map<String, dynamic> json) => ClueData(
        id: json['id'] ?? '',
        clueText: json['clueText'] ?? '',
        targetWord: json['targetWord'] ?? '',
        letterNumbers: List<int>.from(json['letterNumbers'] ?? []),
      );
}

class QuoteWord {
  final String word; // Always uppercase
  final List<int> letterNumbers;

  const QuoteWord({
    required this.word,
    required this.letterNumbers,
  });

  Map<String, dynamic> toJson() => {
        'word': word,
        'letterNumbers': letterNumbers,
      };

  factory QuoteWord.fromJson(Map<String, dynamic> json) => QuoteWord(
        word: json['word'] ?? '',
        letterNumbers: List<int>.from(json['letterNumbers'] ?? []),
      );
}

class LevelData {
  final int id;
  final String title;
  final String category;
  final String classLevel; // "Class 1 - 3", "Class 4 - 5", "Class 6 - 8", "Class 9 - 10+"
  final String quoteText;
  final List<QuoteWord> quoteWords;
  final List<ClueData> clues;
  final EducationalFact educationalFact;
  final List<WordDefinition> vocabularyList;
  final int coinsReward;

  const LevelData({
    required this.id,
    required this.title,
    required this.category,
    this.classLevel = 'Class 1 - 3',
    required this.quoteText,
    required this.quoteWords,
    required this.clues,
    required this.educationalFact,
    required this.vocabularyList,
    this.coinsReward = 50,
  });

  factory LevelData.fromJson(Map<String, dynamic> json) {
    final idVal = json['id'] is int
        ? json['id'] as int
        : int.tryParse(json['id'].toString()) ?? 1;
    String computedClass = json['classLevel'] ?? '';
    if (computedClass.isEmpty) {
      if (idVal <= 10) {
        computedClass = 'Class 1 - 3';
      } else if (idVal <= 20) {
        computedClass = 'Class 4 - 5';
      } else if (idVal <= 30) {
        computedClass = 'Class 6 - 8';
      } else {
        computedClass = 'Class 9 - 10+';
      }
    }

    return LevelData(
      id: idVal,
      title: json['title'] ?? '',
      category: json['category'] ?? 'General Knowledge',
      classLevel: computedClass,
      quoteText: json['quoteText'] ?? '',
      quoteWords: (json['quoteWords'] as List<dynamic>?)
              ?.map((w) => QuoteWord.fromJson(w as Map<String, dynamic>))
              .toList() ??
          [],
      clues: (json['clues'] as List<dynamic>?)
              ?.map((c) => ClueData.fromJson(c as Map<String, dynamic>))
              .toList() ??
          [],
      educationalFact: json['educationalFact'] != null
          ? EducationalFact.fromJson(
              json['educationalFact'] as Map<String, dynamic>)
          : const EducationalFact(
              title: 'Educational Fact',
              historicalContext: '',
              attribution: '',
              yearOrEra: '',
              keyTakeaway: '',
            ),
      vocabularyList: (json['vocabularyList'] as List<dynamic>?)
              ?.map((v) => WordDefinition.fromJson(v as Map<String, dynamic>))
              .toList() ??
          [],
      coinsReward: json['coinsReward'] is int ? json['coinsReward'] : 50,
    );
  }

  // Unique mapping of letter number -> character
  Map<int, String> get numberToLetterMap {
    final map = <int, String>{};
    for (final qw in quoteWords) {
      for (int i = 0; i < qw.word.length; i++) {
        map[qw.letterNumbers[i]] = qw.word[i];
      }
    }
    for (final c in clues) {
      for (int i = 0; i < c.targetWord.length; i++) {
        map[c.letterNumbers[i]] = c.targetWord[i];
      }
    }
    return map;
  }

  // Reverse mapping of character -> assigned number (in this level)
  Map<String, int> get letterToNumberMap {
    final map = <String, int>{};
    numberToLetterMap.forEach((num, char) {
      map[char] = num;
    });
    return map;
  }
}
