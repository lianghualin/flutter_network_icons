import 'package:flutter/material.dart';

/// Circle with a question mark drawn as a path (not text).
/// SVG ref: viewBox 0 0 80 80; circle center (40,40) r=30;
/// ? curve from (32,30) through (40,20)-(48,28) to (40,42); dot at (40,53) r=3.
void paintUnknownIcon(Canvas canvas, Rect bounds, Color stroke, Color fill) {
  final w = bounds.width;
  final h = bounds.height;
  final l = bounds.left;
  final t = bounds.top;

  double x(double svgX) => l + (svgX / 80) * w;
  double y(double svgY) => t + (svgY / 80) * h;

  // Outer circle
  final center = Offset(x(40), y(40));
  final radius = w * (30.0 / 80);

  canvas.drawCircle(
    center,
    radius,
    Paint()
      ..color = fill
      ..style = PaintingStyle.fill,
  );
  canvas.drawCircle(
    center,
    radius,
    Paint()
      ..color = stroke
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2,
  );

  // Question mark curve (drawn as path, not text)
  // SVG: M32 30 C32 24 36 20 40 20 C44 20 48 24 48 28 C48 32 45 34 42 35 C41 35.5 40 36.5 40 38 L40 42
  final questionCurve = Path()
    ..moveTo(x(32), y(30))
    ..cubicTo(x(32), y(24), x(36), y(20), x(40), y(20))
    ..cubicTo(x(44), y(20), x(48), y(24), x(48), y(28))
    ..cubicTo(x(48), y(32), x(45), y(34), x(42), y(35))
    ..cubicTo(x(41), y(35.5), x(40), y(36.5), x(40), y(38))
    ..lineTo(x(40), y(42));

  canvas.drawPath(
    questionCurve,
    Paint()
      ..color = stroke
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round,
  );

  // Question mark dot
  final dotRadius = w * (3.0 / 80);
  canvas.drawCircle(
    Offset(x(40), y(53)),
    dotRadius,
    Paint()
      ..color = stroke
      ..style = PaintingStyle.fill,
  );
}
