import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/player_provider.dart';
import '../providers/quest_provider.dart';
import '../widgets/exp_bar.dart';
import '../widgets/quest_card.dart';
import '../l10n/app_localizations.dart';

/// HomeScreen - Main dashboard showing player status and today's quests
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 24),
              _buildPlayerCard(context),
              const SizedBox(height: 24),
              _buildTodayProgress(context),
              const SizedBox(height: 24),
              _buildTodayQuests(context),
              const SizedBox(height: 24),
              _buildWeeklyQuests(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final hour = DateTime.now().hour;
    String greeting;
    if (hour < 12) {
      greeting = l10n.goodMorning;
    } else if (hour < 18) {
      greeting = l10n.goodAfternoon;
    } else {
      greeting = l10n.goodEvening;
    }

    return Consumer<PlayerProvider>(
      builder: (context, playerProvider, child) {
        return Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$greeting！',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    playerProvider.player.name,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // Avatar
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  playerProvider.player.avatarIcon,
                  style: const TextStyle(fontSize: 32),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPlayerCard(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Consumer<PlayerProvider>(
      builder: (context, playerProvider, child) {
        final player = playerProvider.player;
        final expInLevel = player.totalExp.value -
            _getTotalExpForLevel(player.level - 1);

        return Card(
          elevation: 0,
          color: theme.colorScheme.primaryContainer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    // Title badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        playerProvider.title,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Spacer(),
                    // Streak
                    Row(
                      children: [
                        const Icon(Icons.local_fire_department,
                            color: Colors.orange, size: 20),
                        const SizedBox(width: 4),
                        Text(
                          '${playerProvider.streak} ${l10n.days}',
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ExpBar(
                  progress: playerProvider.levelProgress,
                  currentExp: expInLevel,
                  maxExp: playerProvider.expForNextLevel,
                  level: playerProvider.level,
                  foregroundColor: theme.colorScheme.primary,
                  backgroundColor:
                      theme.colorScheme.onPrimaryContainer.withAlpha(50),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.star,
                      size: 16,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${l10n.totalExp}: ${player.totalExp.value}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTodayProgress(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Consumer<QuestProvider>(
      builder: (context, questProvider, child) {
        final completed = questProvider.todayCompletedCount;
        final total = questProvider.todayTotalCount;
        final progress = questProvider.todayCompletionRate;

        return Card(
          elevation: 0,
          color: theme.colorScheme.surfaceContainerHighest,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Circular progress
                SizedBox(
                  width: 60,
                  height: 60,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 6,
                        backgroundColor: theme.colorScheme.surfaceContainerHigh,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          theme.colorScheme.primary,
                        ),
                      ),
                      Center(
                        child: Text(
                          '${(progress * 100).toInt()}%',
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.todayProgress,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${l10n.completed} $completed / $total ${l10n.completedTasks}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                if (completed == total && total > 0)
                  const Icon(
                    Icons.emoji_events,
                    color: Colors.amber,
                    size: 32,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTodayQuests(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Consumer2<QuestProvider, PlayerProvider>(
      builder: (context, questProvider, playerProvider, child) {
        final dailyQuests = questProvider.dailyQuests;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.todayQuests,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${dailyQuests.where((q) => q.isCompleted).length}/${dailyQuests.length}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (dailyQuests.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      Icon(
                        Icons.task_alt,
                        size: 48,
                        color: theme.colorScheme.outline,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.noQuests,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: dailyQuests.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final quest = dailyQuests[index];
                  return QuestCardMini(
                    quest: quest,
                    onTap: () {
                      final exp = questProvider.toggleQuestCompletion(quest.id);
                      if (exp != null) {
                        if (exp > 0) {
                          // Quest completed - add experience
                          final leveledUp = playerProvider.addExperience(exp);
                          if (leveledUp) {
                            _showLevelUpDialog(context, playerProvider.level);
                            // 檢查等級成就
                            questProvider.checkLevelAchievement(playerProvider.level);
                          }
                        } else {
                          // Quest unchecked - remove experience
                          playerProvider.removeExperience(-exp);
                        }
                      }
                    },
                  );
                },
              ),
          ],
        );
      },
    );
  }

  Widget _buildWeeklyQuests(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Consumer2<QuestProvider, PlayerProvider>(
      builder: (context, questProvider, playerProvider, child) {
        final weeklyQuests = questProvider.weeklyQuests;

        if (weeklyQuests.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.weeklyQuests,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${weeklyQuests.where((q) => q.isCompleted).length}/${weeklyQuests.length}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: weeklyQuests.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final quest = weeklyQuests[index];
                return WeeklyQuestCardMini(
                  quest: quest,
                  onTap: () {
                    if (!quest.isCompleted) {
                      questProvider.incrementWeeklyProgress(quest.id);
                      if (quest.isCompleted) {
                        final leveledUp = playerProvider.addExperience(quest.expReward);
                        if (leveledUp) {
                          _showLevelUpDialog(context, playerProvider.level);
                          questProvider.checkLevelAchievement(playerProvider.level);
                        }
                      }
                    }
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }

  int _getTotalExpForLevel(int level) {
    if (level <= 0) return 0;
    return 50 * level * (level + 1);
  }

  void _showLevelUpDialog(BuildContext context, int newLevel) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '🎉',
              style: TextStyle(fontSize: 64),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.congratulations,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Lv.$newLevel',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.great),
          ),
        ],
      ),
    );
  }
}
