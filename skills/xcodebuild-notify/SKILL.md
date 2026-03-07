---
name: xcodebuild-notify
description: Sends macOS notifications after xcodebuild commands, showing Build Succeeded or Build Failed with scheme and project info. Mimics Xcode's native build notifications. Auto-triggers on xcodebuild via PostToolUse hook.
---

# xcodebuild-notify

macOS notifications for `xcodebuild` commands, mimicking Xcode's native build notifications.

## When to Use

This skill activates automatically. It hooks into `PostToolUse` for Bash commands and sends a macOS notification whenever an `xcodebuild` command completes.

## Notification Format

- **Title**: `Build Succeeded` / `Build Failed`
- **Body**: `<scheme> | <project> Project`

## Requirements

- macOS
- `jq` (`brew install jq`)
