import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class FloatingSparkles extends StatefulWidget {
  const FloatingSparkles({super.key});

  @override
  State<FloatingSparkles> createState() => _FloatingSparklesState();
}

class _FloatingSparklesState extends State<FloatingSparkles>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, _) {
          return CustomPaint(
            painter: _FloatingSparklesPainter(progress: _controller.value),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

class _FloatingSparklesPainter extends CustomPainter {
  _FloatingSparklesPainter({required this.progress});

  final double progress;

  static const List<_SparkleSpec> _sparkles = <_SparkleSpec>[
    _SparkleSpec(0.12, 0.18, 5.5, 0.9, 0.2),
    _SparkleSpec(0.24, 0.34, 4.5, 0.7, 1.1),
    _SparkleSpec(0.36, 0.12, 4, 0.8, 2.3),
    _SparkleSpec(0.58, 0.24, 5, 1.0, 3.6),
    _SparkleSpec(0.73, 0.16, 4.5, 0.75, 4.1),
    _SparkleSpec(0.84, 0.3, 5.2, 0.85, 5.4),
    _SparkleSpec(0.2, 0.62, 4.2, 0.95, 1.8),
    _SparkleSpec(0.44, 0.74, 5.1, 0.8, 2.7),
    _SparkleSpec(0.67, 0.66, 4.6, 0.9, 4.8),
    _SparkleSpec(0.88, 0.78, 5.4, 0.7, 5.9),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    for (final _SparkleSpec sparkle in _sparkles) {
      final double angle = progress * math.pi * 2 + sparkle.phase;
      final double dx = sparkle.dx + math.sin(angle) * 0.018 * sparkle.drift;
      final double dy =
          sparkle.dy + math.cos(angle * 0.82) * 0.024 * sparkle.drift;
      final Offset center = Offset(dx * size.width, dy * size.height);
      final double shimmer =
          0.35 + 0.65 * (0.5 + 0.5 * math.sin(angle * 1.4 + sparkle.phase));
      final double glowOpacity = 0.08 + 0.1 * shimmer;
      final double strokeOpacity = 0.14 + 0.18 * shimmer;

      final Paint glowPaint =
          Paint()
            ..color = AppColors.moonWhite.withValues(alpha: glowOpacity)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
      canvas.drawCircle(center, sparkle.size * 1.2, glowPaint);

      final Paint linePaint =
          Paint()
            ..color = AppColors.moonWhite.withValues(alpha: strokeOpacity)
            ..strokeWidth = 1.2
            ..strokeCap = StrokeCap.round;

      final double radius = sparkle.size * (0.7 + shimmer * 0.4);
      canvas.drawLine(
        Offset(center.dx - radius, center.dy),
        Offset(center.dx + radius, center.dy),
        linePaint,
      );
      canvas.drawLine(
        Offset(center.dx, center.dy - radius),
        Offset(center.dx, center.dy + radius),
        linePaint,
      );

      final Paint corePaint =
          Paint()
            ..color = AppColors.warmBeige.withValues(
              alpha: 0.22 + 0.16 * shimmer,
            );
      canvas.drawCircle(center, 1.1, corePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _FloatingSparklesPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class _SparkleSpec {
  const _SparkleSpec(this.dx, this.dy, this.size, this.drift, this.phase);

  final double dx;
  final double dy;
  final double size;
  final double drift;
  final double phase;
}
