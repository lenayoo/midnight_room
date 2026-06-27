import 'dart:math' as math;

import 'package:flutter/material.dart';

class SoftRevealText extends StatelessWidget {
  const SoftRevealText({
    required this.text,
    required this.progress,
    required this.start,
    required this.end,
    this.style,
    super.key,
  });

  final String text;
  final double progress;
  final double start;
  final double end;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final TextStyle baseStyle = style ?? DefaultTextStyle.of(context).style;
    final Color baseColor =
        baseStyle.color ?? Theme.of(context).colorScheme.onSurface;
    final List<String> characters = text.characters.toList(growable: false);
    final double lineProgress = intervalValue(progress, start, end);
    final double revealProgress = lineProgress * characters.length;

    return Text.rich(
      TextSpan(
        children: List<InlineSpan>.generate(characters.length, (int index) {
          final String character = characters[index];
          final bool isWhitespace = character.trim().isEmpty;
          final double charProgress = (revealProgress - index).clamp(0.0, 1.0);
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

class SoftRevealDivider extends StatelessWidget {
  const SoftRevealDivider({
    required this.width,
    required this.progress,
    required this.start,
    required this.end,
    super.key,
  });

  final double width;
  final double progress;
  final double start;
  final double end;

  @override
  Widget build(BuildContext context) {
    final double revealProgress = intervalValue(progress, start, end);

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: width * revealProgress,
        height: 1,
        color: Theme.of(
          context,
        ).colorScheme.onSurface.withValues(alpha: 0.32 * revealProgress),
      ),
    );
  }
}

double intervalValue(double progress, double start, double end) {
  final double clampedStart = math.max(0, math.min(1, start));
  final double clampedEnd = math.max(clampedStart + 0.001, math.min(1, end));

  return Interval(
    clampedStart,
    clampedEnd,
    curve: Curves.easeOutSine,
  ).transform(progress);
}
