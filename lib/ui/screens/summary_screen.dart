import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../components/app_top_bar.dart';
import '../components/primary_button.dart';
import '../components/secondary_text_button.dart';
import '../tokens.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBar(
        leading: IconButton(
          onPressed: () => context.go('/home'),
          icon: const Icon(Icons.close),
        ),
        title: const Text('Итоги'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppSpacing.grid * 2),
            const Text(
              'Раунд завершён!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.grid * 2),
            const Text(
              '1 250 очков',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: AppColors.accentPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.grid * 2),
            Container(
              padding: const EdgeInsets.all(AppSpacing.grid),
              decoration: BoxDecoration(
                color: AppColors.bgElevated,
                borderRadius: AppRadius.medium,
                border: Border.all(color: AppColors.borderMuted),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Правильно: 7/10', style: AppTypography.secondary),
                  SizedBox(height: 8),
                  Text('Средняя дельта: 12 лет', style: AppTypography.secondary),
                ],
              ),
            ),
            const Spacer(),
            PrimaryButton(
              label: 'Играть снова',
              onPressed: () => context.go('/round/history'),
            ),
            const SizedBox(height: 8),
            SecondaryTextButton(
              label: 'Домой',
              onPressed: () => context.go('/home'),
            ),
            const SizedBox(height: AppSpacing.grid),
          ],
        ),
      ),
    );
  }
}
