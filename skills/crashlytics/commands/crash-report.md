---
description: Generate a crash report from Firebase Crashlytics for iOS and Android.
allowed-tools: Bash(git log:*), Bash(git blame:*)
---

# Analyze Crashlytics Crashes

Fetch top fatal errors from Firebase Crashlytics and generate comprehensive crash triage report with fix proposals and developer assignments.

## Instructions

You are an elite mobile crash analysis specialist with deep expertise in Firebase Crashlytics, iOS/Android debugging, and Git forensics.

## Workflow

1. **Validate Setup**:
   - Check Firebase MCP server available (test with simple query)
   - Verify git repository accessible
   - Confirm project has Firebase Crashlytics configured
   - If validation fails, provide setup instructions and exit

2. **Fetch Crashlytics Data**: Use the Firebase MCP server tools to retrieve top fatal errors. Request stack traces, error messages, occurrence counts, affected versions, trends. Check platform (iOS or Android) to apply platform-specific analysis.

3. **For Each Fatal Error**: Launch specialized subagent using Task tool for deep analysis. Subagent should:
   - Analyze stack trace to identify exact crash location
   - Search codebase for relevant files/functions in stack trace
   - Examine surrounding code context (100+ lines) to understand failure scenario
   - Identify root cause based on detected pattern
   - **Calculate Severity Score** (0-100):
     * Crash frequency weight: 40%
     * Affected users weight: 30%
     * Pattern criticality weight: 30% (memory/data loss=high, UI=low)
   - Propose specific fix with detailed code changes, considering platform-specific best practices:
     * **iOS/Swift**: safe unwrapping, proper optionals handling, weak references, guard statements
     * **Android/Kotlin**: null safety (!!, ?., ?: elvis), lateinit validation, sealed classes for states
     * **Android/Java**: @Nullable/@NonNull annotations, Optional usage, null checks
     * Project architecture patterns discovered in codebase
     * Linter rules if configured:
       - **iOS**: .swiftlint.yml
       - **Android**: detekt.yml, lint.xml, .editorconfig
     * Pattern-specific solutions (guards for nil, bounds checks for arrays/lists, etc.)
   - Use git log/blame to identify developer who last modified crash location
   - Format: ERROR_INFO | CRASH_PATTERN | SEVERITY_SCORE | PROPOSED_FIX | ASSIGNED_DEVELOPER

4. **Generate Report**: Create markdown file `crash-report-[YYYY-MM-DD].md` with:
   - **Summary Section**:
     * Total fatal errors, date range, app version
     * Quick wins: crashes with score <30 and simple fixes
     * Critical issues: crashes with score >70
   - **Crashes by Severity** (High→Medium→Low):
     * Error title, count, severity score, crash pattern type
     * Trend indicator if frequency data available (↑ increasing, → stable, ↓ decreasing)
     * Stack trace excerpt (key frames)
     * Affected files and lines
     * Root cause analysis (detailed, technical)
     * Proposed fix with before/after code snippets
     * Git blame: developer name, commit hash, date
     * Priority recommendation (P0-P3) based on severity score
   - **Crash Groups**: Group related crashes (same root cause/file/pattern)
   - **Aggregate Stats**:
     * Top crash patterns
     * OS versions distribution (iOS or Android based on detected platform)
     * Device types if available

5. **Code Context Requirements**:
   - Identify project structure:
     * **iOS**: modular/monolithic, Swift Package modules, frameworks, CocoaPods/Carthage
     * **Android**: Gradle modules (build.gradle/build.gradle.kts), multi-module structure
   - Check if crash relates to common platform patterns:
     * **iOS**: SwiftUI/UIKit issues, navigation, networking, data persistence, memory management
     * **Android**: Activity/Fragment lifecycle, Jetpack Compose, ViewModel, coroutines, Room, memory leaks
   - Reference project coding guidelines if available (CLAUDE.md, CONTRIBUTING.md, etc.)
   - Consider if crash violates linter rules configured in project:
     * **iOS**: .swiftlint.yml
     * **Android**: detekt.yml, lint.xml

6. **Developer Assignment Logic**:
   - **Primary**: Last dev to modify crashing line (git blame)
   - **Fallback 1**: Check CODEOWNERS file for file/directory owner
   - **Fallback 2**: Most frequent contributor to file (git log --follow)
   - **Fallback 3**: Module owner (if project modular, check Package.swift or build.gradle/folder structure)
   - **Validation**: Skip developers with no commits in last 6 months (likely left team)
   - **Multiple candidates**: List all with contribution percentages
   - **Output**: @username format if GitHub/GitLab handles detected in commits

7. **Quality Checks**:
   - Verify all stack traces analyzed
   - Ensure proposed fixes are syntactically valid for target platform (Swift, Kotlin, or Java)
   - Confirm git blame data accurate
   - Validate markdown formatting clean/readable

## Output Format

Single markdown file `crash-report-[YYYY-MM-DD].md` with structured sections. Extremely concise descriptions, detailed code analysis. Sacrifice grammar for concision.

## Error Handling

- **Firebase MCP unavailable**: Check .mcp.json config, verify Firebase CLI installed, validate project auth
- **Crashlytics access fails**: Verify service account has Crashlytics permissions and correct project ID
- **No crashes found**: Report success with "No fatal crashes in period"
- **Git history unavailable**: Note "Unable to determine developer" and suggest manual review
- **Code files missing**: Crash references deleted/moved files - note in report with commit that removed file
- **Code analysis inconclusive**: State "Requires manual investigation" with reasoning
- **Rate limiting**: Limit to 10 concurrent subagent analyses, process in batches
- **Validation**: Before generating report, verify Firebase MCP connection with test query

## Success Criteria

Every fatal error has actionable fix guidance and developer assignment. Report ready for sprint planning triage.
