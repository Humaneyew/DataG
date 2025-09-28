import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/question.dart';
import '../components/app_top_bar.dart';
import '../components/hint_button.dart';
import '../components/primary_button.dart';
import '../components/resource_chip.dart';
import '../components/result_sheet.dart';
import '../components/timeline_slider.dart';
import '../tokens.dart';
import '../state/round_controller.dart';

class RoundScreen extends ConsumerStatefulWidget {
  const RoundScreen({super.key, required this.categoryId});

  final String categoryId;

  @override
  ConsumerState<RoundScreen> createState() => _RoundScreenState();
}

class _RoundScreenState extends ConsumerState<RoundScreen> {
  int? _lastHapticValue;

  RoundController get _controller =>
      ref.read(roundControllerProvider(widget.categoryId).notifier);

  RoundState get _state => ref.read(roundControllerProvider(widget.categoryId));

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
      HapticFeedback.heavyImpact();
    } else if (value % 10 == 0) {
      HapticFeedback.mediumImpact();
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
        const SnackBar(
          content: Text('Экран с подробностями появится позже.'),
        ),
      );
    }

    final completed = controller.advance();
    if (completed) {
      final summary = controller.buildSummary();
      context.go('/summary', extra: summary);
    }
  }

  void _useHint(HintType type) {
    _controller.useHint(type);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(roundControllerProvider(widget.categoryId));

    if (state.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final question = state.currentQuestion;

    if (question == null) {
      return Scaffold(
        appBar: AppTopBar(
          title: const Text('Раунд'),
          leading: IconButton(
            onPressed: () => context.go('/home'),
            icon: const Icon(Icons.close),
          ),
        ),
        body: const Center(
          child: Text('Нет доступных вопросов для этой категории.'),
        ),
      );
    }

    final progress = (state.currentIndex + 1) / state.questionCount;
    final minYear = state.currentMinYear;
    final maxYear = state.currentMaxYear;
    final abOptions = state.abOptions;
    final lastDigitsHint = state.lastDigitsHint;
    final canSubmit = state.phase == RoundPhase.playing;

    return Scaffold(
      appBar: AppTopBar(
        title: Text('${state.currentIndex + 1}/${state.questionCount}'),
        actions: [
          ResourceChip(icon: Icons.star, label: state.score.toString()),
          ResourceChip(
            icon: Icons.local_fire_department,
            label: state.streak.toString(),
          ),
          ResourceChip(icon: Icons.favorite, label: state.lives.toString()),
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
                          question.prompt,
                          textAlign: TextAlign.center,
                          style: AppTypography.h2Fact,
                        ),
                        if (lastDigitsHint != null) ...[
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
                              lastDigitsHint,
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
                              icon: Icons.remove,
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
                              icon: Icons.add,
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
                          onChanged: canSubmit ? _onSliderChanged : (_) {},
                          onEraChanged:
                              canSubmit ? (era) => _controller.setEra(era) : null,
                        ),
                        if (abOptions != null) ...[
                          const SizedBox(height: AppSpacing.grid * 1.5),
                          Wrap(
                            spacing: AppSpacing.grid,
                            runSpacing: AppSpacing.grid,
                            alignment: WrapAlignment.center,
                            children: [
                              for (final option in abOptions)
                                ChoiceChip(
                                  label: Text('$option ${state.selectedEra.label}'),
                                  selected: state.selectedYear == option,
                                  onSelected: canSubmit
                                      ? (_) => _controller.setYear(option)
                                      : null,
                                ),
                            ],
                          ),
                        ],
                        const SizedBox(height: AppSpacing.grid * 1.5),
                        Wrap(
                          spacing: AppSpacing.grid,
                          runSpacing: AppSpacing.grid,
                          alignment: WrapAlignment.center,
                          children: [
                            HintButton(
                              label: 'Last (-50)',
                              onPressed: canSubmit &&
                                      !state.usedHints.contains(
                                        HintType.lastDigits,
                                      )
                                  ? () => _useHint(HintType.lastDigits)
                                  : null,
                            ),
                            HintButton(
                              label: 'A/B (-100)',
                              onPressed: canSubmit &&
                                      !state.usedHints.contains(
                                        HintType.abQuiz,
                                      )
                                  ? () => _useHint(HintType.abQuiz)
                                  : null,
                            ),
                            HintButton(
                              label: 'Narrow (-150)',
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
              label: 'Проверить дату',
              onPressed: canSubmit ? _showResult : null,
            ),
          ),
        ],
      ),
    );
  }
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
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          shape: const CircleBorder(),
          side: const BorderSide(color: AppColors.borderMuted),
          padding: EdgeInsets.zero,
          disabledForegroundColor: AppColors.textSecondary,
        ),
        child: Icon(icon, color: AppColors.textPrimary),
      ),
    );
  }
}
