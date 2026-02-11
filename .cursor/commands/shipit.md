# Shipit

## Overview

Run the full flow: ensure we're on a feature/bug branch (create one if on mainline or release), stage related changes, run pre-commit, commit with a terse semantic message, push, then create a PR (or update the PR description if one already exists). This command orchestrates the ensure-feature-branch, stage-related-files, terse-semantic-commits, and open-pr skills.

## When to Use

- Use when you want to ship changes: stage, commit, push, and open or update a PR in one workflow
- Use when following the project's commit and PR standards (semantic, terse, pre-commit)

## Steps

1. **Ensure feature branch**: Use the [ensure-feature-branch](.cursor/skills/git/ensure-feature-branch/SKILL.md) skill. If the current branch is mainline (e.g. main, master, dev) or a release branch (e.g. release/*), create and checkout a new feature/bug branch before proceeding. If already on a feature or bug branch, continue.

2. **Stage**: Use the [stage-related-files](.cursor/skills/git/stage-related-files/SKILL.md) skill to group changes and stage them (one or more logical groups; multiple `git add` + commit cycles if the user wants multiple commits, or one group for "shipit in one commit"). **Note**: Research documents (`*research*.md`, `plan*.txt`, `*.plan.md`) are automatically excluded from staging as they are one-off task documents.

3. **Commit**: For each staged group, use the [terse-semantic-commits](.cursor/skills/git/terse-semantic-commits/SKILL.md) skill to produce the commit message. Run `pre-commit run --all-files` (fix any failures), then `git commit -m "..."`. Repeat if multiple groups were chosen.

4. **Push**: Push the current branch: `git push -u origin <branch>` on first push, otherwise `git push`. If push is rejected (e.g. remote has new commits), pull or rebase as needed, then push again.

5. **PR**: Use the [open-pr](.cursor/skills/git/open-pr/SKILL.md) skill: if no PR exists for this branch, create one with a terse semantic title and body from the project template; if a PR already exists, ensure the description (and title if needed) is up to date.

## Parameters

Optional context after the command to guide staging:

- `/shipit` – Default: one or more logical groups as appropriate
- `/shipit single commit` – Prefer one commit for all changes
- `/shipit split by feature` – Prefer multiple commits grouped by feature/fix/docs

## Checklist

- [ ] On a feature/bug branch (ensure-feature-branch used if started on mainline or release)
- [ ] Changes staged using the stage-related-files skill
- [ ] Pre-commit run and passing
- [ ] Commit(s) made with terse semantic message(s)
- [ ] Branch pushed
- [ ] PR created or description updated using the open-pr skill

## Related Artifacts

- [Ensure Feature Branch Skill](.cursor/skills/git/ensure-feature-branch/SKILL.md)
- [Stage Related Files Skill](.cursor/skills/git/stage-related-files/SKILL.md)
- [Terse Semantic Commits Skill](.cursor/skills/git/terse-semantic-commits/SKILL.md)
- [Open PR Skill](.cursor/skills/git/open-pr/SKILL.md)
- [Automation Decomposition Rule](.cursor/rules/meta/automation-decomposition.mdc)
- [CONTRIBUTING.md](CONTRIBUTING.md), [AGENTS.md](AGENTS.md)
- [.github/PRE_COMMIT_SETUP.md](.github/PRE_COMMIT_SETUP.md)
