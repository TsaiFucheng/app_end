import '../mixins/rewardable.dart';
import '../mixins/trackable.dart';

/// Sealed class for Quest Status
/// Demonstrates: Sealed Class (密封類別)
sealed class QuestStatus {
  const QuestStatus();

  factory QuestStatus.pending() => const Pending();
  factory QuestStatus.inProgress() => const InProgress();
  factory QuestStatus.completed() => const Completed();
}

class Pending extends QuestStatus {
  const Pending();
}

class InProgress extends QuestStatus {
  const InProgress();
}

class Completed extends QuestStatus {
  const Completed();
}

/// Quest Type enumeration
enum QuestType { daily, weekly }

/// Abstract Quest class
/// Demonstrates: Abstract Class (抽象類別)
abstract class Quest with Rewardable, Trackable {
  final String id;
  String title;
  String description;
  int expReward;
  QuestStatus status;
  final QuestType type;
  final DateTime createdAt;

  Quest({
    required this.id,
    required this.title,
    this.description = '',
    required this.expReward,
    this.status = const Pending(),
    required this.type,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  /// Abstract method: complete the quest
  void complete();

  /// Abstract method: reset the quest
  void reset();

  /// Check if quest is completed
  bool get isCompleted => status is Completed;

  /// Get the actual reward with multiplier
  int getReward() => calculateReward(expReward, isCompleted ? 1 : 0);

  /// Copy with method for immutability
  Quest copyWith({
    String? title,
    String? description,
    int? expReward,
    QuestStatus? status,
  });
}

/// Daily Quest class
/// Demonstrates: Inheritance (繼承) and Mixin usage
class DailyQuest extends Quest {
  DailyQuest({
    required super.id,
    required super.title,
    super.description,
    super.expReward = 10,
    super.status,
    super.createdAt,
  }) : super(type: QuestType.daily);

  @override
  void complete() {
    if (status is! Completed) {
      status = QuestStatus.completed();
      markCompleted();
    }
  }

  @override
  void reset() {
    status = QuestStatus.pending();
    completedAt = null;
  }

  @override
  DailyQuest copyWith({
    String? title,
    String? description,
    int? expReward,
    QuestStatus? status,
  }) {
    return DailyQuest(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      expReward: expReward ?? this.expReward,
      status: status ?? this.status,
      createdAt: createdAt,
    );
  }

  /// 轉換為 Map（用於儲存）
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'expReward': expReward,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  /// 從 Map 建立（用於讀取）
  factory DailyQuest.fromMap(Map<String, dynamic> map) {
    final quest = DailyQuest(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String? ?? '',
      expReward: map['expReward'] as int? ?? 10,
      createdAt: DateTime.tryParse(map['createdAt'] as String? ?? ''),
    );
    if (map['isCompleted'] == true) {
      quest.complete();
      if (map['completedAt'] != null) {
        quest.completedAt = DateTime.tryParse(map['completedAt'] as String);
      }
    }
    return quest;
  }
}

/// Weekly Quest class
/// Demonstrates: Inheritance with different behavior
class WeeklyQuest extends Quest {
  int targetCount;
  int currentCount;

  WeeklyQuest({
    required super.id,
    required super.title,
    super.description,
    super.expReward = 50,
    super.status,
    super.createdAt,
    this.targetCount = 7,
    this.currentCount = 0,
  }) : super(type: QuestType.weekly);

  /// Progress percentage
  double get progress => targetCount > 0 ? currentCount / targetCount : 0.0;

  /// Increment progress
  void incrementProgress() {
    if (currentCount < targetCount) {
      currentCount++;
      if (currentCount >= targetCount) {
        complete();
      }
    }
  }

  @override
  void complete() {
    if (status is! Completed) {
      status = QuestStatus.completed();
      markCompleted();
    }
  }

  @override
  void reset() {
    status = QuestStatus.pending();
    currentCount = 0;
    completedAt = null;
  }

  @override
  WeeklyQuest copyWith({
    String? title,
    String? description,
    int? expReward,
    QuestStatus? status,
    int? targetCount,
    int? currentCount,
  }) {
    return WeeklyQuest(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      expReward: expReward ?? this.expReward,
      status: status ?? this.status,
      createdAt: createdAt,
      targetCount: targetCount ?? this.targetCount,
      currentCount: currentCount ?? this.currentCount,
    );
  }

  /// 轉換為 Map（用於儲存）
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'expReward': expReward,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'targetCount': targetCount,
      'currentCount': currentCount,
    };
  }

  /// 從 Map 建立（用於讀取）
  factory WeeklyQuest.fromMap(Map<String, dynamic> map) {
    final quest = WeeklyQuest(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String? ?? '',
      expReward: map['expReward'] as int? ?? 50,
      createdAt: DateTime.tryParse(map['createdAt'] as String? ?? ''),
      targetCount: map['targetCount'] as int? ?? 7,
      currentCount: map['currentCount'] as int? ?? 0,
    );
    if (map['isCompleted'] == true) {
      quest.status = QuestStatus.completed();
      if (map['completedAt'] != null) {
        quest.completedAt = DateTime.tryParse(map['completedAt'] as String);
      }
    }
    return quest;
  }
}
