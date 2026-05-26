import '../models/timer_session.dart';

final List<TimerSession> mockTimerHistory = <TimerSession>[
  TimerSession(
    id: 'session_1',
    mode: 'Focus',
    durationMinutes: 25,
    completedAt: DateTime(2026, 5, 21, 21, 15),
    soundId: 'midnight_rain',
  ),
  TimerSession(
    id: 'session_2',
    mode: 'Short Break',
    durationMinutes: 5,
    completedAt: DateTime(2026, 5, 21, 21, 45),
    soundId: 'quiet_cafe',
  ),
  TimerSession(
    id: 'session_3',
    mode: 'Focus',
    durationMinutes: 25,
    completedAt: DateTime(2026, 5, 20, 23, 10),
    soundId: 'night_train',
  ),
];
