import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:topology_view_icons/src/port_colors.dart';
import 'package:topology_view_icons/src/port_painter.dart';
import 'package:topology_view_icons/src/icon_style.dart';

void main() {
  group('PortColors', () {
    test('upStroke is professional green', () {
      expect(PortColors.upStroke, const Color(0xFF27AE60));
    });

    test('downStroke is light grey', () {
      expect(PortColors.downStroke, const Color(0xFFAAAAAA));
    });

    test('disabledStroke is dark grey', () {
      expect(PortColors.disabledStroke, const Color(0xFF666666));
    });
  });

  group('TopoPortPainter', () {
    test('defaults to isUp=true, isDisabled=false, flat style', () {
      const painter = TopoPortPainter();
      expect(painter.isUp, true);
      expect(painter.isDisabled, false);
      expect(painter.style, TopoIconStyle.flat);
    });

    test('shouldRepaint returns true when isUp changes', () {
      const a = TopoPortPainter(isUp: true);
      const b = TopoPortPainter(isUp: false);
      expect(a.shouldRepaint(b), true);
    });

    test('shouldRepaint returns true when isDisabled changes', () {
      const a = TopoPortPainter(isDisabled: true);
      const b = TopoPortPainter(isDisabled: false);
      expect(a.shouldRepaint(b), true);
    });

    test('shouldRepaint returns true when style changes', () {
      const a = TopoPortPainter(style: TopoIconStyle.flat);
      const b = TopoPortPainter(style: TopoIconStyle.lnm);
      expect(a.shouldRepaint(b), true);
    });

    test('shouldRepaint returns false when nothing changes', () {
      const a = TopoPortPainter();
      const b = TopoPortPainter();
      expect(a.shouldRepaint(b), false);
    });

    test('paint does not throw for all state/style combinations', () {
      for (final style in TopoIconStyle.values) {
        for (final isUp in [true, false]) {
          for (final isDisabled in [true, false]) {
            final painter = TopoPortPainter(
              isUp: isUp,
              isDisabled: isDisabled,
              style: style,
            );
            final recorder = PictureRecorder();
            final canvas = Canvas(recorder);
            expect(
              () => painter.paint(canvas, const Size(80, 80)),
              returnsNormally,
            );
          }
        }
      }
    });
  });
}
