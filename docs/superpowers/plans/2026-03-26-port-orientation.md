# Port Orientation Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add 4-direction rotation (up, down, left, right) to `TopoPortPainter` via a `PortDirection` enum and canvas transform.

**Architecture:** New `PortDirection` enum with a `radians` getter. `TopoPortPainter` accepts an optional `direction` parameter (defaults to `up`). In `paint()`, the canvas is rotated around the center before delegating to existing shape functions — no changes to shape code.

**Tech Stack:** Flutter/Dart, `CustomPainter`, `canvas.rotate`

---

### Task 1: Create `PortDirection` enum with tests

**Files:**
- Create: `lib/src/port_direction.dart`
- Create: `test/port_direction_test.dart`

- [ ] **Step 1: Write the failing test**

Create `test/port_direction_test.dart`:

```dart
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
```

- [ ] **Step 2: Run test to verify it fails**

Run: `cd example && cd .. && flutter test test/port_direction_test.dart`
Expected: FAIL — `port_direction.dart` does not exist yet.

- [ ] **Step 3: Write minimal implementation**

Create `lib/src/port_direction.dart`:

```dart
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
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/port_direction_test.dart`
Expected: All 5 tests PASS.

- [ ] **Step 5: Commit**

```bash
git add lib/src/port_direction.dart test/port_direction_test.dart
git commit -m "feat: add PortDirection enum with radians getter"
```

---

### Task 2: Add `direction` parameter to `TopoPortPainter` with canvas rotation

**Files:**
- Modify: `lib/src/port_painter.dart:1-61`
- Modify: `test/port_painter_test.dart:1-75`

- [ ] **Step 1: Write the failing tests**

Add these tests to `test/port_painter_test.dart`. Insert a new import at the top and new test groups inside the existing `TopoPortPainter` group.

Add import at top of file (after the existing imports):

```dart
import 'package:topology_view_icons/src/port_direction.dart';
```

Add these tests inside the `group('TopoPortPainter', () {` block, after the existing `paint does not throw` test (after line 73):

```dart
    test('defaults to direction=PortDirection.up', () {
      const painter = TopoPortPainter();
      expect(painter.direction, PortDirection.up);
    });

    test('shouldRepaint returns true when direction changes', () {
      const a = TopoPortPainter(direction: PortDirection.up);
      const b = TopoPortPainter(direction: PortDirection.down);
      expect(a.shouldRepaint(b), true);
    });

    test('shouldRepaint returns false when direction is the same', () {
      const a = TopoPortPainter(direction: PortDirection.left);
      const b = TopoPortPainter(direction: PortDirection.left);
      expect(a.shouldRepaint(b), false);
    });

    test('paint does not throw for all direction/style/state combinations', () {
      for (final direction in PortDirection.values) {
        for (final style in TopoIconStyle.values) {
          for (final isUp in [true, false]) {
            for (final isDisabled in [true, false]) {
              final painter = TopoPortPainter(
                isUp: isUp,
                isDisabled: isDisabled,
                style: style,
                direction: direction,
              );
              final recorder = PictureRecorder();
              final canvas = Canvas(recorder);
              expect(
                () => painter.paint(canvas, const Size(80, 80)),
                returnsNormally,
                reason:
                    'direction=$direction style=$style isUp=$isUp isDisabled=$isDisabled',
              );
            }
          }
        }
      }
    });
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `flutter test test/port_painter_test.dart`
Expected: FAIL — `TopoPortPainter` does not accept `direction` parameter yet.

- [ ] **Step 3: Update `TopoPortPainter` implementation**

Edit `lib/src/port_painter.dart` to the following complete content:

```dart
import 'package:flutter/material.dart';
import 'icon_style.dart';
import 'port_colors.dart';
import 'port_direction.dart';
import 'shapes/port_shape.dart';
import 'shapes_lnm/port_lnm.dart';

/// CustomPainter for RJ45 Ethernet port icons.
///
/// Uses [isUp] and [isDisabled] for three visual states:
/// - `isDisabled: true` → Admin Down (dark grey) — overrides [isUp]
/// - `isUp: true` → Link Up (green)
/// - `isUp: false` → Link Down (light grey)
///
/// Use [direction] to rotate the port icon (default: [PortDirection.up]).
class TopoPortPainter extends CustomPainter {
  final bool isUp;
  final bool isDisabled;
  final TopoIconStyle style;
  final PortDirection direction;

  const TopoPortPainter({
    this.isUp = true,
    this.isDisabled = false,
    this.style = TopoIconStyle.flat,
    this.direction = PortDirection.up,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();

    final cx = size.width / 2;
    final cy = size.height / 2;
    canvas.translate(cx, cy);
    canvas.rotate(direction.radians);
    canvas.translate(-cx, -cy);

    final rect = Offset.zero & size;
    final padded = rect.deflate(size.width * 0.05);

    switch (style) {
      case TopoIconStyle.flat:
        _paintFlat(canvas, padded);
      case TopoIconStyle.lnm:
        paintPortLnmIcon(canvas, padded, isUp, isDisabled);
    }

    canvas.restore();
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
        oldDelegate.style != style ||
        oldDelegate.direction != direction;
  }
}
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `flutter test test/port_painter_test.dart`
Expected: All tests PASS (existing + new).

- [ ] **Step 5: Commit**

```bash
git add lib/src/port_painter.dart test/port_painter_test.dart
git commit -m "feat: add direction parameter to TopoPortPainter with canvas rotation"
```

---

### Task 3: Export `PortDirection` from barrel file

**Files:**
- Modify: `lib/topology_view_icons.dart:31-35`

- [ ] **Step 1: Add export**

In `lib/topology_view_icons.dart`, add the `port_direction.dart` export. Insert after the `// Port icon` comment line (line 31) and before `export 'src/port_colors.dart';` (line 32):

```dart
export 'src/port_direction.dart';
```

- [ ] **Step 2: Verify the library resolves**

Run: `flutter analyze`
Expected: No errors.

- [ ] **Step 3: Commit**

```bash
git add lib/topology_view_icons.dart
git commit -m "feat: export PortDirection from barrel file"
```

---

### Task 4: Add direction toggle to example gallery

**Files:**
- Modify: `example/lib/main.dart:46-249`

- [ ] **Step 1: Add `_portDirection` state field**

In `example/lib/main.dart`, inside `_GalleryPageState` (after line 51, after `bool _portIsDisabled = false;`), add:

```dart
  PortDirection _portDirection = PortDirection.up;
```

- [ ] **Step 2: Add direction toggle row to `_buildPortSection`**

In the `_buildPortSection` method, insert a direction toggle row after the state toggle row. After the closing `),` of the state `Row` widget (line 188) and before `const SizedBox(height: 16),` (line 189), add:

```dart
        const SizedBox(height: 12),
        // Port direction toggle
        Row(
          children: [
            const Text('Direction:', style: TextStyle(fontSize: 14)),
            const SizedBox(width: 12),
            SegmentedButton<PortDirection>(
              segments: const [
                ButtonSegment(
                  value: PortDirection.up,
                  label: Text('Up'),
                ),
                ButtonSegment(
                  value: PortDirection.down,
                  label: Text('Down'),
                ),
                ButtonSegment(
                  value: PortDirection.left,
                  label: Text('Left'),
                ),
                ButtonSegment(
                  value: PortDirection.right,
                  label: Text('Right'),
                ),
              ],
              selected: {_portDirection},
              onSelectionChanged: (v) =>
                  setState(() => _portDirection = v.first),
            ),
          ],
        ),
```

- [ ] **Step 3: Pass direction to `TopoPortPainter` in `_buildPortCard`**

In the `_buildPortCard` method, update the `TopoPortPainter` constructor call (around line 226) to include `direction`:

```dart
              painter: TopoPortPainter(
                isUp: _portIsUp,
                isDisabled: _portIsDisabled,
                style: _style,
                direction: _portDirection,
              ),
```

- [ ] **Step 4: Verify example compiles and runs**

Run: `cd example && flutter analyze`
Expected: No errors.

- [ ] **Step 5: Commit**

```bash
git add example/lib/main.dart
git commit -m "feat: add direction toggle to example gallery port section"
```

---

### Task 5: Run full test suite and verify

**Files:** None (verification only)

- [ ] **Step 1: Run all tests**

Run: `flutter test`
Expected: All tests PASS.

- [ ] **Step 2: Run analyzer on entire project**

Run: `flutter analyze`
Expected: No issues found.

- [ ] **Step 3: Final commit (if any cleanup needed)**

If all passes cleanly, no commit needed. Otherwise commit any fixes.
