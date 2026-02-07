# Revive DX implementation guidance

Purpose: actionable guidance for revive (and similar projects) so that work is not marked done without verification, and design follows a one-slice-first gate. This doc summarizes the audit, what went wrong, and points to deliverable assets in this repo.

## Audit summary

### Revive

- **Pre-commit:** Locally, integration + E2E + verify-all-tests run; in CI those hooks skip (exit 0), so PR merge does not require them in CI.
- **Rules:** 20 rules including task-completion-verification, test-verification-enforcement, baseline-verification, planning-and-scope, commit-workflow. No Cursor hooks; no `.cursor/commands/`.
- **Plans:** Task prompts say "run verification before marking done"; they were not followed.

### Why it failed

1. **No single path to "mark task done"** — Agent could call Task Master "set status done" without ever running verification.
2. **Pre-commit does not run at "done"** — Done was declared before commit, so pre-commit never ran for that decision.
3. **No MVP/slice gate** — Full factory/registry sequence was executed; no "one verified slice before next phase" checkpoint.

## Order of implementation

1. **Single path to mark done** — Add a command (e.g. verify-and-complete-task) and/or script that runs verification then marks done. Use the [verify-and-complete-task command template](../../.cursor/templates/verify-and-complete-task-command.md) in this repo; copy into revive's `.cursor/commands/` and adapt. Update AGENTS.md and rules: "To mark a task done, use verify-and-complete-task; do not call task-master set-status ... done without verification."
2. **Verify-before-done rule** — Install or mirror the [verify-before-done](../../.cursor/rules/meta/verify-before-done.mdc) rule (this repo's install script can install it, or copy manually).
3. **MVP/slice gate** — Add to plan template: "First milestone = one demonstrable slice; before adding abstraction, confirm previous phase has one verified slice." Reference [MVP-first](../../.cursor/rules/meta/mvp-first.mdc) and [YAGNI](../../.cursor/rules/meta/yagni.mdc) (install script or copy).
4. **Pre-commit/CI** — Document the tradeoff (local vs CI); optionally add a CI job that runs integration/E2E so merge requires them.
5. **Cursor hook (receipt check)** — Add [receipt-check hook](../../.cursor/templates/receipt-check-hook/): `beforeShellExecution` for `task-master set-status.*done`; script checks for recent verification receipt, exits 2 if missing. Add receipt write to `verify-all-tests.sh` on success. See template README.

## Deliverable assets in this repo

| Asset | Location | Use |
|-------|----------|-----|
| Verify-and-complete-task command | [.cursor/templates/verify-and-complete-task-command.md](../../.cursor/templates/verify-and-complete-task-command.md) | Copy to project `.cursor/commands/`, adapt paths |
| Verify-on-stop-prompt hook | [.cursor/templates/verify-on-stop-prompt-hook/](../../.cursor/templates/verify-on-stop-prompt-hook/) | Copy `stop` entry from hooks.json.snippet into project `.cursor/hooks.json` |
| verify-before-done, mvp-first, yagni rules | `.cursor/rules/meta/` | Install via `./scripts/install-self-improvement.sh` (with prompts) or copy |
| INSTALL.md | [INSTALL.md](../../INSTALL.md) | Canonical DX model, symlink for commands/skills, install flow |

## Related

- [DX mechanisms report](dx-mechanisms-report.md)
- [Verify-before-done enforcement](verify-before-done-enforcement.md)
- [Cursor hooks](cursor-hooks.md)
