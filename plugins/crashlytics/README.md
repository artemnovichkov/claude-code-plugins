# Crashlytics Plugin

Generate crash reports from Firebase Crashlytics for iOS and Android with automated fix proposals and developer assignments.

## Features

- **Fetches Fatal Errors**: Retrieves top crashes from Firebase Crashlytics via MCP server
- **Stack Trace Analysis**: Identifies exact crash locations in codebase
- **Root Cause Detection**: Analyzes code context to determine failure patterns
- **Severity Scoring**: Calculates 0-100 score based on frequency, users affected, pattern criticality
- **Fix Proposals**: Generates specific code changes following platform best practices (Swift, Kotlin, Java)
- **Developer Assignment**: Uses git blame/log to assign crashes to responsible developers
- **Crash Grouping**: Groups related issues by pattern/file/root cause
- **Comprehensive Reports**: Generates markdown reports with stats, trends, priorities

## Requirements

- Firebase project with Crashlytics enabled
- Git repository
- Claude Code

## Commands

### `/crash-report`

Analyzes Crashlytics crashes and generates triage report.

**Process:**
1. Validates Firebase MCP server connection
2. Fetches fatal errors from Crashlytics
3. Launches subagents for deep analysis of each crash
4. Extracts stack traces, searches codebase for crash locations
5. Identifies root causes and calculates severity scores
6. Proposes fixes with before/after code snippets
7. Uses git blame to assign developers
8. Generates `crash-report-[YYYY-MM-DD].md`

**Report Sections:**
- Summary (total errors, quick wins, critical issues)
- Crashes by severity (high -> medium -> low)
- Stack traces, affected files, root cause analysis
- Proposed fixes with code snippets
- Developer assignments with git history
- Crash groups
- Aggregate stats (patterns, OS versions, devices)

**Severity Score Calculation:**
- Crash frequency: 40%
- Affected users: 30%
- Pattern criticality: 30%

**Developer Assignment Logic:**
1. Last modifier of crashing line (git blame)
2. CODEOWNERS file owner
3. Most frequent contributor (git log)
4. Module owner (Package.swift or build.gradle)
5. Excludes devs with no commits in 6 months

## Configuration

Plugin uses `.mcp.json` to configure Firebase MCP server:

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

## Error Handling

- **Firebase MCP unavailable**: Provides setup instructions
- **Crashlytics access fails**: Verifies service account permissions
- **No crashes found**: Reports success with no fatal crashes
- **Git history unavailable**: Notes inability to assign developer
- **Code files missing**: Flags deleted/moved files
- **Rate limiting**: Processes max 10 concurrent analyses

## Output Format

Markdown file `crash-report-[YYYY-MM-DD].md` with:
- Concise descriptions
- Detailed code analysis
- Actionable fix guidance
- Ready for sprint planning triage
