import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_account.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  static const String _userKey = 'crostic_user_account';
  static const String _savedGuessesPrefix = 'crostic_guesses_lvl_';
  static const String _settingsBgmKey = 'crostic_setting_bgm';
  static const String _settingsSfxKey = 'crostic_setting_sfx';
  static const String _settingsHighContrastKey = 'crostic_setting_high_contrast';
  static const String _settingsDyslexicKey = 'crostic_setting_dyslexic';

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<UserAccount> loadUserAccount() async {
    await init();
    final jsonString = _prefs?.getString(_userKey);
    if (jsonString != null && jsonString.isNotEmpty) {
      try {
        final Map<String, dynamic> data = jsonDecode(jsonString);
        return UserAccount.fromJson(data);
      } catch (_) {}
    }
    // Return fresh guest user if not saved
    final defaultUser = UserAccount.createDefaultGuest();
    await saveUserAccount(defaultUser);
    return defaultUser;
  }

  Future<void> saveUserAccount(UserAccount user) async {
    await init();
    final jsonString = jsonEncode(user.toJson());
    await _prefs?.setString(_userKey, jsonString);
  }

  Future<Map<int, String>> loadLevelGuesses(int levelId) async {
    await init();
    final jsonString = _prefs?.getString('$_savedGuessesPrefix$levelId');
    if (jsonString != null && jsonString.isNotEmpty) {
      try {
        final Map<String, dynamic> raw = jsonDecode(jsonString);
        return raw.map((k, v) => MapEntry(int.parse(k), v.toString()));
      } catch (_) {}
    }
    return {};
  }

  Future<void> saveLevelGuesses(int levelId, Map<int, String> guesses) async {
    await init();
    final stringKeyMap = guesses.map((k, v) => MapEntry(k.toString(), v));
    final jsonString = jsonEncode(stringKeyMap);
    await _prefs?.setString('$_savedGuessesPrefix$levelId', jsonString);
  }

  Future<void> clearLevelGuesses(int levelId) async {
    await init();
    await _prefs?.remove('$_savedGuessesPrefix$levelId');
  }

  bool getBgmSetting() => _prefs?.getBool(_settingsBgmKey) ?? true;
  Future<void> saveBgmSetting(bool val) async => await _prefs?.setBool(_settingsBgmKey, val);

  bool getSfxSetting() => _prefs?.getBool(_settingsSfxKey) ?? true;
  Future<void> saveSfxSetting(bool val) async => await _prefs?.setBool(_settingsSfxKey, val);

  bool getHighContrastSetting() => _prefs?.getBool(_settingsHighContrastKey) ?? false;
  Future<void> saveHighContrastSetting(bool val) async => await _prefs?.setBool(_settingsHighContrastKey, val);

  bool getDyslexicFontSetting() => _prefs?.getBool(_settingsDyslexicKey) ?? false;
  Future<void> saveDyslexicFontSetting(bool val) async => await _prefs?.setBool(_settingsDyslexicKey, val);
}
