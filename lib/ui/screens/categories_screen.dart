import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../components/app_badge.dart';
import '../components/app_card.dart';
import '../components/app_scaffold.dart';
import '../components/app_top_bar.dart';
import '../theme/tokens.dart';

const _categories = <String, String>{
  'history': 'History',
  'sport': 'Sport',
  'movies': 'Movies',
  'art': 'Art',
  'games': 'Games',
  'books': 'Books',
  'vehicles': 'Vehicles',
  'world': 'World',
  'tech': 'Tech',
  'food': 'Food',
  'culture': 'Culture',
  'fashion': 'Fashion',
  'mix': 'Mix',
};

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppScaffold(
      topBar: const AppTopBar(),
      body: GridView.count(
        physics: const BouncingScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: AppSpacing.xxl,
        crossAxisSpacing: AppSpacing.xxl,
        children: _categories.entries.map((entry) {
          final color = AppColors.categoryColors[entry.key] ?? AppColors.primary;
          return AppCard(
            title: Text(
              entry.value,
              style: AppTypography.h3,
            ),
            subtitle: Text(
              'Curated ${entry.value.toLowerCase()} dossiers',
              style: AppTypography.secondary,
            ),
            variant: AppCardVariant.elevated,
            onTap: () {
              HapticFeedback.selectionClick();
              context.go('/home?category=${entry.key}');
            },
            trailing: AppBadge.category(
              label: entry.key.toUpperCase(),
              color: color,
              gradientBorder:
                  entry.key == 'mix' ? AppColors.mixBorder : null,
            ),
          );
        }).toList(),
      ),
    );
  }
}
