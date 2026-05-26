import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/widgets/ambient_background.dart';
import '../../../../core/widgets/fade_slide_in.dart';
import '../../../../core/widgets/glass_panel.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../../data/models/sound_item.dart';
import '../../../premium/presentation/widgets/premium_gate.dart';
import '../widgets/timer_ring.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({
    required this.currentSound,
    required this.isPremium,
    required this.onOpenPremium,
    super.key,
  });

  final SoundItem currentSound;
  final bool isPremium;
  final VoidCallback onOpenPremium;

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  static const List<_ModeOption> _modes = <_ModeOption>[
    _ModeOption(label: 'Focus', minutes: 25, subtitle: 'Deep work room'),
    _ModeOption(
      label: 'Short Break',
      minutes: 5,
      subtitle: 'Breathe and reset',
    ),
    _ModeOption(label: 'Long Break', minutes: 15, subtitle: 'Slow body reset'),
    _ModeOption(
      label: 'Sleep Timer',
      minutes: 45,
      subtitle: 'Premium night drift',
      isPremium: true,
    ),
  ];

  Timer? _ticker;
  _ModeOption _selectedMode = _modes.first;
  late Duration _remaining = Duration(minutes: _selectedMode.minutes);
  bool _isRunning = false;
  int _completedSessions = 6;

  Duration get _totalDuration => Duration(minutes: _selectedMode.minutes);

  double get _progress {
    final int totalSeconds = _totalDuration.inSeconds;
    if (totalSeconds == 0) {
      return 0;
    }

    return (_remaining.inSeconds / totalSeconds).clamp(0, 1);
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  void _selectMode(_ModeOption mode) {
    if (mode.isPremium && !widget.isPremium) {
      widget.onOpenPremium();
      return;
    }

    setState(() {
      _selectedMode = mode;
      _remaining = Duration(minutes: mode.minutes);
      _isRunning = false;
    });
    _ticker?.cancel();
  }

  void _toggleTimer() {
    if (_isRunning) {
      _ticker?.cancel();
      setState(() {
        _isRunning = false;
      });
      return;
    }

    setState(() {
      _isRunning = true;
    });

    _ticker = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (_remaining.inSeconds <= 1) {
        timer.cancel();
        setState(() {
          _remaining = Duration(minutes: _selectedMode.minutes);
          _isRunning = false;
          _completedSessions += 1;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Session complete. Gentle notification hook is ready.',
            ),
          ),
        );
        return;
      }

      setState(() {
        _remaining -= const Duration(seconds: 1);
      });
    });
  }

  void _resetTimer() {
    _ticker?.cancel();
    setState(() {
      _remaining = Duration(minutes: _selectedMode.minutes);
      _isRunning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return AmbientBackground(
      gradient: AppGradients.screenBackground(1),
      primaryOrbColors: const <Color>[Color(0x44D9B99B), Color(0x0011182E)],
      secondaryOrbColors: const <Color>[Color(0x332D4F50), Color(0x0011182E)],
      child: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 140),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              FadeSlideIn(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Pomodoro Room',
                      style: textTheme.bodySmall?.copyWith(letterSpacing: 1.5),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Minimal focus, wrapped in warmth.',
                      style: textTheme.displayMedium,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'The timer is real enough for prototype use, while notifications stay service-ready only.',
                      style: textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              FadeSlideIn(
                delay: const Duration(milliseconds: 120),
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children:
                      _modes.map((_ModeOption mode) {
                        final bool isSelected =
                            mode.label == _selectedMode.label;
                        final bool isLocked =
                            mode.isPremium && !widget.isPremium;

                        return GestureDetector(
                          onTap: () => _selectMode(mode),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 220),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(999),
                              color:
                                  isSelected
                                      ? AppColors.moonWhite.withValues(
                                        alpha: 0.14,
                                      )
                                      : Colors.white.withValues(alpha: 0.05),
                              border: Border.all(
                                color:
                                    isSelected
                                        ? AppColors.moonWhite.withValues(
                                          alpha: 0.22,
                                        )
                                        : Colors.white.withValues(alpha: 0.08),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                if (isLocked)
                                  Padding(
                                    padding: const EdgeInsets.only(right: 6),
                                    child: Icon(
                                      Icons.lock_rounded,
                                      size: 15,
                                      color: Colors.white.withValues(
                                        alpha: 0.72,
                                      ),
                                    ),
                                  ),
                                Text(mode.label, style: textTheme.bodySmall),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ),
              const SizedBox(height: 28),
              FadeSlideIn(
                delay: const Duration(milliseconds: 180),
                child: Center(
                  child: TimerRing(
                    progress: _progress,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          _formatDuration(_remaining),
                          style: textTheme.displayLarge,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _selectedMode.subtitle,
                          style: textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 18),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(999),
                            color: Colors.white.withValues(alpha: 0.08),
                          ),
                          child: Text(
                            widget.currentSound.title,
                            style: textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 26),
              FadeSlideIn(
                delay: const Duration(milliseconds: 240),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: FilledButton(
                        onPressed: _toggleTimer,
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          backgroundColor: AppColors.moonWhite,
                          foregroundColor: AppColors.deepNavy,
                        ),
                        child: Text(
                          _isRunning ? 'Pause Session' : 'Start Session',
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    IconButton.filledTonal(
                      onPressed: _resetTimer,
                      style: IconButton.styleFrom(
                        padding: const EdgeInsets.all(18),
                        backgroundColor: Colors.white.withValues(alpha: 0.1),
                      ),
                      icon: const Icon(Icons.refresh_rounded),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 26),
              FadeSlideIn(
                delay: const Duration(milliseconds: 300),
                child: const SectionHeader(
                  title: 'Tonight’s Ritual',
                  actionLabel: 'Soft metrics',
                ),
              ),
              const SizedBox(height: 14),
              FadeSlideIn(
                delay: const Duration(milliseconds: 340),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: _MetricCard(
                        label: 'Sessions',
                        value: '$_completedSessions',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _MetricCard(
                        label: 'Current sound',
                        value: widget.currentSound.category,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              FadeSlideIn(
                delay: const Duration(milliseconds: 380),
                child: PremiumGate(
                  isPremium: widget.isPremium,
                  onUnlock: widget.onOpenPremium,
                  title: 'Advanced Pomodoro controls',
                  subtitle:
                      'Sleep timer, custom intervals, and extended focus history belong here.',
                  child: GlassPanel(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Premium timer tools',
                          style: textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Prepare endless sessions, deeper interval presets, and bedtime fades without changing the screen layout later.',
                          style: textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 18),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                'Sleep timer · Focus reminder · Unlimited history',
                                style: textTheme.bodySmall,
                              ),
                            ),
                            const SizedBox(width: 12),
                            FilledButton(
                              onPressed: widget.onOpenPremium,
                              child: const Text('Preview'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final String minutes = duration.inMinutes
        .remainder(60)
        .toString()
        .padLeft(2, '0');
    final String seconds = duration.inSeconds
        .remainder(60)
        .toString()
        .padLeft(2, '0');
    return '$minutes:$seconds';
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      padding: const EdgeInsets.all(18),
      borderRadius: const BorderRadius.all(Radius.circular(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 8),
          Text(value, style: Theme.of(context).textTheme.headlineMedium),
        ],
      ),
    );
  }
}

class _ModeOption {
  const _ModeOption({
    required this.label,
    required this.minutes,
    required this.subtitle,
    this.isPremium = false,
  });

  final String label;
  final int minutes;
  final String subtitle;
  final bool isPremium;
}
