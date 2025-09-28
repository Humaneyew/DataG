import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../components/app_top_bar.dart';
import '../components/primary_button.dart';
import '../components/locale_menu.dart';
import '../components/secondary_text_button.dart';
import '../state/round_controller.dart';
import '../tokens.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key, this.summary});

  final RoundSummary? summary;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final data = summary;
    final totalScore = data?.score ?? 0;
    final locale = Localizations.localeOf(context);
    final averageDelta = data == null
        ? l.summaryNoValue
        : NumberFormat('0.0', locale.toLanguageTag()).format(data.averageDelta);
    final streak = data?.bestStreak ?? 0;
    final closeHits = data?.closeHits ?? 0;
    final totalQuestions = data?.totalQuestions ?? 0;
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
                ],
              ),
            ),
            const Spacer(),
            PrimaryButton(
              label: l.summaryPlayAgain,
              onPressed: () {
                final category = summary?.categoryId ?? 'history';
                context.go('/round/$category');
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
