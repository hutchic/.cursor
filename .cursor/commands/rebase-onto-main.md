# Rebase onto Main

## Overview

Fetch `origin/main`, rebase the current branch onto it, resolve any conflicts using the rebase-conflict-resolution skill, then push. Use when bringing a feature or bug branch up to date with main or when the user asks to "rebase onto main," "fix conflicts," or similar.

## When to Use

- Use when the user asks to rebase onto main (or origin/main), fix conflicts, and push
- Use when a branch is behind main and should be updated before merging or continuing work
- Use when push is rejected because the remote has new commits and a rebase is preferred over a merge

## Steps

1. **Ensure feature branch**: Use the [ensure-feature-branch](.cursor/skills/git/ensure-feature-branch/SKILL.md) skill. Do not rebase mainline or release branches; rebase only feature/bug branches.

2. **Fetch**: Run `git fetch origin main` (or `git fetch origin` if the default branch is main).

3. **Rebase**: Run `git rebase origin/main`. If there are no conflicts, skip to step 5.

4. **Resolve conflicts**: For each conflict:
   - Use the [rebase-conflict-resolution](.cursor/skills/git/rebase-conflict-resolution/SKILL.md) skill to resolve (accept main's deletions, choose HEAD vs incoming, remove conflict markers, avoid duplicates).
   - Stage resolved files: `git add <paths>` (or `git add .` for all resolved).
   - Continue: `git rebase --continue`.
   - Repeat until the rebase completes (no more conflicts).

5. **Push**: Run `git push origin <branch>`. If push is rejected because the branch history was rewritten (rebase changed commits), use:
   - `git push origin <branch> --force-with-lease`
   Do not use `--force` without `--lease`; do not use `--no-verify` to skip hooks.

## Notes

- If the rebase fails or is interrupted, use `git rebase --abort` to return to the pre-rebase state, or fix conflicts and continue as above.
- Commit retry: If you run `git commit` during conflict resolution and the pre-commit hook times out, retry with an extended timeout; never use `--no-verify`. See [Commit Retry on Hook Timeout rule](.cursor/rules/meta/commit-retry-on-hook-timeout.mdc).

## Checklist

- [ ] On a feature/bug branch (ensure-feature-branch used if needed)
- [ ] Fetched origin/main
- [ ] Rebase started and conflicts resolved using rebase-conflict-resolution skill
- [ ] All resolved files staged and `git rebase --continue` run until complete
- [ ] Pushed with `git push` or `--force-with-lease` if history was rewritten

## Related Artifacts

- [Rebase Conflict Resolution Skill](.cursor/skills/git/rebase-conflict-resolution/SKILL.md)
- [Ensure Feature Branch Skill](.cursor/skills/git/ensure-feature-branch/SKILL.md)
- [Commit Retry on Hook Timeout Rule](.cursor/rules/meta/commit-retry-on-hook-timeout.mdc)
- [Shipit Command](.cursor/commands/shipit.md) – Push step may reference rebase when remote has new commits
