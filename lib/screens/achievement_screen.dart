import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quest_provider.dart';
import '../providers/player_provider.dart';
import '../models/achievement.dart';
import '../widgets/achievement_badge.dart';
import '../l10n/app_localizations.dart';

/// AchievementScreen - Display achievement badges
class AchievementScreen extends StatelessWidget {
  const AchievementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).achievements),
        centerTitle: true,
      ),
      body: Consumer2<QuestProvider, PlayerProvider>(
        builder: (context, questProvider, playerProvider, child) {
          final achievements = questProvider.achievements;
          final unlocked = questProvider.unlockedAchievements;

          // 取得各類別的目前進度
          final progressMap = _getProgressMap(questProvider, playerProvider);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Summary card
                _buildSummaryCard(context, unlocked.length, achievements.length),
                const SizedBox(height: 24),

                // Unlocked achievements
                if (unlocked.isNotEmpty) ...[
                  _buildSectionHeader(context, AppLocalizations.of(context).unlockedAchievements, unlocked.length),
                  const SizedBox(height: 12),
                  _buildAchievementGrid(context, unlocked, progressMap),
                  const SizedBox(height: 24),
                ],

                // Locked achievements by category
                ..._buildCategorySections(context, achievements, progressMap),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, int unlocked, int total) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final progress = total > 0 ? unlocked / total : 0.0;

    return Card(
      elevation: 0,
      color: theme.colorScheme.primaryContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            // Trophy icon
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withAlpha(51),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Text('🏆', style: TextStyle(fontSize: 32)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.achievementCollection,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${l10n.unlockedAchievements} $unlocked / $total ${l10n.achievementsCount}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 8,
                      backgroundColor: theme.colorScheme.primary.withAlpha(51),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, int count) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '$count',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAchievementGrid(
      BuildContext context, List<Achievement> achievements, Map<AchievementCategory, int> progressMap) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.7,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: achievements.length,
      itemBuilder: (context, index) {
        final achievement = achievements[index];
        final progress = progressMap[achievement.category] ?? 0;
        return AchievementBadge(
          achievement: achievement,
          currentProgress: progress,
          onTap: () => _showAchievementDetail(context, achievement, progress),
        );
      },
    );
  }

  List<Widget> _buildCategorySections(
      BuildContext context, List<Achievement> achievements, Map<AchievementCategory, int> progressMap) {
    final widgets = <Widget>[];
    final l10n = AppLocalizations.of(context);

    final categories = {
      AchievementCategory.quest: l10n.questAchievements,
      AchievementCategory.streak: l10n.streakAchievements,
      AchievementCategory.level: l10n.levelAchievements,
      AchievementCategory.special: l10n.specialAchievements,
    };

    for (final entry in categories.entries) {
      final categoryAchievements = achievements
          .where((a) => a.category == entry.key && !a.isUnlocked)
          .toList();

      if (categoryAchievements.isNotEmpty) {
        widgets.add(
          _buildSectionHeader(
              context, entry.value, categoryAchievements.length),
        );
        widgets.add(const SizedBox(height: 12));
        widgets.add(_buildAchievementGrid(context, categoryAchievements, progressMap));
        widgets.add(const SizedBox(height: 24));
      }
    }

    return widgets;
  }

  void _showAchievementDetail(BuildContext context, Achievement achievement, int progress) {
    showDialog(
      context: context,
      builder: (context) => AchievementDetailDialog(
        achievement: achievement,
        currentProgress: progress,
      ),
    );
  }

  /// 取得各類別的目前進度
  Map<AchievementCategory, int> _getProgressMap(
      QuestProvider questProvider, PlayerProvider playerProvider) {
    return {
      AchievementCategory.quest: questProvider.totalCompleted,
      AchievementCategory.streak: playerProvider.streak,
      AchievementCategory.level: playerProvider.level,
      AchievementCategory.special: 0, // 特殊成就需要個別處理
    };
  }
}
