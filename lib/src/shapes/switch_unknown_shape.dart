import 'package:flutter/material.dart';
import '../question_mark_painter.dart';

/// Switch Unknown: ghost switch (20% opacity) with centered magnifying glass
/// and bold ? inside. Red badge top-right.
void paintSwitchUnknownIcon(Canvas canvas, Rect bounds, Color stroke, Color fill) {
  final w = bounds.width;
  final h = bounds.height;
  final l = bounds.left;
  final t = bounds.top;

  double x(double v) => l + (v / 80) * w;
  double y(double v) => t + (v / 80) * h;
  double s(double v) => (v / 80) * w;

  // Ghost switch body (20% opacity)
  final ghostFill = fill.withValues(alpha: 0.2);
  final ghostStroke = stroke.withValues(alpha: 0.2);

  final bodyRect = RRect.fromRectAndRadius(
    Rect.fromLTRB(x(4), y(25), x(76), y(55)),
    Radius.circular(s(4)),
  );
  canvas.drawRRect(bodyRect, Paint()..color = ghostFill);
  canvas.drawRRect(
    bodyRect,
    Paint()
      ..color = ghostStroke
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2,
  );

  // Ghost ports
  for (int i = 0; i < 4; i++) {
    final portX = x(12 + i * 15.0);
    canvas.drawRect(
      Rect.fromLTRB(portX, y(42), portX + s(10), y(48)),
      Paint()..color = ghostStroke,
    );
  }

  // Centered magnifying glass lens
  final lensCenter = Offset(x(40), y(40));
  final lensRadius = s(16);
  canvas.drawCircle(
    lensCenter,
    lensRadius,
    Paint()..color = Colors.white.withValues(alpha: 0.45),
  );
  canvas.drawCircle(
    lensCenter,
    lensRadius,
    Paint()
      ..color = stroke
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2,
  );

  // Handle (45° from lens)
  canvas.drawLine(
    Offset(x(52), y(52)),
    Offset(x(62), y(62)),
    Paint()
      ..color = stroke
      ..strokeWidth = s(2.5)
      ..strokeCap = StrokeCap.round,
  );

  // Bold ? inside lens (using TextPainter for proper glyph)
  paintQuestionMark(
    canvas,
    center: lensCenter,
    size: s(26),
    color: stroke,
  );

  // Red badge top-right
  final badgeCenter = Offset(x(70), y(22));
  canvas.drawCircle(badgeCenter, s(5), Paint()..color = const Color(0xFFE8554E));
  canvas.drawCircle(
    badgeCenter,
    s(5),
    Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = s(1.3),
  );
}
