import 'package:flutter/material.dart';
import '../lnm_colors.dart';

/// LNM-style router: silver horizontal box with dark top panel, two diagonal
/// antennas with teal circle tips, row of 4 port rectangles, two LED dots,
/// and bidirectional arrows.
void paintRouterLnmIcon(Canvas canvas, Rect bounds, bool isError) {
  const svgW = 200.0;
  const svgH = 140.0;
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
  final topColor =
      isError ? LnmIconColors.errorDark : LnmIconColors.darkGrey;

  // Antennas (drawn first so they appear behind the box)
  final antennaPaint = Paint()
    ..color = topColor
    ..style = PaintingStyle.stroke
    ..strokeWidth = s(3)
    ..strokeCap = StrokeCap.round;

  // Left antenna
  canvas.drawLine(Offset(x(60), y(45)), Offset(x(40), y(10)), antennaPaint);
  canvas.drawCircle(Offset(x(40), y(10)), s(6), Paint()..color = LnmIconColors.tealLed);

  // Right antenna
  canvas.drawLine(Offset(x(140), y(45)), Offset(x(160), y(10)), antennaPaint);
  canvas.drawCircle(Offset(x(160), y(10)), s(6), Paint()..color = LnmIconColors.tealLed);

  // Top panel (dark)
  final topPanel = RRect.fromLTRBAndCorners(
    x(10), y(40), x(190), y(70),
    topLeft: Radius.circular(s(6)),
    topRight: Radius.circular(s(6)),
  );
  canvas.drawRRect(topPanel, Paint()..color = topColor);

  // Bottom chassis (silver)
  final bottomPanel = RRect.fromLTRBAndCorners(
    x(10), y(70), x(190), y(130),
    bottomLeft: Radius.circular(s(6)),
    bottomRight: Radius.circular(s(6)),
  );
  canvas.drawRRect(bottomPanel, Paint()..color = chassisColor);

  // Bidirectional arrows in top panel
  final arrowPaint = Paint()
    ..color = LnmIconColors.silverChassis
    ..style = PaintingStyle.fill;
  if (isError) {
    arrowPaint.color = LnmIconColors.errorLight;
  }

  // Right-pointing arrow
  final rightArrow = Path()
    ..moveTo(x(120), y(50))
    ..lineTo(x(175), y(55))
    ..lineTo(x(120), y(60))
    ..close();
  canvas.drawPath(rightArrow, arrowPaint);

  // Left-pointing arrow
  final leftArrow = Path()
    ..moveTo(x(80), y(50))
    ..lineTo(x(25), y(55))
    ..lineTo(x(80), y(60))
    ..close();
  canvas.drawPath(leftArrow, arrowPaint);

  // 4 port rectangles in bottom panel
  final portPaint = Paint()..color = topColor;
  for (var i = 0; i < 4; i++) {
    final px = 30.0 + i * 38.0;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(x(px), y(80), x(px + 28), y(105)),
        Radius.circular(s(3)),
      ),
      portPaint,
    );
  }

  // LED indicators (bottom right area)
  canvas.drawCircle(
    Offset(x(165), y(115)),
    s(5),
    Paint()..color = LnmIconColors.tealLed,
  );
  canvas.drawCircle(
    Offset(x(178), y(115)),
    s(5),
    Paint()..color = LnmIconColors.coralLed,
  );
}
