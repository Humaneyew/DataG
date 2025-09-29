import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color gradientStart = Color(0xFF14121A);
  static const Color gradientEnd = Color(0xFF0A0A0F);

  static const Color bgBase = gradientStart;
  static const Color bgElevated = Color(0xFF1C1A23);

  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFC8CAD3);
  static const Color textTertiary = Color(0xFF8E93A4);

  static const Color primary = Color(0xFFF4D47C);
  static const Color primaryHover = Color(0xFFD9BB63);
  static const Color primaryPressed = Color(0xFFBEA14F);
  static const Color accentPrimary = primary;
  static const Color accentSecondary = Color(0xFF58B9FF);

  static const Color success = Color(0xFF57E39C);
  static const Color error = Color(0xFFFF5A5A);
  static const Color warning = Color(0xFFFFC466);

  static const Map<String, Color> categoryColors = <String, Color>{
    'history': Color(0xFFF6D17A),
    'sport': Color(0xFFFF8A34),
    'movies': Color(0xFFFF5B84),
    'art': Color(0xFFFF6FB2),
    'games': Color(0xFFE66BE7),
    'books': Color(0xFFB488FF),
    'vehicles': Color(0xFF7C8CFF),
    'world': Color(0xFF58B9FF),
    'tech': Color(0xFF38E1E7),
    'food': Color(0xFFE7B657),
    'culture': Color(0xFFFF6268),
    'fashion': Color(0xFFFF5DD6),
  };

  static const List<Color> mixBorder = <Color>[
    Color(0xFFF6D17A),
    Color(0xFFFF8A34),
    Color(0xFFFF5B84),
    Color(0xFFE66BE7),
    Color(0xFF7C8CFF),
    Color(0xFF58B9FF),
    Color(0xFF38E1E7),
  ];

  static const Color surface = Color(0x1AF4D47C);
  static const Color surfaceStrong = Color(0x33FFFFFF);
  static const Color outline = Color(0x33FFFFFF);
  static const Color borderMuted = outline;
}

class AppSpacing {
  AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;
  static const double screenPadding = xxl;
}

class AppRadii {
  AppRadii._();

  static const BorderRadius small = BorderRadius.all(Radius.circular(12));
  static const BorderRadius medium = BorderRadius.all(Radius.circular(16));
  static const BorderRadius large = BorderRadius.all(Radius.circular(20));
  static const BorderRadius pill = BorderRadius.all(Radius.circular(999));
}

class AppBorders {
  AppBorders._();

  static const BorderSide muted = BorderSide(
    color: AppColors.borderMuted,
    width: 1.0,
  );

  static final BorderSide focus = BorderSide(
    color: AppColors.accentSecondary,
    width: 2.0,
  );
}

class AppShadows {
  AppShadows._();

  static List<BoxShadow> soft({Color color = Colors.black}) => <BoxShadow>[
        BoxShadow(
          color: color.withOpacity(0.18),
          blurRadius: 24,
          offset: const Offset(0, 12),
        ),
      ];
}

class AppAnimations {
  AppAnimations._();

  static const Duration short = Duration(milliseconds: 200);
  static const Duration medium = Duration(milliseconds: 240);
  static const Duration long = Duration(milliseconds: 280);
  static const Curve easing = Curves.easeOutCubic;
  static const Duration micro = Duration(milliseconds: 180);
  static const Duration standard = medium;
  static Curve get eased => easing;
}

class AppComponentSpecs {
  AppComponentSpecs._();

  static const double primaryButtonHeight = 56.0;
  static const double progressBarHeight = 3.0;
  static const double minTouchTarget = 48.0;
}

class AppStateLayers {
  AppStateLayers._();

  static Color elevatedSurface(Set<WidgetState> states) {
    var base = Colors.white.withOpacity(0.06);
    if (states.contains(WidgetState.disabled)) {
      return Colors.white.withOpacity(0.02);
    }
    if (states.contains(WidgetState.pressed)) {
      base = Colors.white.withOpacity(0.12);
    } else if (states.contains(WidgetState.hovered)) {
      base = Colors.white.withOpacity(0.08);
    }
    return base;
  }

  static Color accentSurface(Set<WidgetState> states) {
    var color = AppColors.accentSecondary.withOpacity(0.14);
    if (states.contains(WidgetState.disabled)) {
      return AppColors.accentSecondary.withOpacity(0.08);
    }
    if (states.contains(WidgetState.pressed)) {
      color = AppColors.accentSecondary.withOpacity(0.28);
    } else if (states.contains(WidgetState.hovered)) {
      color = AppColors.accentSecondary.withOpacity(0.18);
    }
    return color;
  }
}

class AppTypography {
  AppTypography._();

  static const String serif = 'Playfair Display';
  static const String sans = 'Inter';

  static const List<String> sansFallback = <String>['Roboto', 'Arial'];
  static const List<String> serifFallback = <String>['Georgia'];

  static const List<FontFeature> numericFeatures = <FontFeature>[
    FontFeature.tabularFigures(),
    FontFeature.liningFigures(),
  ];

  static TextStyle _base(
    double size, {
    FontWeight weight = FontWeight.w400,
    double height = 1.4,
    Color color = AppColors.textPrimary,
    bool serif = false,
    double? letterSpacing,
  }) {
    return TextStyle(
      fontFamily: serif ? AppTypography.serif : AppTypography.sans,
      fontFamilyFallback: serif
          ? AppTypography.serifFallback
          : AppTypography.sansFallback,
      fontWeight: weight,
      fontSize: size,
      height: height,
      letterSpacing: letterSpacing,
      color: color,
      fontFeatures: AppTypography.numericFeatures,
    );
  }

  static final TextStyle display = _base(
    36,
    weight: FontWeight.w500,
    serif: true,
    height: 1.1,
  );

  static final TextStyle h1 = _base(
    28,
    weight: FontWeight.w700,
    serif: true,
    height: 1.2,
  );

  static final TextStyle h2 = _base(
    22,
    weight: FontWeight.w600,
    serif: true,
    height: 1.25,
  );

  static final TextStyle h3 = _base(
    18,
    weight: FontWeight.w600,
  );

  static final TextStyle body = _base(16, height: 1.6);

  static final TextStyle bodyStrong = _base(
    16,
    weight: FontWeight.w600,
  );

  static final TextStyle caption = _base(
    12,
    color: AppColors.textTertiary,
    height: 1.4,
  );

  static final TextTheme textTheme = TextTheme(
    displayLarge: display,
    headlineLarge: h1,
    headlineMedium: h2,
    headlineSmall: h3,
    titleLarge: bodyStrong,
    titleMedium: bodyStrong,
    titleSmall: body,
    bodyLarge: body,
    bodyMedium: body,
    bodySmall: caption,
    labelLarge: bodyStrong,
    labelMedium: caption,
    labelSmall: caption,
  );

  // Legacy aliases kept for compatibility with existing widgets.
  static TextStyle get h1Year => display;
  static TextStyle get h2Fact => h2;
  static TextStyle get chip => bodyStrong.copyWith(
        fontSize: 14,
        letterSpacing: 0.2,
      );
  static TextStyle get secondary => body.copyWith(
        fontSize: 14,
        color: AppColors.textSecondary,
      );
  static TextStyle get buttonLarge => bodyStrong.copyWith(fontSize: 18);
  static TextStyle get label => bodyStrong.copyWith(fontSize: 14);
}
