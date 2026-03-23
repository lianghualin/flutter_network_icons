# TopologyView Icon Theme — Design Spec

**Date:** 2026-03-23
**Status:** Approved
**Goal:** Create a flat icon set and theme API for the topology_view package, allowing users to choose built-in icon groups or provide custom ones per device type.

---

## Overview

Two deliverables:

1. **18 flat SVG icons** (9 device types x normal/error) shipped with the `topology_view` package
2. **`TopoIconTheme` API** added to the `topology_view` package, mapping device types to icon assets

This project creates the SVG icon assets. The API integration into `topology_view` is a separate task (documented here for reference but implemented in the `topology_view` project).

---

## Project Location

```
/Users/hualinliang/Project/
├── lnm_frontend/          # consumer app
├── topology_view/         # topology widget package
└── topology_view_icons/   # THIS PROJECT — icon design & assets
    ├── docs/
    │   └── 2026-03-23-icon-theme-design.md
    └── assets/flat/       # 18 SVG files
```

After icons are finalized, they get copied into `topology_view/assets/images/flat/`.

---

## Device Types

```dart
enum TopoDeviceType {
  network,    // cloud shape — network/subnet
  switch_,    // network switch
  host,       // host machine / workstation
  dpu,        // data processing unit
  router,     // router
  firewall,   // security boundary
  server,     // server / rack unit
  generic,    // circle — generic fallback
  unknown,    // question mark — unidentified device
}
```

---

## SVG Design Rules

- **Viewbox:** `0 0 80 80` (square, consistent across all icons)
- **Style:** Flat, minimal, single-color fill with optional subtle stroke
- **Normal color:** `#4B7BEC` (blue) with lighter fill `#D6E4FF` for body
- **Error color:** `#E74C3C` (red) with lighter fill `#FDDFDF` for body
- **Must use `<path>` elements** — required for `SvgCacheManager.getPath()` clipper
- **No `<text>` elements** — labels are rendered by the node layer
- **Clean silhouette** — recognizable at 60-80px display size
- **Consistent padding** — ~4px inset from viewbox edges

---

## Icon Shapes

| Device | Shape | Description |
|--------|-------|-------------|
| **Network** | Cloud | 3-4 bumps on top, flat bottom. Classic network cloud silhouette. |
| **Switch** | Rectangular box | Horizontal rectangle with small port indicators on front face. Directional arrows inside. |
| **Host** | Monitor | Simplified monitor with stand/base. Screen area visible. |
| **DPU** | Vertical rack unit | Tall narrow rectangle with two small port squares. Resembles a blade server. |
| **Router** | Circle with arrows | Circular body with four directional arrows pointing outward (N/S/E/W). |
| **Firewall** | Shield | Classic shield shape. Solid fill. |
| **Server** | Stacked rectangles | 2-3 horizontal stacked rectangles representing a rack server. |
| **Generic** | Circle | Simple filled circle with thin stroke. Default for untyped nodes. |
| **Unknown** | Circle + question mark | Circle with a `?` cutout or overlay. |

---

## File Listing

```
assets/flat/
├── network_normal.svg
├── network_error.svg
├── switch_normal.svg
├── switch_error.svg
├── host_normal.svg
├── host_error.svg
├── dpu_normal.svg
├── dpu_error.svg
├── router_normal.svg
├── router_error.svg
├── firewall_normal.svg
├── firewall_error.svg
├── server_normal.svg
├── server_error.svg
├── generic_normal.svg
├── generic_error.svg
├── unknown_normal.svg
└── unknown_error.svg
```

---

## TopoIconTheme API (for topology_view package)

### New file: `lib/src/models/topo_icon_theme.dart`

```dart
/// A pair of normal/error icon asset paths.
class IconPair {
  final String normal;
  final String error;
  const IconPair(this.normal, this.error);
}

/// Maps device types to icon assets.
class TopoIconTheme {
  final IconPair network;
  final IconPair switch_;
  final IconPair host;
  final IconPair dpu;
  final IconPair router;
  final IconPair firewall;
  final IconPair server;
  final IconPair generic;
  final IconPair unknown;

  const TopoIconTheme({
    required this.network,
    required this.switch_,
    required this.host,
    required this.dpu,
    required this.router,
    required this.firewall,
    required this.server,
    required this.generic,
    required this.unknown,
  });

  /// Look up the icon pair for a device type.
  IconPair forType(TopoDeviceType type) {
    switch (type) {
      case TopoDeviceType.network:  return network;
      case TopoDeviceType.switch_:  return switch_;
      case TopoDeviceType.host:     return host;
      case TopoDeviceType.dpu:      return dpu;
      case TopoDeviceType.router:   return router;
      case TopoDeviceType.firewall: return firewall;
      case TopoDeviceType.server:   return server;
      case TopoDeviceType.generic:  return generic;
      case TopoDeviceType.unknown:  return unknown;
    }
  }

  /// Built-in simplified flat icon set.
  static const flat = TopoIconTheme(
    network:  IconPair('assets/images/flat/network_normal.svg',  'assets/images/flat/network_error.svg'),
    switch_:  IconPair('assets/images/flat/switch_normal.svg',   'assets/images/flat/switch_error.svg'),
    host:     IconPair('assets/images/flat/host_normal.svg',     'assets/images/flat/host_error.svg'),
    dpu:      IconPair('assets/images/flat/dpu_normal.svg',      'assets/images/flat/dpu_error.svg'),
    router:   IconPair('assets/images/flat/router_normal.svg',   'assets/images/flat/router_error.svg'),
    firewall: IconPair('assets/images/flat/firewall_normal.svg', 'assets/images/flat/firewall_error.svg'),
    server:   IconPair('assets/images/flat/server_normal.svg',   'assets/images/flat/server_error.svg'),
    generic:  IconPair('assets/images/flat/generic_normal.svg',  'assets/images/flat/generic_error.svg'),
    unknown:  IconPair('assets/images/flat/unknown_normal.svg',  'assets/images/flat/unknown_error.svg'),
  );
}
```

### Changes to `TopoNode`

```dart
class TopoNode {
  // ... existing fields ...
  final TopoDeviceType? deviceType;  // NEW — pick icon from theme
}
```

### Changes to `TopologyView`

```dart
class TopologyView extends StatefulWidget {
  // ... existing params ...
  final TopoIconTheme? iconTheme;  // NEW — defaults to TopoIconTheme.flat
}
```

### Icon Resolution Order (in node_layer.dart)

1. `TopoNode.iconAsset` / `errorIconAsset` if set → use directly (explicit override)
2. `TopoNode.deviceType` + `TopologyView.iconTheme` → `iconTheme.forType(deviceType)`
3. `TopologyView.iconTheme.generic` fallback if no deviceType
4. Colored circle fallback if no theme at all

### Cloud Clip Mode

`useCloudClip` applies when `deviceType == TopoDeviceType.network` (not just when `enableGrouping` is true). This ensures cloud icons get the correct clip scaling regardless of grouping mode.

### Barrel Export

```dart
// topology_view.dart
export 'src/models/topo_node.dart';        // includes TopoDeviceType enum
export 'src/models/topo_connection.dart';
export 'src/models/topo_icon_theme.dart';  // NEW
export 'src/topology_view_widget.dart';
```

### pubspec.yaml Addition

```yaml
flutter:
  assets:
    - assets/images/
    - assets/images/flat/
```

---

## Backward Compatibility

Fully backward compatible:
- `TopoNode.deviceType` defaults to `null` → existing code unchanged
- `TopologyView.iconTheme` defaults to `null` → falls back to `iconAsset` as before
- `iconAsset` always wins over theme (explicit override)

Consumer migration is optional:

```dart
// Before (still works)
TopoNode(id: 'sw-01', label: 'Switch', iconAsset: 'my/switch.svg', errorIconAsset: 'my/switch_err.svg')

// After (simpler with theme)
TopoNode(id: 'sw-01', label: 'Switch', deviceType: TopoDeviceType.switch_)
```

---

## Implementation Scope

### This project (topology_view_icons)
- Design and create 18 flat SVG icon files
- Verify each SVG has `<path>` elements and works with `SvgCacheManager.getPath()`

### Separate task (topology_view project)
- Add `TopoDeviceType` enum to `topo_node.dart`
- Create `topo_icon_theme.dart`
- Add `iconTheme` param to `TopologyView`
- Update icon resolution in `node_layer.dart`
- Copy finalized SVGs into `assets/images/flat/`
- Update `pubspec.yaml`
- Update example playground with theme support

---

## Out of Scope

- Multiple built-in themes (only `flat` for now; more can be added later)
- Animated/interactive icons
- Icon size customization per device type (uniform size for now)
- Dark mode variant icons (single color scheme works in both modes)
