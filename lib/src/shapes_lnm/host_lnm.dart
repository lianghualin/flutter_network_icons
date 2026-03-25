import 'package:flutter/material.dart';
import '../lnm_colors.dart';

/// LNM-style host: monitor body (navy), grey screen with border, neck column,
/// curved base/stand.
///
/// SVG ref: viewBox 0 0 202 170
void paintHostLnmIcon(Canvas canvas, Rect bounds, bool isError) {
  const svgW = 202.0;
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

  const bodyColor = LnmIconColors.navy;
  final screenColor = isError ? LnmIconColors.errorScreen : LnmIconColors.lightGrey;

  // Monitor body (rounded rectangle)
  final bodyRect = RRect.fromRectAndRadius(
    Rect.fromLTRB(x(0), y(0), x(202), y(124)),
    Radius.circular(s(6)),
  );
  canvas.drawRRect(bodyRect, Paint()..color = bodyColor);

  // Screen area (inset rectangle with rounded corners and border)
  final screenRect = RRect.fromRectAndRadius(
    Rect.fromLTRB(x(7), y(8), x(196), y(102)),
    Radius.circular(s(5)),
  );
  canvas.drawRRect(
    screenRect,
    Paint()..color = screenColor,
  );
  canvas.drawRRect(
    screenRect,
    Paint()
      ..color = LnmIconColors.border
      ..style = PaintingStyle.stroke
      ..strokeWidth = s(1),
  );

  // Neck column (dark navy shadow underneath)
  final neckPath = Path()
    ..moveTo(x(85), y(124))
    ..lineTo(x(117), y(124))
    ..lineTo(x(117), y(143.4))
    ..lineTo(x(85), y(143.4))
    ..close();
  canvas.drawPath(neckPath, Paint()..color = LnmIconColors.darkNavy);

  // Base / stand (curved, using bezier to approximate the SVG path)
  final basePath = Path()
    ..moveTo(x(85), y(144.1))
    ..cubicTo(x(74.9), y(144.7), x(56.2), y(142.5), x(48.1), y(146.3))
    ..cubicTo(x(39.1), y(150.5), x(32.8), y(169.9), x(49.1), y(169.9))
    ..lineTo(x(154.9), y(169.9))
    ..cubicTo(x(159.3), y(169.9), x(161.6), y(166.7), x(161.9), y(162.6))
    ..cubicTo(x(162.8), y(150.0), x(154.5), y(144.4), x(142.6), y(144.6))
    ..cubicTo(x(133.9), y(144.7), x(125.2), y(144.6), x(116.6), y(144.1))
    ..cubicTo(x(106.0), y(144.8), x(95.3), y(144.8), x(85), y(144.1))
    ..close();
  canvas.drawPath(basePath, Paint()..color = bodyColor);
}
