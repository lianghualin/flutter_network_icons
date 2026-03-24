import 'package:flutter/material.dart';

/// Horizontal box with 3 port rectangles and directional arrows on each side.
/// SVG ref: viewBox 0 0 80 80, body 12,30 -> 68,50; ports at 20-28, 32-40, 44-52; arrows at x=6 and x=74.
void paintSwitchIcon(Canvas canvas, Rect bounds, Color stroke, Color fill) {
  final w = bounds.width;
  final h = bounds.height;
  final l = bounds.left;
  final t = bounds.top;

  double x(double svgX) => l + (svgX / 80) * w;
  double y(double svgY) => t + (svgY / 80) * h;

  // Switch body
  final body = Path()
    ..addRect(Rect.fromLTRB(x(12), y(30), x(68), y(50)));

  canvas.drawPath(
    body,
    Paint()
      ..color = fill
      ..style = PaintingStyle.fill,
  );
  canvas.drawPath(
    body,
    Paint()
      ..color = stroke
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeJoin = StrokeJoin.round,
  );

  // Port indicators (filled with stroke color)
  final portPaint = Paint()
    ..color = stroke
    ..style = PaintingStyle.fill;

  canvas.drawRect(Rect.fromLTRB(x(20), y(36), x(28), y(44)), portPaint);
  canvas.drawRect(Rect.fromLTRB(x(32), y(36), x(40), y(44)), portPaint);
  canvas.drawRect(Rect.fromLTRB(x(44), y(36), x(52), y(44)), portPaint);

  // Left arrow (chevron pointing right toward switch)
  final arrowPaint = Paint()
    ..color = stroke
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;

  final leftArrow = Path()
    ..moveTo(x(6), y(34))
    ..lineTo(x(12), y(40))
    ..lineTo(x(6), y(46));
  canvas.drawPath(leftArrow, arrowPaint);

  // Right arrow (chevron pointing left toward switch)
  final rightArrow = Path()
    ..moveTo(x(74), y(34))
    ..lineTo(x(68), y(40))
    ..lineTo(x(74), y(46));
  canvas.drawPath(rightArrow, arrowPaint);
}
