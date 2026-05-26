class DailyQuoteNotification {
  const DailyQuoteNotification({
    required this.title,
    required this.body,
    required this.scheduledAt,
  });

  final String title;
  final String body;
  final DateTime scheduledAt;
}
