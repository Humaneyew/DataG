import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../components/app_card.dart';
import '../components/app_scaffold.dart';
import '../components/app_top_bar.dart';
import '../state/category_selection.dart';
import '../state/strings.dart';
import '../theme/tokens.dart';

class CategoriesScreen extends ConsumerStatefulWidget {
  const CategoriesScreen({super.key});

  @override
  ConsumerState<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends ConsumerState<CategoriesScreen> {
  final ScrollController _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = ref.watch(stringsProvider);
    final selected = ref.watch(selectedCategoryProvider);

    return AppScaffold(
      scrollController: _controller,
      topBar: AppTopBar(
        title: strings.categoriesTitle,
        subtitle: 'Tap a capsule to focus your next round.',
        onMenuTap: () => context.pop(),
      ),
      body: GridView.builder(
        controller: _controller,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: AppSpacing.md,
          mainAxisSpacing: AppSpacing.md,
          childAspectRatio: 1.1,
        ),
        itemCount: AppCategories.values.length,
        padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
        itemBuilder: (context, index) {
          final token = AppCategories.values[index];
          final isSelected = token.id == selected;
          return _CategoryCard(
            token: token,
            selected: isSelected,
            onTap: () {
              ref.read(selectedCategoryProvider.notifier).state = token.id;
              context.go('/home');
            },
          );
        },
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.token,
    required this.selected,
    required this.onTap,
  });

  final CategoryToken token;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final decoration = token.gradient != null
        ? BoxDecoration(
            gradient: token.gradient,
            borderRadius: BorderRadius.circular(AppRadii.large),
            border: Border.all(color: Colors.white.withOpacity(selected ? 0.6 : 0.2), width: 1.8),
          )
        : BoxDecoration(
            color: token.color.withOpacity(0.22),
            borderRadius: BorderRadius.circular(AppRadii.large),
            border: Border.all(color: token.color.withOpacity(selected ? 0.7 : 0.24), width: 1.6),
          );

    return AppCard(
      variant: AppCardVariant.elevated,
      onTap: onTap,
      padding: EdgeInsets.zero,
      child: Container(
        decoration: decoration,
        child: Stack(
          children: [
            Positioned(
              right: -24,
              bottom: -24,
              child: Icon(
                Icons.bubble_chart,
                size: 120,
                color: Colors.white.withOpacity(0.08),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    token.label,
                    style: AppTypography.h2,
                  ),
                  const Spacer(),
                  AnimatedOpacity(
                    opacity: selected ? 1 : 0.0,
                    duration: AppDurations.medium,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.check_circle, color: AppColors.success, size: 20),
                        const SizedBox(width: AppSpacing.xs),
                        Text('Selected', style: AppTypography.body),
                      ],
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
}
