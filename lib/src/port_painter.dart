import 'package:flutter/material.dart';
import 'icon_style.dart';
import 'port_colors.dart';
import 'shapes/port_shape.dart';
import 'shapes_lnm/port_lnm.dart';

/// CustomPainter for RJ45 Ethernet port icons.
///
/// Uses [isUp] and [isDisabled] for three visual states:
/// - `isDisabled: true` → Admin Down (dark grey) — overrides [isUp]
/// - `isUp: true` → Link Up (green)
/// - `isUp: false` → Link Down (light grey)
class TopoPortPainter extends CustomPainter {
  final bool isUp;
  final bool isDisabled;
  final TopoIconStyle style;

  const TopoPortPainter({
    this.isUp = true,
    this.isDisabled = false,
    this.style = TopoIconStyle.flat,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final padded = rect.deflate(size.width * 0.05);

    switch (style) {
      case TopoIconStyle.flat:
        _paintFlat(canvas, padded);
      case TopoIconStyle.lnm:
        paintPortLnmIcon(canvas, padded, isUp, isDisabled);
    }
  }

  void _paintFlat(Canvas canvas, Rect padded) {
    final Color stroke;
    final Color fill;

    if (isDisabled) {
      stroke = PortColors.disabledStroke;
      fill = PortColors.disabledFill;
    } else if (isUp) {
      stroke = PortColors.upStroke;
      fill = PortColors.upFill;
    } else {
      stroke = PortColors.downStroke;
      fill = PortColors.downFill;
    }

    paintPortIcon(canvas, padded, stroke, fill);
  }

  @override
  bool shouldRepaint(covariant TopoPortPainter oldDelegate) {
    return oldDelegate.isUp != isUp ||
        oldDelegate.isDisabled != isDisabled ||
        oldDelegate.style != style;
  }
}
