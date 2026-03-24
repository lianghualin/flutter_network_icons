import 'package:flutter/material.dart';
import '../lnm_colors.dart';

/// LNM-style switch: horizontal chassis with tapered trapezoidal top hood,
/// flat bottom panel, two rows of rounded-rect port slots, and three LED
/// circles per row (teal, coral, grey).
///
/// SVG ref: viewBox 0 0 300 170
void paintSwitchLnmIcon(Canvas canvas, Rect bounds, bool isError) {
  // Original SVG is 300x170 — fit within square bounds keeping aspect ratio.
  const svgW = 300.0;
  const svgH = 170.0;
  final scale =
      (bounds.width / svgW).clamp(0.0, bounds.height / svgH).toDouble();
  final drawW = svgW * scale;
  final drawH = svgH * scale;
  final offsetX = bounds.left + (bounds.width - drawW) / 2;
  final offsetY = bounds.top + (bounds.height - drawH) / 2;

  double x(double svgX) => offsetX + svgX * scale;
  double y(double svgY) => offsetY + svgY * scale;
  double s(double v) => v * scale;

  final hoodColor = isError ? LnmIconColors.errorLight : LnmIconColors.silverChassis;
  final bottomColor = isError ? LnmIconColors.errorDark : LnmIconColors.darkGrey;

  // Bottom panel (rectangle with rounded bottom corners)
  final bottomPanel = RRect.fromLTRBAndCorners(
    x(0), y(101.6), x(300), y(170),
    bottomLeft: Radius.circular(s(10)),
    bottomRight: Radius.circular(s(10)),
  );
  canvas.drawRRect(bottomPanel, Paint()..color = bottomColor);

  // Top hood (trapezoid)
  final hood = Path()
    ..moveTo(x(33.75), y(0))
    ..lineTo(x(266.25), y(0))
    ..lineTo(x(300), y(102.6))
    ..lineTo(x(0), y(102.6))
    ..close();
  canvas.drawPath(hood, Paint()..color = hoodColor);

  // Directional arrows in hood area (dark grey)
  final arrowPaint = Paint()
    ..color = LnmIconColors.darkGrey
    ..style = PaintingStyle.fill;

  // Right-pointing arrow with bar
  final rightArrow = Path()
    ..moveTo(x(199), y(89.5))
    ..lineTo(x(242), y(69.8))
    ..lineTo(x(200.6), y(51.3))
    ..lineTo(x(200.1), y(64.5))
    ..lineTo(x(138.5), y(64.5))
    ..lineTo(x(137), y(77.4))
    ..lineTo(x(199.6), y(77.4))
    ..close();
  canvas.drawPath(rightArrow, arrowPaint);

  // Left-pointing arrow with bar
  final leftArrow = Path()
    ..moveTo(x(106.2), y(47.3))
    ..lineTo(x(168), y(47.3))
    ..lineTo(x(168), y(35.2))
    ..lineTo(x(107.2), y(35.2))
    ..lineTo(x(108), y(23.1))
    ..lineTo(x(66), y(41.2))
    ..lineTo(x(105.3), y(59.3))
    ..close();
  canvas.drawPath(leftArrow, arrowPaint);

  // Port slot rows — row 1 (y ~117.7–135.8)
  final portFill = Paint()..color = LnmIconColors.silverChassis;
  // Row 1 left port
  canvas.drawRRect(
    RRect.fromRectAndRadius(
      Rect.fromLTRB(x(12), y(117.7), x(89), y(135.8)),
      Radius.circular(s(9)),
    ),
    portFill,
  );
  // Row 1 right port
  canvas.drawRRect(
    RRect.fromRectAndRadius(
      Rect.fromLTRB(x(100), y(117.7), x(177), y(135.8)),
      Radius.circular(s(9)),
    ),
    portFill,
  );

  // Row 2 (y ~139.8–157.9)
  canvas.drawRRect(
    RRect.fromRectAndRadius(
      Rect.fromLTRB(x(13), y(139.8), x(90), y(157.9)),
      Radius.circular(s(9)),
    ),
    portFill,
  );
  canvas.drawRRect(
    RRect.fromRectAndRadius(
      Rect.fromLTRB(x(100), y(139.8), x(177), y(157.9)),
      Radius.circular(s(9)),
    ),
    portFill,
  );

  // LED circles — Row 1
  _drawLed(canvas, Offset(x(269.5), y(126.2)), s(8.5), LnmIconColors.tealLed);
  _drawLed(canvas, Offset(x(242.5), y(126.2)), s(8.5), LnmIconColors.coralLed);
  _drawLed(canvas, Offset(x(215.5), y(126.2)), s(8.5), LnmIconColors.greyLed);

  // LED circles — Row 2
  _drawLed(canvas, Offset(x(270.5), y(149.4)), s(8.5), LnmIconColors.tealLed);
  _drawLed(canvas, Offset(x(243.5), y(149.4)), s(8.5), LnmIconColors.coralLed);
  _drawLed(canvas, Offset(x(215.5), y(149.4)), s(8.5), LnmIconColors.greyLed);
}

void _drawLed(Canvas canvas, Offset center, double radius, Color color) {
  canvas.drawCircle(center, radius, Paint()..color = color);
}
