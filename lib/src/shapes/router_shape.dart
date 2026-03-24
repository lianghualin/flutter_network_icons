import 'package:flutter/material.dart';

/// Circle with 4 directional arrows (N, S, E, W) and center dot.
/// SVG ref: viewBox 0 0 80 80; circle r=30 at (40,40); center dot r=4; arrows from ~32/48 to ~18/62.
void paintRouterIcon(Canvas canvas, Rect bounds, Color stroke, Color fill) {
  final w = bounds.width;
  final h = bounds.height;
  final l = bounds.left;
  final t = bounds.top;

  double x(double svgX) => l + (svgX / 80) * w;
  double y(double svgY) => t + (svgY / 80) * h;

  // Outer circle
  final center = Offset(x(40), y(40));
  final radius = w * (30.0 / 80);

  canvas.drawCircle(
    center,
    radius,
    Paint()
      ..color = fill
      ..style = PaintingStyle.fill,
  );
  canvas.drawCircle(
    center,
    radius,
    Paint()
      ..color = stroke
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2,
  );

  // Center dot
  final dotRadius = w * (4.0 / 80);
  canvas.drawCircle(
    center,
    dotRadius,
    Paint()
      ..color = stroke
      ..style = PaintingStyle.fill,
  );

  // Arrow paint
  final arrowPaint = Paint()
    ..color = stroke
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;

  // North arrow: line from (40,32) to (40,18), arrowhead at (36,22)-(40,18)-(44,22)
  final north = Path()
    ..moveTo(x(40), y(32))
    ..lineTo(x(40), y(18));
  canvas.drawPath(north, arrowPaint);
  final northHead = Path()
    ..moveTo(x(36), y(22))
    ..lineTo(x(40), y(18))
    ..lineTo(x(44), y(22));
  canvas.drawPath(northHead, arrowPaint);

  // South arrow: line from (40,48) to (40,62), arrowhead at (36,58)-(40,62)-(44,58)
  final south = Path()
    ..moveTo(x(40), y(48))
    ..lineTo(x(40), y(62));
  canvas.drawPath(south, arrowPaint);
  final southHead = Path()
    ..moveTo(x(36), y(58))
    ..lineTo(x(40), y(62))
    ..lineTo(x(44), y(58));
  canvas.drawPath(southHead, arrowPaint);

  // East arrow: line from (48,40) to (62,40), arrowhead at (58,36)-(62,40)-(58,44)
  final east = Path()
    ..moveTo(x(48), y(40))
    ..lineTo(x(62), y(40));
  canvas.drawPath(east, arrowPaint);
  final eastHead = Path()
    ..moveTo(x(58), y(36))
    ..lineTo(x(62), y(40))
    ..lineTo(x(58), y(44));
  canvas.drawPath(eastHead, arrowPaint);

  // West arrow: line from (32,40) to (18,40), arrowhead at (22,36)-(18,40)-(22,44)
  final west = Path()
    ..moveTo(x(32), y(40))
    ..lineTo(x(18), y(40));
  canvas.drawPath(west, arrowPaint);
  final westHead = Path()
    ..moveTo(x(22), y(36))
    ..lineTo(x(18), y(40))
    ..lineTo(x(22), y(44));
  canvas.drawPath(westHead, arrowPaint);
}
