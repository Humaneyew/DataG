import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../features/modes/game_mode.dart';
import '../../features/modes/mode_controller.dart';
import '../../features/round/round_controller.dart';
import '../components/app_top_bar.dart';
import '../components/category_tile.dart';
import '../components/empty_error_state.dart';
import '../components/locale_menu.dart';
import '../components/primary_button.dart';
import '../components/resource_chip.dart';
import '../components/shimmer_placeholders.dart';
import '../tokens.dart';

class CategoriesScreen extends ConsumerStatefulWidget {
  const CategoriesScreen({super.key});

  @override
  ConsumerState<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends ConsumerState<CategoriesScreen> {
  int _reloadKey = 0;

  void _reload() {
    setState(() {
      _reloadKey++;
    });
  }

  static const Map<String, IconData> _icons = {
    'history': LucideIcons.library,
    'movies': LucideIcons.film,
    'world': LucideIcons.globe,
    'culture': LucideIcons.landmark,
    'art': LucideIcons.paintbrush,
    'games': LucideIcons.gamepad2,
    'music': LucideIcons.music,
    'sport': LucideIcons.dumbbell,
  };

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    final repository = ref.watch(questionRepositoryProvider);

    return Scaffold(
      appBar: AppTopBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(LucideIcons.arrowLeft, size: 20),
        ),
        title: Text(l.categoriesTitle),
        actions: [
          const LocaleMenu(),
          const ResourceChip(icon: LucideIcons.heart, label: '5'),
          const ResourceChip(icon: Icons.bolt, label: '120'),
          const ResourceChip(icon: LucideIcons.snowflake, label: '42'),
        ],
      ),
      body: FutureBuilder(
        key: ValueKey(_reloadKey),
        future: repository.loadIndex(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const CategoryListShimmer();
          }
          if (snapshot.hasError) {
            return Center(
              child: ErrorState(
                icon: LucideIcons.alertTriangle,
                title: l.categoriesTitle,
                message: l.categoriesEmpty,
                onRetry: _reload,
              ),
            );
          }
          final index = snapshot.data;
          final categories = index?.categories ?? const [];
          if (categories.isEmpty) {
            return Center(
              child: EmptyState(
                icon: LucideIcons.inbox,
                title: l.categoriesEmpty,
                message: l.roundDetailsComingSoon,
              ),
            );
          }
          final selectedMode = ref.watch(selectedModeProvider);
          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(AppSpacing.screenPadding),
                  itemBuilder: (context, idx) {
                    final category = categories[idx];
                    final icon = _icons[category.id] ?? LucideIcons.helpCircle;
                    final progress = (idx + 1) / (categories.length + 1);
                    return CategoryTile(
                      icon: icon,
                      title: category.nameFor(locale),
                      progress: progress.clamp(0.0, 1.0),
                      onTap: () => context
                          .go('/round/${category.id}?mode=${selectedMode.key}'),
                    );
                  },
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppSpacing.grid),
                  itemCount: categories.length,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenPadding,
                  0,
                  AppSpacing.screenPadding,
                  AppSpacing.screenPadding,
                ),
                child: PrimaryButton(
                  label: l.categoriesBack,
                  onPressed: () => context.go('/home'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
