// 遊戲列舉類型定義
// Demonstrates: Enum (列舉)

/// 任務難度
enum QuestDifficulty {
  easy('簡單', 1.0, '🟢'),
  normal('普通', 1.5, '🟡'),
  hard('困難', 2.0, '🟠'),
  legendary('傳說', 3.0, '🔴');

  final String label;
  final double expMultiplier;
  final String icon;

  const QuestDifficulty(this.label, this.expMultiplier, this.icon);

  /// 根據難度計算經驗值
  int calculateExp(int baseExp) => (baseExp * expMultiplier).round();
}

/// 任務類別
enum QuestCategory {
  health('健康', '❤️'),
  study('學習', '📚'),
  exercise('運動', '💪'),
  lifestyle('生活', '🏠'),
  social('社交', '👥'),
  creativity('創意', '🎨');

  final String label;
  final String icon;

  const QuestCategory(this.label, this.icon);
}

/// 成就類型
enum AchievementType {
  streak('連續達成', '🔥'),
  total('累計完成', '⭐'),
  level('等級里程碑', '🏆'),
  special('特殊成就', '💎');

  final String label;
  final String icon;

  const AchievementType(this.label, this.icon);
}

/// 玩家稱號等級
enum PlayerRank {
  novice(1, '新手冒險者', '🌱'),
  apprentice(5, '見習勇者', '⚔️'),
  warrior(10, '戰士', '🛡️'),
  veteran(20, '老練戰士', '🗡️'),
  elite(30, '精英勇者', '💫'),
  master(50, '大師', '👑'),
  legend(100, '傳說英雄', '🌟');

  final int requiredLevel;
  final String title;
  final String icon;

  const PlayerRank(this.requiredLevel, this.title, this.icon);

  /// 根據等級取得對應稱號
  static PlayerRank fromLevel(int level) {
    return PlayerRank.values.lastWhere(
      (rank) => level >= rank.requiredLevel,
      orElse: () => PlayerRank.novice,
    );
  }
}

/// 通知類型
enum NotificationType {
  levelUp('升級', '🎉'),
  questComplete('任務完成', '✅'),
  achievementUnlock('成就解鎖', '🏅'),
  streakMilestone('連勝里程碑', '🔥');

  final String label;
  final String icon;

  const NotificationType(this.label, this.icon);
}
