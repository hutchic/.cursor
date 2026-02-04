# Cursor Commands & Skills Installation

This guide helps you install Cursor automation commands and skills **globally** so they're available in all your projects.

## Quick Start

### Automated Installation (Recommended)

Run the interactive setup script:

```bash
# Clone this repository first
git clone https://github.com/hutchic/.cursor.git
cd .cursor

# Run interactive setup
bash scripts/setup.sh
```

The script will:
- Check for required dependencies
- Offer to install missing tools
- Create `~/.cursor/` directories
- Symlink commands and skills
- Verify the installation

### Manual Installation

If you prefer manual setup:

```bash
# 1. Clone the repository
git clone https://github.com/hutchic/.cursor.git
cd .cursor

# 2. Create global Cursor directories
mkdir -p ~/.cursor/commands ~/.cursor/skills

# 3. Symlink commands and skills
ln -sf "$(pwd)/cursor/commands"/* ~/.cursor/commands/
ln -sf "$(pwd)/cursor/skills"/* ~/.cursor/skills/

# 4. Verify installation
bash scripts/test_cursor_config.sh
```

## Prerequisites

### Required

| Tool | Purpose | Check | Install |
|------|---------|-------|---------|
| **Cursor IDE** | The IDE these commands are for | Open Cursor | [cursor.sh](https://cursor.sh/) |
| **Git** (2.0+) | Version control | `git --version` | [git-scm.com](https://git-scm.com/downloads) |
| **Bash** (4.0+) | Shell environment | `bash --version` | Included on Linux/macOS |

### Recommended for Full Functionality

| Tool | Purpose | Check | Install |
|------|---------|-------|---------|
| **GitHub CLI** | Required for `/gpr` command | `gh --version` | [See below](#installing-github-cli) |
| **Python 3.7+** | For pre-commit hooks (development) | `python3 --version` | [python.org](https://python.org/downloads/) |

## Installation Methods

Choose the method that works best for you.

### Method 1: Automated Setup Script (Recommended)

The setup script provides an interactive, guided installation:

```bash
bash scripts/setup.sh
```

**Features:**
- ✅ Checks for all dependencies
- ✅ Offers to install missing tools
- ✅ Creates necessary directories
- ✅ Sets up symlinks correctly
- ✅ Verifies installation
- ✅ Provides troubleshooting tips

**Non-Interactive Mode (for CI/CD):**

```bash
# Skip all prompts, assume yes to everything
bash scripts/setup.sh --non-interactive

# Install dependencies automatically
bash scripts/setup.sh --install-deps

# Both options
bash scripts/setup.sh --non-interactive --install-deps
```

### Method 2: Using Makefile

If you prefer make:

```bash
# Install commands and skills globally
make install

# Verify installation
make verify

# Uninstall (removes symlinks)
make uninstall

# Show all available targets
make help
```

### Method 3: Manual Installation

For complete control over the process:

#### Step 1: Clone the Repository

```bash
git clone https://github.com/hutchic/.cursor.git
cd .cursor
```

#### Step 2: Create Cursor Directories

```bash
mkdir -p ~/.cursor/commands
mkdir -p ~/.cursor/skills
```

#### Step 3: Symlink Commands

```bash
# Link all commands at once
ln -sf "$(pwd)"/cursor/commands/* ~/.cursor/commands/

# Or link individual commands
ln -sf "$(pwd)/cursor/commands/gadd" ~/.cursor/commands/gadd
ln -sf "$(pwd)/cursor/commands/gship" ~/.cursor/commands/gship
ln -sf "$(pwd)/cursor/commands/gpr.md" ~/.cursor/commands/gpr.md
```

#### Step 4: Symlink Skills

```bash
# Link all skills at once
ln -sf "$(pwd)"/cursor/skills/* ~/.cursor/skills/

# Or link individual skills (when you add them)
# ln -sf "$(pwd)/cursor/skills/my-skill" ~/.cursor/skills/my-skill
```

#### Step 5: Verify Installation

```bash
# Check symlinks are created
ls -la ~/.cursor/commands/
ls -la ~/.cursor/skills/

# Run verification script
bash scripts/test_cursor_config.sh
```

### Method 4: Project-Local Only (No Global Install)

If you only want commands in this specific project:

1. **Just clone and open in Cursor** - that's it!
2. The `.cursor/` directory is already configured with symlinks
3. Commands will be available when this repository is open in Cursor

**No installation needed** for project-local usage.

## Installing Dependencies

### Installing GitHub CLI

GitHub CLI is required for the `/gpr` command to create pull requests.

#### macOS

```bash
brew install gh
gh auth login
```

#### Ubuntu/Debian

```bash
# Add GitHub CLI repository
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null

# Install
sudo apt update
sudo apt install gh

# Authenticate
gh auth login
```

#### Fedora/RHEL/CentOS

```bash
sudo dnf install gh
gh auth login
```

#### Windows

**Option 1: winget**
```powershell
winget install GitHub.cli
```

**Option 2: scoop**
```powershell
scoop install gh
```

**Option 3: Chocolatey**
```powershell
choco install gh
```

After installation:
```powershell
gh auth login
```

### Installing Python & pre-commit (Optional)

Only needed if you plan to contribute to this repository:

```bash
# Install Python (if not already installed)
# macOS
brew install python3

# Ubuntu/Debian
sudo apt install python3 python3-pip

# Install pre-commit
pip3 install pre-commit

# In this repository, install hooks
pre-commit install
```

## Verification

### Verify Installation

After installation, verify everything is set up correctly:

```bash
# Run the verification script
bash scripts/test_cursor_config.sh

# Or use make
make verify
```

The verification script checks:
- ✅ `~/.cursor/commands/` directory exists
- ✅ `~/.cursor/skills/` directory exists
- ✅ Symlinks are valid and point to correct files
- ✅ Commands are accessible
- ✅ File permissions are correct

### Test Commands in Cursor IDE

1. **Open Cursor IDE**
2. **Open any project**
3. **Type `/` in the chat or command input**
4. **You should see your installed commands** like:
   - `/gadd` - Smart git staging
   - `/gship` - Branch + commit + PR workflow
   - `/gpr` - Create or update pull request

### Manual Verification

```bash
# Check directory structure
ls -la ~/.cursor/

# Should show:
# commands/ -> (or symlinks inside)
# skills/   -> (or symlinks inside)

# Check commands are accessible
ls -la ~/.cursor/commands/

# Should show:
# gadd -> /path/to/.cursor/cursor/commands/gadd
# gship -> /path/to/.cursor/cursor/commands/gship
# gpr.md -> /path/to/.cursor/cursor/commands/gpr.md

# Test GitHub CLI is working
gh --version
gh auth status
```

## Available Commands

After installation, these commands are available in Cursor IDE:

### `/gadd` - Smart Git Staging

Intelligently stage files by logical groupings (docs, source, tests, etc.)

**Usage:**
```
/gadd              # Guided mode with prompts
/gadd all          # Stage everything
/gadd group=docs   # Stage only documentation
```

### `/gship` - Complete Git Workflow

Branch creation + semantic commit + PR in one command.

**Usage:**
```
/gship                                  # Auto-generate everything
/gship "feat(api): add search"          # With message
/gship "fix: resolve bug" --no-pr       # Skip PR creation
```

### `/gpr` - Create/Update Pull Request

Push current branch and create or update a GitHub pull request.

**Usage:**
```
/gpr "feat(api): add search endpoint"
/gpr "fix: resolve issue" --ready       # Not a draft
```

See [cursor/commands/](cursor/commands/) for detailed documentation on each command.

## Updating

To get the latest commands and improvements:

```bash
# Navigate to your clone
cd /path/to/.cursor

# Pull latest changes
git pull origin main

# Symlinks automatically point to updated files
# No need to reinstall!

# Optional: Verify everything still works
bash scripts/test_cursor_config.sh
```

## Uninstallation

To remove the global installation:

```bash
# Using make
make uninstall

# Or manually
rm ~/.cursor/commands/*
rm ~/.cursor/skills/*

# Optionally remove directories
rmdir ~/.cursor/commands
rmdir ~/.cursor/skills
rmdir ~/.cursor
```

**Note:** This only removes symlinks. The original repository remains untouched.

## Platform-Specific Notes

### Linux and macOS

✅ **Works out-of-the-box**
- Symlinks are natively supported
- Git preserves symlinks by default
- No special configuration needed

### Windows

⚠️ **Requires Developer Mode or Administrator privileges**

Symlinks on Windows need special handling. Choose one of these options:

**Option 1: Enable Developer Mode (Recommended)**
1. Open Settings → Update & Security → For Developers
2. Enable "Developer Mode"
3. Clone/re-clone the repository (symlinks will work automatically)

**Option 2: Clone with Administrator Privileges**
```powershell
# In an elevated PowerShell/Command Prompt
git clone -c core.symlinks=true https://github.com/hutchic/.cursor.git
```

**Option 3: Use Git Bash or WSL**
```bash
# Git Bash or WSL support symlinks natively
git clone https://github.com/hutchic/.cursor.git
```

**Option 4: Manual Symlink Creation**
If symlinks don't work after cloning:
```powershell
# In PowerShell with admin privileges
cd ~/.cursor
mkdir commands, skills

# Create symlinks
cmd /c mklink /D commands C:\path\to\.cursor\cursor\commands
cmd /c mklink /D skills C:\path\to\.cursor\cursor\skills
```

## Troubleshooting

### Commands Not Showing in Cursor IDE

**Symptom:** Commands don't appear when you type `/` in Cursor.

**Solutions:**

1. **Restart Cursor IDE** - Configuration is loaded at startup
2. **Check directory structure:**
   ```bash
   ls -la ~/.cursor/commands/
   # Should show symlinks or command files
   ```
3. **Verify commands are markdown or executable:**
   ```bash
   file ~/.cursor/commands/gpr.md
   file ~/.cursor/commands/gadd
   ```
4. **Check Cursor IDE version** - Ensure you're using a recent version
5. **Try project-local** - Open this repository directly in Cursor as a fallback

### Symlinks Not Working

**Symptom:** `ls -la ~/.cursor/commands/` shows broken symlinks or no files.

**Solutions:**

1. **Check source files exist:**
   ```bash
   ls -la /path/to/.cursor/cursor/commands/
   ```
2. **Use absolute paths:**
   ```bash
   ln -sf /absolute/path/to/.cursor/cursor/commands/* ~/.cursor/commands/
   ```
3. **On Windows:** Enable Developer Mode or use admin privileges (see above)
4. **Verify git preserved symlinks:**
   ```bash
   cd /path/to/.cursor
   git ls-files -s .cursor/commands
   # Should show mode 120000 for symlinks
   ```

### GitHub CLI Not Working

**Symptom:** `/gpr` command fails with "neither gh nor MCP available".

**Solutions:**

1. **Install GitHub CLI:**
   - macOS: `brew install gh`
   - Ubuntu: See [Installing GitHub CLI](#installing-github-cli)
   - Windows: `winget install GitHub.cli`

2. **Authenticate:**
   ```bash
   gh auth login
   ```

3. **Verify authentication:**
   ```bash
   gh auth status
   ```

4. **Check GitHub token has required scopes:**
   - `repo` - Full control of private repositories
   - `workflow` - Update GitHub Action workflows

### Permission Denied Errors

**Symptom:** "Permission denied" when running commands.

**Solutions:**

1. **Make commands executable:**
   ```bash
   chmod +x cursor/commands/*
   chmod +x ~/.cursor/commands/*
   ```

2. **Check file ownership:**
   ```bash
   ls -la ~/.cursor/commands/
   # Files should be owned by your user
   ```

3. **Fix ownership if needed:**
   ```bash
   chown -R $USER:$USER ~/.cursor/
   ```

### Commands Work Locally But Not Globally

**Symptom:** Commands work in this repository but not in other projects.

**Solutions:**

1. **Verify global installation:**
   ```bash
   ls -la ~/.cursor/commands/
   # Should show symlinks or command files
   ```

2. **Check Cursor's configuration priority:**
   - Project `.cursor/` takes precedence over `~/.cursor/`
   - If both exist, project config is used

3. **Re-run global installation:**
   ```bash
   bash scripts/setup.sh
   # Or
   make install
   ```

### Getting Help

If you're still experiencing issues:

1. **Run diagnostics:**
   ```bash
   bash scripts/test_cursor_config.sh
   ```

2. **Check documentation:**
   - [README.md](README.md) - Overview and troubleshooting FAQ
   - [cursor/commands/](cursor/commands/) - Command-specific docs
   - [CONTRIBUTING.md](CONTRIBUTING.md) - Contribution guidelines

3. **Open an issue:**
   - Visit: [https://github.com/hutchic/.cursor/issues](https://github.com/hutchic/.cursor/issues)
   - Include:
     - Your OS and version
     - Cursor IDE version
     - Output of `bash scripts/test_cursor_config.sh`
     - Steps to reproduce the problem

## Advanced Configuration

### Custom Command Locations

You can organize commands differently if needed:

```bash
# Keep this repo separate from Cursor config
mkdir -p ~/my-cursor-commands

# Symlink to custom location
ln -sf ~/my-cursor-commands ~/.cursor/commands
```

### Multiple Command Repositories

Merge commands from multiple sources:

```bash
# Install commands from multiple repos
ln -sf /path/to/repo1/cursor/commands/* ~/.cursor/commands/
ln -sf /path/to/repo2/cursor/commands/* ~/.cursor/commands/
```

**Note:** Command names must be unique across repositories.

### Environment-Specific Commands

Use different commands for different environments:

```bash
# Development
ln -sf ~/cursor-dev/commands ~/.cursor/commands

# Production
ln -sf ~/cursor-prod/commands ~/.cursor/commands
```

## Next Steps

After installation:

1. **Test the commands** in Cursor IDE - Open any project and type `/`
2. **Read command documentation** - See [cursor/commands/](cursor/commands/)
3. **Customize if needed** - Edit commands in `cursor/commands/` to fit your workflow
4. **Share with team** - Point teammates to this installation guide
5. **Stay updated** - Run `git pull` periodically for improvements

## Related Documentation

- [README.md](README.md) - Quick start and overview
- [CONTRIBUTING.md](CONTRIBUTING.md) - How to contribute
- [AGENTS.md](AGENTS.md) - Automation agents and CI/CD
- [cursor/commands/gpr.md](cursor/commands/gpr.md) - Pull request command details
