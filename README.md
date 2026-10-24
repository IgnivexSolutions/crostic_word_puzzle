# Crostic Cryptogram • Educational Scholar Edition (Flutter & Web)

An authentic, educational word puzzle game built with **Flutter**, featuring real-time cipher decoding, educational vocabulary glossary, ambient background music and sound effects, and multi-device online sync.

---

## 🎯 Gameplay Features

1. **Pixel-Perfect Mobile Interface**:
   - Soft pastel blue gradient background (`#EBF3F8`).
   - Top quote board displaying hidden historical and scientific quotes with cryptogram number subscript badges.
   - 7 to 8 clues with definitions, hints, and interactive letter slots.
   - **Simultaneous Letter Revelation**: When any letter number is guessed, typed, or revealed, it updates in **every single word** across the board where that number appears!
   - **Golden Amber Highlighting**: Tapping any letter tile illuminates all matching letter slots across the entire screen simultaneously.
   - Interactive on-screen QWERTY keyboard + full physical keyboard support for laptops and PCs.
   - Floating action buttons: **Scholar Shop** (bag) and **Instant Clue Hint** (lightbulb).

2. **100% Mathematically Verified Cipher Levels (Under-Matric Curriculum)**:
   - Tailored specifically for **Grade 6–10 (Under-Matric)** students in **Pakistan, India, Bangladesh, and Sri Lanka**.
   - Replaces foreign Western pop culture with core school syllabus subjects: **General Science (Biology, Physics, Chemistry), Mathematics, Computer Studies, Regional Geography, and Astronomy**.
   - Every single level has been mathematically verified for 100% letter bijection (each letter A-Z has one and only one assigned integer ID):
     - **Level 1 (General Science - Biology)**: Quote: `"GREEN PLANTS PRODUCE FOOD"` • Clues: `LEAF`, `ROOT`, `STEM`, `SEED`, `CELL`, `SUGAR`, `POND`, `SOIL`.
     - **Level 2 (Computer Studies - Architecture)**: Quote: `"CPU IS THE BRAIN OF COMPUTER"` • Clues: `MOUSE`, `SCREEN`, `BYTE`, `CHIP`, `FONT`, `PRINT`, `RAM`, `INPUT`.
     - **Level 3 (Mathematics - Geometry)**: Quote: `"SUM OF TRIANGLE ANGLES IS FIXED"` • Clues: `ANGLE`, `RADIUS`, `FRACTION`, `MINUS`, `GRAPH`, `POINT`, `AXIS`, `DIGIT`.
     - **Level 4 (Physical Sciences - Matter)**: Quote: `"MATTER HAS MASS AND VOLUME"` • Clues: `ATOM`, `SOLID`, `HEAT`, `VAPOR`, `LENS`, `FLUID`, `SOUND`, `METAL`.
     - **Level 5 (Social Studies - South Asian Geography)**: Quote: `"MONSOON RAIN FEEDS SOUTH ASIA"` • Clues: `INDUS`, `DELTA`, `ISLAND`, `HIMALAYA`, `FOREST`, `OCEAN`, `DESERT`, `RIVER`.
     - **Level 6 (Astronomy - Solar System)**: Quote: `"EARTH REVOLVES AROUND SUN"` • Clues: `PLANET`, `SOLAR`, `MOON`, `ORBIT`, `DUST`, `HEAVEN`, `STAR`, `VENUS`.

3. **Rich Educational Value**:
   - Historical context and quotation attribution modal upon level victory.
   - Student Vocabulary Lexicon with definitions, parts of speech, example sentences, and etymology.

4. **Online Account Creation & Multi-Device Sync**:
   - Register with username, email, and password.
   - Generates a unique 6-character **Device Sync Code** (e.g. `CR-9041`).
   - Enter your code on any other smartphone, tablet, or desktop to instantly sync stars, coins, unlocked levels, and vocabulary.

5. **Audio Engine**:
   - `bgm_loop.wav`: Soothing study ambient music loop.
   - `key_tap.wav`: Tactile typing click.
   - `letter_reveal.wav`: Bright marimba chime on correct guess.
   - `word_complete.wav`: Ascending major triad chord on completing a clue.
   - `level_victory.wav`: Sparkling triumphant victory fanfare.
   - `hint.wav`: Shimmer harp on hint reveal.

---

## 🚀 How to Run

### Option 1: Instant Browser Preview & Android PWA Installation
- **On PC / Laptop**: Double-click `web/index.html` to run in Google Chrome or Microsoft Edge.
- **On Android Phone**: Open `web/index.html` in Chrome on your Android device and tap **"Install App"** (or three dots menu ➔ **"Add to Home Screen"**) to install it directly as a native standalone app on your phone with zero build tools!

### Option 2: Build APK in the Cloud with GitHub Actions (Zero Local Setup)
This repository includes a ready-to-run GitHub workflow [`.github/workflows/build_apk.yml`](file:///.github/workflows/build_apk.yml):
1. Push this folder to a GitHub repository.
2. Go to **Actions** ➔ **Build Release APK** ➔ click **Run workflow**.
3. In under 2 minutes, download the compiled `crostic-scholar-release-apk` directly from GitHub!

### Option 3: Build APK Locally with Flutter SDK
Once you install Flutter SDK & Android Studio/Command-line tools:
```bash
# 1. Fetch dependencies
flutter pub get

# 2. Run unit tests to verify all school cipher levels
flutter test

# 3. Build release APK
flutter build apk --release
```
The compiled APK will be generated at:
`build/app/outputs/flutter-apk/app-release.apk`

---

## 📁 Project Structure

```
crostic_word_puzzle/
├── pubspec.yaml
├── README.md
├── assets/
│   └── audio/
│       ├── bgm_loop.wav
│       ├── key_tap.wav
│       ├── letter_reveal.wav
│       ├── word_complete.wav
│       ├── level_victory.wav
│       └── hint.wav
├── lib/
│   ├── main.dart
│   ├── models/
│   │   ├── level_data.dart
│   │   ├── user_account.dart
│   │   └── game_state.dart
│   ├── data/
│   │   └── levels_dataset.dart
│   ├── services/
│   │   ├── level_verifier.dart
│   │   ├── sound_service.dart
│   │   ├── storage_service.dart
│   │   └── sync_service.dart
│   ├── widgets/
│   │   ├── letter_tile.dart
│   │   ├── quote_matrix.dart
│   │   ├── clue_row.dart
│   │   └── virtual_keyboard.dart
│   └── screens/
│       ├── home_screen.dart
│       ├── gameplay_screen.dart
│       ├── category_levels_screen.dart
│       ├── vocabulary_book_screen.dart
│       ├── account_sync_screen.dart
│       ├── settings_screen.dart
│       └── level_complete_dialog.dart
├── test/
│   └── level_verification_test.dart
└── web/
    └── index.html
```
