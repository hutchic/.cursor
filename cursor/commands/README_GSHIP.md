# /gship - Semantic Commit Command

## Overview

`/gship` is a command that safely creates semantic commits from staged changes. It automatically creates feature branches when you're on a protected branch and enforces semantic commit message standards.

## Features

- ✅ **Protected Branch Detection**: Automatically creates a feature branch when on `main`, `master`, `trunk`, `develop`, or `release/*`
- ✅ **Semantic Commit Enforcement**: Validates commit messages follow semantic conventions
- ✅ **Hook & Signing Safety**: Never bypasses pre-commit hooks or GPG signing
- ✅ **Clean Branch Naming**: Generates normalized branch names from semantic messages
- ✅ **Clear Error Messages**: Provides helpful feedback when something goes wrong

## Usage

```bash
gship "<semantic-message>" [--mode=single|multi]
```

### Arguments

- `<semantic-message>`: A semantic commit message in the format `type(scope): summary` or `type: summary`
- `--mode`: Optional. Either `single` (default) or `multi` (experimental)

### Valid Semantic Types

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, missing semicolons, etc.)
- `refactor`: Code refactoring
- `perf`: Performance improvements
- `test`: Adding or updating tests
- `chore`: Maintenance tasks
- `build`: Build system changes
- `ci`: CI/CD changes
- `revert`: Reverting previous changes

## Examples

### Basic Usage

```bash
# On main branch - creates feat/api-add-search-endpoint
gship "feat(api): add search endpoint"

# On main branch - creates fix/resolve-null-pointer
gship "fix: resolve null pointer"

# On feature branch - commits to current branch
gship "docs: update installation guide"
```

### With Scope

```bash
# Creates feat/auth-add-oauth-support
gship "feat(auth): add OAuth support"

# Creates fix/database-connection-leak
gship "fix(database): resolve connection leak"
```

### Without Scope

```bash
# Creates chore/update-dependencies
gship "chore: update dependencies"

# Creates test/add-integration-tests
gship "test: add integration tests"
```

## Workflow

### From Protected Branch (main/master/trunk/develop/release/*)

1. Stage your changes: `git add <files>`
2. Run: `gship "feat(api): add endpoint"`
3. Result:
   - Creates new branch: `feat/api-add-endpoint`
   - Switches to new branch
   - Creates commit with message: `feat(api): add endpoint`

### From Feature Branch

1. Stage your changes: `git add <files>`
2. Run: `gship "fix: resolve bug"`
3. Result:
   - Stays on current branch
   - Creates commit with message: `fix: resolve bug`

## Acceptance Criteria Coverage

### ✅ AC-1: Semantic Commit Creation
Given staged files exist, when user runs `/gship feat(api): add search`, then a commit is created with subject `feat(api): add search`.

### ✅ AC-2: No Staged Files
Given no staged files exist, when user runs `/gship ...`, then command exits and suggests staging files first.

### ✅ AC-3: Protected Branch Detection
Given user is on main, when user runs `/gship ...`, then a new branch is created before committing.

### ✅ AC-4: Feature Branch Workflow
Given user is on feat/foo, when user runs `/gship ...`, then no new branch is created.

### ✅ AC-5: Hook Failure Handling
Given commit hooks fail, when user runs `/gship ...`, then no commit is created and error is surfaced.

### ✅ AC-6: GPG Signing Respect
Given GPG signing is configured and fails, when user runs `/gship ...`, then no commit is created and error is surfaced.

### ⚠️ AC-7: Multi-Commit Mode
Given mode=multi, when staged changes represent multiple logical groups, then implementation falls back to single-commit mode with a warning.

## Error Handling

### No Staged Files
```
Error: No staged changes found
Please stage your changes first with 'git add' or '/gadd'
```

### Invalid Semantic Message
```
Error: Invalid semantic commit format
Valid types: feat, fix, docs, style, refactor, perf, test, chore, build, ci, revert
Format: 'type(scope): summary' or 'type: summary'
Example: 'feat(api): add search' or 'fix: resolve bug'
```

### Pre-commit Hook Failure
```
Error: Commit failed
This could be due to:
  - Pre-commit hooks failing
  - GPG signing issues
  - Other git errors
```

### Branch Already Exists
```
Error: Branch 'feat/api-add-search' already exists
Please use a different semantic message or switch to the existing branch
```

## Safety Guarantees

1. **Never bypasses hooks**: Uses plain `git commit -m` without `--no-verify`
2. **Never bypasses signing**: No `--no-gpg-sign` flag is used
3. **Fails fast**: Stops immediately on any error
4. **Protected branch safety**: Prevents direct commits to protected branches

## Branch Naming Convention

Branches are created following the pattern: `<type>/<scope>-<summary>`

Examples:
- `feat(api): add search` → `feat/api-add-search`
- `fix: resolve bug` → `fix/resolve-bug`
- `chore(deps): update packages` → `chore/deps-update-packages`

### Normalization Rules

1. Convert to lowercase
2. Replace non-alphanumeric characters with hyphens
3. Collapse multiple consecutive hyphens
4. Remove leading/trailing hyphens

## Limitations

- Multi-commit mode is not fully implemented (falls back to single-commit)
- No automatic file staging (use `git add` or `/gadd` first)
- No PR creation (handled separately)
- No automatic pushing (use `git push` separately)

## Integration

This command integrates with:
- Git pre-commit hooks (always runs them)
- GPG signing configuration (always respects it)
- Protected branch policies (enforces branch creation)

## Installation

The command is automatically available when the `cursor/commands` directory is symlinked to `~/.cursor/commands`.

See [INSTALL.md](../../INSTALL.md) for setup instructions.
