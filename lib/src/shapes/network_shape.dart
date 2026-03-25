import 'package:flutter/material.dart';

/// Classic fluffy cloud: 3 bumps on top, flat bottom.
/// Designed in 100x70 viewBox, scaled to fit bounds.
void paintNetworkIcon(Canvas canvas, Rect bounds, Color stroke, Color fill) {
  final w = bounds.width;
  final h = bounds.height;
  final l = bounds.left;
  final t = bounds.top;

  const vw = 100.0;
  const vh = 70.0;
  final scale = (w / vw).clamp(0.0, h / vh).toDouble();
  final dw = vw * scale;
  final dh = vh * scale;
  final ox = l + (w - dw) / 2;
  final oy = t + (h - dh) / 2;

  double x(double v) => ox + v * scale;
  double y(double v) => oy + v * scale;

  final cloud = Path()
    ..moveTo(x(25), y(55))
    ..cubicTo(x(12), y(55), x(3), y(47), x(3), y(37))
    ..cubicTo(x(3), y(28), x(10), y(21), x(19), y(19))
    ..cubicTo(x(20), y(10), x(28), y(3), x(40), y(3))
    ..cubicTo(x(50), y(3), x(58), y(9), x(62), y(17))
    ..cubicTo(x(64), y(16), x(67), y(15), x(70), y(15))
    ..cubicTo(x(80), y(15), x(88), y(22), x(88), y(31))
    ..cubicTo(x(88), y(32), x(88), y(33), x(88), y(33))
    ..cubicTo(x(93), y(35), x(97), y(40), x(97), y(46))
    ..cubicTo(x(97), y(52), x(92), y(55), x(86), y(55))
    ..close();

  canvas.drawPath(cloud, Paint()..color = fill);
  canvas.drawPath(
    cloud,
    Paint()
      ..color = stroke
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5 * scale
      ..strokeJoin = StrokeJoin.round,
  );
}
