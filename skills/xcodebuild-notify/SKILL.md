---
name: xcodebuild-notify
description: "Sends macOS notifications after xcodebuild commands, showing Build Succeeded or Build Failed with scheme and project info. Mimics Xcode's native build notifications. Auto-triggers on xcodebuild via PostToolUse hook."
---

# xcodebuild-notify

macOS notifications for `xcodebuild` commands, mimicking Xcode's native build notifications.

## When to Use

This skill activates automatically via a PostToolUse hook on Bash commands. No manual invocation needed — any `xcodebuild` command triggers it.

## How It Works

The hook script (`hooks/scripts/xcodebuild-notify.sh`) runs after every Bash tool use:

1. Checks if the command contains `xcodebuild` — exits early if not
2. Parses `-scheme` and `-project` flags from the command
3. Checks tool output for `BUILD SUCCEEDED` or `BUILD FAILED`
4. Sends a macOS notification via `osascript`

### Hook Configuration

The PostToolUse hook is defined in `hooks/hooks.json`:

```json
{
  "PostToolUse": [
    {
      "matcher": "Bash",
      "hooks": [
        {
          "type": "command",
          "command": "bash $CLAUDE_PLUGIN_ROOT/hooks/scripts/xcodebuild-notify.sh",
          "async": true
        }
      ]
    }
  ]
}
```

### Notification Examples

**Build succeeds:**
```
Title: "Build Succeeded"
Body:  "MyScheme | MyApp Project"
```

**Build fails:**
```
Title: "Build Failed"
Body:  "MyScheme | MyApp Project"
```

Commands that don't produce `BUILD SUCCEEDED` or `BUILD FAILED` (e.g., `xcodebuild clean`, `xcodebuild -help`) are silently skipped.

## Requirements

- macOS (uses `osascript` for notifications)
- `jq` (`brew install jq`) — parses hook input JSON
