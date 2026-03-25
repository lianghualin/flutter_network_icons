import 'package:flutter/material.dart';

/// LNM hardware-style RJ45 Ethernet port.
/// Whole housing changes color by state: green (up), grey (down), black (disabled).
/// White pin contacts for contrast. No LED dot.
/// SVG ref: viewBox 0 0 160 130.
void paintPortLnmIcon(Canvas canvas, Rect bounds, bool isUp, bool isDisabled) {
  const svgW = 160.0;
  const svgH = 130.0;
  final scale =
      (bounds.width / svgW).clamp(0.0, bounds.height / svgH).toDouble();
  final drawW = svgW * scale;
  final drawH = svgH * scale;
  final offsetX = bounds.left + (bounds.width - drawW) / 2;
  final offsetY = bounds.top + (bounds.height - drawH) / 2;

  double x(double svgX) => offsetX + svgX * scale;
  double y(double svgY) => offsetY + svgY * scale;
  double s(double v) => v * scale;

  // Resolve colors based on state
  final Color housingColor;
  final Color strokeColor;
  final Color cavityColor;
  final Color pinColor;

  if (isDisabled) {
    housingColor = const Color(0xFF333333);
    strokeColor = const Color(0xFF1A1A1A);
    cavityColor = const Color(0xFF1A1A1A);
    pinColor = const Color(0xFF666666);
  } else if (isUp) {
    housingColor = const Color(0xFF27AE60);
    strokeColor = const Color(0xFF1E8449);
    cavityColor = const Color(0xFF1E8449);
    pinColor = Colors.white;
  } else {
    housingColor = const Color(0xFFAAAAAA);
    strokeColor = const Color(0xFF888888);
    cavityColor = const Color(0xFF888888);
    pinColor = Colors.white;
  }

  // Metal housing — outer rounded rectangle
  final housingRect = RRect.fromRectAndRadius(
    Rect.fromLTRB(x(15), y(10), x(145), y(85)),
    Radius.circular(s(8)),
  );
  canvas.drawRRect(housingRect, Paint()..color = housingColor);
  canvas.drawRRect(
    housingRect,
    Paint()
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = s(2.5),
  );

  // Inner cavity — full-width recessed area
  final cavityRect = RRect.fromRectAndRadius(
    Rect.fromLTRB(x(28), y(22), x(132), y(68)),
    Radius.circular(s(4)),
  );
  canvas.drawRRect(
    cavityRect,
    Paint()..color = cavityColor.withValues(alpha: 0.25),
  );

  // 8 pin contacts inside cavity — white for contrast
  final pinPaint = Paint()
    ..color = pinColor
    ..strokeWidth = s(3)
    ..strokeCap = StrokeCap.round;
  final pinStartY = y(28);
  final pinEndY = y(55);
  final pinStartX = x(36);
  final pinSpacing = s(12);
  for (int i = 0; i < 8; i++) {
    final px = pinStartX + i * pinSpacing;
    canvas.drawLine(Offset(px, pinStartY), Offset(px, pinEndY), pinPaint);
  }

  // Clip tab below housing
  final clipRect = RRect.fromRectAndRadius(
    Rect.fromLTRB(x(55), y(85), x(105), y(100)),
    Radius.circular(s(4)),
  );
  canvas.drawRRect(clipRect, Paint()..color = housingColor);
  canvas.drawRRect(
    clipRect,
    Paint()
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = s(1.5),
  );
}
