import 'package:flutter/material.dart';

import 'tokens.dart';

class AppTheme {
  static ThemeData get dark {
    final base = ThemeData.dark();
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
      primary: AppColors.primary,
      background: Colors.transparent,
    );

    final textTheme = base.textTheme.copyWith(
      displayLarge: AppTypography.display,
      headlineMedium: AppTypography.h1,
      headlineSmall: AppTypography.h2,
      titleLarge: AppTypography.h3,
      bodyLarge: AppTypography.body,
      bodyMedium: AppTypography.body,
      bodySmall: AppTypography.caption,
    );

    return base.copyWith(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: Colors.transparent,
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      fontFamily: 'Inter',
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      dividerColor: AppColors.outline,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.macOS: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
        },
      ),
      iconTheme: const IconThemeData(color: AppColors.textSecondary),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.medium),
          side: const BorderSide(color: AppColors.outline),
        ),
        labelStyle: AppTypography.caption,
      ),
      snackBarTheme: base.snackBarTheme.copyWith(
        backgroundColor: AppColors.surfaceElevated,
        contentTextStyle: AppTypography.body,
      ),
    );
  }
}
