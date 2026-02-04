# .cursor Directory

This directory enables **self-configuration** for this repository when opened in Cursor IDE.

## Purpose

When you open this repository in Cursor IDE, it automatically recognizes the `.cursor` directory in the project root, making commands and skills immediately available without manual installation.

## Structure

```
.cursor/
├── commands -> ../cursor/commands  # Symlink to actual commands
└── skills -> ../cursor/skills      # Symlink to actual skills
```

## How It Works

1. **Cursor IDE checks project root**: When opening a project, Cursor looks for a `.cursor/` directory
2. **Symlinks provide access**: The symlinks point to the actual files in `cursor/`
3. **Commands are available**: All commands in `cursor/commands/` become available via `/command-name`

## Benefits

- ✅ **Zero setup**: Works immediately after cloning
- ✅ **Dogfooding**: Use the repository's own commands on itself
- ✅ **Template-ready**: When used as a template, new projects get instant access
- ✅ **Preserves structure**: The `cursor/` directory remains the source of truth

## Implementation

The symlinks are created with:

```bash
ln -s ../cursor/commands .cursor/commands
ln -s ../cursor/skills .cursor/skills
```

These symlinks are committed to the repository so they work out-of-the-box.

## Alternatives

If you want to use these commands **globally** across all projects (not just this one):

```bash
ln -s "$(pwd)/cursor/commands" ~/.cursor/commands
ln -s "$(pwd)/cursor/skills" ~/.cursor/skills
```

See [INSTALL.md](../INSTALL.md) for more details.
