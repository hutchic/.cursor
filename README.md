# Cursor Automation

This repository contains Cursor IDE automation commands and utilities.

## Quick Start

1. Install the commands:

   ```bash
   ln -s "$(pwd)/cursor/commands" ~/.cursor/commands
   ```

2. Use commands in Cursor IDE by typing `/` followed by the command name.

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

- `cursor/commands/` - Cursor IDE commands
- `cursor/skills/` - Cursor IDE skills
- `scripts/` - Utility scripts
- `templates/` - Template files

## Installation

See [INSTALL.md](INSTALL.md) for detailed installation instructions.
