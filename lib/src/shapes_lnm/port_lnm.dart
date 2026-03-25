import 'package:flutter/material.dart';
import '../lnm_colors.dart';

/// LNM hardware-style RJ45 Ethernet port.
/// Metal housing with LED indicator for link status.
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
  final Color chassisColor;
  final Color strokeColor;
  final Color ledColor;

  if (isDisabled) {
    chassisColor = LnmIconColors.darkGrey;
    strokeColor = LnmIconColors.border;
    ledColor = LnmIconColors.nearBlack;
  } else if (isUp) {
    chassisColor = LnmIconColors.silverChassis;
    strokeColor = LnmIconColors.darkGrey;
    ledColor = LnmIconColors.tealLed;
  } else {
    chassisColor = LnmIconColors.silverChassis;
    strokeColor = LnmIconColors.darkGrey;
    ledColor = LnmIconColors.greyLed;
  }

  // Metal housing — outer rounded rectangle
  final housingRect = RRect.fromRectAndRadius(
    Rect.fromLTRB(x(15), y(10), x(145), y(85)),
    Radius.circular(s(8)),
  );
  canvas.drawRRect(housingRect, Paint()..color = chassisColor);
  canvas.drawRRect(
    housingRect,
    Paint()
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = s(2),
  );

  // Inner cavity — recessed darker area
  final cavityRect = RRect.fromRectAndRadius(
    Rect.fromLTRB(x(28), y(22), x(115), y(68)),
    Radius.circular(s(4)),
  );
  canvas.drawRRect(
    cavityRect,
    Paint()..color = strokeColor.withValues(alpha: 0.2),
  );

  // 8 pin contacts inside cavity
  final pinPaint = Paint()
    ..color = LnmIconColors.lightGrey
    ..strokeWidth = s(2.5)
    ..strokeCap = StrokeCap.round;
  final pinStartY = y(28);
  final pinEndY = y(55);
  final pinStartX = x(36);
  final pinSpacing = s(9);
  for (int i = 0; i < 8; i++) {
    final px = pinStartX + i * pinSpacing;
    canvas.drawLine(Offset(px, pinStartY), Offset(px, pinEndY), pinPaint);
  }

  // Clip tab below housing
  final clipRect = RRect.fromRectAndRadius(
    Rect.fromLTRB(x(55), y(85), x(105), y(100)),
    Radius.circular(s(4)),
  );
  canvas.drawRRect(clipRect, Paint()..color = chassisColor);
  canvas.drawRRect(
    clipRect,
    Paint()
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = s(1.5),
  );

  // LED indicator — top-right of housing
  canvas.drawCircle(Offset(x(130), y(25)), s(7), Paint()..color = ledColor);
  canvas.drawCircle(
    Offset(x(130), y(25)),
    s(7),
    Paint()
      ..color = LnmIconColors.border
      ..style = PaintingStyle.stroke
      ..strokeWidth = s(1),
  );
}
