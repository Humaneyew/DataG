import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/tokens.dart';

enum AppButtonVariant { primary, secondary, ghost }

class AppButton extends StatefulWidget {
  const AppButton.primary({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon,
  })  : variant = AppButtonVariant.primary,
        outlineColor = null;

  const AppButton.secondary({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon,
    this.outlineColor,
  }) : variant = AppButtonVariant.secondary;

  const AppButton.ghost({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon,
  })  : variant = AppButtonVariant.ghost,
        outlineColor = null;

  final VoidCallback onPressed;
  final String label;
  final Widget? icon;
  final AppButtonVariant variant;
  final Color? outlineColor;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final label = Text(
      widget.label,
      style: switch (widget.variant) {
        AppButtonVariant.primary => AppTypography.bodyStrong.copyWith(
            color: Colors.black,
            letterSpacing: 0.4,
          ),
        AppButtonVariant.secondary =>
            AppTypography.bodyStrong.copyWith(color: AppColors.accentSecondary),
        AppButtonVariant.ghost => AppTypography.bodyStrong.copyWith(
            color: AppColors.textSecondary,
            letterSpacing: 0.4,
          ),
      },
    );

    final Widget child = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.icon != null) ...[
          widget.icon!,
          const SizedBox(width: AppSpacing.sm),
        ],
        label,
      ],
    );

    Color borderColor;
    Color background;
    List<BoxShadow>? shadows;

    switch (widget.variant) {
      case AppButtonVariant.primary:
        borderColor = Colors.transparent;
        background = _pressed ? AppColors.primaryPressed : AppColors.primary;
        shadows = AppShadows.soft(color: AppColors.primary);
        break;
      case AppButtonVariant.secondary:
        borderColor = widget.outlineColor ?? AppColors.accentSecondary;
        background = Colors.white.withOpacity(0.04);
        shadows = [
          BoxShadow(
            color: (widget.outlineColor ?? AppColors.accentSecondary)
                .withOpacity(0.4),
            blurRadius: 18,
            spreadRadius: 0,
          ),
        ];
        break;
      case AppButtonVariant.ghost:
        borderColor = Colors.transparent;
        background = Colors.transparent;
        shadows = null;
        break;
    }

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: () {
        HapticFeedback.selectionClick();
        widget.onPressed();
      },
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1,
        duration: AppAnimations.short,
        curve: AppAnimations.easing,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: widget.variant == AppButtonVariant.primary
                ? LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.primaryHover,
                    ],
                  )
                : null,
            borderRadius: AppRadii.pill,
            border: Border.all(color: borderColor, width: 1.4),
            color: widget.variant == AppButtonVariant.primary ? null : background,
            boxShadow: shadows,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xxxl,
              vertical: AppSpacing.md,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
