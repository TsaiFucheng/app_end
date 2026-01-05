import 'experience.dart';

/// Player class representing the user's game character
class Player {
  final String id;
  String name;
  String avatarIcon;
  Experience totalExp;
  int level;
  int streak; // consecutive days completing quests

  Player({
    required this.id,
    required this.name,
    this.avatarIcon = '🦸',
    Experience? totalExp,
    this.level = 1,
    this.streak = 0,
  }) : totalExp = totalExp ?? Experience.zero();

  /// Experience required for next level
  /// Formula: level * 100
  int get expForNextLevel => level * 100;

  /// Current progress towards next level (0.0 - 1.0)
  double get levelProgress {
    final expInCurrentLevel = totalExp.value - _totalExpForLevel(level - 1);
    final expNeeded = expForNextLevel;
    return expNeeded > 0 ? (expInCurrentLevel / expNeeded).clamp(0.0, 1.0) : 0.0;
  }

  /// Calculate total exp needed to reach a level
  int _totalExpForLevel(int lvl) {
    if (lvl <= 0) return 0;
    // Sum of 1*100 + 2*100 + ... + lvl*100 = 100 * (lvl * (lvl + 1) / 2)
    return 50 * lvl * (lvl + 1);
  }

  /// Add experience and check for level up
  /// Returns true if leveled up
  bool addExperience(Experience exp) {
    totalExp = totalExp + exp;
    return _checkLevelUp();
  }

  /// Remove experience and check for level down
  /// Returns true if leveled down
  bool removeExperience(Experience exp) {
    // Don't go below 0
    final newValue = (totalExp.value - exp.value).clamp(0, totalExp.value);
    totalExp = Experience(newValue);
    return _checkLevelDown();
  }

  /// Check and process level up
  bool _checkLevelUp() {
    bool leveledUp = false;
    while (totalExp.value >= _totalExpForLevel(level)) {
      level++;
      leveledUp = true;
    }
    return leveledUp;
  }

  /// Check and process level down
  bool _checkLevelDown() {
    bool leveledDown = false;
    while (level > 1 && totalExp.value < _totalExpForLevel(level - 1)) {
      level--;
      leveledDown = true;
    }
    return leveledDown;
  }

  /// Increment streak
  void incrementStreak() => streak++;

  /// Reset streak
  void resetStreak() => streak = 0;

  /// Get title based on level
  String get title {
    if (level >= 50) return '傳奇英雄';
    if (level >= 40) return '大師';
    if (level >= 30) return '專家';
    if (level >= 20) return '老手';
    if (level >= 10) return '見習者';
    if (level >= 5) return '新手';
    return '初心者';
  }

  /// Copy with method
  Player copyWith({
    String? name,
    String? avatarIcon,
    Experience? totalExp,
    int? level,
    int? streak,
  }) {
    return Player(
      id: id,
      name: name ?? this.name,
      avatarIcon: avatarIcon ?? this.avatarIcon,
      totalExp: totalExp ?? this.totalExp,
      level: level ?? this.level,
      streak: streak ?? this.streak,
    );
  }
}
