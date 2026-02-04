# Command Development Skill

This skill provides context and guidelines for developing Cursor IDE commands following repository best practices.

## Core Principles

When developing commands for this repository:

1. **Clarity over Cleverness**: Write code that is easy to understand and maintain
2. **Documentation is Essential**: Every command must have clear documentation
3. **User Experience Matters**: Commands should be intuitive and helpful
4. **Safety First**: Validate inputs, handle errors, never lose user data
5. **Consistent with Repository Standards**: Follow existing patterns and conventions
6. **Directory Structure Always**: All commands use self-contained directory structure

## Directory Structure Standard

**All commands MUST use self-contained directory structure:**

```
cursor/commands/
└── command-name/
    ├── README.md             # Required: Full documentation
    ├── command-name          # Required: Main executable
    ├── lib/                  # Optional: Helper modules
    ├── tests/                # Optional: Test suite
    └── examples/             # Optional: Usage examples
```

### Minimum Required
- `command-name` - The executable script
- `README.md` - Complete documentation

### Recommended for Production
- Add `lib/` for helper functions and shared utilities
- Add `tests/` for automated testing
- Add `examples/` for usage demonstrations

### Why Directory Structure?

1. **Consistency**: All commands follow the same pattern
2. **Scalability**: Room to grow as command complexity increases
3. **Organization**: Related files grouped together
4. **Maintainability**: Clear separation of concerns
5. **Testability**: Dedicated space for tests
6. **Documentation**: Examples and docs with the code

## Required Elements for All Commands

### 1. Header Documentation (Bash Scripts)
```bash
#!/usr/bin/env bash
# -*- coding: utf-8 -*-
# vim: ft=bash

#
# /command-name - Brief one-line description
#
# Longer description explaining purpose and behavior
#
# USAGE:
#   command-name [options] [arguments]
#
# OPTIONS/EXAMPLES/NOTES sections as appropriate
#
```

### 2. Error Handling
```bash
set -euo pipefail  # Exit on error, undefined vars, pipe failures

# Validate inputs
if [ $# -lt 1 ]; then
    echo "Error: Missing required argument" >&2
    echo "Usage: $0 <arg>" >&2
    exit 1
fi

# Check prerequisites
if ! command -v git &> /dev/null; then
    echo "Error: git is required but not installed" >&2
    exit 1
fi
```

### 3. User Feedback
```bash
# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_success() { echo -e "${GREEN}$1${NC}"; }
print_error() { echo -e "${RED}Error: $1${NC}" >&2; }
print_info() { echo -e "${BLUE}$1${NC}"; }
print_warning() { echo -e "${YELLOW}$1${NC}"; }
```

### 4. Documentation File
Every command needs either:
- Inline documentation in script header (for simple commands)
- Separate `command.md` file (for medium complexity)
- `command/README.md` file (for directory structure)

Include:
- Overview and purpose
- Usage with examples
- All options and arguments
- Requirements/dependencies
- Troubleshooting section

## Integration Patterns

### Delegating to Other Commands
```bash
# Find and call another command
find_gadd() {
    local gadd_path=""
    local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

    # Check same directory
    if [ -x "$script_dir/gadd" ]; then
        gadd_path="$script_dir/gadd"
    # Check ~/.cursor/commands
    elif [ -x "$HOME/.cursor/commands/gadd" ]; then
        gadd_path="$HOME/.cursor/commands/gadd"
    # Check PATH
    elif command -v gadd &> /dev/null; then
        gadd_path="gadd"
    fi

    echo "$gadd_path"
}

# Use the found command
if ! "$gadd_cmd" all; then
    print_error "gadd failed"
    exit 1
fi
```

### Git Integration
```bash
# Always check if in git repo
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    print_error "Not in a git repository"
    exit 1
fi

# Use git porcelain for parsing
git status --porcelain

# Disable pager for automation
git --no-pager log
git --no-pager diff
```

### GitHub Integration
```bash
# Prefer GitHub CLI when available
if command -v gh &> /dev/null; then
    gh pr create --title "$title" --body "$body"
else
    print_error "GitHub CLI (gh) is required"
    exit 1
fi
```

## Testing Requirements

### Manual Testing
Before committing:
- [ ] Run command with valid inputs
- [ ] Run command with invalid inputs (test error handling)
- [ ] Test all documented options
- [ ] Verify error messages are helpful
- [ ] Test in both project and global contexts

### Automated Testing (for complex commands)
```bash
#!/usr/bin/env bash
# tests/test_command.sh

set -euo pipefail

test_count=0
pass_count=0

run_test() {
    local name="$1"
    local command="$2"

    test_count=$((test_count + 1))
    echo "Test $test_count: $name"

    if eval "$command"; then
        echo "✅ Pass"
        pass_count=$((pass_count + 1))
    else
        echo "❌ Fail"
    fi
}

run_test "Basic execution" "./cursor/commands/mycommand test"
run_test "Help option" "./cursor/commands/mycommand --help"

echo ""
echo "Passed $pass_count/$test_count tests"
[ $pass_count -eq $test_count ]
```

## Common Patterns

### Argument Parsing
```bash
# Simple positional args
SEMANTIC_MESSAGE="${1:-}"
MODE="${2:-single}"

# Options with getopts
while getopts "h:v-:" opt; do
    case "$opt" in
        h) show_help; exit 0 ;;
        v) VERBOSE=true ;;
        -) # Long options
            case "$OPTARG" in
                help) show_help; exit 0 ;;
                verbose) VERBOSE=true ;;
                *) echo "Invalid option: --$OPTARG" >&2; exit 1 ;;
            esac
            ;;
    esac
done
```

### File Classification/Bucketing
```bash
classify_file() {
    local file="$1"
    local basename=$(basename "$file")

    # Check patterns in order of specificity
    if [[ "$basename" =~ ^test_ ]]; then
        echo "tests"
    elif [[ "$file" =~ \.md$ ]]; then
        echo "docs"
    elif [[ "$file" =~ \.(py|js|ts)$ ]]; then
        echo "src"
    else
        echo "misc"
    fi
}
```

### Progress Indication
```bash
# For long operations
echo "Processing files..."
for file in "${files[@]}"; do
    process_file "$file"
    echo -n "."
done
echo " done!"

# For multi-step operations
print_info "Step 1/3: Staging files..."
stage_files
print_success "✓ Files staged"

print_info "Step 2/3: Creating commit..."
create_commit
print_success "✓ Commit created"

print_info "Step 3/3: Pushing changes..."
push_changes
print_success "✓ Changes pushed"
```

## Repository-Specific Conventions

### Semantic Commit Messages
Commands that create commits should enforce semantic format:
```bash
validate_semantic_message() {
    local message="$1"
    local valid_types="feat|fix|docs|style|refactor|perf|test|chore|build|ci|revert"

    if [[ "$message" =~ ^($valid_types)(\([^\)]+\))?:[[:space:]]*(.+)$ ]]; then
        return 0
    else
        print_error "Invalid semantic commit format"
        echo "Format: 'type(scope): summary' or 'type: summary'"
        echo "Valid types: feat, fix, docs, style, refactor, perf, test, chore, build, ci, revert"
        exit 1
    fi
}
```

### Protected Branches
Commands should respect protected branches:
```bash
PROTECTED_BRANCHES=("main" "master" "trunk" "develop")

is_protected_branch() {
    local branch="$1"
    for pattern in "${PROTECTED_BRANCHES[@]}"; do
        if [ "$branch" = "$pattern" ]; then
            return 0
        fi
    done
    return 1
}

# Usage
current_branch=$(git branch --show-current)
if is_protected_branch "$current_branch"; then
    print_warning "On protected branch '$current_branch'"
    print_info "Creating feature branch..."
    # Create feature branch logic
fi
```

### Pre-commit Hooks
Never bypass hooks:
```bash
# ✅ Good - respects hooks
git commit -m "message"

# ❌ Bad - bypasses hooks
git commit --no-verify -m "message"
```

## AI-Specific Guidelines

When AI (Cursor Copilot) is developing commands:

1. **Read existing commands first**: Understand patterns used in `gadd`, `gship`
2. **Follow the decision matrix**: Choose file vs directory based on complexity
3. **Complete documentation**: Don't skip docs - they're as important as code
4. **Test before committing**: Verify command works as documented
5. **Match repository style**: Use same colors, messages, patterns as existing commands
6. **Update main README**: Add new command to `cursor/commands/README.md`

## Examples from Repository

### Good Example: `create-command`
- Self-contained directory structure
- Clear single purpose (scaffold new commands)
- Comprehensive README.md documentation
- Follows all repository conventions
- Generates other commands with same structure

### Legacy Commands

Existing commands (`gadd`, `gship`, `gpr`) currently use individual files. These represent legacy structure and should be migrated to directories. **All new commands must use directory structure.**

## Anti-Patterns to Avoid

❌ **Individual files**: Use directory structure, not standalone files
❌ **No documentation**: Every command needs README.md in its directory
❌ **Silent failures**: Always provide error messages
❌ **Bypassing safety**: No `--no-verify`, no force push
❌ **Poor error handling**: Check prerequisites and validate inputs
❌ **Inconsistent style**: Match existing command patterns
❌ **Cryptic variable names**: Use descriptive names
❌ **No help option**: Support `--help` or `-h`
❌ **Mixed structure**: Don't mix files and directories - directories only

## Checklist for New Commands

Before submitting a new command:

- [ ] Command uses directory structure (not standalone file)
- [ ] Directory contains at minimum: executable + README.md
- [ ] Command has clear, descriptive name (kebab-case)
- [ ] Executable has proper shebang and permissions
- [ ] Header documentation is complete
- [ ] README.md is comprehensive with examples
- [ ] Error handling is comprehensive
- [ ] User feedback uses colors appropriately
- [ ] Command tested manually with various inputs
- [ ] Added to `cursor/commands/README.md`
- [ ] Follows repository conventions
- [ ] Git hooks are respected
- [ ] Integration with other commands tested (if applicable)
- [ ] Consider adding lib/ for helpers if command is >100 lines
- [ ] Consider adding tests/ for automated testing
- [ ] Consider adding examples/ for usage demonstrations

## Getting Help

- Review [COMMAND_DEVELOPMENT_GUIDE.md](../COMMAND_DEVELOPMENT_GUIDE.md) for comprehensive guidelines
- Study existing commands: `gadd`, `gship`
- Check [CONTRIBUTING.md](../../CONTRIBUTING.md) for repository conventions
- Ask in issues or PRs if unsure about structure decisions
