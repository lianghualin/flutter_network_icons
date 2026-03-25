import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:topology_view_icons/src/port_colors.dart';

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
}
