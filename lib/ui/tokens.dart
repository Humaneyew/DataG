import 'dart:ui';

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

  static const double s = 8.0;
  static const double m = 12.0;
  static const double l = 16.0;
  static const double xl = 24.0;

  /// Legacy grid spacing kept for backwards compatibility.
  static const double grid = m;
  static const double screenPadding = l;
}

class AppRadius {
  const AppRadius._();

  static const BorderRadius medium = BorderRadius.all(Radius.circular(12));
  static const BorderRadius pill = BorderRadius.all(Radius.circular(999));
}

class AppBorders {
  const AppBorders._();

  static const BorderSide muted = BorderSide(
    color: AppColors.borderMuted,
    width: 1.0,
  );

  static const BorderSide focus = BorderSide(
    color: AppColors.accentSecondary,
    width: 2.0,
  );
}

class AppShadows {
  const AppShadows._();

  static const List<BoxShadow> soft = <BoxShadow>[
    BoxShadow(
      color: Color(0x330C111D),
      offset: Offset(0, 6),
      blurRadius: 18,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> deep = <BoxShadow>[
    BoxShadow(
      color: Color(0x1F0C111D),
      offset: Offset(0, 24),
      blurRadius: 48,
      spreadRadius: -12,
    ),
  ];
}

class AppTypography {
  const AppTypography._();

  static const String fontFamily = 'Inter';
  static const List<String> fontFallback = <String>['Roboto'];
  static const List<FontFeature> fontFeatures = <FontFeature>[
    FontFeature.tabularFigures(),
    FontFeature.liningFigures(),
  ];

  static TextStyle _base({
    required double size,
    FontWeight weight = FontWeight.w400,
    double height = 1.4,
    double? letterSpacing,
    Color color = AppColors.textPrimary,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontFamilyFallback: fontFallback,
      fontFeatures: fontFeatures,
      fontSize: size,
      fontWeight: weight,
      height: height,
      letterSpacing: letterSpacing,
      color: color,
    );
  }

  static final TextStyle h1Year = _base(
    size: 50,
    weight: FontWeight.w600,
    height: 1.08,
  );

  static final TextStyle h2Fact = _base(
    size: 20,
    weight: FontWeight.w500,
    height: 1.35,
  );

  static TextStyle h2FactEmphasis(BuildContext context) =>
      h2Fact.copyWith(fontWeight: FontWeight.w600);

  static final TextStyle chip = _base(
    size: 15,
    weight: FontWeight.w500,
    letterSpacing: 0.1,
  );

  static final TextStyle secondary = _base(
    size: 14,
    color: AppColors.textSecondary,
  );

  static final TextStyle buttonLarge = _base(
    size: 18,
    weight: FontWeight.w600,
    height: 1.2,
    color: Colors.black,
  );

  static final TextStyle label = _base(
    size: 14,
    weight: FontWeight.w500,
  );

  static final TextTheme textTheme = TextTheme(
    displayLarge: h1Year,
    headlineSmall: h2Fact,
    titleLarge: _base(size: 22, weight: FontWeight.w600, height: 1.3),
    titleMedium: _base(size: 18, weight: FontWeight.w600, height: 1.3),
    titleSmall: _base(size: 16, weight: FontWeight.w600, height: 1.3),
    bodyLarge: _base(size: 16, height: 1.6),
    bodyMedium: _base(size: 14, height: 1.5),
    bodySmall: _base(size: 12, height: 1.4, color: AppColors.textSecondary),
    labelLarge: label,
    labelMedium: _base(
      size: 13,
      weight: FontWeight.w500,
      color: AppColors.textSecondary,
    ),
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

class AppStateLayers {
  const AppStateLayers._();

  static Color primary(Set<WidgetState> states) {
    if (states.contains(WidgetState.disabled)) {
      return AppColors.accentPrimary.withValues(alpha: 0.28);
    }
    var color = AppColors.accentPrimary;
    if (states.contains(WidgetState.pressed)) {
      color = _blend(color, Colors.black, 0.18);
    } else if (states.contains(WidgetState.hovered)) {
      color = _blend(color, Colors.white, 0.08);
    }
    return color;
  }

  static Color secondary(Set<WidgetState> states) {
    if (states.contains(WidgetState.disabled)) {
      return AppColors.bgBase.withValues(alpha: 0.32);
    }
    var color = AppColors.bgBase;
    if (states.contains(WidgetState.pressed)) {
      color = _blend(color, Colors.white, 0.08);
    } else if (states.contains(WidgetState.hovered)) {
      color = _blend(color, Colors.white, 0.04);
    }
    return color;
  }

  static Color elevatedSurface(Set<WidgetState> states) {
    if (states.contains(WidgetState.disabled)) {
      return AppColors.bgElevated.withValues(alpha: 0.5);
    }
    var color = AppColors.bgElevated;
    if (states.contains(WidgetState.pressed)) {
      color = _blend(color, Colors.black, 0.22);
    } else if (states.contains(WidgetState.hovered)) {
      color = _blend(color, Colors.white, 0.06);
    }
    return color;
  }

  static Color accentSurface(Set<WidgetState> states) {
    if (states.contains(WidgetState.disabled)) {
      return AppColors.accentSecondary.withValues(alpha: 0.12);
    }
    var color = AppColors.accentSecondary.withValues(alpha: 0.18);
    if (states.contains(WidgetState.pressed)) {
      color = AppColors.accentSecondary.withValues(alpha: 0.26);
    } else if (states.contains(WidgetState.hovered)) {
      color = AppColors.accentSecondary.withValues(alpha: 0.22);
    }
    return color;
  }

  static Color _blend(Color base, Color overlay, double opacity) {
    return Color.alphaBlend(overlay.withValues(alpha: opacity), base);
  }
}

class AppButtonStyles {
  const AppButtonStyles._();

  static final ButtonStyle primary = ButtonStyle(
    minimumSize: WidgetStatePropertyAll<Size>(
      const Size.fromHeight(AppComponentSpecs.primaryButtonHeight),
    ),
    padding: const WidgetStatePropertyAll<EdgeInsets>(
      EdgeInsets.symmetric(horizontal: AppSpacing.l),
    ),
    shape: const WidgetStatePropertyAll<OutlinedBorder>(
      RoundedRectangleBorder(borderRadius: AppRadius.medium),
    ),
    textStyle: WidgetStatePropertyAll<TextStyle>(AppTypography.buttonLarge),
    backgroundColor:
        WidgetStateProperty.resolveWith(AppStateLayers.primary),
    foregroundColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.disabled)) {
        return AppColors.textSecondary.withValues(alpha: 0.6);
      }
      return Colors.black;
    }),
    side: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.focused)) {
        return AppBorders.focus;
      }
      return const BorderSide(color: Colors.transparent, width: 0);
    }),
    shadowColor: const WidgetStatePropertyAll<Color>(
      Color(0x33FFD66B),
    ),
    elevation: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.disabled)) {
        return 0.0;
      }
      if (states.contains(WidgetState.pressed)) {
        return 1.0;
      }
      if (states.contains(WidgetState.hovered)) {
        return 4.0;
      }
      return 2.0;
    }),
    splashFactory: InkRipple.splashFactory,
    animationDuration: AppAnimations.standard,
    enableFeedback: true,
  );

  static final ButtonStyle outline = ButtonStyle(
    minimumSize: const WidgetStatePropertyAll<Size>(
      Size.fromHeight(AppComponentSpecs.minTouchTarget),
    ),
    padding: const WidgetStatePropertyAll<EdgeInsets>(
      EdgeInsets.symmetric(horizontal: AppSpacing.l, vertical: AppSpacing.s),
    ),
    shape: const WidgetStatePropertyAll<OutlinedBorder>(
      RoundedRectangleBorder(borderRadius: AppRadius.medium),
    ),
    side: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.focused)) {
        return AppBorders.focus;
      }
      return AppBorders.muted;
    }),
    foregroundColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.disabled)) {
        return AppColors.textSecondary.withValues(alpha: 0.6);
      }
      return AppColors.textPrimary;
    }),
    backgroundColor:
        WidgetStateProperty.resolveWith(AppStateLayers.secondary),
    textStyle: WidgetStatePropertyAll<TextStyle>(AppTypography.label),
    splashFactory: InkRipple.splashFactory,
    animationDuration: AppAnimations.standard,
  );

  static final ButtonStyle text = ButtonStyle(
    foregroundColor: const WidgetStatePropertyAll<Color>(
      AppColors.accentSecondary,
    ),
    textStyle: WidgetStatePropertyAll<TextStyle>(
      AppTypography.label.copyWith(color: AppColors.accentSecondary),
    ),
    overlayColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.pressed)) {
        return AppColors.accentSecondary.withValues(alpha: 0.24);
      }
      if (states.contains(WidgetState.hovered)) {
        return AppColors.accentSecondary.withValues(alpha: 0.12);
      }
      return AppColors.accentSecondary.withValues(alpha: 0.06);
    }),
    side: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.focused)) {
        return AppBorders.focus;
      }
      return const BorderSide(color: Colors.transparent);
    }),
    splashFactory: InkRipple.splashFactory,
  );

  static final ButtonStyle icon = ButtonStyle(
    minimumSize: const WidgetStatePropertyAll<Size>(
      Size.square(AppComponentSpecs.minTouchTarget),
    ),
    shape: const WidgetStatePropertyAll<OutlinedBorder>(CircleBorder()),
    padding: const WidgetStatePropertyAll<EdgeInsets>(EdgeInsets.zero),
    foregroundColor: const WidgetStatePropertyAll<Color>(
      AppColors.textPrimary,
    ),
    overlayColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.pressed)) {
        return AppColors.textPrimary.withValues(alpha: 0.24);
      }
      if (states.contains(WidgetState.hovered)) {
        return AppColors.textPrimary.withValues(alpha: 0.12);
      }
      return AppColors.textPrimary.withValues(alpha: 0.08);
    }),
    side: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.focused)) {
        return AppBorders.focus;
      }
      return const BorderSide(color: Colors.transparent);
    }),
    splashFactory: InkRipple.splashFactory,
  );

  static final ButtonStyle segmented = ButtonStyle(
    minimumSize: const WidgetStatePropertyAll<Size>(
      Size(AppComponentSpecs.minTouchTarget, AppComponentSpecs.minTouchTarget),
    ),
    padding: const WidgetStatePropertyAll<EdgeInsets>(
      EdgeInsets.symmetric(horizontal: AppSpacing.m, vertical: AppSpacing.s),
    ),
    backgroundColor:
        WidgetStateProperty.resolveWith(AppStateLayers.elevatedSurface),
    foregroundColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.disabled)) {
        return AppColors.textSecondary.withValues(alpha: 0.5);
      }
      if (states.contains(WidgetState.selected)) {
        return AppColors.accentSecondary;
      }
      return AppColors.textPrimary;
    }),
    side: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.focused)) {
        return AppBorders.focus;
      }
      if (states.contains(WidgetState.selected)) {
        return BorderSide(color: AppColors.accentSecondary, width: 1.5);
      }
      return AppBorders.muted;
    }),
    overlayColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.pressed)) {
        return AppColors.accentSecondary.withValues(alpha: 0.24);
      }
      if (states.contains(WidgetState.hovered)) {
        return AppColors.accentSecondary.withValues(alpha: 0.12);
      }
      return Colors.transparent;
    }),
    shape: const WidgetStatePropertyAll<OutlinedBorder>(
      RoundedRectangleBorder(borderRadius: AppRadius.pill),
    ),
    splashFactory: InkRipple.splashFactory,
  );
}

class AppTheme {
  const AppTheme._();

  static ThemeData get dark {
    final colorScheme = const ColorScheme.dark(
      surface: AppColors.bgElevated,
      primary: AppColors.accentPrimary,
      secondary: AppColors.accentSecondary,
      error: AppColors.error,
      onSurface: AppColors.textPrimary,
      onPrimary: Colors.black,
      onSecondary: AppColors.textPrimary,
      onError: Colors.black,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.bgBase,
      fontFamily: AppTypography.fontFamily,
      fontFamilyFallback: AppTypography.fontFallback,
      textTheme: AppTypography.textTheme,
      splashFactory: InkRipple.splashFactory,
      iconButtonTheme: IconButtonThemeData(style: AppButtonStyles.icon),
      filledButtonTheme: FilledButtonThemeData(style: AppButtonStyles.primary),
      outlinedButtonTheme: OutlinedButtonThemeData(style: AppButtonStyles.outline),
      textButtonTheme: TextButtonThemeData(style: AppButtonStyles.text),
      segmentedButtonTheme:
          SegmentedButtonThemeData(style: AppButtonStyles.segmented),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.bgElevated,
        disabledColor: AppColors.bgElevated.withValues(alpha: 0.4),
        selectedColor: AppColors.accentSecondary.withValues(alpha: 0.2),
        secondarySelectedColor: AppColors.accentSecondary.withValues(alpha: 0.26),
        labelStyle: AppTypography.chip,
        secondaryLabelStyle:
            AppTypography.chip.copyWith(color: AppColors.textSecondary),
        side: AppBorders.muted,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.m,
          vertical: AppSpacing.s,
        ),
        shape: const StadiumBorder(),
        showCheckmark: false,
      ),
      cardTheme: CardThemeData(
        color: AppColors.bgElevated,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.medium),
        elevation: 0,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: AppColors.bgElevated,
        textStyle: AppTypography.textTheme.bodyMedium,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.medium),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.accentSecondary,
        linearTrackColor: AppColors.borderMuted,
      ),
      dividerColor: AppColors.borderMuted,
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.accentSecondary;
          }
          return AppColors.borderMuted;
        }),
        side: const BorderSide(color: AppColors.borderMuted, width: 1.5),
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.medium),
      ),
    );
  }
}
