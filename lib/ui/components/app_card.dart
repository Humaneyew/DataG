import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/tokens.dart';

enum AppCardVariant { elevated, outlined, gradient }

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.variant = AppCardVariant.elevated,
    this.onTap,
    this.padding = const EdgeInsets.all(AppSpacing.xl),
  });

  final Widget child;
  final AppCardVariant variant;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final decoration = _resolveDecoration();
    final card = AnimatedContainer(
      duration: AppDurations.medium,
      curve: Curves.easeOut,
      padding: padding,
      decoration: decoration,
      child: child,
    );

    if (onTap == null) {
      return card;
    }
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap!.call();
      },
      child: card,
    );
  }

  BoxDecoration _resolveDecoration() {
    switch (variant) {
      case AppCardVariant.elevated:
        return BoxDecoration(
          color: AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(AppRadii.large),
          boxShadow: AppShadows.soft,
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        );
      case AppCardVariant.outlined:
        return BoxDecoration(
          color: Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(AppRadii.medium),
          border: Border.all(color: Colors.white.withOpacity(0.16)),
        );
      case AppCardVariant.gradient:
        return BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF2F2441), Color(0xFF1E1B29)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppRadii.large),
          border: Border.all(color: Colors.white.withOpacity(0.18)),
        );
    }
  }
}
