# Create or Update Pull Request

This command creates or updates a GitHub pull request for the current branch. By default, creates **draft** PRs.

## Usage

```bash
/gpr "feat(api): add search endpoint"
```

With options:

```bash
/gpr "fix(auth): resolve token expiry" --snippet-mode file --snippet-path src/auth.py
/gpr "feat: ready for review" --ready  # Create as ready for review (not draft)
```

## What it does

1. Verifies you're not in a detached HEAD state
2. Pushes the current branch to remote (with upstream if needed)
3. Detects whether to use `gh` CLI or GitHub MCP
4. Checks if a PR already exists for the branch
5. Creates a new **draft** PR (or ready PR with `--ready`) or updates the existing one
6. Uses PR template from `.github/pull_request_template.md` if available
7. Generates a standardized PR body with:
   - Summary
   - List of commits
   - Validation checklist
   - Code snippet (diff stat, file content, or custom)
   - Risk assessment and rollback plan

## Arguments

- **PR_TITLE** (required): The semantic title for your pull request
  - **MUST** follow [Conventional Commits](https://www.conventionalcommits.org/) format: `type(scope): description`
  - **MUST** be terse (under 50 characters when possible)
  - **MUST** use imperative mood ("add" not "added")
  - Example: `"feat(api): add search endpoint"`
  - Example: `"fix(auth): resolve token expiry"`
  - Example: `"docs: update installation guide"`
  - See [CONTRIBUTING.md](../../CONTRIBUTING.md#pull-request-titles) for comprehensive guidelines

**Valid types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `refactor`: Code refactoring
- `perf`: Performance improvements
- `test`: Adding/modifying tests
- `chore`: Maintenance tasks
- `ci`: CI/CD configuration
- `build`: Build system changes
- `style`: Code style/formatting

**✅ Good PR title examples:**
```bash
/gpr "feat(search): implement full-text search"
/gpr "fix(parser): resolve off-by-one error in cursor navigation"
/gpr "docs(api): clarify authentication flow"
/gpr "refactor(utils): simplify date formatting"
/gpr "perf(query): optimize database indexes"
/gpr "test(api): add search endpoint coverage"
/gpr "chore(deps): update lodash to 4.17.21"
/gpr "ci(workflow): add build caching"
```

**❌ Bad PR title examples (DO NOT USE):**
```bash
/gpr "Added new feature"                    # Not semantic, not imperative
/gpr "Update files"                         # Too vague
/gpr "WIP: Working on search"               # Not descriptive of final state
/gpr "Fixed bug"                            # Not specific enough
/gpr "Updated README with installation instructions and troubleshooting"  # Too verbose
/gpr "Changes"                              # Meaningless
```

## Options

- `--snippet-mode MODE`: Choose snippet type
  - `auto` (default): Shows diff statistics
  - `file`: Shows content from a specific file
  - `paste`: Uses custom provided content

- `--snippet-path PATH`: File path when using `file` mode
  - Example: `--snippet-path src/components/Search.tsx`

- `--snippet-content CONTENT`: Custom content when using `paste` mode
  - Example: `--snippet-content "See detailed commit messages"`

- `--ready`: Create PR as ready for review instead of draft (default is draft)

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
