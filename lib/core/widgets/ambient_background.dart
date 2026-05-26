import 'dart:ui';

import 'package:flutter/material.dart';

class AmbientBackground extends StatelessWidget {
  const AmbientBackground({
    required this.child,
    required this.gradient,
    this.primaryOrbColors = const <Color>[Color(0x66F4EDE3), Color(0x00F4EDE3)],
    this.secondaryOrbColors = const <Color>[
      Color(0x33B98299),
      Color(0x003A335C),
    ],
    this.primaryAlignment = const Alignment(0.85, -0.9),
    this.secondaryAlignment = const Alignment(-0.9, 0.2),
    super.key,
  });

  final Widget child;
  final Gradient gradient;
  final List<Color> primaryOrbColors;
  final List<Color> secondaryOrbColors;
  final Alignment primaryAlignment;
  final Alignment secondaryAlignment;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(gradient: gradient),
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: IgnorePointer(
              child: Stack(
                children: <Widget>[
                  _BlurredOrb(
                    alignment: primaryAlignment,
                    size: 240,
                    colors: primaryOrbColors,
                  ),
                  _BlurredOrb(
                    alignment: secondaryAlignment,
                    size: 320,
                    colors: secondaryOrbColors,
                  ),
                  const _Starfield(),
                ],
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class _BlurredOrb extends StatelessWidget {
  const _BlurredOrb({
    required this.alignment,
    required this.size,
    required this.colors,
  });

  final Alignment alignment;
  final double size;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: 54, sigmaY: 54),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(colors: colors),
          ),
        ),
      ),
    );
  }
}

class _Starfield extends StatelessWidget {
  const _Starfield();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(painter: _StarfieldPainter(), size: Size.infinite),
    );
  }
}

class _StarfieldPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = Colors.white.withValues(alpha: 0.1);
    const List<Offset> points = <Offset>[
      Offset(0.14, 0.18),
      Offset(0.22, 0.32),
      Offset(0.78, 0.24),
      Offset(0.84, 0.41),
      Offset(0.68, 0.14),
      Offset(0.11, 0.72),
      Offset(0.27, 0.86),
      Offset(0.74, 0.8),
      Offset(0.58, 0.68),
    ];

    for (final Offset point in points) {
      canvas.drawCircle(
        Offset(point.dx * size.width, point.dy * size.height),
        1.4,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
