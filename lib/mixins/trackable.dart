/// Trackable mixin for tracking completion time
/// Demonstrates: Mixin (混入)
mixin Trackable {
  DateTime? completedAt;

  /// Mark as completed with current timestamp
  void markCompleted() => completedAt = DateTime.now();

  /// Check if completed today
  bool get isCompletedToday {
    if (completedAt == null) return false;
    final now = DateTime.now();
    return completedAt!.year == now.year &&
        completedAt!.month == now.month &&
        completedAt!.day == now.day;
  }

  /// Get time since completion
  Duration? get timeSinceCompletion {
    if (completedAt == null) return null;
    return DateTime.now().difference(completedAt!);
  }
}
