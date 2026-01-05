// 型別定義 (typedef)
// Demonstrates: typedef (型別別名)

import '../models/quest.dart';
import '../models/achievement.dart';

/// 經驗值計算函數
typedef ExpCalculator = int Function(int baseExp, double multiplier);

/// 任務完成回呼
typedef QuestCompletionCallback = void Function(Quest quest, int expGained);

/// 成就解鎖回呼
typedef AchievementUnlockCallback = void Function(Achievement achievement);

/// 等級提升回呼
typedef LevelUpCallback = void Function(int oldLevel, int newLevel);

/// 資料驗證函數
typedef Validator<T> = bool Function(T value);

/// 字串驗證函數
typedef StringValidator = Validator<String>;

/// 數值驗證函數
typedef NumberValidator = Validator<num>;

/// 非同步資料載入函數
typedef AsyncLoader<T> = Future<T> Function();

/// 非同步資料儲存函數
typedef AsyncSaver<T> = Future<void> Function(T data);

/// JSON 轉換函數
typedef JsonParser<T> = T Function(Map<String, dynamic> json);

/// 物件轉 JSON 函數
typedef JsonSerializer<T> = Map<String, dynamic> Function(T object);

/// 列表過濾函數
typedef ListFilter<T> = bool Function(T item);

/// 列表排序比較函數
typedef ListSorter<T> = int Function(T a, T b);

/// 錯誤處理函數
typedef ErrorHandler = void Function(Object error, StackTrace stackTrace);

/// 進度更新回呼
typedef ProgressCallback = void Function(double progress);
