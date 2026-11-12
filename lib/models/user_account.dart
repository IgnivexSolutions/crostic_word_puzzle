class UserAccount {
  final String id;
  final String username;
  final String displayName;
  final String email;
  final String syncCode; // 6-digit cross-device sync code
  String selectedClass; // e.g. "Class 1 - 3", "Class 4 - 5", "Class 6 - 8", "Class 9 - 10+"
  int coins;
  int hintsCount;
  List<int> unlockedLevels;
  List<int> completedLevels;
  Map<String, int> levelStars; // "1": 3, "2": 2...
  List<String> learnedWords; // Words student has mastered
  DateTime lastSyncTime;
  bool isCloudSynced;

  UserAccount({
    required this.id,
    required this.username,
    required this.displayName,
    required this.email,
    required this.syncCode,
    this.selectedClass = 'Class 1 - 3',
    this.coins = 200,
    this.hintsCount = 5,
    List<int>? unlockedLevels,
    List<int>? completedLevels,
    Map<String, int>? levelStars,
    List<String>? learnedWords,
    DateTime? lastSyncTime,
    this.isCloudSynced = false,
  })  : unlockedLevels = unlockedLevels ?? [1, 11, 21, 31],
        completedLevels = completedLevels ?? [],
        levelStars = levelStars ?? {},
        learnedWords = learnedWords ?? [],
        lastSyncTime = lastSyncTime ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'displayName': displayName,
        'email': email,
        'syncCode': syncCode,
        'selectedClass': selectedClass,
        'coins': coins,
        'hintsCount': hintsCount,
        'unlockedLevels': unlockedLevels,
        'completedLevels': completedLevels,
        'levelStars': levelStars,
        'learnedWords': learnedWords,
        'lastSyncTime': lastSyncTime.toIso8601String(),
        'isCloudSynced': isCloudSynced,
      };

  factory UserAccount.fromJson(Map<String, dynamic> json) => UserAccount(
        id: json['id'] ?? 'user_guest',
        username: json['username'] ?? 'student_scholar',
        displayName: json['displayName'] ?? 'Curious Scholar',
        email: json['email'] ?? 'scholar@crostic.edu',
        syncCode: json['syncCode'] ?? 'CR-9041',
        selectedClass: json['selectedClass'] ?? 'Class 1 - 3',
        coins: json['coins'] ?? 200,
        hintsCount: json['hintsCount'] ?? 5,
        unlockedLevels: List<int>.from(json['unlockedLevels'] ?? [1, 11, 21, 31]),
        completedLevels: List<int>.from(json['completedLevels'] ?? []),
        levelStars: Map<String, int>.from(json['levelStars'] ?? {}),
        learnedWords: List<String>.from(json['learnedWords'] ?? []),
        lastSyncTime: json['lastSyncTime'] != null
            ? DateTime.tryParse(json['lastSyncTime']) ?? DateTime.now()
            : DateTime.now(),
        isCloudSynced: json['isCloudSynced'] ?? false,
      );

  static UserAccount createDefaultGuest({String? customSyncCode}) {
    final code = customSyncCode ??
        'CR-${(1000 + (DateTime.now().millisecondsSinceEpoch % 8999)).toString()}';
    return UserAccount(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      username: 'student_explorer',
      displayName: 'Word Explorer',
      email: 'student@crostic.app',
      syncCode: code,
      coins: 250,
      hintsCount: 6,
      selectedClass: 'Class 1 - 3',
      unlockedLevels: [1, 11, 21, 31],
      completedLevels: [],
      learnedWords: [],
      isCloudSynced: true,
    );
  }
}
