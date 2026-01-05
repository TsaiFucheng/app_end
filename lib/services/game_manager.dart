import '../models/player.dart';
import '../models/quest.dart';
import '../models/achievement.dart';
import '../models/experience.dart';

/// GameManager singleton class
/// Demonstrates: Singleton Pattern (單例模式)
class GameManager {
  // Singleton instance
  static final GameManager _instance = GameManager._internal();

  // Factory constructor returns the same instance
  factory GameManager() => _instance;

  // Private internal constructor
  GameManager._internal();

  // Game state
  Player? _currentPlayer;
  final List<Quest> _quests = [];
  final List<Achievement> _achievements = [];
  int _totalQuestsCompleted = 0;

  /// Initialize game with player
  void initializeGame(Player player) {
    _currentPlayer = player;
    _achievements.clear();
    _achievements.addAll(Achievements.getDefaultAchievements());
  }

  /// Get current player
  Player? get currentPlayer => _currentPlayer;

  /// Get all quests
  List<Quest> get quests => List.unmodifiable(_quests);

  /// Get all achievements
  List<Achievement> get achievements => List.unmodifiable(_achievements);

  /// Get total quests completed
  int get totalQuestsCompleted => _totalQuestsCompleted;

  /// Add a quest
  void addQuest(Quest quest) {
    _quests.add(quest);
  }

  /// Remove a quest
  void removeQuest(String questId) {
    _quests.removeWhere((q) => q.id == questId);
  }

  /// Complete a quest and process rewards
  CompleteQuestResult completeQuest(String questId) {
    final questIndex = _quests.indexWhere((q) => q.id == questId);
    if (questIndex == -1) {
      return CompleteQuestResult(success: false);
    }

    final quest = _quests[questIndex];
    if (quest.isCompleted) {
      return CompleteQuestResult(success: false);
    }

    // Complete the quest
    quest.complete();
    _totalQuestsCompleted++;

    // Calculate and add experience
    final expGained = Experience(quest.expReward);
    final leveledUp = _currentPlayer?.addExperience(expGained) ?? false;

    // Check achievements
    final unlockedAchievements = _checkAchievements();

    return CompleteQuestResult(
      success: true,
      expGained: expGained,
      leveledUp: leveledUp,
      newLevel: _currentPlayer?.level,
      unlockedAchievements: unlockedAchievements,
    );
  }

  /// Check and unlock achievements
  List<Achievement> _checkAchievements() {
    final unlocked = <Achievement>[];

    for (final achievement in _achievements) {
      if (achievement.isUnlocked) continue;

      bool shouldUnlock = false;

      switch (achievement.category) {
        case AchievementCategory.quest:
          shouldUnlock = _totalQuestsCompleted >= achievement.requirement;
          break;
        case AchievementCategory.streak:
          shouldUnlock =
              (_currentPlayer?.streak ?? 0) >= achievement.requirement;
          break;
        case AchievementCategory.level:
          shouldUnlock =
              (_currentPlayer?.level ?? 0) >= achievement.requirement;
          break;
        case AchievementCategory.special:
          // Special achievements are handled separately
          break;
      }

      if (shouldUnlock) {
        achievement.unlock();
        unlocked.add(achievement);
      }
    }

    return unlocked;
  }

  /// Check special achievement (early bird / night owl)
  Achievement? checkTimeBasedAchievement() {
    final now = DateTime.now();
    final hour = now.hour;

    if (hour < 6) {
      // Early bird
      final achievement = _achievements.firstWhere(
        (a) => a.id == 'early_bird',
        orElse: () => throw StateError('Achievement not found'),
      );
      if (!achievement.isUnlocked) {
        achievement.unlock();
        return achievement;
      }
    } else if (hour >= 23) {
      // Night owl
      final achievement = _achievements.firstWhere(
        (a) => a.id == 'night_owl',
        orElse: () => throw StateError('Achievement not found'),
      );
      if (!achievement.isUnlocked) {
        achievement.unlock();
        return achievement;
      }
    }

    return null;
  }

  /// Reset daily quests
  void resetDailyQuests() {
    for (final quest in _quests) {
      if (quest is DailyQuest) {
        quest.reset();
      }
    }
  }

  /// Reset weekly quests
  void resetWeeklyQuests() {
    for (final quest in _quests) {
      if (quest is WeeklyQuest) {
        quest.reset();
      }
    }
  }

  /// Get daily quests
  List<DailyQuest> get dailyQuests =>
      _quests.whereType<DailyQuest>().toList();

  /// Get weekly quests
  List<WeeklyQuest> get weeklyQuests =>
      _quests.whereType<WeeklyQuest>().toList();

  /// Get completed quests count for today
  int get todayCompletedCount {
    final today = DateTime.now();
    return _quests.where((q) {
      if (q.completedAt == null) return false;
      return q.completedAt!.year == today.year &&
          q.completedAt!.month == today.month &&
          q.completedAt!.day == today.day;
    }).length;
  }

  /// Clear all data (for testing)
  void clearAll() {
    _currentPlayer = null;
    _quests.clear();
    _achievements.clear();
    _totalQuestsCompleted = 0;
  }
}

/// Result class for quest completion
class CompleteQuestResult {
  final bool success;
  final Experience? expGained;
  final bool leveledUp;
  final int? newLevel;
  final List<Achievement> unlockedAchievements;

  CompleteQuestResult({
    required this.success,
    this.expGained,
    this.leveledUp = false,
    this.newLevel,
    this.unlockedAchievements = const [],
  });
}
