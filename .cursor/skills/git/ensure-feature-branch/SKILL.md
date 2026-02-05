---
name: ensure-feature-branch
description: "Ensure we're on a feature or bug branch before committing. If current branch is mainline (main, master, dev) or a release branch (release/*), create and checkout a new branch. Use when about to run shipit or commit/push so work is never committed directly to mainline or release."
---

# Ensure Feature Branch Skill

Before staging and committing, ensure the current branch is a feature or bug branch. If it is a mainline or release branch, create and checkout a new branch so commits are not made on mainline/release.

## When to Use

- Use at the start of shipit (before stage/commit) when the workflow should not commit to mainline or release
- Use when the user asks to commit/push and you should avoid pushing directly to main or dev

## Mainline and Release Branches

Treat these as **not** feature/bug branches; create a new branch if current branch is one of:

- **Mainline**: `main`, `master`, `dev`
- **Release**: Any branch matching `release/*` (e.g. `release/1.0`, `release/2.x`)

Repos may use different default branch names (e.g. `trunk`, `development`). If the repo clearly uses another name as the primary integration branch, treat it as mainline.

## Steps

1. Get current branch: `git branch --show-current`
2. If it is a mainline or release branch (as above), create a new branch and checkout:
   - **Branch name**: Infer from the changes (files/diff) a short kebab-case description. Use `feat/<description>` for features or `fix/<description>` for fixes. If the change type is unclear, use `feat/<description>` or a neutral `chore/<description>`.
   - Run: `git checkout -b <branch-name>`
3. If already on a feature/bug branch (e.g. `feat/...`, `fix/...`, or any branch not mainline/release), do nothing and proceed.

## Notes

- Run this **before** staging and committing so the first commit lands on the new branch.
- Do not create a branch if already on a non-mainline, non-release branch (e.g. existing `feat/xyz` or an updatecli branch).

## Related Artifacts

- [Shipit Command](.cursor/commands/shipit.md)
- [Stage Related Files Skill](.cursor/skills/git/stage-related-files/SKILL.md)
- [Terse Semantic Commits Skill](.cursor/skills/git/terse-semantic-commits/SKILL.md)
