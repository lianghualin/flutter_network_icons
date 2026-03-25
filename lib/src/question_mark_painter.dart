import 'package:flutter/material.dart';

/// Paints a "?" character centered at [center] using TextPainter for
/// proper typographic proportions. [size] is the font size in pixels.
void paintQuestionMark(
  Canvas canvas, {
  required Offset center,
  required double size,
  required Color color,
  double opacity = 0.85,
  FontWeight weight = FontWeight.w400,
}) {
  final textPainter = TextPainter(
    text: TextSpan(
      text: '?',
      style: TextStyle(
        fontSize: size,
        fontWeight: weight,
        color: color.withValues(alpha: opacity),
        fontFamily: 'Arial',
        height: 1.0,
      ),
    ),
    textAlign: TextAlign.center,
    textDirection: TextDirection.ltr,
  );
  textPainter.layout();
  textPainter.paint(
    canvas,
    Offset(
      center.dx - textPainter.width / 2,
      center.dy - textPainter.height / 2,
    ),
  );
}
