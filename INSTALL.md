# Cursor Artifacts (Project-Local)

This repository provides rules, skills, commands, and subagents for use **in this project** when opened in Cursor. There is no global installation or symlinking to `~/.cursor/`.

## Quick Start

1. **Clone and open in Cursor** — that's it.
2. Rules, commands, skills, and subagents live in `.cursor/` and are available when this repository is open.

**No installation required.** Everything works when you open this repository in Cursor.

## Using These Artifacts in Other Projects

To use the same artifacts elsewhere:

- **Copy** the rules, skills, commands, or subagents you need into that project's `.cursor/` structure.
- **Reference** this repo in that project's docs or AGENTS.md.
- **Use as template** — fork or copy this repo and trim to your needs.

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
