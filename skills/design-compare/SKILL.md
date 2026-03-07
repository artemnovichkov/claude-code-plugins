---
name: design-compare
description: This skill should be used when the user asks to "compare design with preview", "compare Figma with screenshot", "check design implementation", "compare design to implementation", "design review", or provides a Figma URL alongside a screenshot file for visual comparison.
---

# Design Compare

Compare Figma design screenshots against local preview screenshots, producing a structured visual review and an interactive HTML comparison page. Supports multiple screens in a single report.

## Setup

`$SKILL_DIR` refers to the directory containing this SKILL.md file. Resolve it based on where the skill is installed (e.g. `.claude/skills/design-compare`, `.agents/skills/design-compare`, etc.).

## Prerequisites

The export script requires a `FIGMA_ACCESS_TOKEN` env var. Store it in `.env` at the repo root:
```
FIGMA_ACCESS_TOKEN=figd_...
```
The script auto-loads `.env` from the repo root. Get a token from https://www.figma.com/developers/api#access-tokens

## Workflow

### Step 1: Obtain Images for Each Screen

Repeat for each screen being compared. Use a slug (e.g. `empty-state`, `list-view`) to name files.

Derive the report folder from the project or context name, e.g. `design-compare-reports/LayoutCheckExample/`. Within this folder, store images in per-view subfolders named after the source file (without extension), e.g. `ContentView/`, `SliderView/`. The report folder holds a single shared `config.js` and `report.html`.

**Figma design image:**
- Extract `fileKey` and `nodeId` from the Figma URL.
- Call `mcp__figma__get_screenshot` with the extracted parameters. The screenshot is returned inline for visual comparison in Step 2.
- To save it as a file for the HTML page, run the export script:
  ```bash
  mkdir -p design-compare-reports/<ReportName>/<ViewName>
  bash $SKILL_DIR/scripts/export-figma-node.sh <fileKey> <nodeId> design-compare-reports/<ReportName>/<ViewName>/<slug>_figma.png
  ```
  The script exports at 3x scale with `use_absolute_bounds=true` to match device pixel density and clip to exact frame bounds.
- If the script fails (no token), ask the user to provide a Figma screenshot file.

**Preview image:**
- If using Xcode MCP, call `mcp__xcode__RenderPreview` to render a fresh preview and use the returned `previewSnapshotPath`.
- Otherwise accept a preview image path from the user.
- Copy to the report folder:
  ```bash
  cp <preview_path> design-compare-reports/<ReportName>/<ViewName>/<slug>_preview.png
  ```

### Step 2: Visual Comparison

Read/view both images (Figma inline screenshot + preview file) and analyze them. Evaluate:

1. **Layout** - positioning, alignment, spacing between elements
2. **Typography** - font sizes, weights, line heights, text content
3. **Colors** - backgrounds, text colors, tint colors, opacity
4. **Components** - buttons, toolbars, icons, navigation elements
5. **Sizing** - element dimensions, padding, margins

### Step 3: Output Comparison Summary

Produce a structured summary with two sections:

**Positive (matches):** List aspects where the implementation matches the design.

**Negative (mismatches):** List aspects where the implementation diverges from the design, with specific details about what differs and how to fix it.

Keep each item concise (one line). Order by visual importance.

### Step 4: Generate HTML Comparison Page

All shared artifacts (`config.js`, `report.html`) are stored in `design-compare-reports/<ReportName>/`. Images live in per-view subfolders (`<ViewName>/`).

1. Generate `config.js` with screen metadata. Image paths use the `<ViewName>/` prefix. Use a shell heredoc:
   ```bash
   cat > design-compare-reports/<ReportName>/config.js <<'EOF'
   const reportConfig = {
     generatedAt: "TIMESTAMP",
     screens: [
       { name: "SCREEN_NAME", figma: "VIEW_NAME/SLUG_figma.png", preview: "VIEW_NAME/SLUG_preview.png", figmaUrl: "FIGMA_URL" }
     ]
   };
   EOF
   ```
   Replace `TIMESTAMP` with the current date/time, `SCREEN_NAME` with a human-readable name, `VIEW_NAME` with the source file name (without extension), `SLUG` with the file slug, and `FIGMA_URL` with the full Figma URL for that node.

   For multiple screens, add entries to the `screens` array.

2. Copy the HTML template:
   ```bash
   cp $SKILL_DIR/assets/compare.html design-compare-reports/<ReportName>/report.html
   ```

3. Open the file with `open design-compare-reports/<ReportName>/report.html`.

The report folder structure:
```
design-compare-reports/<ReportName>/
  config.js          — screen list, timestamp, and Figma links
  report.html        — interactive comparison page
  <ViewName>/        — per source file (e.g. ContentView/, SliderView/)
    <slug>_figma.png
    <slug>_preview.png
```

The HTML page provides:
- **Screen tabs** — switch between screens (hidden for single screen)
- **Figma link** — opens the source node in Figma
- **Timestamp** — when the report was generated
- **Swipe** (default) — drag a slider to reveal one image over the other
- **Side by Side** — both images displayed next to each other with labels
