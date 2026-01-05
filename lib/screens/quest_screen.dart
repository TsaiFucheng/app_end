import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quest_provider.dart';
import '../providers/player_provider.dart';
import '../widgets/quest_card.dart';
import '../models/quest.dart';
import '../l10n/app_localizations.dart';

/// QuestScreen - Manage daily and weekly quests
class QuestScreen extends StatefulWidget {
  const QuestScreen({super.key});

  @override
  State<QuestScreen> createState() => _QuestScreenState();
}

class _QuestScreenState extends State<QuestScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.quests),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: l10n.dailyQuests, icon: const Icon(Icons.today)),
            Tab(text: l10n.weeklyQuests, icon: const Icon(Icons.date_range)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDailyQuestList(context),
          _buildWeeklyQuestList(context),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddQuestDialog(context),
        icon: const Icon(Icons.add),
        label: Text(l10n.addQuest),
      ),
    );
  }

  Widget _buildDailyQuestList(BuildContext context) {
    return Consumer2<QuestProvider, PlayerProvider>(
      builder: (context, questProvider, playerProvider, child) {
        final quests = questProvider.dailyQuests;

        if (quests.isEmpty) {
          return _buildEmptyState(context, AppLocalizations.of(context).noDailyQuests);
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: quests.length,
          itemBuilder: (context, index) {
            final quest = quests[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: QuestCard(
                quest: quest,
                onComplete: () {
                  final exp = questProvider.toggleQuestCompletion(quest.id);
                  if (exp != null) {
                    if (exp > 0) {
                      // Quest completed - add experience
                      final leveledUp = playerProvider.addExperience(exp);
                      _showExpGainedSnackBar(context, exp, leveledUp,
                          leveledUp ? playerProvider.level : null);
                      // 檢查等級成就
                      if (leveledUp) {
                        questProvider.checkLevelAchievement(playerProvider.level);
                      }
                    } else {
                      // Quest unchecked - remove experience
                      playerProvider.removeExperience(-exp);
                    }
                  }
                },
                onDelete: () {
                  questProvider.removeQuest(quest.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${AppLocalizations.of(context).deleted}「${quest.title}」'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildWeeklyQuestList(BuildContext context) {
    return Consumer2<QuestProvider, PlayerProvider>(
      builder: (context, questProvider, playerProvider, child) {
        final quests = questProvider.weeklyQuests;

        if (quests.isEmpty) {
          return _buildEmptyState(context, AppLocalizations.of(context).noWeeklyQuests);
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: quests.length,
          itemBuilder: (context, index) {
            final quest = quests[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildWeeklyQuestCard(
                  context, quest, questProvider, playerProvider),
            );
          },
        );
      },
    );
  }

  Widget _buildWeeklyQuestCard(BuildContext context, WeeklyQuest quest,
      QuestProvider questProvider, PlayerProvider playerProvider) {
    final theme = Theme.of(context);
    final isCompleted = quest.isCompleted;

    return Card(
      elevation: isCompleted ? 0 : 2,
      color: isCompleted
          ? theme.colorScheme.surfaceContainerHighest.withAlpha(128)
          : theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isCompleted
            ? BorderSide.none
            : BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: Dismissible(
        key: Key(quest.id),
        direction: DismissDirection.endToStart,
        onDismissed: (_) {
          questProvider.removeQuest(quest.id);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${AppLocalizations.of(context).deleted}「${quest.title}」'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          decoration: BoxDecoration(
            color: theme.colorScheme.error,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(Icons.delete, color: theme.colorScheme.onError),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          quest.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            decoration:
                                isCompleted ? TextDecoration.lineThrough : null,
                          ),
                        ),
                        if (quest.description.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            quest.description,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? Colors.green.withAlpha(26)
                          : theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.star,
                          size: 16,
                          color: isCompleted
                              ? Colors.green
                              : theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '+${quest.expReward}',
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isCompleted
                                ? Colors.green
                                : theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Progress bar
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: quest.progress,
                        minHeight: 12,
                        backgroundColor: theme.colorScheme.surfaceContainerHigh,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isCompleted
                              ? Colors.green
                              : theme.colorScheme.secondary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${quest.currentCount}/${quest.targetCount}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Increment button
              if (!isCompleted)
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      questProvider.incrementWeeklyProgress(quest.id);
                      if (quest.isCompleted) {
                        final leveledUp =
                            playerProvider.addExperience(quest.expReward);
                        _showExpGainedSnackBar(context, quest.expReward,
                            leveledUp, leveledUp ? playerProvider.level : null);
                      }
                    },
                    icon: const Icon(Icons.add),
                    label: Text(AppLocalizations.of(context).recordOnce),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, String message) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.assignment_outlined,
            size: 80,
            color: theme.colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.tapToAddQuest,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddQuestDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    final expController = TextEditingController(text: '10');
    final targetController = TextEditingController(text: '7');
    bool isDaily = _tabController.index == 0;
    final l10n = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => AlertDialog(
          title: Text(l10n.addQuest),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Task type selector
                SegmentedButton<bool>(
                  segments: [
                    ButtonSegment(
                      value: true,
                      label: Text(l10n.daily),
                      icon: const Icon(Icons.today),
                    ),
                    ButtonSegment(
                      value: false,
                      label: Text(l10n.weekly),
                      icon: const Icon(Icons.date_range),
                    ),
                  ],
                  selected: {isDaily},
                  onSelectionChanged: (selection) {
                    setDialogState(() {
                      isDaily = selection.first;
                      expController.text = isDaily ? '10' : '50';
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: l10n.questName,
                    border: const OutlineInputBorder(),
                  ),
                  autofocus: true,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descController,
                  decoration: InputDecoration(
                    labelText: l10n.descriptionOptional,
                    border: const OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: expController,
                  decoration: InputDecoration(
                    labelText: l10n.expReward,
                    border: const OutlineInputBorder(),
                    suffixText: 'EXP',
                  ),
                  keyboardType: TextInputType.number,
                ),
                if (!isDaily) ...[
                  const SizedBox(height: 12),
                  TextField(
                    controller: targetController,
                    decoration: InputDecoration(
                      labelText: l10n.targetCount,
                      border: const OutlineInputBorder(),
                      suffixText: l10n.times,
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () {
                if (titleController.text.isEmpty) {
                  return;
                }

                final questProvider =
                    Provider.of<QuestProvider>(context, listen: false);
                final exp = int.tryParse(expController.text) ?? 10;

                if (isDaily) {
                  questProvider.createDailyQuest(
                    title: titleController.text,
                    description: descController.text,
                    expReward: exp,
                  );
                } else {
                  final target = int.tryParse(targetController.text) ?? 7;
                  questProvider.createWeeklyQuest(
                    title: titleController.text,
                    description: descController.text,
                    expReward: exp,
                    targetCount: target,
                  );
                }

                Navigator.of(dialogContext).pop();
              },
              child: Text(l10n.add),
            ),
          ],
        ),
      ),
    );
  }

  void _showExpGainedSnackBar(
      BuildContext context, int exp, bool leveledUp, int? newLevel) {
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.star, color: Colors.amber),
            const SizedBox(width: 8),
            Text('+$exp EXP'),
            if (leveledUp && newLevel != null) ...[
              const SizedBox(width: 16),
              const Icon(Icons.arrow_upward, color: Colors.green),
              const SizedBox(width: 4),
              Text('${l10n.levelUpTo} Lv.$newLevel!'),
            ],
          ],
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
