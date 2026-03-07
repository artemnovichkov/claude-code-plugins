# xcodebuild-notify

A skill that sends macOS notifications for `xcodebuild` commands, mimicking Xcode's build notifications. Works with any AI coding agent that supports hooks.

![Notification](assets/notification.png)

## Notification Format

- **Title**: `Build Succeeded` / `Build Failed`
- **Body**: `<scheme> | <project> Project`

## Requirements

- macOS
- `jq` (`brew install jq`)

## Installation

### Claude Code

```bash
/plugin marketplace add artemnovichkov/skills
```

### Other Agents

Configure a `PostToolUse` hook that runs `hooks/scripts/xcodebuild-notify.sh` after Bash tool calls. See `hooks/hooks.json` for the hook definition.
