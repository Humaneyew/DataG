import 'package:flutter/material.dart';

import '../theme/tokens.dart';

class AppBadge extends StatelessWidget {
  const AppBadge.weekly({super.key})
      : label = 'Weekly',
        color = AppColors.primary,
        gradientBorder = null;

  const AppBadge.category({
    super.key,
    required this.label,
    required Color this.color,
    this.gradientBorder,
  });

  final String label;
  final Color color;
  final List<Color>? gradientBorder;

  @override
  Widget build(BuildContext context) {
    final borderDecoration = gradientBorder == null
        ? Border.all(color: color.withOpacity(0.6), width: 1)
        : null;

    final borderGradient = gradientBorder == null
        ? null
        : SweepGradient(colors: gradientBorder!);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: AppRadii.pill,
        border: borderDecoration,
        gradient: borderGradient,
      ),
      child: Padding(
        padding: const EdgeInsets.all(1.5),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            borderRadius: AppRadii.pill,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm,
            ),
            child: Text(
              label,
              style: AppTypography.chip.copyWith(color: color),
            ),
          ),
        ),
      ),
    );
  }
}
