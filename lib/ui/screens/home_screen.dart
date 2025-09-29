import 'package:datag/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../components/app_badge.dart';
import '../components/app_button.dart';
import '../components/app_card.dart';
import '../components/app_progress.dart';
import '../components/app_scaffold.dart';
import '../components/app_top_bar.dart';
import '../theme/tokens.dart';

final _featuredFacts = [
  'Unravel lost timelines with handcrafted trivia.',
  'Master categories ranging from history to futuristic tech.',
  'Climb the prestige ladder and unlock curator-only drops.',
];

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key, this.categoryId});

  final String? categoryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final selectedCategory = categoryId ?? 'history';
    final categoryColor = AppColors.categoryColors[selectedCategory];
    final featureColor = categoryColor ?? AppColors.primary;

    return AppScaffold(
      topBar: const AppTopBar(),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          Text(
            'Chronicle your mastery.',
            style: AppTypography.display.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Row(
            children: [
              const AppBadge.weekly(),
              const SizedBox(width: AppSpacing.lg),
              AppBadge.category(
                label: selectedCategory.toUpperCase(),
                color: featureColor,
                gradientBorder:
                    selectedCategory == 'mix' ? AppColors.mixBorder : null,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xxl),
          AppCard(
            title: Text(
              'Weekly resonance',
              style: AppTypography.h2,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Earn double prestige in curated timelines.',
                  style: AppTypography.secondary,
                ),
                const SizedBox(height: AppSpacing.md),
                AppProgressBar(value: 0.42, category: selectedCategory),
              ],
            ),
            trailing: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('42%', style: AppTypography.h3),
                Text(
                  'Track',
                  style: AppTypography.caption.copyWith(
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ],
            ),
            onTap: () {},
          ),
          const SizedBox(height: AppSpacing.xxl),
          AppCard(
            variant: AppCardVariant.gradient,
            title: Text(
              'Curator queue',
              style: AppTypography.h2,
            ),
            subtitle: Text(
              _featuredFacts.first,
              style: AppTypography.secondary,
            ),
            trailing: AppButton.secondary(
              label: 'View drops',
              onPressed: () => context.push('/categories'),
              icon: const Icon(Icons.auto_awesome, color: Colors.white, size: 18),
            ),
          ),
          const SizedBox(height: AppSpacing.xxxl),
          Text('Featured insights', style: AppTypography.h3),
          const SizedBox(height: AppSpacing.lg),
          ..._featuredFacts.skip(1).map(
            (fact) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.lg),
              child: AppCard(
                variant: AppCardVariant.outlined,
                title: Text(
                  fact,
                  style: AppTypography.body.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xxxl),
          AppButton.primary(
            label: 'Enter round',
            onPressed: () =>
                context.push('/round?category=$selectedCategory'),
            icon: const Icon(Icons.play_arrow, color: Colors.black),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppButton.ghost(
            label: l.categoriesTitle,
            onPressed: () => context.push('/categories'),
            icon: const Icon(Icons.grid_view, color: Colors.white70),
          ),
          const SizedBox(height: AppSpacing.xxxl),
        ],
      ),
    );
  }
}
