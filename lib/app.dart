import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'providers/player_provider.dart';
import 'providers/quest_provider.dart';
import 'screens/home_screen.dart';
import 'screens/quest_screen.dart';
import 'screens/achievement_screen.dart';
import 'screens/stats_screen.dart';
import 'screens/settings_screen.dart';
import 'l10n/app_localizations.dart';
import 'services/storage_service.dart';

/// Main App Widget
class HabitHeroApp extends StatefulWidget {
  final StorageService storage;

  const HabitHeroApp({super.key, required this.storage});

  @override
  State<HabitHeroApp> createState() => _HabitHeroAppState();
}

class _HabitHeroAppState extends State<HabitHeroApp> {
  late ThemeMode _themeMode;
  late Locale _locale;

  @override
  void initState() {
    super.initState();
    // 從儲存載入主題和語言設定
    final themeIndex = widget.storage.getThemeMode();
    _themeMode = ThemeMode.values[themeIndex];
    _locale = Locale(widget.storage.getLocale());
  }

  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
      widget.storage.saveThemeMode(_themeMode.index);
    });
  }

  void _changeLanguage() {
    setState(() {
      _locale = _locale.languageCode == 'zh'
          ? const Locale('en')
          : const Locale('zh');
      widget.storage.saveLocale(_locale.languageCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PlayerProvider(widget.storage)),
        ChangeNotifierProvider(create: (_) => QuestProvider(widget.storage)),
      ],
      child: MaterialApp(
        title: 'Habit Hero',
        debugShowCheckedModeBanner: false,
        locale: _locale,
        supportedLocales: const [
          Locale('zh'),
          Locale('en'),
        ],
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        themeMode: _themeMode,
        theme: _buildLightTheme(),
        darkTheme: _buildDarkTheme(),
        home: MainNavigation(
          onThemeToggle: _toggleTheme,
          onLanguageChange: _changeLanguage,
          isDarkMode: _themeMode == ThemeMode.dark,
          currentLanguage: _locale.languageCode,
        ),
      ),
    );
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF6750A4),
        brightness: Brightness.light,
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF6750A4),
        brightness: Brightness.dark,
      ),
    );
  }
}

/// Main Navigation with BottomNavigationBar
class MainNavigation extends StatefulWidget {
  final VoidCallback onThemeToggle;
  final VoidCallback onLanguageChange;
  final bool isDarkMode;
  final String currentLanguage;

  const MainNavigation({
    super.key,
    required this.onThemeToggle,
    required this.onLanguageChange,
    required this.isDarkMode,
    required this.currentLanguage,
  });

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  bool _achievementsChecked = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check achievements after providers are initialized
    if (!_achievementsChecked) {
      _achievementsChecked = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _checkAchievementsOnLoad();
      });
    }
  }

  void _checkAchievementsOnLoad() {
    final playerProvider = Provider.of<PlayerProvider>(context, listen: false);
    final questProvider = Provider.of<QuestProvider>(context, listen: false);
    questProvider.checkAllAchievementsOnLoad(
      playerProvider.level,
      playerProvider.streak,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          const HomeScreen(),
          const QuestScreen(),
          const AchievementScreen(),
          const StatsScreen(),
          SettingsScreen(
            onThemeToggle: widget.onThemeToggle,
            onLanguageChange: widget.onLanguageChange,
            isDarkMode: widget.isDarkMode,
            currentLanguage: widget.currentLanguage,
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: l10n.home,
          ),
          NavigationDestination(
            icon: const Icon(Icons.assignment_outlined),
            selectedIcon: const Icon(Icons.assignment),
            label: l10n.quests,
          ),
          NavigationDestination(
            icon: const Icon(Icons.emoji_events_outlined),
            selectedIcon: const Icon(Icons.emoji_events),
            label: l10n.achievements,
          ),
          NavigationDestination(
            icon: const Icon(Icons.bar_chart_outlined),
            selectedIcon: const Icon(Icons.bar_chart),
            label: l10n.stats,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            label: l10n.settings,
          ),
        ],
      ),
    );
  }
}
