import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../components/app_badge.dart';
import '../components/app_button.dart';
import '../components/app_card.dart';
import '../components/app_progress.dart';
import '../components/app_scaffold.dart';
import '../components/app_top_bar.dart';
import '../state/category_selection.dart';
import '../state/player_resources.dart';
import '../state/strings.dart';
import '../theme/tokens.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = ref.watch(stringsProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final categoryToken = AppCategories.byId(selectedCategory);
    final resources = ref.watch(playerResourcesProvider);

    return AppScaffold(
      scrollController: _scrollController,
      topBar: AppTopBar(
        title: strings.homeHeadline,
        subtitle: strings.homeSubheading,
        onMenuTap: () => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${strings.appTitle} UI shell')), // placeholder
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppCard(
              variant: AppCardVariant.gradient,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      AppBadge(
                        label: strings.weeklyBadge.toUpperCase(),
                        variant: AppBadgeVariant.neon,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      AppBadge(
                        label: '${categoryToken.label} League',
                        variant: AppBadgeVariant.outline,
                        color: categoryToken.gradient == null
                            ? categoryToken.color
                            : AppColors.primary,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text('${categoryToken.label} Mastery', style: AppTypography.h2),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Climb to level ${resources.level + 1} and unlock elite cosmetics.',
                    style: AppTypography.body,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppProgress(
                    value: (resources.xp % 1000) / 1000,
                    color: categoryToken.gradient == null
                        ? categoryToken.color
                        : AppColors.primary,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            Text(strings.modesBadge, style: AppTypography.h3),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.md,
              children: [
                _ModePill(label: 'Classic 10', accent: categoryToken.color),
                _ModePill(label: 'Marathon 30', accent: AppColors.primary),
                _ModePill(label: 'Blitz 5', accent: AppColors.warning),
              ],
            ),
            const SizedBox(height: AppSpacing.xxl),
            AppCard(
              variant: AppCardVariant.outlined,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Chosen category', style: AppTypography.caption.copyWith(color: AppColors.textMuted)),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      _CategoryBadge(token: categoryToken),
                      const Spacer(),
                      AppButton(
                        label: strings.homeSecondaryAction,
                        variant: AppButtonVariant.ghost,
                        icon: Icons.grid_view_rounded,
                        expand: false,
                        onPressed: () {
                          context.go('/categories');
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            AppButton(
              label: strings.homePrimaryAction,
              icon: Icons.play_arrow_rounded,
              onPressed: () {
                context.go('/round/${categoryToken.id}');
              },
            ),
            const SizedBox(height: AppSpacing.md),
            AppButton(
              label: 'Boost resources',
              variant: AppButtonVariant.secondary,
              icon: Icons.auto_awesome,
              onPressed: () {
                ref.read(playerResourcesProvider.notifier).gain(gems: 120, xp: 230);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ModePill extends StatelessWidget {
  const _ModePill({required this.label, required this.accent});

  final String label;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: accent.withOpacity(0.32)),
        color: accent.withOpacity(0.12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        child: Text(
          label,
          style: AppTypography.body.copyWith(
            color: accent,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _CategoryBadge extends StatelessWidget {
  const _CategoryBadge({required this.token});

  final CategoryToken token;

  @override
  Widget build(BuildContext context) {
    final decoration = token.gradient != null
        ? BoxDecoration(
            gradient: token.gradient,
            borderRadius: BorderRadius.circular(AppRadii.large),
            border: Border.all(color: Colors.white.withOpacity(0.24)),
          )
        : BoxDecoration(
            color: token.color.withOpacity(0.18),
            borderRadius: BorderRadius.circular(AppRadii.large),
            border: Border.all(color: token.color.withOpacity(0.32)),
          );

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      decoration: decoration,
      child: Text(
        token.label,
        style: AppTypography.h3.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
