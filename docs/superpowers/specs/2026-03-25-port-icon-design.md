# Port Icon Design Spec

## Goal

Add an RJ45 Ethernet port icon to the `topology_view_icons` package with three visual states (Link Up, Link Down, Admin Down) in both flat and LNM styles.

## Context

The existing package provides 10 device types via `TopoDeviceType` enum, rendered through `TopoIconPainter` with a single `isError` boolean for state. The port icon requires richer state semantics (`isUp` + `isDisabled`), so it gets a dedicated `TopoPortPainter` class rather than being added to the enum.

## API

### TopoPortPainter

A new `CustomPainter` class, separate from `TopoIconPainter`.

```dart
class TopoPortPainter extends CustomPainter {
  final bool isUp;           // true = link up, false = link down
  final bool isDisabled;     // true = admin down (overrides isUp)
  final TopoIconStyle style; // flat or lnm

  const TopoPortPainter({
    this.isUp = true,
    this.isDisabled = false,
    this.style = TopoIconStyle.flat,
  });
}
```

**State resolution:** `isDisabled: true` takes priority — always renders Admin Down regardless of `isUp`.

| `isDisabled` | `isUp` | Rendered State |
|---|---|---|
| `true` | (ignored) | Admin Down |
| `false` | `true` | Link Up |
| `false` | `false` | Link Down |

**`paint()` method:** Applies 5% padding (same as `TopoIconPainter`), then switches on `style`:
- **Flat path:** Resolves `PortColors` stroke/fill from state, calls `paintPortIcon(canvas, bounds, stroke, fill)`.
- **LNM path:** Calls `paintPortLnmIcon(canvas, bounds, isUp, isDisabled)`.

The flat function takes pre-resolved colors (consistent with existing flat shape signatures like `paintGenericIcon`). The LNM function takes booleans because it manages its own color selection internally (consistent with LNM convention, adapted for port's two-boolean state).

**`shouldRepaint`:** Compares `isUp`, `isDisabled`, and `style`.

**Usage:**

```dart
CustomPaint(
  size: const Size(80, 80),
  painter: TopoPortPainter(
    isUp: true,
    isDisabled: false,
    style: TopoIconStyle.flat,
  ),
)
```

### Port Colors

New `PortColors` class with **flat-style color constants only**. LNM style reuses existing `LnmIconColors` constants directly.

**Flat style colors:**

| State | Stroke | Fill |
|---|---|---|
| Link Up | `#27AE60` (professional green) | `#D4EFDF` (light green) |
| Link Down | `#AAAAAA` (light grey) | `#E8E8E8` (pale grey) |
| Admin Down | `#666666` (dark grey) | `#C0C0C0` (medium grey) |

**LNM style colors:** Uses existing `LnmIconColors` constants. No new LNM colors needed.

| State | Chassis | LED |
|---|---|---|
| Link Up | `LnmIconColors.silverChassis` (#A8A8BD) | `LnmIconColors.tealLed` (#48B2B1) |
| Link Down | `LnmIconColors.silverChassis` (#A8A8BD) | `LnmIconColors.greyLed` (#9E9E9E) |
| Admin Down | `LnmIconColors.darkGrey` (#6E6E96) | `LnmIconColors.nearBlack` (#292626) |

## Visual Design

### Flat Style — RJ45 Port

ViewBox reference: 80 x 80 (consistent with other flat icons like `generic_shape.dart`).

Shape elements:
1. **Port body** — Rounded rectangle, main shape. Fill + stroke colored by state.
2. **Inner cavity** — Slightly smaller rounded rectangle inside the body, darker shade (stroke color at 20% opacity). Represents the recessed connector opening.
3. **Pin contacts** — 8 short vertical lines inside the cavity, evenly spaced. Colored with stroke color. Represents the 8 RJ45 copper contacts.
4. **Clip tab** — Small rounded rectangle below the body. Same fill/stroke as body. Represents the RJ45 latch mechanism.

Function signature (consistent with other flat shapes):

```dart
void paintPortIcon(Canvas canvas, Rect bounds, Color stroke, Color fill)
```

### LNM Hardware Style — RJ45 Port

ViewBox reference: 160 x 130 (width matches `generic_lnm.dart` at 160; height slightly taller than 120 to accommodate the clip tab).

Shape elements:
1. **Metal housing** — Rounded rectangle with chassis color. Stroke with `LnmIconColors.border`. Represents the shielded metal jack housing.
2. **Inner cavity** — Darker recessed rectangle inside housing. Shows the connector opening.
3. **Pin contacts** — 8 vertical lines inside cavity, using `LnmIconColors.lightGrey`.
4. **Clip tab** — Rounded rectangle below housing, same chassis treatment.
5. **LED indicator** — Small circle near top-right of the housing. Color determined by state: `tealLed` (up), `greyLed` (down), `nearBlack` (disabled).

Function signature:

```dart
void paintPortLnmIcon(Canvas canvas, Rect bounds, bool isUp, bool isDisabled)
```

Note: LNM port painter receives `isUp` and `isDisabled` directly instead of the `isError` boolean used by other LNM painters, since port state semantics differ.

## File Structure

New files:

| File | Purpose |
|---|---|
| `lib/src/port_colors.dart` | `PortColors` class with flat-style color constants only |
| `lib/src/port_painter.dart` | `TopoPortPainter` CustomPainter class |
| `lib/src/shapes/port_shape.dart` | Flat-style RJ45 painter function |
| `lib/src/shapes_lnm/port_lnm.dart` | LNM-style RJ45 painter function |

Modified files:

| File | Change |
|---|---|
| `lib/topology_view_icons.dart` | Add exports for new port files |
| `example/lib/main.dart` | Add port icon section with state toggles (default: Link Up) |
| `pubspec.yaml` | Bump version (minor: new public API) |
| `README.md` | Add port to documentation |
| `CHANGELOG.md` | Add entry for port icon |

## Example Gallery Update

The port icon uses different parameters than the existing device icons, so the gallery needs a dedicated section:

- Separate "Port" card below the main device grid
- Three state buttons: Link Up / Link Down / Admin Down (default: Link Up)
- Style toggle (Flat/LNM) shared with the main grid
- Size slider shared with the main grid

## Not In Scope

- Adding `port` to `TopoDeviceType` enum
- Modifying `TopoIconPainter` class
- SFP/fiber port variants (future work if needed)
- Port-unknown variant (no ghost+magnifying glass pattern)
