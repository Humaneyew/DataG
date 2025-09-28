import 'dart:math';

import 'package:flutter/material.dart';

import '../../models/question.dart';
import '../tokens.dart';

class TimelineSlider extends StatelessWidget {
  const TimelineSlider({
    super.key,
    required this.minYear,
    required this.maxYear,
    required this.value,
    required this.correctYear,
    required this.correctEra,
    required this.era,
    required this.onChanged,
    this.onEraChanged,
  });

  final int minYear;
  final int maxYear;
  final int value;
  final int correctYear;
  final Era correctEra;
  final Era era;
  final ValueChanged<int> onChanged;
  final ValueChanged<Era>? onEraChanged;

  double get _heat {
    final selectedSigned = era.signedYear(value);
    final correctSigned = correctEra.signedYear(correctYear);
    final rangeSpan = max(1, (maxYear - minYear).abs());
    final distance = (selectedSigned - correctSigned).abs();
    return (1 - (distance / rangeSpan)).clamp(0, 1).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final divisions = max(1, maxYear - minYear);
    final heatColor = Color.lerp(
      AppColors.accentSecondary.withOpacity(0.4),
      AppColors.accentPrimary,
      _heat,
    )!;
    final inactiveTrack = AppColors.borderMuted.withOpacity(0.6);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.grid),
      decoration: BoxDecoration(
        color: AppColors.bgElevated,
        borderRadius: AppRadius.medium,
        border: Border.all(color: AppColors.borderMuted),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 6,
              activeTrackColor: heatColor,
              inactiveTrackColor: inactiveTrack,
              overlayColor: heatColor.withOpacity(0.2),
              thumbColor: heatColor,
              valueIndicatorColor: AppColors.accentPrimary,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
            ),
            child: Slider(
              min: minYear.toDouble(),
              max: maxYear.toDouble(),
              divisions: divisions,
              value: value.clamp(minYear, maxYear).toDouble(),
              label: '$value ${era.label}',
              onChanged: (newValue) => onChanged(newValue.round()),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 32,
            child: CustomPaint(
              painter: _TimelineTicksPainter(
                minYear: minYear,
                maxYear: maxYear,
              ),
            ),
          ),
          const SizedBox(height: 12),
          _CenturyLabels(minYear: minYear, maxYear: maxYear, era: era),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: ToggleButtons(
              isSelected: [era == Era.bce, era == Era.ce],
              onPressed: onEraChanged == null
                  ? null
                  : (index) => onEraChanged!(index == 0 ? Era.bce : Era.ce),
              borderRadius: BorderRadius.circular(20),
              borderColor: AppColors.borderMuted,
              selectedBorderColor: AppColors.accentSecondary,
              fillColor: AppColors.accentSecondary.withOpacity(0.2),
              selectedColor: AppColors.accentSecondary,
              textStyle: const TextStyle(fontSize: 13),
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Text('BCE'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Text('CE'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineTicksPainter extends CustomPainter {
  const _TimelineTicksPainter({
    required this.minYear,
    required this.maxYear,
  });

  final int minYear;
  final int maxYear;

  @override
  void paint(Canvas canvas, Size size) {
    final total = max(1, maxYear - minYear);
    final paint = Paint()
      ..color = AppColors.borderMuted
      ..strokeWidth = 1;
    for (int offset = 0; offset <= total; offset++) {
      final year = minYear + offset;
      final dx = size.width * (offset / total);
      final tickHeight = year % 10 == 0
          ? size.height
          : year % 5 == 0
              ? size.height * 0.65
              : size.height * 0.4;
      canvas.drawLine(
        Offset(dx, size.height - tickHeight),
        Offset(dx, size.height),
        paint,
      );
      if (year % 10 == 0) {
        final textPainter = TextPainter(
          text: TextSpan(
            text: year.toString(),
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 10,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        textPainter.paint(
          canvas,
          Offset(dx - textPainter.width / 2, 0),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _TimelineTicksPainter oldDelegate) {
    return oldDelegate.minYear != minYear || oldDelegate.maxYear != maxYear;
  }
}

class _CenturyLabels extends StatelessWidget {
  const _CenturyLabels({
    required this.minYear,
    required this.maxYear,
    required this.era,
  });

  final int minYear;
  final int maxYear;
  final Era era;

  @override
  Widget build(BuildContext context) {
    final centuries = _buildCenturies();
    if (centuries.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: centuries
          .map(
            (century) => Text(
              '${century.roman} (${century.start}–${century.end}) ${era.label}',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          )
          .toList(),
    );
  }

  List<_CenturyData> _buildCenturies() {
    final startCentury = _centuryForYear(minYear);
    final endCentury = _centuryForYear(maxYear);
    final centuries = <_CenturyData>[];
    for (int century = startCentury; century <= endCentury; century++) {
      final start = max(minYear, _centuryStart(century));
      final end = min(maxYear, _centuryEnd(century));
      centuries.add(
        _CenturyData(
          roman: _toRoman(century),
          start: start,
          end: end,
        ),
      );
    }
    return centuries;
  }

  int _centuryForYear(int year) {
    final safeYear = max(1, year);
    return ((safeYear - 1) ~/ 100) + 1;
  }

  int _centuryStart(int century) => (century - 1) * 100;

  int _centuryEnd(int century) => century * 100 - 1;

  String _toRoman(int value) {
    const numerals = {
      1000: 'M',
      900: 'CM',
      500: 'D',
      400: 'CD',
      100: 'C',
      90: 'XC',
      50: 'L',
      40: 'XL',
      10: 'X',
      9: 'IX',
      5: 'V',
      4: 'IV',
      1: 'I',
    };
    var number = value;
    final buffer = StringBuffer();
    for (final entry in numerals.entries) {
      while (number >= entry.key) {
        buffer.write(entry.value);
        number -= entry.key;
      }
    }
    return buffer.toString();
  }
}

class _CenturyData {
  const _CenturyData({
    required this.roman,
    required this.start,
    required this.end,
  });

  final String roman;
  final int start;
  final int end;
}
