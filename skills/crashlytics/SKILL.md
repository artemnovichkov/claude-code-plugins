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

Analyzes Crashlytics crashes and generates a triage report.

**Process:**
1. Validates Firebase MCP server connection
2. Fetches fatal errors from Crashlytics
3. Launches subagents for deep analysis of each crash
4. Extracts stack traces, searches codebase for crash locations
5. Identifies root causes and calculates severity scores
6. Proposes fixes with before/after code snippets
7. Uses git blame to assign developers
8. Generates `crash-report-[YYYY-MM-DD].md`

## Requirements

- Firebase project with Crashlytics enabled
- Git repository
- MCP server config (`.mcp.json` included)

## Severity Score

- Crash frequency: 40%
- Affected users: 30%
- Pattern criticality: 30%

## Developer Assignment

1. Last modifier of crashing line (git blame)
2. CODEOWNERS file owner
3. Most frequent contributor (git log)
4. Module owner (Package.swift or build.gradle)
