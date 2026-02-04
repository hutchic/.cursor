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

## Troubleshooting

### Symlinks not working?

**Verify symlinks exist:**
```bash
ls -la .cursor/
```

You should see:
```
commands -> ../cursor/commands
skills -> ../cursor/skills
```

**Test the configuration:**
```bash
bash scripts/test_cursor_config.sh
```

### Windows Issues

If symlinks aren't working on Windows:

1. **Enable Developer Mode** (Windows 10/11):
   - Settings → Update & Security → For Developers → Enable "Developer Mode"
   - Re-clone the repository

2. **Or use Administrator privileges**:
   ```powershell
   git clone -c core.symlinks=true https://github.com/hutchic/.cursor.git
   ```

3. **Fallback: Use global installation**:
   ```bash
   ln -s "$(pwd)/cursor/commands" ~/.cursor/commands
   ```

See [INSTALL.md](../INSTALL.md) for detailed Windows setup instructions.

### Commands not showing in Cursor IDE?

1. **Verify you're in the right directory**: The `.cursor/` configuration only works when this repository is the root directory opened in Cursor
2. **Check Cursor IDE version**: Ensure you're using a recent version that supports project-local `.cursor/` directories
3. **Try global installation**: If project-local doesn't work, use the global installation method in [INSTALL.md](../INSTALL.md)
