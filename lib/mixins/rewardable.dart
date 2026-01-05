/// Rewardable mixin for calculating rewards
/// Demonstrates: Mixin (混入)
mixin Rewardable {
  /// Calculate reward based on base exp and multiplier
  int calculateReward(int baseExp, int multiplier) => baseExp * multiplier;

  /// Calculate bonus reward based on streak
  int calculateStreakBonus(int baseExp, int streak) {
    if (streak >= 30) return baseExp ~/ 2; // 50% bonus
    if (streak >= 7) return baseExp ~/ 4;  // 25% bonus
    if (streak >= 3) return baseExp ~/ 10; // 10% bonus
    return 0;
  }
}
