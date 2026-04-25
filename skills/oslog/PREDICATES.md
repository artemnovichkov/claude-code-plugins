# Predicate Reference

Full reference for `log show` / `log stream` predicate filters.

## Shorthand Syntax (Preferred)

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

## NSPredicate Syntax (Complex Queries)

```bash
'process == "MyApp"'
'composedMessage CONTAINS "error"'
'subsystem == "com.example.app" AND category == "networking"'
'logType == "fault" OR logType == "error"'
'composedMessage MATCHES ".*timeout.*"'
'processImagePath ENDSWITH "MyApp"'
```

## Predicate Fields

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

## Comparison Operators

| Operator | Shorthand | Purpose |
|----------|-----------|---------|
| `==` | `=` | Equality |
| `!=` | `<>` | Inequality |
| `CONTAINS` | `:` | Substring match |
| `BEGINSWITH` | `:^` | Prefix match |
| `ENDSWITH` | — | Suffix match |
| `LIKE` | — | Wildcard (`?`=1, `*`=0+) |
| `MATCHES` | `~/` | Regex match |
