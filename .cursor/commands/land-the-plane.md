# Land the Plane

## Overview

Run the full wrap-up and ship workflow: if taskmaster or beads are in use, sync tasks (file new tasks for remaining work, update or close existing tasks); ensure all quality gates pass; run deslop; then run shipit. This command orchestrates the [land-the-plane skill](.cursor/skills/meta/land-the-plane/SKILL.md).

## When to Use

- Use when you want to finish a branch and ship: sync task systems, pass checks, remove AI slop, then stage, commit, push, and open or update a PR
- Use after feature or fix work is done and you want one workflow to close tasks, clean up, and ship

## Steps

1. **Use the land-the-plane skill**: Follow the [land-the-plane skill](.cursor/skills/meta/land-the-plane/SKILL.md). In order:
   - If taskmaster is in use: file new tasks for remaining issues; update tasks (close finished work, update status).
   - Ensure all quality gates pass (lint, tests, build, pre-commit as applicable).
   - If beads is in use: file new tasks for remaining issues; update beads issues (close finished work, update status).
   - Run deslop (see [deslop command](.cursor/commands/deslop.md)).
   - Run shipit (see [shipit command](.cursor/commands/shipit.md)).

2. **Report**: After shipit completes, briefly confirm: tasks updated (if applicable), quality passed, deslop done, PR created or updated.

## Checklist

- [ ] Land-the-plane skill followed in order
- [ ] Taskmaster (if in use): tasks filed/updated/closed
- [ ] Quality gates passed
- [ ] Beads (if in use): issues filed/updated/closed
- [ ] Deslop run and summary reported
- [ ] Shipit run; PR created or updated

## Related Artifacts

- [Land the Plane Skill](.cursor/skills/meta/land-the-plane/SKILL.md)
- [Deslop Command](.cursor/commands/deslop.md)
- [Shipit Command](.cursor/commands/shipit.md)
