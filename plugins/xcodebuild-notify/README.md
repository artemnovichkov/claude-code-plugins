# xcodebuild-notify

A Claude Code plugin that sends macOS notifications for `xcodebuild` commands, mimicking Xcode's build notifications.

![Notification](assets/notification.png)

## Notification Format

- **Title**: `Build Succeeded` / `Build Failed`
- **Body**: `<scheme> | <project> Project`

## Requirements

- macOS
- `jq` (`brew install jq`)

## Installation

Install the plugin:

```bash
claude plugin install artemnovichkov/claude-code-plugins/xcodebuild-notify
```

Then add the hook to `~/.claude/settings.json` (replace `<install-path>` with the actual plugin path, usually `~/.claude/plugins/cache/claude-code-plugins/xcodebuild-notify/1.0.0`):

```json
"hooks": {
  "PostToolUse": [
    {
      "matcher": "Bash",
      "hooks": [
        {
          "type": "command",
          "command": "bash <install-path>/hooks/scripts/xcodebuild-notify.sh",
          "async": true
        }
      ]
    }
  ]
}
```

Restart Claude Code for the hook to take effect.
