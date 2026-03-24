import 'package:flutter/material.dart';

/// Cloud silhouette with bezier curves: 3-4 bumps on top, flat bottom.
/// SVG ref: viewBox 0 0 80 80, path from (22,52) with bumps peaking around y=28..33.
void paintNetworkIcon(Canvas canvas, Rect bounds, Color stroke, Color fill) {
  final w = bounds.width;
  final h = bounds.height;
  final l = bounds.left;
  final t = bounds.top;

  // Map SVG coordinates (80x80) to bounds.
  double x(double svgX) => l + (svgX / 80) * w;
  double y(double svgY) => t + (svgY / 80) * h;

  final path = Path()
    ..moveTo(x(22), y(52))
    ..lineTo(x(58), y(52))
    // right bump up
    ..cubicTo(x(58), y(52), x(62), y(52), x(62), y(48))
    ..cubicTo(x(62), y(44), x(58), y(42), x(55), y(42))
    // top-right bump
    ..cubicTo(x(55), y(42), x(56), y(36), x(50), y(33))
    // top-center bump
    ..cubicTo(x(44), y(30), x(40), y(34), x(40), y(34))
    // top-left bump
    ..cubicTo(x(40), y(34), x(38), y(28), x(30), y(28))
    // left side descent
    ..cubicTo(x(22), y(28), x(18), y(34), x(18), y(38))
    // bottom-left bump
    ..cubicTo(x(18), y(38), x(12), y(38), x(12), y(44))
    ..cubicTo(x(12), y(50), x(18), y(52), x(22), y(52))
    ..close();

  canvas.drawPath(
    path,
    Paint()
      ..color = fill
      ..style = PaintingStyle.fill,
  );
  canvas.drawPath(
    path,
    Paint()
      ..color = stroke
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeJoin = StrokeJoin.round,
  );
}
