# Cursor Artifacts (Project-Local)

This repository provides rules, skills, commands, and subagents for use **in this project** when opened in Cursor. There is no global installation or symlinking to `~/.cursor/`.

## Quick Start

1. **Clone and open in Cursor** — that's it.
2. Rules, commands, skills, and subagents live in `.cursor/` and are available when this repository is open.

**No installation required.** Everything works when you open this repository in Cursor.

## Canonical DX model: rules, hooks, subagents vs commands and skills

Cursor does not have a separate "global" directory for rules, hooks, or subagents. This repo treats them as follows:

- **Rules, hooks, subagents** — Canonical versions live in **this repo** (`.cursor/rules`, `.cursor/hooks`, `.cursor/agents`). They are **installed into** each target project by the **installation script** (with prompts so you can skip any category). Run `./scripts/install-self-improvement.sh [TARGET_DIR]` from this repo; the script will prompt to install rules, hooks (if present), and subagents. It will not overwrite existing files without confirmation.
- **Commands and skills** — To use this repo's commands and skills in **all** projects, **symlink** them from your user directory so Cursor sees them globally:
  - `ln -s "$(pwd)/.cursor/commands" ~/.cursor/commands`
  - `ln -s "$(pwd)/.cursor/skills" ~/.cursor/skills`
  (Run from this repo root. Adjust paths if your clone is elsewhere.) No installation script for commands/skills; symlinking makes them available everywhere.

Use **dry-run** to see what would be installed without writing: `./scripts/install-self-improvement.sh --dry-run [TARGET_DIR]`.

## Using These Artifacts in Other Projects

To use the same artifacts elsewhere:

- **Copy** the rules, skills, commands, or subagents you need into that project's `.cursor/` structure.
- **Reference** this repo in that project's docs or AGENTS.md.
- **Use as template** — fork or copy this repo and trim to your needs.

### Self-improvement in other projects

To give another Cursor project the ability to **retrospect and self-improve** (analyze conversations, extract patterns, create/update rules, skills, commands, subagents, hooks, and docs), use the **self-improvement bundle**. Run the interactive script from this repo: `./scripts/install-self-improvement.sh [TARGET_DIR]`. You will be prompted to install rules, hooks (if present), and subagents; installation is not required for any category. The script copies the selected bundle into the target (no symlinks), so the target stays portable. Use `--dry-run` to preview. See [Self-Improvement Bundle](docs/self-improvement-bundle.md) for the full file list and manual copy steps.

## Prerequisites

| Tool | Purpose |
|------|---------|
| **Cursor IDE** | The IDE these artifacts are for |
| **Git** | Version control |
| **Bash** | Shell (for any scripts) |

Optional for contributors: **Python 3.7+**, **pre-commit** (see [Contributing](CONTRIBUTING.md)).

## Verification

Check that the project structure is present:

```bash
make verify
```

This confirms `.cursor/`, `.cursor/commands/`, `.cursor/skills/`, and `.cursor/agents/` exist.

## Optional: GitHub CLI

Some commands may use GitHub CLI. Install and authenticate if needed:

- macOS: `brew install gh && gh auth login`
- See [GitHub CLI](https://cli.github.com/) for other platforms.

## Optional: Pre-commit (Contributors)

If you contribute to this repo:

```bash
pip3 install pre-commit
pre-commit install
pre-commit run --all-files
```

See [.github/PRE_COMMIT_SETUP.md](.github/PRE_COMMIT_SETUP.md).

## Updating

```bash
git pull origin main
make verify
```

## Related Documentation

- [README.md](README.md) - Overview and quick start
- [CONTRIBUTING.md](CONTRIBUTING.md) - How to contribute
- [AGENTS.md](AGENTS.md) - Instructions for AI coding agents
- [docs/cursor-commands.md](docs/cursor-commands.md) - Commands
- [docs/cursor-skills.md](docs/cursor-skills.md) - Skills
- [docs/cursor-rules.md](docs/cursor-rules.md) - Rules
- [docs/cursor-subagents.md](docs/cursor-subagents.md) - Subagents
