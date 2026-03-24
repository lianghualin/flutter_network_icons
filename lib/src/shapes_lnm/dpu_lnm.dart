import 'package:flutter/material.dart';
import '../lnm_colors.dart';

/// LNM-style DPU: tall vertical rack unit (portrait).
/// Rounded rectangle body, row of small LED circles near top, two square port
/// areas (NETA/NETB) in the lower section.
///
/// SVG ref: viewBox 0 0 133 355
void paintDpuLnmIcon(Canvas canvas, Rect bounds, bool isError) {
  const svgW = 133.0;
  const svgH = 355.0;
  final scale =
      (bounds.width / svgW).clamp(0.0, bounds.height / svgH).toDouble();
  final drawW = svgW * scale;
  final drawH = svgH * scale;
  final offsetX = bounds.left + (bounds.width - drawW) / 2;
  final offsetY = bounds.top + (bounds.height - drawH) / 2;

  double x(double svgX) => offsetX + svgX * scale;
  double y(double svgY) => offsetY + svgY * scale;
  double s(double v) => v * scale;

  final bodyColor = isError ? LnmIconColors.dpuError : LnmIconColors.nearBlack;

  // Main body (rounded rectangle)
  final bodyRect = RRect.fromRectAndRadius(
    Rect.fromLTRB(x(0.5), y(0.5), x(132.5), y(354.5)),
    Radius.circular(s(13)),
  );
  canvas.drawRRect(bodyRect, Paint()..color = bodyColor);
  canvas.drawRRect(
    bodyRect,
    Paint()
      ..color = LnmIconColors.border
      ..style = PaintingStyle.stroke
      ..strokeWidth = s(1),
  );

  // LED indicator circles — two columns of 4 near top
  // Column 1 at x=56.5, column 2 at x=73.5
  // Y positions: 73.5, 86.5, 99.5, 112.5
  final ledPositions = [
    Offset(x(56.5), y(73.5)),
    Offset(x(56.5), y(86.5)),
    Offset(x(56.5), y(99.5)),
    Offset(x(56.5), y(112.5)),
    Offset(x(73.5), y(73.5)),
    Offset(x(73.5), y(86.5)),
    Offset(x(73.5), y(99.5)),
    Offset(x(73.5), y(112.5)),
  ];
  final ledPaint = Paint()..color = LnmIconColors.lightGrey;
  final ledStroke = Paint()
    ..color = LnmIconColors.border
    ..style = PaintingStyle.stroke
    ..strokeWidth = s(1);
  for (final pos in ledPositions) {
    canvas.drawCircle(pos, s(3), ledPaint);
    canvas.drawCircle(pos, s(3), ledStroke);
  }

  // DBG indicator
  final dbgRect = RRect.fromRectAndRadius(
    Rect.fromLTRB(x(52.5), y(163.5), x(59.5), y(181.5)),
    Radius.circular(s(3)),
  );
  canvas.drawRRect(dbgRect, Paint()..color = LnmIconColors.lightGrey);
  canvas.drawRRect(dbgRect, ledStroke);

  // Port A (NETA) — square at (41, 227), 22x22
  final portARect = Rect.fromLTRB(x(41.5), y(227.5), x(62.5), y(248.5));
  canvas.drawRect(portARect, Paint()..color = LnmIconColors.lightGrey);
  canvas.drawRect(
    portARect,
    Paint()
      ..color = LnmIconColors.border
      ..style = PaintingStyle.stroke
      ..strokeWidth = s(1),
  );

  // Port B (NETB) — square at (41, 263), 22x22
  final portBRect = Rect.fromLTRB(x(41.5), y(263.5), x(62.5), y(284.5));
  canvas.drawRect(portBRect, Paint()..color = LnmIconColors.lightGrey);
  canvas.drawRect(
    portBRect,
    Paint()
      ..color = LnmIconColors.border
      ..style = PaintingStyle.stroke
      ..strokeWidth = s(1),
  );
}
