# Crash Report Plugin

Generate crash report from Firebase Crashlytics with fix proposals and developer assignments.

Uses [Firebase AI Assistance with MCP](https://firebase.google.com/docs/crashlytics/ai-assistance-mcp) to fetch and analyze Crashlytics data.

## Features

- Fetch top fatal errors from Firebase Crashlytics via Firebase MCP server
- Launch subagents for deep analysis of each error
- Parse stack traces and identify crash origins
- Search codebase for crash locations
- Git blame to identify responsible developers
- Generate comprehensive markdown reports with fix proposals
- Suggest specific code fixes with Swift best practices
- Developer assignments based on git history

## Installation

Install the plugin (Firebase MCP server will be installed automatically):

```bash
# If installing from this marketplace
claude-code plugins install crash-report
```

## Important: Firebase MCP Context Optimization

firebase-tools automatically optimizes MCP context and enables Crashlytics tools based on your project setup. For iOS projects, it checks if `Package.swift` exists in the project root and contains the "Crashlytics" string.

**⚠️ If you added Firebase to your Xcode project without using Swift Package Manager** (e.g., via CocoaPods or manually), the Firebase MCP tools may not be available. To fix this:

1. Ensure you're using Swift Package Manager to add Firebase/Crashlytics
2. OR create a `Package.swift` in your project root that includes Firebase Crashlytics dependencies

See [Firebase documentation](https://firebase.google.com/docs/crashlytics/ai-assistance-mcp) for more details on MCP context optimization.

## Usage

Run the command to fetch and analyze production crashes:

```
/crash-report
```

The command will:
- Fetch top fatal errors from Firebase Crashlytics via Firebase MCP server
- Launch subagents for deep analysis of each error
- Search codebase for crash locations and context
- Run git blame to identify responsible developers
- Generate `crash-report-[date].md` with:
  - Error summaries with occurrence counts
  - Stack traces and affected files
  - Root cause analysis
  - Proposed fixes with before/after code
  - Developer assignments
  - Severity/priority recommendations

## Example

```
User: /crash-report

Claude:
[Fetches from Firebase Crashlytics via Firebase MCP server]
[Launches subagents for each error]
[Generates crash-report-2025-11-02.md]

Report created with 5 fatal errors analyzed:
- Each with stack trace, root cause, proposed fix
- Developer assignments via git blame
- Ready for sprint planning
```

## Requirements

- Claude Code CLI
- Firebase project with Crashlytics enabled
- Swift Package Manager setup with Firebase Crashlytics (for automatic MCP context detection)

For detailed setup and authentication options, see [Firebase AI Assistance with MCP documentation](https://firebase.google.com/docs/crashlytics/ai-assistance-mcp).

## License

MIT
