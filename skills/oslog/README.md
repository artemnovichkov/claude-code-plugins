# oslog

Read, stream, and analyze Apple unified logs (OSLog) for iOS/macOS apps from Claude Code.

## Features

- **Auto-detect subsystem** from `Logger(subsystem:)` in source code, falling back to bundle identifier
- **Show recent logs** from the live system log store
- **Stream logs** in real time from a running app
- **Analyze `.logarchive`** bundles with full predicate filtering
- **Predicate reference** — shorthand and NSPredicate syntax

## Requirements

- macOS
- App must use `OSLog`

## Usage

Ask Claude Code to check your app's logs:

- "show me recent app logs"
- "stream logs from the running app"
- "check for errors in the last 10 minutes"
- "analyze this logarchive file"
- "show networking category logs"

The skill auto-detects the subsystem from `Logger(subsystem:)` usage in your code, falling back to bundle identifier from `project.pbxproj` or `Info.plist`.
