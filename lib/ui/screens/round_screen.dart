import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../components/app_button.dart';
import '../components/app_card.dart';
import '../components/app_scaffold.dart';
import '../components/app_top_bar.dart';
import '../components/app_badge.dart';
import '../state/category_selection.dart';
import '../state/player_resources.dart';
import '../state/strings.dart';
import '../theme/tokens.dart';

class RoundScreen extends ConsumerWidget {
  const RoundScreen({super.key, required this.categoryId});

  final String categoryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(stringsProvider);
    final categoriesAsync = ref.watch(categoryListProvider);

    return categoriesAsync.when(
      loading: () => AppScaffold(
        topBar: AppTopBar(
          title: strings.roundPlaceholderTitle,
          subtitle: strings.roundPlaceholderSubtitle,
          onMenuTap: () => context.pop(),
        ),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) => AppScaffold(
        topBar: AppTopBar(
          title: strings.roundPlaceholderTitle,
          subtitle: strings.roundPlaceholderSubtitle,
          onMenuTap: () => context.pop(),
        ),
        body: Center(
          child: Text(
            'Failed to load category',
            style: AppTypography.body,
            textAlign: TextAlign.center,
          ),
        ),
      ),
      data: (categories) {
        final category = categories.firstWhere(
          (definition) => definition.id == categoryId,
          orElse: () => categories.isEmpty
              ? CategoryDefinition(
                  id: 'unknown',
                  titleKey: 'cat_history',
                  colorKey: 'history',
                  iconKey: 'bank',
                  progress: 0,
                  locked: false,
                )
              : categories.first,
        );
        final title = category.localizedTitle(strings);

        return AppScaffold(
          topBar: AppTopBar(
            title: strings.roundPlaceholderTitle,
            subtitle: strings.roundPlaceholderSubtitle,
            onMenuTap: () => context.pop(),
          ),
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: AppCard(
                variant: AppCardVariant.elevated,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Category',
                        style: AppTypography.caption
                            .copyWith(color: AppColors.textMuted)),
                    const SizedBox(height: AppSpacing.xs),
                    Row(
                      children: [
                        AppBadge(
                          label: title,
                          color: category.accentColor,
                        ),
                        const Spacer(),
                        Icon(
                          category.iconData,
                          color: category.accentColor,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Text(
                      'This is a premium visual placeholder for the upcoming gameplay loop. '
                      'Use the buttons below to simulate resource flow.',
                      style: AppTypography.body,
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    AppButton(
                      label: 'Spend 1 life & 20 gems',
                      variant: AppButtonVariant.secondary,
                      onPressed: () {
                        ref
                            .read(playerResourcesProvider.notifier)
                            .spend(lives: 1, gems: 20);
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppButton(
                      label: 'Gain XP boost',
                      icon: Icons.trending_up,
                      onPressed: () {
                        ref
                            .read(playerResourcesProvider.notifier)
                            .gain(xp: 500, energy: 3);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class RoundEntryScreen extends ConsumerWidget {
  const RoundEntryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedCategoryProvider);
    return RoundScreen(categoryId: selected);
  }
}
