# Cursor Automation

This repository contains Cursor IDE automation commands and utilities.

## Quick Start

### Option 1: Self-Configuring (Recommended)

This repository is **self-configuring** when opened in Cursor IDE:

1. Clone or open this repository in Cursor
2. The `.cursor/` directory in the project root provides immediate access to commands
3. Use commands by typing `/` followed by the command name

**No manual installation required!**

### Option 2: Global Installation

To use these commands across all projects:

```bash
ln -s "$(pwd)/cursor/commands" ~/.cursor/commands
ln -s "$(pwd)/cursor/skills" ~/.cursor/skills
```

See [INSTALL.md](INSTALL.md) for detailed installation instructions.

## Available Commands

### `/gpr` - Create or Update Pull Request

Creates or updates a GitHub pull request for the current branch.

**Usage:**

```
/gpr "feat(api): add search endpoint"
```

**Features:**

- Automatically pushes the current branch
- No duplicate PRs (updates existing PR if found)
- Standardized PR body format
- Works with GitHub CLI or GitHub MCP

[See full documentation](cursor/commands/gpr.md)

## Repository Setup

- detect-secrets scan > .secrets.baseline
- set github setting
  - allow auto-merge
  - automatically delete head branches
- set github branch protection rules:
  - require a pull request before merging
  - require status checks to pass
    - pre-commit
    - valid pr titles
    - sync
- set github secrets for actions and dependabot
  - AUTO_MERGE_TOKEN
  - GH_TOKEN

## Directory Structure

- `.cursor/` - Self-configuring symlinks (automatically used by Cursor IDE)
  - `commands/` → `../cursor/commands/`
  - `skills/` → `../cursor/skills/`
- `cursor/commands/` - Cursor IDE commands (source files)
- `cursor/skills/` - Cursor IDE skills (source files)
- `scripts/` - Utility scripts
- `templates/` - Template files

## Installation

See [INSTALL.md](INSTALL.md) for detailed installation instructions.

## Troubleshooting & FAQ

### General Issues

#### Q: Commands not showing up in Cursor IDE?

**A:** Check the following:

1. **Verify repository location**: Is this repository opened as the root folder in Cursor IDE?
2. **Check symlinks**: Run `ls -la .cursor/` to verify symlinks exist and point to `../cursor/commands` and `../cursor/skills`
3. **Test configuration**: Run `bash scripts/test_cursor_config.sh` to verify setup
4. **Cursor IDE version**: Ensure you're using a recent version of Cursor IDE that supports project-local `.cursor/` directories
5. **Try global installation**: If project-local doesn't work, follow the global installation steps in [INSTALL.md](INSTALL.md)

#### Q: How do I verify the installation is working?

**A:** Run the verification script:

```bash
bash scripts/test_cursor_config.sh
```

This will check:
- `.cursor/` directory exists
- Symlinks are valid
- Commands are accessible
- Configuration is committed to git

#### Q: Can I use these commands in other projects?

**A:** Yes! Use the global installation method:

```bash
ln -s "$(pwd)/cursor/commands" ~/.cursor/commands
ln -s "$(pwd)/cursor/skills" ~/.cursor/skills
```

After global installation, commands will be available in all projects opened in Cursor IDE.

### Platform-Specific Issues

#### Q: Symlinks not working on Windows?

**A:** Windows requires special handling for symlinks:

**Option 1: Enable Developer Mode (Recommended)**
1. Open Settings → Update & Security → For Developers
2. Enable "Developer Mode"
3. Re-clone the repository

**Option 2: Use Administrator Privileges**
```powershell
git clone -c core.symlinks=true https://github.com/hutchic/.cursor.git
```

**Option 3: Manual Symlink Creation**
```powershell
# From PowerShell with admin privileges
cd .cursor
cmd /c mklink /D commands ..\cursor\commands
cmd /c mklink /D skills ..\cursor\skills
```

**Option 4: Use Global Installation**
If symlinks continue to fail, use the global installation method instead.

See [INSTALL.md](INSTALL.md#windows) for detailed Windows instructions.

#### Q: Getting "permission denied" errors on Linux/macOS?

**A:** Check file permissions:

```bash
# Make scripts executable
chmod +x scripts/*.sh
chmod +x cursor/commands/*

# Verify permissions
ls -la scripts/
ls -la cursor/commands/
```

### Dependency Issues

#### Q: What dependencies are required?

**A:** Core dependencies:

- **Git**: For version control operations
- **Bash**: Shell environment (4.0+ recommended)
- **GitHub CLI (gh)** OR **GitHub MCP**: For GitHub operations

Optional dependencies:

- **pre-commit**: For code quality hooks (`pip install pre-commit`)
- **Python 3.x**: For pre-commit hooks
- **Docker**: If using containerized workflows

#### Q: How do I install GitHub CLI?

**A:** Installation varies by platform:

**macOS:**
```bash
brew install gh
gh auth login
```

**Ubuntu/Debian:**
```bash
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update
sudo apt install gh
gh auth login
```

**Windows:**
```powershell
winget install GitHub.cli
gh auth login
```

See [cursor/commands/gpr.md](cursor/commands/gpr.md#requirements) for more details.

#### Q: How do I set up pre-commit hooks?

**A:** Install and configure pre-commit:

```bash
# Install pre-commit
pip install pre-commit

# Install git hooks
pre-commit install

# Run on all files (optional, to test)
pre-commit run --all-files
```

See [.github/PRE_COMMIT_SETUP.md](.github/PRE_COMMIT_SETUP.md) for detailed setup instructions.

### Command-Specific Issues

#### Q: `/gpr` command fails with "neither gh nor MCP available"?

**A:** You need to install and authenticate with GitHub CLI:

```bash
# Install gh (see above for platform-specific instructions)
# Then authenticate
gh auth login
```

Alternatively, configure GitHub MCP if you prefer that over GitHub CLI.

#### Q: `/gpr` fails to push to remote?

**A:** Check the following:

1. **Remote is configured**: `git remote -v` should show your GitHub repository
2. **Authentication works**: `gh auth status` should show you're logged in
3. **Branch has commits**: Ensure you've made commits on your branch
4. **Network connectivity**: Check your internet connection

#### Q: Pull request titles are failing validation?

**A:** PR titles must follow [Conventional Commits](https://www.conventionalcommits.org/) format:

**Format:** `<type>(<scope>): <description>`

**Examples:**
- ✅ `feat(api): add search endpoint`
- ✅ `fix(auth): resolve token expiry`
- ✅ `docs: update installation guide`
- ❌ `Added new feature` (not semantic)
- ❌ `Update files` (too vague)

See [CONTRIBUTING.md](CONTRIBUTING.md#pull-request-titles) for complete guidelines.

### Configuration Issues

#### Q: How do I configure this for CI/CD?

**A:** Use the non-interactive setup mode:

```bash
# Run setup script non-interactively
bash scripts/setup.sh --non-interactive --install-deps

# Or use make
make install
```

See the "Automated Setup" section in [INSTALL.md](INSTALL.md) for details.

#### Q: Can I customize the commands?

**A:** Yes! Commands are just bash scripts in `cursor/commands/`:

1. Edit existing commands in `cursor/commands/`
2. Add new commands as executable files
3. Document them in the command's `.md` file
4. Test with the verification scripts

#### Q: Where are configuration files stored?

**A:** Configuration locations:

- **Project-specific**: `.cursor/` in repository root (symlinks to `cursor/`)
- **Global**: `~/.cursor/` in your home directory
- **Git config**: `.git/config` for repository settings
- **GitHub CLI**: `~/.config/gh/` for gh authentication

### Getting Help

#### Q: Where can I find more documentation?

**A:** Documentation is organized as follows:

- **[README.md](README.md)** - Quick start and overview
- **[INSTALL.md](INSTALL.md)** - Detailed installation instructions
- **[CONTRIBUTING.md](CONTRIBUTING.md)** - Contribution guidelines and PR title format
- **[AGENTS.md](AGENTS.md)** - Automation agents and workflows
- **[cursor/commands/](cursor/commands/)** - Individual command documentation
- **[.github/copilot-instructions.md](.github/copilot-instructions.md)** - Project standards and guidelines

#### Q: I found a bug or have a feature request?

**A:** Please [open an issue](https://github.com/hutchic/.cursor/issues/new) with:

- Clear description of the problem or feature
- Steps to reproduce (for bugs)
- Your environment (OS, Cursor IDE version, etc.)
- Expected vs actual behavior

#### Q: How do I contribute?

**A:** Contributions are welcome!

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request with a [semantic title](CONTRIBUTING.md#pull-request-titles)

See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed guidelines.

### Advanced Topics

#### Q: Can I use this as a template for my own projects?

**A:** Yes! This repository is designed to be used as a template:

1. Click "Use this template" on GitHub
2. Clone your new repository
3. The `.cursor/` directory will automatically work
4. Customize commands in `cursor/commands/` to your needs

#### Q: How do I add new commands?

**A:**

1. Create a new executable file in `cursor/commands/`:
   ```bash
   touch cursor/commands/mycommand
   chmod +x cursor/commands/mycommand
   ```

2. Add a shebang and implementation:
   ```bash
   #!/usr/bin/env bash
   # Your command implementation
   ```

3. Document it with a `.md` file:
   ```bash
   # cursor/commands/mycommand.md
   # Your command documentation
   ```

4. Test the command works through the symlink:
   ```bash
   bash .cursor/commands/mycommand
   ```

#### Q: What's the difference between commands and skills?

**A:**

- **Commands**: Executable scripts that perform actions (e.g., `/gpr` to create PRs)
- **Skills**: Reusable knowledge or patterns that Cursor AI can reference
- Both are accessed through the `.cursor/` directory
- Commands are in `cursor/commands/`, skills are in `cursor/skills/`
