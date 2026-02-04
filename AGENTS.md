# Automation Agents

This document describes the automated agents and workflows configured in this repository.

## GitHub Actions Workflows

### Pre-commit Checks

**Workflow:** `.github/workflows/pre-commit.yml`

Runs on every pull request to ensure code quality and consistency.

#### Jobs:
- **Validate PR titles**: Ensures PR titles follow semantic versioning conventions using `amannn/action-semantic-pull-request`
- **pre-commit**: Runs all configured pre-commit hooks to lint and format code

### Dependabot Auto-merge

**Workflow:** `.github/workflows/automerge.yml`

Automatically approves and merges Dependabot PRs.

#### Trigger:
- Runs on `pull_request_target` events
- Only executes when the actor is `dependabot[bot]`

#### Actions:
1. Fetches Dependabot metadata
2. Automatically approves the PR
3. Enables auto-merge with squash strategy

### Pull Request Labeler

**Workflow:** `.github/workflows/labeller.yml`

Automatically adds labels to pull requests based on modified files and PR metadata.

#### Jobs:
- Uses `actions/labeler` to add labels based on file patterns (configured in `.github/labeler.yml`)
- Uses `TimonVS/pr-labeler-action` to add labels based on PR branch names (configured in `.github/pr-labeler.yml`)

### Auto-update PRs

**Workflow:** `.github/workflows/autoupdate.yml`

Automatically updates pull request branches when the main branch is updated.

#### Trigger:
- Runs when code is pushed to `main` branch

#### Actions:
- Updates all open PRs to be in sync with the latest main branch
- Only updates PRs that have passed required checks
- Sorts by creation date (newest first)

### Pre-commit Hook Updates

**Workflow:** `.github/workflows/pre-commit-update.yml`

Keeps pre-commit hooks up to date.

#### Trigger:
- Manual trigger via `workflow_dispatch`
- Weekly schedule (Mondays at 7:00 AM)

#### Actions:
1. Runs `pre-commit autoupdate`
2. Creates a PR with updated hook versions
3. Labels the PR as `dependencies`

## Dependabot

**Configuration:** `.github/dependabot.yml`

Automated dependency updates for multiple package ecosystems.

### Monitored Ecosystems:
- **Python** (pip): Daily updates for Python dependencies
- **Docker**: Daily updates for Docker images
- **GitHub Actions**: Daily updates for action versions
- **npm** (frontend): Daily updates for Node.js dependencies (major versions ignored)
- **Git Submodules**: Daily updates for submodules

### Update Strategy:
- Groups patch updates together for cleaner PRs
- Runs daily for all ecosystems
- Frontend npm dependencies ignore major version updates

## Bot Integrations

### Pull[bot]

**Configuration:** `.github/pull.yml`

Keeps repository in sync with upstream template repository.

### Settings Bot

**Configuration:** `.github/settings.yml`

Syncs repository settings via [Probot Settings](https://probot.github.io/apps/settings/).

#### Key Settings:
- Auto-delete branches on merge
- Squash merge enabled (merge commits disabled)
- Branch protection on `main`:
  - Requires PRs to be up-to-date with main
  - Requires `pre-commit` and `sync` checks to pass
  - Enforces linear history

## Required Secrets

The following secrets must be configured in GitHub repository settings:

- `AUTO_MERGE_TOKEN`: Personal access token for auto-merge functionality
- `GH_TOKEN`: GitHub token for general GitHub API access
- `GITHUB_TOKEN`: Automatically provided by GitHub Actions

## Branch Protection

The `main` branch has the following protections:
- Pull requests required before merging
- Status checks required:
  - `pre-commit`
  - `sync`
- Branches must be up-to-date before merging
- Linear history enforced (no merge commits)
- Auto-delete branches after merge

## Setup Instructions

Refer to [README.md](README.md) for repository-specific setup steps.

For installation of Cursor automation scaffolding, see [INSTALL.md](INSTALL.md).
