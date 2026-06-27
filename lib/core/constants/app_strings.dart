import 'package:flutter/material.dart';

class AppStrings {
  const AppStrings._();

  static const String appName = 'Midnight Room';
  static const String premiumPrice = '¥490 / month';
  static const String premiumCta = 'Start Free Trial';
  static const String premiumTitle = 'Unlock Your Peaceful Universe';

  static const List<String> _months = <String>[
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  static const List<String> _weekdays = <String>[
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  static String formatLongDate(DateTime date) {
    final String month = _months[date.month - 1];
    final String weekday = _weekdays[date.weekday - 1];
    return '$weekday, $month ${date.day}';
  }

  static String formatMonthDay(DateTime date) {
    final String month = _months[date.month - 1];
    return '$month ${date.day}';
  }

  static String formatTimeOfDay(TimeOfDay timeOfDay) {
    final int hour = timeOfDay.hourOfPeriod == 0 ? 12 : timeOfDay.hourOfPeriod;
    final String minute = timeOfDay.minute.toString().padLeft(2, '0');
    final String period = timeOfDay.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }
}
