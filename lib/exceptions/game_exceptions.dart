// 自訂例外處理類別
// Demonstrates: Custom Exception (自訂例外)

/// 遊戲例外基底類別
abstract class GameException implements Exception {
  final String message;
  final String code;

  const GameException(this.message, this.code);

  @override
  String toString() => '[$code] $message';
}

/// 任務相關例外
class QuestException extends GameException {
  const QuestException(String message) : super(message, 'QUEST_ERROR');

  /// 任務不存在
  factory QuestException.notFound(String questId) =>
      QuestException('找不到任務: $questId');

  /// 任務已完成
  factory QuestException.alreadyCompleted(String questId) =>
      QuestException('任務已經完成: $questId');

  /// 無效的經驗值
  factory QuestException.invalidExp(int exp) =>
      QuestException('經驗值不可為負數: $exp');

  /// 無效的任務標題
  factory QuestException.invalidTitle(String title) =>
      QuestException('任務標題無效: $title');
}

/// 玩家相關例外
class PlayerException extends GameException {
  const PlayerException(String message) : super(message, 'PLAYER_ERROR');

  /// 無效的玩家名稱
  factory PlayerException.invalidName(String name, String reason) =>
      PlayerException('無效的玩家名稱「$name」: $reason');

  /// 等級不足
  factory PlayerException.insufficientLevel(int required, int current) =>
      PlayerException('等級不足，需要 $required 級，目前 $current 級');

  /// 經驗值溢位
  factory PlayerException.expOverflow(int amount) =>
      PlayerException('經驗值超出上限: $amount');
}

/// 成就相關例外
class AchievementException extends GameException {
  const AchievementException(String message) : super(message, 'ACHIEVEMENT_ERROR');

  /// 成就不存在
  factory AchievementException.notFound(String achievementId) =>
      AchievementException('找不到成就: $achievementId');

  /// 成就已解鎖
  factory AchievementException.alreadyUnlocked(String achievementId) =>
      AchievementException('成就已解鎖: $achievementId');
}

/// 儲存相關例外
class StorageException extends GameException {
  const StorageException(String message) : super(message, 'STORAGE_ERROR');

  /// 儲存失敗
  factory StorageException.saveFailed(String key) =>
      StorageException('儲存失敗: $key');

  /// 讀取失敗
  factory StorageException.loadFailed(String key) =>
      StorageException('讀取失敗: $key');

  /// 資料格式錯誤
  factory StorageException.invalidFormat(String key) =>
      StorageException('資料格式錯誤: $key');
}
