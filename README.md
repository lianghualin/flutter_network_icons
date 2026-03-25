# topology_view_icons

Canvas-drawn network topology device icons for Flutter. Provides a `TopoIconPainter` CustomPainter with 10 device types in 2 visual styles (flat and LNM hardware).

![Icon Gallery Example](https://raw.githubusercontent.com/lianghualin/flutter_network_icons/main/doc/example.png)

## Features

- **10 device types + port:** Network (cloud), Switch, Host, Agent, Router, Firewall, Server, Generic, Unknown, Switch Unknown
- **2 icon styles:** Flat (minimal, blue/red) and LNM (hardware illustration)
- **Normal + Error states** for each icon
- **Pure Canvas drawing** — no SVG files, no asset loading, no parsing overhead
- **Scales to any size** — all coordinates are relative to bounds

## Usage

```dart
import 'package:topology_view_icons/topology_view_icons.dart';

// Use as a CustomPaint widget
CustomPaint(
  size: const Size(80, 80),
  painter: TopoIconPainter(
    deviceType: TopoDeviceType.switch_,
    isError: false,
    style: TopoIconStyle.flat,
  ),
)
```

## Device Types

| Type | Description |
|------|-------------|
| `network` | Cloud silhouette (network/subnet) |
| `switch_` | Network switch with ports |
| `host` | Monitor with stand |
| `agent` | Vertical rack unit |
| `router` | Circle with directional arrows |
| `firewall` | Shield shape |
| `server` | Stacked rack units |
| `generic` | Simple circle |
| `unknown` | Ghost host + magnifying glass with ? |
| `switchUnknown` | Ghost switch + magnifying glass with ? |
| `port` (via `TopoPortPainter`) | RJ45 Ethernet port with Link Up/Down/Admin Down states |

## Icon Styles

- **`TopoIconStyle.flat`** — Minimal flat icons. Normal: blue (`#4B7BEC`), Error: red (`#E74C3C`).
- **`TopoIconStyle.lnm`** — Hardware-style illustrations matching LNM network management UI. Uses chassis greys, navy blues, teal/coral LEDs.

## Port Icon

The port uses a separate `TopoPortPainter` with richer state control:

```dart
CustomPaint(
  size: const Size(80, 80),
  painter: TopoPortPainter(
    isUp: true,        // link up (green) vs link down (grey)
    isDisabled: false,  // admin down (dark grey) — overrides isUp
    style: TopoIconStyle.flat,
  ),
)
```

| State | `isDisabled` | `isUp` | Flat Color |
|-------|-------------|--------|------------|
| Link Up | `false` | `true` | Green |
| Link Down | `false` | `false` | Light grey |
| Admin Down | `true` | — | Dark grey |

## Example

Run the interactive gallery:

```bash
cd example
flutter run -d chrome
```

The gallery lets you toggle between Flat/LNM styles, Normal/Error states, and adjust icon size with a slider.
