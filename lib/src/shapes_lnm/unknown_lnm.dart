import 'package:flutter/material.dart';
import '../lnm_colors.dart';
import '../question_mark_painter.dart';

/// LNM-style unknown device: ghost host (20%) with centered magnifying glass,
/// orange bold ? inside, red badge top-right.
/// Same pattern as switch_unknown_lnm but using host silhouette.
/// Error: ghost screen turns red, ? turns red.
void paintUnknownLnmIcon(Canvas canvas, Rect bounds, bool isError) {
  // Use host SVG coordinate space: 202x170
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

  // Ghost host at 20% opacity
  canvas.saveLayer(bounds, Paint()..color = Colors.white.withValues(alpha: 0.2));

  // Monitor body
  final bodyRect = RRect.fromRectAndRadius(
    Rect.fromLTRB(x(0), y(0), x(202), y(124)),
    Radius.circular(s(6)),
  );
  canvas.drawRRect(bodyRect, Paint()..color = LnmIconColors.navy);

  // Screen
  final screenColor = isError ? LnmIconColors.errorScreen : LnmIconColors.lightGrey;
  final screenRect = RRect.fromRectAndRadius(
    Rect.fromLTRB(x(7), y(8), x(196), y(102)),
    Radius.circular(s(5)),
  );
  canvas.drawRRect(screenRect, Paint()..color = screenColor);
  canvas.drawRRect(
    screenRect,
    Paint()
      ..color = LnmIconColors.border
      ..style = PaintingStyle.stroke
      ..strokeWidth = s(1),
  );

  // Neck
  final neckPath = Path()
    ..moveTo(x(85), y(124))
    ..lineTo(x(117), y(124))
    ..lineTo(x(117), y(143.4))
    ..lineTo(x(85), y(143.4))
    ..close();
  canvas.drawPath(neckPath, Paint()..color = LnmIconColors.darkNavy);

  // Base
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
  canvas.drawPath(basePath, Paint()..color = LnmIconColors.navy);

  canvas.restore(); // End ghost layer

  // Centered magnifying glass (full opacity)
  final lensCenter = Offset(x(101), y(62));
  final lensRadius = s(42);
  canvas.drawCircle(
    lensCenter,
    lensRadius,
    Paint()..color = Colors.white.withValues(alpha: 0.45),
  );
  canvas.drawCircle(
    lensCenter,
    lensRadius,
    Paint()
      ..color = const Color(0xFF6B7789)
      ..style = PaintingStyle.stroke
      ..strokeWidth = s(5),
  );

  // Handle
  canvas.drawLine(
    Offset(x(131), y(92)),
    Offset(x(158), y(118)),
    Paint()
      ..color = const Color(0xFF6B7789)
      ..strokeWidth = s(7)
      ..strokeCap = StrokeCap.round,
  );

  // Orange bold ? (or red in error) — using TextPainter for proper glyph
  final qColor = isError ? LnmIconColors.questionRed : LnmIconColors.questionOrange;
  paintQuestionMark(
    canvas,
    center: lensCenter,
    size: s(72),
    color: qColor,
  );

  // Red badge top-right
  final badgeCenter = Offset(x(185), y(14));
  canvas.drawCircle(badgeCenter, s(14), Paint()..color = const Color(0xFFE8554E));
  canvas.drawCircle(
    badgeCenter,
    s(14),
    Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = s(3),
  );
}
