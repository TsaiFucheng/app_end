import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/player_provider.dart';
import '../providers/quest_provider.dart';
import '../l10n/app_localizations.dart';

/// SettingsScreen - App settings and preferences
class SettingsScreen extends StatelessWidget {
  final VoidCallback? onThemeToggle;
  final VoidCallback? onLanguageChange;
  final bool isDarkMode;
  final String currentLanguage;

  const SettingsScreen({
    super.key,
    this.onThemeToggle,
    this.onLanguageChange,
    this.isDarkMode = false,
    this.currentLanguage = 'zh',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).settings),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile section
          _buildSectionHeader(context, AppLocalizations.of(context).profile),
          _buildProfileCard(context),
          const SizedBox(height: 24),

          // Appearance section
          _buildSectionHeader(context, AppLocalizations.of(context).appearance),
          _buildAppearanceCard(context),
          const SizedBox(height: 24),

          // About section
          _buildSectionHeader(context, AppLocalizations.of(context).about),
          _buildAboutCard(context),
          const SizedBox(height: 24),

          // Reset section
          _buildResetCard(context),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<PlayerProvider>(
      builder: (context, playerProvider, child) {
        final player = playerProvider.player;

        return Card(
          elevation: 0,
          color: theme.colorScheme.surfaceContainerHighest,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Column(
            children: [
              ListTile(
                leading: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      player.avatarIcon,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                title: Text(player.name),
                subtitle: Text('Lv.${player.level} ${playerProvider.title}'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showEditNameDialog(context, playerProvider),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.emoji_emotions_outlined),
                title: Text(AppLocalizations.of(context).changeAvatar),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showAvatarPicker(context, playerProvider),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAppearanceCard(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          SwitchListTile(
            secondary: Icon(
              isDarkMode ? Icons.dark_mode : Icons.light_mode,
            ),
            title: Text(AppLocalizations.of(context).darkMode),
            subtitle: Text(isDarkMode ? AppLocalizations.of(context).on : AppLocalizations.of(context).off),
            value: isDarkMode,
            onChanged: (_) => onThemeToggle?.call(),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(AppLocalizations.of(context).language),
            subtitle: Text(currentLanguage == 'zh' ? AppLocalizations.of(context).chineseTraditional : 'English'),
            trailing: const Icon(Icons.chevron_right),
            onTap: onLanguageChange,
          ),
        ],
      ),
    );
  }

  Widget _buildAboutCard(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(l10n.version),
            trailing: Text(
              'v1.0.0',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.school_outlined),
            title: Text(l10n.courseProject),
            subtitle: Text(l10n.courseInfo),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.favorite_outline),
            title: Text(l10n.appTitle),
            subtitle: Text(l10n.appDescription),
          ),
        ],
      ),
    );
  }

  Widget _buildResetCard(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Card(
      elevation: 0,
      color: theme.colorScheme.errorContainer.withAlpha(77),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: Icon(Icons.refresh, color: theme.colorScheme.error),
        title: Text(
          l10n.reset,
          style: TextStyle(color: theme.colorScheme.error),
        ),
        subtitle: Text(l10n.clearDataAndRestart),
        onTap: () => _showResetConfirmDialog(context),
      ),
    );
  }

  void _showEditNameDialog(BuildContext context, PlayerProvider provider) {
    final controller = TextEditingController(text: provider.player.name);
    final l10n = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.editName),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: l10n.characterName,
            border: const OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                provider.updateName(controller.text);
              }
              Navigator.of(dialogContext).pop();
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }

  void _showAvatarPicker(BuildContext context, PlayerProvider provider) {
    final avatars = [
      '🦸', '🦸‍♀️', '🦸‍♂️', '🧙', '🧙‍♀️', '🧙‍♂️',
      '🥷', '🧝', '🧝‍♀️', '🧝‍♂️', '🧛', '🧛‍♀️',
      '🧜', '🧜‍♀️', '🧜‍♂️', '🧚', '🧚‍♀️', '🧚‍♂️',
      '👨‍🚀', '👩‍🚀', '🐱', '🐶', '🦊', '🦁',
      '🐯', '🐻', '🐼', '🐨', '🦄', '🐲',
    ];
    final l10n = AppLocalizations.of(context);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.selectAvatar,
              style: Theme.of(sheetContext).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemCount: avatars.length,
              itemBuilder: (context, index) {
                final avatar = avatars[index];
                final isSelected = avatar == provider.player.avatarIcon;

                return GestureDetector(
                  onTap: () {
                    provider.updateAvatar(avatar);
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primaryContainer
                          : Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                      border: isSelected
                          ? Border.all(
                              color: Theme.of(context).colorScheme.primary,
                              width: 2,
                            )
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        avatar,
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showResetConfirmDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.confirmReset),
        content: Text(l10n.resetConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(dialogContext).colorScheme.error,
            ),
            onPressed: () {
              final playerProvider =
                  Provider.of<PlayerProvider>(context, listen: false);
              final questProvider =
                  Provider.of<QuestProvider>(context, listen: false);
              playerProvider.reset();
              questProvider.resetAll();
              Navigator.of(dialogContext).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.progressReset),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: Text(l10n.reset),
          ),
        ],
      ),
    );
  }
}
