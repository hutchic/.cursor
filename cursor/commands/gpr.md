# Create or Update Pull Request

This command creates or updates a GitHub pull request for the current branch.

## Usage

```bash
/gpr "feat(api): add search endpoint"
```

With options:

```bash
/gpr "fix(auth): resolve token expiry" --snippet-mode file --snippet-path src/auth.py
```

## What it does

1. Verifies you're not in a detached HEAD state
2. Pushes the current branch to remote (with upstream if needed)
3. Detects whether to use `gh` CLI or GitHub MCP
4. Checks if a PR already exists for the branch
5. Creates a new PR or updates the existing one
6. Generates a standardized PR body with:
   - Summary
   - List of commits
   - Validation checklist
   - Code snippet (diff stat, file content, or custom)
   - Risk assessment and rollback plan

## Arguments

- **PR_TITLE** (required): The semantic title for your pull request
  - Example: `"feat(api): add search endpoint"`
  - Example: `"fix(auth): resolve token expiry"`
  - Example: `"docs: update installation guide"`

## Options

- `--snippet-mode MODE`: Choose snippet type
  - `auto` (default): Shows diff statistics
  - `file`: Shows content from a specific file
  - `paste`: Uses custom provided content

- `--snippet-path PATH`: File path when using `file` mode
  - Example: `--snippet-path src/components/Search.tsx`

- `--snippet-content CONTENT`: Custom content when using `paste` mode
  - Example: `--snippet-content "See detailed commit messages"`

## Requirements

You must have either:

- GitHub CLI (`gh`) installed and authenticated, OR
- GitHub MCP server configured

### Installing GitHub CLI

```bash
# macOS
brew install gh

# Linux
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update
sudo apt install gh

# Authenticate
gh auth login
```

## Examples

### Basic usage

Create or update PR with default settings:

```bash
/gpr "feat(search): implement full-text search"
```

### With file snippet

Show a specific file in the PR body:

```bash
/gpr "feat(api): add user endpoint" --snippet-mode file --snippet-path src/api/users.py
```

### With custom content

Add custom snippet content:

```bash
/gpr "chore: update dependencies" --snippet-mode paste --snippet-content "Updated all dependencies to latest versions. See package.json for details."
```

## Error Handling

The command will fail with helpful guidance if:

- You're in a detached HEAD state → Use `/gship` to create a branch
- Push fails → Check network and permissions
- Neither `gh` nor MCP available → Install and configure one
- PR creation/update fails → Check GitHub permissions

## Notes

- The command is idempotent: running it multiple times on the same branch will update the existing PR
- No duplicate PRs will be created
- PR body follows a consistent template for easier reviews
- The base branch defaults to `main`
