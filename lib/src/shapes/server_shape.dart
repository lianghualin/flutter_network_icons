import 'package:flutter/material.dart';

/// 3 stacked rounded rectangles (rack units) each with an LED dot.
/// SVG ref: viewBox 0 0 80 80; units at y=14-30, 32-48, 50-66; x=12..68; LED dots at (25, center_y) r=3.
void paintServerIcon(Canvas canvas, Rect bounds, Color stroke, Color fill) {
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

  final ledPaint = Paint()
    ..color = stroke
    ..style = PaintingStyle.fill;

  final ledRadius = w * (3.0 / 80);

  // Rack unit positions: top-y, bottom-y, LED center-y
  final units = [
    (14.0, 30.0, 22.0),
    (32.0, 48.0, 40.0),
    (50.0, 66.0, 58.0),
  ];

  for (final (top_, bottom, ledY) in units) {
    final rect = Rect.fromLTRB(x(12), y(top_), x(68), y(bottom));
    canvas.drawRect(rect, fillPaint);
    canvas.drawRect(rect, strokePaint);

    // LED dot
    canvas.drawCircle(Offset(x(25), y(ledY)), ledRadius, ledPaint);
  }
}
