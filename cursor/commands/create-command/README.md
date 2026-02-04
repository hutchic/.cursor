# create-command - Scaffold a New Cursor Command

Creates a new Cursor IDE command with self-contained directory structure and proper documentation following repository best practices.

## Overview

The `create-command` tool automates the creation of new Cursor commands, ensuring they follow the repository's directory-based organization standard. It generates all necessary files and subdirectories, making it easy to start developing a new command with proper structure.

## Usage

```bash
create-command <name> [--description="..."]
```

### Arguments

- `name`: The command name (kebab-case, e.g., 'my-command')

### Options

- `--description DESC`: Brief description of the command
- `--help, -h`: Show this help message

## Examples

### Create a new command with description

```bash
create-command my-command --description="Does something useful"
```

### Create without description (will use default)

```bash
create-command another-command
```

## Output

Creates self-contained command directory in `cursor/commands/` with:
- `commandname/commandname` - Executable script with template code
- `commandname/README.md` - Full documentation template
- `commandname/lib/` - Directory for helper modules
- `commandname/tests/` - Directory for test suite
- `commandname/examples/` - Directory for usage examples
- Updates `commands/README.md` with new command entry

## Directory Structure Created

```
cursor/commands/
└── my-command/
    ├── README.md          # Full documentation
    ├── my-command         # Executable script
    ├── lib/               # Helper modules
    ├── tests/             # Test suite
    └── examples/          # Usage examples
```

## Features

- Generates self-contained command directory
- Creates executable with proper template and best practices
- Generates comprehensive README.md with sections for usage, features, examples
- Creates lib/, tests/, examples/ subdirectories
- Updates commands README automatically
- Validates command naming conventions (kebab-case)
- Sets proper file permissions

## Requirements

- Bash 4.0+
- Git (for the repository)

## Installation

This command is automatically available after installing cursor commands:

```bash
ln -s "$(pwd)/cursor/commands/create-command/create-command" ~/.cursor/commands/create-command
```

## Next Steps After Creating a Command

1. Edit the command implementation in `cursor/commands/COMMAND/COMMAND`
2. Update the documentation in `cursor/commands/COMMAND/README.md`
3. Test the command: `COMMAND --help`
4. Add to git: `git add cursor/commands/COMMAND`
5. Add helper functions in `lib/` as needed
6. Write tests in `tests/`
7. Add examples in `examples/`

## Notes

- Command names must use kebab-case (hyphens, lowercase)
- All commands use directory structure (not standalone files)
- Minimum structure: executable + README.md
- Recommended: also add lib/, tests/, examples/ as the command grows in complexity
- The tool follows the guidelines in COMMAND_DEVELOPMENT_GUIDE.md

## Error Handling

### Invalid Command Name

```
Error: Invalid command name: MyCommand
Command names must:
  - Start with a lowercase letter
  - Contain only lowercase letters, numbers, and hyphens
  - Use kebab-case (e.g., 'my-command')
```

### Command Already Exists

```
Error: Command 'my-command' already exists
```

### Reserved Names

Some names are reserved and cannot be used:
- `help`
- `test`
- `commands`
- `skills`

## See Also

- [COMMAND_DEVELOPMENT_GUIDE.md](../../COMMAND_DEVELOPMENT_GUIDE.md) - Comprehensive guide
- [command-development skill](../../skills/command-development.md) - AI context for development
