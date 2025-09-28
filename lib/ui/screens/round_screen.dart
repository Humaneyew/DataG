import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../components/app_top_bar.dart';
import '../components/hint_button.dart';
import '../components/primary_button.dart';
import '../components/resource_chip.dart';
import '../components/result_sheet.dart';
import '../components/timeline_slider.dart';
import '../tokens.dart';

class RoundQuestion {
  const RoundQuestion({
    required this.fact,
    required this.answerYear,
    required this.highlight,
  });

  final String fact;
  final String highlight;
  final int answerYear;
}

class RoundScreen extends StatefulWidget {
  const RoundScreen({super.key, required this.categoryId});

  final String categoryId;

  @override
  State<RoundScreen> createState() => _RoundScreenState();
}

class _RoundScreenState extends State<RoundScreen> {
  static const _questions = [
    RoundQuestion(
      fact: 'Когда произошла битва при',
      highlight: 'Гастингсе?',
      answerYear: 1066,
    ),
    RoundQuestion(
      fact: 'В каком году была создана',
      highlight: 'первaя телеграмма?',
      answerYear: 1844,
    ),
    RoundQuestion(
      fact: 'Когда состоялась премьера',
      highlight: 'первого фильма Lumière?',
      answerYear: 1895,
    ),
  ];

  int _currentQuestion = 0;
  double _selectedYear = 1500;

  @override
  void initState() {
    super.initState();
    _selectedYear = _questions.first.answerYear.toDouble();
  }

  void _adjustYear(int delta) {
    setState(() {
      _selectedYear = (_selectedYear + delta).clamp(0, 2024);
    });
  }

  Future<void> _showResult() async {
    final question = _questions[_currentQuestion];
    final answer = _selectedYear.round();
    final delta = (answer - question.answerYear).abs();
    final isLast = _currentQuestion == _questions.length - 1;

    final result = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: AppColors.bgBase,
      isScrollControlled: true,
      builder: (context) => ResultSheet(
        playerAnswer: answer,
        correctAnswer: question.answerYear,
        delta: delta,
        points: (100 - delta).clamp(10, 100).toInt(),
        isLast: isLast,
        onNext: () => Navigator.of(context).pop(true),
        onDetails: () => Navigator.of(context).pop(false),
      ),
    );

    if (!mounted || result == null) return;

    if (!result) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Экран с подробностями появится позже.')),
      );
      return;
    }

    if (isLast) {
      context.go('/summary');
      return;
    }

    setState(() {
      _currentQuestion = (_currentQuestion + 1) % _questions.length;
      _selectedYear = _questions[_currentQuestion].answerYear.toDouble();
    });
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentQuestion];
    final progress = (_currentQuestion + 1) / _questions.length;

    return Scaffold(
      appBar: AppTopBar(
        title: Text('${_currentQuestion + 1}/${_questions.length}'),
        actions: const [
          ResourceChip(icon: Icons.favorite, label: '5'),
          ResourceChip(icon: Icons.flash_on, label: '120'),
          ResourceChip(icon: Icons.ac_unit, label: '42'),
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
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: AppTypography.h2Fact,
                            children: [
                              TextSpan(text: '${question.fact} '),
                              TextSpan(
                                text: question.highlight,
                                style: AppTypography.h2FactEmphasis(context),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.grid * 2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _YearControlButton(
                              icon: Icons.remove,
                              onPressed: () => _adjustYear(-1),
                            ),
                            const SizedBox(width: AppSpacing.grid * 1.5),
                            Text(
                              _selectedYear.round().toString(),
                              style: AppTypography.h1Year,
                            ),
                            const SizedBox(width: AppSpacing.grid * 1.5),
                            _YearControlButton(
                              icon: Icons.add,
                              onPressed: () => _adjustYear(1),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.grid * 1.5),
                        TimelineSlider(
                          value: _selectedYear,
                          onChanged: (value) => setState(() {
                            _selectedYear = value;
                          }),
                        ),
                        const SizedBox(height: AppSpacing.grid * 1.5),
                        Wrap(
                          spacing: AppSpacing.grid,
                          runSpacing: AppSpacing.grid,
                          alignment: WrapAlignment.center,
                          children: const [
                            HintButton(label: 'Last'),
                            HintButton(label: 'A/B'),
                            HintButton(label: 'Narrow'),
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
              onPressed: _showResult,
            ),
          ),
        ],
      ),
    );
  }
}

class _YearControlButton extends StatelessWidget {
  const _YearControlButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

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
        ),
        child: Icon(icon, color: AppColors.textPrimary),
      ),
    );
  }
}
