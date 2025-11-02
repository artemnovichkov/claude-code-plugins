# Claude Code Plugins Marketplace

Collection of Claude Code plugins for enhanced development workflows.

## Available Plugins

### Crashlytics
Generate crash reports from Firebase Crashlytics with automated fix proposals and developer assignments.

**Features:**
- Fetches fatal errors from Firebase Crashlytics
- Analyzes stack traces and identifies root causes
- Proposes specific fixes with code snippets
- Assigns crashes to developers via git blame
- Calculates severity scores (0-100)
- Groups related crashes
- Generates comprehensive markdown reports

**Category:** Development
**Version:** 1.0.0

## Structure

```
.
├── .claude-plugin/
│   └── marketplace.json       # Marketplace config
└── plugins/
    └── crashlytics/          # Crashlytics plugin
        ├── .claude-plugin/
        │   └── plugin.json   # Plugin metadata
        ├── .mcp.json         # MCP server config
        ├── README.md         # Plugin docs
        └── commands/
            └── crash-report.md
```

## Installation

```bash
/plugin marketplace add artemnovichkov/claude-code-plugins
```

## Author

Artem Novichkov, https://artemnovichkov.com/

## License

The project is available under the MIT license. See the [LICENSE](./LICENSE) file for more info.
