# xcodebuild-notify

A Claude Code plugin that sends macOS notifications for `xcodebuild` commands, mimicking Xcode's build notifications.

![Notification](assets/notification.png)

## Notification Format

- **Title**: `Build Succeeded` / `Build Failed`
- **Body**: `<scheme> | <project> Project`

## Requirements

- macOS
- `jq` (`brew install jq`)
