import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData build([Locale locale = const Locale('en')]) {
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

    final TextTheme localizedBodyTextTheme = _bodyTextTheme(
      locale,
      base.textTheme,
    );

    final TextTheme textTheme = localizedBodyTextTheme.copyWith(
      displayLarge: _displayFont(
        locale,
        localizedBodyTextTheme.displayLarge?.copyWith(
          color: AppColors.moonWhite,
          fontWeight: FontWeight.w600,
          letterSpacing: -1.4,
          height: 1.05,
        ),
      ),
      displayMedium: _displayFont(
        locale,
        localizedBodyTextTheme.displayMedium?.copyWith(
          color: AppColors.moonWhite,
          fontWeight: FontWeight.w600,
          letterSpacing: -1,
        ),
      ),
      headlineLarge: _displayFont(
        locale,
        localizedBodyTextTheme.headlineLarge?.copyWith(
          color: AppColors.moonWhite,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.8,
        ),
      ),
      headlineMedium: _displayFont(
        locale,
        localizedBodyTextTheme.headlineMedium?.copyWith(
          color: AppColors.moonWhite,
          fontWeight: FontWeight.w600,
        ),
      ),
      headlineSmall: _displayFont(
        locale,
        localizedBodyTextTheme.headlineSmall?.copyWith(
          color: AppColors.moonWhite,
          fontWeight: FontWeight.w600,
        ),
      ),
      titleLarge: _bodyFont(
        locale,
        localizedBodyTextTheme.titleLarge?.copyWith(
          color: AppColors.moonWhite,
          fontWeight: FontWeight.w600,
        ),
      ),
      titleMedium: _bodyFont(
        locale,
        localizedBodyTextTheme.titleMedium?.copyWith(
          color: AppColors.moonWhite,
          fontWeight: FontWeight.w600,
        ),
      ),
      bodyLarge: _bodyFont(
        locale,
        localizedBodyTextTheme.bodyLarge?.copyWith(
          color: AppColors.moonWhite.withValues(alpha: 0.92),
          height: 1.5,
        ),
      ),
      bodyMedium: _bodyFont(
        locale,
        localizedBodyTextTheme.bodyMedium?.copyWith(
          color: AppColors.moonWhite.withValues(alpha: 0.78),
          height: 1.45,
        ),
      ),
      bodySmall: _bodyFont(
        locale,
        localizedBodyTextTheme.bodySmall?.copyWith(
          color: AppColors.moonWhite.withValues(alpha: 0.64),
          letterSpacing: 0.2,
        ),
      ),
      labelLarge: _bodyFont(
        locale,
        localizedBodyTextTheme.labelLarge?.copyWith(
          color: AppColors.moonWhite,
          fontWeight: FontWeight.w600,
        ),
      ),
      labelMedium: _bodyFont(
        locale,
        localizedBodyTextTheme.labelMedium?.copyWith(
          color: AppColors.moonWhite,
          fontWeight: FontWeight.w600,
        ),
      ),
    );

    return base.copyWith(
      textTheme: textTheme,
      primaryTextTheme: _bodyTextTheme(locale, base.primaryTextTheme),
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

  static TextTheme _bodyTextTheme(Locale locale, TextTheme baseTextTheme) {
    switch (_languageCode(locale)) {
      case 'ja':
        return GoogleFonts.zenKakuGothicNewTextTheme(baseTextTheme);
      case 'ko':
        return GoogleFonts.gowunDodumTextTheme(baseTextTheme);
      default:
        return GoogleFonts.manropeTextTheme(baseTextTheme);
    }
  }

  static TextStyle? _displayFont(Locale locale, TextStyle? textStyle) {
    if (textStyle == null) {
      return null;
    }

    switch (_languageCode(locale)) {
      case 'ja':
        return GoogleFonts.zenKakuGothicNew(textStyle: textStyle);
      case 'ko':
        return GoogleFonts.gowunDodum(textStyle: textStyle);
      default:
        return GoogleFonts.cormorantGaramond(textStyle: textStyle);
    }
  }

  static TextStyle? _bodyFont(Locale locale, TextStyle? textStyle) {
    if (textStyle == null) {
      return null;
    }

    switch (_languageCode(locale)) {
      case 'ja':
        return GoogleFonts.zenKakuGothicNew(textStyle: textStyle);
      case 'ko':
        return GoogleFonts.gowunDodum(textStyle: textStyle);
      default:
        return GoogleFonts.manrope(textStyle: textStyle);
    }
  }

  static String _languageCode(Locale locale) {
    switch (locale.languageCode) {
      case 'ja':
      case 'ko':
        return locale.languageCode;
      default:
        return 'en';
    }
  }
}
