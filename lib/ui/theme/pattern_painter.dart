import 'package:flutter/material.dart';

class PatternPainter extends CustomPainter {
  PatternPainter({required this.offset});

  final double offset;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.04)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final double spacing = 160;
    final double radius = 120;

    for (double y = -radius; y < size.height + radius; y += spacing) {
      for (double x = -radius; x < size.width + radius; x += spacing) {
        final center = Offset(x + offset * 0.03, y - offset * 0.02);
        final rect = Rect.fromCircle(center: center, radius: radius);
        final startAngle = (x / spacing + y / spacing) % 2 == 0 ? 0.0 : 3.14;
        canvas.drawArc(rect, startAngle, 3.14, false, paint);
      }
    }

    final accentPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = Colors.white.withOpacity(0.06);

    final path = Path()
      ..moveTo(-offset * 0.02, size.height * 0.7)
      ..cubicTo(
        size.width * 0.2,
        size.height * 0.5,
        size.width * 0.6,
        size.height * 0.9,
        size.width * 1.05,
        size.height * 0.6,
      );

    canvas.drawPath(path, accentPaint);
  }

  @override
  bool shouldRepaint(covariant PatternPainter oldDelegate) {
    return oldDelegate.offset != offset;
  }
}
