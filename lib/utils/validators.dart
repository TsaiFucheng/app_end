// 驗證工具類別
// Demonstrates: RegExp (正規表達式)

import '../exceptions/game_exceptions.dart';

/// 驗證工具類別
class Validators {
  Validators._(); // 防止實例化

  /// 玩家名稱正規表達式
  /// 規則：2-20 字元，允許中文、英文、數字、底線
  static final RegExp _playerNameRegex = RegExp(r'^[\u4e00-\u9fa5a-zA-Z0-9_]{2,20}$');

  /// 任務標題正規表達式
  /// 規則：1-50 字元，不允許特殊符號（除了常見標點）
  static final RegExp _questTitleRegex = RegExp(r'^[\u4e00-\u9fa5a-zA-Z0-9\s，。！？、：；()_-]{1,50}$');

  /// 驗證玩家名稱
  ///
  /// 規則：
  /// - 長度：2-20 字元
  /// - 允許：中文、英文、數字、底線
  /// - 不允許：空白、特殊符號
  static bool isValidPlayerName(String name) {
    if (name.isEmpty) return false;
    return _playerNameRegex.hasMatch(name);
  }

  /// 驗證玩家名稱並返回錯誤訊息
  static String? validatePlayerName(String name) {
    if (name.isEmpty) {
      return '名稱不可為空';
    }
    if (name.length < 2) {
      return '名稱至少需要 2 個字元';
    }
    if (name.length > 20) {
      return '名稱不可超過 20 個字元';
    }
    if (!_playerNameRegex.hasMatch(name)) {
      return '名稱只能包含中文、英文、數字和底線';
    }
    return null; // 驗證通過
  }

  /// 驗證玩家名稱（會拋出例外）
  static void assertValidPlayerName(String name) {
    final error = validatePlayerName(name);
    if (error != null) {
      throw PlayerException.invalidName(name, error);
    }
  }

  /// 驗證任務標題
  static bool isValidQuestTitle(String title) {
    if (title.isEmpty) return false;
    return _questTitleRegex.hasMatch(title);
  }

  /// 驗證任務標題並返回錯誤訊息
  static String? validateQuestTitle(String title) {
    if (title.isEmpty) {
      return '標題不可為空';
    }
    if (title.length > 50) {
      return '標題不可超過 50 個字元';
    }
    if (!_questTitleRegex.hasMatch(title)) {
      return '標題包含不允許的特殊符號';
    }
    return null;
  }

  /// 驗證經驗值
  static bool isValidExp(int exp) => exp >= 0 && exp <= 999999;

  /// 驗證經驗值並返回錯誤訊息
  static String? validateExp(int exp) {
    if (exp < 0) {
      return '經驗值不可為負數';
    }
    if (exp > 999999) {
      return '經驗值超出上限';
    }
    return null;
  }

  /// 驗證經驗值（會拋出例外）
  static void assertValidExp(int exp) {
    if (exp < 0) {
      throw QuestException.invalidExp(exp);
    }
  }

  /// 清理字串（移除前後空白和多餘空格）
  static String sanitizeString(String input) {
    return input.trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  /// 從字串中提取數字
  static List<int> extractNumbers(String input) {
    final matches = RegExp(r'\d+').allMatches(input);
    return matches.map((m) => int.parse(m.group(0)!)).toList();
  }

  /// 檢查是否包含 Emoji
  static bool containsEmoji(String input) {
    final emojiRegex = RegExp(
      r'[\u{1F600}-\u{1F64F}]|'  // Emoticons
      r'[\u{1F300}-\u{1F5FF}]|'  // Misc Symbols and Pictographs
      r'[\u{1F680}-\u{1F6FF}]|'  // Transport and Map
      r'[\u{2600}-\u{26FF}]|'    // Misc symbols
      r'[\u{2700}-\u{27BF}]',    // Dingbats
      unicode: true,
    );
    return emojiRegex.hasMatch(input);
  }
}
