import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/tokens.dart';

enum AppBadgeVariant { filled, outline, neon }

class AppBadge extends StatelessWidget {
  const AppBadge({
    super.key,
    required this.label,
    this.icon,
    this.variant = AppBadgeVariant.filled,
    this.color,
    this.onTap,
  });

  final String label;
  final IconData? icon;
  final AppBadgeVariant variant;
  final Color? color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final palette = _resolvePalette();
    final badge = Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: palette.background,
        gradient: palette.gradient,
        borderRadius: BorderRadius.circular(AppRadii.medium),
        border: palette.border != null ? Border.all(color: palette.border!, width: 1.2) : null,
        boxShadow: palette.shadow,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: palette.foreground),
            const SizedBox(width: AppSpacing.xs),
          ],
          Text(
            label,
            style: AppTypography.caption.copyWith(
              fontWeight: FontWeight.w600,
              color: palette.foreground,
              letterSpacing: 0.6,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );

    if (onTap == null) return badge;

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap!();
      },
      child: badge,
    );
  }

  _BadgePalette _resolvePalette() {
    final baseColor = color ?? AppColors.primary;
    switch (variant) {
      case AppBadgeVariant.filled:
        return _BadgePalette(
          background: baseColor.withOpacity(0.16),
          border: baseColor.withOpacity(0.28),
          foreground: baseColor,
        );
      case AppBadgeVariant.outline:
        return _BadgePalette(
          background: Colors.transparent,
          border: baseColor.withOpacity(0.4),
          foreground: baseColor,
        );
      case AppBadgeVariant.neon:
        return _BadgePalette(
          gradient: LinearGradient(
            colors: [baseColor, baseColor.withOpacity(0.4)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          foreground: AppColors.backgroundEnd,
          shadow: const [
            BoxShadow(
              color: Color(0x40F4D47C),
              blurRadius: 24,
              spreadRadius: 1,
            ),
          ],
        );
    }
  }
}

class _BadgePalette {
  const _BadgePalette({
    this.background,
    this.gradient,
    required this.foreground,
    this.border,
    this.shadow,
  });

  final Color? background;
  final Gradient? gradient;
  final Color foreground;
  final Color? border;
  final List<BoxShadow>? shadow;
}
