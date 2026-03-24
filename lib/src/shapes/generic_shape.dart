import 'package:flutter/material.dart';

/// Simple circle.
/// SVG ref: viewBox 0 0 80 80; circle center (40,40) r=30.
void paintGenericIcon(Canvas canvas, Rect bounds, Color stroke, Color fill) {
  final w = bounds.width;
  final h = bounds.height;
  final l = bounds.left;
  final t = bounds.top;

  final center = Offset(l + w * 0.5, t + h * 0.5);
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
}
