import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/tokens.dart';

enum AppButtonVariant { primary, secondary, ghost }

class AppButton extends StatefulWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.expand = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final IconData? icon;
  final bool expand;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _isPressed = false;

  void _onTapDown(TapDownDetails _) {
    if (widget.onPressed == null) return;
    setState(() => _isPressed = true);
  }

  void _onTapUp(TapUpDetails _) {
    if (widget.onPressed == null) return;
    setState(() => _isPressed = false);
  }

  void _onTapCancel() {
    if (_isPressed) {
      setState(() => _isPressed = false);
    }
  }

  void _triggerHaptic() {
    if (widget.onPressed != null) {
      HapticFeedback.selectionClick();
      widget.onPressed!();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = _resolveColors();
    final scale = _isPressed ? 0.97 : 1.0;
    final textStyle = widget.variant == AppButtonVariant.ghost
        ? AppTypography.body.copyWith(
            fontWeight: FontWeight.w600,
            color: colors.foreground,
          )
        : AppTypography.h3.copyWith(
            fontSize: 16,
            fontFamily: 'Inter',
            color: colors.foreground,
          );

    return AnimatedScale(
      scale: scale,
      duration: AppDurations.short,
      curve: Curves.easeOut,
      child: AnimatedContainer(
        duration: AppDurations.medium,
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: colors.background,
          gradient: colors.gradient,
          borderRadius: BorderRadius.circular(999),
          border: colors.border != null
              ? Border.all(color: colors.border!, width: 1.4)
              : null,
          boxShadow: widget.variant == AppButtonVariant.primary ? AppShadows.soft : null,
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            borderRadius: BorderRadius.circular(999),
            onTap: widget.onPressed == null ? null : _triggerHaptic,
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            child: Container(
              width: widget.expand ? double.infinity : null,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xxl,
                vertical: AppSpacing.md,
              ),
              child: Row(
                mainAxisSize: widget.expand ? MainAxisSize.max : MainAxisSize.min,
                mainAxisAlignment: widget.expand ? MainAxisAlignment.center : MainAxisAlignment.start,
                children: [
                  if (widget.icon != null) ...[
                    Icon(widget.icon, color: colors.foreground, size: 20),
                    const SizedBox(width: AppSpacing.sm),
                  ],
                  Text(widget.label, style: textStyle),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _ButtonColors _resolveColors() {
    switch (widget.variant) {
      case AppButtonVariant.primary:
        return _ButtonColors(
          background: _isPressed ? AppColors.primaryPressed : AppColors.primary,
          foreground: AppColors.backgroundEnd,
        );
      case AppButtonVariant.secondary:
        return _ButtonColors(
          gradient: const LinearGradient(
            colors: [Color(0xFF39324A), Color(0xFF2C2A37)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Colors.white.withOpacity(0.24),
          foreground: AppColors.textPrimary,
        );
      case AppButtonVariant.ghost:
        return _ButtonColors(
          background: Colors.transparent,
          border: Colors.transparent,
          foreground: AppColors.textSecondary,
        );
    }
  }
}

class _ButtonColors {
  const _ButtonColors({
    this.background,
    this.gradient,
    required this.foreground,
    this.border,
  });

  final Color? background;
  final Gradient? gradient;
  final Color foreground;
  final Color? border;
}
