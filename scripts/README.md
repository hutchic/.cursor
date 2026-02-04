# Scripts

This directory contains utility scripts for Cursor automation.

## Available Scripts

### gpr - Create or Update Pull Request

The `gpr` script creates or updates GitHub pull requests for the current branch.

**Usage:**

```bash
./scripts/gpr "feat(api): add search endpoint"
```

**Features:**

- Automatically pushes the current branch to remote
- Detects if a PR already exists and updates it (no duplicates)
- Works with GitHub CLI (gh) or GitHub MCP
- Generates standardized PR body with:
  - Summary
  - Commit list
  - Validation checklist
  - Code snippet
  - Risk assessment

**Options:**

- `--snippet-mode MODE`: Choose snippet type (auto, file, paste)
- `--snippet-path PATH`: File path for 'file' mode
- `--snippet-content CONTENT`: Custom content for 'paste' mode

**Requirements:**

- GitHub CLI (`gh`) installed and authenticated, OR
- GitHub MCP server configured

See the [Cursor command documentation](../cursor/commands/gpr.md) for more details.

### test_gpr.sh - Test Suite for gpr

Runs validation tests for the `gpr` script.

**Usage:**

```bash
./scripts/test_gpr.sh
```

**Tests:**

- Help flag functionality
- Argument validation
- Snippet mode validation
- Error handling

## Installation

To use these scripts from anywhere, you can:

1. Add the scripts directory to your PATH:

   ```bash
   export PATH="$PATH:$(pwd)/scripts"
   ```

2. Or create symlinks in a directory that's already in your PATH:

   ```bash
   ln -s "$(pwd)/scripts/gpr" /usr/local/bin/gpr
   ```

3. Or use the Cursor command interface (recommended):

   Simply type `/gpr` in Cursor to use the command.
