---
name: oslog
description: Read, stream, and analyze Apple unified logs (OSLog) for iOS/macOS apps. Auto-detects subsystem from Logger usage or bundle identifier. Supports live log show, real-time streaming, and .logarchive analysis with full predicate reference.
---

# oslog

Read, stream, and analyze Apple unified logs for iOS/macOS apps.

## When to Use

Activate when the user asks to:
- Check, read, show, or debug app logs
- Stream logs in real time
- Analyze `.logarchive` files
- Filter system logs by process, subsystem, or message content
- Investigate crashes, errors, or unexpected behavior via logs

## Step 1 — Detect Subsystem

Auto-detect the OSLog subsystem from the project. Try these sources in order:

1. **Source code** — search for `Logger(subsystem:` in Swift files to find the actual subsystem string used in code
2. **`project.pbxproj`** — fall back to `PRODUCT_BUNDLE_IDENTIFIER` build setting (common convention is to use bundle ID as subsystem)
3. **`Info.plist`** — read `CFBundleIdentifier` value (resolve `$(PRODUCT_BUNDLE_IDENTIFIER)` if needed)
4. **Ask the user** — if all detection fails, ask for the subsystem string

Note: the subsystem is an arbitrary string passed to `Logger(subsystem:, category:)`. It often matches the bundle identifier but doesn't have to.

Store the detected subsystem for reuse within the session.

## Step 2 — Determine Mode

### Mode A: Show Recent Logs

Query recent logs from the live system log store.

```bash
/usr/bin/log show --last <N>m --info --debug --no-pager \
  --predicate 'subsystem == "<SUBSYSTEM>"' | head -100
```

- Default to `--last 5m`, adjust based on user request
- Always pipe through `head` on first query to avoid flooding output
- Increase `head` limit or remove it only if the user asks for more

### Mode B: Stream Live Logs

Stream logs in real time from a running app.

```bash
/usr/bin/log stream --info --debug \
  --predicate 'subsystem == "<SUBSYSTEM>"'
```

- Note: `--no-pager` is not needed here — `log stream` is inherently streaming and has no pager
- Run via Bash with `run_in_background` — the stream is continuous
- Notify the user when output is available
- Stop the stream when the user is done or the task changes

### Mode C: Analyze `.logarchive`

Query an exported log archive bundle.

**Locate the archive:**
```bash
ls <path>.logarchive/Info.plist
```

**Determine time range:**
```bash
/usr/bin/log show --style ndjson --no-pager <archive> | head -1
/usr/bin/log show --style ndjson --no-pager <archive> | tail -1
```

**Query the archive:**
```bash
/usr/bin/log show --info --debug --no-pager \
  --predicate 'subsystem == "<SUBSYSTEM>"' <archive> | head -50
```

**Export a new archive (requires sudo):**
```bash
# Path must not already exist — log collect creates the directory
sudo /usr/bin/log collect --last 30m --output <path>.logarchive
```

## Critical Rules

- **Always use `/usr/bin/log`** — bare `log` conflicts with zsh builtin
- **Always include `--no-pager`** — interactive pagers hang in non-interactive contexts
- **Always pipe through `head -N`** on initial queries — archives and log stores can contain millions of entries
- **Include `--info --debug`** — by default only Default and Error/Fault levels are shown
- **Use `--style ndjson`** for programmatic parsing/counting, `--style default` for human-readable output

## Predicate Reference

### Shorthand Syntax (Preferred)

```bash
# Process
'p=MyApp'
'p=foo|bar'                     # OR multiple processes

# Subsystem / category
's=com.example.app'
'c=networking'

# Message content
'"error loading"'               # message contains
'm:"timeout"'                   # explicit message contains
'm~/"regex pattern"'            # regex matching

# Log levels
'type=error'
'type>=error'                   # error + fault

# Combined
'p=MyApp AND type>=error'
's=com.example.app AND c=networking AND "timeout"'
```

### NSPredicate Syntax (Complex Queries)

```bash
'process == "MyApp"'
'composedMessage CONTAINS "error"'
'subsystem == "com.example.app" AND category == "networking"'
'logType == "fault" OR logType == "error"'
'composedMessage MATCHES ".*timeout.*"'
'processImagePath ENDSWITH "MyApp"'
```

### Predicate Fields

| Field | Shorthand | Type | Description |
|-------|-----------|------|-------------|
| `process` | `p` | string | Process name |
| `processIdentifier` | `pid` | integer | Process ID |
| `subsystem` | `s` | string | Subsystem identifier |
| `category` | `c`, `cat` | string | Subsystem category |
| `composedMessage` | `m` | string | Log message text |
| `sender` | `l`, `lib` | string | Library/sender name |
| `logType` | `type` | log type | default, info, debug, error, fault |
| `senderImagePath` | — | string | Full sender library path |
| `processImagePath` | — | string | Full process binary path |
| `threadIdentifier` | `tid` | integer | Thread ID |

### Comparison Operators

| Operator | Shorthand | Purpose |
|----------|-----------|---------|
| `==` | `=` | Equality |
| `!=` | `<>` | Inequality |
| `CONTAINS` | `:` | Substring match |
| `BEGINSWITH` | `:^` | Prefix match |
| `ENDSWITH` | — | Suffix match |
| `LIKE` | — | Wildcard (`?`=1, `*`=0+) |
| `MATCHES` | `~/` | Regex match |

## Common Workflows

**Show all errors/faults from the app:**
```bash
/usr/bin/log show --last 10m --no-pager \
  --predicate 's=<SUBSYSTEM> AND type>=error' | head -50
```

**Show logs for a specific category:**
```bash
/usr/bin/log show --last 5m --info --debug --no-pager \
  --predicate 's=<SUBSYSTEM> AND c=networking' | head -100
```

**Search for a keyword in messages:**
```bash
/usr/bin/log show --last 5m --info --debug --no-pager \
  --predicate 's=<SUBSYSTEM> AND m:"timeout"' | head -50
```

**Count events by type in an archive:**
```bash
/usr/bin/log show --no-pager --style ndjson \
  --predicate 's=<SUBSYSTEM> AND type=error' <archive> | wc -l
```

**List unique categories from the app:**
```bash
/usr/bin/log show --last 30m --info --debug --no-pager --style ndjson \
  --predicate 's=<SUBSYSTEM>' | head -500 | \
  grep -o '"category":"[^"]*"' | sort -u
```
