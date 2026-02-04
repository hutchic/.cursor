# Pre-commit Setup

This document explains how to set up pre-commit hooks to ensure code quality before commits.

## Why Pre-commit Hooks?

Pre-commit hooks automatically check and fix common issues before code is committed, including:
- Trailing whitespace
- End-of-file fixers
- Mixed line endings
- CRLF/tabs issues
- Python code formatting (black)
- Security checks (bandit)

## Installation

**IMPORTANT**: Pre-commit hooks must be installed locally to work. They are NOT automatically installed when cloning the repository.

### Install Pre-commit Hooks

```bash
# Install pre-commit hooks (run once after cloning)
pre-commit install

# Verify installation
ls -la .git/hooks/pre-commit
```

### Manual Pre-commit Run

You can manually run pre-commit checks before committing:

```bash
# Run on all files
pre-commit run --all-files

# Run on staged files only
pre-commit run

# Run on specific files
pre-commit run --files path/to/file1 path/to/file2
```

## CI/CD Integration

The repository has a GitHub Actions workflow (`.github/workflows/pre-commit.yml`) that runs pre-commit checks on all pull requests. If the CI fails:

1. Run `pre-commit run --all-files` locally
2. Commit any fixes made by pre-commit
3. Push the changes

## For AI Agents

**Critical**: AI agents using the `report_progress` tool or similar automated commit mechanisms MUST:

> **Note for Maintainers**: This guidance is also documented in:
> - [AGENTS.md - AI Agent Guidelines](../AGENTS.md#ai-agent-guidelines) - Main AI agent workflow documentation
> - [.github/copilot-instructions.md](copilot-instructions.md#for-ai-agents-critical) - Copilot-specific instructions
>
> When updating AI agent pre-commit requirements, ensure all locations are kept in sync.

1. **Install pre-commit hooks** at the start of each session:
   ```bash
   pre-commit install
   ```

2. **Run pre-commit before committing**:
   ```bash
   pre-commit run --all-files
   ```

3. **Commit any fixes** made by pre-commit before using `report_progress`

### Why This Matters

The `report_progress` tool and other automated commit mechanisms bypass local git hooks. Without explicitly running pre-commit:
- Commits may fail CI checks
- Code quality issues slip through
- PRs require additional fix-up commits

## Pre-commit Configuration

The pre-commit configuration is in `.pre-commit-config.yaml`. It includes:

- **pre-commit-hooks**: Standard hooks for file formatting
- **black**: Python code formatter
- **bandit**: Python security checker
- **Lucas-C hooks**: CRLF and tab checkers

## Troubleshooting

### Hooks not running on commit

```bash
# Reinstall hooks
pre-commit install

# Check hook is installed
ls -la .git/hooks/pre-commit
```

### CI failing but local checks pass

```bash
# Update pre-commit hooks to match CI
pre-commit autoupdate

# Run with same Python version as CI (3.9)
python3.9 -m pre_commit run --all-files
```

### Skipping pre-commit (NOT recommended)

```bash
# Only use in emergencies
git commit --no-verify -m "message"
```

## References

- [Pre-commit documentation](https://pre-commit.com/)
- [Repository pre-commit config](.pre-commit-config.yaml)
- [CI workflow](.github/workflows/pre-commit.yml)
