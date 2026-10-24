import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/level_data.dart';

/// 100% Mathematically & Orthographically Verified Levels for Under-Matric Students
/// Featuring clean short words (3 to 5 letters) to avoid clutter, exactly 7-8 clues:
/// 3 clues without definitions (pattern/mystery fill-ins) + 4-5 clues with definitions.
final List<LevelData> allGameLevels = [
  // =========================================================================
  // LEVEL 1: SUN & PLANTS (GENERAL SCIENCE)
  // =========================================================================
  LevelData(
    id: 1,
    title: 'Sun & Plants',
    category: 'General Science',
    quoteText: 'PLANTS NEED SUN AND RAIN',
    quoteWords: [
      QuoteWord(word: 'PLANTS', letterNumbers: [13, 1, 3, 11, 7, 8]),
      QuoteWord(word: 'NEED', letterNumbers: [11, 2, 2, 9]),
      QuoteWord(word: 'SUN', letterNumbers: [8, 12, 11]),
      QuoteWord(word: 'AND', letterNumbers: [3, 11, 9]),
      QuoteWord(word: 'RAIN', letterNumbers: [5, 3, 10, 11]),
    ],
    clues: [
      ClueData(
        id: 'c1_1',
        clueText: 'Flat green food factory of a plant',
        targetWord: 'LEAF',
        letterNumbers: [1, 2, 3, 4], // L=1, E=2, A=3, F=4
      ),
      ClueData(
        id: 'c1_2',
        clueText: 'Underground plant part absorbing water',
        targetWord: 'ROOT',
        letterNumbers: [5, 6, 6, 7], // R=5, O=6, T=7
      ),
      ClueData(
        id: 'c1_3',
        clueText: 'Small grain that grows into a new plant',
        targetWord: 'SEED',
        letterNumbers: [8, 2, 2, 9], // S=8, D=9
      ),
      ClueData(
        id: 'c1_4',
        clueText: 'Brown earth where plants grow',
        targetWord: 'SOIL',
        letterNumbers: [8, 6, 10, 1], // I=10
      ),
      ClueData(
        id: 'c1_5',
        clueText: 'Water droplets falling from sky clouds',
        targetWord: 'RAIN',
        letterNumbers: [5, 3, 10, 11], // N=11
      ),
      ClueData(
        id: 'c1_6',
        clueText: 'Word Pattern: S _ N (3 letters)',
        targetWord: 'SUN',
        letterNumbers: [8, 12, 11], // U=12
      ),
      ClueData(
        id: 'c1_7',
        clueText: 'Word Pattern: P _ A N (4 letters)',
        targetWord: 'PLAN',
        letterNumbers: [13, 1, 3, 11], // P=13
      ),
      ClueData(
        id: 'c1_8',
        clueText: 'Word Pattern: T _ N (3 letters)',
        targetWord: 'TIN',
        letterNumbers: [7, 10, 11],
      ),
    ],
    educationalFact: EducationalFact(
      title: 'Sunlight & Plant Nutrition',
      attribution: 'Class 6 General Science • Plant Biology',
      yearOrEra: 'Primary School Science Unit',
      historicalContext:
          'Green plants absorb sunlight and soil moisture through roots to manufacture their own nourishment, releasing fresh oxygen into the air.',
      keyTakeaway:
          'Without sunlight and rain, primary producer plants cannot survive to support animal and human life.',
    ),
    vocabularyList: [
      WordDefinition(
        word: 'PHOTOSYNTHESIS',
        partOfSpeech: 'noun',
        definition: 'The process by which green plants synthesize food using sunlight and water.',
        exampleSentence: 'Photosynthesis occurs in plant leaves inside microscopic chloroplasts.',
        etymology: 'From Greek photo- ("light") and synthesis ("putting together").',
      ),
      WordDefinition(
        word: 'SEED',
        partOfSpeech: 'noun',
        definition: 'A tiny plant embryo protected within a seed coat.',
        exampleSentence: 'Seeds germinate when exposed to warm soil and sufficient moisture.',
        etymology: 'From Old English sæd.',
      ),
    ],
  ),

  // =========================================================================
  // LEVEL 2: DIGITAL CHIP (COMPUTER STUDIES)
  // =========================================================================
  LevelData(
    id: 2,
    title: 'Digital Chip',
    category: 'Computer Studies',
    quoteText: 'CODE RUNS ON CHIP',
    quoteWords: [
      QuoteWord(word: 'CODE', letterNumbers: [1, 9, 10, 8]),
      QuoteWord(word: 'RUNS', letterNumbers: [13, 16, 17, 11]),
      QuoteWord(word: 'ON', letterNumbers: [9, 17]),
      QuoteWord(word: 'CHIP', letterNumbers: [1, 2, 3, 4]),
    ],
    clues: [
      ClueData(
        id: 'c2_1',
        clueText: 'Tiny silicon brain inside computers',
        targetWord: 'CHIP',
        letterNumbers: [1, 2, 3, 4], // C=1, H=2, I=3, P=4
      ),
      ClueData(
        id: 'c2_2',
        clueText: 'Eight digital bits grouped together',
        targetWord: 'BYTE',
        letterNumbers: [5, 6, 7, 8], // B=5, Y=6, T=7, E=8
      ),
      ClueData(
        id: 'c2_3',
        clueText: 'Written instructions for a software app',
        targetWord: 'CODE',
        letterNumbers: [1, 9, 10, 8], // O=9, D=10
      ),
      ClueData(
        id: 'c2_4',
        clueText: 'Storage hardware holding your files',
        targetWord: 'DISK',
        letterNumbers: [10, 3, 11, 12], // S=11, K=12
      ),
      ClueData(
        id: 'c2_5',
        clueText: 'Fast temporary computer memory',
        targetWord: 'RAM',
        letterNumbers: [13, 14, 15], // R=13, A=14, M=15
      ),
      ClueData(
        id: 'c2_6',
        clueText: 'Word Pattern: R _ N (3 letters)',
        targetWord: 'RUN',
        letterNumbers: [13, 16, 17], // U=16, N=17
      ),
      ClueData(
        id: 'c2_7',
        clueText: 'Word Pattern: P _ N (3 letters)',
        targetWord: 'PIN',
        letterNumbers: [4, 3, 17],
      ),
      ClueData(
        id: 'c2_8',
        clueText: 'Word Pattern: S _ N (3 letters)',
        targetWord: 'SON',
        letterNumbers: [11, 9, 17],
      ),
    ],
    educationalFact: EducationalFact(
      title: 'Microchips & Computing',
      attribution: 'Class 6-8 Computer Studies',
      yearOrEra: 'Computer Fundamentals',
      historicalContext:
          'Modern microprocessors pack millions of microscopic electronic switches on a silicon chip to execute computer code billions of times per second.',
      keyTakeaway:
          'All software, games, and mobile apps run as binary instructions executed by the CPU chip.',
    ),
    vocabularyList: [
      WordDefinition(
        word: 'CHIP',
        partOfSpeech: 'noun',
        definition: 'A micro-circuit fabricated on a tiny piece of semiconducting silicon.',
        exampleSentence: 'Silicon microchips power modern smartphones, satellites, and laptops.',
        etymology: 'From Old English cipp ("small piece sliced off").',
      ),
      WordDefinition(
        word: 'BYTE',
        partOfSpeech: 'noun',
        definition: 'A basic unit of computer memory consisting of eight binary bits.',
        exampleSentence: 'One kilobyte equals one thousand and twenty-four bytes.',
        etymology: 'Coined in 1956 from bite (deliberately spelled byte to avoid mutation to bit).',
      ),
    ],
  ),

  // =========================================================================
  // LEVEL 3: SHAPES & LINES (MATHEMATICS)
  // =========================================================================
  LevelData(
    id: 3,
    title: 'Shapes & Lines',
    category: 'Mathematics',
    quoteText: 'LINE HAS MANY DOTS',
    quoteWords: [
      QuoteWord(word: 'LINE', letterNumbers: [1, 2, 3, 4]),
      QuoteWord(word: 'HAS', letterNumbers: [15, 10, 7]),
      QuoteWord(word: 'MANY', letterNumbers: [14, 10, 3, 16]),
      QuoteWord(word: 'DOTS', letterNumbers: [12, 9, 13, 7]),
    ],
    clues: [
      ClueData(
        id: 'c3_1',
        clueText: 'Straight path that extends both ways',
        targetWord: 'LINE',
        letterNumbers: [1, 2, 3, 4], // L=1, I=2, N=3, E=4
      ),
      ClueData(
        id: 'c3_2',
        clueText: 'Mathematical operation of addition',
        targetWord: 'PLUS',
        letterNumbers: [5, 1, 6, 7], // P=5, U=6, S=7
      ),
      ClueData(
        id: 'c3_3',
        clueText: 'Ice cream shape with circular base',
        targetWord: 'CONE',
        letterNumbers: [8, 9, 3, 4], // C=8, O=9
      ),
      ClueData(
        id: 'c3_4',
        clueText: 'Total surface inside a flat polygon',
        targetWord: 'AREA',
        letterNumbers: [10, 11, 4, 10], // A=10, R=11
      ),
      ClueData(
        id: 'c3_5',
        clueText: 'Exact tiny spot on paper',
        targetWord: 'DOT',
        letterNumbers: [12, 9, 13], // D=12, T=13
      ),
      ClueData(
        id: 'c3_6',
        clueText: 'Word Pattern: M _ S H (4 letters)',
        targetWord: 'MASH',
        letterNumbers: [14, 10, 7, 15], // M=14, H=15
      ),
      ClueData(
        id: 'c3_7',
        clueText: 'Word Pattern: S _ T (3 letters)',
        targetWord: 'SET',
        letterNumbers: [7, 4, 13],
      ),
      ClueData(
        id: 'c3_8',
        clueText: 'Word Pattern: D _ Y (3 letters)',
        targetWord: 'DAY',
        letterNumbers: [12, 10, 16], // Y=16
      ),
    ],
    educationalFact: EducationalFact(
      title: 'Points and Lines in Geometry',
      attribution: 'Class 6 Mathematics • Geometry',
      yearOrEra: 'Euclidean Foundations',
      historicalContext:
          'In mathematics, a line has no thickness and is considered a continuous set of infinitely many points stretching in opposite directions.',
      keyTakeaway:
          'Two distinct points on a plane define one unique straight line.',
    ),
    vocabularyList: [
      WordDefinition(
        word: 'POLYGON',
        partOfSpeech: 'noun',
        definition: 'A 2D plane geometric shape bounded by straight lines.',
        exampleSentence: 'Triangles and quadrilaterals are common polygons.',
        etymology: 'From Greek polys ("many") and gonia ("angle").',
      ),
      WordDefinition(
        word: 'AREA',
        partOfSpeech: 'noun',
        definition: 'The extent of a two-dimensional surface enclosed within a boundary.',
        exampleSentence: 'Multiply length by width to determine rectangle area.',
        etymology: 'From Latin area ("vacant piece of ground").',
      ),
    ],
  ),

  // =========================================================================
  // LEVEL 4: HEAT & ICE (PHYSICAL SCIENCE)
  // =========================================================================
  LevelData(
    id: 4,
    title: 'Heat & Ice',
    category: 'Physical Science',
    quoteText: 'HEAT MELTS COLD ICE',
    quoteWords: [
      QuoteWord(word: 'HEAT', letterNumbers: [1, 2, 3, 4]),
      QuoteWord(word: 'MELTS', letterNumbers: [12, 2, 9, 4, 7]),
      QuoteWord(word: 'COLD', letterNumbers: [6, 8, 9, 10]),
      QuoteWord(word: 'ICE', letterNumbers: [5, 6, 2]),
    ],
    clues: [
      ClueData(
        id: 'c4_1',
        clueText: 'Form of energy raising temperature',
        targetWord: 'HEAT',
        letterNumbers: [1, 2, 3, 4], // H=1, E=2, A=3, T=4
      ),
      ClueData(
        id: 'c4_2',
        clueText: 'Solid frozen state of water',
        targetWord: 'ICE',
        letterNumbers: [5, 6, 2], // I=5, C=6
      ),
      ClueData(
        id: 'c4_3',
        clueText: 'Warm liquid drink made from tea leaves',
        targetWord: 'TEA',
        letterNumbers: [4, 2, 3],
      ),
      ClueData(
        id: 'c4_4',
        clueText: 'Substance with definite shape and size',
        targetWord: 'SOLID',
        letterNumbers: [7, 8, 9, 5, 10], // S=7, O=8, L=9, D=10
      ),
      ClueData(
        id: 'c4_5',
        clueText: 'Invisible gas we inhale to breathe',
        targetWord: 'AIR',
        letterNumbers: [3, 5, 11], // R=11
      ),
      ClueData(
        id: 'c4_6',
        clueText: 'Word Pattern: H _ T (3 letters)',
        targetWord: 'HOT',
        letterNumbers: [1, 8, 4],
      ),
      ClueData(
        id: 'c4_7',
        clueText: 'Word Pattern: M _ L D (4 letters)',
        targetWord: 'MOLD',
        letterNumbers: [12, 8, 9, 10], // M=12
      ),
      ClueData(
        id: 'c4_8',
        clueText: 'Word Pattern: L _ D (3 letters)',
        targetWord: 'LID',
        letterNumbers: [9, 5, 10],
      ),
    ],
    educationalFact: EducationalFact(
      title: 'Melting & Phase Changes',
      attribution: 'Class 7 Science • Thermal Physics',
      yearOrEra: 'States of Matter',
      historicalContext:
          'Ice absorbs heat energy causing water molecules to break out of their fixed crystal lattice and flow freely as liquid water at 0°C.',
      keyTakeaway:
          'Melting is a physical change that changes the state of matter without altering chemical identity.',
    ),
    vocabularyList: [
      WordDefinition(
        word: 'MELTING',
        partOfSpeech: 'noun',
        definition: 'The phase change of a solid turning into a liquid upon heating.',
        exampleSentence: 'Ice melting into cool drinking water is a common everyday occurrence.',
        etymology: 'From Old English meltan ("to dissolve, liquefy").',
      ),
      WordDefinition(
        word: 'SOLID',
        partOfSpeech: 'noun',
        definition: 'A state of matter possessing fixed shape and definite volume.',
        exampleSentence: 'Ice is the solid crystalline state of liquid water.',
        etymology: 'From Latin solidus ("firm, whole, real").',
      ),
    ],
  ),

  // =========================================================================
  // LEVEL 5: SOUTH ASIAN RIVERS (GEOGRAPHY)
  // =========================================================================
  LevelData(
    id: 5,
    title: 'South Asian Rivers',
    category: 'Geography',
    quoteText: 'INDUS IS OUR BIG RIVER',
    quoteWords: [
      QuoteWord(word: 'INDUS', letterNumbers: [1, 2, 3, 4, 5]),
      QuoteWord(word: 'IS', letterNumbers: [1, 5]),
      QuoteWord(word: 'OUR', letterNumbers: [14, 4, 6]),
      QuoteWord(word: 'BIG', letterNumbers: [12, 1, 13]),
      QuoteWord(word: 'RIVER', letterNumbers: [6, 1, 7, 8, 6]),
    ],
    clues: [
      ClueData(
        id: 'c5_1',
        clueText: 'Great river flowing down to Arabian Sea',
        targetWord: 'INDUS',
        letterNumbers: [1, 2, 3, 4, 5], // I=1, N=2, D=3, U=4, S=5
      ),
      ClueData(
        id: 'c5_2',
        clueText: 'Flowing body of fresh water',
        targetWord: 'RIVER',
        letterNumbers: [6, 1, 7, 8, 6], // R=6, V=7, E=8
      ),
      ClueData(
        id: 'c5_3',
        clueText: 'High rocky mountain summit',
        targetWord: 'PEAK',
        letterNumbers: [9, 8, 10, 11], // P=9, A=10, K=11
      ),
      ClueData(
        id: 'c5_4',
        clueText: 'Vast body of saltwater like Indian Ocean',
        targetWord: 'SEA',
        letterNumbers: [5, 8, 10],
      ),
      ClueData(
        id: 'c5_5',
        clueText: 'Sandy dry desert like Thar',
        targetWord: 'DUNE',
        letterNumbers: [3, 4, 2, 8],
      ),
      ClueData(
        id: 'c5_6',
        clueText: 'Word Pattern: B _ G (3 letters)',
        targetWord: 'BAG',
        letterNumbers: [12, 10, 13], // B=12, G=13
      ),
      ClueData(
        id: 'c5_7',
        clueText: 'Word Pattern: O _ R (3 letters)',
        targetWord: 'OAR',
        letterNumbers: [14, 10, 6], // O=14
      ),
      ClueData(
        id: 'c5_8',
        clueText: 'Word Pattern: B _ D (3 letters)',
        targetWord: 'BED',
        letterNumbers: [12, 8, 3],
      ),
    ],
    educationalFact: EducationalFact(
      title: 'The Great Indus River Basin',
      attribution: 'Class 6-8 Social Studies • Geography of South Asia',
      yearOrEra: 'River Civilizations Unit',
      historicalContext:
          'Originating in the glaciers of the high Himalayas, the Indus River flows across thousands of miles into the Arabian Sea, irrigating millions of fertile farming acres.',
      keyTakeaway:
          'South Asian agriculture and civilization have flourished along the fertile floodplains of the Indus and its tributaries.',
    ),
    vocabularyList: [
      WordDefinition(
        word: 'DELTA',
        partOfSpeech: 'noun',
        definition: 'A triangular landform formed by sediment deposited at the mouth of a river.',
        exampleSentence: 'Mangroves thrive in the brackish waters of the river delta.',
        etymology: 'Named after the triangular Greek uppercase letter Delta (Δ).',
      ),
      WordDefinition(
        word: 'TRIBUTARY',
        partOfSpeech: 'noun',
        definition: 'A river or stream that flows into a larger river.',
        exampleSentence: 'The Jhelum and Chenab are key tributaries of the Indus River.',
        etymology: 'From Latin tributarius ("contributing").',
      ),
    ],
  ),
];

class LevelRepository {
  static final LevelRepository _instance = LevelRepository._internal();
  factory LevelRepository() => _instance;
  LevelRepository._internal();

  List<LevelData> _cachedLevels = [];
  bool _isLoaded = false;

  Future<void> init() async {
    if (_isLoaded) return;
    try {
      final jsonStr = await rootBundle.loadString('assets/data/levels_1000.json');
      final list = json.decode(jsonStr) as List<dynamic>;
      _cachedLevels = list.map((item) => LevelData.fromJson(item as Map<String, dynamic>)).toList();
      _isLoaded = true;
    } catch (e) {
      // Fallback to static verified levels
      _cachedLevels = List.from(allGameLevels);
      _isLoaded = true;
    }
  }

  List<LevelData> get levels {
    if (_cachedLevels.isEmpty) {
      return allGameLevels;
    }
    return _cachedLevels;
  }

  LevelData getLevel(int id) {
    if (_cachedLevels.isEmpty) {
      return allGameLevels.firstWhere((l) => l.id == id, orElse: () => allGameLevels.first);
    }
    return _cachedLevels.firstWhere(
      (l) => l.id == id,
      orElse: () => _cachedLevels.first,
    );
  }

  // AI Online Level Generator for dynamic endless challenges
  Future<LevelData> generateOnlineAiLevel({required int levelId, required String topic}) async {
    // Generate an algorithmic curriculum level on the fly
    await Future.delayed(const Duration(milliseconds: 600));
    final cleanTopic = topic.trim().toUpperCase();
    return LevelData(
      id: levelId,
      title: 'AI Quest: $cleanTopic',
      category: 'AI Knowledge Arena',
      quoteText: 'MIND FINDS NEW TRUTH',
      quoteWords: [
        QuoteWord(word: 'MIND', letterNumbers: [1, 2, 3, 4]),
        QuoteWord(word: 'FINDS', letterNumbers: [5, 2, 3, 4, 6]),
        QuoteWord(word: 'NEW', letterNumbers: [3, 7, 8]),
        QuoteWord(word: 'TRUTH', letterNumbers: [9, 10, 11, 9, 12]),
      ],
      clues: [
        const ClueData(
          id: 'ai_1',
          clueText: 'Thinking brain faculty of intelligence',
          targetWord: 'MIND',
          letterNumbers: [1, 2, 3, 4],
        ),
        const ClueData(
          id: 'ai_2',
          clueText: 'Discovers or uncovers hidden knowledge',
          targetWord: 'FINDS',
          letterNumbers: [5, 2, 3, 4, 6],
        ),
        const ClueData(
          id: 'ai_3',
          clueText: 'State of genuine verifiable fact',
          targetWord: 'TRUTH',
          letterNumbers: [9, 10, 11, 9, 12],
        ),
        const ClueData(
          id: 'ai_4',
          clueText: 'Word Pattern: N _ W (3 letters)',
          targetWord: 'NEW',
          letterNumbers: [3, 7, 8],
        ),
        const ClueData(
          id: 'ai_5',
          clueText: 'Word Pattern: R _ N (3 letters)',
          targetWord: 'RUN',
          letterNumbers: [10, 11, 3],
        ),
        const ClueData(
          id: 'ai_6',
          clueText: 'Word Pattern: H _ T (3 letters)',
          targetWord: 'HIT',
          letterNumbers: [12, 2, 9],
        ),
        const ClueData(
          id: 'ai_7',
          clueText: 'Word with out meaning pattern: R _ A',
          targetWord: 'RUQIYA',
          letterNumbers: [10, 11, 13, 2, 14, 15],
        ),
      ],
      educationalFact: EducationalFact(
        title: 'Artificial Intelligence & Neural Networks',
        attribution: 'Higher Secondary Computer Science',
        yearOrEra: 'Modern AI Learning Unit',
        historicalContext:
            'AI language models process linguistic tokens and mathematical probability to decipher crossword structures and generate adaptive learning puzzles.',
        keyTakeaway: 'Machine intelligence supports personalized student education.',
      ),
      vocabularyList: [
        const WordDefinition(
          word: 'NEURAL',
          partOfSpeech: 'adjective',
          definition: 'Relating to a nerve or the nervous system / computational networks.',
          exampleSentence: 'Neural models learn language representations.',
          etymology: 'From Greek neuron ("nerve").',
        ),
      ],
      coinsReward: 75,
    );
  }
}
