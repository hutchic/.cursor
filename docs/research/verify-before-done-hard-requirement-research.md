# Verify-before-done: hard technical requirement — research report

**Goal:** Enforce that Cursor cannot declare work "done" unless automated tests have actually run, using a **dedicated file that test harnesses touch** and a gate (hook or single-path command/skill). Avoid infinite loops if we use a "hey did you run the following…?" style response.

**Status:** Research complete. Recommendations at end.

---

## 1. Dedicated receipt file (test harness touches it)

### Concept

A single file (e.g. `.cursor/verification-receipt` or `.cursor/.last-test-run`) that **only the test/verification script** writes when tests pass. The gate (hook or command) checks for this file and its recency; no receipt or stale receipt → block "mark done."

### Why this works

- **Hard technical requirement:** The only way to get a valid receipt is to run the script that runs tests and writes the file on success. The agent cannot create the file by hand without running the harness (we document that the receipt must only be written by the harness).
- **Test harness changes:** Each project’s test entrypoint (e.g. `scripts/verify-all-tests.sh`, `make test`, pytest, jest) must be updated to write the receipt on success. No universal convention exists; it’s a small, project-specific addition.

### Integration options

| Harness / entrypoint | How to write receipt on success |
|----------------------|----------------------------------|
| **Shell script** (e.g. `verify-all-tests.sh`) | At end of script, on exit 0: `mkdir -p .cursor && date +%s > .cursor/verification-receipt` |
| **Makefile** (`make test`) | Add a target that runs tests and on success runs `echo $$(date +%s) > .cursor/verification-receipt` (e.g. from a `verify` target that depends on test) |
| **pytest** | In `conftest.py` or a plugin: hook on session finish (e.g. `pytest_sessionfinish`); if exit status 0, write receipt to a known path |
| **Jest** | Use `--reporters` or a custom reporter that runs on run completion; if no failures, write receipt (e.g. Node script that writes to `.cursor/verification-receipt`) |
| **CI** | Optional: CI job that runs tests can also write the receipt (e.g. in a workspace artifact) if you want CI to satisfy the same gate; usually the gate is for local "mark done" only |

### Receipt format and location

- **Location:** `.cursor/verification-receipt` (or configurable via env in the hook). Keeps Cursor-specific state under `.cursor/`.
- **Content:** A timestamp (e.g. `date +%s`) is enough for "recent" checks. Optional: append checksum of test run or project version for stricter validation.
- **TTL:** Gate script rejects if receipt is older than N seconds (e.g. 1800). Prevents reusing an old run.

---

## 2. Hook that blocks and sends a message ("did you run the following…?")

### Can we show a message without causing an infinite loop?

**Yes.** Cursor’s `beforeShellExecution` hook can **deny** and optionally return an **agent_message**. The agent receives that message and can act on it (e.g. run the verify script and retry). There is **no** automatic re-submit of a new user message from this hook.

- **Deny:** Script exits with code **2**, or script prints JSON to stdout with `"permission": "deny"`.
- **agent_message:** In the JSON response, set `"agent_message": "Run scripts/verify-all-tests.sh. On success it writes a receipt. Then retry marking the task done."` That text is sent to the agent. The agent can then run the script and try "mark done" again.
- **Infinite loop:** The only loop would be the agent **ignoring** the message and repeatedly trying "mark done" without running the script. The hook does **not** inject a follow-up user message (that’s the `stop` hook’s `followup_message`). So there is no technical infinite loop from the hook itself.

### Command-based hook: returning JSON on deny

Cursor docs state that command-based hooks receive JSON on stdin and **return JSON on stdout**. For `beforeShellExecution`, the output can include:

- `permission`: `"allow"` | `"deny"` | `"ask"`
- `agent_message`: message sent to the agent (e.g. guidance when denied)
- `user_message`: message shown in the client

So the receipt-check script can:

1. Check for receipt file and TTL.
2. If missing or stale: print to stdout one line of JSON, e.g.
   `{"permission":"deny","agent_message":"Run scripts/verify-all-tests.sh (or the project verification script). On success it writes a receipt. Then retry marking the task done."}`
   Then exit 2.
3. If valid: print `{"permission":"allow"}` and exit 0.

That gives a clear "hey did you run the following…?" without any automatic re-prompt or loop.

### Done hook (prompt-based, no script)

This repo provides a **stop** hook with **type: "prompt"** so that when the agent loop ends, an LLM evaluates whether verification ran and passed; if not, the agent gets a follow-up message. No receipt file or script. See the [verify-on-stop-prompt-hook template](../../.cursor/templates/verify-on-stop-prompt-hook/README.md).

---

## 3. Hook vs single-path command/skill

### Hook-only (current pattern)

- **Gate:** `beforeShellExecution` with matcher for `task-master set-status.*done` (or equivalent). Script checks receipt; denies if missing/stale; can return `agent_message`.
- **Pros:** Hard technical barrier: "mark done" never runs until receipt is present and recent.
- **Cons:** Depends on Cursor hooks; agent must discover that it should run the verify script (hence the need for a clear `agent_message`).

### Single-path command/skill (verify-then-mark-done)

- **Idea:** The only supported way to "mark done" is a **command** (or skill) that: (1) runs the project verification script, (2) if it fails, stops and reports, (3) if it succeeds, writes the receipt (if not already written by the script) and then runs `task-master set-status ... done`. AGENTS.md and rules say: "To mark a task done, use the verify-and-complete-task command. Do not call task-master set-status done directly."
- **Pros:** Single, documented path; no hook required; works in any environment that can run the command.
- **Cons:** Agent can still call `task-master set-status ... done` directly and bypass the command unless a **hook** also blocks that.

### Recommended: both

- **Single path (command):** Provide and document a verify-and-complete-task command (or script) that runs verification and then marks done. Easy to adopt and likely to succeed.
- **Hook (hard requirement):** Use the receipt-check hook so that **even if** the agent tries to mark done directly, the hook blocks and returns an `agent_message` pointing to the verify script and retry. That way the technical requirement is enforced; the command is the preferred path.

---

## 4. Summary and recommendations

| Question | Finding |
|----------|---------|
| Dedicated file that test suites touch? | **Yes.** Use a single receipt file (e.g. `.cursor/verification-receipt`) written **only** by the project’s test/verification script on success. Requires small changes per harness (shell, Make, pytest, Jest, etc.). |
| Hook that says "hey did you run…?" without infinite loop? | **Yes.** `beforeShellExecution` can return `permission: "deny"` and `agent_message`. The agent gets the message; there is no auto re-submit from this hook, so no infinite loop. Prefer updating the receipt-check script to output this JSON on deny. |
| Hook vs command/skill? | **Use both:** (1) A **command** (verify-and-complete-task) as the documented single path; (2) A **hook** that gates "mark done" on receipt and returns a clear `agent_message` so direct "mark done" is blocked and the agent is told what to do. |

### Stop hook alternative (run on every completion)

For **"run verification whenever the agent is done, for any reason"** (not only when a specific shell command runs), use the **stop** hook instead of beforeShellExecution. The stop hook fires when the agent loop ends (completed, aborted, or error). Run verification in the script; if it fails, return `followup_message` so Cursor auto-submits a message and the agent continues (up to Cursor’s follow-up cap, e.g. 5). See [Verify-before-done enforcement](verify-before-done-enforcement.md) option 2a and [Cursor hooks](cursor-hooks.md) section "Verify-before-done: which hook event?". **Do not default to beforeShellExecution** when the requirement is "whenever done" or "for any reason"—consider the stop hook first.

### Concrete next steps

1. **Done hook:** Use the [verify-on-stop-prompt-hook template](../../.cursor/templates/verify-on-stop-prompt-hook/README.md) (stop + prompt); copy the `stop` entry into the project’s `.cursor/hooks.json`. Edit the prompt to match the project’s verification command if needed.
2. **Keep** the verify-and-complete-task **command** template as the preferred path; document in AGENTS.md and the implementation guidance that the done hook (stop + prompt) can enforce verification at agent completion.

---

## Related artifacts

- [Verify-before-done rule](../../.cursor/rules/meta/verify-before-done.mdc)
- [Verify-before-done enforcement options](verify-before-done-enforcement.md)
- [Cursor hooks](cursor-hooks.md) — beforeShellExecution output schema
- [Verify-on-stop-prompt-hook template](../../.cursor/templates/verify-on-stop-prompt-hook/README.md) — done hook (stop + prompt), no script
- [Revive DX implementation guidance](revive-dx-implementation-guidance.md)
