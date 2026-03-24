import 'package:flutter/material.dart';
import '../lnm_colors.dart';

/// LNM-style generic device: simple rounded rectangular box with subtle inner
/// panel, two LED indicators, and one port rectangle.
void paintGenericLnmIcon(Canvas canvas, Rect bounds, bool isError) {
  const svgW = 160.0;
  const svgH = 120.0;
  final scale =
      (bounds.width / svgW).clamp(0.0, bounds.height / svgH).toDouble();
  final drawW = svgW * scale;
  final drawH = svgH * scale;
  final offsetX = bounds.left + (bounds.width - drawW) / 2;
  final offsetY = bounds.top + (bounds.height - drawH) / 2;

  double x(double svgX) => offsetX + svgX * scale;
  double y(double svgY) => offsetY + svgY * scale;
  double s(double v) => v * scale;

  final chassisColor =
      isError ? LnmIconColors.errorLight : LnmIconColors.silverChassis;
  final strokeColor =
      isError ? LnmIconColors.errorDark : LnmIconColors.darkGrey;

  // Outer box
  final outerRect = RRect.fromRectAndRadius(
    Rect.fromLTRB(x(10), y(10), x(150), y(110)),
    Radius.circular(s(8)),
  );
  canvas.drawRRect(outerRect, Paint()..color = chassisColor);
  canvas.drawRRect(
    outerRect,
    Paint()
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = s(2),
  );

  // Inner panel (subtle)
  final innerRect = RRect.fromRectAndRadius(
    Rect.fromLTRB(x(20), y(20), x(140), y(100)),
    Radius.circular(s(4)),
  );
  canvas.drawRRect(
    innerRect,
    Paint()
      ..color = strokeColor.withValues(alpha: 0.15)
      ..style = PaintingStyle.fill,
  );

  // Port rectangle (left-center area)
  final portRect = RRect.fromRectAndRadius(
    Rect.fromLTRB(x(30), y(45), x(90), y(75)),
    Radius.circular(s(4)),
  );
  canvas.drawRRect(portRect, Paint()..color = strokeColor);

  // Two LED indicators (right side)
  canvas.drawCircle(
    Offset(x(115), y(50)),
    s(6),
    Paint()..color = LnmIconColors.tealLed,
  );
  canvas.drawCircle(
    Offset(x(115), y(70)),
    s(6),
    Paint()..color = LnmIconColors.coralLed,
  );
}
