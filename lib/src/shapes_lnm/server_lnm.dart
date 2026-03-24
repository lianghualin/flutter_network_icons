import 'package:flutter/material.dart';
import '../lnm_colors.dart';

/// LNM-style server: three vertically stacked rack units. Each unit has a
/// horizontal port slot bar on the left and 2 LED circles on the right.
void paintServerLnmIcon(Canvas canvas, Rect bounds, bool isError) {
  const svgW = 180.0;
  const svgH = 160.0;
  final scale =
      (bounds.width / svgW).clamp(0.0, bounds.height / svgH).toDouble();
  final drawW = svgW * scale;
  final drawH = svgH * scale;
  final offsetX = bounds.left + (bounds.width - drawW) / 2;
  final offsetY = bounds.top + (bounds.height - drawH) / 2;

  double x(double svgX) => offsetX + svgX * scale;
  double y(double svgY) => offsetY + svgY * scale;
  double s(double v) => v * scale;

  final unitColor =
      isError ? LnmIconColors.errorLight : LnmIconColors.silverChassis;
  final strokeColor = LnmIconColors.darkGrey;

  // LED colors for the three units (each unit has 2 LEDs)
  final ledColors = [
    [LnmIconColors.tealLed, LnmIconColors.coralLed],
    [LnmIconColors.tealLed, LnmIconColors.greyLed],
    [LnmIconColors.coralLed, LnmIconColors.greyLed],
  ];

  for (var i = 0; i < 3; i++) {
    final unitTop = 10.0 + i * 50.0;
    final unitBottom = unitTop + 40.0;

    // Unit body
    final unitRect = RRect.fromRectAndRadius(
      Rect.fromLTRB(x(10), y(unitTop), x(170), y(unitBottom)),
      Radius.circular(s(5)),
    );
    canvas.drawRRect(unitRect, Paint()..color = unitColor);
    canvas.drawRRect(
      unitRect,
      Paint()
        ..color = strokeColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = s(1.5),
    );

    // Port slot bar (left side of each unit)
    final slotRect = RRect.fromRectAndRadius(
      Rect.fromLTRB(x(22), y(unitTop + 10), x(110), y(unitBottom - 10)),
      Radius.circular(s(3)),
    );
    canvas.drawRRect(slotRect, Paint()..color = strokeColor);

    // Two LED circles (right side)
    final ledY = unitTop + 20.0;
    canvas.drawCircle(
      Offset(x(130), y(ledY)),
      s(6),
      Paint()..color = ledColors[i][0],
    );
    canvas.drawCircle(
      Offset(x(150), y(ledY)),
      s(6),
      Paint()..color = ledColors[i][1],
    );
  }
}
