import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../components/app_top_bar.dart';
import '../components/card_tile.dart';
import '../components/primary_button.dart';
import '../components/resource_chip.dart';
import '../components/secondary_text_button.dart';
import '../tokens.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBar(
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.menu),
        ),
        title: const Text('DataG Trivia'),
        actions: const [
          ResourceChip(icon: Icons.favorite, label: '5'),
          ResourceChip(icon: Icons.flash_on, label: '120'),
          ResourceChip(icon: Icons.ac_unit, label: '42'),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CardTile(
              leading: const Icon(Icons.local_fire_department,
                  color: AppColors.accentSecondary, size: 32),
              title: const Text('Неделя X'),
              subtitle: LinearProgressIndicator(
                value: 0.45,
                minHeight: AppComponentSpecs.progressBarHeight,
                backgroundColor: AppColors.borderMuted,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.accentSecondary,
                ),
              ),
              onTap: () => context.go('/stub?title=Событие'),
            ),
            const SizedBox(height: AppSpacing.grid),
            CardTile(
              leading: const Icon(Icons.group,
                  color: AppColors.accentSecondary, size: 32),
              title: const Text('Играй с друзьями'),
              onTap: () => context.go('/stub?title=Друзья'),
            ),
            const SizedBox(height: AppSpacing.grid * 1.5),
            PrimaryButton(
              label: 'Играть',
              onPressed: () => context.go('/round/history'),
            ),
            const SizedBox(height: 8),
            SecondaryTextButton(
              label: 'Сменить категорию',
              onPressed: () => context.go('/categories'),
            ),
          ],
        ),
      ),
    );
  }
}
