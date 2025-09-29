import 'package:flutter/material.dart';

import 'tokens.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get dark {
    final base = ThemeData.dark(useMaterial3: true);

    final colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.primary,
      onPrimary: Colors.black,
      secondary: AppColors.primary,
      onSecondary: Colors.black,
      error: AppColors.error,
      onError: Colors.white,
      surface: AppColors.gradientEnd,
      onSurface: AppColors.textPrimary,
      background: AppColors.gradientStart,
      onBackground: AppColors.textPrimary,
      tertiary: AppColors.success,
      onTertiary: Colors.black,
      surfaceVariant: AppColors.gradientEnd,
      onSurfaceVariant: AppColors.textSecondary,
      outline: AppColors.outline,
      shadow: Colors.black,
      inverseSurface: Colors.black,
      onInverseSurface: Colors.white,
      inversePrimary: AppColors.primaryHover,
      scrim: Colors.black54,
    );

    return base.copyWith(
      colorScheme: colorScheme,
      textTheme: AppTypography.textTheme,
      scaffoldBackgroundColor: Colors.transparent,
      canvasColor: Colors.transparent,
      cardTheme: CardTheme(
        color: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.medium),
        margin: EdgeInsets.zero,
      ),
      dialogTheme: const DialogTheme(backgroundColor: Colors.transparent),
      dividerColor: AppColors.outline,
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          textStyle: WidgetStateProperty.all(AppTypography.bodyStrong),
          foregroundColor: WidgetStateProperty.all(Colors.black),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return AppColors.primary.withOpacity(0.4);
            }
            if (states.contains(WidgetState.pressed)) {
              return AppColors.primaryPressed;
            }
            if (states.contains(WidgetState.hovered)) {
              return AppColors.primaryHover;
            }
            return AppColors.primary;
          }),
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          shape: WidgetStateProperty.all(
            const RoundedRectangleBorder(borderRadius: AppRadii.pill),
          ),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(
              horizontal: AppSpacing.xxl,
              vertical: AppSpacing.sm,
            ),
          ),
        ),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.macOS: FadeUpwardsPageTransitionsBuilder(),
        },
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.surfaceStrong,
        contentTextStyle: AppTypography.body.copyWith(
          color: AppColors.textPrimary,
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.medium),
      ),
    );
  }
}
