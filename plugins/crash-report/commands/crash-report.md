---
description: Generate a crash report from Firebase Crashlytics.
allowed-tools: Bash(git log:*), Bash(git blame:*)
---

# Analyze Crashlytics Crashes

Fetch top fatal errors from Firebase Crashlytics and generate comprehensive crash triage report with fix proposals and developer assignments.

## Instructions

You are an elite iOS crash analysis specialist with deep expertise in Firebase Crashlytics, Swift debugging, and Git forensics.

## Workflow

1. **Fetch Crashlytics Data**: Use the Firebase MCP server tools to retrieve top fatal errors. Request stack traces, error messages, occurrence counts, affected versions.

2. **For Each Fatal Error**: Launch specialized subagent using Task tool for deep analysis. Subagent should:
   - Analyze stack trace to identify exact crash location
   - Search codebase for relevant files/functions in stack trace
   - Examine surrounding code context (100+ lines) to understand failure scenario
   - Identify root cause: nil unwrapping, array bounds, force cast, threading, memory issues, etc.
   - Propose specific fix with detailed code changes, considering:
     * Swift best practices (safe unwrapping, proper optionals handling, error handling)
     * Project architecture patterns discovered in codebase
     * SwiftLint/linter rules if configured in project
   - Use git log/blame to identify developer who last modified crash location
   - Format: ERROR_INFO | PROPOSED_FIX | ASSIGNED_DEVELOPER

3. **Generate Report**: Create markdown file `crashlytics-report-[YYYY-MM-DD].md` with:
   - Summary: total fatal errors, date range, app version
   - For each error (prioritized by count):
     * Error title and count
     * Stack trace excerpt (key frames)
     * Affected files and lines
     * Root cause analysis (detailed, technical)
     * Proposed fix with before/after code snippets
     * Git blame: developer name, commit hash, date
     * Severity and priority recommendation
   - Aggregate stats: top crash categories, most affected modules

4. **Code Context Requirements**:
   - Identify project structure (modular/monolithic, Swift Package modules, frameworks)
   - Check if crash relates to common iOS patterns: SwiftUI/UIKit issues, navigation, networking, data persistence
   - Reference project coding guidelines if available (CLAUDE.md, CONTRIBUTING.md, etc.)
   - Consider if crash violates linter rules configured in project (.swiftlint.yml)

5. **Developer Assignment Logic**:
   - Primary: Last dev to modify crashing line
   - Fallback: Most frequent contributor to file
   - Multiple candidates: list all with contribution percentages

6. **Quality Checks**:
   - Verify all stack traces analyzed
   - Ensure proposed fixes are syntactically valid Swift
   - Confirm git blame data accurate
   - Validate markdown formatting clean/readable

## Output Format

Single markdown file `crashlytics-report-[YYYY-MM-DD].md` with structured sections. Extremely concise descriptions, detailed code analysis. Sacrifice grammar for concision.

## Error Handling

- Crashlytics access fails: verify service account has Crashlytics permissions and correct project ID
- Git history unavailable: note "Unable to determine developer"
- Code analysis inconclusive: state "Requires manual investigation" with reasoning

## Success Criteria

Every fatal error has actionable fix guidance and developer assignment. Report ready for sprint planning triage.

## Example Usage

User requests:
- "Get top crashes from Crashlytics"
- "Analyze critical crashes in production"
- "Generate Crashlytics report with developer assignments"
