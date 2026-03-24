import 'package:flutter/material.dart';
import '../lnm_colors.dart';

/// LNM-style firewall: grey outer rack, silver inner panel, shield emblem with
/// lock icon inside, teal LED indicator.
void paintFirewallLnmIcon(Canvas canvas, Rect bounds, bool isError) {
  const svgW = 160.0;
  const svgH = 160.0;
  final scale =
      (bounds.width / svgW).clamp(0.0, bounds.height / svgH).toDouble();
  final drawW = svgW * scale;
  final drawH = svgH * scale;
  final offsetX = bounds.left + (bounds.width - drawW) / 2;
  final offsetY = bounds.top + (bounds.height - drawH) / 2;

  double x(double svgX) => offsetX + svgX * scale;
  double y(double svgY) => offsetY + svgY * scale;
  double s(double v) => v * scale;

  final rackColor = isError ? LnmIconColors.errorDark : LnmIconColors.darkGrey;
  final panelColor =
      isError ? LnmIconColors.errorLight : LnmIconColors.silverChassis;

  // Outer rack
  final outerRect = RRect.fromRectAndRadius(
    Rect.fromLTRB(x(5), y(5), x(155), y(155)),
    Radius.circular(s(10)),
  );
  canvas.drawRRect(outerRect, Paint()..color = rackColor);

  // Inner panel
  final innerRect = RRect.fromRectAndRadius(
    Rect.fromLTRB(x(15), y(15), x(145), y(145)),
    Radius.circular(s(6)),
  );
  canvas.drawRRect(innerRect, Paint()..color = panelColor);

  // Shield emblem (centered)
  final shieldColor =
      isError ? LnmIconColors.errorDark : LnmIconColors.darkGrey;
  final shieldStroke = isError ? LnmIconColors.errorDark : LnmIconColors.navy;

  final shield = Path()
    ..moveTo(x(80), y(30))
    ..lineTo(x(120), y(42))
    ..cubicTo(x(122), y(90), x(115), y(115), x(80), y(130))
    ..cubicTo(x(45), y(115), x(38), y(90), x(40), y(42))
    ..close();

  canvas.drawPath(shield, Paint()..color = shieldColor);
  canvas.drawPath(
    shield,
    Paint()
      ..color = shieldStroke
      ..style = PaintingStyle.stroke
      ..strokeWidth = s(2)
      ..strokeJoin = StrokeJoin.round,
  );

  // Lock icon inside shield
  final lockColor = panelColor;

  // Lock body (rounded rect)
  final lockBody = RRect.fromRectAndRadius(
    Rect.fromLTRB(x(68), y(78), x(92), y(100)),
    Radius.circular(s(3)),
  );
  canvas.drawRRect(lockBody, Paint()..color = lockColor);

  // Lock shackle (arc)
  final shacklePaint = Paint()
    ..color = lockColor
    ..style = PaintingStyle.stroke
    ..strokeWidth = s(3.5)
    ..strokeCap = StrokeCap.round;
  final shackle = Path()
    ..moveTo(x(73), y(78))
    ..cubicTo(x(73), y(62), x(87), y(62), x(87), y(78));
  canvas.drawPath(shackle, shacklePaint);

  // Keyhole dot
  canvas.drawCircle(
    Offset(x(80), y(87)),
    s(2.5),
    Paint()..color = shieldColor,
  );

  // Teal LED indicator (bottom-right of panel)
  canvas.drawCircle(
    Offset(x(132), y(132)),
    s(5),
    Paint()..color = LnmIconColors.tealLed,
  );
}
