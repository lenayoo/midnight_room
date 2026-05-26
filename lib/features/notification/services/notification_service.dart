import '../models/daily_quote_notification.dart';

class NotificationService {
  Future<void> initialize() async {
    // TODO(lenayoo): Wire platform notification plugins when real notifications are enabled.
  }

  Future<bool> requestPermission() async {
    // TODO(lenayoo): Request platform permission when the notification stack is implemented.
    return false;
  }

  Future<void> scheduleDailyQuote(DailyQuoteNotification notification) async {
    // TODO(lenayoo): Persist and schedule the notification with timezone-safe platform APIs.
    final DailyQuoteNotification _ = notification;
  }

  Future<void> cancelDailyQuote() async {
    // TODO(lenayoo): Cancel scheduled quote notification once a real implementation exists.
  }
}
