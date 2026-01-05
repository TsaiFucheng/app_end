import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// StorageService - 資料持久化服務
/// 使用 shared_preferences 實現本地資料儲存
class StorageService {
  static const String _keyPlayerName = 'player_name';
  static const String _keyPlayerAvatar = 'player_avatar';
  static const String _keyPlayerLevel = 'player_level';
  static const String _keyPlayerExp = 'player_exp';
  static const String _keyPlayerStreak = 'player_streak';
  static const String _keyDailyQuests = 'daily_quests';
  static const String _keyWeeklyQuests = 'weekly_quests';
  static const String _keyTotalCompleted = 'total_completed';
  static const String _keyUnlockedAchievements = 'unlocked_achievements';
  static const String _keyThemeMode = 'theme_mode';
  static const String _keyLocale = 'locale';

  SharedPreferences? _prefs;

  /// 初始化 SharedPreferences
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// 確保已初始化
  SharedPreferences get prefs {
    if (_prefs == null) {
      throw Exception('StorageService not initialized. Call init() first.');
    }
    return _prefs!;
  }

  // ==================== 玩家資料 ====================

  /// 儲存玩家資料
  Future<void> savePlayerData({
    required String name,
    required String avatar,
    required int level,
    required int exp,
    required int streak,
  }) async {
    await prefs.setString(_keyPlayerName, name);
    await prefs.setString(_keyPlayerAvatar, avatar);
    await prefs.setInt(_keyPlayerLevel, level);
    await prefs.setInt(_keyPlayerExp, exp);
    await prefs.setInt(_keyPlayerStreak, streak);
  }

  /// 讀取玩家名稱
  String getPlayerName() => prefs.getString(_keyPlayerName) ?? '冒險者';

  /// 讀取玩家頭像
  String getPlayerAvatar() => prefs.getString(_keyPlayerAvatar) ?? '🦸';

  /// 讀取玩家等級
  int getPlayerLevel() => prefs.getInt(_keyPlayerLevel) ?? 1;

  /// 讀取玩家經驗值
  int getPlayerExp() => prefs.getInt(_keyPlayerExp) ?? 0;

  /// 讀取玩家連勝天數
  int getPlayerStreak() => prefs.getInt(_keyPlayerStreak) ?? 0;

  // ==================== 任務資料 ====================

  /// 儲存每日任務列表
  Future<void> saveDailyQuests(List<Map<String, dynamic>> quests) async {
    final jsonString = jsonEncode(quests);
    await prefs.setString(_keyDailyQuests, jsonString);
  }

  /// 讀取每日任務列表
  List<Map<String, dynamic>> getDailyQuests() {
    final jsonString = prefs.getString(_keyDailyQuests);
    if (jsonString == null || jsonString.isEmpty) return [];
    try {
      final List<dynamic> decoded = jsonDecode(jsonString);
      return decoded.cast<Map<String, dynamic>>();
    } catch (e) {
      return [];
    }
  }

  /// 儲存每週任務列表
  Future<void> saveWeeklyQuests(List<Map<String, dynamic>> quests) async {
    final jsonString = jsonEncode(quests);
    await prefs.setString(_keyWeeklyQuests, jsonString);
  }

  /// 讀取每週任務列表
  List<Map<String, dynamic>> getWeeklyQuests() {
    final jsonString = prefs.getString(_keyWeeklyQuests);
    if (jsonString == null || jsonString.isEmpty) return [];
    try {
      final List<dynamic> decoded = jsonDecode(jsonString);
      return decoded.cast<Map<String, dynamic>>();
    } catch (e) {
      return [];
    }
  }

  /// 儲存總完成任務數
  Future<void> saveTotalCompleted(int count) async {
    await prefs.setInt(_keyTotalCompleted, count);
  }

  /// 讀取總完成任務數
  int getTotalCompleted() => prefs.getInt(_keyTotalCompleted) ?? 0;

  // ==================== 成就資料 ====================

  /// 儲存已解鎖成就 ID 列表
  Future<void> saveUnlockedAchievements(List<String> achievementIds) async {
    await prefs.setStringList(_keyUnlockedAchievements, achievementIds);
  }

  /// 讀取已解鎖成就 ID 列表
  List<String> getUnlockedAchievements() {
    return prefs.getStringList(_keyUnlockedAchievements) ?? [];
  }

  // ==================== 使用者偏好設定 ====================

  /// 儲存主題模式 (0: system, 1: light, 2: dark)
  Future<void> saveThemeMode(int mode) async {
    await prefs.setInt(_keyThemeMode, mode);
  }

  /// 讀取主題模式
  int getThemeMode() => prefs.getInt(_keyThemeMode) ?? 0;

  /// 儲存語言設定
  Future<void> saveLocale(String languageCode) async {
    await prefs.setString(_keyLocale, languageCode);
  }

  /// 讀取語言設定
  String getLocale() => prefs.getString(_keyLocale) ?? 'zh';

  // ==================== 重置 ====================

  /// 清除所有資料
  Future<void> clearAll() async {
    await prefs.clear();
  }

  /// 重置遊戲進度（保留設定）
  Future<void> resetProgress() async {
    await prefs.remove(_keyPlayerName);
    await prefs.remove(_keyPlayerAvatar);
    await prefs.remove(_keyPlayerLevel);
    await prefs.remove(_keyPlayerExp);
    await prefs.remove(_keyPlayerStreak);
    await prefs.remove(_keyDailyQuests);
    await prefs.remove(_keyWeeklyQuests);
    await prefs.remove(_keyTotalCompleted);
    await prefs.remove(_keyUnlockedAchievements);
  }
}
