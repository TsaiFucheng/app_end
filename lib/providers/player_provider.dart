import 'package:flutter/foundation.dart';
import '../models/player.dart';
import '../models/experience.dart';
import '../services/storage_service.dart';

/// PlayerProvider for managing player state
/// Demonstrates: Provider State Management (狀態管理)
class PlayerProvider extends ChangeNotifier {
  final StorageService _storage;

  Player _player = Player(
    id: 'player_1',
    name: '冒險者',
    avatarIcon: '🦸',
  );

  PlayerProvider(this._storage) {
    loadData();
  }

  Player get player => _player;

  /// 從儲存載入玩家資料
  void loadData() {
    _player = Player(
      id: 'player_1',
      name: _storage.getPlayerName(),
      avatarIcon: _storage.getPlayerAvatar(),
      level: _storage.getPlayerLevel(),
      totalExp: Experience(_storage.getPlayerExp()),
      streak: _storage.getPlayerStreak(),
    );
    notifyListeners();
  }

  /// 儲存玩家資料
  Future<void> _saveData() async {
    await _storage.savePlayerData(
      name: _player.name,
      avatar: _player.avatarIcon,
      level: _player.level,
      exp: _player.totalExp.value,
      streak: _player.streak,
    );
  }

  /// Update player name
  void updateName(String name) {
    _player = _player.copyWith(name: name);
    _saveData();
    notifyListeners();
  }

  /// Update player avatar
  void updateAvatar(String avatar) {
    _player = _player.copyWith(avatarIcon: avatar);
    _saveData();
    notifyListeners();
  }

  /// Add experience to player
  /// Returns true if leveled up
  bool addExperience(int amount) {
    final exp = Experience(amount);
    final leveledUp = _player.addExperience(exp);
    _saveData();
    notifyListeners();
    return leveledUp;
  }

  /// Remove experience from player
  /// Returns true if leveled down
  bool removeExperience(int amount) {
    final exp = Experience(amount);
    final leveledDown = _player.removeExperience(exp);
    _saveData();
    notifyListeners();
    return leveledDown;
  }

  /// Increment streak
  void incrementStreak() {
    _player.incrementStreak();
    _saveData();
    notifyListeners();
  }

  /// Reset streak
  void resetStreak() {
    _player.resetStreak();
    _saveData();
    notifyListeners();
  }

  /// Get level progress (0.0 - 1.0)
  double get levelProgress => _player.levelProgress;

  /// Get experience for next level
  int get expForNextLevel => _player.expForNextLevel;

  /// Get current level
  int get level => _player.level;

  /// Get total experience
  int get totalExp => _player.totalExp.value;

  /// Get streak
  int get streak => _player.streak;

  /// Get player title
  String get title => _player.title;

  /// Reset player to initial state
  void reset() {
    _player = Player(
      id: 'player_1',
      name: '冒險者',
      avatarIcon: '🦸',
    );
    _saveData();
    notifyListeners();
  }
}
