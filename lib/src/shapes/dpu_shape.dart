import 'package:flutter/material.dart';

/// Vertical rack unit with LED dots, divider line, and two port squares.
/// SVG ref: viewBox 0 0 80 80; body 22,8->58,72; LEDs at y=16,24,32; divider at y=44; ports 28-38 and 42-52 at y=50-58.
void paintDpuIcon(Canvas canvas, Rect bounds, Color stroke, Color fill) {
  final w = bounds.width;
  final h = bounds.height;
  final l = bounds.left;
  final t = bounds.top;

  double x(double svgX) => l + (svgX / 80) * w;
  double y(double svgY) => t + (svgY / 80) * h;

  final strokePaint = Paint()
    ..color = stroke
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2
    ..strokeJoin = StrokeJoin.round;

  final fillPaint = Paint()
    ..color = fill
    ..style = PaintingStyle.fill;

  // DPU rack body
  final body = Rect.fromLTRB(x(22), y(8), x(58), y(72));
  canvas.drawRect(body, fillPaint);
  canvas.drawRect(body, strokePaint);

  // LED indicators (small filled circles)
  final ledPaint = Paint()
    ..color = stroke
    ..style = PaintingStyle.fill;

  final ledRadius = w * (2.0 / 80);
  canvas.drawCircle(Offset(x(30), y(16)), ledRadius, ledPaint);
  canvas.drawCircle(Offset(x(30), y(24)), ledRadius, ledPaint);
  canvas.drawCircle(Offset(x(30), y(32)), ledRadius, ledPaint);

  // Divider line
  canvas.drawLine(
    Offset(x(22), y(44)),
    Offset(x(58), y(44)),
    Paint()
      ..color = stroke
      ..strokeWidth = 1.5,
  );

  // Port squares (semi-transparent)
  final portPaint = Paint()
    ..color = stroke.withValues(alpha: 0.3)
    ..style = PaintingStyle.fill;

  canvas.drawRect(Rect.fromLTRB(x(28), y(50), x(38), y(58)), portPaint);
  canvas.drawRect(Rect.fromLTRB(x(42), y(50), x(52), y(58)), portPaint);
}
