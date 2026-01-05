import 'package:flutter/foundation.dart';
import '../models/quest.dart';
import '../models/achievement.dart';
import '../services/storage_service.dart';

/// QuestProvider for managing quests state
/// Demonstrates: Provider State Management (狀態管理)
class QuestProvider extends ChangeNotifier {
  final StorageService _storage;
  final List<Quest> _quests = [];
  final List<Achievement> _achievements = [];
  int _totalCompleted = 0;

  QuestProvider(this._storage) {
    _initializeAchievements();
    loadData();
  }

  /// 從儲存載入任務資料
  void loadData() {
    _quests.clear();

    // 載入每日任務
    final dailyData = _storage.getDailyQuests();
    for (final map in dailyData) {
      _quests.add(DailyQuest.fromMap(map));
    }

    // 載入每週任務
    final weeklyData = _storage.getWeeklyQuests();
    for (final map in weeklyData) {
      _quests.add(WeeklyQuest.fromMap(map));
    }

    // 載入總完成數
    _totalCompleted = _storage.getTotalCompleted();

    // 載入已解鎖成就
    final unlockedIds = _storage.getUnlockedAchievements();
    for (final achievement in _achievements) {
      if (unlockedIds.contains(achievement.id)) {
        achievement.unlock();
      }
    }

    // 如果沒有任務，建立預設任務
    if (_quests.isEmpty) {
      _initializeDefaultQuests();
    }

    notifyListeners();
  }

  /// 儲存任務資料
  Future<void> _saveData() async {
    // 儲存每日任務
    final dailyMaps = dailyQuests.map((q) => q.toMap()).toList();
    await _storage.saveDailyQuests(dailyMaps);

    // 儲存每週任務
    final weeklyMaps = weeklyQuests.map((q) => q.toMap()).toList();
    await _storage.saveWeeklyQuests(weeklyMaps);

    // 儲存總完成數
    await _storage.saveTotalCompleted(_totalCompleted);

    // 儲存已解鎖成就
    final unlockedIds = _achievements
        .where((a) => a.isUnlocked)
        .map((a) => a.id)
        .toList();
    await _storage.saveUnlockedAchievements(unlockedIds);
  }

  /// Initialize with default quests
  void _initializeDefaultQuests() {
    _quests.addAll([
      DailyQuest(
        id: 'daily_1',
        title: '早起運動',
        description: '早上起床後做 10 分鐘運動',
        expReward: 15,
      ),
      DailyQuest(
        id: 'daily_2',
        title: '閱讀 30 分鐘',
        description: '每天閱讀至少 30 分鐘',
        expReward: 20,
      ),
      DailyQuest(
        id: 'daily_3',
        title: '喝 8 杯水',
        description: '保持水分攝取',
        expReward: 10,
      ),
      WeeklyQuest(
        id: 'weekly_1',
        title: '每週運動 5 天',
        description: '本週完成 5 天的運動目標',
        expReward: 100,
        targetCount: 5,
      ),
      WeeklyQuest(
        id: 'weekly_2',
        title: '學習新技能',
        description: '每週花時間學習新事物',
        expReward: 80,
        targetCount: 3,
      ),
    ]);
  }

  /// Initialize achievements
  void _initializeAchievements() {
    _achievements.addAll(Achievements.getDefaultAchievements());
  }

  /// Get all quests
  List<Quest> get quests => List.unmodifiable(_quests);

  /// Get daily quests
  List<DailyQuest> get dailyQuests => _quests.whereType<DailyQuest>().toList();

  /// Get weekly quests
  List<WeeklyQuest> get weeklyQuests =>
      _quests.whereType<WeeklyQuest>().toList();

  /// Get all achievements
  List<Achievement> get achievements => List.unmodifiable(_achievements);

  /// Get unlocked achievements
  List<Achievement> get unlockedAchievements =>
      _achievements.where((a) => a.isUnlocked).toList();

  /// Get locked achievements
  List<Achievement> get lockedAchievements =>
      _achievements.where((a) => !a.isUnlocked).toList();

  /// Get total completed quests
  int get totalCompleted => _totalCompleted;

  /// Get today's completion count (daily quests only)
  int get todayCompletedCount {
    final today = DateTime.now();
    return dailyQuests.where((q) {
      if (q.completedAt == null) return false;
      return q.completedAt!.year == today.year &&
          q.completedAt!.month == today.month &&
          q.completedAt!.day == today.day;
    }).length;
  }

  /// Get today's total quests (daily only)
  int get todayTotalCount => dailyQuests.length;

  /// Get completion rate for today
  double get todayCompletionRate {
    if (todayTotalCount == 0) return 0.0;
    return todayCompletedCount / todayTotalCount;
  }

  /// Add a new quest
  void addQuest(Quest quest) {
    _quests.add(quest);
    _saveData();
    notifyListeners();
  }

  /// Remove a quest
  void removeQuest(String questId) {
    _quests.removeWhere((q) => q.id == questId);
    _saveData();
    notifyListeners();
  }

  /// Complete a quest
  /// Returns the exp reward if successful, null otherwise
  int? completeQuest(String questId) {
    final questIndex = _quests.indexWhere((q) => q.id == questId);
    if (questIndex == -1) return null;

    final quest = _quests[questIndex];
    if (quest.isCompleted) return null;

    quest.complete();
    _totalCompleted++;
    _checkAchievements();
    _saveData();
    notifyListeners();

    return quest.expReward;
  }

  /// Increment weekly quest progress
  void incrementWeeklyProgress(String questId) {
    final quest = _quests.firstWhere(
      (q) => q.id == questId,
      orElse: () => throw StateError('Quest not found'),
    );

    if (quest is WeeklyQuest) {
      quest.incrementProgress();
      if (quest.isCompleted) {
        _totalCompleted++;
        _checkAchievements();
      }
      _saveData();
      notifyListeners();
    }
  }

  /// Toggle quest completion (for daily quests)
  /// Returns positive exp when completing, negative exp when unchecking
  int? toggleQuestCompletion(String questId) {
    final quest = _quests.firstWhere(
      (q) => q.id == questId,
      orElse: () => throw StateError('Quest not found'),
    );

    if (quest.isCompleted) {
      final expToDeduct = quest.expReward;
      quest.reset();
      _totalCompleted--;
      _saveData();
      notifyListeners();
      return -expToDeduct; // Return negative exp to deduct
    } else {
      return completeQuest(questId);
    }
  }

  /// Check and unlock achievements
  List<Achievement> _checkAchievements() {
    final unlocked = <Achievement>[];

    for (final achievement in _achievements) {
      if (achievement.isUnlocked) continue;

      bool shouldUnlock = false;

      switch (achievement.category) {
        case AchievementCategory.quest:
          shouldUnlock = _totalCompleted >= achievement.requirement;
          break;
        case AchievementCategory.streak:
        case AchievementCategory.level:
        case AchievementCategory.special:
          // These are handled by PlayerProvider or special conditions
          break;
      }

      if (shouldUnlock) {
        achievement.unlock();
        unlocked.add(achievement);
      }
    }

    return unlocked;
  }

  /// Check level achievement
  void checkLevelAchievement(int level) {
    for (final achievement in _achievements) {
      if (achievement.isUnlocked) continue;
      if (achievement.category != AchievementCategory.level) continue;

      if (level >= achievement.requirement) {
        achievement.unlock();
        _saveData();
        notifyListeners();
      }
    }
  }

  /// Check streak achievement
  void checkStreakAchievement(int streak) {
    for (final achievement in _achievements) {
      if (achievement.isUnlocked) continue;
      if (achievement.category != AchievementCategory.streak) continue;

      if (streak >= achievement.requirement) {
        achievement.unlock();
        _saveData();
        notifyListeners();
      }
    }
  }

  /// Check all achievements on app load
  /// Call this after both providers are initialized
  void checkAllAchievementsOnLoad(int level, int streak) {
    bool hasChanges = false;

    for (final achievement in _achievements) {
      if (achievement.isUnlocked) continue;

      bool shouldUnlock = false;

      switch (achievement.category) {
        case AchievementCategory.quest:
          shouldUnlock = _totalCompleted >= achievement.requirement;
          break;
        case AchievementCategory.level:
          shouldUnlock = level >= achievement.requirement;
          break;
        case AchievementCategory.streak:
          shouldUnlock = streak >= achievement.requirement;
          break;
        case AchievementCategory.special:
          // Special achievements are checked elsewhere
          break;
      }

      if (shouldUnlock) {
        achievement.unlock();
        hasChanges = true;
      }
    }

    if (hasChanges) {
      _saveData();
      notifyListeners();
    }
  }

  /// Reset daily quests
  void resetDailyQuests() {
    for (final quest in _quests) {
      if (quest is DailyQuest) {
        quest.reset();
      }
    }
    _saveData();
    notifyListeners();
  }

  /// Reset weekly quests
  void resetWeeklyQuests() {
    for (final quest in _quests) {
      if (quest is WeeklyQuest) {
        quest.reset();
      }
    }
    _saveData();
    notifyListeners();
  }

  /// Reset all progress including achievements
  void resetAll() {
    // Reset all quests
    for (final quest in _quests) {
      quest.reset();
    }

    // Reset total completed count
    _totalCompleted = 0;

    // Reset all achievements
    for (final achievement in _achievements) {
      if (achievement.isUnlocked) {
        // Create a new unlocked state by setting isUnlocked to false
        achievement.isUnlocked = false;
        achievement.unlockedAt = null;
      }
    }

    _saveData();
    notifyListeners();
  }

  /// Create a new daily quest
  void createDailyQuest({
    required String title,
    String description = '',
    int expReward = 10,
  }) {
    final quest = DailyQuest(
      id: 'daily_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      description: description,
      expReward: expReward,
    );
    addQuest(quest);
  }

  /// Create a new weekly quest
  void createWeeklyQuest({
    required String title,
    String description = '',
    int expReward = 50,
    int targetCount = 7,
  }) {
    final quest = WeeklyQuest(
      id: 'weekly_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      description: description,
      expReward: expReward,
      targetCount: targetCount,
    );
    addQuest(quest);
  }
}
