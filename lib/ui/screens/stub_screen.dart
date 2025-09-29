import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../components/app_button.dart';
import '../components/app_card.dart';
import '../components/app_scaffold.dart';
import '../components/app_top_bar.dart';
import '../state/strings.dart';
import '../theme/tokens.dart';

class StubScreen extends ConsumerWidget {
  const StubScreen({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(stringsProvider);

    return AppScaffold(
      topBar: AppTopBar(
        title: title,
        subtitle: strings.roundPlaceholderSubtitle,
        onMenuTap: () => context.go('/home'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: AppCard(
            variant: AppCardVariant.outlined,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  strings.roundPlaceholderTitle,
                  style: AppTypography.h2,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Premium mode preview. Gameplay modules will arrive shortly.',
                  style: AppTypography.body,
                ),
                const SizedBox(height: AppSpacing.xxl),
                AppButton(
                  label: strings.homeChangeCategory,
                  icon: Icons.grid_view_rounded,
                  variant: AppButtonVariant.ghost,
                  onPressed: () => context.go('/categories'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
