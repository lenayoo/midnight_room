import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../data/models/quote_item.dart';
import '../models/daily_quote_notification.dart';
import 'notification_service.dart';

class QuoteScheduler {
  const QuoteScheduler(this._notificationService);

  final NotificationService _notificationService;

  Future<void> scheduleQuote({
    required QuoteItem quote,
    required TimeOfDay timeOfDay,
  }) async {
    final DateTime scheduledAt = DateTime(
      quote.date.year,
      quote.date.month,
      quote.date.day,
      timeOfDay.hour,
      timeOfDay.minute,
    );

    final DailyQuoteNotification notification = DailyQuoteNotification(
      title: AppStrings.appName,
      body: 'Today’s Quote\n"${quote.text}"',
      scheduledAt: scheduledAt,
    );

    await _notificationService.scheduleDailyQuote(notification);
  }
}
