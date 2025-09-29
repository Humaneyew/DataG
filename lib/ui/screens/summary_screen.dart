import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../features/modes/duel_service.dart';
import '../../features/modes/game_mode.dart';
import '../../features/round/round_controller.dart';
import '../../features/round/round_models.dart';
import '../components/app_top_bar.dart';
import '../components/locale_menu.dart';
import '../components/primary_button.dart';
import '../components/secondary_text_button.dart';
import '../tokens.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key, this.completion});

  final RoundCompletion? completion;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final summary = completion?.summary;
    final dailyLeaderboard = completion?.dailyLeaderboard;
    final totalScore = summary?.score ?? 0;
    final locale = Localizations.localeOf(context);
    final averageDelta = summary == null
        ? l.summaryNoValue
        : NumberFormat('0.0', locale.toLanguageTag()).format(summary.averageDelta);
    final streak = summary?.bestStreak ?? 0;
    final closeHits = summary?.closeHits ?? 0;
    final totalQuestions = summary?.totalQuestions ?? 0;
    final accuracyText = totalQuestions == 0
        ? l.summaryNoValue
        : l.summaryAccuracyValue(closeHits, totalQuestions);

    return Scaffold(
      appBar: AppTopBar(
        leading: IconButton(
          onPressed: () => context.go('/home'),
          icon: const Icon(Icons.close),
        ),
        title: Text(l.summaryTitle),
        actions: const [LocaleMenu()],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppSpacing.grid * 2),
            Text(
              l.summaryHeader,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.grid * 2),
            Text(
              l.summaryPoints(totalScore),
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
                    l.summaryAccuracy(accuracyText),
                    style: AppTypography.secondary,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l.summaryAverageDelta(averageDelta),
                    style: AppTypography.secondary,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l.summaryBestStreak(streak),
                    style: AppTypography.secondary,
                  ),
                  if (summary != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Time bonus: ${summary.timeBonusTotal}',
                      style: AppTypography.secondary,
                    ),
                  ],
                ],
              ),
            ),
            const Spacer(),
            if (completion?.duelReport != null)
              _DuelResultCard(report: completion!.duelReport!),
            if (summary != null &&
                dailyLeaderboard != null &&
                dailyLeaderboard.isNotEmpty)
              _DailyLeaderboardCard(
                leaderboard: dailyLeaderboard,
                current: summary,
              ),
            const SizedBox(height: AppSpacing.grid * 2),
            PrimaryButton(
              label: l.summaryPlayAgain,
              onPressed: () {
                final categoryId = summary?.categoryId ?? 'history';
                final modeId = summary?.modeId ?? GameModeId.classic10;
                context.go('/round/$categoryId?mode=${modeId.key}');
              },
            ),
            const SizedBox(height: 8),
            SecondaryTextButton(
              label: l.summaryHome,
              onPressed: () => context.go('/home'),
            ),
            const SizedBox(height: AppSpacing.grid),
          ],
        ),
      ),
    );
  }
}

class _DuelResultCard extends StatelessWidget {
  const _DuelResultCard({required this.report});

  final DuelReport report;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final statusText = report.isPending
        ? 'Waiting for opponent to finish…'
        : report.isDraw
            ? 'Draw! Both scored ${report.playerSummary.score}.'
            : report.isPlayerWinner
                ? 'You won by ${report.scoreDelta} points!'
                : 'You lost by ${report.scoreDelta} points.';
    final opponentScore = report.opponentSummary?.score;

    return Container(
      margin: const EdgeInsets.only(top: AppSpacing.grid * 2),
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
            'Duel result',
            style: theme.titleMedium?.copyWith(color: AppColors.accentSecondary),
          ),
          const SizedBox(height: 8),
          Text(statusText, style: AppTypography.secondary),
          if (!report.isPending && opponentScore != null) ...[
            const SizedBox(height: 8),
            Text(
              'Opponent: $opponentScore',
              style: AppTypography.secondary,
            ),
          ],
        ],
      ),
    );
  }
}

class _DailyLeaderboardCard extends StatelessWidget {
  const _DailyLeaderboardCard({
    required this.leaderboard,
    required this.current,
  });

  final List<RoundSummary> leaderboard;
  final RoundSummary current;

  @override
  Widget build(BuildContext context) {
    final displayCount = math.min(leaderboard.length, 5);
    return Container(
      margin: const EdgeInsets.only(top: AppSpacing.grid * 2),
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
            'Daily leaderboard (${current.leaderboardKey ?? ''})',
            style: AppTypography.secondary,
          ),
          const SizedBox(height: 8),
          for (var i = 0; i < displayCount; i++)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${i + 1}. ${leaderboard[i].score}',
                      style: AppTypography.secondary),
                  Text(
                    leaderboard[i].modeId == current.modeId &&
                            leaderboard[i].completedAt == current.completedAt
                        ? 'You'
                        : '',
                    style: AppTypography.secondary,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
