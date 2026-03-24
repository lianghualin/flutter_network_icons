# Flat Icon Set Creation — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Create 18 flat SVG icons (9 device types x normal/error) for the topology_view package.

**Architecture:** Each SVG follows strict design rules: 80x80 viewbox, `<path>` elements only (no `<circle>`, `<ellipse>`, `<text>`, `<rect>`), `d` attribute first on every `<path>`. Normal icons use blue palette (`#4B7BEC` stroke, `#D6E4FF` fill), error icons use red (`#E74C3C` stroke, `#FDDFDF` fill). All shapes must be recognizable at 60-80px display size.

**Tech Stack:** SVG (hand-authored or path-converted)

**Spec:** `docs/2026-03-23-icon-theme-design.md`

---

## SVG Template

Every icon follows this structure:

```svg
<svg width="80" height="80" viewBox="0 0 80 80" xmlns="http://www.w3.org/2000/svg">
  <path d="..." fill="#D6E4FF" stroke="#4B7BEC" stroke-width="2"/>
  <!-- additional <path> elements as needed -->
</svg>
```

For error variants, swap colors:
- `fill="#D6E4FF"` → `fill="#FDDFDF"`
- `stroke="#4B7BEC"` / `fill="#4B7BEC"` → `stroke="#E74C3C"` / `fill="#E74C3C"`

**Critical rule:** The `d` attribute MUST be the first attribute on every `<path>` element (required by the current `_pathRegex` in `svg_cache.dart`).

---

### Task 1: Create network (cloud) icons

**Files:**
- Create: `assets/flat/network_normal.svg`
- Create: `assets/flat/network_error.svg`

- [ ] **Step 1: Create `network_normal.svg`**

Cloud silhouette with 3-4 bumps on top, flat bottom. All `<path>` elements, blue palette.

```svg
<svg width="80" height="80" viewBox="0 0 80 80" xmlns="http://www.w3.org/2000/svg">
  <path d="M20,55 C10,55 4,48 4,40 C4,33 9,27 16,25 C16,15 24,7 35,7 C43,7 50,12 53,19 C55,18 57,17 60,17 C70,17 76,24 76,33 C76,34 76,35 76,36 C76,36 76,36 76,36 C76,45 70,55 60,55 Z" fill="#D6E4FF" stroke="#4B7BEC" stroke-width="2" stroke-linejoin="round"/>
</svg>
```

- [ ] **Step 2: Create `network_error.svg`**

Same path, red palette:

```svg
<svg width="80" height="80" viewBox="0 0 80 80" xmlns="http://www.w3.org/2000/svg">
  <path d="M20,55 C10,55 4,48 4,40 C4,33 9,27 16,25 C16,15 24,7 35,7 C43,7 50,12 53,19 C55,18 57,17 60,17 C70,17 76,24 76,33 C76,34 76,35 76,36 C76,36 76,36 76,36 C76,45 70,55 60,55 Z" fill="#FDDFDF" stroke="#E74C3C" stroke-width="2" stroke-linejoin="round"/>
</svg>
```

- [ ] **Step 3: Verify both files have `<path>` with `d` first**

Run: `grep -c '<path d=' assets/flat/network_normal.svg assets/flat/network_error.svg`
Expected: Both show `1` (at least one path with `d` as first attribute).

- [ ] **Step 4: Commit**

```bash
cd /Users/hualinliang/Project/topology_view_icons
git add assets/flat/network_normal.svg assets/flat/network_error.svg
git commit -m "feat: add flat network (cloud) icons"
```

---

### Task 2: Create switch icons

**Files:**
- Create: `assets/flat/switch_normal.svg`
- Create: `assets/flat/switch_error.svg`

- [ ] **Step 1: Create `switch_normal.svg`**

Horizontal rectangular box with small port indicators and directional arrows.

```svg
<svg width="80" height="80" viewBox="0 0 80 80" xmlns="http://www.w3.org/2000/svg">
  <!-- Body -->
  <path d="M8,25 L72,25 C74,25 76,27 76,29 L76,51 C76,53 74,55 72,55 L8,55 C6,55 4,53 4,51 L4,29 C4,27 6,25 8,25 Z" fill="#D6E4FF" stroke="#4B7BEC" stroke-width="2"/>
  <!-- Ports -->
  <path d="M14,44 L14,48 L22,48 L22,44 Z" fill="#4B7BEC"/>
  <path d="M26,44 L26,48 L34,48 L34,44 Z" fill="#4B7BEC"/>
  <path d="M38,44 L38,48 L46,48 L46,44 Z" fill="#4B7BEC"/>
  <path d="M50,44 L50,48 L58,48 L58,44 Z" fill="#4B7BEC"/>
  <!-- Arrows -->
  <path d="M22,34 L34,34 L30,31 M34,34 L30,37" fill="none" stroke="#4B7BEC" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
  <path d="M58,34 L46,34 L50,31 M46,34 L50,37" fill="none" stroke="#4B7BEC" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
</svg>
```

- [ ] **Step 2: Create `switch_error.svg`**

Same paths, red palette — replace all `#D6E4FF` with `#FDDFDF`, all `#4B7BEC` with `#E74C3C`.

- [ ] **Step 3: Verify and commit**

```bash
grep -c '<path d=' assets/flat/switch_normal.svg assets/flat/switch_error.svg
git add assets/flat/switch_*.svg
git commit -m "feat: add flat switch icons"
```

---

### Task 3: Create host icons

**Files:**
- Create: `assets/flat/host_normal.svg`
- Create: `assets/flat/host_error.svg`

- [ ] **Step 1: Create `host_normal.svg`**

Simplified monitor with stand/base.

```svg
<svg width="80" height="80" viewBox="0 0 80 80" xmlns="http://www.w3.org/2000/svg">
  <!-- Screen -->
  <path d="M10,12 L70,12 C72,12 74,14 74,16 L74,48 C74,50 72,52 70,52 L10,52 C8,52 6,50 6,48 L6,16 C6,14 8,12 10,12 Z" fill="#D6E4FF" stroke="#4B7BEC" stroke-width="2"/>
  <!-- Screen inner -->
  <path d="M12,16 L68,16 L68,48 L12,48 Z" fill="#4B7BEC" opacity="0.15"/>
  <!-- Stand neck -->
  <path d="M35,52 L45,52 L45,60 L35,60 Z" fill="#4B7BEC"/>
  <!-- Stand base -->
  <path d="M24,60 L56,60 C58,60 58,64 56,64 L24,64 C22,64 22,60 24,60 Z" fill="#D6E4FF" stroke="#4B7BEC" stroke-width="2"/>
</svg>
```

- [ ] **Step 2: Create `host_error.svg`**

Same paths, red palette.

- [ ] **Step 3: Verify and commit**

```bash
grep -c '<path d=' assets/flat/host_normal.svg assets/flat/host_error.svg
git add assets/flat/host_*.svg
git commit -m "feat: add flat host icons"
```

---

### Task 4: Create DPU icons

**Files:**
- Create: `assets/flat/dpu_normal.svg`
- Create: `assets/flat/dpu_error.svg`

- [ ] **Step 1: Create `dpu_normal.svg`**

Vertical rack unit with two port squares.

```svg
<svg width="80" height="80" viewBox="0 0 80 80" xmlns="http://www.w3.org/2000/svg">
  <!-- Body -->
  <path d="M22,6 L58,6 C60,6 62,8 62,10 L62,70 C62,72 60,74 58,74 L22,74 C20,74 18,72 18,70 L18,10 C18,8 20,6 22,6 Z" fill="#D6E4FF" stroke="#4B7BEC" stroke-width="2"/>
  <!-- LED indicators -->
  <path d="M30,14 C30,12.3 31.3,11 33,11 C34.7,11 36,12.3 36,14 C36,15.7 34.7,17 33,17 C31.3,17 30,15.7 30,14 Z" fill="#4B7BEC"/>
  <path d="M44,14 C44,12.3 45.3,11 47,11 C48.7,11 50,12.3 50,14 C50,15.7 48.7,17 47,17 C45.3,17 44,15.7 44,14 Z" fill="#4B7BEC"/>
  <!-- Port A -->
  <path d="M28,50 L38,50 L38,60 L28,60 Z" fill="#4B7BEC" opacity="0.4"/>
  <!-- Port B -->
  <path d="M42,50 L52,50 L52,60 L42,60 Z" fill="#4B7BEC" opacity="0.4"/>
  <!-- Label line -->
  <path d="M28,30 L52,30" fill="none" stroke="#4B7BEC" stroke-width="1.5" opacity="0.5"/>
  <path d="M28,36 L46,36" fill="none" stroke="#4B7BEC" stroke-width="1.5" opacity="0.3"/>
</svg>
```

- [ ] **Step 2: Create `dpu_error.svg`**

Same paths, red palette.

- [ ] **Step 3: Verify and commit**

```bash
grep -c '<path d=' assets/flat/dpu_normal.svg assets/flat/dpu_error.svg
git add assets/flat/dpu_*.svg
git commit -m "feat: add flat DPU icons"
```

---

### Task 5: Create router icons

**Files:**
- Create: `assets/flat/router_normal.svg`
- Create: `assets/flat/router_error.svg`

- [ ] **Step 1: Create `router_normal.svg`**

Circle with four directional arrows (N/S/E/W).

```svg
<svg width="80" height="80" viewBox="0 0 80 80" xmlns="http://www.w3.org/2000/svg">
  <!-- Circle body -->
  <path d="M40,8 C57.7,8 72,22.3 72,40 C72,57.7 57.7,72 40,72 C22.3,72 8,57.7 8,40 C8,22.3 22.3,8 40,8 Z" fill="#D6E4FF" stroke="#4B7BEC" stroke-width="2"/>
  <!-- Up arrow -->
  <path d="M40,18 L45,26 L40,24 L35,26 Z" fill="#4B7BEC"/>
  <!-- Down arrow -->
  <path d="M40,62 L45,54 L40,56 L35,54 Z" fill="#4B7BEC"/>
  <!-- Right arrow -->
  <path d="M62,40 L54,35 L56,40 L54,45 Z" fill="#4B7BEC"/>
  <!-- Left arrow -->
  <path d="M18,40 L26,35 L24,40 L26,45 Z" fill="#4B7BEC"/>
  <!-- Center dot -->
  <path d="M40,36 C42.2,36 44,37.8 44,40 C44,42.2 42.2,44 40,44 C37.8,44 36,42.2 36,40 C36,37.8 37.8,36 40,36 Z" fill="#4B7BEC"/>
</svg>
```

- [ ] **Step 2: Create `router_error.svg`**

Same paths, red palette.

- [ ] **Step 3: Verify and commit**

```bash
grep -c '<path d=' assets/flat/router_normal.svg assets/flat/router_error.svg
git add assets/flat/router_*.svg
git commit -m "feat: add flat router icons"
```

---

### Task 6: Create firewall icons

**Files:**
- Create: `assets/flat/firewall_normal.svg`
- Create: `assets/flat/firewall_error.svg`

- [ ] **Step 1: Create `firewall_normal.svg`**

Classic shield shape.

```svg
<svg width="80" height="80" viewBox="0 0 80 80" xmlns="http://www.w3.org/2000/svg">
  <path d="M40,6 L70,18 C70,18 72,44 60,58 C52,67 40,74 40,74 C40,74 28,67 20,58 C8,44 10,18 10,18 Z" fill="#D6E4FF" stroke="#4B7BEC" stroke-width="2" stroke-linejoin="round"/>
  <!-- Shield center line -->
  <path d="M40,20 L40,60" fill="none" stroke="#4B7BEC" stroke-width="1.5" opacity="0.4"/>
  <path d="M24,34 L56,34" fill="none" stroke="#4B7BEC" stroke-width="1.5" opacity="0.4"/>
</svg>
```

- [ ] **Step 2: Create `firewall_error.svg`**

Same paths, red palette.

- [ ] **Step 3: Verify and commit**

```bash
grep -c '<path d=' assets/flat/firewall_normal.svg assets/flat/firewall_error.svg
git add assets/flat/firewall_*.svg
git commit -m "feat: add flat firewall icons"
```

---

### Task 7: Create server icons

**Files:**
- Create: `assets/flat/server_normal.svg`
- Create: `assets/flat/server_error.svg`

- [ ] **Step 1: Create `server_normal.svg`**

Three stacked horizontal rectangles (rack server).

```svg
<svg width="80" height="80" viewBox="0 0 80 80" xmlns="http://www.w3.org/2000/svg">
  <!-- Top unit -->
  <path d="M12,10 L68,10 C70,10 72,12 72,14 L72,26 C72,28 70,30 68,30 L12,30 C10,30 8,28 8,26 L8,14 C8,12 10,10 12,10 Z" fill="#D6E4FF" stroke="#4B7BEC" stroke-width="2"/>
  <path d="M62,18 C62,16.3 63.3,15 65,15 C66.7,15 68,16.3 68,18 C68,19.7 66.7,21 65,21 C63.3,21 62,19.7 62,18 Z" fill="#4B7BEC"/>
  <!-- Middle unit -->
  <path d="M12,32 L68,32 C70,32 72,34 72,36 L72,48 C72,50 70,52 68,52 L12,52 C10,52 8,50 8,48 L8,36 C8,34 10,32 12,32 Z" fill="#D6E4FF" stroke="#4B7BEC" stroke-width="2"/>
  <path d="M62,40 C62,38.3 63.3,37 65,37 C66.7,37 68,38.3 68,40 C68,41.7 66.7,43 65,43 C63.3,43 62,41.7 62,40 Z" fill="#4B7BEC"/>
  <!-- Bottom unit -->
  <path d="M12,54 L68,54 C70,54 72,56 72,58 L72,70 C72,72 70,74 68,74 L12,74 C10,74 8,72 8,70 L8,58 C8,56 10,54 12,54 Z" fill="#D6E4FF" stroke="#4B7BEC" stroke-width="2"/>
  <path d="M62,62 C62,60.3 63.3,59 65,59 C66.7,59 68,60.3 68,62 C68,63.7 66.7,65 65,65 C63.3,65 62,63.7 62,62 Z" fill="#4B7BEC"/>
</svg>
```

- [ ] **Step 2: Create `server_error.svg`**

Same paths, red palette.

- [ ] **Step 3: Verify and commit**

```bash
grep -c '<path d=' assets/flat/server_normal.svg assets/flat/server_error.svg
git add assets/flat/server_*.svg
git commit -m "feat: add flat server icons"
```

---

### Task 8: Create generic icons

**Files:**
- Create: `assets/flat/generic_normal.svg`
- Create: `assets/flat/generic_error.svg`

- [ ] **Step 1: Create `generic_normal.svg`**

Simple filled circle.

```svg
<svg width="80" height="80" viewBox="0 0 80 80" xmlns="http://www.w3.org/2000/svg">
  <path d="M40,8 C57.7,8 72,22.3 72,40 C72,57.7 57.7,72 40,72 C22.3,72 8,57.7 8,40 C8,22.3 22.3,8 40,8 Z" fill="#D6E4FF" stroke="#4B7BEC" stroke-width="2"/>
</svg>
```

- [ ] **Step 2: Create `generic_error.svg`**

Same path, red palette.

- [ ] **Step 3: Verify and commit**

```bash
grep -c '<path d=' assets/flat/generic_normal.svg assets/flat/generic_error.svg
git add assets/flat/generic_*.svg
git commit -m "feat: add flat generic icons"
```

---

### Task 9: Create unknown icons

**Files:**
- Create: `assets/flat/unknown_normal.svg`
- Create: `assets/flat/unknown_error.svg`

- [ ] **Step 1: Create `unknown_normal.svg`**

Circle with `?` glyph outline (path, NOT text).

```svg
<svg width="80" height="80" viewBox="0 0 80 80" xmlns="http://www.w3.org/2000/svg">
  <!-- Circle -->
  <path d="M40,8 C57.7,8 72,22.3 72,40 C72,57.7 57.7,72 40,72 C22.3,72 8,57.7 8,40 C8,22.3 22.3,8 40,8 Z" fill="#D6E4FF" stroke="#4B7BEC" stroke-width="2"/>
  <!-- Question mark (path outline, not text) -->
  <path d="M32,30 C32,24 36,20 40,20 C44,20 48,24 48,28 C48,32 45,34 42,35 L42,42" fill="none" stroke="#4B7BEC" stroke-width="3" stroke-linecap="round"/>
  <!-- Dot -->
  <path d="M42,50 C42,48.3 43.3,47 45,47 C46.7,47 48,48.3 48,50 C48,51.7 46.7,53 45,53 C43.3,53 42,51.7 42,50 Z" fill="#4B7BEC"/>
</svg>
```

- [ ] **Step 2: Create `unknown_error.svg`**

Same paths, red palette.

- [ ] **Step 3: Verify and commit**

```bash
grep -c '<path d=' assets/flat/unknown_normal.svg assets/flat/unknown_error.svg
git add assets/flat/unknown_*.svg
git commit -m "feat: add flat unknown icons"
```

---

### Task 10: Final verification and copy to topology_view

**Files:**
- Verify: all 18 SVGs in `assets/flat/`
- Copy to: `/Users/hualinliang/Project/topology_view/assets/images/flat/`

- [ ] **Step 1: Verify all 18 files exist**

Run: `ls -1 /Users/hualinliang/Project/topology_view_icons/assets/flat/*.svg | wc -l`
Expected: `18`

- [ ] **Step 2: Verify every SVG has at least one `<path d=` element**

Run: `for f in assets/flat/*.svg; do echo "$f: $(grep -c '<path d=' "$f")"; done`
Expected: Every file shows at least `1`.

- [ ] **Step 3: Verify no forbidden elements**

Run: `grep -l '<text\|<circle\|<ellipse\|<rect' assets/flat/*.svg`
Expected: No output (no files match).

- [ ] **Step 4: Copy icons to topology_view package**

```bash
mkdir -p /Users/hualinliang/Project/topology_view/assets/images/flat/
cp assets/flat/*.svg /Users/hualinliang/Project/topology_view/assets/images/flat/
```

- [ ] **Step 5: Verify copy**

Run: `ls -1 /Users/hualinliang/Project/topology_view/assets/images/flat/*.svg | wc -l`
Expected: `18`

- [ ] **Step 6: Commit in topology_view_icons**

```bash
cd /Users/hualinliang/Project/topology_view_icons
git add -A
git commit -m "feat: complete flat icon set — 18 SVGs for 9 device types"
```
