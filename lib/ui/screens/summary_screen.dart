import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../components/app_top_bar.dart';
import '../components/primary_button.dart';
import '../components/secondary_text_button.dart';
import '../state/round_controller.dart';
import '../tokens.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key, this.summary});

  final RoundSummary? summary;

  @override
  Widget build(BuildContext context) {
    final data = summary;
    final totalScore = data?.score ?? 0;
    final averageDelta = data == null
        ? '—'
        : data.averageDelta.toStringAsFixed(1).replaceAll('.', ',');
    final streak = data?.bestStreak ?? 0;
    final closeHits = data?.closeHits ?? 0;
    final totalQuestions = data?.totalQuestions ?? 0;
    final accuracyText = totalQuestions == 0
        ? '—'
        : '$closeHits из $totalQuestions';

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
            Text(
              '$totalScore очков',
              textAlign: TextAlign.center,
              style: const TextStyle(
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
                children: [
                  Text(
                    'Попадания ≤5 лет: $accuracyText',
                    style: AppTypography.secondary,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Средняя дельта: $averageDelta',
                    style: AppTypography.secondary,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Лучшая серия: $streak',
                    style: AppTypography.secondary,
                  ),
                ],
              ),
            ),
            const Spacer(),
            PrimaryButton(
              label: 'Играть снова',
              onPressed: () {
                final category = summary?.categoryId ?? 'history';
                context.go('/round/$category');
              },
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
