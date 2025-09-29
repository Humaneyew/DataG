import 'package:datag/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../components/app_button.dart';
import '../components/app_card.dart';
import '../components/app_scaffold.dart';
import '../components/app_top_bar.dart';
import '../theme/tokens.dart';

class RoundStubScreen extends ConsumerWidget {
  const RoundStubScreen({super.key, this.categoryId});

  final String? categoryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final category = categoryId ?? 'history';
    final color = AppColors.categoryColors[category] ?? AppColors.primary;

    return AppScaffold(
      topBar: const AppTopBar(),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          Text(
            'Round prototype',
            style: AppTypography.h1,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Gameplay surfaces arrive in the next milestone. For now, bask in the premium shell.',
            style: AppTypography.secondary,
          ),
          const SizedBox(height: AppSpacing.xxl),
          AppCard(
            title: Text(
              'Selected category',
              style: AppTypography.h3,
            ),
            subtitle: Text(
              category.toUpperCase(),
              style: AppTypography.bodyStrong.copyWith(color: color),
            ),
            variant: AppCardVariant.outlined,
          ),
          const SizedBox(height: AppSpacing.xxxl),
          AppButton.primary(
            label: l.categoriesBack,
            onPressed: () => context.go('/home?category=$category'),
            icon: const Icon(Icons.arrow_back, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
