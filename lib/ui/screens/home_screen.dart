import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/modes/game_mode.dart';
import '../../features/modes/mode_controller.dart';
import '../components/app_top_bar.dart';
import '../components/card_tile.dart';
import '../components/locale_menu.dart';
import '../components/primary_button.dart';
import '../components/resource_chip.dart';
import '../components/secondary_text_button.dart';
import '../tokens.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final selectedMode = ref.watch(selectedModeProvider);
    final timerEnabled = ref.watch(timerEnabledForModeProvider(selectedMode));
    final modeNames = GameModeId.values;

    return Scaffold(
      appBar: AppTopBar(
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.menu),
        ),
        title: Text(l.homeTitle),
        actions: const [
          LocaleMenu(),
          ResourceChip(icon: Icons.favorite, label: '5'),
          ResourceChip(icon: Icons.flash_on, label: '120'),
          ResourceChip(icon: Icons.ac_unit, label: '42'),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CardTile(
              leading: const Icon(Icons.local_fire_department,
                  color: AppColors.accentSecondary, size: 32),
              title: Text(l.homeWeeklyChallengeTitle),
              subtitle: LinearProgressIndicator(
                value: 0.45,
                minHeight: AppComponentSpecs.progressBarHeight,
                backgroundColor: AppColors.borderMuted,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.accentSecondary,
                ),
              ),
              onTap: () => context.go(
                '/stub?title=${Uri.encodeComponent(l.homeStubEventTitle)}',
              ),
            ),
            const SizedBox(height: AppSpacing.grid),
            CardTile(
              leading: const Icon(Icons.group,
                  color: AppColors.accentSecondary, size: 32),
              title: Text(l.homePlayWithFriends),
              onTap: () => context.go(
                '/stub?title=${Uri.encodeComponent(l.homeStubFriendsTitle)}',
              ),
            ),
            const SizedBox(height: AppSpacing.grid * 1.5),
            Text(
              'Game mode',
              style: AppTypography.secondary,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: AppSpacing.grid,
              runSpacing: AppSpacing.grid,
              children: [
                for (final mode in modeNames)
                  ChoiceChip(
                    label: Text(mode.displayName),
                    selected: mode == selectedMode,
                    onSelected: (_) =>
                        ref.read(selectedModeProvider.notifier).state = mode,
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.grid),
            SwitchListTile.adaptive(
              value: timerEnabled,
              onChanged: (value) => ref
                  .read(modePreferencesProvider.notifier)
                  .setTimer(selectedMode, value),
              title: const Text('Per-question timer'),
              subtitle: const Text('Toggle 20-30 second countdown'),
            ),
            const SizedBox(height: AppSpacing.grid * 1.5),
            PrimaryButton(
              label: l.homePlayButton,
              onPressed: () =>
                  context.go('/round/history?mode=${selectedMode.key}'),
            ),
            const SizedBox(height: 8),
            SecondaryTextButton(
              label: l.homeChangeCategory,
              onPressed: () => context.go('/categories'),
            ),
          ],
        ),
      ),
    );
  }
}
