import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/level_data.dart';
import '../models/game_state.dart';
import '../models/user_account.dart';
import '../services/sound_service.dart';
import '../services/storage_service.dart';
import '../services/sync_service.dart';
import '../widgets/quote_matrix.dart';
import '../widgets/clue_row.dart';
import '../widgets/virtual_keyboard.dart';
import 'level_complete_dialog.dart';
import 'settings_screen.dart';

class GameplayScreen extends StatefulWidget {
  final LevelData level;
  final UserAccount user;
  final VoidCallback onLevelCompleted;

  const GameplayScreen({
    super.key,
    required this.level,
    required this.user,
    required this.onLevelCompleted,
  });

  @override
  State<GameplayScreen> createState() => _GameplayScreenState();
}

class _GameplayScreenState extends State<GameplayScreen> {
  late GameState gameState;
  final SoundService _sound = SoundService();
  final StorageService _storage = StorageService();
  final SyncService _sync = SyncService();
  final FocusNode _keyboardFocusNode = FocusNode();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initGame();
  }

  Future<void> _initGame() async {
    gameState = GameState.initial(widget.level);
    // Load any saved guesses from storage
    final savedGuesses = await _storage.loadLevelGuesses(widget.level.id);
    if (savedGuesses.isNotEmpty) {
      gameState.guessedLetters.addAll(savedGuesses);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _keyboardFocusNode.dispose();
    super.dispose();
  }

  void _onClueTileTap(String clueId, int charIdx, int letterNumber) {
    _sound.playKeyTap();
    setState(() {
      gameState.isQuoteFocused = false;
      gameState.selectedClueId = clueId;
      gameState.selectedCharIndexInClue = charIdx;
      gameState.selectedLetterNumber = letterNumber;
    });
  }

  void _onQuoteTileTap(int wordIdx, int charIdx, int letterNumber) {
    _sound.playKeyTap();
    setState(() {
      gameState.isQuoteFocused = true;
      gameState.selectedQuoteWordIndex = wordIdx;
      gameState.selectedCharIndexInQuote = charIdx;
      gameState.selectedLetterNumber = letterNumber;
    });
  }

  void _onKeyInput(String char) {
    final activeNumber = gameState.selectedLetterNumber;
    if (activeNumber == null) return;

    _sound.playKeyTap();

    setState(() {
      // 1. Assign character to this letter number (reveals in ALL matching slots!)
      gameState.guessedLetters[activeNumber] = char.toUpperCase();

      // Check if this guess is correct
      final expectedChar = widget.level.numberToLetterMap[activeNumber];
      if (char.toUpperCase() == expectedChar) {
        _sound.playLetterReveal();
      }

      // 2. Check if the active clue just completed
      if (!gameState.isQuoteFocused && gameState.selectedClueId != null) {
        final currentClue = widget.level.clues.firstWhere((c) => c.id == gameState.selectedClueId);
        if (gameState.isClueComplete(currentClue)) {
          _sound.playWordComplete();
        }
      }

      // 3. Auto-advance to next empty slot
      _advanceCursor();

      // 4. Check if entire puzzle is solved
      if (gameState.checkEntireLevelWon()) {
        _handleVictory();
      }
    });

    // Save progress asynchronously
    _storage.saveLevelGuesses(widget.level.id, gameState.guessedLetters);
  }

  void _onBackspace() {
    final activeNumber = gameState.selectedLetterNumber;
    if (activeNumber == null) return;

    // Check if this letter is already correctly solved
    final correctChar = gameState.targetSolution[activeNumber];
    final currentGuess = gameState.guessedLetters[activeNumber];

    if (currentGuess != null && currentGuess == correctChar) {
      // Solved letters are locked and protected from accidental deletion
      _sound.playError();
      return;
    }

    _sound.playKeyTap();

    setState(() {
      if (gameState.guessedLetters.containsKey(activeNumber)) {
        gameState.guessedLetters.remove(activeNumber);
      } else {
        // Move backwards to previous editable tile
        _retreatCursor();
      }
    });

    _storage.saveLevelGuesses(widget.level.id, gameState.guessedLetters);
  }

  void _advanceCursor() {
    if (!gameState.isQuoteFocused && gameState.selectedClueId != null) {
      final clue = widget.level.clues.firstWhere((c) => c.id == gameState.selectedClueId);
      // Advance to next char in this clue
      if (gameState.selectedCharIndexInClue + 1 < clue.letterNumbers.length) {
        gameState.selectedCharIndexInClue++;
        gameState.selectedLetterNumber = clue.letterNumbers[gameState.selectedCharIndexInClue];
      } else {
        // Move to next clue
        final currentClueIdx = widget.level.clues.indexOf(clue);
        if (currentClueIdx + 1 < widget.level.clues.length) {
          final nextClue = widget.level.clues[currentClueIdx + 1];
          gameState.selectedClueId = nextClue.id;
          gameState.selectedCharIndexInClue = 0;
          gameState.selectedLetterNumber = nextClue.letterNumbers.first;
        }
      }
    } else if (gameState.isQuoteFocused && gameState.selectedQuoteWordIndex != null) {
      final qw = widget.level.quoteWords[gameState.selectedQuoteWordIndex!];
      if (gameState.selectedCharIndexInQuote + 1 < qw.letterNumbers.length) {
        gameState.selectedCharIndexInQuote++;
        gameState.selectedLetterNumber = qw.letterNumbers[gameState.selectedCharIndexInQuote];
      } else if (gameState.selectedQuoteWordIndex! + 1 < widget.level.quoteWords.length) {
        gameState.selectedQuoteWordIndex = gameState.selectedQuoteWordIndex! + 1;
        gameState.selectedCharIndexInQuote = 0;
        final nextQw = widget.level.quoteWords[gameState.selectedQuoteWordIndex!];
        gameState.selectedLetterNumber = nextQw.letterNumbers.first;
      }
    }
  }

  void _retreatCursor() {
    if (!gameState.isQuoteFocused && gameState.selectedClueId != null) {
      if (gameState.selectedCharIndexInClue > 0) {
        gameState.selectedCharIndexInClue--;
        final clue = widget.level.clues.firstWhere((c) => c.id == gameState.selectedClueId);
        gameState.selectedLetterNumber = clue.letterNumbers[gameState.selectedCharIndexInClue];
      }
    } else if (gameState.isQuoteFocused && gameState.selectedQuoteWordIndex != null) {
      if (gameState.selectedCharIndexInQuote > 0) {
        gameState.selectedCharIndexInQuote--;
        final qw = widget.level.quoteWords[gameState.selectedQuoteWordIndex!];
        gameState.selectedLetterNumber = qw.letterNumbers[gameState.selectedCharIndexInQuote];
      }
    }
  }

  void _useHint() {
    if (widget.user.hintsCount <= 0 && widget.user.coins < 25) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Not enough coins or hints! Solve clues to earn more.'),
          backgroundColor: Color(0xFFD97706),
        ),
      );
      return;
    }

    _sound.playHint();

    setState(() {
      if (widget.user.hintsCount > 0) {
        widget.user.hintsCount--;
      } else {
        widget.user.coins -= 25;
      }

      // Find an unsolved letter number
      int? targetNumber;
      if (gameState.selectedLetterNumber != null &&
          !gameState.isNumberSolved(gameState.selectedLetterNumber!)) {
        targetNumber = gameState.selectedLetterNumber;
      } else {
        for (final entry in widget.level.numberToLetterMap.entries) {
          if (!gameState.isNumberSolved(entry.key)) {
            targetNumber = entry.key;
            break;
          }
        }
      }

      if (targetNumber != null) {
        final correctChar = widget.level.numberToLetterMap[targetNumber]!;
        gameState.guessedLetters[targetNumber] = correctChar;
        gameState.revealedLetterNumbers.add(targetNumber);
        gameState.selectedLetterNumber = targetNumber;

        // Auto check victory
        if (gameState.checkEntireLevelWon()) {
          _handleVictory();
        }
      }
    });

    _storage.saveUserAccount(widget.user);
    _storage.saveLevelGuesses(widget.level.id, gameState.guessedLetters);
  }

  void _openShop() {
    _sound.playKeyTap();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Icon(Icons.shopping_bag_rounded, color: Color(0xFFF97316), size: 28),
                const SizedBox(width: 8.0),
                Text(
                  'Scholar Scholar Shop',
                  style: GoogleFonts.spaceGrotesk(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                const Spacer(),
                Text(
                  '🪙 ${widget.user.coins}',
                  style: GoogleFonts.jetBrainsMono(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            ListTile(
              leading: const Icon(Icons.lightbulb_rounded, color: Color(0xFFF59E0B), size: 32),
              title: const Text('3 Clue Hints Pack'),
              subtitle: const Text('Instantly reveal 3 cryptic letter tiles'),
              trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF59E0B)),
                onPressed: widget.user.coins >= 50
                    ? () {
                        setState(() {
                          widget.user.coins -= 50;
                          widget.user.hintsCount += 3;
                        });
                        _storage.saveUserAccount(widget.user);
                        Navigator.pop(ctx);
                        _sound.playLetterReveal();
                      }
                    : null,
                child: const Text('50 🪙', style: TextStyle(color: Colors.white)),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.auto_awesome_rounded, color: Color(0xFF8B5CF6), size: 32),
              title: const Text('Daily Scholar Bonus'),
              subtitle: const Text('Claim 100 free coins for learning vocabulary!'),
              trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8B5CF6)),
                onPressed: () {
                  setState(() {
                    widget.user.coins += 100;
                  });
                  _storage.saveUserAccount(widget.user);
                  Navigator.pop(ctx);
                  _sound.playWordComplete();
                },
                child: const Text('Free Claim', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleVictory() async {
    _sound.playVictory();

    // Reward user
    widget.user.coins += widget.level.coinsReward;
    if (!widget.user.completedLevels.contains(widget.level.id)) {
      widget.user.completedLevels.add(widget.level.id);
    }
    // Unlock next level
    if (!widget.user.unlockedLevels.contains(widget.level.id + 1)) {
      widget.user.unlockedLevels.add(widget.level.id + 1);
    }
    widget.user.levelStars['${widget.level.id}'] = 3;

    // Add vocabulary words to user's learned lexicon
    for (final v in widget.level.vocabularyList) {
      if (!widget.user.learnedWords.contains(v.word)) {
        widget.user.learnedWords.add(v.word);
      }
    }

    await _storage.saveUserAccount(widget.user);
    await _sync.pushSync(widget.user);

    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => LevelCompleteDialog(
        level: widget.level,
        coinsEarned: widget.level.coinsReward,
        onNextLevel: () {
          Navigator.pop(ctx);
          widget.onLevelCompleted();
        },
        onReviewBoard: () {
          Navigator.pop(ctx);
        },
      ),
    );
  }

  Set<String> _getDisabledLetters() {
    final disabled = <String>{};
    widget.level.letterToNumberMap.forEach((char, num) {
      if (gameState.isNumberSolved(num)) {
        disabled.add(char);
      }
    });
    return disabled;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFE8F1F5),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return RawKeyboardListener(
      focusNode: _keyboardFocusNode,
      autofocus: true,
      onKey: (event) {
        if (event is RawKeyDownEvent) {
          final logicalKey = event.logicalKey;
          if (logicalKey == LogicalKeyboardKey.backspace) {
            _onBackspace();
          } else {
            final keyLabel = logicalKey.keyLabel.toUpperCase();
            if (RegExp(r'^[A-Z]$').hasMatch(keyLabel)) {
              _onKeyInput(keyLabel);
            }
          }
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFEBF3F8), // Soft pastel blue background identical to screenshot
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  // 1. Header Bar (Home icon, Title, Settings ...)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.home_rounded, color: Color(0xFF64748B), size: 28.0),
                          onPressed: () {
                            _sound.playKeyTap();
                            Navigator.pop(context);
                          },
                        ),
                        Column(
                          children: [
                            Text(
                              widget.level.category,
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF475569),
                              ),
                            ),
                            Text(
                              'Level ${widget.level.id} • ${widget.level.title}',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF94A3B8),
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.more_horiz_rounded, color: Color(0xFF64748B), size: 28.0),
                          onPressed: () {
                            _sound.playKeyTap();
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (c) => const SettingsScreen()),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  // 2. Top Hidden Quote Card
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0),
                    child: QuoteMatrix(
                      level: widget.level,
                      gameState: gameState,
                      onTileTap: _onQuoteTileTap,
                    ),
                  ),

                  const SizedBox(height: 6.0),

                  // 3. Scrollable Clues List (flex 1)
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 6.0),
                      itemCount: widget.level.clues.length,
                      separatorBuilder: (ctx, i) => const Divider(color: Color(0xFFE2E8F0), height: 1.0),
                      itemBuilder: (ctx, i) {
                        final clue = widget.level.clues[i];
                        return ClueRow(
                          clue: clue,
                          gameState: gameState,
                          onTileTap: _onClueTileTap,
                        );
                      },
                    ),
                  ),

                  // 4. Virtual Keyboard Pinned to Bottom
                  VirtualKeyboard(
                    onKeyTap: _onKeyInput,
                    onBackspace: _onBackspace,
                    disabledLetters: _getDisabledLetters(),
                  ),
                ],
              ),

              // 5. Floating Action Buttons (Shop on left, Hint on right - matching screenshot!)
              Positioned(
                bottom: 175.0, // Floating right above virtual keyboard
                left: 14.0,
                child: GestureDetector(
                  onTap: _openShop,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 52.0,
                        height: 52.0,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFB923C), // Warm orange as in screenshot
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFEA580C).withOpacity(0.35),
                              blurRadius: 8.0,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(Icons.shopping_bag_rounded, color: Colors.white, size: 26.0),
                        ),
                      ),
                      Positioned(
                        top: -3.0,
                        right: -3.0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(color: Colors.black12, blurRadius: 2.0),
                            ],
                          ),
                          child: Text(
                            '1',
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFFEA580C),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Positioned(
                bottom: 175.0, // Floating right above virtual keyboard
                right: 14.0,
                child: GestureDetector(
                  onTap: _useHint,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 52.0,
                        height: 52.0,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFBBF24), // Vibrant gold as in screenshot
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFD97706).withOpacity(0.35),
                              blurRadius: 8.0,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(Icons.lightbulb_rounded, color: Colors.white, size: 28.0),
                        ),
                      ),
                      Positioned(
                        top: -3.0,
                        right: -3.0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF59E0B),
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(color: Colors.white, width: 1.5),
                          ),
                          child: Text(
                            widget.user.hintsCount > 0 ? '${widget.user.hintsCount}' : 'Ad',
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
