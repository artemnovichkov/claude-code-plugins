# Design Compare Skill

Compare Figma design screenshots against local preview screenshots, producing a structured visual review and an interactive HTML comparison page.

## Features

- **Figma Export**: Exports Figma nodes at 3x scale via API
- **Visual Comparison**: Analyzes layout, typography, colors, components, sizing
- **Structured Reports**: Positive matches and negative mismatches
- **Interactive HTML**: Swipe slider and side-by-side comparison modes
- **Multi-Screen**: Supports multiple screens in a single report

## Requirements

- `FIGMA_ACCESS_TOKEN` env var (store in `.env` at repo root)
- Figma MCP server (for inline screenshots) or manual screenshot files
- Xcode MCP (optional, for rendering SwiftUI previews)

## Usage

Provide a Figma URL and a preview screenshot, then ask to compare them. The skill will:

1. Export the Figma design node
2. Capture or accept a preview screenshot
3. Analyze visual differences
4. Generate an interactive HTML report with swipe/side-by-side views

## Screenshot

![Design Compare](/.github/screenshot.png)

## Report Structure

```
design-compare-reports/<ReportName>/
  config.js          -- screen list, timestamp, Figma links
  report.html        -- interactive comparison page
  <ViewName>/        -- per source file
    <slug>_figma.png
    <slug>_preview.png
```
