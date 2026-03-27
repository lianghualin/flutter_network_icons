## 1.3.0

- New: `PortDirection` enum for 4-direction port orientation (up, down, left, right)
- `TopoPortPainter` now accepts a `direction` parameter (default: `PortDirection.up`)
- Ports rotate via canvas transform — both flat and LNM styles supported
- Narrowed LNM port icon proportions for a more realistic RJ45 look
- Example gallery now includes a direction toggle for port icons

## 1.2.1

- Redesign LNM port icon with bold full-housing state colors (green/grey/black)
- White pin contacts for better contrast
- Removed small LED dot indicator
- Full-width cavity layout

## 1.1.0

- New: RJ45 port icon with `TopoPortPainter`
- Three visual states: Link Up, Link Down, Admin Down
- Flat and LNM hardware styles
- `PortColors` constants for flat-style port colors

## 1.0.0

- Initial release
- 10 device types: network, switch, host, agent, router, firewall, server, generic, unknown, switchUnknown
- 2 icon styles: flat and LNM hardware
- Normal and error states for all icons
- Canvas-drawn with no SVG dependencies
- Interactive example gallery app
