import 'package:flutter/material.dart';
import '../lnm_colors.dart';
import '../question_mark_painter.dart';

/// LNM-style switch unknown: ghost switch (20%) with centered magnifying glass,
/// orange bold ? inside, red badge top-right.
/// Error: ghost switch turns red, ? turns red.
void paintSwitchUnknownLnmIcon(Canvas canvas, Rect bounds, bool isError) {
  // Use switch SVG coordinate space: 300x170
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

  // Ghost switch at 20% opacity
  canvas.saveLayer(bounds, Paint()..color = Colors.white.withValues(alpha: 0.2));

  // Bottom panel
  final bottomPath = Path()
    ..moveTo(x(0), y(101.6))
    ..lineTo(x(300), y(101.6))
    ..lineTo(x(300), y(160))
    ..cubicTo(x(300), y(163.3), x(299.6), y(164.6), x(298.9), y(165.9))
    ..cubicTo(x(297.2), y(168.2), x(295.9), y(168.9), x(289.7), y(170))
    ..lineTo(x(10.3), y(170))
    ..cubicTo(x(6.7), y(170), x(5.4), y(169.6), x(4.1), y(168.9))
    ..cubicTo(x(1.8), y(167.2), x(0.4), y(164.6), x(0), y(160))
    ..close();
  canvas.drawPath(
    bottomPath,
    Paint()..color = isError ? LnmIconColors.errorDark : LnmIconColors.darkGrey,
  );

  // Top hood (trapezoid)
  final hoodPath = Path()
    ..moveTo(x(33.7), y(0))
    ..lineTo(x(266.3), y(0))
    ..cubicTo(x(270.6), y(0), x(272.1), y(0.4), x(273.8), y(1.1))
    ..cubicTo(x(275.4), y(1.8), x(276.8), y(2.9), x(277.8), y(4.4))
    ..cubicTo(x(278.9), y(5.8), x(279.6), y(7.3), x(280.5), y(11.5))
    ..lineTo(x(300), y(102.6))
    ..lineTo(x(0), y(102.6))
    ..lineTo(x(19.5), y(11.5))
    ..cubicTo(x(20.4), y(7.3), x(21.1), y(5.8), x(22.2), y(4.4))
    ..cubicTo(x(23.2), y(2.9), x(24.6), y(1.8), x(26.2), y(1.1))
    ..cubicTo(x(27.9), y(0.4), x(29.4), y(0), x(33.7), y(0))
    ..close();
  canvas.drawPath(
    hoodPath,
    Paint()..color = isError ? LnmIconColors.errorLight : LnmIconColors.silverChassis,
  );

  // Port slots
  for (final row in [118.0, 140.0]) {
    final portRect1 = RRect.fromRectAndRadius(
      Rect.fromLTRB(x(12), y(row), x(89), y(row + 18)),
      Radius.circular(s(9)),
    );
    canvas.drawRRect(portRect1, Paint()..color = LnmIconColors.silverChassis);
    final portRect2 = RRect.fromRectAndRadius(
      Rect.fromLTRB(x(100), y(row), x(177), y(row + 18)),
      Radius.circular(s(9)),
    );
    canvas.drawRRect(portRect2, Paint()..color = LnmIconColors.silverChassis);
  }

  canvas.restore(); // End ghost layer

  // Centered magnifying glass (full opacity, on top of ghost)
  final lensCenter = Offset(x(150), y(85));
  final lensRadius = s(55);
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
      ..strokeWidth = s(7),
  );

  // Handle
  canvas.drawLine(
    Offset(x(190), y(125)),
    Offset(x(225), y(158)),
    Paint()
      ..color = const Color(0xFF6B7789)
      ..strokeWidth = s(9)
      ..strokeCap = StrokeCap.round,
  );

  // Bold orange ? (or red in error) — using TextPainter for proper glyph
  final qColor = isError ? LnmIconColors.questionRed : LnmIconColors.questionOrange;
  paintQuestionMark(
    canvas,
    center: lensCenter,
    size: s(90),
    color: qColor,
  );

  // Red badge top-right
  final badgeCenter = Offset(x(270), y(20));
  canvas.drawCircle(badgeCenter, s(18), Paint()..color = const Color(0xFFE8554E));
  canvas.drawCircle(
    badgeCenter,
    s(18),
    Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = s(4),
  );
}
