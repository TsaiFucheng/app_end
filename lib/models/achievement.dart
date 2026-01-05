/// Achievement category
enum AchievementCategory {
  quest,    // quest-related achievements
  streak,   // streak-related achievements
  level,    // level-related achievements
  special,  // special achievements
}

/// Achievement class representing unlockable badges
class Achievement {
  final String id;
  final String title;
  final String description;
  final String icon;
  final AchievementCategory category;
  final int requirement; // value needed to unlock
  bool isUnlocked;
  DateTime? unlockedAt;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.category,
    required this.requirement,
    this.isUnlocked = false,
    this.unlockedAt,
  });

  /// Unlock this achievement
  void unlock() {
    if (!isUnlocked) {
      isUnlocked = true;
      unlockedAt = DateTime.now();
    }
  }

  /// Copy with method
  Achievement copyWith({
    bool? isUnlocked,
    DateTime? unlockedAt,
  }) {
    return Achievement(
      id: id,
      title: title,
      description: description,
      icon: icon,
      category: category,
      requirement: requirement,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
    );
  }
}

/// Predefined achievements
class Achievements {
  static List<Achievement> getDefaultAchievements() {
    return [
      // Quest achievements
      Achievement(
        id: 'first_quest',
        title: '踏出第一步',
        description: '完成你的第一個任務',
        icon: '🎯',
        category: AchievementCategory.quest,
        requirement: 1,
      ),
      Achievement(
        id: 'quest_10',
        title: '任務達人',
        description: '累計完成 10 個任務',
        icon: '⭐',
        category: AchievementCategory.quest,
        requirement: 10,
      ),
      Achievement(
        id: 'quest_50',
        title: '任務專家',
        description: '累計完成 50 個任務',
        icon: '🌟',
        category: AchievementCategory.quest,
        requirement: 50,
      ),
      Achievement(
        id: 'quest_100',
        title: '任務大師',
        description: '累計完成 100 個任務',
        icon: '💫',
        category: AchievementCategory.quest,
        requirement: 100,
      ),
      // Streak achievements
      Achievement(
        id: 'streak_3',
        title: '持之以恆',
        description: '連續 3 天完成任務',
        icon: '🔥',
        category: AchievementCategory.streak,
        requirement: 3,
      ),
      Achievement(
        id: 'streak_7',
        title: '一週達人',
        description: '連續 7 天完成任務',
        icon: '🔥',
        category: AchievementCategory.streak,
        requirement: 7,
      ),
      Achievement(
        id: 'streak_30',
        title: '月度英雄',
        description: '連續 30 天完成任務',
        icon: '🏆',
        category: AchievementCategory.streak,
        requirement: 30,
      ),
      // Level achievements
      Achievement(
        id: 'level_5',
        title: '嶄露頭角',
        description: '達到等級 5',
        icon: '📈',
        category: AchievementCategory.level,
        requirement: 5,
      ),
      Achievement(
        id: 'level_10',
        title: '穩步成長',
        description: '達到等級 10',
        icon: '📊',
        category: AchievementCategory.level,
        requirement: 10,
      ),
      Achievement(
        id: 'level_25',
        title: '實力派',
        description: '達到等級 25',
        icon: '🎖️',
        category: AchievementCategory.level,
        requirement: 25,
      ),
      Achievement(
        id: 'level_50',
        title: '傳奇英雄',
        description: '達到等級 50',
        icon: '👑',
        category: AchievementCategory.level,
        requirement: 50,
      ),
      // Special achievements
      Achievement(
        id: 'early_bird',
        title: '早起的鳥兒',
        description: '在早上 6 點前完成任務',
        icon: '🌅',
        category: AchievementCategory.special,
        requirement: 1,
      ),
      Achievement(
        id: 'night_owl',
        title: '夜貓子',
        description: '在晚上 11 點後完成任務',
        icon: '🦉',
        category: AchievementCategory.special,
        requirement: 1,
      ),
    ];
  }
}
