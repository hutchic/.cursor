# Commands

This directory contains Cursor automation commands.

## Available Commands

### gship - Semantic Commit + PR Command

Creates semantic commits and pull requests with sensible defaults. Internally uses `gadd` for staging and `gpr` for PR creation. Automatically creates feature branches, stages files, generates semantic messages if not provided, and creates draft PRs.

[Full Documentation](README_GSHIP.md)

**Quick Start:**

```bash
# Fully automated - no arguments needed!
gship

# Or provide explicit message
gship "feat(api): add search endpoint"

# Commit only (skip PR creation)
gship "fix: resolve bug" --no-pr
```

## Meta Commands

### `/create-command` - Scaffold New Commands

Creates a new Cursor command with self-contained directory structure and proper documentation following repository best practices.

**Usage:**

```bash
# Create a new command with description
create-command my-command --description="Does something useful"

# Create with default description
create-command another-command
```

**Features:**
- Generates self-contained command directory
- Creates executable with proper template
- Generates comprehensive README.md
- Creates lib/, tests/, examples/ subdirectories
- Updates commands README automatically
- Validates command naming conventions

**Options:**
- `--description="..."`: Brief description of the command
- `--help`: Show help message

**Directory Structure Created:**
```
cursor/commands/
└── my-command/
    ├── README.md          # Full documentation
    ├── my-command         # Executable script
    ├── lib/               # Helper modules
    ├── tests/             # Test suite
    └── examples/          # Usage examples
```

[Full Documentation](create-command)

## Development Guide

For comprehensive guidance on developing commands, see:
- [COMMAND_DEVELOPMENT_GUIDE.md](../COMMAND_DEVELOPMENT_GUIDE.md) - Complete guide with best practices
- [command-development skill](../skills/command-development.md) - AI context for command development

**Key Topics:**
- Self-contained directory structure (required for all commands)
- Command templates and patterns
- Documentation requirements
- Testing and validation
- Integration with other commands
- Repository conventions

## Structure

All commands use **self-contained directory structure**:

```
cursor/commands/
├── README.md                 # This file
└── command-name/
    ├── README.md             # Required: Documentation
    ├── command-name          # Required: Main executable
    ├── lib/                  # Optional: Helper modules
    ├── tests/                # Optional: Test suite
    └── examples/             # Optional: Usage examples
```

### Why Directory Structure?

1. **Consistency**: All commands follow the same pattern
2. **Scalability**: Easy to add helpers, tests, examples
3. **Organization**: Related files grouped together
4. **Maintainability**: Clear separation of concerns
5. **Testability**: Dedicated space for test files
6. **Documentation**: Examples and docs with the code

### Legacy Commands

Some existing commands (`gadd`, `gship`, `gpr.md`) currently use individual files. These represent legacy structure and should be migrated to directories in future updates.

**All new commands must use directory structure.**

See [COMMAND_DEVELOPMENT_GUIDE.md](../COMMAND_DEVELOPMENT_GUIDE.md) for migration guidance.

## Available Commands

### `/gadd` - Smart Git Staging Command

A guided and intelligent way to stage changes by logical groupings.

#### Usage

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

#### Features

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

#### Examples

**Scenario 1: Quick staging of everything**

```bash
$ gadd all
Staging all changes...
✓ All changes staged
```

**Scenario 2: Guided staging with prompts**

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

**Scenario 3: Stage only documentation**

```bash
$ gadd group=docs
Staging bucket: docs (2 file(s))
✓ Staged 2 file(s) from bucket: docs

=== Staged Changes (diff --cached --stat) ===
 README.md     | 10 ++++++++--
 docs/guide.md |  5 ++++-
 2 files changed, 12 insertions(+), 3 deletions(-)
```

#### Installation

The command is automatically available after symlinking the commands directory:

```bash
ln -s "$(pwd)/cursor/commands" ~/.cursor/commands
```
