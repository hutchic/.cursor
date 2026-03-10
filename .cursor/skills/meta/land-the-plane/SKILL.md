---
name: land-the-plane
description: "Finish and ship work: sync task systems (taskmaster/beads if in use), ensure quality gates pass, run deslop, then shipit. Use when wrapping up a branch—closing tasks, cleaning AI slop, and opening or updating a PR."
---

# Land the Plane Skill

Run the full wrap-up and ship workflow: update task systems for any remaining work, ensure quality gates pass, remove AI slop (deslop), then stage, commit, push, and open or update a PR (shipit). Use this skill on its own or via the land-the-plane command.

## When to Use

- Use when you want to finish a branch and ship: sync tasks, pass checks, deslop, then shipit
- Use when the user says "land the plane," "wrap up and ship," or similar
- Use as the final step of a feature or fix workflow

## Order of Operations

Execute in this order. Skip taskmaster or beads steps if that system is not in use in the project.

1. **Taskmaster (if in use)**
   - File new tasks for any remaining issues that still need work.
   - Update existing tasks: close finished work, update status for in-progress or blocked items.
   - Detect taskmaster by project config, docs, or task files (e.g. taskmaster config or task list in repo).

2. **Quality gates**
   - Ensure all quality gates pass (e.g. lint, tests, build, pre-commit).
   - Run the same commands CI runs (e.g. `make test`, `pnpm run lint`, `pre-commit run --all-files`).
   - Fix any failures before proceeding; do not skip or bypass gates.

3. **Beads (if in use)**
   - File new tasks for any remaining issues that need work.
   - Update beads issues: close finished work, update status.
   - Detect beads by project config, docs, or issue-tracking usage (e.g. beads config or linked issues).

4. **Deslop**
   - Run the deslop workflow: compare branch to main, remove AI-generated slop (extra comments, unnecessary defensive checks, `any` casts, style inconsistencies), report a 1–3 sentence summary.
   - Use the [deslop command](.cursor/commands/deslop.md) steps or invoke `/deslop` if available.

5. **Shipit**
   - Run the full ship flow: ensure feature branch, stage related files, run pre-commit, commit with terse semantic message(s), push, then create or update the PR.
   - Use the [shipit command](.cursor/commands/shipit.md) steps or the ensure-feature-branch, stage-related-files, terse-semantic-commits, and open-pr skills.

## Detecting Taskmaster and Beads

- **Taskmaster**: Look for config or docs mentioning "taskmaster," task lists, or project-specific task workflow. If unsure, skip taskmaster steps.
- **Beads**: Look for config or docs mentioning "beads," or issue/bead tracking in the project. If unsure, skip beads steps.

## Checklist

- [ ] Taskmaster (if in use): new tasks filed for remaining work; existing tasks updated/closed
- [ ] Quality gates: all pass (lint, tests, build, pre-commit as applicable)
- [ ] Beads (if in use): new tasks filed; issues updated/closed
- [ ] Deslop: run and 1–3 sentence summary reported
- [ ] Shipit: branch pushed and PR created or updated

## Related Artifacts

- [Deslop Command](.cursor/commands/deslop.md)
- [Shipit Command](.cursor/commands/shipit.md)
- [Ensure Feature Branch Skill](.cursor/skills/git/ensure-feature-branch/SKILL.md)
- [Stage Related Files Skill](.cursor/skills/git/stage-related-files/SKILL.md)
- [Terse Semantic Commits Skill](.cursor/skills/git/terse-semantic-commits/SKILL.md)
- [Open PR Skill](.cursor/skills/git/open-pr/SKILL.md)
- [Verify-Before-Done Rule](.cursor/rules/meta/verify-before-done.mdc)
