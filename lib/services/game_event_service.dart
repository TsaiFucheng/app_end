// 遊戲事件服務
// Demonstrates: Stream, StreamController (串流)

import 'dart:async';
import '../models/quest.dart';
import '../models/achievement.dart';

/// 遊戲事件類型
sealed class GameEvent {
  final DateTime timestamp;
  GameEvent() : timestamp = DateTime.now();
}

/// 經驗值變化事件
class ExpChangedEvent extends GameEvent {
  final int oldExp;
  final int newExp;
  final int delta;

  ExpChangedEvent({
    required this.oldExp,
    required this.newExp,
  }) : delta = newExp - oldExp;
}

/// 等級提升事件
class LevelUpEvent extends GameEvent {
  final int oldLevel;
  final int newLevel;

  LevelUpEvent({
    required this.oldLevel,
    required this.newLevel,
  });
}

/// 任務完成事件
class QuestCompletedEvent extends GameEvent {
  final Quest quest;
  final int expGained;

  QuestCompletedEvent({
    required this.quest,
    required this.expGained,
  });
}

/// 成就解鎖事件
class AchievementUnlockedEvent extends GameEvent {
  final Achievement achievement;

  AchievementUnlockedEvent({required this.achievement});
}

/// 連勝更新事件
class StreakUpdatedEvent extends GameEvent {
  final int oldStreak;
  final int newStreak;

  StreakUpdatedEvent({
    required this.oldStreak,
    required this.newStreak,
  });
}

/// 遊戲事件服務（Singleton）
class GameEventService {
  // Singleton 模式
  static final GameEventService _instance = GameEventService._internal();
  factory GameEventService() => _instance;
  GameEventService._internal();

  // 廣播 StreamController（允許多個監聽者）
  final _eventController = StreamController<GameEvent>.broadcast();

  /// 取得事件串流
  Stream<GameEvent> get eventStream => _eventController.stream;

  /// 取得經驗值變化串流
  Stream<ExpChangedEvent> get expStream =>
      eventStream.where((e) => e is ExpChangedEvent).cast<ExpChangedEvent>();

  /// 取得等級提升串流
  Stream<LevelUpEvent> get levelUpStream =>
      eventStream.where((e) => e is LevelUpEvent).cast<LevelUpEvent>();

  /// 取得任務完成串流
  Stream<QuestCompletedEvent> get questCompletedStream =>
      eventStream.where((e) => e is QuestCompletedEvent).cast<QuestCompletedEvent>();

  /// 取得成就解鎖串流
  Stream<AchievementUnlockedEvent> get achievementUnlockedStream =>
      eventStream.where((e) => e is AchievementUnlockedEvent).cast<AchievementUnlockedEvent>();

  /// 取得連勝更新串流
  Stream<StreakUpdatedEvent> get streakUpdatedStream =>
      eventStream.where((e) => e is StreakUpdatedEvent).cast<StreakUpdatedEvent>();

  /// 發送經驗值變化事件
  void emitExpChanged(int oldExp, int newExp) {
    _eventController.add(ExpChangedEvent(oldExp: oldExp, newExp: newExp));
  }

  /// 發送等級提升事件
  void emitLevelUp(int oldLevel, int newLevel) {
    _eventController.add(LevelUpEvent(oldLevel: oldLevel, newLevel: newLevel));
  }

  /// 發送任務完成事件
  void emitQuestCompleted(Quest quest, int expGained) {
    _eventController.add(QuestCompletedEvent(quest: quest, expGained: expGained));
  }

  /// 發送成就解鎖事件
  void emitAchievementUnlocked(Achievement achievement) {
    _eventController.add(AchievementUnlockedEvent(achievement: achievement));
  }

  /// 發送連勝更新事件
  void emitStreakUpdated(int oldStreak, int newStreak) {
    _eventController.add(StreakUpdatedEvent(oldStreak: oldStreak, newStreak: newStreak));
  }

  /// 關閉服務
  void dispose() {
    _eventController.close();
  }
}
