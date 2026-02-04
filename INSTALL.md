# Cursor Automation Installation

This document provides comprehensive installation instructions for using the Cursor automation commands and skills.

## Prerequisites

Before installing, ensure you have the following:

### Required

- **Git** (2.0+): Version control system
  - Check: `git --version`
  - Install: See [git-scm.com](https://git-scm.com/downloads)

- **Bash** (4.0+): Shell environment
  - Check: `bash --version`
  - Included by default on Linux/macOS
  - Windows: Use Git Bash, WSL, or MinGW

- **Cursor IDE**: The IDE this automation is designed for
  - Download: [cursor.sh](https://cursor.sh/)

### Recommended

- **GitHub CLI (gh)**: Required for `/gpr` command
  - Check: `gh --version`
  - Install: See [CLI installation guide](#installing-github-cli)
  - Alternative: Configure GitHub MCP

- **Python 3.7+**: Required for pre-commit hooks
  - Check: `python3 --version`
  - Install: See [python.org](https://www.python.org/downloads/)

- **pre-commit**: Code quality automation
  - Check: `pre-commit --version`
  - Install: `pip install pre-commit`

### Optional

- **Docker**: For containerized workflows
  - Check: `docker --version`
  - Install: [docker.com](https://www.docker.com/get-started)

- **Node.js**: If using npm-based tools
  - Check: `node --version`
  - Install: [nodejs.org](https://nodejs.org/)

## Installation Methods

Choose the installation method that best fits your use case.

## Self-Configuring Repository (Recommended)

**This repository is self-configuring!** When you open this repository in Cursor IDE:

1. The `.cursor/` directory at the project root is automatically recognized by Cursor
2. Commands and skills are immediately available via symlinks:
   - `.cursor/commands/` → `cursor/commands/`
   - `.cursor/skills/` → `cursor/skills/`
3. No manual installation steps required

### How It Works

Cursor IDE checks for a `.cursor` directory in your project root. This repository includes pre-configured symlinks that point to the actual command and skill files in the `cursor/` directory.

### Benefits

- **Zero configuration**: Works immediately after cloning
- **Dogfooding**: Test and use the commands on the repository itself
- **Template ready**: When using this as a template, users get instant access to commands

## Global Installation (Optional)

If you want to use these commands across **all projects** (not just this repository):

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

### Verify Self-Configuration

Open this repository in Cursor IDE and verify commands are available:

1. Press `/` in Cursor to see available commands
2. Look for `/gadd`, `/gship`, and other commands from this repository

### Verify Global Installation

After global installation, verify the symlinks:

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

- **Self-configuration is automatic**: The `.cursor/` directory with symlinks enables immediate use
- **Two installation modes**:
  - **Local (automatic)**: Works when this repo is open in Cursor - no setup needed
  - **Global (manual)**: Requires symlinking to `~/.cursor/` - works across all projects
- The `cursor/` directory contains the actual command and skill files
- The `.cursor/` directory contains symlinks for auto-discovery
- The `scripts/` directory is reserved for utility scripts
- The `templates/` directory can be used for shared templates

## Edge Cases and Limitations

### Cursor IDE Configuration Loading

Cursor IDE loads configurations from these locations in order:
1. **Project root** (`.cursor/` directory) - Project-specific configurations
2. **User home** (`~/.cursor/` directory) - Global user configurations

### Self-Configuration Behavior

- **When it works**: Opening this repository directly in Cursor IDE
- **When it may not work**:
  - If Cursor doesn't support project-local `.cursor/` directories (IDE-dependent)
  - If symlinks are not preserved when cloning (Windows without developer mode)
  - If the repository is accessed as a subdirectory of another project

### Cross-Platform Compatibility

#### Linux and macOS
✅ **Works out-of-the-box**
- Symlinks are natively supported
- Git preserves symlinks by default

#### Windows
⚠️ **Requires Developer Mode or Administrator privileges**

**Option 1: Enable Developer Mode (Recommended)**
1. Go to Settings → Update & Security → For Developers
2. Enable "Developer Mode"
3. Clone the repository (symlinks will work automatically)

**Option 2: Use Administrator privileges**
```powershell
# Clone with admin privileges
git clone -c core.symlinks=true https://github.com/hutchic/.cursor.git
```

**Option 3: Manual symlink creation (if cloning fails to preserve symlinks)**
```powershell
# From PowerShell with admin privileges
cd .cursor
cmd /c mklink /D commands ..\cursor\commands
cmd /c mklink /D skills ..\cursor\skills
```

**Option 4: Use global installation instead**
If symlinks don't work on your Windows setup, use the global installation method:
```bash
ln -s "$(pwd)/cursor/commands" ~/.cursor/commands
ln -s "$(pwd)/cursor/skills" ~/.cursor/skills
```

**Verify Windows symlinks work:**
```powershell
# Run the test script
bash scripts/test_cursor_config.sh
```

### Recommended Approach

1. **For this repository**: Use the built-in `.cursor/` self-configuration (automatic)
2. **For using these commands elsewhere**: Use global installation to `~/.cursor/`
3. **For templates derived from this repository**: Keep the `.cursor/` symlinks for self-configuration
4. **For Windows users without symlink support**: Use global installation as fallback
