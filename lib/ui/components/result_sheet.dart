import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../content/models.dart';
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    final eraPlayer = result.playerEra.labelForLocale(locale);
    final eraCorrect = result.question.era.labelForLocale(locale);
    final deltaText =
        result.isPerfect ? l.resultPerfect : l.resultMissedBy(result.delta);
    final bonus = result.totalPoints - result.baseScore;
    final hints = result.usedHints.isEmpty
        ? l.resultNoHints
        : l.resultHintsPrefix(
            result.usedHints.map((type) => _hintLabel(type, l)).join(', '),
          );
    final streakText = result.streakBoostApplied
        ? l.resultStreak(result.streakAfterAnswer)
        : null;
    final bonusText = l.resultBonus(_formatSigned(bonus));
    final questionPoints = _formatSigned(result.netPoints);

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
                  l.resultYourAnswer(result.playerYear, eraPlayer),
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  l.resultCorrectAnswer(
                    result.question.correctYear,
                    eraCorrect,
                  ),
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  deltaText,
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  l.resultBaseScore(result.baseScore),
                  style: AppTypography.secondary,
                ),
                Text(
                  bonusText,
                  style: AppTypography.secondary,
                ),
                if (result.hintPenalty > 0)
                  Text(
                    l.resultHintPenalty(result.hintPenalty),
                    style: AppTypography.secondary,
                  ),
                const SizedBox(height: 8),
                Text(
                  l.resultQuestionPoints(questionPoints),
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
                if (streakText != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      streakText,
                      style: AppTypography.secondary,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.grid * 1.5),
          PrimaryButton(
            label: isLast ? l.resultFinish : l.resultNext,
            onPressed: onNext,
          ),
          const SizedBox(height: AppSpacing.grid),
          TextButton(
            onPressed: onDetails,
            child: Text(l.resultDetails),
          ),
        ],
      ),
    );
  }

  String _hintLabel(HintType type, AppLocalizations l) {
    switch (type) {
      case HintType.lastDigits:
        return l.hintLabelLastDigits;
      case HintType.abQuiz:
        return l.hintLabelAB;
      case HintType.narrowTimeline:
        return l.hintLabelNarrow;
    }
  }

  String _formatSigned(int value) => value >= 0 ? '+$value' : value.toString();
}
