# Skills Marketplace

Curated collection of Claude Code skills. Each skill adds commands, hooks, MCP servers, or agents.

## Repo Structure

```
skills/<skill-name>/
  .claude-plugin/plugin.json   # Skill manifest (name, description, version)
  README.md                    # Skill docs
  commands/                    # Slash commands (optional)
  hooks/                       # Hook definitions (optional)
  .mcp.json                    # MCP server config (optional)
```

Root `.claude-plugin/marketplace.json` registers all skills.

## Adding a New Skill

1. Create `skills/<skill-name>/` directory
2. Add `.claude-plugin/plugin.json`:
   ```json
   {
     "name": "<skill-name>",
     "description": "Short description",
     "version": "1.0.0"
   }
   ```
3. Add `README.md` with features, requirements, usage
4. Add components: `commands/`, `hooks/`, `.mcp.json` as needed
5. Register in `.claude-plugin/marketplace.json` under `plugins` array
6. Update root `README.md` with skill listing

## Conventions

- `.claude-plugin/` dirs and `plugin.json` files are framework conventions -- do not rename
- `$CLAUDE_PLUGIN_ROOT` env var in hooks references skill root at runtime
- Keep skills self-contained (no cross-skill dependencies)

## Testing

```bash
/plugin marketplace add artemnovichkov/skills
```

Then use the skill's commands or trigger its hooks.
