import 'package:flutter/material.dart';

import '../tokens.dart';
import 'primary_button.dart';

class ResultSheet extends StatelessWidget {
  const ResultSheet({
    super.key,
    required this.playerAnswer,
    required this.correctAnswer,
    required this.delta,
    required this.points,
    required this.onNext,
    required this.onDetails,
    this.isLast = false,
  });

  final int playerAnswer;
  final int correctAnswer;
  final int delta;
  final int points;
  final VoidCallback onNext;
  final VoidCallback onDetails;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
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
                Text('Твой ответ: $playerAnswer', style: theme.textTheme.bodyLarge),
                const SizedBox(height: 8),
                Text('Правильный ответ: $correctAnswer',
                    style: theme.textTheme.bodyLarge),
                const SizedBox(height: 8),
                Text('Δ $delta лет', style: theme.textTheme.bodyLarge),
                const SizedBox(height: 8),
                Text('Очки: +$points',
                    style: theme.textTheme.bodyLarge
                        ?.copyWith(color: AppColors.success)),
                const SizedBox(height: 12),
                Text(
                  'Факт: Краткое описание события.',
                  style: AppTypography.secondary,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.grid * 1.5),
          PrimaryButton(
            label: isLast ? 'Завершить' : 'Дальше',
            onPressed: onNext,
          ),
          const SizedBox(height: AppSpacing.grid),
          TextButton(
            onPressed: onDetails,
            child: const Text('Подробнее'),
          ),
        ],
      ),
    );
  }
}
