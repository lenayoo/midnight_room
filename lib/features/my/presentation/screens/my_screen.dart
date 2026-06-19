import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/quote_item.dart';
import '../../../../data/models/sound_item.dart';

class MyScreen extends StatefulWidget {
  const MyScreen({
    required this.savedQuotes,
    required this.favoriteSounds,
    this.isActive = true,
    super.key,
  });

  final List<QuoteItem> savedQuotes;
  final List<SoundItem> favoriteSounds;
  final bool isActive;

  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen>
    with SingleTickerProviderStateMixin {
  static const Duration _timelineDuration = Duration(milliseconds: 26000);

  late final AnimationController _timelineController;

  @override
  void initState() {
    super.initState();
    _timelineController = AnimationController(
      vsync: this,
      duration: _timelineDuration,
    );

    if (widget.isActive) {
      _timelineController.forward();
    }
  }

  @override
  void didUpdateWidget(covariant MyScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!oldWidget.isActive && widget.isActive) {
      _timelineController
        ..value = 0
        ..forward();
      return;
    }

    if (oldWidget.isActive && !widget.isActive) {
      _timelineController.value = 0;
    }
  }

  @override
  void dispose() {
    _timelineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return ColoredBox(
      color: Colors.black,
      child: SafeArea(
        bottom: false,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(28, 40, 28, 120),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: AnimatedBuilder(
                animation: _timelineController,
                builder: (BuildContext context, _) {
                  final double progress = _timelineController.value;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _SoftRevealText(
                        text: 'Midnight Room',
                        progress: progress,
                        start: 0.04,
                        end: 0.16,
                        style: textTheme.displayMedium?.copyWith(
                          color: AppColors.moonWhite,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 18),
                      _SoftRevealDivider(
                        width: 56,
                        progress: progress,
                        start: 0.18,
                        end: 0.24,
                      ),
                      const SizedBox(height: 24),
                      _SoftRevealText(
                        text:
                            'A safe little room for slowing down, softening the noise, and breathing again.',
                        progress: progress,
                        start: 0.28,
                        end: 0.6,
                        style: textTheme.bodyLarge?.copyWith(
                          color: AppColors.moonWhite.withValues(alpha: 0.9),
                          height: 1.7,
                        ),
                      ),
                      const SizedBox(height: 48),
                      _SoftRevealText(
                        text:
                            'Midnight Room stays quiet so your mind does not have to fight for stillness.',
                        progress: progress,
                        start: 0.64,
                        end: 0.88,
                        style: textTheme.bodyMedium?.copyWith(
                          color: AppColors.moonWhite.withValues(alpha: 0.62),
                        ),
                      ),
                      const SizedBox(height: 40),
                      _SoftRevealText(
                        text: 'Just breathe',
                        progress: progress,
                        start: 0.92,
                        end: 1,
                        style: textTheme.headlineMedium?.copyWith(
                          color: AppColors.warmBeige,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SoftRevealText extends StatelessWidget {
  const _SoftRevealText({
    required this.text,
    required this.progress,
    required this.start,
    required this.end,
    required this.style,
  });

  final String text;
  final double progress;
  final double start;
  final double end;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final TextStyle baseStyle =
        style ?? DefaultTextStyle.of(context).style;
    final Color baseColor =
        baseStyle.color ?? Theme.of(context).colorScheme.onSurface;
    final List<String> characters = text.characters.toList(growable: false);
    final double lineProgress = _intervalValue(progress, start, end);
    final double revealProgress = lineProgress * characters.length;

    return Text.rich(
      TextSpan(
        children: List<InlineSpan>.generate(characters.length, (int index) {
          final String character = characters[index];
          final bool isWhitespace = character.trim().isEmpty;
          final double charProgress =
              (revealProgress - index).clamp(0.0, 1.0);
          final double opacity =
              isWhitespace ? 1 : Curves.easeOutCubic.transform(charProgress);

          return TextSpan(
            text: character,
            style: baseStyle.copyWith(
              color: baseColor.withValues(alpha: opacity),
            ),
          );
        }),
      ),
      style: baseStyle,
      strutStyle: StrutStyle.fromTextStyle(baseStyle),
    );
  }
}

class _SoftRevealDivider extends StatelessWidget {
  const _SoftRevealDivider({
    required this.width,
    required this.progress,
    required this.start,
    required this.end,
  });

  final double width;
  final double progress;
  final double start;
  final double end;

  @override
  Widget build(BuildContext context) {
    final double revealProgress = _intervalValue(progress, start, end);

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: width * revealProgress,
        height: 1,
        color: AppColors.moonWhite.withValues(alpha: 0.32 * revealProgress),
      ),
    );
  }
}

double _intervalValue(double progress, double start, double end) {
  final double clampedStart = math.max(0, math.min(1, start));
  final double clampedEnd = math.max(clampedStart + 0.001, math.min(1, end));

  return Interval(
    clampedStart,
    clampedEnd,
    curve: Curves.easeOutSine,
  ).transform(progress);
}
