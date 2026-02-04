# Global Rules Setup

## How Cursor Loads Rules, Commands, and Skills

- **Project artifacts**: When you open a project, Cursor loads rules, commands, skills, and subagents from that project's `.cursor/` (or equivalent) directory. This repository does **not** install anything into `~/.cursor/` (no global symlinks).
- **Rules**: Typically managed via **Cursor Settings → Rules** or by placing rule files in the project's `.cursor/rules/` directory.
- **Commands and skills**: Loaded from the project's `.cursor/commands/` and `.cursor/skills/` when that project is open.

## Using This Repo’s Rules in Other Projects

To use rules (or other artifacts) from this repository in another project:

1. **Cursor Settings UI**: In the other project, open Cursor Settings → Rules and add or import the rules you want.
2. **Copy into the project**: Create `.cursor/rules/` in the other project and copy (or symlink) the rule files from this repo.
3. **AGENTS.md**: In the other project, reference this repository or paste relevant guidance into `AGENTS.md`.

## Reference

- Rules: [docs/cursor-rules.md](cursor-rules.md)
- Commands: [docs/cursor-commands.md](cursor-commands.md)
- Skills: [docs/cursor-skills.md](cursor-skills.md)
- Subagents: [docs/cursor-subagents.md](cursor-subagents.md)
