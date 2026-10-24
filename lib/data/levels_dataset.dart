import '../models/level_data.dart';

/// 100% Mathematically & Orthographically Verified Levels for Under-Matric Students
/// Curated for Grade 6-10 Curriculum in Pakistan, India, Bangladesh, and Sri Lanka.
/// Subjects: General Science (Biology, Physics, Chemistry, Astronomy), Mathematics, Computer Studies, Regional Geography.
final List<LevelData> allGameLevels = [
  // =========================================================================
  // LEVEL 1: GENERAL SCIENCE (BIOLOGY - PHOTOSYNTHESIS & PLANTS)
  // =========================================================================
  LevelData(
    id: 1,
    title: 'Plant Photosynthesis',
    category: 'General Science',
    quoteText: 'GREEN PLANTS PRODUCE FOOD',
    quoteWords: [
      QuoteWord(word: 'GREEN', letterNumbers: [13, 5, 2, 2, 15]),
      QuoteWord(word: 'PLANTS', letterNumbers: [14, 1, 3, 15, 7, 8]),
      QuoteWord(word: 'PRODUCE', letterNumbers: [14, 5, 6, 10, 12, 11, 2]),
      QuoteWord(word: 'FOOD', letterNumbers: [4, 6, 6, 10]),
    ],
    clues: [
      ClueData(
        id: 'clue_1_1',
        clueText: 'Green food-producing factory of a plant',
        targetWord: 'LEAF',
        letterNumbers: [1, 2, 3, 4], // L=1, E=2, A=3, F=4
      ),
      ClueData(
        id: 'clue_1_2',
        clueText: 'Underground organ absorbing water and minerals',
        targetWord: 'ROOT',
        letterNumbers: [5, 6, 6, 7], // R=5, O=6, T=7
      ),
      ClueData(
        id: 'clue_1_3',
        clueText: 'Plant axis supporting leaves and flowers',
        targetWord: 'STEM',
        letterNumbers: [8, 7, 2, 9], // S=8, M=9
      ),
      ClueData(
        id: 'clue_1_4',
        clueText: 'Embryonic plant enclosed in a protective coat',
        targetWord: 'SEED',
        letterNumbers: [8, 2, 2, 10], // D=10
      ),
      ClueData(
        id: 'clue_1_5',
        clueText: 'Microscopic building block of all living cells',
        targetWord: 'CELL',
        letterNumbers: [11, 2, 1, 1], // C=11
      ),
      ClueData(
        id: 'clue_1_6',
        clueText: 'Sweet soluble carbohydrate produced during photosynthesis',
        targetWord: 'SUGAR',
        letterNumbers: [8, 12, 13, 3, 5], // U=12, G=13
      ),
      ClueData(
        id: 'clue_1_7',
        clueText: 'Small body of still water supporting aquatic ecosystem',
        targetWord: 'POND',
        letterNumbers: [14, 6, 15, 10], // P=14, N=15
      ),
      ClueData(
        id: 'clue_1_8',
        clueText: 'Upper fertile layer of earth where roots grow',
        targetWord: 'SOIL',
        letterNumbers: [8, 6, 16, 1], // I=16
      ),
    ],
    educationalFact: EducationalFact(
      title: 'Photosynthesis & Solar Plant Energy',
      attribution: 'Class 6-9 General Science • Biology Curriculum',
      yearOrEra: 'Primary School Science Unit',
      historicalContext:
          'Plants utilize solar radiation, water from roots, and atmospheric carbon dioxide inside chloroplasts containing chlorophyll to produce glucose and release clean oxygen.',
      keyTakeaway:
          'Green plants are the primary producers of the terrestrial food chain, sustaining all animal and human life on Earth.',
    ),
    vocabularyList: [
      WordDefinition(
        word: 'PHOTOSYNTHESIS',
        partOfSpeech: 'noun',
        definition: 'The biological process by which autotrophic plants synthesize glucose from carbon dioxide and water using sunlight.',
        exampleSentence: 'Photosynthesis in green leaves converts light energy into chemical energy.',
        etymology: 'From Greek photo- ("light") and synthesis ("putting together").',
      ),
      WordDefinition(
        word: 'CHLOROPHYLL',
        partOfSpeech: 'noun',
        definition: 'The green pigment present in all autotrophic plants which absorbs solar light energy.',
        exampleSentence: 'Chlorophyll molecules capture red and blue wavelengths while reflecting green light.',
        etymology: 'From Greek chloros ("pale green") and phyllon ("leaf").',
      ),
      WordDefinition(
        word: 'STOMATA',
        partOfSpeech: 'noun (plural)',
        definition: 'Microscopic cellular apertures on the epidermis of leaves that regulate gas exchange and transpiration.',
        exampleSentence: 'Guard cells control the opening and closing of stomata to prevent dehydration.',
        etymology: 'From Greek stoma ("mouth").',
      ),
      WordDefinition(
        word: 'GLUCOSE',
        partOfSpeech: 'noun',
        definition: 'A simple hexose monosaccharide sugar that serves as an essential source of energy in living organisms.',
        exampleSentence: 'Surplus glucose produced during the day is stored by plants as insoluble starch.',
        etymology: 'From Greek gleukos ("sweet wine").',
      ),
    ],
  ),

  // =========================================================================
  // LEVEL 2: COMPUTER STUDIES (CLASS 6-10 COMPUTER EDUCATION)
  // =========================================================================
  LevelData(
    id: 2,
    title: 'Computer Architecture',
    category: 'Computer Science',
    quoteText: 'CPU IS THE BRAIN OF COMPUTER',
    quoteWords: [
      QuoteWord(word: 'CPU', letterNumbers: [6, 14, 3]),
      QuoteWord(word: 'IS', letterNumbers: [13, 4]),
      QuoteWord(word: 'THE', letterNumbers: [11, 12, 5]),
      QuoteWord(word: 'BRAIN', letterNumbers: [9, 7, 16, 13, 8]),
      QuoteWord(word: 'OF', letterNumbers: [2, 15]),
      QuoteWord(word: 'COMPUTER', letterNumbers: [6, 2, 1, 14, 3, 11, 5, 7]),
    ],
    clues: [
      ClueData(
        id: 'clue_2_1',
        clueText: 'Handheld pointing device used to click on monitor',
        targetWord: 'MOUSE',
        letterNumbers: [1, 2, 3, 4, 5], // M=1, O=2, U=3, S=4, E=5
      ),
      ClueData(
        id: 'clue_2_2',
        clueText: 'Display monitor showing visual output to user',
        targetWord: 'SCREEN',
        letterNumbers: [4, 6, 7, 5, 5, 8], // C=6, R=7, N=8
      ),
      ClueData(
        id: 'clue_2_3',
        clueText: 'Group of eight bits representing a character',
        targetWord: 'BYTE',
        letterNumbers: [9, 10, 11, 5], // B=9, Y=10, T=11
      ),
      ClueData(
        id: 'clue_2_4',
        clueText: 'Tiny silicon wafer containing electronic microcircuits',
        targetWord: 'CHIP',
        letterNumbers: [6, 12, 13, 14], // H=12, I=13, P=14
      ),
      ClueData(
        id: 'clue_2_5',
        clueText: 'Style and design of typographic text characters',
        targetWord: 'FONT',
        letterNumbers: [15, 2, 8, 11], // F=15
      ),
      ClueData(
        id: 'clue_2_6',
        clueText: 'Produce physical hard copy of digital documents on paper',
        targetWord: 'PRINT',
        letterNumbers: [14, 7, 13, 8, 11],
      ),
      ClueData(
        id: 'clue_2_7',
        clueText: 'Fast primary memory storing running programs temporarily',
        targetWord: 'RAM',
        letterNumbers: [7, 16, 1], // A=16
      ),
      ClueData(
        id: 'clue_2_8',
        clueText: 'Data or instructions entered into a computer system',
        targetWord: 'INPUT',
        letterNumbers: [13, 8, 14, 3, 11],
      ),
    ],
    educationalFact: EducationalFact(
      title: 'Von Neumann Architecture & The Microprocessor',
      attribution: 'Class 6-10 Computer Studies Syllabus',
      yearOrEra: 'Computer Fundamentals',
      historicalContext:
          'The Central Processing Unit (CPU) contains the Arithmetic Logic Unit (ALU) and Control Unit (CU), coordinating with Random Access Memory (RAM) to execute millions of instructions per second.',
      keyTakeaway:
          'Every smart device, laptop, and calculator relies on the fundamental CPU cycle: Fetch, Decode, and Execute.',
    ),
    vocabularyList: [
      WordDefinition(
        word: 'HARDWARE',
        partOfSpeech: 'noun',
        definition: 'The tangible physical and electronic components of a computer system.',
        exampleSentence: 'The motherboard, hard disk, and keyboard are essential hardware components.',
        etymology: 'From Old English heard ("hard") + waru ("goods, commodities").',
      ),
      WordDefinition(
        word: 'SOFTWARE',
        partOfSpeech: 'noun',
        definition: 'The organized set of computer programs, procedures, and operating systems.',
        exampleSentence: 'Operating systems such as Linux and Windows manage application software.',
        etymology: 'Formed in 1953 by analogy with hardware.',
      ),
      WordDefinition(
        word: 'ALGORITHM',
        partOfSpeech: 'noun',
        definition: 'A finite, unambiguous sequence of logical steps designed to solve a computational problem.',
        exampleSentence: 'Search algorithms rapidly retrieve query results from massive databases.',
        etymology: 'Named after 9th-century Persian mathematician Muhammad ibn Musa al-Khwarizmi.',
      ),
      WordDefinition(
        word: 'BINARY',
        partOfSpeech: 'adjective',
        definition: 'A base-2 positional numeral system using only two discrete symbols: 0 and 1.',
        exampleSentence: 'Digital logic circuits represent binary 1 as high voltage and 0 as low voltage.',
        etymology: 'From Latin binarius ("consisting of two").',
      ),
    ],
  ),

  // =========================================================================
  // LEVEL 3: MATHEMATICS (GEOMETRY & ARITHMETIC)
  // =========================================================================
  LevelData(
    id: 3,
    title: 'Geometry & Shapes',
    category: 'Mathematics',
    quoteText: 'SUM OF TRIANGLE ANGLES IS FIXED',
    quoteWords: [
      QuoteWord(word: 'SUM', letterNumbers: [10, 9, 15]),
      QuoteWord(word: 'OF', letterNumbers: [14, 11]),
      QuoteWord(word: 'TRIANGLE', letterNumbers: [13, 6, 8, 1, 2, 3, 4, 5]),
      QuoteWord(word: 'ANGLES', letterNumbers: [1, 2, 3, 4, 5, 10]),
      QuoteWord(word: 'IS', letterNumbers: [8, 10]),
      QuoteWord(word: 'FIXED', letterNumbers: [11, 8, 18, 5, 7]),
    ],
    clues: [
      ClueData(
        id: 'clue_3_1',
        clueText: 'Geometric figure formed by two rays sharing a vertex',
        targetWord: 'ANGLE',
        letterNumbers: [1, 2, 3, 4, 5], // A=1, N=2, G=3, L=4, E=5
      ),
      ClueData(
        id: 'clue_3_2',
        clueText: 'Distance from center of circle to its boundary edge',
        targetWord: 'RADIUS',
        letterNumbers: [6, 1, 7, 8, 9, 10], // R=6, D=7, I=8, U=9, S=10
      ),
      ClueData(
        id: 'clue_3_3',
        clueText: 'Part of a whole represented as numerator over denominator',
        targetWord: 'FRACTION',
        letterNumbers: [11, 6, 1, 12, 13, 8, 14, 2], // F=11, C=12, T=13, O=14
      ),
      ClueData(
        id: 'clue_3_4',
        clueText: 'Mathematical symbol denoting operation of subtraction',
        targetWord: 'MINUS',
        letterNumbers: [15, 8, 2, 9, 10], // M=15
      ),
      ClueData(
        id: 'clue_3_5',
        clueText: 'Visual chart representing equations or statistical data',
        targetWord: 'GRAPH',
        letterNumbers: [3, 6, 1, 16, 17], // P=16, H=17
      ),
      ClueData(
        id: 'clue_3_6',
        clueText: 'Exact dimensionless location in space having no length',
        targetWord: 'POINT',
        letterNumbers: [16, 14, 8, 2, 13],
      ),
      ClueData(
        id: 'clue_3_7',
        clueText: 'Reference line on a Cartesian coordinate plane',
        targetWord: 'AXIS',
        letterNumbers: [1, 18, 8, 10], // X=18
      ),
      ClueData(
        id: 'clue_3_8',
        clueText: 'Any individual numeral from zero through nine',
        targetWord: 'DIGIT',
        letterNumbers: [7, 8, 3, 8, 13],
      ),
    ],
    educationalFact: EducationalFact(
      title: 'Angle Sum Theorem of Triangles',
      attribution: 'Class 6-9 Mathematics Curriculum',
      yearOrEra: 'Euclidean Geometry Unit',
      historicalContext:
          'On a flat two-dimensional Euclidean plane, the three interior angles of any triangle (acute, right, or obtuse) invariably sum up to exactly 180 degrees.',
      keyTakeaway:
          'If you know any two interior angles of a triangle, you can always calculate the third by subtracting their sum from 180°.',
    ),
    vocabularyList: [
      WordDefinition(
        word: 'HYPOTENUSE',
        partOfSpeech: 'noun',
        definition: 'The longest side of a right-angled triangle, opposite the ninety-degree right angle.',
        exampleSentence: 'According to the Pythagorean theorem, hypotenuse squared equals the sum of squares of the legs.',
        etymology: 'From Greek hypoteinousa ("stretching under").',
      ),
      WordDefinition(
        word: 'PERIMETER',
        partOfSpeech: 'noun',
        definition: 'The total length of the continuous boundary enclosing a closed geometric plane figure.',
        exampleSentence: 'To fence the rectangular field, farmers calculated its total perimeter.',
        etymology: 'From Greek peri- ("around") and metron ("measure").',
      ),
      WordDefinition(
        word: 'POLYGON',
        partOfSpeech: 'noun',
        definition: 'A closed two-dimensional figure bounded by three or more straight coplanar line segments.',
        exampleSentence: 'Triangles, squares, pentagons, and hexagons are classic examples of polygons.',
        etymology: 'From Greek polys ("many") and gonia ("angle, corner").',
      ),
      WordDefinition(
        word: 'EQUATION',
        partOfSpeech: 'noun',
        definition: 'A mathematical formula stating that two algebraic expressions are equivalent with an equal sign.',
        exampleSentence: 'Solving the quadratic equation yielded two distinct real roots.',
        etymology: 'From Latin aequatio ("equalization, making equal").',
      ),
    ],
  ),

  // =========================================================================
  // LEVEL 4: PHYSICAL SCIENCES (STATES OF MATTER & CHEMISTRY)
  // =========================================================================
  LevelData(
    id: 4,
    title: 'States of Matter',
    category: 'Physics & Chemistry',
    quoteText: 'MATTER HAS MASS AND VOLUME',
    quoteWords: [
      QuoteWord(word: 'MATTER', letterNumbers: [4, 1, 2, 2, 10, 13]),
      QuoteWord(word: 'HAS', letterNumbers: [9, 1, 5]),
      QuoteWord(word: 'MASS', letterNumbers: [4, 1, 5, 5]),
      QuoteWord(word: 'AND', letterNumbers: [1, 14, 8]),
      QuoteWord(word: 'VOLUME', letterNumbers: [11, 3, 6, 16, 4, 10]),
    ],
    clues: [
      ClueData(
        id: 'clue_4_1',
        clueText: 'Smallest fundamental particle of a chemical element',
        targetWord: 'ATOM',
        letterNumbers: [1, 2, 3, 4], // A=1, T=2, O=3, M=4
      ),
      ClueData(
        id: 'clue_4_2',
        clueText: 'State of matter having rigid definite shape and volume',
        targetWord: 'SOLID',
        letterNumbers: [5, 3, 6, 7, 8], // S=5, L=6, I=7, D=8
      ),
      ClueData(
        id: 'clue_4_3',
        clueText: 'Form of thermal energy that raises temperature',
        targetWord: 'HEAT',
        letterNumbers: [9, 10, 1, 2], // H=9, E=10
      ),
      ClueData(
        id: 'clue_4_4',
        clueText: 'Gaseous state of water produced by boiling or evaporation',
        targetWord: 'VAPOR',
        letterNumbers: [11, 1, 12, 3, 13], // V=11, P=12, R=13
      ),
      ClueData(
        id: 'clue_4_5',
        clueText: 'Transparent curved optical glass that refracts light',
        targetWord: 'LENS',
        letterNumbers: [6, 10, 14, 5], // N=14
      ),
      ClueData(
        id: 'clue_4_6',
        clueText: 'Substance such as liquid or gas that flows smoothly',
        targetWord: 'FLUID',
        letterNumbers: [15, 6, 16, 7, 8], // F=15, U=16
      ),
      ClueData(
        id: 'clue_4_7',
        clueText: 'Mechanical vibration propagating as acoustic pressure waves',
        targetWord: 'SOUND',
        letterNumbers: [5, 3, 16, 14, 8],
      ),
      ClueData(
        id: 'clue_4_8',
        clueText: 'Shiny element that conducts electricity and heat efficiently',
        targetWord: 'METAL',
        letterNumbers: [4, 10, 2, 1, 6],
      ),
    ],
    educationalFact: EducationalFact(
      title: 'Properties & Three Classical States of Matter',
      attribution: 'Class 7-9 General Science Curriculum',
      yearOrEra: 'Physical Sciences Module',
      historicalContext:
          'Matter is defined as anything that possesses mass and occupies physical space. In solids, particles vibrate in place; in liquids, they slide over one another; in gases, they move freely at high velocity.',
      keyTakeaway:
          'Phase transitions (melting, boiling, condensation, freezing) occur through heat absorption or release without changing chemical composition.',
    ),
    vocabularyList: [
      WordDefinition(
        word: 'DENSITY',
        partOfSpeech: 'noun',
        definition: 'The mass of a substance per unit volume (calculated as mass divided by volume).',
        exampleSentence: 'An iron nail sinks in water because its density exceeds that of liquid water.',
        etymology: 'From Latin densitas ("thickness, compactness").',
      ),
      WordDefinition(
        word: 'EVAPORATION',
        partOfSpeech: 'noun',
        definition: 'The spontaneous phase change of a liquid into gaseous vapor occurring at its surface below boiling point.',
        exampleSentence: 'Earthen water pots keep water cool through continuous surface evaporation.',
        etymology: 'From Latin evaporare ("disperse in vapor").',
      ),
      WordDefinition(
        word: 'CONDUCTOR',
        partOfSpeech: 'noun',
        definition: 'A material or medium that freely permits the transmission of electrical charge or thermal energy.',
        exampleSentence: 'Copper and aluminum wires are superior electrical conductors used in transmission grids.',
        etymology: 'From Latin conducere ("to lead or bring together").',
      ),
      WordDefinition(
        word: 'MOLECULE',
        partOfSpeech: 'noun',
        definition: 'An electrically neutral group of two or more atoms held firmly together by chemical covalent bonds.',
        exampleSentence: 'A water molecule consists of two hydrogen atoms bonded to one oxygen atom.',
        etymology: 'From Latin molecula, diminutive of moles ("mass").',
      ),
    ],
  ),

  // =========================================================================
  // LEVEL 5: SOUTH ASIAN GEOGRAPHY (PAKISTAN, INDIA, BANGLADESH, SRI LANKA)
  // =========================================================================
  LevelData(
    id: 5,
    title: 'Rivers & Climate of South Asia',
    category: 'Geography & Social Studies',
    quoteText: 'MONSOON RAIN FEEDS SOUTH ASIA',
    quoteWords: [
      QuoteWord(word: 'MONSOON', letterNumbers: [11, 14, 2, 5, 14, 14, 2]),
      QuoteWord(word: 'RAIN', letterNumbers: [15, 9, 1, 2]),
      QuoteWord(word: 'FEEDS', letterNumbers: [13, 6, 6, 3, 5]),
      QuoteWord(word: 'SOUTH', letterNumbers: [5, 14, 4, 8, 10]),
      QuoteWord(word: 'ASIA', letterNumbers: [9, 5, 1, 9]),
    ],
    clues: [
      ClueData(
        id: 'clue_5_1',
        clueText: 'Mighty river flowing from Himalayas through Pakistan to Arabian Sea',
        targetWord: 'INDUS',
        letterNumbers: [1, 2, 3, 4, 5], // I=1, N=2, D=3, U=4, S=5
      ),
      ClueData(
        id: 'clue_5_2',
        clueText: 'Fertile triangular landform formed by sediment at river mouth',
        targetWord: 'DELTA',
        letterNumbers: [3, 6, 7, 8, 9], // E=6, L=7, T=8, A=9
      ),
      ClueData(
        id: 'clue_5_3',
        clueText: 'Landmass completely encircled by water, like Sri Lanka',
        targetWord: 'ISLAND',
        letterNumbers: [1, 5, 7, 9, 2, 3],
      ),
      ClueData(
        id: 'clue_5_4',
        clueText: 'Majestic mountain range featuring Mount Everest and K2',
        targetWord: 'HIMALAYA',
        letterNumbers: [10, 1, 11, 9, 7, 9, 12, 9], // H=10, M=11, Y=12
      ),
      ClueData(
        id: 'clue_5_5',
        clueText: 'Lush woodland ecosystem like Bengal Sundarbans mangrove',
        targetWord: 'FOREST',
        letterNumbers: [13, 14, 15, 6, 5, 8], // F=13, O=14, R=15
      ),
      ClueData(
        id: 'clue_5_6',
        clueText: 'Expansive saltwater body south of subcontinent (Indian Ocean)',
        targetWord: 'OCEAN',
        letterNumbers: [14, 16, 6, 9, 2], // C=16
      ),
      ClueData(
        id: 'clue_5_7',
        clueText: 'Arid sandy geographic region like Thar and Cholistan',
        targetWord: 'DESERT',
        letterNumbers: [3, 6, 5, 6, 15, 8],
      ),
      ClueData(
        id: 'clue_5_8',
        clueText: 'Freshwater stream flowing continuously down to the sea',
        targetWord: 'RIVER',
        letterNumbers: [15, 1, 17, 6, 15], // V=17
      ),
    ],
    educationalFact: EducationalFact(
      title: 'Monsoon Winds & River Basins of South Asia',
      attribution: 'Class 6-10 Social Studies • South Asian Geography',
      yearOrEra: 'Subcontinental Geography Unit',
      historicalContext:
          'South Asia is bound by the towering Himalayas and the Indian Ocean. The seasonal Southwest Monsoon brings vital rains between June and September, recharging the Indus, Ganges, Brahmaputra, Padma, and Mahaweli river basins.',
      keyTakeaway:
          'Agriculture across Pakistan, India, Bangladesh, and Sri Lanka depends directly on the rhythm of monsoon rains and fertile alluvial floodplains.',
    ),
    vocabularyList: [
      WordDefinition(
        word: 'TRIBUTARY',
        partOfSpeech: 'noun',
        definition: 'A freshwater river or tributary stream flowing into a larger main stem river.',
        exampleSentence: 'The Jhelum, Chenab, Ravi, and Sutlej rivers are primary tributaries of the Indus River.',
        etymology: 'From Latin tributarius ("paying tribute, contributory").',
      ),
      WordDefinition(
        word: 'ALLUVIAL',
        partOfSpeech: 'adjective',
        definition: 'Pertaining to soil composed of nutrient-rich clay, silt, and gravel left by overflowing rivers.',
        exampleSentence: 'Alluvial plains in Punjab and Bengal yield bumper crops of wheat and basmati rice.',
        etymology: 'From Latin alluvio ("overflowing of water, alluvial flood").',
      ),
      WordDefinition(
        word: 'PLATEAU',
        partOfSpeech: 'noun',
        definition: 'A wide, elevated expanse of relatively level land bounded on one or more sides by steep slopes.',
        exampleSentence: 'The Potohar and Deccan plateaus are key geographic features of South Asia.',
        etymology: 'From Old French plat ("flat").',
      ),
      WordDefinition(
        word: 'MANGROVE',
        partOfSpeech: 'noun',
        definition: 'A salt-tolerant halophytic shrub or tree that grows in littoral coastal saline or brackish water.',
        exampleSentence: 'The Sundarbans mangrove forest shields coastal communities from fierce ocean cyclones.',
        etymology: 'From Portuguese mangue or Spanish mangle.',
      ),
    ],
  ),

  // =========================================================================
  // LEVEL 6: GENERAL SCIENCE (ASTRONOMY & THE SOLAR SYSTEM)
  // =========================================================================
  LevelData(
    id: 6,
    title: 'The Solar System',
    category: 'Astronomy & Space',
    quoteText: 'EARTH REVOLVES AROUND SUN',
    quoteWords: [
      QuoteWord(word: 'EARTH', letterNumbers: [5, 3, 9, 6, 15]),
      QuoteWord(word: 'REVOLVES', letterNumbers: [9, 5, 16, 8, 2, 16, 5, 7]),
      QuoteWord(word: 'AROUND', letterNumbers: [3, 9, 8, 14, 4, 13]),
      QuoteWord(word: 'SUN', letterNumbers: [7, 14, 4]),
    ],
    clues: [
      ClueData(
        id: 'clue_6_1',
        clueText: 'Large celestial body orbiting a star in clear path',
        targetWord: 'PLANET',
        letterNumbers: [1, 2, 3, 4, 5, 6], // P=1, L=2, A=3, N=4, E=5, T=6
      ),
      ClueData(
        id: 'clue_6_2',
        clueText: 'Radiant light and heat energy emitted by our Sun',
        targetWord: 'SOLAR',
        letterNumbers: [7, 8, 2, 3, 9], // S=7, O=8, R=9
      ),
      ClueData(
        id: 'clue_6_3',
        clueText: 'Earth\'s natural celestial satellite causing ocean tides',
        targetWord: 'MOON',
        letterNumbers: [10, 8, 8, 4], // M=10
      ),
      ClueData(
        id: 'clue_6_4',
        clueText: 'Curved gravitational trajectory of a planet or satellite',
        targetWord: 'ORBIT',
        letterNumbers: [8, 9, 11, 12, 6], // B=11, I=12
      ),
      ClueData(
        id: 'clue_6_5',
        clueText: 'Microscopic cosmic matter floating between planets in space',
        targetWord: 'DUST',
        letterNumbers: [13, 14, 7, 6], // D=13, U=14
      ),
      ClueData(
        id: 'clue_6_6',
        clueText: 'Sky and celestial sphere visible from Earth surface',
        targetWord: 'HEAVEN',
        letterNumbers: [15, 5, 3, 16, 5, 4], // H=15, V=16
      ),
      ClueData(
        id: 'clue_6_7',
        clueText: 'Massive glowing sphere of plasma held together by gravity',
        targetWord: 'STAR',
        letterNumbers: [7, 6, 3, 9],
      ),
      ClueData(
        id: 'clue_6_8',
        clueText: 'Second planet from Sun known as the brilliant evening star',
        targetWord: 'VENUS',
        letterNumbers: [16, 5, 4, 14, 7],
      ),
    ],
    educationalFact: EducationalFact(
      title: 'Heliocentric Orbit & Planetary Motion',
      attribution: 'Class 6-8 General Science • Astronomy Curriculum',
      yearOrEra: 'Space Sciences Unit',
      historicalContext:
          'Earth revolves around the Sun in an elliptical orbit once every 365.25 days, creating the four seasons, while rotating on its tilted axis every 24 hours to generate day and night.',
      keyTakeaway:
          'Gravity is the universal attractive force that anchors planets, moons, asteroids, and comets in orderly orbits around the Sun.',
    ),
    vocabularyList: [
      WordDefinition(
        word: 'ECLIPSE',
        partOfSpeech: 'noun',
        definition: 'The total or partial obscuring of one celestial body by another when alignment blocks incoming light.',
        exampleSentence: 'During a solar eclipse, the Moon casts a dark shadow upon the surface of the Earth.',
        etymology: 'From Greek ekleipsis ("abandonment, darkening").',
      ),
      WordDefinition(
        word: 'SATELLITE',
        partOfSpeech: 'noun',
        definition: 'An artificial apparatus or natural celestial body orbiting around a larger planet in space.',
        exampleSentence: 'Communication satellites orbit high above the equator in geostationary orbit.',
        etymology: 'From Latin satelles ("attendant, companion").',
      ),
      WordDefinition(
        word: 'ELLIPSE',
        partOfSpeech: 'noun',
        definition: 'A closed symmetrical oval curve generated by a plane cutting through a cone.',
        exampleSentence: 'Kepler discovered that all planetary orbits are subtle ellipses rather than perfect circles.',
        etymology: 'From Greek elleipsis ("falling short, deficiency").',
      ),
      WordDefinition(
        word: 'GRAVITATION',
        partOfSpeech: 'noun',
        definition: 'The fundamental universal attractive force that pulls any two masses in the cosmos toward each other.',
        exampleSentence: 'The gravitational pull between Earth and Moon produces the daily rise and fall of ocean tides.',
        etymology: 'From Latin gravitas ("heaviness, weight").',
      ),
    ],
  ),
];
