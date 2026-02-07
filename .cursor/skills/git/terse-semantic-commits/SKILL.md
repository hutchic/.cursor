---
name: terse-semantic-commits
description: "Write semantic commit messages in Conventional Commits format. Use when committing, writing commit messages, or when a terse semantic commit is required. Covers format, types, scope, imperative mood, and length."
---

# Terse Semantic Commits Skill

Produce commit messages that follow [Conventional Commits](https://www.conventionalcommits.org/): terse, semantic, imperative. See [CONTRIBUTING.md](CONTRIBUTING.md) and [AGENTS.md](AGENTS.md) for project standards.

## When to Use

- Use when committing changes and a commit message is needed
- Use when a terse semantic commit is required (e.g. commit workflows, PR creation)

## Format

```
<type>(<scope>): <description>
```

- **type**: Required. One of: feat, fix, docs, style, refactor, perf, test, chore, ci, build, revert
- **scope**: Optional but recommended. Area affected (lowercase)
- **description**: Required. Imperative mood, lowercase, no trailing period, terse (under ~50 chars)

## Rules

1. Imperative mood: "add" not "added" or "adds"
2. Lowercase description, no trailing period
3. Derive type/scope from changed files and edits (e.g. `auth/` → scope `auth`)
4. One commit message per staged group when used with stage-related-files
5. Use only `git commit -m "..."` for the message; do not use `--trailer`

## Examples

- Good: `feat(api): add user search endpoint`, `fix(auth): resolve token expiry bug`
- Bad: `Added new feature`, `Update files`, `Fixed the bug`

## Related Artifacts

- [Stage Related Files Skill](.cursor/skills/git/stage-related-files/SKILL.md)
- [CONTRIBUTING.md](CONTRIBUTING.md), [AGENTS.md](AGENTS.md)
- [Shipit Command](.cursor/commands/shipit.md)
