# Commands

This directory contains Cursor automation commands.

## Available Commands

### gship - Semantic Commit + PR Command

Creates semantic commits and pull requests with sensible defaults. Internally uses `gadd` for staging and `gpr` for PR creation. Automatically creates feature branches, stages files, generates semantic messages if not provided, and creates draft PRs.

[Full Documentation](gship/README.md)

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

[Full Documentation](create-command/README.md)

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

~~Some existing commands (`gadd`, `gship`, `gpr.md`) currently use individual files. These represent legacy structure and should be migrated to directories in future updates.~~

**Update**: All commands have been migrated to directory structure!

**All new commands must use directory structure.**

See [COMMAND_DEVELOPMENT_GUIDE.md](../COMMAND_DEVELOPMENT_GUIDE.md) for migration guidance.

## Available Commands

### `/gadd` - Smart Git Staging Command

A guided and intelligent way to stage changes by logical groupings.

[Full Documentation](gadd/README.md)

**Quick Usage:**

```bash
gadd              # Guided mode
gadd all          # Stage all
gadd group=docs   # Stage only docs
```

### `/gpr` - Create or Update Pull Request

Creates or updates a GitHub pull request for the current branch.

[Full Documentation](gpr/README.md)

**Quick Usage:**

```bash
gpr "feat(api): add search endpoint"
```
