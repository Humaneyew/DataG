import 'package:flutter/material.dart';

class AppColors {
  static const Color backgroundStart = Color(0xFF14121A);
  static const Color backgroundEnd = Color(0xFF0A0A0F);

  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFC8CAD3);
  static const Color textMuted = Color(0xFF8E93A4);

  static const Color primary = Color(0xFFF4D47C);
  static const Color primaryHover = Color(0xFFE3BF63);
  static const Color primaryPressed = Color(0xFFCFA74E);

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

  static const List<Color> mixCategory = <Color>[
    Color(0xFFF6D17A),
    Color(0xFFFF8A34),
    Color(0xFFFF5B84),
    Color(0xFFFF6FB2),
    Color(0xFFE66BE7),
    Color(0xFFB488FF),
    Color(0xFF7C8CFF),
    Color(0xFF58B9FF),
    Color(0xFF38E1E7),
    Color(0xFFE7B657),
    Color(0xFFFF6268),
    Color(0xFFFF5DD6),
  ];

  static const Color surface = Color(0x1AFFFFFF);
  static const Color surfaceElevated = Color(0x33FFFFFF);
  static const Color outline = Color(0x33FFFFFF);
  static const Color outlineStrong = Color(0x66FFFFFF);
  static const Color shadow = Color(0x2E000000);
}

class AppSpacing {
  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 20;
  static const double xl = 24;
  static const double xxl = 32;

  static const double screenPadding = 24;
  static const double itemSpacing = 16;
}

class AppRadii {
  static const double small = 12;
  static const double medium = 16;
  static const double large = 20;
}

class AppDurations {
  static const Duration short = Duration(milliseconds: 200);
  static const Duration medium = Duration(milliseconds: 240);
  static const Duration long = Duration(milliseconds: 280);
}

class AppShadows {
  static const List<BoxShadow> soft = <BoxShadow>[
    BoxShadow(
      color: AppColors.shadow,
      blurRadius: 24,
      offset: Offset(0, 16),
    ),
  ];
}

class AppTypography {
  static TextStyle get display => const TextStyle(
        fontFamily: 'PlayfairDisplay',
        fontWeight: FontWeight.w500,
        fontSize: 36,
        height: 1.1,
        color: AppColors.textPrimary,
      );

  static TextStyle get h1 => const TextStyle(
        fontFamily: 'PlayfairDisplay',
        fontWeight: FontWeight.w700,
        fontSize: 28,
        height: 1.16,
        color: AppColors.textPrimary,
      );

  static TextStyle get h2 => const TextStyle(
        fontFamily: 'PlayfairDisplay',
        fontWeight: FontWeight.w500,
        fontSize: 22,
        height: 1.2,
        color: AppColors.textPrimary,
      );

  static TextStyle get h3 => const TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w600,
        fontSize: 18,
        height: 1.22,
        color: AppColors.textPrimary,
      );

  static TextStyle get body => const TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w400,
        fontSize: 16,
        height: 1.4,
        color: AppColors.textSecondary,
      );

  static TextStyle get caption => const TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w400,
        fontSize: 12,
        height: 1.3,
        color: AppColors.textMuted,
      );

  static TextStyle numeric({
    FontWeight fontWeight = FontWeight.w600,
    double fontSize = 16,
    Color color = AppColors.textPrimary,
  }) {
    return TextStyle(
      fontFamily: 'Inter',
      fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
      fontWeight: fontWeight,
      fontSize: fontSize,
      height: 1.2,
      color: color,
    );
  }
}

class CategoryToken {
  CategoryToken({
    required this.id,
    required this.label,
    required this.color,
    this.gradient,
  });

  final String id;
  final String label;
  final Color color;
  final Gradient? gradient;
}

class AppCategories {
  static final List<CategoryToken> values = <CategoryToken>[
    CategoryToken(id: 'history', label: 'History', color: AppColors.categoryColors['history']!),
    CategoryToken(id: 'sport', label: 'Sport', color: AppColors.categoryColors['sport']!),
    CategoryToken(id: 'movies', label: 'Movies', color: AppColors.categoryColors['movies']!),
    CategoryToken(id: 'art', label: 'Art', color: AppColors.categoryColors['art']!),
    CategoryToken(id: 'games', label: 'Games', color: AppColors.categoryColors['games']!),
    CategoryToken(id: 'books', label: 'Books', color: AppColors.categoryColors['books']!),
    CategoryToken(id: 'vehicles', label: 'Vehicles', color: AppColors.categoryColors['vehicles']!),
    CategoryToken(id: 'world', label: 'World', color: AppColors.categoryColors['world']!),
    CategoryToken(id: 'tech', label: 'Tech', color: AppColors.categoryColors['tech']!),
    CategoryToken(id: 'food', label: 'Food', color: AppColors.categoryColors['food']!),
    CategoryToken(id: 'culture', label: 'Culture', color: AppColors.categoryColors['culture']!),
    CategoryToken(id: 'fashion', label: 'Fashion', color: AppColors.categoryColors['fashion']!),
    CategoryToken(
      id: 'mix',
      label: 'Mix',
      color: AppColors.primary,
      gradient: const SweepGradient(colors: AppColors.mixCategory),
    ),
  ];

  static CategoryToken byId(String id) {
    return values.firstWhere(
      (token) => token.id == id,
      orElse: () => values.first,
    );
  }
}
