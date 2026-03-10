---
name: rebase-conflict-resolution
description: "Resolve git rebase conflicts: when to accept main's version vs branch, how to remove conflict markers, and how to avoid duplicate sections. Use when resolving conflicts during git rebase (e.g. rebase onto main) or when continuing a rebase after fixing conflicts."
---

# Rebase Conflict Resolution Skill

Resolve conflicts that appear during `git rebase` (e.g. rebase onto main). Use this skill when the rebase stops with conflicts so you can decide what to keep, edit the files, stage them, and run `git rebase --continue`.

## When to Use

- Use when `git rebase origin/main` (or similar) stops due to conflicts
- Use when the user asks to "fix conflicts" or "resolve rebase conflicts"
- Use as the conflict-resolution step in the [rebase-onto-main](.cursor/commands/rebase-onto-main.md) command

## Conflict Resolution Guidelines

### Deleted vs modified

- If **main (HEAD) deleted** a file that **our branch modified**: accept main’s deletion. Remove the file from the branch’s changes (e.g. `git rm <file>` or delete the file, then stage). The rebase is replaying our commits on top of main; if main no longer has that file, we don’t keep it.
- If **our branch deleted** a file and **main modified** it: usually keep main’s version (the file exists on main). Resolve any conflict in that file and keep the content main has, then stage.

### Choosing HEAD vs incoming

- **HEAD** during rebase is the commit from the branch we rebased onto (e.g. main). **Incoming** is the change from the commit we’re replaying (our branch).
- Prefer **HEAD** when main’s version is the source of truth (e.g. CI workflow structure, docs that were updated on main).
- Prefer **incoming** (our branch) when our change is the one we want to keep (e.g. a new feature, a fix we’re adding). Merge when both sides have valid parts (e.g. keep main’s job structure but add our env vars).

### Editing conflicted files

- Remove all conflict markers: `<<<<<<<`, `=======`, `>>>>>>>`. Keep exactly one version of each conflicted region (or a merged version you build from both sides).
- Avoid **duplicate sections**: e.g. two "Pre-commit" sections in a doc, or two identical steps in a workflow. After resolving, read the file and remove any duplicated blocks.
- **Makefile**: Often only one `.PHONY` line is desired. Merge the two lists into a single `.PHONY` line (e.g. keep HEAD’s line if it already includes the targets we need).
- **YAML (workflows, docker-compose)**: Preserve structure (indentation, key order). Choose the job or service definition that matches the intended behavior; if both sides added different env vars or steps, merge them into one coherent block.

### After editing

- Stage the resolved files: `git add <path>` or `git add .` for all resolved.
- Continue the rebase: `git rebase --continue`. If more conflicts appear, repeat: resolve with this skill, stage, then `git rebase --continue` again until the rebase finishes.

## Steps (summary)

1. Identify conflicted files (`git status`).
2. For each file: open it, decide HEAD vs incoming (or merge), remove conflict markers, remove any duplicate sections you introduced.
3. Stage resolved files.
4. Run `git rebase --continue`. If conflicts appear again, go to step 1.

## Related Artifacts

- [Rebase onto Main Command](.cursor/commands/rebase-onto-main.md)
- [Ensure Feature Branch Skill](.cursor/skills/git/ensure-feature-branch/SKILL.md)
- [Stage Related Files Skill](.cursor/skills/git/stage-related-files/SKILL.md)
- [Commit Retry on Hook Timeout Rule](.cursor/rules/meta/commit-retry-on-hook-timeout.mdc)
