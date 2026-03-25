import 'package:flutter/material.dart';

/// Flat-style RJ45 Ethernet port.
/// SVG ref: viewBox 0 0 80 80.
void paintPortIcon(Canvas canvas, Rect bounds, Color stroke, Color fill) {
  final w = bounds.width;
  final h = bounds.height;
  final l = bounds.left;
  final t = bounds.top;

  // Scale helper based on 80x80 viewBox
  double sx(double v) => l + v * w / 80;
  double sy(double v) => t + v * h / 80;
  double s(double v) => v * w / 80;

  // Port body — rounded rectangle
  final bodyRect = RRect.fromRectAndRadius(
    Rect.fromLTRB(sx(15), sy(18), sx(65), sy(55)),
    Radius.circular(s(5)),
  );
  canvas.drawRRect(bodyRect, Paint()..color = fill);
  canvas.drawRRect(
    bodyRect,
    Paint()
      ..color = stroke
      ..style = PaintingStyle.stroke
      ..strokeWidth = s(2),
  );

  // Inner cavity — recessed opening
  final cavityRect = RRect.fromRectAndRadius(
    Rect.fromLTRB(sx(22), sy(24), sx(58), sy(46)),
    Radius.circular(s(3)),
  );
  canvas.drawRRect(
    cavityRect,
    Paint()..color = stroke.withValues(alpha: 0.2),
  );

  // 8 pin contacts — vertical lines inside cavity
  final pinPaint = Paint()
    ..color = stroke
    ..strokeWidth = s(1.5)
    ..strokeCap = StrokeCap.round;
  final pinStartY = sy(26);
  final pinEndY = sy(38);
  final pinStartX = sx(26);
  final pinSpacing = s(4);
  for (int i = 0; i < 8; i++) {
    final px = pinStartX + i * pinSpacing;
    canvas.drawLine(Offset(px, pinStartY), Offset(px, pinEndY), pinPaint);
  }

  // Clip tab — small rectangle below body
  final clipRect = RRect.fromRectAndRadius(
    Rect.fromLTRB(sx(30), sy(55), sx(50), sy(62)),
    Radius.circular(s(2)),
  );
  canvas.drawRRect(clipRect, Paint()..color = fill);
  canvas.drawRRect(
    clipRect,
    Paint()
      ..color = stroke
      ..style = PaintingStyle.stroke
      ..strokeWidth = s(1.5),
  );
}
