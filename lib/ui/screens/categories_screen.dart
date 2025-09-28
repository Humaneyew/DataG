import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../components/app_top_bar.dart';
import '../components/category_tile.dart';
import '../components/primary_button.dart';
import '../components/resource_chip.dart';
import '../tokens.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  static const _categories = [
    ('history', 'History', Icons.timeline),
    ('culture', 'Culture', Icons.palette_outlined),
    ('movies', 'Movies', Icons.movie_outlined),
    ('art', 'Art', Icons.brush_outlined),
    ('games', 'Games', Icons.sports_esports_outlined),
    ('music', 'Music', Icons.music_note_outlined),
    ('sport', 'Sport', Icons.sports_soccer),
    ('world', 'World', Icons.public),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Категории'),
        actions: const [
          ResourceChip(icon: Icons.favorite, label: '5'),
          ResourceChip(icon: Icons.flash_on, label: '120'),
          ResourceChip(icon: Icons.ac_unit, label: '42'),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              itemBuilder: (context, index) {
                final category = _categories[index];
                return CategoryTile(
                  icon: category.$3,
                  title: category.$2,
                  progress: 0.2 + index * 0.08,
                  onTap: () => context.go('/round/${category.$1}'),
                );
              },
              separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.grid),
              itemCount: _categories.length,
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
              label: 'Назад',
              onPressed: () => context.go('/home'),
            ),
          ),
        ],
      ),
    );
  }
}
