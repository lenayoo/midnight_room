class TimerSession {
  const TimerSession({
    required this.id,
    required this.mode,
    required this.durationMinutes,
    required this.completedAt,
    required this.soundId,
  });

  final String id;
  final String mode;
  final int durationMinutes;
  final DateTime completedAt;
  final String soundId;
}
