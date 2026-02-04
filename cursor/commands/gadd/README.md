# gadd - Smart Git Staging Command

A guided and intelligent way to stage changes by logical groupings.

## Overview

`gadd` is a smart git staging command that automatically classifies your changes into logical buckets (dependencies, source code, tests, docs, CI, config, misc) and lets you stage them selectively or all at once.

## Usage

```bash
# Guided mode (default) - prompts for each bucket
gadd

# Stage all changes at once
gadd all

# Stage specific bucket
gadd group=deps    # Stage only dependency files
gadd group=src     # Stage only source code
gadd group=tests   # Stage only test files
gadd group=docs    # Stage only documentation
gadd group=ci      # Stage only CI configuration
gadd group=config  # Stage only config files
gadd group=misc    # Stage only miscellaneous files
```

## Features

- **Logical Grouping**: Automatically classifies files into buckets
  - `deps`: Lockfiles and dependency manifests (package-lock.json, Gemfile.lock, etc.)
  - `src`: Application/runtime code (*.py, *.js, *.java, *.go, etc.)
  - `tests`: Test files and fixtures (test_*.py, *.test.js, __tests__/, etc.)
  - `docs`: Documentation files (README, *.md, docs/, etc.)
  - `ci`: CI/CD configs (.github/, .gitlab-ci.yml, Jenkinsfile, etc.)
  - `config`: Configuration files (*.yaml, *.json, Dockerfile, etc.)
  - `misc`: Anything not matched by above buckets

- **Safety Checks**:
  - Exits if no changes exist
  - Blocks staging if conflicts or unmerged paths exist
  - Never commits or pushes (staging only)

- **Post-Staging Visibility**:
  - Shows `git diff --cached --stat`
  - Shows `git status --porcelain`

## Examples

### Scenario 1: Quick staging of everything

```bash
$ gadd all
Staging all changes...
✓ All changes staged
```

### Scenario 2: Guided staging with prompts

```bash
$ gadd
Guided staging mode

Bucket: deps (1 file(s))
  - package.json
Stage this bucket? (y/n): y
✓ Staged 1 file(s) from bucket: deps

Bucket: src (3 file(s))
  - src/app.py
  - src/utils.py
  - src/config.py
Stage this bucket? (y/n): n
✗ Skipped bucket: src
...
```

### Scenario 3: Stage only documentation

```bash
$ gadd group=docs
Staging bucket: docs (2 file(s))
✓ Staged 2 file(s) from bucket: docs

=== Staged Changes (diff --cached --stat) ===
 README.md     | 10 ++++++++--
 docs/guide.md |  5 ++++-
 2 files changed, 12 insertions(+), 3 deletions(-)
```

## Requirements

- Git
- Bash 4.0+

## Installation

The command is automatically available after symlinking the commands directory:

```bash
ln -s "$(pwd)/cursor/commands/gadd/gadd" ~/.cursor/commands/gadd
```

## Error Handling

### No Changes to Stage

```
No changes to stage
```

### Repository Has Conflicts

```
Error: Repository has conflicts or unmerged paths
Please resolve conflicts before staging
```

### Invalid Bucket Name

```
Error: Invalid bucket name 'invalid'
Valid buckets: deps, src, tests, docs, ci, config, misc
```

## Notes

- Command is idempotent - safe to run multiple times
- Never commits or pushes, only stages files
- Works with any git repository
- Respects gitignore patterns
