# AGENTS.md

Instructions for AI coding agents working on this repository.

## Setup Commands

### Initial Setup

- Verify project structure: `make verify`
- Check dependencies: `make check-deps`

### Pre-commit Setup

**CRITICAL**: AI agents making commits MUST set up pre-commit hooks:

```bash
# Install pre-commit hooks (required before first commit)
pre-commit install

# Run pre-commit on all files before committing
pre-commit run --all-files
```

This ensures all commits pass CI/CD checks. See [.github/PRE_COMMIT_SETUP.md](.github/PRE_COMMIT_SETUP.md) for details.

## Code Style

### General Guidelines

- Follow existing code patterns in the repository
- Use consistent indentation (spaces, not tabs)
- Ensure files end with a newline
- Remove trailing whitespace
- Use LF line endings (not CRLF)

### Shell Scripts

- Use `#!/usr/bin/env bash` shebang
- Make scripts executable: `chmod +x script.sh`
- Follow shellcheck guidelines (error severity only)
- Use consistent quoting and error handling

### Markdown

- Follow markdownlint rules (see `.markdownlint.json`)
- Use proper heading hierarchy
- Keep line length reasonable

### Python (if any)

- Use Black formatter (configured in pre-commit)
- Follow PEP 8 style guidelines
- Run bandit security checks

## Testing Instructions

### Pre-commit Checks

Before committing, run:

```bash
pre-commit run --all-files
```

This runs all configured hooks:
- File quality checks (end-of-file, whitespace, line endings)
- YAML/JSON validation
- Python syntax and formatting
- Security checks (bandit, detect-private-key)
- Linting (shellcheck, yamllint, markdownlint)

### Verification

Verify project structure:

```bash
make verify
```

This checks that `.cursor/`, `cursor/commands/`, `cursor/skills/`, and `cursor/agents/` exist.

### CI/CD Checks

All PRs must pass:
- `pre-commit` - All pre-commit hooks
- `lint-pr-title` - PR title validation (semantic format)
- `sync` - Repository sync checks

## PR Instructions

### Pull Request Title Format

**CRITICAL**: All PR titles MUST follow [Conventional Commits](https://www.conventionalcommits.org/) format:

```
<type>(<scope>): <description>
```

**Requirements:**
- **Semantic**: Use proper type (feat, fix, docs, etc.)
- **Terse**: Keep under 50 characters when possible
- **Descriptive**: Clearly summarize the change
- **Imperative mood**: Use "add" not "added" or "adds"

**Valid types:** `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `chore`, `ci`, `build`, `revert`

**Examples:**
- ✅ `feat(api): add user search endpoint`
- ✅ `fix(auth): resolve token expiry bug`
- ✅ `docs(readme): update installation steps`
- ✅ `refactor(parser): simplify token handling`
- ✅ `chore(deps): update dependencies`
- ❌ `Added new feature` (not semantic)
- ❌ `Update files` (too vague)
- ❌ `Fixed a bug in the authentication module that was causing tokens to expire` (too verbose)

See [CONTRIBUTING.md](CONTRIBUTING.md#pull-request-titles) for complete guidelines.

### Before Submitting PR

1. **Run pre-commit**: `pre-commit run --all-files`
2. **Verify structure**: `make verify`
3. **Check dependencies**: `make check-deps`
4. **Ensure PR title is semantic**: Follow format above
5. **Update documentation**: If adding features, update relevant docs

## Security Considerations

### Pre-commit Security Checks

- `detect-private-key`: Detects private keys in code
- `bandit`: Python security linter

### Never Commit

- API keys or secrets
- Private keys or certificates
- Passwords or tokens
- Personal information

### GitHub Secrets

Required secrets are configured in repository settings (not in code):
- `AUTO_MERGE_TOKEN`
- `GH_TOKEN`
- `GITHUB_TOKEN` (auto-provided)

## Project Structure

**This repo is a standalone project. Rules, skills, and commands live in `cursor/`. Two symlinks only: (1) `.cursor` → `cursor/` so editors can self-edit; (2) global use = symlink skills/commands (e.g. `~/.cursor/skills` → repo `cursor/skills`). No install scripts or extra complexity.** See [Standalone Repository rule](.cursor/rules/standalone-repository.mdc).

### Key Directories

- `cursor/` - **Source of truth** for rules, skills, commands, agents. Edit here.
- `.cursor/` - Symlink to `cursor/` so Cursor IDE (and AI editors) see and can self-edit the same files.
- `cursor/commands/`, `cursor/skills/`, `cursor/agents/`, `cursor/rules/` - All artifacts live under `cursor/`.
- `docs/` - Documentation
- `scripts/` - Utility scripts (no global-install or symlink-creation scripts)

### Important Files

- `AGENTS.md` - This file (instructions for agents)
- `README.md` - Project overview and quick start
- `CONTRIBUTING.md` - Contribution guidelines
- `INSTALL.md` - Installation instructions
- `.pre-commit-config.yaml` - Pre-commit hook configuration
- `Makefile` - Common commands

## Workflow for AI Agents

### Standard Workflow

1. **Install pre-commit hooks** (once per session):
   ```bash
   pre-commit install
   ```

2. **Make code changes**

3. **Run pre-commit** before committing:
   ```bash
   pre-commit run --all-files
   ```

4. **Commit fixes** made by pre-commit

5. **Create PR** with semantic title

### Why Pre-commit is Required

- Automated commit tools bypass local git hooks
- Without pre-commit checks, commits will **fail CI/CD checks**
- This causes PR failures and requires additional fix-up commits
- Pre-commit catches issues like:
  - Trailing whitespace
  - Missing end-of-file newlines
  - Mixed line endings
  - CRLF issues
  - Python formatting (black)
  - Security issues (bandit)

## Meta Processes

This repository includes meta processes for self-improvement:

### Meta Commands

- `/process-chat` - Analyze AI chat conversations for patterns
- `/create-artifact` - Interactively create artifacts from patterns
- `/update-cross-references` - Maintain cross-references
- `/validate-organization` - Validate repository organization
- `/generate-docs-index` - Generate documentation indexes

### Meta Skills

- `conversation-analysis` - Analyze AI chat conversations
- `pattern-extraction` - Extract reusable patterns
- `artifact-creation` - Guide artifact creation
- `cross-reference-maintenance` - Maintain cross-references
- `find-skills` - Discover and install skills from [skills.sh](https://skills.sh/) when users ask "find a skill for X" or want to extend capabilities; uses `npx skills find` and `npx skills add`

### Meta Subagents

- `conversation-analyzer` - Analyze conversations in isolation
- `artifact-creator` - Create artifacts from patterns
- `cross-reference-maintainer` - Maintain cross-references
- `documentation-updater` - Update documentation

See [Meta Processes Guide](docs/meta-processes.md) for details on using these meta artifacts.

## Additional Resources

- [Cursor Rules Documentation](docs/cursor-rules.md) - Guide to Cursor Rules
- [Cursor Commands Documentation](docs/cursor-commands.md) - Guide to creating reusable workflows
- [Cursor Skills Documentation](docs/cursor-skills.md) - Guide to extending AI agents with specialized capabilities
- [Cursor Subagents Documentation](docs/cursor-subagents.md) - Guide to specialized AI assistants for complex tasks
- [Meta Processes Guide](docs/meta-processes.md) - Guide to meta processes for self-improvement
- [Self-Improvement Workflow](docs/self-improvement-workflow.md) - Step-by-step self-improvement process
- [Organization Guide](docs/organization.md) - Organization structure guide
- [Automation Agents](docs/automation-agents.md) - GitHub Actions and automation workflows
- [Contributing Guidelines](CONTRIBUTING.md) - Detailed contribution standards
- [Installation Guide](INSTALL.md) - Comprehensive setup instructions

## Notes

- Commands, skills, and subagents are loaded from this project's `.cursor/` when the repo is open in Cursor (project-local only; no global `~/.cursor` install).
- Rules are in `.cursor/rules/` (see [docs/cursor-rules.md](docs/cursor-rules.md)).
- All changes must pass pre-commit hooks before committing.
