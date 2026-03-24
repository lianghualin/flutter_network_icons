import 'package:flutter/material.dart';
import '../lnm_colors.dart';

/// LNM-style unknown device: black monitor body, white screen, orange question
/// mark. Error: question mark turns red.
///
/// SVG ref: viewBox 0 0 305 335 (monitor + switch at bottom + question mark)
/// Simplified to just the monitor + question mark (the switch part is omitted
/// as the spec says "Desktop monitor ... with question mark").
void paintUnknownLnmIcon(Canvas canvas, Rect bounds, bool isError) {
  // Layout within 305x280 (just the monitor portion from the SVG)
  const svgW = 305.0;
  const svgH = 280.0;
  final scale =
      (bounds.width / svgW).clamp(0.0, bounds.height / svgH).toDouble();
  final drawW = svgW * scale;
  final drawH = svgH * scale;
  final offsetX = bounds.left + (bounds.width - drawW) / 2;
  final offsetY = bounds.top + (bounds.height - drawH) / 2;

  double x(double svgX) => offsetX + svgX * scale;
  double y(double svgY) => offsetY + svgY * scale;
  double s(double v) => v * scale;

  const monitorColor = Color(0xFF000000);
  const screenColor = Color(0xFFFFFFFF);

  // Monitor body (rounded rectangle)
  final monitorRect = RRect.fromRectAndRadius(
    Rect.fromLTRB(x(0), y(20), x(305), y(214)),
    Radius.circular(s(22)),
  );
  canvas.drawRRect(monitorRect, Paint()..color = monitorColor);

  // Screen (white with border)
  final screenRect = RRect.fromRectAndRadius(
    Rect.fromLTRB(x(9.5), y(30.5), x(294.5), y(205.5)),
    Radius.circular(s(15)),
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
  final neckRect = Rect.fromLTRB(x(127), y(209), x(178), y(243));
  canvas.drawRect(neckRect, Paint()..color = monitorColor);

  // Base (rounded rectangle)
  final baseRect = RRect.fromRectAndRadius(
    Rect.fromLTRB(x(82), y(243), x(222), y(257)),
    Radius.circular(s(4)),
  );
  canvas.drawRect(baseRect.outerRect, Paint()..color = monitorColor);

  // Question mark
  final qColor = isError ? LnmIconColors.questionRed : LnmIconColors.questionOrange;
  final qStrokeColor =
      isError ? LnmIconColors.questionRed : LnmIconColors.questionOrangeStroke;

  // Question mark hook (arc path) — centered on screen
  final qStrokePaint = Paint()
    ..color = qStrokeColor
    ..style = PaintingStyle.stroke
    ..strokeWidth = s(7)
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;
  final qFillPaint = Paint()..color = qColor;

  // Simplified question mark path centered at roughly (152, 100)
  final qPath = Path()
    // The hook of the question mark
    ..moveTo(x(120), y(85))
    ..cubicTo(x(120), y(55), x(150), y(45), x(160), y(55))
    ..cubicTo(x(175), y(65), x(170), y(85), x(152), y(95))
    ..cubicTo(x(145), y(100), x(145), y(105), x(145), y(115));

  canvas.drawPath(qPath, qStrokePaint);
  canvas.drawPath(
    qPath,
    Paint()
      ..color = qColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = s(4)
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round,
  );

  // Question mark dot
  canvas.drawCircle(
    Offset(x(145), y(135)),
    s(7),
    qFillPaint,
  );
  canvas.drawCircle(
    Offset(x(145), y(135)),
    s(7),
    Paint()
      ..color = qStrokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = s(3),
  );
}
