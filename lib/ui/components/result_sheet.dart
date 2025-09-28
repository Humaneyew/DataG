import 'package:flutter/material.dart';

import '../../models/question.dart';
import '../state/round_controller.dart';
import '../tokens.dart';
import 'primary_button.dart';

class ResultSheet extends StatelessWidget {
  const ResultSheet({
    super.key,
    required this.result,
    required this.isLast,
    required this.onNext,
    required this.onDetails,
  });

  final QuestionResult result;
  final bool isLast;
  final VoidCallback onNext;
  final VoidCallback onDetails;

  String get _deltaText {
    if (result.delta == 0) {
      return 'Вы попали точно!';
    }
    return 'Вы промахнулись на ${result.delta} ${_pluralYears(result.delta)}';
  }

  String get _pointsText {
    final points = result.netPoints;
    final prefix = points >= 0 ? '+' : '';
    return '$prefix$points';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bonus = result.totalPoints - result.baseScore;
    final hints = result.usedHints.isEmpty
        ? 'Без подсказок'
        : 'Подсказки: ${result.usedHints.map(_hintLabel).join(', ')}';

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
                Text(
                  'Твой ответ: ${result.playerYear} ${result.playerEra.label}',
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Правильный ответ: ${result.question.correctYear} ${result.question.era.label}',
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  _deltaText,
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Базовые очки: ${result.baseScore}',
                  style: AppTypography.secondary,
                ),
                Text(
                  'Бонусы: ${bonus >= 0 ? '+$bonus' : bonus}',
                  style: AppTypography.secondary,
                ),
                if (result.hintPenalty > 0) ...[
                  Text(
                    'Штраф за подсказки: -${result.hintPenalty}',
                    style: AppTypography.secondary,
                  ),
                ],
                const SizedBox(height: 8),
                Text(
                  'Очки за вопрос: $_pointsText',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: result.netPoints >= 0
                        ? AppColors.success
                        : AppColors.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  hints,
                  style: AppTypography.secondary,
                ),
                if (result.streakBoostApplied)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'Серия ${result.streakAfterAnswer}: множитель 1.5×!',
                      style: AppTypography.secondary,
                    ),
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

  String _hintLabel(HintType type) {
    switch (type) {
      case HintType.lastDigits:
        return 'Last digits';
      case HintType.abQuiz:
        return 'A/B';
      case HintType.narrowTimeline:
        return 'Narrow';
    }
  }

  String _pluralYears(int value) {
    final mod10 = value % 10;
    final mod100 = value % 100;
    if (mod10 == 1 && mod100 != 11) return 'год';
    if (mod10 >= 2 && mod10 <= 4 && (mod100 < 10 || mod100 >= 20)) {
      return 'года';
    }
    return 'лет';
  }
}
