import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  const AppTypography._();

  static TextStyle? brandTitle(TextStyle? textStyle) {
    if (textStyle == null) {
      return null;
    }

    return GoogleFonts.cormorantGaramond(textStyle: textStyle);
  }

  static TextStyle? launchName(String value, TextStyle? textStyle) {
    if (textStyle == null) {
      return null;
    }

    switch (_detectNameScript(value)) {
      case _NameScript.korean:
        return GoogleFonts.gowunDodum(textStyle: textStyle);
      case _NameScript.japanese:
        return GoogleFonts.yomogi(
          textStyle: textStyle.copyWith(fontWeight: FontWeight.w400),
        );
      case _NameScript.latin:
        return GoogleFonts.caveat(
          textStyle: textStyle.copyWith(fontWeight: FontWeight.w600),
        );
    }
  }

  static bool isKoreanName(String value) {
    return _detectNameScript(value) == _NameScript.korean;
  }

  static _NameScript _detectNameScript(String value) {
    if (_hangulRegex.hasMatch(value)) {
      return _NameScript.korean;
    }

    if (_japaneseRegex.hasMatch(value)) {
      return _NameScript.japanese;
    }

    return _NameScript.latin;
  }

  static final RegExp _hangulRegex = RegExp(
    r'[\u1100-\u11FF\u3130-\u318F\uAC00-\uD7AF]',
  );
  static final RegExp _japaneseRegex = RegExp(
    r'[\u3040-\u30FF\u31F0-\u31FF\u4E00-\u9FFF]',
  );
}

enum _NameScript { korean, japanese, latin }
