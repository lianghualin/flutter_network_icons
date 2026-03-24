import 'package:flutter/material.dart';

/// Monitor with screen area, stand neck, and base.
/// SVG ref: viewBox 0 0 80 80; screen 14,16->66,50; bezel 19,21->61,45; neck 36,50->44,58; base 26,58->54,64.
void paintHostIcon(Canvas canvas, Rect bounds, Color stroke, Color fill) {
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

  // Monitor screen
  final screen = Rect.fromLTRB(x(14), y(16), x(66), y(50));
  canvas.drawRect(screen, fillPaint);
  canvas.drawRect(screen, strokePaint);

  // Screen inner bezel (semi-transparent stroke color)
  final bezel = Rect.fromLTRB(x(19), y(21), x(61), y(45));
  canvas.drawRect(
    bezel,
    Paint()
      ..color = stroke.withValues(alpha: 0.15)
      ..style = PaintingStyle.fill,
  );

  // Stand neck
  final neck = Rect.fromLTRB(x(36), y(50), x(44), y(58));
  canvas.drawRect(neck, fillPaint);
  canvas.drawRect(neck, strokePaint);

  // Stand base
  final base = Rect.fromLTRB(x(26), y(58), x(54), y(64));
  canvas.drawRect(base, fillPaint);
  canvas.drawRect(base, strokePaint);
}
