import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/modes/game_mode.dart';
import '../../features/modes/mode_controller.dart';
import '../../features/round/round_controller.dart';
import '../components/app_top_bar.dart';
import '../components/category_tile.dart';
import '../components/locale_menu.dart';
import '../components/primary_button.dart';
import '../components/resource_chip.dart';
import '../tokens.dart';

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  static const Map<String, IconData> _icons = {
    'history': Icons.timeline,
    'movies': Icons.movie_outlined,
    'world': Icons.public,
    'culture': Icons.palette_outlined,
    'art': Icons.brush_outlined,
    'games': Icons.sports_esports_outlined,
    'music': Icons.music_note_outlined,
    'sport': Icons.sports_soccer,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    final repository = ref.watch(questionRepositoryProvider);

    return Scaffold(
      appBar: AppTopBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(l.categoriesTitle),
        actions: const [
          LocaleMenu(),
          ResourceChip(icon: Icons.favorite, label: '5'),
          ResourceChip(icon: Icons.flash_on, label: '120'),
          ResourceChip(icon: Icons.ac_unit, label: '42'),
        ],
      ),
      body: FutureBuilder(
        future: repository.loadIndex(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text(l.categoriesEmpty));
          }
          final index = snapshot.data;
          final categories = index?.categories ?? const [];
          if (categories.isEmpty) {
            return Center(child: Text(l.categoriesEmpty));
          }
          final selectedMode = ref.watch(selectedModeProvider);
          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(AppSpacing.screenPadding),
                  itemBuilder: (context, idx) {
                    final category = categories[idx];
                    final icon = _icons[category.id] ?? Icons.help_outline;
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
