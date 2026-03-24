# LNM Hardware Icon Group — Design Spec

**Date:** 2026-03-24
**Status:** Approved
**Goal:** Add a second icon group ("LNM") replicating the lnm_frontend hardware illustration style as canvas painters, alongside the existing "flat" group.

---

## Overview

9 new painter files replicating the hardware-style device icons from `lnm_frontend/dependencies/`. 5 are replicated from existing SVGs, 4 are new designs in matching style.

---

## Icon Inventory

| Device | Source | Normal Colors | Error Colors |
|--------|--------|---------------|--------------|
| **Switch** | `switch_float.svg` / `switch_abnormal.svg` | Chassis: `#A8A8BD` silver + `#6E6E96` dark grey. LEDs: `#48B2B1` teal, `#E68C7C` coral, `#9E9E9E` grey | Chassis: `#F56666` + `#BD0000` red. LEDs unchanged. |
| **Host** | `host_float.svg` / `host_abnormal.svg` | Body: `#4B6182` navy. Screen: `#D8D8D8`. Stand: `#2E3D50` dark navy. | Screen turns `#D03E3E` red. Body unchanged. |
| **DPU** | `dpu_float.svg` / `dpu_abnormal.svg` | Body: `#292626` near-black. Ports/LEDs: `#D8D8D8`. Border: `#979797`. | Body turns `#DF3232` red. Ports unchanged. |
| **Network** | NEW (replacing green ellipse placeholder) | Cloud shape: `#4CAF50` green fill, `#2E7D32` dark green stroke. | `#F44336` red fill, `#D32F2F` dark red stroke. |
| **Unknown** | `unknown_float.svg` | Monitor: `#000000`. Screen: `#FFFFFF`. `?` mark: `#F68917` orange, `#FFD089` stroke. | `?` mark turns `#E74C3C` red. |
| **Router** | NEW — hardware style | Silver box `#A8A8BD` with antennas, ports, arrows. Teal antenna LEDs. | Chassis turns `#F56666` + `#BD0000`. |
| **Firewall** | NEW — hardware style | Grey rack `#6E6E96` with shield emblem + lock. Panel: `#A8A8BD`. | Chassis turns red. Shield turns `#BD0000`. |
| **Server** | NEW — hardware style | 3 stacked units `#A8A8BD`, port slots `#6E6E96`, colored LEDs. | Units turn `#F56666`. |
| **Generic** | NEW — hardware style | Simple silver box `#A8A8BD` with LEDs and port. | Chassis turns `#F56666` + `#BD0000`. |

---

## Shape Descriptions

**Switch:** Horizontal chassis with tapered top hood (trapezoidal), flat bottom panel. Two rows of rounded rectangular port slots. Three colored LED circles (teal, coral, grey) on the right of each row. Directional arrows in the hood area.

**Host:** Monitor with rectangular screen area (rounded corners), narrow neck column, wide curved base/stand. Screen fills most of the monitor body. Shadow effect on stand via darker color.

**DPU:** Tall vertical rack unit (portrait orientation). Rounded rectangle body. Row of small LED indicator circles near the top. Two square port areas (NETA/NETB) in the lower section.

**Network:** Classic cloud silhouette with 3-4 bumps on top, flat bottom. Smooth bezier curves. Simple fill + stroke.

**Unknown:** Desktop monitor (same proportions as host but with black body). White screen area. Large orange `?` question mark centered on screen — drawn as a curved path (arc for the hook) + filled circle for the dot.

**Router:** Horizontal silver box. Two antennas rising from top (diagonal lines with teal circle tips). Row of 4 rectangular ports on the front. Bidirectional arrows. Two LED indicators (teal + coral).

**Firewall:** Square grey rack enclosure. Inner silver panel. Shield emblem centered (classic shield path with lock icon inside). Single teal LED in corner.

**Server:** Three vertically stacked rack units, each a rounded rectangle. Each unit has a horizontal port slot bar on the left and 2 LED circles on the right (varying colors: teal, coral, grey).

**Generic:** Simple rounded rectangular box. Subtle inner panel area. Two LED indicators and one port rectangle. Minimal detail — recognizable as "some network device."

---

## API Changes

### New enum

```dart
enum TopoIconStyle { flat, lnm }
```

Add to `lib/src/device_type.dart` (or new file `lib/src/icon_style.dart`).

### Updated TopoIconPainter

```dart
class TopoIconPainter extends CustomPainter {
  final TopoDeviceType deviceType;
  final bool isError;
  final TopoIconStyle style;  // NEW — defaults to flat

  const TopoIconPainter({
    required this.deviceType,
    this.isError = false,
    this.style = TopoIconStyle.flat,
  });
}
```

The `paint()` method dispatches to `shapes/` or `shapes_lnm/` based on `style`.

### New barrel exports

```dart
export 'src/icon_style.dart';          // TopoIconStyle enum
export 'src/shapes_lnm/switch_lnm.dart';
export 'src/shapes_lnm/host_lnm.dart';
// ... etc for all 9
```

---

## File Structure

```
lib/src/
├── shapes/          # existing flat icons (unchanged)
├── shapes_lnm/     # NEW — LNM hardware style
│   ├── network_lnm.dart
│   ├── switch_lnm.dart
│   ├── host_lnm.dart
│   ├── dpu_lnm.dart
│   ├── router_lnm.dart
│   ├── firewall_lnm.dart
│   ├── server_lnm.dart
│   ├── generic_lnm.dart
│   └── unknown_lnm.dart
├── icon_style.dart  # NEW — TopoIconStyle enum
├── lnm_colors.dart  # NEW — LNM color constants
└── topo_icon_painter.dart  # MODIFIED — add style parameter
```

---

## LNM Color Constants

```dart
class LnmIconColors {
  // Chassis
  static const silverChassis = Color(0xFFA8A8BD);
  static const darkGrey = Color(0xFF6E6E96);
  static const navy = Color(0xFF4B6182);
  static const darkNavy = Color(0xFF2E3D50);
  static const nearBlack = Color(0xFF292626);
  static const border = Color(0xFF979797);
  static const lightGrey = Color(0xFFD8D8D8);

  // LEDs
  static const tealLed = Color(0xFF48B2B1);
  static const coralLed = Color(0xFFE68C7C);
  static const greyLed = Color(0xFF9E9E9E);

  // Error
  static const errorLight = Color(0xFFF56666);
  static const errorDark = Color(0xFFBD0000);
  static const errorScreen = Color(0xFFD03E3E);
  static const dpuError = Color(0xFFDF3232);

  // Network cloud
  static const cloudGreen = Color(0xFF4CAF50);
  static const cloudGreenStroke = Color(0xFF2E7D32);
  static const cloudRed = Color(0xFFF44336);
  static const cloudRedStroke = Color(0xFFD32F2F);

  // Unknown
  static const questionOrange = Color(0xFFF68917);
  static const questionOrangeStroke = Color(0xFFFFD089);
  static const questionRed = Color(0xFFE74C3C);
}
```

---

## Example Gallery Update

Add a **Style toggle** (`SegmentedButton`) alongside the existing Normal/Error toggle:

```
[Flat ◉] [LNM ○]     [Normal ◉] [Error ○]     Size: ──●── 80px
```

The grid shows the same 9 device types but renders with the selected style.

---

## Aspect Ratio

Original LNM SVGs have varying aspect ratios (switch 300x170, DPU 133x355, host 202x170). The canvas painters draw within a square `bounds` Rect but maintain the original proportions by:
- Using the constrained dimension (fit within bounds)
- Centering the shape in the remaining space

Each shape function receives `Rect bounds` and calculates its own internal layout.
