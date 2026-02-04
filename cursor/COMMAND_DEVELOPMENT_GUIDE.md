# Command Development Guide

This guide provides best practices and conventions for developing Cursor IDE commands and skills.

## Overview

Cursor IDE commands are powerful tools that can be invoked with `/` in the chat interface. Commands can be:
- **Project-specific**: Stored in `.cursor/commands/` and version-controlled
- **Global**: Stored in `~/.cursor/commands/` for personal use across all projects

## Directory Structure: Self-Contained Approach

**All commands in this repository use self-contained directory structures.** This provides consistency, better organization, and room to grow.

### Standard Command Structure

Every command should be a self-contained directory:

```
cursor/commands/
├── README.md                 # Overview of all commands
└── mycommand/
    ├── README.md             # Command documentation
    ├── mycommand             # Main executable
    ├── lib/                  # Helper scripts/modules (optional)
    │   ├── utils.sh
    │   └── validators.sh
    ├── tests/                # Command tests (optional)
    │   └── test_mycommand.sh
    └── examples/             # Usage examples (optional)
        └── example.txt
```

### Minimum Required Structure

At minimum, each command directory must contain:
- **`commandname`** - The main executable script
- **`README.md`** - Complete command documentation

### Full Structure (Recommended)

For production-ready commands, include:
- **`commandname`** - Main executable
- **`README.md`** - Full documentation
- **`lib/`** - Helper modules and shared utilities
- **`tests/`** - Test suite for validation
- **`examples/`** - Usage examples and sample outputs

### Benefits of Directory Structure

1. **Consistency**: All commands follow the same pattern
2. **Scalability**: Easy to add helpers, tests, examples as command grows
3. **Discoverability**: Related files are grouped together
4. **Maintainability**: Clear separation of concerns
5. **Testability**: Dedicated space for test files
6. **Documentation**: Examples and docs live with the code
7. **Version Control**: Clean git diffs and file organization

## Example Command Structure

Here's what a well-organized command directory looks like:

```
cursor/commands/
└── gship/
    ├── README.md             # Full documentation
    ├── gship                 # Main executable
    ├── lib/
    │   ├── branch.sh         # Branch management helpers
    │   ├── commit.sh         # Commit creation logic
    │   └── pr.sh             # PR creation helpers
    ├── tests/
    │   ├── test_branch.sh
    │   ├── test_commit.sh
    │   └── test_integration.sh
    ├── examples/
    │   ├── basic-usage.md
    │   └── advanced-workflow.md
    └── templates/
        └── pr_body.md
```

## Command File Structure

### Executable Script Template

```bash
#!/usr/bin/env bash
# -*- coding: utf-8 -*-
# vim: ft=bash

#
# /command-name - Brief Description
#
# Detailed description of what the command does and its purpose.
#
# USAGE:
#   command-name [options] [arguments]
#
# DESCRIPTION:
#   Extended description with details about:
#   - What the command accomplishes
#   - Key features and capabilities
#   - Important behavior notes
#
# OPTIONS:
#   --option1    Description of option 1
#   --option2    Description of option 2
#
# EXAMPLES:
#   command-name --option1 value
#   command-name arg1 arg2
#
# NOTES:
#   - Important note 1
#   - Important note 2
#

set -euo pipefail

# Your implementation here
main() {
    echo "Hello from command-name"
}

main "$@"
```

### Documentation Template (Markdown)

```markdown
# Command Name - Brief Description

## Overview

Brief description of what the command does and why it exists.

## Usage

\`\`\`bash
command-name [options] [arguments]
\`\`\`

## Features

- ✅ Feature 1
- ✅ Feature 2
- ✅ Feature 3

## Options

- \`--option1 VALUE\`: Description of option 1
- \`--option2\`: Description of option 2 (boolean flag)

## Examples

### Example 1: Basic Usage

\`\`\`bash
command-name arg1 arg2
\`\`\`

Description of what this example does.

### Example 2: With Options

\`\`\`bash
command-name --option1 value arg1
\`\`\`

Description of what this example does.

## Requirements

- Dependency 1
- Dependency 2

## Installation

Instructions for any special installation steps if needed.

## Troubleshooting

### Issue 1

**Problem**: Description of issue
**Solution**: How to fix it

## Notes

- Important note 1
- Important note 2
```

## Naming Conventions

### File Naming

- **Use kebab-case**: `my-command`, `create-pr`, `run-tests`
- **Be descriptive**: Command name should clearly indicate its purpose
- **Avoid abbreviations**: Prefer `create-pull-request` over `cpr` (unless widely known like `git`)
- **Match executable and docs**: If command is `mycommand`, docs should be `mycommand.md` or `mycommand/README.md`

### Command Invocation

Commands are invoked with `/` in Cursor IDE:
- `/mycommand` - runs the command
- Command names appear in autocomplete
- Documentation is shown in hover tooltips

## Skills vs Commands

### Commands
- **Purpose**: Executable actions that perform tasks
- **Format**: Executable scripts (bash, python, etc.)
- **Location**: `cursor/commands/`
- **Example**: `/gship`, `/gadd`

### Skills
- **Purpose**: Knowledge and context for Cursor AI to reference
- **Format**: Markdown documentation
- **Location**: `cursor/skills/`
- **Example**: Code style guides, architecture patterns, best practices

## Development Workflow

### 1. Plan Your Command

Before writing code:
- Define the command's purpose and scope
- List required inputs and outputs
- Identify dependencies
- Determine which subdirectories you'll need (lib, tests, examples)

### 2. Create the Command

Use the `/create-command` meta-command to scaffold the structure:

```bash
create-command mycommand --description="Brief description of command"
```

Or create manually:

```bash
# Create directory structure
mkdir -p cursor/commands/mycommand/{lib,tests,examples}
touch cursor/commands/mycommand/README.md
touch cursor/commands/mycommand/mycommand
chmod +x cursor/commands/mycommand/mycommand
```

### 3. Implement the Command

Follow the template structure and include:
- Clear header documentation
- Input validation
- Error handling
- Helpful error messages
- Exit codes (0 for success, non-zero for errors)

### 4. Document the Command

- Write clear usage instructions
- Provide multiple examples
- Document all options and arguments
- Include troubleshooting section
- Add to main `commands/README.md`

### 5. Test the Command

```bash
# Manual testing
./cursor/commands/mycommand

# Through symlink
~/.cursor/commands/mycommand

# In Cursor IDE
/mycommand
```

### 6. Update Repository Documentation

Update `cursor/commands/README.md` to include:
- Command name and brief description
- Link to full documentation (command/README.md)
- Quick usage example

### 7. Create Symlink for Local Testing

```bash
# Link the command directory
ln -s "$(pwd)/cursor/commands/mycommand/mycommand" ~/.cursor/commands/mycommand
```

## Best Practices

### Code Quality

1. **Use strict mode**: Always include `set -euo pipefail` in bash scripts
2. **Validate inputs**: Check all arguments and options
3. **Handle errors gracefully**: Provide helpful error messages
4. **Use colors for output**: Make success/error messages visually distinct
5. **Be idempotent**: Running the command multiple times should be safe

### Documentation Quality

1. **Write for your future self**: Assume you'll forget how it works
2. **Include examples**: Show don't just tell
3. **Document edge cases**: Explain unusual behavior or limitations
4. **Keep it updated**: Documentation should match implementation
5. **Link to related docs**: Reference other commands or external resources

### User Experience

1. **Provide sensible defaults**: Don't require arguments when reasonable defaults exist
2. **Show progress**: For long-running operations, show what's happening
3. **Confirm destructive actions**: Ask before deleting or overwriting
4. **Support `--help`**: Always provide a help option
5. **Exit codes matter**: Use standard exit codes (0 = success, 1 = error, 2 = usage error)

### Integration

1. **Follow repository conventions**: Match existing code style
2. **Use existing utilities**: Leverage other commands when appropriate
3. **Respect git hooks**: Don't bypass pre-commit or other hooks
4. **Version control friendly**: Ensure commands work with git
5. **CI/CD compatible**: Commands should work in automated environments

## Testing

### Manual Testing Checklist

- [ ] Command runs without errors
- [ ] Help text displays correctly (`--help`)
- [ ] All options work as documented
- [ ] Error messages are clear and helpful
- [ ] Edge cases are handled gracefully
- [ ] Command is idempotent (safe to run multiple times)

### Automated Testing

For complex commands, create test scripts:

```bash
#!/usr/bin/env bash
# tests/test_mycommand.sh

set -euo pipefail

# Test 1: Basic functionality
echo "Test 1: Basic functionality"
if ./cursor/commands/mycommand arg1; then
    echo "✅ Pass"
else
    echo "❌ Fail"
    exit 1
fi

# Test 2: Error handling
echo "Test 2: Error handling"
if ! ./cursor/commands/mycommand --invalid-option 2>/dev/null; then
    echo "✅ Pass"
else
    echo "❌ Fail"
    exit 1
fi

echo "All tests passed!"
```

## Examples from This Repository

### All Commands Use Directory Structure

All commands in this repository now follow the self-contained directory structure:

- **`gadd/`** - Git staging with intelligent file grouping
- **`gship/`** - Semantic commit and PR creation workflow
- **`gpr/`** - GitHub pull request creation and updates
- **`create-command/`** - Meta-command for scaffolding new commands

Each command demonstrates the standard structure with:
- Executable in `command-name/command-name`
- Documentation in `command-name/README.md`
- Optional `lib/`, `tests/`, `examples/` subdirectories

## Migration Guide: File to Directory

To migrate existing single-file commands to directory structure:

```bash
# 1. Create directory
mkdir cursor/commands/mycommand

# 2. Move executable
mv cursor/commands/mycommand cursor/commands/mycommand/mycommand

# 3. Move or create README
if [ -f cursor/commands/mycommand.md ]; then
    mv cursor/commands/mycommand.md cursor/commands/mycommand/README.md
else
    echo "# MyCommand Documentation" > cursor/commands/mycommand/README.md
fi

# 4. Update symlinks if needed
rm ~/.cursor/commands/mycommand 2>/dev/null || true
ln -s "$(pwd)/cursor/commands/mycommand/mycommand" ~/.cursor/commands/mycommand

# 5. Create additional structure as needed
mkdir -p cursor/commands/mycommand/{lib,tests,examples}

# 6. Extract helper functions to lib/ if applicable
# 7. Create tests in tests/
# 8. Add examples to examples/
```

## Resources

### Internal Documentation (Always Available)

These resources are maintained in this repository and are always accessible:

- [cursor/commands/README.md](commands/README.md) - Overview of available commands
- [cursor/skills/README.md](skills/README.md) - Overview of available skills
- [CONTRIBUTING.md](../CONTRIBUTING.md) - Contribution guidelines
- [INSTALL.md](../INSTALL.md) - Installation instructions
- [AGENTS.md](../AGENTS.md) - Automation agents and workflows

### External Documentation (May Be Blocked)

These external resources provide additional context but may be blocked by firewall rules in CI/automated environments:

- [Cursor Commands Documentation](https://cursor.com/docs/context/commands) - Official Cursor IDE command documentation
- [Cursor Agent Best Practices](https://cursor.com/blog/agent-best-practices) - Best practices guide
- [Example Repository: hamzafer/cursor-commands](https://github.com/hamzafer/cursor-commands) - Community examples

**Note**: If you're working in an automated environment (CI, GitHub Actions, AI agents) and need access to cursor.com resources, they are cached during setup steps at `/tmp/cursor-docs/`. See [../.github/CURSOR_DOCS_CACHE.md](../.github/CURSOR_DOCS_CACHE.md) for details.

## Meta Commands

This repository provides meta commands to help develop new commands:

- `/create-command` - Scaffold a new command with proper structure
- Skill: `command-development` - AI context for developing commands following these guidelines

## Questions?

For more help:
- Use `/create-command` to scaffold new commands automatically
- See [README.md](../README.md) for repository overview
- Review [command-development skill](skills/command-development.md) for AI context
- Open an issue if you need assistance
