# Skills Marketplace

Curated collection of skills for AI coding agents. Each skill adds commands, hooks, MCP servers, or agents to enhance development workflows.

Compatible with 40+ agents via [skills.sh](https://skills.sh): Claude Code, Codex, Cursor, Copilot, and more.

## Repo Structure

```
skills/<skill-name>/
  SKILL.md                     # Skill manifest for skills.sh (name, description, instructions)
  .claude-plugin/plugin.json   # Claude Code plugin manifest
  README.md                    # Skill docs
  commands/                    # Slash commands (optional)
  hooks/                       # Hook definitions (optional)
  .mcp.json                    # MCP server config (optional)
```

Root `.claude-plugin/marketplace.json` registers all skills for Claude Code plugin system.

## Adding a New Skill

1. Create `skills/<skill-name>/` directory
2. Add `SKILL.md` with frontmatter:
   ```markdown
   ---
   name: <skill-name>
   description: Short description of what the skill does and when to use it
   ---

   # Skill Name

   Instructions for the agent...
   ```
3. Add `.claude-plugin/plugin.json` (for Claude Code compatibility):
   ```json
   {
     "name": "<skill-name>",
     "description": "Short description",
     "version": "1.0.0"
   }
   ```
4. Add `README.md` with features, requirements, usage
5. Add components: `commands/`, `hooks/`, `.mcp.json` as needed
6. Register in `.claude-plugin/marketplace.json` under `plugins` array
7. Update root `README.md` with skill listing

## Installation

### Any Agent (via skills.sh)

```bash
npx skills add artemnovichkov/skills
```

### Claude Code

```bash
/plugin marketplace add artemnovichkov/skills
```

## Conventions

- `SKILL.md` is the universal skill manifest (skills.sh ecosystem)
- `.claude-plugin/` dirs and `plugin.json` are Claude Code conventions -- keep both for compatibility
- `$CLAUDE_PLUGIN_ROOT` env var in hooks references skill root at runtime (Claude Code specific)
- Keep skills self-contained (no cross-skill dependencies)
- Skills should document agent compatibility in their README
