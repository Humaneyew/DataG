import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../content/models.dart';
import '../../features/modes/game_mode.dart';
import '../../features/round/round_controller.dart';
import '../../features/round/round_models.dart';
import '../components/app_top_bar.dart';
import '../components/empty_error_state.dart';
import '../components/hint_button.dart';
import '../components/locale_menu.dart';
import '../components/primary_button.dart';
import '../components/resource_chip.dart';
import '../components/result_sheet.dart';
import '../components/timeline_slider.dart';
import '../components/shimmer_placeholders.dart';
import '../state/feedback_settings.dart';
import '../tokens.dart';

class RoundScreen extends ConsumerStatefulWidget {
  const RoundScreen({
    super.key,
    required this.categoryId,
    required this.modeId,
  });

  final String categoryId;
  final GameModeId modeId;

  @override
  ConsumerState<RoundScreen> createState() => _RoundScreenState();
}

class _RoundScreenState extends ConsumerState<RoundScreen> {
  int? _lastHapticValue;
  late final RoundSessionRequest _request;
  Timer? _ticker;
  DateTime _now = DateTime.now();

  RoundController get _controller =>
      ref.read(roundControllerProvider(_request).notifier);

  RoundState get _state => ref.read(roundControllerProvider(_request));

  @override
  void initState() {
    super.initState();
    _request = RoundSessionRequest(
      categoryId: widget.categoryId,
      modeId: widget.modeId,
    );
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        _now = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  void _adjustYear(int delta) {
    _controller.adjustYear(delta);
    _emitHaptics(_state.selectedYear);
  }

  void _onSliderChanged(int year) {
    _controller.setYear(year);
    _emitHaptics(year);
  }

  void _emitHaptics(int value) {
    if (_lastHapticValue == value) return;
    if (value % 100 == 0) {
      Haptics.play(HapticType.heavy);
      Sfx.play(SfxName.pop);
    } else if (value % 10 == 0) {
      Haptics.play(HapticType.medium);
      Sfx.play(SfxName.tick);
    } else {
      Haptics.play(HapticType.selection);
    }
    _lastHapticValue = value;
  }

  Future<void> _showResult() async {
    final controller = _controller;
    final stateBefore = _state;
    final isLastQuestion =
        stateBefore.currentIndex == stateBefore.questionCount - 1;
    final result = controller.evaluate();
    if (result == null) return;
    final l = AppLocalizations.of(context)!;

    final proceed = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: AppColors.bgBase,
      isScrollControlled: true,
      builder: (context) => ResultSheet(
        result: result,
        isLast: isLastQuestion,
        onNext: () => Navigator.of(context).pop(true),
        onDetails: () => Navigator.of(context).pop(false),
      ),
    );

    if (!mounted) return;
    if (proceed == false) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l.roundDetailsComingSoon),
        ),
      );
    }

    final completed = controller.advance();
    if (completed) {
      final completion = controller.buildSummary();
      context.go('/summary', extra: completion);
    }
  }

  void _useHint(HintType type) {
    _controller.useHint(type);
    Sfx.play(SfxName.tick);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(roundControllerProvider(_request));
    final l = AppLocalizations.of(context)!;

    if (state.isLoading) {
      return Scaffold(
        appBar: AppTopBar(
          leading: IconButton(
            onPressed: () => context.go('/home'),
            icon: const Icon(LucideIcons.arrowLeft, size: 20),
          ),
          title: Text(l.roundTitleFallback),
          actions: const [LocaleMenu()],
        ),
        body: const RoundQuestionShimmer(),
      );
    }

    final question = state.currentQuestion;

    if (question == null) {
      return Scaffold(
        appBar: AppTopBar(
          leading: IconButton(
            onPressed: () => context.go('/home'),
            icon: const Icon(LucideIcons.x, size: 20),
          ),
          title: Text(l.roundTitleFallback),
          actions: const [LocaleMenu()],
        ),
        body: Center(
          child: EmptyState(
            icon: LucideIcons.calendarClock,
            title: l.roundNoQuestions,
            message: l.roundDetailsComingSoon,
          ),
        ),
      );
    }

    final progress = (state.currentIndex + 1) / state.questionCount;
    final minYear = state.currentMinYear;
    final maxYear = state.currentMaxYear;
    final abOptions = state.abOptions;
    final lastDigitsHint = state.lastDigitsHint;
    final canSubmit = state.phase == RoundPhase.playing;
    final locale = Localizations.localeOf(context);
    final lastDigitsText =
        lastDigitsHint == null ? null : l.roundLastDigitsHint(lastDigitsHint);
    final promptText = question.promptForLocale(locale);
    final timeLimit = state.timerEnabled ? state.timeLimit : null;
    Duration? timeRemaining;
    double? timeProgress;
    if (timeLimit != null && state.questionStartTime != null) {
      final elapsed = _now.difference(state.questionStartTime!);
      final remaining = timeLimit - elapsed;
      timeRemaining = remaining.isNegative ? Duration.zero : remaining;
      final ratio = remaining.isNegative
          ? 1.0
          : (elapsed.inMilliseconds / timeLimit.inMilliseconds)
              .clamp(0.0, 1.0);
      timeProgress = ratio;
    }
    final timerText = timeRemaining == null
        ? null
        : _formatDuration(timeRemaining);

    final hintMultiplier = state.hintCostMultiplier;
    final lastCost = (50 * hintMultiplier).round();
    final abCost = (100 * hintMultiplier).round();
    final narrowCost = (150 * hintMultiplier).round();

    return Scaffold(
      appBar: AppTopBar(
        leading: IconButton(
          onPressed: () => context.go('/home'),
          icon: const Icon(LucideIcons.arrowLeft, size: 20),
        ),
        title: Text('${state.currentIndex + 1}/${state.questionCount}'),
        actions: [
          const LocaleMenu(),
          ResourceChip(
            icon: LucideIcons.star,
            label: state.score.toString(),
          ),
          ResourceChip(
            icon: LucideIcons.flame,
            label: state.streak.toString(),
          ),
          if (state.lives > 0)
            ResourceChip(
              icon: LucideIcons.heart,
              label: state.lives.toString(),
            ),
        ],
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: progress,
            minHeight: AppComponentSpecs.progressBarHeight,
            backgroundColor: AppColors.borderMuted,
            valueColor: const AlwaysStoppedAnimation<Color>(
              AppColors.accentSecondary,
            ),
          ),
          if (timeProgress != null) ...[
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.l,
              ),
              child: LinearProgressIndicator(
                value: timeProgress,
                minHeight: 6,
                backgroundColor: AppColors.borderMuted,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.accentPrimary,
                ),
              ),
            ),
                        if (timerText != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  LucideIcons.timer,
                                  size: 18,
                                  color: AppColors.textSecondary,
                                ),
                                const SizedBox(width: AppSpacing.s),
                                Text(
                                  timerText,
                                  style: AppTypography.secondary,
                                ),
                              ],
                            ),
                          ),
          ],
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: AppSpacing.grid),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          promptText,
                          textAlign: TextAlign.center,
                          style: AppTypography.h2Fact,
                        ),
                        if (lastDigitsText != null) ...[
                          const SizedBox(height: AppSpacing.grid),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.bgElevated,
                              borderRadius: AppRadius.medium,
                              border: Border.all(color: AppColors.accentSecondary),
                            ),
                            child: Text(
                              lastDigitsText,
                              style: AppTypography.secondary,
                            ),
                          ),
                        ],
                        const SizedBox(height: AppSpacing.grid * 2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _YearControlButton(
                              icon: LucideIcons.minus,
                              onPressed: canSubmit
                                  ? () => _adjustYear(-1)
                                  : null,
                            ),
                            const SizedBox(width: AppSpacing.grid * 1.5),
                            Text(
                              state.selectedYear.toString(),
                              style: AppTypography.h1Year,
                            ),
                            const SizedBox(width: AppSpacing.grid * 1.5),
                            _YearControlButton(
                              icon: LucideIcons.plus,
                              onPressed:
                                  canSubmit ? () => _adjustYear(1) : null,
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.grid * 1.5),
                        TimelineSlider(
                          minYear: minYear,
                          maxYear: maxYear,
                          value: state.selectedYear,
                          era: state.selectedEra,
                          correctYear: question.correctYear,
                          correctEra: question.era,
                          locale: locale,
                          onChanged: canSubmit ? _onSliderChanged : (_) {},
                          onEraChanged:
                              canSubmit ? (era) => _controller.setEra(era) : null,
                        ),
                        if (abOptions != null) ...[
                          const SizedBox(height: AppSpacing.xl),
                          Wrap(
                            spacing: AppSpacing.m,
                            runSpacing: AppSpacing.m,
                            alignment: WrapAlignment.center,
                            children: [
                              for (final option in abOptions)
                                ChoiceChip(
                                  label: Text(
                                      '$option ${state.selectedEra.labelForLocale(locale)}'),
                                  labelStyle: AppTypography.chip,
                                  selected: state.selectedYear == option,
                                  onSelected: canSubmit
                                      ? (_) => _controller.setYear(option)
                                      : null,
                                ),
                            ],
                          ),
                        ],
                        const SizedBox(height: AppSpacing.xl),
                        Wrap(
                          spacing: AppSpacing.m,
                          runSpacing: AppSpacing.m,
                          alignment: WrapAlignment.center,
                          children: [
                            HintButton(
                              label: l.roundHintLast(lastCost),
                              onPressed: canSubmit &&
                                      state.isHintAvailable(
                                        HintType.lastDigits,
                                      ) &&
                                      !state.usedHints.contains(
                                        HintType.lastDigits,
                                      )
                                  ? () => _useHint(HintType.lastDigits)
                                  : null,
                            ),
                            HintButton(
                              label: l.roundHintAB(abCost),
                              onPressed: canSubmit &&
                                      !state.usedHints.contains(
                                        HintType.abQuiz,
                                      )
                                  ? () => _useHint(HintType.abQuiz)
                                  : null,
                            ),
                            HintButton(
                              label: l.roundHintNarrow(narrowCost),
                              onPressed: canSubmit &&
                                      !state.usedHints.contains(
                                        HintType.narrowTimeline,
                                      )
                                  ? () => _useHint(HintType.narrowTimeline)
                                  : null,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            minimum: const EdgeInsets.all(AppSpacing.screenPadding),
            child: PrimaryButton(
              label: l.roundSubmit,
              onPressed: canSubmit ? _showResult : null,
            ),
          ),
        ],
      ),
    );
  }
}

String _formatDuration(Duration duration) {
  final seconds = duration.inSeconds;
  final minutes = seconds ~/ 60;
  final remaining = seconds % 60;
  final minPart = minutes.toString().padLeft(2, '0');
  final secPart = remaining.toString().padLeft(2, '0');
  return '$minPart:$secPart';
}

class _YearControlButton extends StatelessWidget {
  const _YearControlButton({required this.icon, this.onPressed});

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppComponentSpecs.minTouchTarget,
      height: AppComponentSpecs.minTouchTarget,
      child: IconButton(
        onPressed: onPressed,
        style: AppButtonStyles.icon,
        icon: Icon(icon, color: AppColors.textPrimary, size: 20),
      ),
    );
  }
}
