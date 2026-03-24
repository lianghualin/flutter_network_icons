import 'package:flutter/material.dart';
import '../lnm_colors.dart';

/// LNM-style network: cloud silhouette with bezier bumps.
/// Normal: green fill + dark green stroke. Error: red fill + dark red stroke.
void paintNetworkLnmIcon(Canvas canvas, Rect bounds, bool isError) {
  final fill = isError ? LnmIconColors.cloudRed : LnmIconColors.cloudGreen;
  final stroke =
      isError ? LnmIconColors.cloudRedStroke : LnmIconColors.cloudGreenStroke;

  // Work within padded bounds
  final w = bounds.width;
  final h = bounds.height;
  final l = bounds.left;
  final t = bounds.top;

  // Cloud shape — three bumps on top, flat-ish bottom
  // Designed within a 100x70 viewBox, scaled to fit bounds.
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
    // Start at bottom-left
    ..moveTo(x(15), y(55))
    // Left bump up
    ..cubicTo(x(2), y(55), x(-2), y(38), x(12), y(33))
    // Top-left bump
    ..cubicTo(x(8), y(20), x(22), y(10), x(35), y(13))
    // Center top bump
    ..cubicTo(x(38), y(2), x(55), y(-2), x(65), y(8))
    // Top-right bump
    ..cubicTo(x(75), y(2), x(92), y(8), x(92), y(23))
    // Right side down
    ..cubicTo(x(105), y(25), x(105), y(48), x(88), y(55))
    // Bottom (flat)
    ..lineTo(x(15), y(55))
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
