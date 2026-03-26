import 'dart:math';

/// Direction a port icon faces — controls canvas rotation.
enum PortDirection {
  up,
  down,
  left,
  right;

  /// Rotation angle in radians (clockwise from up).
  double get radians => switch (this) {
        up => 0.0,
        down => pi,
        left => 3 * pi / 2,
        right => pi / 2,
      };
}
