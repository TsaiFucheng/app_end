import 'package:flutter/material.dart';

/// App Localizations - 多語言支援
class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'zh': {
      'appTitle': '習慣英雄',
      'home': '首頁',
      'quests': '任務',
      'achievements': '成就',
      'stats': '統計',
      'settings': '設定',
      'dailyQuests': '每日任務',
      'weeklyQuests': '每週任務',
      'addQuest': '新增任務',
      'questName': '任務名稱',
      'description': '描述（選填）',
      'expReward': '經驗值獎勵',
      'targetCount': '目標次數',
      'cancel': '取消',
      'save': '儲存',
      'add': '新增',
      'delete': '刪除',
      'completed': '已完成',
      'pending': '未完成',
      'level': '等級',
      'experience': '經驗值',
      'streak': '連續天數',
      'todayProgress': '今日進度',
      'todayQuests': '今日任務',
      'totalCompleted': '已完成任務',
      'totalExp': '總經驗值',
      'unlocked': '已解鎖',
      'locked': '未解鎖',
      'profile': '個人資料',
      'appearance': '外觀',
      'darkMode': '深色模式',
      'language': '語言',
      'about': '關於',
      'version': '版本',
      'reset': '重置進度',
      'resetConfirm': '確定要重置所有進度嗎？此操作無法復原。',
      'confirmReset': '確認重置',
      'congratulations': '恭喜升級！',
      'great': '太棒了！',
      'close': '關閉',
      'goodMorning': '早安',
      'goodAfternoon': '午安',
      'goodEvening': '晚安',
      'noQuests': '尚未建立任務',
      'noQuestsHint': '點擊右下角按鈕新增任務',
      'recordOnce': '記錄一次',
      'achievementUnlocked': '成就解鎖！',
      'achievementCollection': '成就收集',
      'questAchievements': '任務成就',
      'streakAchievements': '連續達成',
      'levelAchievements': '等級成就',
      'specialAchievements': '特殊成就',
      'completedTasks': '個任務',
      'days': '天',
      'editName': '編輯名稱',
      'characterName': '角色名稱',
      'changeAvatar': '更換頭像',
      'selectAvatar': '選擇頭像',
      'courseProject': '課程專案',
      'appDescription': '遊戲化習慣養成 APP',
      'on': '已開啟',
      'off': '已關閉',
      'progressReset': '進度已重置',
      'deleted': '已刪除',
      'noData': '尚無資料',
      'completionRate': '今日完成率',
      'questDistribution': '任務分布',
      'daily': '每日',
      'weekly': '每週',
      'count': '個',
      'noDailyQuests': '尚未建立每日任務',
      'noWeeklyQuests': '尚未建立每週任務',
      'tapToAddQuest': '點擊右下角按鈕新增任務',
      'descriptionOptional': '描述（選填）',
      'times': '次',
      'levelUpTo': '升級到',
      'progress': '進度',
      'remaining': '還差',
      'aboutToUnlock': '即將解鎖！',
      'unlockedAt': '已解鎖',
      'clearDataAndRestart': '清除所有資料並重新開始',
      'courseInfo': '114學年度 APP程式設計',
      'chineseTraditional': '繁體中文',
      'questUnit': '個任務',
      'dayUnit': '天',
      'levelUnit': '級',
      'timeUnit': '次',
      'unlockedAchievements': '已解鎖',
      'achievementsCount': '個成就',
      // Achievement titles and descriptions
      'achievement_first_quest_title': '踏出第一步',
      'achievement_first_quest_desc': '完成你的第一個任務',
      'achievement_quest_10_title': '任務達人',
      'achievement_quest_10_desc': '累計完成 10 個任務',
      'achievement_quest_50_title': '任務專家',
      'achievement_quest_50_desc': '累計完成 50 個任務',
      'achievement_quest_100_title': '任務大師',
      'achievement_quest_100_desc': '累計完成 100 個任務',
      'achievement_streak_3_title': '持之以恆',
      'achievement_streak_3_desc': '連續 3 天完成任務',
      'achievement_streak_7_title': '一週達人',
      'achievement_streak_7_desc': '連續 7 天完成任務',
      'achievement_streak_30_title': '月度英雄',
      'achievement_streak_30_desc': '連續 30 天完成任務',
      'achievement_level_5_title': '嶄露頭角',
      'achievement_level_5_desc': '達到等級 5',
      'achievement_level_10_title': '穩步成長',
      'achievement_level_10_desc': '達到等級 10',
      'achievement_level_25_title': '實力派',
      'achievement_level_25_desc': '達到等級 25',
      'achievement_level_50_title': '傳奇英雄',
      'achievement_level_50_desc': '達到等級 50',
      'achievement_early_bird_title': '早起的鳥兒',
      'achievement_early_bird_desc': '在早上 6 點前完成任務',
      'achievement_night_owl_title': '夜貓子',
      'achievement_night_owl_desc': '在晚上 11 點後完成任務',
    },
    'en': {
      'appTitle': 'Habit Hero',
      'home': 'Home',
      'quests': 'Quests',
      'achievements': 'Achievements',
      'stats': 'Stats',
      'settings': 'Settings',
      'dailyQuests': 'Daily Quests',
      'weeklyQuests': 'Weekly Quests',
      'addQuest': 'Add Quest',
      'questName': 'Quest Name',
      'description': 'Description (Optional)',
      'expReward': 'EXP Reward',
      'targetCount': 'Target Count',
      'cancel': 'Cancel',
      'save': 'Save',
      'add': 'Add',
      'delete': 'Delete',
      'completed': 'Completed',
      'pending': 'Pending',
      'level': 'Level',
      'experience': 'Experience',
      'streak': 'Streak',
      'todayProgress': "Today's Progress",
      'todayQuests': "Today's Quests",
      'totalCompleted': 'Completed Quests',
      'totalExp': 'Total EXP',
      'unlocked': 'Unlocked',
      'locked': 'Locked',
      'profile': 'Profile',
      'appearance': 'Appearance',
      'darkMode': 'Dark Mode',
      'language': 'Language',
      'about': 'About',
      'version': 'Version',
      'reset': 'Reset Progress',
      'resetConfirm':
          'Are you sure you want to reset all progress? This action cannot be undone.',
      'confirmReset': 'Confirm Reset',
      'congratulations': 'Congratulations!',
      'great': 'Great!',
      'close': 'Close',
      'goodMorning': 'Good Morning',
      'goodAfternoon': 'Good Afternoon',
      'goodEvening': 'Good Evening',
      'noQuests': 'No quests yet',
      'noQuestsHint': 'Tap the button below to add a quest',
      'recordOnce': 'Record Once',
      'achievementUnlocked': 'Achievement Unlocked!',
      'achievementCollection': 'Achievement Collection',
      'questAchievements': 'Quest Achievements',
      'streakAchievements': 'Streak Achievements',
      'levelAchievements': 'Level Achievements',
      'specialAchievements': 'Special Achievements',
      'completedTasks': 'tasks',
      'days': 'days',
      'editName': 'Edit Name',
      'characterName': 'Character Name',
      'changeAvatar': 'Change Avatar',
      'selectAvatar': 'Select Avatar',
      'courseProject': 'Course Project',
      'appDescription': 'Gamified Habit Tracking APP',
      'on': 'On',
      'off': 'Off',
      'progressReset': 'Progress has been reset',
      'deleted': 'Deleted',
      'noData': 'No data yet',
      'completionRate': 'Today\'s Completion Rate',
      'questDistribution': 'Quest Distribution',
      'daily': 'Daily',
      'weekly': 'Weekly',
      'count': '',
      'noDailyQuests': 'No daily quests yet',
      'noWeeklyQuests': 'No weekly quests yet',
      'tapToAddQuest': 'Tap the button to add a quest',
      'descriptionOptional': 'Description (Optional)',
      'times': 'times',
      'levelUpTo': 'Level up to',
      'progress': 'Progress',
      'remaining': 'remaining',
      'aboutToUnlock': 'About to unlock!',
      'unlockedAt': 'Unlocked',
      'clearDataAndRestart': 'Clear all data and restart',
      'courseInfo': '114 Academic Year App Programming',
      'chineseTraditional': 'Traditional Chinese',
      'questUnit': 'quests',
      'dayUnit': 'days',
      'levelUnit': 'levels',
      'timeUnit': 'times',
      'unlockedAchievements': 'Unlocked',
      'achievementsCount': 'achievements',
      // Achievement titles and descriptions
      'achievement_first_quest_title': 'First Step',
      'achievement_first_quest_desc': 'Complete your first quest',
      'achievement_quest_10_title': 'Quest Enthusiast',
      'achievement_quest_10_desc': 'Complete 10 quests in total',
      'achievement_quest_50_title': 'Quest Expert',
      'achievement_quest_50_desc': 'Complete 50 quests in total',
      'achievement_quest_100_title': 'Quest Master',
      'achievement_quest_100_desc': 'Complete 100 quests in total',
      'achievement_streak_3_title': 'Persistence',
      'achievement_streak_3_desc': 'Complete quests for 3 consecutive days',
      'achievement_streak_7_title': 'Weekly Champion',
      'achievement_streak_7_desc': 'Complete quests for 7 consecutive days',
      'achievement_streak_30_title': 'Monthly Hero',
      'achievement_streak_30_desc': 'Complete quests for 30 consecutive days',
      'achievement_level_5_title': 'Rising Star',
      'achievement_level_5_desc': 'Reach level 5',
      'achievement_level_10_title': 'Steady Growth',
      'achievement_level_10_desc': 'Reach level 10',
      'achievement_level_25_title': 'Powerhouse',
      'achievement_level_25_desc': 'Reach level 25',
      'achievement_level_50_title': 'Legendary Hero',
      'achievement_level_50_desc': 'Reach level 50',
      'achievement_early_bird_title': 'Early Bird',
      'achievement_early_bird_desc': 'Complete a quest before 6 AM',
      'achievement_night_owl_title': 'Night Owl',
      'achievement_night_owl_desc': 'Complete a quest after 11 PM',
    },
  };

  String get appTitle => _localizedValues[locale.languageCode]!['appTitle']!;
  String get home => _localizedValues[locale.languageCode]!['home']!;
  String get quests => _localizedValues[locale.languageCode]!['quests']!;
  String get achievements =>
      _localizedValues[locale.languageCode]!['achievements']!;
  String get stats => _localizedValues[locale.languageCode]!['stats']!;
  String get settings => _localizedValues[locale.languageCode]!['settings']!;
  String get dailyQuests =>
      _localizedValues[locale.languageCode]!['dailyQuests']!;
  String get weeklyQuests =>
      _localizedValues[locale.languageCode]!['weeklyQuests']!;
  String get addQuest => _localizedValues[locale.languageCode]!['addQuest']!;
  String get questName => _localizedValues[locale.languageCode]!['questName']!;
  String get description =>
      _localizedValues[locale.languageCode]!['description']!;
  String get expReward => _localizedValues[locale.languageCode]!['expReward']!;
  String get targetCount =>
      _localizedValues[locale.languageCode]!['targetCount']!;
  String get cancel => _localizedValues[locale.languageCode]!['cancel']!;
  String get save => _localizedValues[locale.languageCode]!['save']!;
  String get add => _localizedValues[locale.languageCode]!['add']!;
  String get delete => _localizedValues[locale.languageCode]!['delete']!;
  String get completed => _localizedValues[locale.languageCode]!['completed']!;
  String get pending => _localizedValues[locale.languageCode]!['pending']!;
  String get level => _localizedValues[locale.languageCode]!['level']!;
  String get experience =>
      _localizedValues[locale.languageCode]!['experience']!;
  String get streak => _localizedValues[locale.languageCode]!['streak']!;
  String get todayProgress =>
      _localizedValues[locale.languageCode]!['todayProgress']!;
  String get todayQuests =>
      _localizedValues[locale.languageCode]!['todayQuests']!;
  String get totalCompleted =>
      _localizedValues[locale.languageCode]!['totalCompleted']!;
  String get totalExp => _localizedValues[locale.languageCode]!['totalExp']!;
  String get unlocked => _localizedValues[locale.languageCode]!['unlocked']!;
  String get locked => _localizedValues[locale.languageCode]!['locked']!;
  String get profile => _localizedValues[locale.languageCode]!['profile']!;
  String get appearance =>
      _localizedValues[locale.languageCode]!['appearance']!;
  String get darkMode => _localizedValues[locale.languageCode]!['darkMode']!;
  String get language => _localizedValues[locale.languageCode]!['language']!;
  String get about => _localizedValues[locale.languageCode]!['about']!;
  String get version => _localizedValues[locale.languageCode]!['version']!;
  String get reset => _localizedValues[locale.languageCode]!['reset']!;
  String get resetConfirm =>
      _localizedValues[locale.languageCode]!['resetConfirm']!;
  String get confirmReset =>
      _localizedValues[locale.languageCode]!['confirmReset']!;
  String get congratulations =>
      _localizedValues[locale.languageCode]!['congratulations']!;
  String get great => _localizedValues[locale.languageCode]!['great']!;
  String get close => _localizedValues[locale.languageCode]!['close']!;
  String get goodMorning =>
      _localizedValues[locale.languageCode]!['goodMorning']!;
  String get goodAfternoon =>
      _localizedValues[locale.languageCode]!['goodAfternoon']!;
  String get goodEvening =>
      _localizedValues[locale.languageCode]!['goodEvening']!;
  String get noQuests => _localizedValues[locale.languageCode]!['noQuests']!;
  String get noQuestsHint =>
      _localizedValues[locale.languageCode]!['noQuestsHint']!;
  String get recordOnce =>
      _localizedValues[locale.languageCode]!['recordOnce']!;
  String get achievementUnlocked =>
      _localizedValues[locale.languageCode]!['achievementUnlocked']!;
  String get achievementCollection =>
      _localizedValues[locale.languageCode]!['achievementCollection']!;
  String get questAchievements =>
      _localizedValues[locale.languageCode]!['questAchievements']!;
  String get streakAchievements =>
      _localizedValues[locale.languageCode]!['streakAchievements']!;
  String get levelAchievements =>
      _localizedValues[locale.languageCode]!['levelAchievements']!;
  String get specialAchievements =>
      _localizedValues[locale.languageCode]!['specialAchievements']!;
  String get completedTasks =>
      _localizedValues[locale.languageCode]!['completedTasks']!;
  String get days => _localizedValues[locale.languageCode]!['days']!;
  String get editName => _localizedValues[locale.languageCode]!['editName']!;
  String get characterName =>
      _localizedValues[locale.languageCode]!['characterName']!;
  String get changeAvatar =>
      _localizedValues[locale.languageCode]!['changeAvatar']!;
  String get selectAvatar =>
      _localizedValues[locale.languageCode]!['selectAvatar']!;
  String get courseProject =>
      _localizedValues[locale.languageCode]!['courseProject']!;
  String get appDescription =>
      _localizedValues[locale.languageCode]!['appDescription']!;
  String get on => _localizedValues[locale.languageCode]!['on']!;
  String get off => _localizedValues[locale.languageCode]!['off']!;
  String get progressReset =>
      _localizedValues[locale.languageCode]!['progressReset']!;
  String get deleted => _localizedValues[locale.languageCode]!['deleted']!;
  String get noData => _localizedValues[locale.languageCode]!['noData']!;
  String get completionRate =>
      _localizedValues[locale.languageCode]!['completionRate']!;
  String get questDistribution =>
      _localizedValues[locale.languageCode]!['questDistribution']!;
  String get daily => _localizedValues[locale.languageCode]!['daily']!;
  String get weekly => _localizedValues[locale.languageCode]!['weekly']!;
  String get count => _localizedValues[locale.languageCode]!['count']!;
  String get noDailyQuests =>
      _localizedValues[locale.languageCode]!['noDailyQuests']!;
  String get noWeeklyQuests =>
      _localizedValues[locale.languageCode]!['noWeeklyQuests']!;
  String get tapToAddQuest =>
      _localizedValues[locale.languageCode]!['tapToAddQuest']!;
  String get descriptionOptional =>
      _localizedValues[locale.languageCode]!['descriptionOptional']!;
  String get times => _localizedValues[locale.languageCode]!['times']!;
  String get levelUpTo =>
      _localizedValues[locale.languageCode]!['levelUpTo']!;
  String get progress => _localizedValues[locale.languageCode]!['progress']!;
  String get remaining => _localizedValues[locale.languageCode]!['remaining']!;
  String get aboutToUnlock =>
      _localizedValues[locale.languageCode]!['aboutToUnlock']!;
  String get unlockedAt =>
      _localizedValues[locale.languageCode]!['unlockedAt']!;
  String get clearDataAndRestart =>
      _localizedValues[locale.languageCode]!['clearDataAndRestart']!;
  String get courseInfo =>
      _localizedValues[locale.languageCode]!['courseInfo']!;
  String get chineseTraditional =>
      _localizedValues[locale.languageCode]!['chineseTraditional']!;
  String get questUnit =>
      _localizedValues[locale.languageCode]!['questUnit']!;
  String get dayUnit => _localizedValues[locale.languageCode]!['dayUnit']!;
  String get levelUnit =>
      _localizedValues[locale.languageCode]!['levelUnit']!;
  String get timeUnit => _localizedValues[locale.languageCode]!['timeUnit']!;
  String get unlockedAchievements =>
      _localizedValues[locale.languageCode]!['unlockedAchievements']!;
  String get achievementsCount =>
      _localizedValues[locale.languageCode]!['achievementsCount']!;

  /// Get localized achievement title by achievement id
  String getAchievementTitle(String achievementId) {
    final key = 'achievement_${achievementId}_title';
    return _localizedValues[locale.languageCode]![key] ?? achievementId;
  }

  /// Get localized achievement description by achievement id
  String getAchievementDescription(String achievementId) {
    final key = 'achievement_${achievementId}_desc';
    return _localizedValues[locale.languageCode]![key] ?? '';
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'zh'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
