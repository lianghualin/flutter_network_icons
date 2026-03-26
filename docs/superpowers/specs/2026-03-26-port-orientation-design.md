# Port Orientation Support

Add 4-direction rotation (up, down, left, right) to `TopoPortPainter` so ports can face any direction when placed around devices in topology views.

## Motivation

Topology views render ports around devices (e.g., semi-elliptical arcs on hosts, two-row switch layouts). Ports need to face different directions depending on their position:

- Top-row ports face up, bottom-row ports face down
- Side-mounted ports face left or right

Without built-in support, consumers must wrap the painter in `Transform.rotate`, which causes layout sizing and hit-testing issues.

## Approach: Canvas Transform

Apply `canvas.save/translate/rotate/restore` in `TopoPortPainter.paint()` before delegating to existing shape functions. The shape drawing code (`paintPortIcon`, `paintPortLnmIcon`) remains completely untouched.

Alternatives considered:
- **Coordinate rewrite** — rewriting all shape coordinates per direction. Rejected: 40+ coordinate sets to maintain (4 directions × 2 styles × 5 elements), high bug risk.
- **External transform widget** — a wrapper widget applying `Transform.rotate`. Rejected: layout/hit-testing issues, doesn't help consumers using `CustomPaint` directly.

## API Design

### New enum: `PortDirection`

File: `lib/src/port_direction.dart`

```dart
enum PortDirection {
  up,     // 0° — connector opening faces up (default)
  down,   // 180° — connector opening faces down
  left,   // 270° — connector opening faces left
  right,  // 90° — connector opening faces right
}
```

Each value exposes a `radians` getter returning the rotation angle.

### Updated `TopoPortPainter`

```dart
class TopoPortPainter extends CustomPainter {
  final bool isUp;
  final bool isDisabled;
  final TopoIconStyle style;
  final PortDirection direction;  // NEW

  const TopoPortPainter({
    this.isUp = true,
    this.isDisabled = false,
    this.style = TopoIconStyle.flat,
    this.direction = PortDirection.up,  // NEW — backward compatible
  });
}
```

### Rotation logic in `paint()`

```dart
@override
void paint(Canvas canvas, Size size) {
  canvas.save();

  final cx = size.width / 2;
  final cy = size.height / 2;
  canvas.translate(cx, cy);
  canvas.rotate(direction.radians);
  canvas.translate(-cx, -cy);

  // Existing shape drawing — unchanged
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
```

`shouldRepaint` updated to include `direction`.

## Bounding Box Behavior

| Direction | Rotation | Consumer sizing |
|-----------|----------|-----------------|
| up        | 0°       | W × H (normal)  |
| down      | 180°     | W × H (normal)  |
| left      | 270°     | H × W (swapped) |
| right     | 90°      | H × W (swapped) |

For square bounding boxes (the common case), all directions work identically with no sizing concerns.

## File Changes

### New file
- `lib/src/port_direction.dart` — `PortDirection` enum with `radians` getter

### Modified files
- `lib/src/port_painter.dart` — add `direction` parameter, canvas transform in `paint()`, update `shouldRepaint`
- `lib/topology_view_icons.dart` — export `port_direction.dart`
- `test/port_painter_test.dart` — add direction tests
- `example/lib/main.dart` — add direction toggle to port section

## Test Plan

### PortDirection enum
- Each value returns correct radians (0, π, 3π/2, π/2)
- All four values are present

### shouldRepaint
- Returns `true` when direction changes
- Returns `false` when direction is the same

### Paint smoke tests
- All 4 directions × 2 styles × 3 states = 24 combinations paint without throwing
- Extends the existing 8-combination smoke test

## Example Gallery Update

Add a direction toggle row below the existing state toggle (Link Up / Link Down / Admin Down) in the port section. Four buttons: Up, Down, Left, Right. Default: Up.

## Backward Compatibility

Fully backward compatible. The `direction` parameter defaults to `PortDirection.up`, so all existing consumer code works unchanged.
