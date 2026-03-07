# Conventions

## Skill Naming

- Lowercase, kebab-case (e.g. `xcodebuild-notify`)
- Descriptive, concise

## Required Files

Each skill must have:
- `SKILL.md` -- universal skill manifest with YAML frontmatter (name, description) and agent instructions
- `README.md` -- docs with features, requirements, usage
- `.claude-plugin/plugin.json` -- Claude Code plugin manifest (for backward compatibility)

## Optional Components

- `commands/*.md` -- slash commands
- `hooks/hooks.json` + `hooks/scripts/` -- event hooks
- `.mcp.json` -- MCP server configuration
- `agents/` -- agent definitions
- `skills/` -- skill definitions

## Categories

- `development` -- build tools, code analysis, CI/CD
- `productivity` -- notifications, automation, workflow
- `testing` -- test runners, coverage, quality

## Code Style

- Shell scripts: bash, quote variables, use `set -euo pipefail`
- JSON: 2-space indent
- Markdown: ATX headings, fenced code blocks
