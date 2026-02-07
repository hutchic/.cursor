---
name: open-pr
description: "Create or update a pull request with a terse semantic title and appropriate description. Use when creating a PR, opening a pull request, updating PR description, or when a PR already exists and the description should be checked and updated."
---

# Open PR Skill

Create a new PR with a terse semantic title and body matching the project template, or—if a PR already exists for the branch—check and update the PR description (and title if needed).

## When to Use

- Use when creating a new pull request after pushing a branch
- Use when a PR already exists and the description (or title) may be outdated

## Prerequisites

- **GitHub access**: GitHub MCP configured and enabled, or GitHub CLI (`gh`) installed and authenticated (`gh auth status`).
- **Pushed branch**: Branch must be pushed before creating or updating the PR.

## PR Title

Same convention as commit messages: `<type>(<scope>): <description>`. Semantic, terse (under 50 chars), imperative. See [CONTRIBUTING.md](CONTRIBUTING.md) and [AGENTS.md](AGENTS.md).

## PR Body

Align with [.github/pull_request_template.md](.github/pull_request_template.md): Description, Type of Change, Changes Made, Testing, Checklist, Related Issues. Fill from the branch's commits and diff.

## Create Flow (No PR Yet)

1. Check for existing PR (MCP: e.g. list/read PRs by head branch; or `gh pr view` / `gh pr list --head <branch>`). If a PR exists, use Update flow instead.
2. Compose terse semantic title and body from commits/diff.
3. Create PR: use GitHub MCP create-pull-request when MCP is available; otherwise `gh pr create --title "..." --body "..."` (or `--body-file`).

## Update Flow (PR Exists)

1. Get current PR (MCP: pull request read; or `gh pr view` for title and body).
2. Compare with what the body/title should be given current commits/diff.
3. If outdated: use GitHub MCP update-pull-request when MCP is available; otherwise `gh pr edit --body "..."` and optionally `--title "..."`.

Only update when description or title is inaccurate or incomplete.

## Tooling

- **Prefer GitHub MCP** when it is configured, enabled, and has access: use MCP tools to create or update PRs (e.g. create pull request, update pull request, pull request read). This keeps the flow in the agent and avoids depending on a local `gh` auth.
- **Otherwise use GitHub CLI (`gh`)**: installed and authenticated (`gh auth status`). If `gh` is not available, instruct the user to install and authenticate.

## Related Artifacts

- [Terse Semantic Commits Skill](.cursor/skills/git/terse-semantic-commits/SKILL.md)
- [.github/pull_request_template.md](.github/pull_request_template.md)
- [CONTRIBUTING.md](CONTRIBUTING.md)
- [Shipit Command](.cursor/commands/shipit.md)
