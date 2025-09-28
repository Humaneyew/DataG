import 'package:flutter/material.dart';

/// Centralized design tokens for the dark MVP theme described in the
/// "Визуальная система и UX-основания" specification.
///
/// Light theme should reuse these semantic tokens with adjusted values.
class AppColors {
  const AppColors._();

  static const Color bgBase = Color(0xFF0C0F13);
  static const Color bgElevated = Color(0xFF131921);

  static const Color textPrimary = Color(0xFFEAF0FF);
  static const Color textSecondary = Color(0xFFA9B3C8);

  static const Color borderMuted = Color(0xFF2A3140);

  static const Color accentPrimary = Color(0xFFFFD66B);
  static const Color accentSecondary = Color(0xFF8A9EFF);

  static const Color error = Color(0xFFFF6B6B);
  static const Color success = Color(0xFF6BFF95);
}

class AppSpacing {
  const AppSpacing._();

  static const double grid = 12.0;
  static const double screenPadding = 16.0;
}

class AppRadius {
  const AppRadius._();

  static const BorderRadius medium = BorderRadius.all(Radius.circular(12));
}

class AppBorders {
  const AppBorders._();

  static const BorderSide muted = BorderSide(
    color: AppColors.borderMuted,
    width: 1.0,
  );
}

class AppTypography {
  const AppTypography._();

  static const _fontFamily = 'Inter';
  static const _fontFallback = <String>['Roboto'];
  static const _fontFeatures = <FontFeature>[
    FontFeature.tabularFigures(),
    FontFeature.liningFigures(),
  ];

  static const TextStyle h1Year = TextStyle(
    fontFamily: _fontFamily,
    fontFamilyFallback: _fontFallback,
    fontFeatures: _fontFeatures,
    fontSize: 50,
    fontWeight: FontWeight.w600,
    height: 1.1,
    color: AppColors.textPrimary,
  );

  static const TextStyle h2Fact = TextStyle(
    fontFamily: _fontFamily,
    fontFamilyFallback: _fontFallback,
    fontFeatures: _fontFeatures,
    fontSize: 19,
    fontWeight: FontWeight.w500,
    height: 1.4,
    color: AppColors.textPrimary,
  );

  static TextStyle h2FactEmphasis(BuildContext context) => h2Fact.copyWith(
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  static const TextStyle chip = TextStyle(
    fontFamily: _fontFamily,
    fontFamilyFallback: _fontFallback,
    fontFeatures: _fontFeatures,
    fontSize: 15,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    color: AppColors.textPrimary,
  );

  static const TextStyle secondary = TextStyle(
    fontFamily: _fontFamily,
    fontFamilyFallback: _fontFallback,
    fontFeatures: _fontFeatures,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: AppColors.textSecondary,
  );
}

class AppAnimations {
  const AppAnimations._();

  static const Duration micro = Duration(milliseconds: 150);
  static const Duration standard = Duration(milliseconds: 200);
  static const Curve eased = Curves.easeOutCubic;
}

class AppComponentSpecs {
  const AppComponentSpecs._();

  static const double primaryButtonHeight = 56.0;
  static const double progressBarHeight = 3.0;
  static const double minTouchTarget = 48.0;
}
