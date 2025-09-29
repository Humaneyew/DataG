import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'tokens.dart';

class PatternPainter extends CustomPainter {
  PatternPainter({required this.offset});

  final Offset offset;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = AppColors.textPrimary.withOpacity(0.04);

    final diagonal = math.sqrt(size.width * size.width + size.height * size.height);
    final step = 140.0;

    for (double d = -diagonal; d < diagonal; d += step) {
      final dy = d + offset.dy * 0.4;
      final path = Path()
        ..moveTo(-size.height, dy)
        ..quadraticBezierTo(
          size.width * 0.25,
          dy - 32,
          size.width * 0.5,
          dy,
        )
        ..quadraticBezierTo(
          size.width * 0.75,
          dy + 32,
          size.width + size.height,
          dy,
        );
      canvas.drawPath(path, paint);
    }

    final circlePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..color = AppColors.textPrimary.withOpacity(0.05);

    final random = math.Random(42);
    for (int i = 0; i < 18; i++) {
      final radius = 24 + random.nextDouble() * 56;
      final dx = random.nextDouble() * size.width;
      final dy = random.nextDouble() * size.height;
      final shift = Offset(dx, dy) + offset * 0.05;
      canvas.drawCircle(shift, radius, circlePaint);
    }
  }

  @override
  bool shouldRepaint(covariant PatternPainter oldDelegate) {
    return oldDelegate.offset != offset;
  }
}
