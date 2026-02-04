# Cursor Automation Installation

This document provides installation instructions for setting up the Cursor automation scaffolding.

## Directory Tree

```
.
├── cursor/
│   ├── commands/          # Cursor commands
│   │   └── README.md
│   └── skills/            # Cursor skills
│       └── README.md
├── templates/             # Template files
│   └── README.md
├── scripts/               # Utility scripts
│   └── .gitkeep
├── INSTALL.md
└── README.md
```

## Installation Instructions

### 1. Symlink Commands Directory

Link the commands directory to your Cursor configuration:

```bash
ln -s "$(pwd)/cursor/commands" ~/.cursor/commands
```

### 2. Symlink Skills Directory

Link the skills directory to your Cursor configuration:

```bash
ln -s "$(pwd)/cursor/skills" ~/.cursor/skills
```

### 3. Symlink Repository Root (Optional)

If you need to reference the entire repository from `~/.cursor/`:

```bash
ln -s "$(pwd)" ~/.cursor/repo
```

Or for specific subdirectories:

```bash
ln -s "$(pwd)/templates" ~/.cursor/templates
ln -s "$(pwd)/scripts" ~/.cursor/scripts
```

## Verification

After installation, verify the symlinks:

```bash
ls -la ~/.cursor/commands
ls -la ~/.cursor/skills
```

Both should point to the directories in this repository.

## Uninstallation

To remove the symlinks:

```bash
rm ~/.cursor/commands
rm ~/.cursor/skills
# Remove any additional symlinks you created
```

## Notes

- This scaffolding contains no implementations, only structure and placeholders.
- Add your actual command and skill files to the appropriate directories.
- The `scripts/` directory is reserved for utility scripts (currently empty).
- The `templates/` directory can be used for shared templates.
