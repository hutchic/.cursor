---
name: terse-semantic-commits
description: "Apply when committing, suggesting a commit message, or running a commit workflow. Use Conventional Commits format (type(scope): description). Keep terse (under 50 chars when possible), imperative mood, no trailing period. Use when the agent is about to run git commit, user asks to 'commit this', or running the commit command."
---

# Terse Semantic Commits

Compose commit messages in **Conventional Commits** form: terse, imperative, semantic.

## Format

```
type(scope): description
```

- **type** (required): `feat` | `fix` | `docs` | `style` | `refactor` | `perf` | `test` | `chore` | `ci` | `build` | `revert`
- **scope** (optional): area affected (e.g. `api`, `docs`, `meta`)
- **description** (required): imperative, no trailing period, lowercase after colon

## Rules

- Terse: prefer under 50 characters.
- Imperative: "add" not "added"; "fix" not "fixed".
- No trailing period. No extra docs in the skill; full guidelines in [CONTRIBUTING.md](CONTRIBUTING.md) and [AGENTS.md](AGENTS.md).

## Examples

**Good:** `refactor: standalone project, two symlinks only` · `feat(api): add user search endpoint` · `chore: add skill-creator, find-skills`

**Bad:** `Added new feature` · `Update files` · long explanatory sentence

## Related Artifacts

- [Commit command](.cursor/commands/meta/commit.md) – workflow: stage → message → pre-commit → commit
- [CONTRIBUTING.md](CONTRIBUTING.md) – full PR/commit guidelines
- [AGENTS.md](AGENTS.md) – PR Instructions
