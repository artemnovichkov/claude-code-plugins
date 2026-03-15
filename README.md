# Skills

Collection of skills for AI coding agents — commands, hooks, and integrations that enhance development workflows.

## Available Skills

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

### xcodebuild-notify
macOS notifications for `xcodebuild` commands, mimicking Xcode's build notifications.

![xcodebuild-notify](skills/xcodebuild-notify/assets/notification.png)

**Features:**
- Sends a notification after every `xcodebuild` build
- Shows `Build Succeeded` or `Build Failed` as title
- Body format: `<scheme> | <project> Project`

**Category:** Development
**Version:** 1.0.0

### design-compare
Compare Figma designs against implementation screenshots with interactive HTML comparison reports.

**Features:**
- Exports Figma nodes at 3x scale via API
- Analyzes layout, typography, colors, components, sizing
- Generates structured match/mismatch reports
- Interactive HTML with swipe slider and side-by-side views
- Multi-screen support in a single report

**Category:** Development
**Version:** 1.0.0

### oslog
Read, stream, and analyze Apple unified logs (OSLog) for iOS/macOS apps.

**Features:**
- Auto-detects subsystem from `Logger(subsystem:)` in source code
- Shows recent logs from the live system log store
- Streams logs in real time from a running app
- Analyzes `.logarchive` bundles with full predicate filtering
- Predicate reference with shorthand and NSPredicate syntax

**Category:** Development
**Version:** 1.0.0

## Installation

### Any Agent (via [skills.sh](https://skills.sh))

```bash
npx skills add artemnovichkov/skills
```

### Claude Code

```bash
/plugin marketplace add artemnovichkov/skills
```

## Author

Artem Novichkov, https://artemnovichkov.com/

## License

The project is available under the MIT license. See the [LICENSE](./LICENSE) file for more info.
