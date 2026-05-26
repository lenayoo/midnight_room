import 'dart:math' as math;

import 'package:flutter/material.dart';

class TimerRing extends StatelessWidget {
  const TimerRing({required this.progress, required this.child, super.key});

  final double progress;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 290,
      height: 290,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          CustomPaint(
            size: const Size.square(290),
            painter: _TimerRingPainter(progress: progress),
          ),
          child,
        ],
      ),
    );
  }
}

class _TimerRingPainter extends CustomPainter {
  const _TimerRingPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = size.center(Offset.zero);
    final double radius = size.width / 2;

    final Paint background =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 16
          ..color = Colors.white.withValues(alpha: 0.08);

    final Paint glow =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 20
          ..strokeCap = StrokeCap.round
          ..shader = const SweepGradient(
            colors: <Color>[
              Color(0x00F4EDE3),
              Color(0x88F4EDE3),
              Color(0x00B98299),
            ],
          ).createShader(Offset.zero & size);

    final Paint foreground =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 12
          ..strokeCap = StrokeCap.round
          ..shader = const SweepGradient(
            startAngle: -math.pi / 2,
            endAngle: math.pi * 1.5,
            colors: <Color>[
              Color(0xFFF4EDE3),
              Color(0xFFD9B99B),
              Color(0xFFB98299),
            ],
          ).createShader(Offset.zero & size);

    canvas.drawCircle(center, radius - 12, background);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 12),
      -math.pi / 2,
      math.pi * 2 * progress,
      false,
      glow,
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 12),
      -math.pi / 2,
      math.pi * 2 * progress,
      false,
      foreground,
    );
  }

  @override
  bool shouldRepaint(covariant _TimerRingPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
