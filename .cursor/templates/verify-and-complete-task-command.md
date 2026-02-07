# Verify and Complete Task

## Overview

Single path to mark a task done: run the project's verification (e.g. `verify-all-tests.sh` or the plan's verification step), then only on success mark the task done. Use this command so the agent never marks work complete without having run and reported verification.

## When to Use

- When the user or agent needs to mark a task (e.g. Task Master task, plan subtask) as done.
- Whenever the workflow says "mark task N done" or "set status done".
- Do **not** call `task-master set-status ... done` (or equivalent) directly without running this flow first.

## Steps

1. **Run verification** — Execute the project's verification script (e.g. `bash scripts/verify-all-tests.sh`) or the plan's stated verification step for this task. If the command is invoked with a task id (e.g. `/verify-and-complete-task 5`), use the plan's verification step for that task if defined.
2. **Check exit code** — If verification exits non-zero, report the failure (logs, summary) and do **not** mark the task done. Stop.
3. **On success** — If exit code is 0, run the "mark done" action (e.g. `task-master set-status --id=<id> --status=done`) and document evidence (e.g. "Verified: verify-all-tests.sh exit 0 at a timestamp").
4. **Require task id** — When the project uses task ids, require the user/agent to pass the task id (e.g. `/verify-and-complete-task 5`).

## Checklist

- [ ] Verification script or plan step was run (not just described).
- [ ] Exit code was checked; if non-zero, task was not marked done.
- [ ] On success, evidence was documented and "mark done" was executed.
- [ ] AGENTS.md / rules state: use this command to mark done; do not call mark-done without verification.

## Parameters

Anything after the command name is the task id or context:

```
/verify-and-complete-task 5
```

## Related Artifacts

- [Verify-before-done rule](.cursor/rules/meta/verify-before-done.mdc)
- [Verify-before-done enforcement](docs/research/verify-before-done-enforcement.md)
- [Cursor hooks](docs/research/cursor-hooks.md) — for verify-on-stop-prompt hook (done hook) to enforce at agent completion

## Notes

- Copy this file into the project's `.cursor/commands/` (e.g. `.cursor/commands/verify-and-complete-task.md`) and adapt paths (e.g. `scripts/verify-all-tests.sh`) to the project.
- For a done hook that prompts the agent to run verification when the loop ends, add the [verify-on-stop-prompt-hook](verify-on-stop-prompt-hook/README.md) from `.cursor/templates/verify-on-stop-prompt-hook/`.
