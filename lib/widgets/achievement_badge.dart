import 'package:flutter/material.dart';
import '../models/achievement.dart';
import '../l10n/app_localizations.dart';

/// AchievementBadge widget for displaying achievement
class AchievementBadge extends StatelessWidget {
  final Achievement achievement;
  final VoidCallback? onTap;
  final double size;
  final int? currentProgress; // 目前進度

  const AchievementBadge({
    super.key,
    required this.achievement,
    this.onTap,
    this.size = 80,
    this.currentProgress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUnlocked = achievement.isUnlocked;
    final progress = currentProgress ?? 0;
    final requirement = achievement.requirement;
    final progressRatio = (progress / requirement).clamp(0.0, 1.0);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              // 進度圓環（未解鎖時顯示）
              if (!isUnlocked)
                SizedBox(
                  width: size,
                  height: size,
                  child: CircularProgressIndicator(
                    value: progressRatio,
                    strokeWidth: 3,
                    backgroundColor: theme.colorScheme.surfaceContainerHighest,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _getCategoryColor(achievement.category).withAlpha(150),
                    ),
                  ),
                ),
              // 主要徽章
              Container(
                width: size - (isUnlocked ? 0 : 8),
                height: size - (isUnlocked ? 0 : 8),
                decoration: BoxDecoration(
                  color: isUnlocked
                      ? _getCategoryColor(achievement.category).withAlpha(51)
                      : theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(size / 4),
                  border: Border.all(
                    color: isUnlocked
                        ? _getCategoryColor(achievement.category)
                        : theme.colorScheme.outlineVariant,
                    width: 2,
                  ),
                  boxShadow: isUnlocked
                      ? [
                          BoxShadow(
                            color: _getCategoryColor(achievement.category).withAlpha(77),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    achievement.icon,
                    style: TextStyle(
                      fontSize: (size - (isUnlocked ? 0 : 8)) * 0.4,
                      color: isUnlocked ? null : Colors.grey,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: size + 20,
            child: Column(
              children: [
                Text(
                  AppLocalizations.of(context).getAchievementTitle(achievement.id),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: isUnlocked
                        ? theme.colorScheme.onSurface
                        : theme.colorScheme.onSurfaceVariant,
                    fontWeight: isUnlocked ? FontWeight.bold : FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                // 進度文字（未解鎖時顯示）
                if (!isUnlocked)
                  Text(
                    '$progress / $requirement',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: _getCategoryColor(achievement.category),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(AchievementCategory category) {
    switch (category) {
      case AchievementCategory.quest:
        return Colors.blue;
      case AchievementCategory.streak:
        return Colors.orange;
      case AchievementCategory.level:
        return Colors.purple;
      case AchievementCategory.special:
        return Colors.teal;
    }
  }
}

/// Achievement detail dialog
class AchievementDetailDialog extends StatelessWidget {
  final Achievement achievement;
  final int? currentProgress; // 目前進度

  const AchievementDetailDialog({
    super.key,
    required this.achievement,
    this.currentProgress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUnlocked = achievement.isUnlocked;
    final progress = currentProgress ?? 0;
    final requirement = achievement.requirement;
    final progressRatio = (progress / requirement).clamp(0.0, 1.0);
    final remaining = requirement - progress;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: isUnlocked
                    ? _getCategoryColor(achievement.category).withAlpha(51)
                    : theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: isUnlocked
                      ? _getCategoryColor(achievement.category)
                      : theme.colorScheme.outlineVariant,
                  width: 3,
                ),
              ),
              child: Center(
                child: Text(
                  achievement.icon,
                  style: TextStyle(
                    fontSize: 48,
                    color: isUnlocked ? null : Colors.grey,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Title
            Text(
              AppLocalizations.of(context).getAchievementTitle(achievement.id),
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            // Description
            Text(
              AppLocalizations.of(context).getAchievementDescription(achievement.id),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            // Progress section (for locked achievements)
            if (!isUnlocked) ...[
              // Progress bar
              Builder(
                builder: (context) {
                  final l10n = AppLocalizations.of(context);
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.progress,
                            style: theme.textTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '$progress / $requirement',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: _getCategoryColor(achievement.category),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: progressRatio,
                          minHeight: 12,
                          backgroundColor: theme.colorScheme.surfaceContainerHighest,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _getCategoryColor(achievement.category),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        remaining > 0 ? '${l10n.remaining} $remaining ${_getUnitText(context, achievement.category)}' : l10n.aboutToUnlock,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 16),
            ],
            // Status
            Builder(
              builder: (context) {
                final l10n = AppLocalizations.of(context);
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isUnlocked
                        ? Colors.green.withAlpha(26)
                        : theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isUnlocked
                        ? '${l10n.unlockedAt} ${_formatDate(achievement.unlockedAt)}'
                        : l10n.locked,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: isUnlocked
                          ? Colors.green
                          : theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            // Close button
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(AppLocalizations.of(context).close),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getUnitText(BuildContext context, AchievementCategory category) {
    final l10n = AppLocalizations.of(context);
    switch (category) {
      case AchievementCategory.quest:
        return l10n.questUnit;
      case AchievementCategory.streak:
        return l10n.dayUnit;
      case AchievementCategory.level:
        return l10n.levelUnit;
      case AchievementCategory.special:
        return l10n.timeUnit;
    }
  }

  Color _getCategoryColor(AchievementCategory category) {
    switch (category) {
      case AchievementCategory.quest:
        return Colors.blue;
      case AchievementCategory.streak:
        return Colors.orange;
      case AchievementCategory.level:
        return Colors.purple;
      case AchievementCategory.special:
        return Colors.teal;
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.year}/${date.month}/${date.day}';
  }
}

/// Show achievement unlocked snackbar
void showAchievementUnlockedSnackBar(
    BuildContext context, Achievement achievement) {
  final l10n = AppLocalizations.of(context);
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Text(
            achievement.icon,
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.achievementUnlocked,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(l10n.getAchievementTitle(achievement.id)),
              ],
            ),
          ),
        ],
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      duration: const Duration(seconds: 3),
    ),
  );
}
