import 'package:flutter/material.dart';

/// Shield shape with cross lines (horizontal + vertical).
/// SVG ref: viewBox 0 0 80 80; shield from (40,8) top, sides to (66,20)-(66,42) curving to (40,74) bottom.
/// Cross: horizontal at y=38 from x=22..58; vertical at x=40 from y=18..62.
void paintFirewallIcon(Canvas canvas, Rect bounds, Color stroke, Color fill) {
  final w = bounds.width;
  final h = bounds.height;
  final l = bounds.left;
  final t = bounds.top;

  double x(double svgX) => l + (svgX / 80) * w;
  double y(double svgY) => t + (svgY / 80) * h;

  // Shield shape
  final shield = Path()
    ..moveTo(x(40), y(8))
    ..lineTo(x(66), y(20))
    ..lineTo(x(66), y(42))
    ..cubicTo(x(66), y(58), x(54), y(68), x(40), y(74))
    ..cubicTo(x(26), y(68), x(14), y(58), x(14), y(42))
    ..lineTo(x(14), y(20))
    ..close();

  canvas.drawPath(
    shield,
    Paint()
      ..color = fill
      ..style = PaintingStyle.fill,
  );
  canvas.drawPath(
    shield,
    Paint()
      ..color = stroke
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeJoin = StrokeJoin.round,
  );

  // Horizontal cross line
  final crossPaint = Paint()
    ..color = stroke
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2;

  canvas.drawLine(Offset(x(22), y(38)), Offset(x(58), y(38)), crossPaint);

  // Vertical cross line
  canvas.drawLine(Offset(x(40), y(18)), Offset(x(40), y(62)), crossPaint);
}
