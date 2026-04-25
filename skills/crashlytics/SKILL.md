---
name: crashlytics
description: Generate crash reports from Firebase Crashlytics with automated fix proposals, severity scoring, and developer assignments via git blame. Use when analyzing crashes, triaging production issues, or generating crash triage reports.
---

# Crashlytics

Generate crash reports from Firebase Crashlytics for iOS and Android with automated fix proposals and developer assignments.

## When to Use

- User asks to analyze crashes or crash reports
- User wants to triage production issues from Crashlytics
- User asks for crash severity analysis or fix proposals
- User mentions Firebase Crashlytics

## Commands

### `/crash-report`

Analyzes Crashlytics crashes and generates a triage report. See `commands/crash-report.md` for the full workflow, platform-specific analysis rules, and error handling.

**Process:**
1. Validate Firebase MCP server connection (test with a simple query first)
2. Fetch fatal errors from Crashlytics with stack traces and occurrence counts
3. Launch subagents for deep analysis of each crash (max 10 concurrent)
4. Extract stack traces, search codebase for crash locations
5. Identify root causes and calculate severity scores
6. Propose fixes with before/after code snippets
7. Use git blame to assign developers
8. Generate `crash-report-[YYYY-MM-DD].md`

**If validation fails** (MCP unavailable, no crashes found, auth error), the command file includes specific recovery steps for each scenario.

### Example Output Structure

```markdown
## Critical Issues (Score > 70)
### NullPointerException in CheckoutViewModel.kt:142
- **Severity**: 85/100 | **Count**: 1,247 | **Trend**: ↑
- **Root cause**: Force-unwrap on nullable payment response
- **Assigned**: @developer (last modified 2025-03-10)
- **Fix**: Replace `!!` with safe call + fallback
```

## Requirements

- Firebase project with Crashlytics enabled
- Git repository
- MCP server config (`.mcp.json` included in this skill)

### MCP Server Setup

This skill bundles `.mcp.json` with the Firebase Crashlytics MCP server:

```json
{
  "mcpServers": {
    "firebase": {
      "command": "npx",
      "args": ["-y", "firebase-tools@latest", "experimental:mcp", "--only", "crashlytics"]
    }
  }
}
```

## Severity Score

| Factor | Weight | High Example | Low Example |
|--------|--------|-------------|-------------|
| Crash frequency | 40% | 1000+ occurrences | < 10 occurrences |
| Affected users | 30% | Wide user base | Single device |
| Pattern criticality | 30% | Memory / data loss | UI glitch |

## Developer Assignment

1. Last modifier of crashing line (`git blame`)
2. CODEOWNERS file owner
3. Most frequent contributor (`git log --follow`)
4. Module owner (Package.swift or build.gradle)

Skip developers with no commits in the last 6 months.
