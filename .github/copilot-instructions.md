# Project Overview

This repository provides automation scaffolding for Cursor IDE, including commands, skills, and GitHub workflow automations. It serves as a template repository for setting up consistent development workflows, automated dependency management, and code quality checks.

## Purpose

- Provide reusable Cursor commands and skills structure
- Standardize GitHub Actions workflows for CI/CD
- Automate dependency management via Dependabot
- Enforce code quality through pre-commit hooks
- Maintain consistent repository settings and branch protection

## Technology Stack

- **GitHub Actions**: CI/CD workflows for automation
- **Pre-commit**: Code quality hooks (black, bandit, trailing-whitespace, etc.)
- **Python**: Primary language for scripts and tools
- **YAML**: Configuration for workflows, pre-commit, and GitHub settings
- **Markdown**: Documentation and instructions
- **Shell/Bash**: Utility scripts

## Repository Structure

```
.
├── .github/
│   ├── workflows/          # GitHub Actions workflows
│   ├── dependabot.yml      # Dependency automation config
│   ├── settings.yml        # Repository settings (via Probot)
│   ├── labeler.yml         # PR auto-labeling rules
│   └── pull_request_template.md
├── cursor/
│   ├── commands/           # Cursor IDE commands
│   └── skills/             # Cursor IDE skills
├── scripts/                # Utility scripts
├── templates/              # Reusable templates
└── docs/                   # Documentation
```

## Coding Standards

### General Guidelines

- **Line Endings**: Use LF (Unix-style) line endings, not CRLF
- **Indentation**: Use spaces, not tabs (4 spaces for Python, 2 spaces for YAML)
- **File Endings**: Always end files with a newline
- **Trailing Whitespace**: Remove all trailing whitespace
- **Encoding**: Use UTF-8 without BOM (Byte Order Mark)

### Python Standards

- Follow PEP 8 style guide
- Use `black` for code formatting (enforced by pre-commit)
- Use `bandit` for security linting
- Avoid debug statements in committed code
- Use descriptive variable and function names
- Add docstrings to functions and classes

### YAML Standards

- Indent with 2 spaces
- Use lowercase for keys
- Quote strings when they contain special characters
- Keep workflow files organized with clear job and step names
- Add comments to explain non-obvious configurations

### Documentation Standards

- Use Markdown for all documentation
- Follow consistent heading hierarchy
- Include code blocks with proper syntax highlighting
- Add links to relevant resources
- Keep documentation up-to-date with code changes
- Use relative links for internal documentation

## GitHub Actions Patterns

### Workflow Structure

```yaml
name: Descriptive Workflow Name

on:
  pull_request:
    branches: [main]

jobs:
  job-name:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Descriptive step name
        run: |
          # Commands here
```

### Best Practices

- Use specific action versions (e.g., `@v4`, not `@latest`)
- Cache dependencies when possible
- Use matrix builds for multi-version testing
- Set appropriate permissions for workflows
- Use secrets for sensitive data
- Add descriptive names to all jobs and steps
- Group related steps with clear comments

## Pre-commit Hooks

All code must pass pre-commit hooks before committing:

- `end-of-file-fixer`: Ensures files end with newline
- `trailing-whitespace`: Removes trailing spaces
- `mixed-line-ending`: Enforces consistent line endings
- `check-merge-conflict`: Detects merge conflict markers
- `check-ast`: Validates Python syntax
- `black`: Python code formatting
- `bandit`: Python security checks
- `forbid-crlf` and `remove-crlf`: Enforce LF line endings
- `forbid-tabs` and `remove-tabs`: Enforce spaces over tabs

### Running Pre-commit

```bash
# Install pre-commit hooks
pre-commit install

# Run on all files
pre-commit run --all-files

# Run on staged files
pre-commit run
```

### For AI Agents (CRITICAL)

**AI agents and automated tools MUST install and run pre-commit hooks** to prevent CI failures:

```bash
# 1. Install hooks at session start
pre-commit install

# 2. Run pre-commit before committing
pre-commit run --all-files

# 3. Then use automated commit tools (e.g., report_progress)
```

**Why this matters:**
- Automated commit tools bypass local git hooks
- Without pre-commit, commits fail CI/CD checks
- Causes PR failures requiring fix-up commits

**See also:**
- [AGENTS.md - AI Agent Guidelines](../AGENTS.md#ai-agent-guidelines) - Comprehensive AI agent workflow
- [.github/PRE_COMMIT_SETUP.md](.github/PRE_COMMIT_SETUP.md) - Detailed pre-commit setup guide

## Automation Patterns

### Dependabot

- Daily dependency updates for all ecosystems
- Automatic grouping of patch updates
- Auto-merge enabled for minor/patch updates
- Major version updates require manual review

### Branch Protection

- All changes must go through pull requests
- PRs must be up-to-date with `main` before merging
- Required status checks: `pre-commit`, `sync`
- Enforce linear history (squash merge only)
- Auto-delete branches after merge

### Pull Request Workflow

1. Create feature branch from `main`
2. Make changes and commit
3. Pre-commit hooks run automatically
4. Push to remote and create PR
5. Automated labeling based on changed files
6. Required status checks must pass
7. PR title must follow Conventional Commits format - **terse and semantic** (see [CONTRIBUTING.md](../CONTRIBUTING.md#pull-request-titles) for details)
8. Squash merge to `main`
9. Branch automatically deleted

### Pull Request Title Requirements

**CRITICAL for AI Agents**: All pull request titles MUST be:

- **Semantic**: Follow [Conventional Commits](https://www.conventionalcommits.org/) format: `type(scope): description`
- **Terse**: Keep under 50 characters when possible
- **Descriptive**: Clearly summarize the essence of the change
- **Imperative mood**: Use "add" not "added" or "adds"

**Examples:**
- ✅ `feat(api): add user search endpoint`
- ✅ `fix(auth): resolve token expiry bug`
- ✅ `docs(readme): update installation steps`
- ❌ `Added new feature` (not semantic)
- ❌ `Update files` (too vague)
- ❌ `Fixed a bug in the authentication module that was causing tokens to expire` (too verbose)

For comprehensive guidelines, see [CONTRIBUTING.md](../CONTRIBUTING.md#pull-request-titles).

## Testing and Validation

### Before Committing

- Run pre-commit hooks: `pre-commit run --all-files`
- Test any new scripts or commands locally
- Validate YAML syntax for workflow files
- Check that documentation builds correctly

### PR Validation

- PR titles must follow conventional commits format
- All pre-commit checks must pass
- Workflows must complete successfully
- Documentation must be updated for feature changes

## Common Patterns and Examples

### Adding a New GitHub Action Workflow

```yaml
name: New Workflow

on:
  pull_request:
    branches: [main]
  workflow_dispatch:  # Allow manual trigger

jobs:
  build:
    runs-on: ubuntu-latest
    permissions:
      contents: read

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Setup environment
        run: |
          echo "Setting up environment"

      - name: Run action
        run: |
          echo "Performing action"
```

### Adding a Pre-commit Hook

```yaml
- repo: https://github.com/example/hook-repo
  rev: v1.0.0
  hooks:
  - id: hook-id
    args: ['--option', 'value']
```

### Creating Cursor Commands

Place command files in `cursor/commands/` directory following the Cursor command format.

### Creating Cursor Skills

Place skill files in `cursor/skills/` directory following the Cursor skill format.

## Security Considerations

- Never commit secrets or sensitive data
- Use GitHub secrets for workflow credentials
- Run `bandit` security checks on Python code
- Keep dependencies up-to-date via Dependabot
- Review automated PRs before merging
- Use minimal permissions in workflows

## References

### External Documentation

**Note**: External URLs may be blocked by firewall rules in CI/automated environments. Cursor.com documentation is cached during setup steps at `/tmp/cursor-docs/`. See [CURSOR_DOCS_CACHE.md](CURSOR_DOCS_CACHE.md) for details.

- [Pre-commit Documentation](https://pre-commit.com/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [Black Code Formatter](https://black.readthedocs.io/)
- [Dependabot Documentation](https://docs.github.com/en/code-security/dependabot)

### Internal Documentation (AI Agents)

> **For Maintainers**: When updating AI agent instructions, remember to update all related files:

- [AGENTS.md](../AGENTS.md) - Comprehensive automation agents and workflows documentation, including AI agent guidelines
- [.github/PRE_COMMIT_SETUP.md](PRE_COMMIT_SETUP.md) - Detailed pre-commit setup and troubleshooting for AI agents
- This file (.github/copilot-instructions.md) - Copilot-specific project instructions
