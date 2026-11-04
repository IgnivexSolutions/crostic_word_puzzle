import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/level_data.dart';
import '../models/game_state.dart';
import '../models/user_account.dart';
import '../data/levels_dataset.dart';
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

  Timer? _gameTimer;
  int _elapsedSeconds = 0;
  int _mistakesCount = 0;
  int _hintsUsed = 0;

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

    _elapsedSeconds = 0;
    _mistakesCount = 0;
    _hintsUsed = 0;
    _gameTimer?.cancel();
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (mounted) {
        setState(() {
          _elapsedSeconds++;
        });
      }
    });

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
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
      } else {
        _sound.playError();
        _mistakesCount++;
        gameState.mistakesCount = _mistakesCount;
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

    _sound.playKeyTap();

    setState(() {
      // 1. If active tile has an unverified guess, remove it and auto-retreat backwards!
      if (gameState.guessedLetters.containsKey(activeNumber) && !gameState.isNumberSolved(activeNumber)) {
        gameState.guessedLetters.remove(activeNumber);
        _retreatCursor();
        return;
      }

      // 2. If active tile was already empty or solved, auto-retreat backwards AND delete that tile!
      _retreatCursor();
      final newActiveNum = gameState.selectedLetterNumber;
      if (newActiveNum != null && !gameState.isNumberSolved(newActiveNum)) {
        gameState.guessedLetters.remove(newActiveNum);
      }
    });

    _storage.saveLevelGuesses(widget.level.id, gameState.guessedLetters);
  }

  void _advanceCursor() {
    // If focused on clues:
    if (!gameState.isQuoteFocused && gameState.selectedClueId != null) {
      final currentClueIdx = widget.level.clues.indexWhere((c) => c.id == gameState.selectedClueId);
      if (currentClueIdx != -1) {
        // 1. Search ahead in current clue for first empty slot
        final clue = widget.level.clues[currentClueIdx];
        for (int i = gameState.selectedCharIndexInClue + 1; i < clue.letterNumbers.length; i++) {
          final n = clue.letterNumbers[i];
          if (!gameState.isNumberSolved(n)) {
            gameState.selectedCharIndexInClue = i;
            gameState.selectedLetterNumber = n;
            return;
          }
        }
        // 2. Search subsequent clues for first empty slot
        for (int cIdx = currentClueIdx + 1; cIdx < widget.level.clues.length; cIdx++) {
          final nextClue = widget.level.clues[cIdx];
          for (int i = 0; i < nextClue.letterNumbers.length; i++) {
            final n = nextClue.letterNumbers[i];
            if (!gameState.isNumberSolved(n)) {
              gameState.selectedClueId = nextClue.id;
              gameState.selectedCharIndexInClue = i;
              gameState.selectedLetterNumber = n;
              return;
            }
          }
        }
        // 3. Search earlier clues from beginning (wrap around)
        for (int cIdx = 0; cIdx <= currentClueIdx; cIdx++) {
          final prevClue = widget.level.clues[cIdx];
          for (int i = 0; i < prevClue.letterNumbers.length; i++) {
            final n = prevClue.letterNumbers[i];
            if (!gameState.isNumberSolved(n)) {
              gameState.selectedClueId = prevClue.id;
              gameState.selectedCharIndexInClue = i;
              gameState.selectedLetterNumber = n;
              return;
            }
          }
        }
      }
    } else if (gameState.isQuoteFocused && gameState.selectedQuoteWordIndex != null) {
      final currentWordIdx = gameState.selectedQuoteWordIndex!;
      final qw = widget.level.quoteWords[currentWordIdx];
      // Search forward in current quote word
      for (int i = gameState.selectedCharIndexInQuote + 1; i < qw.letterNumbers.length; i++) {
        final n = qw.letterNumbers[i];
        if (!gameState.isNumberSolved(n)) {
          gameState.selectedCharIndexInQuote = i;
          gameState.selectedLetterNumber = n;
          return;
        }
      }
      // Search subsequent quote words
      for (int wIdx = currentWordIdx + 1; wIdx < widget.level.quoteWords.length; wIdx++) {
        final nextQw = widget.level.quoteWords[wIdx];
        for (int i = 0; i < nextQw.letterNumbers.length; i++) {
          final n = nextQw.letterNumbers[i];
          if (!gameState.isNumberSolved(n)) {
            gameState.selectedQuoteWordIndex = wIdx;
            gameState.selectedCharIndexInQuote = i;
            gameState.selectedLetterNumber = n;
            return;
          }
        }
      }
      // Wrap around earlier quote words
      for (int wIdx = 0; wIdx <= currentWordIdx; wIdx++) {
        final nextQw = widget.level.quoteWords[wIdx];
        for (int i = 0; i < nextQw.letterNumbers.length; i++) {
          final n = nextQw.letterNumbers[i];
          if (!gameState.isNumberSolved(n)) {
            gameState.selectedQuoteWordIndex = wIdx;
            gameState.selectedCharIndexInQuote = i;
            gameState.selectedLetterNumber = n;
            return;
          }
        }
      }
    }
  }

  void _retreatCursor() {
    if (!gameState.isQuoteFocused && gameState.selectedClueId != null) {
      final currentClueIdx = widget.level.clues.indexWhere((c) => c.id == gameState.selectedClueId);
      if (currentClueIdx != -1) {
        final clue = widget.level.clues[currentClueIdx];
        // 1. Look backwards in current clue
        for (int i = gameState.selectedCharIndexInClue - 1; i >= 0; i--) {
          final n = clue.letterNumbers[i];
          if (!gameState.isNumberSolved(n)) {
            gameState.selectedCharIndexInClue = i;
            gameState.selectedLetterNumber = n;
            return;
          }
        }
        // 2. Look backwards in previous clues
        for (int cIdx = currentClueIdx - 1; cIdx >= 0; cIdx--) {
          final prevClue = widget.level.clues[cIdx];
          for (int i = prevClue.letterNumbers.length - 1; i >= 0; i--) {
            final n = prevClue.letterNumbers[i];
            if (!gameState.isNumberSolved(n)) {
              gameState.selectedClueId = prevClue.id;
              gameState.selectedCharIndexInClue = i;
              gameState.selectedLetterNumber = n;
              return;
            }
          }
        }
      }
    } else if (gameState.isQuoteFocused && gameState.selectedQuoteWordIndex != null) {
      final currentWordIdx = gameState.selectedQuoteWordIndex!;
      final qw = widget.level.quoteWords[currentWordIdx];
      for (int i = gameState.selectedCharIndexInQuote - 1; i >= 0; i--) {
        final n = qw.letterNumbers[i];
        if (!gameState.isNumberSolved(n)) {
          gameState.selectedCharIndexInQuote = i;
          gameState.selectedLetterNumber = n;
          return;
        }
      }
      for (int wIdx = currentWordIdx - 1; wIdx >= 0; wIdx--) {
        final prevQw = widget.level.quoteWords[wIdx];
        for (int i = prevQw.letterNumbers.length - 1; i >= 0; i--) {
          final n = prevQw.letterNumbers[i];
          if (!gameState.isNumberSolved(n)) {
            gameState.selectedQuoteWordIndex = wIdx;
            gameState.selectedCharIndexInQuote = i;
            gameState.selectedLetterNumber = n;
            return;
          }
        }
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
      _hintsUsed++;
      gameState.hintsUsed = _hintsUsed;

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
    _gameTimer?.cancel();
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

    // Dynamic Star Calculation based on Time & Accuracy
    final accuracy = (100 - (_mistakesCount * 6) - (_hintsUsed * 8)).clamp(10, 100);
    int calculatedStars = 1;
    if (accuracy >= 85 && _elapsedSeconds <= 120) {
      calculatedStars = 3;
    } else if (accuracy >= 65 && _elapsedSeconds <= 240) {
      calculatedStars = 2;
    }

    final existingStars = widget.user.levelStars['${widget.level.id}'] ?? 0;
    if (calculatedStars > existingStars) {
      widget.user.levelStars['${widget.level.id}'] = calculatedStars;
    }

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
        starsEarned: calculatedStars,
        hintsUsed: _hintsUsed,
        onNextLevel: () {
          Navigator.pop(ctx);
          Navigator.pop(context);
          // Launch next level
          final nextLevel = LevelRepository().getLevel(widget.level.id + 1);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (c) => GameplayScreen(
                level: nextLevel,
                user: widget.user,
                onLevelCompleted: widget.onLevelCompleted,
              ),
            ),
          );
        },
        onReviewBoard: () {
          Navigator.pop(ctx);
        },
        onReplay: () {
          Navigator.pop(ctx);
          setState(() {
            gameState.guessedLetters.clear();
            gameState.revealedLetterNumbers.clear();
            gameState.selectedLetterNumber = null;
          });
          _storage.saveLevelGuesses(widget.level.id, {});
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

                  // Live Timer & Accuracy HUD
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.timer_outlined, size: 16.0, color: Color(0xFF0284C7)),
                            const SizedBox(width: 4.0),
                            Text(
                              '${(_elapsedSeconds ~/ 60).toString().padLeft(2, '0')}:${(_elapsedSeconds % 60).toString().padLeft(2, '0')}',
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 13.0,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF0284C7),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.track_changes_rounded, size: 16.0, color: Color(0xFF16A34A)),
                            const SizedBox(width: 4.0),
                            Text(
                              '${(100 - (_mistakesCount * 6) - (_hintsUsed * 8)).clamp(10, 100)}% Acc',
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 13.0,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF16A34A),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '🪙 ${widget.user.coins}',
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFD97706),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4.0),

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

                  // 3. Compact Clues List (All 7-8 clues fit neatly onto screen)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: widget.level.clues.map((clue) {
                          return ClueRow(
                            clue: clue,
                            gameState: gameState,
                            onTileTap: _onClueTileTap,
                          );
                        }).toList(),
                      ),
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
