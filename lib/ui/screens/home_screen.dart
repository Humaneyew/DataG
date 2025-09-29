import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../components/app_badge.dart';
import '../components/app_button.dart';
import '../components/app_card.dart';
import '../components/app_scaffold.dart';
import '../components/app_top_bar.dart';
import '../state/category_selection.dart';
import '../state/strings.dart';
import '../theme/tokens.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late AnimationController _introController;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  bool _didAnimate = false;

  @override
  void initState() {
    super.initState();
    _introController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 620),
    );
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 720),
    );
    _pulseAnimation = TweenSequence<double>([
      TweenSequenceItem<double>(
        tween: Tween(begin: 1.0, end: 1.08)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem<double>(
        tween: Tween(begin: 1.08, end: 1.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 50,
      ),
    ]).animate(_pulseController);

    ref.listen<AsyncValue<List<CategoryDefinition>>>(
      categoryListProvider,
      (_, next) {
        next.whenData((_) {
          if (!_didAnimate && mounted) {
            _didAnimate = true;
            _introController.forward();
            _pulseController.forward();
          }
        });
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _introController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = ref.watch(stringsProvider);
    final categoriesAsync = ref.watch(categoryListProvider);
    final selectedCategoryId = ref.watch(selectedCategoryProvider);

    return AppScaffold(
      scrollController: _scrollController,
      topBar: AppTopBar(
        title: strings.appTitle,
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
                textAlign: TextAlign.center,
              ),
            );
          }

          final selected = categories.firstWhere(
            (category) => category.id == selectedCategoryId,
            orElse: () => categories.first,
          );
          final categoryTitle = selected.localizedTitle(strings);

          return SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _AnimatedFadeSlide(
                  controller: _introController,
                  interval: const Interval(0.0, 0.36, curve: Curves.easeOut),
                  child: ShaderMask(
                    shaderCallback: (bounds) {
                      return const LinearGradient(
                        colors: [AppColors.primary, Colors.white],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds);
                    },
                    blendMode: BlendMode.srcIn,
                    child: Text(
                      strings.appTitle,
                      style: AppTypography.display.copyWith(
                        fontSize: 36,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                _AnimatedFadeSlide(
                  controller: _introController,
                  interval: const Interval(0.12, 0.6, curve: Curves.easeOut),
                  child: AppCard(
                    variant: AppCardVariant.outlined,
                    onTap: () {
                      final uri = Uri(
                        path: '/stub',
                        queryParameters: {'title': strings.homeWeeklyTitle},
                      );
                      context.go(uri.toString());
                    },
                    child: Row(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.12),
                            borderRadius:
                                BorderRadius.circular(AppRadii.medium),
                            border: Border.all(
                              color: AppColors.primary.withOpacity(0.4),
                            ),
                          ),
                          child: const Icon(
                            Icons.calendar_today_rounded,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.lg),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                strings.homeWeeklyTitle,
                                style: AppTypography.h2,
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                'Elite timeline drops every Thursday.',
                                style: AppTypography.body,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        const AppBadge(
                          label: '22-28.09',
                          variant: AppBadgeVariant.outline,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                _AnimatedFadeSlide(
                  controller: _introController,
                  interval: const Interval(0.18, 0.66, curve: Curves.easeOut),
                  child: AppCard(
                    variant: AppCardVariant.outlined,
                    onTap: () {
                      final uri = Uri(
                        path: '/stub',
                        queryParameters: {'title': strings.homePlayWithFriends},
                      );
                      context.go(uri.toString());
                    },
                    child: Row(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.08),
                            borderRadius:
                                BorderRadius.circular(AppRadii.medium),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                            ),
                          ),
                          child: const Icon(
                            Icons.groups_rounded,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.lg),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                strings.homePlayWithFriends,
                                style: AppTypography.h2,
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                'Host a private lobby and share rewards.',
                                style: AppTypography.body,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        const Icon(Icons.chevron_right_rounded,
                            color: AppColors.textSecondary),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
                _AnimatedFadeSlide(
                  controller: _introController,
                  interval: const Interval(0.32, 0.9, curve: Curves.easeOut),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ScaleTransition(
                        scale: _pulseAnimation,
                        child: AppButton(
                          label: strings.homePlayButton,
                          icon: Icons.play_arrow_rounded,
                          onPressed: () {
                            context.go('/round');
                          },
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      AppBadge(
                        label: categoryTitle,
                        color: selected.accentColor,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                _AnimatedFadeSlide(
                  controller: _introController,
                  interval: const Interval(0.42, 1, curve: Curves.easeOut),
                  child: AppButton(
                    label: strings.homeChangeCategory,
                    icon: Icons.grid_view_rounded,
                    variant: AppButtonVariant.ghost,
                    onPressed: () {
                      context.go('/categories');
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _AnimatedFadeSlide extends StatelessWidget {
  const _AnimatedFadeSlide({
    required this.controller,
    required this.interval,
    required this.child,
    this.offset = const Offset(0, 0.06),
  });

  final AnimationController controller;
  final Interval interval;
  final Widget child;
  final Offset offset;

  @override
  Widget build(BuildContext context) {
    final animation = CurvedAnimation(parent: controller, curve: interval);
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(begin: offset, end: Offset.zero).animate(animation),
        child: child,
      ),
    );
  }
}
