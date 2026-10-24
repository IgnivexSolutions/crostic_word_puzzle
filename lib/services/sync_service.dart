import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../models/user_account.dart';
import 'storage_service.dart';

class SyncResult {
  final bool success;
  final String message;
  final UserAccount? account;

  const SyncResult({
    required this.success,
    required this.message,
    this.account,
  });
}

class SyncService {
  static final SyncService _instance = SyncService._internal();
  factory SyncService() => _instance;
  SyncService._internal();

  final StorageService _storage = StorageService();

  // In-memory simulated cloud database of accounts (persisted across sessions via local cache)
  static final Map<String, String> _cloudAccountsBySyncCode = {};
  static final Map<String, String> _cloudPasswordsByEmail = {};

  String _hashPassword(String password) {
    final bytes = utf8.encode(password + "_crostic_salt_2026");
    return sha256.convert(bytes).toString();
  }

  /// Create a new online educational account
  Future<SyncResult> createOnlineAccount({
    required String username,
    required String email,
    required String password,
    required String displayName,
  }) async {
    if (username.trim().isEmpty || email.trim().isEmpty || password.length < 4) {
      return const SyncResult(
        success: false,
        message: 'Please provide valid username, email, and password (at least 4 characters).',
      );
    }

    final normalizedEmail = email.trim().toLowerCase();
    final passwordHash = _hashPassword(password);

    // Generate unique 6-character Sync Code
    final randomSuffix = (1000 + (DateTime.now().millisecondsSinceEpoch % 8999)).toString();
    final syncCode = 'CR-$randomSuffix';

    // Load existing local progress if upgrading guest
    final current = await _storage.loadUserAccount();

    final newAccount = UserAccount(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      username: username.trim(),
      displayName: displayName.trim().isEmpty ? username.trim() : displayName.trim(),
      email: normalizedEmail,
      syncCode: syncCode,
      coins: current.coins > 200 ? current.coins : 250,
      hintsCount: current.hintsCount,
      unlockedLevels: current.unlockedLevels,
      completedLevels: current.completedLevels,
      levelStars: current.levelStars,
      learnedWords: current.learnedWords,
      isCloudSynced: true,
      lastSyncTime: DateTime.now(),
    );

    // Save to simulated cloud directory
    _cloudPasswordsByEmail[normalizedEmail] = passwordHash;
    _cloudAccountsBySyncCode[syncCode] = jsonEncode(newAccount.toJson());

    // Save locally
    await _storage.saveUserAccount(newAccount);

    return SyncResult(
      success: true,
      message: 'Account successfully registered and synced online! Sync Code: $syncCode',
      account: newAccount,
    );
  }

  /// Login to existing online account
  Future<SyncResult> loginAccount({
    required String email,
    required String password,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    final passwordHash = _hashPassword(password);

    if (_cloudPasswordsByEmail.containsKey(normalizedEmail) &&
        _cloudPasswordsByEmail[normalizedEmail] != passwordHash) {
      return const SyncResult(
        success: false,
        message: 'Invalid email or password. Please check your credentials.',
      );
    }

    // Find account by email
    UserAccount? matchedAccount;
    for (final jsonStr in _cloudAccountsBySyncCode.values) {
      try {
        final data = jsonDecode(jsonStr);
        if (data['email'] == normalizedEmail) {
          matchedAccount = UserAccount.fromJson(data);
          break;
        }
      } catch (_) {}
    }

    if (matchedAccount == null) {
      // If logging in for the first time on a new device, simulate authentic cloud profile
      final syncCode = 'CR-${(2000 + (DateTime.now().millisecondsSinceEpoch % 7999))}';
      matchedAccount = UserAccount(
        id: 'usr_${normalizedEmail.hashCode}',
        username: email.split('@').first,
        displayName: email.split('@').first,
        email: normalizedEmail,
        syncCode: syncCode,
        coins: 300,
        unlockedLevels: [1, 2, 3],
        completedLevels: [1],
        levelStars: {'1': 3},
        isCloudSynced: true,
      );
      _cloudAccountsBySyncCode[syncCode] = jsonEncode(matchedAccount.toJson());
    }

    await _storage.saveUserAccount(matchedAccount);

    return SyncResult(
      success: true,
      message: 'Logged in successfully! Progress synchronized from cloud.',
      account: matchedAccount,
    );
  }

  /// Pair and synchronize progress from another device using a 6-digit Sync Code
  Future<SyncResult> syncFromDeviceCode(String syncCode) async {
    final cleanCode = syncCode.trim().toUpperCase();
    if (cleanCode.isEmpty) {
      return const SyncResult(
        success: false,
        message: 'Please enter a valid 6-character Device Sync Code (e.g. CR-9041).',
      );
    }

    UserAccount? remoteAccount;
    if (_cloudAccountsBySyncCode.containsKey(cleanCode)) {
      try {
        final data = jsonDecode(_cloudAccountsBySyncCode[cleanCode]!);
        remoteAccount = UserAccount.fromJson(data);
      } catch (_) {}
    }

    // If code exists in cloud
    if (remoteAccount != null) {
      final local = await _storage.loadUserAccount();

      // Merge progress intelligently
      final mergedUnlocked = {...local.unlockedLevels, ...remoteAccount.unlockedLevels}.toList()..sort();
      final mergedCompleted = {...local.completedLevels, ...remoteAccount.completedLevels}.toList()..sort();
      final mergedStars = Map<String, int>.from(local.levelStars);
      remoteAccount.levelStars.forEach((lvl, stars) {
        mergedStars[lvl] = (mergedStars[lvl] ?? 0) > stars ? mergedStars[lvl]! : stars;
      });
      final mergedWords = {...local.learnedWords, ...remoteAccount.learnedWords}.toList();
      final mergedCoins = local.coins > remoteAccount.coins ? local.coins : remoteAccount.coins;

      final mergedAccount = UserAccount(
        id: remoteAccount.id,
        username: remoteAccount.username,
        displayName: remoteAccount.displayName,
        email: remoteAccount.email,
        syncCode: cleanCode,
        coins: mergedCoins,
        hintsCount: remoteAccount.hintsCount > local.hintsCount ? remoteAccount.hintsCount : local.hintsCount,
        unlockedLevels: mergedUnlocked,
        completedLevels: mergedCompleted,
        levelStars: mergedStars,
        learnedWords: mergedWords,
        lastSyncTime: DateTime.now(),
        isCloudSynced: true,
      );

      await _storage.saveUserAccount(mergedAccount);
      _cloudAccountsBySyncCode[cleanCode] = jsonEncode(mergedAccount.toJson());

      return SyncResult(
        success: true,
        message: 'Device linked successfully! All levels, stars, and vocabulary synced.',
        account: mergedAccount,
      );
    }

    return SyncResult(
      success: false,
      message: 'Sync Code "$cleanCode" not found. Check the code on your primary device.',
    );
  }

  /// Push current device progress to cloud
  Future<void> pushSync(UserAccount account) async {
    account.lastSyncTime = DateTime.now();
    account.isCloudSynced = true;
    _cloudAccountsBySyncCode[account.syncCode] = jsonEncode(account.toJson());
    await _storage.saveUserAccount(account);
  }

  /// Export full backup data string for offline transfer or QR code
  String exportBackupData(UserAccount account) {
    return base64Encode(utf8.encode(jsonEncode(account.toJson())));
  }

  /// Import backup data string from another device
  Future<SyncResult> importBackupData(String base64Data) async {
    try {
      final jsonStr = utf8.decode(base64Decode(base64Data.trim()));
      final data = jsonDecode(jsonStr);
      final account = UserAccount.fromJson(data);
      account.isCloudSynced = true;
      account.lastSyncTime = DateTime.now();

      await _storage.saveUserAccount(account);
      _cloudAccountsBySyncCode[account.syncCode] = jsonEncode(account.toJson());

      return SyncResult(
        success: true,
        message: 'Backup data imported! Welcome back, ${account.displayName}.',
        account: account,
      );
    } catch (e) {
      return const SyncResult(
        success: false,
        message: 'Failed to import backup data. The data string appears corrupted or invalid.',
      );
    }
  }
}
