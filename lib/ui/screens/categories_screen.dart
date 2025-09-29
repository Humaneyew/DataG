import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../components/app_badge.dart';
import '../components/app_card.dart';
import '../components/app_progress.dart';
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

class _CategoriesScreenState extends ConsumerState<CategoriesScreen>
    with TickerProviderStateMixin {
  final ScrollController _controller = ScrollController();
  late AnimationController _introController;
  bool _didAnimate = false;

  @override
  void initState() {
    super.initState();
    _introController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 560),
    );
    ref.listen<AsyncValue<List<CategoryDefinition>>>(
      categoryListProvider,
      (_, next) {
        next.whenData((_) {
          if (!_didAnimate && mounted) {
            _didAnimate = true;
            _introController.forward();
          }
        });
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _introController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = ref.watch(stringsProvider);
    final selected = ref.watch(selectedCategoryProvider);
    final categoriesAsync = ref.watch(categoryListProvider);

    return AppScaffold(
      scrollController: _controller,
      topBar: AppTopBar(
        title: strings.categoriesTitle,
        subtitle: strings.categoriesSubtitle,
        onMenuTap: () => context.go('/home'),
      ),
      body: categoriesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text(
            strings.categoriesEmpty,
            style: AppTypography.body,
            textAlign: TextAlign.center,
          ),
        ),
        data: (categories) {
          if (categories.isEmpty) {
            return Center(
              child: Text(
                strings.categoriesEmpty,
                style: AppTypography.body,
              ),
            );
          }

          return ListView.separated(
            controller: _controller,
            padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
            itemBuilder: (context, index) {
              final category = categories[index];
              final animation = CurvedAnimation(
                parent: _introController,
                curve: Interval(
                  (0.12 + index * 0.08).clamp(0.0, 1.0),
                  1,
                  curve: Curves.easeOut,
                ),
              );
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.08),
                    end: Offset.zero,
                  ).animate(animation),
                  child: _CategoryCard(
                    definition: category,
                    selected: category.id == selected,
                    onTap: () async {
                      await ref
                          .read(selectedCategoryProvider.notifier)
                          .select(category.id);
                      if (context.mounted) {
                        context.go('/home');
                      }
                    },
                    strings: strings,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.definition,
    required this.selected,
    required this.onTap,
    required this.strings,
  });

  final CategoryDefinition definition;
  final bool selected;
  final VoidCallback onTap;
  final AppStrings strings;

  @override
  Widget build(BuildContext context) {
    final accent = definition.accentColor;
    final title = definition.localizedTitle(strings);

    return AppCard(
      variant: AppCardVariant.gradient,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadii.medium),
                  border: Border.all(color: accent.withOpacity(0.5)),
                  color: accent.withOpacity(0.15),
                ),
                child: Icon(
                  definition.iconData,
                  color: accent,
                  size: 28,
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTypography.h2),
                    if (selected) ...[
                      const SizedBox(height: AppSpacing.xs),
                      AppBadge(
                        label: strings.categorySelectedLabel,
                        variant: AppBadgeVariant.outline,
                        color: accent,
                      ),
                    ],
                  ],
                ),
              ),
              AppBadge(
                label: '0',
                icon: Icons.emoji_events_rounded,
                variant: AppBadgeVariant.outline,
                color: accent,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          AppProgress(
            value: definition.progress.clamp(0, 1),
            color: accent,
            height: 4,
          ),
        ],
      ),
    );
  }
}
