import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:topology_view_icons/src/port_direction.dart';

void main() {
  group('PortDirection', () {
    test('has exactly four values', () {
      expect(PortDirection.values.length, 4);
    });

    test('up returns 0 radians', () {
      expect(PortDirection.up.radians, 0.0);
    });

    test('down returns pi radians', () {
      expect(PortDirection.down.radians, pi);
    });

    test('left returns 3*pi/2 radians', () {
      expect(PortDirection.left.radians, 3 * pi / 2);
    });

    test('right returns pi/2 radians', () {
      expect(PortDirection.right.radians, pi / 2);
    });
  });
}
