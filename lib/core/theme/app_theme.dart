import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData build() {
    const ColorScheme colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.warmBeige,
      onPrimary: AppColors.deepNavy,
      secondary: AppColors.dustyPink,
      onSecondary: AppColors.deepNavy,
      error: Color(0xFFFF7B91),
      onError: Colors.white,
      surface: AppColors.midnightBlue,
      onSurface: AppColors.moonWhite,
      surfaceContainerHighest: AppColors.softPurple,
      onSurfaceVariant: Color(0xFFB8B8C5),
      outline: Color(0x3DFFFFFF),
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: AppColors.moonWhite,
      onInverseSurface: AppColors.deepNavy,
      inversePrimary: AppColors.deepNavy,
      tertiary: AppColors.mistBlue,
      onTertiary: AppColors.moonWhite,
    );

    final ThemeData base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.deepNavy,
    );

    final TextTheme textTheme = base.textTheme.copyWith(
      displayLarge: base.textTheme.displayLarge?.copyWith(
        color: AppColors.moonWhite,
        fontWeight: FontWeight.w600,
        letterSpacing: -1.4,
        height: 1.05,
      ),
      displayMedium: base.textTheme.displayMedium?.copyWith(
        color: AppColors.moonWhite,
        fontWeight: FontWeight.w600,
        letterSpacing: -1,
      ),
      headlineLarge: base.textTheme.headlineLarge?.copyWith(
        color: AppColors.moonWhite,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.8,
      ),
      headlineMedium: base.textTheme.headlineMedium?.copyWith(
        color: AppColors.moonWhite,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: base.textTheme.titleLarge?.copyWith(
        color: AppColors.moonWhite,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: base.textTheme.titleMedium?.copyWith(
        color: AppColors.moonWhite,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: base.textTheme.bodyLarge?.copyWith(
        color: AppColors.moonWhite.withValues(alpha: 0.92),
        height: 1.5,
      ),
      bodyMedium: base.textTheme.bodyMedium?.copyWith(
        color: AppColors.moonWhite.withValues(alpha: 0.78),
        height: 1.45,
      ),
      bodySmall: base.textTheme.bodySmall?.copyWith(
        color: AppColors.moonWhite.withValues(alpha: 0.64),
        letterSpacing: 0.2,
      ),
      labelLarge: base.textTheme.labelLarge?.copyWith(
        color: AppColors.moonWhite,
        fontWeight: FontWeight.w600,
      ),
    );

    return base.copyWith(
      textTheme: textTheme,
      dividerColor: Colors.white.withValues(alpha: 0.06),
      splashColor: Colors.white.withValues(alpha: 0.05),
      highlightColor: Colors.white.withValues(alpha: 0.03),
      cardColor: Colors.white.withValues(alpha: 0.08),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.midnightBlue.withValues(alpha: 0.96),
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: AppColors.moonWhite,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        behavior: SnackBarBehavior.floating,
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.warmBeige,
        inactiveTrackColor: Colors.white.withValues(alpha: 0.14),
        thumbColor: AppColors.moonWhite,
        overlayColor: AppColors.warmBeige.withValues(alpha: 0.12),
        trackHeight: 4,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.transparent,
        modalBackgroundColor: Colors.transparent,
      ),
    );
  }
}
