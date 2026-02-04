# Cursor Automation

This repository contains Cursor IDE automation commands and utilities.

## Quick Start

### Option 1: Self-Configuring (Recommended)

This repository is **self-configuring** when opened in Cursor IDE:

1. Clone or open this repository in Cursor
2. The `.cursor/` directory in the project root provides immediate access to commands
3. Use commands by typing `/` followed by the command name

**No manual installation required!**

### Option 2: Global Installation

To use these commands across all projects:

```bash
ln -s "$(pwd)/cursor/commands" ~/.cursor/commands
ln -s "$(pwd)/cursor/skills" ~/.cursor/skills
```

See [INSTALL.md](INSTALL.md) for detailed installation instructions.

## Available Commands

### `/gpr` - Create or Update Pull Request

Creates or updates a GitHub pull request for the current branch.

**Usage:**

```
/gpr "feat(api): add search endpoint"
```

**Features:**

- Automatically pushes the current branch
- No duplicate PRs (updates existing PR if found)
- Standardized PR body format
- Works with GitHub CLI or GitHub MCP

[See full documentation](cursor/commands/gpr.md)

## Repository Setup

- detect-secrets scan > .secrets.baseline
- set github setting
  - allow auto-merge
  - automatically delete head branches
- set github branch protection rules:
  - require a pull request before merging
  - require status checks to pass
    - pre-commit
    - valid pr titles
    - sync
- set github secrets for actions and dependabot
  - AUTO_MERGE_TOKEN
  - GH_TOKEN

## Directory Structure

- `.cursor/` - Self-configuring symlinks (automatically used by Cursor IDE)
  - `commands/` → `../cursor/commands/`
  - `skills/` → `../cursor/skills/`
- `cursor/commands/` - Cursor IDE commands (source files)
- `cursor/skills/` - Cursor IDE skills (source files)
- `scripts/` - Utility scripts
- `templates/` - Template files

## Installation

See [INSTALL.md](INSTALL.md) for detailed installation instructions.
