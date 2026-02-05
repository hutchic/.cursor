# Verify-Before-Done: Hard Enforcement Options

The [Verify-Before-Done rule](../../.cursor/rules/meta/verify-before-done.mdc) gives behavioral guidance. In practice, **hard requirements often work better**—e.g. a failing pre-commit that forces agents to run tests. This doc lists options to enforce verification by design so the agent cannot easily skip it.

## Options (strongest to softest)

### 1. Pre-commit runs tests

**What:** Add a hook in `.pre-commit-config.yaml` that runs the test suite (or a fast subset). Commit fails if tests fail.

**How:** Local hook or a repo that runs `make test` / `npm test` / `pytest`. Agent cannot complete a commit without tests having passed.

**Pros:** Works in any repo; no Cursor-specific setup; you’ve had good luck with this pattern.
**Cons:** Agent can still *say* "I'm done" before attempting commit; enforcement is at commit time.
**Bypass risk:** Low if the project rule is "never use `--no-verify`" and that’s enforced (e.g. CI also runs tests and fails the PR).

---

### 2. Cursor hook: gate `git commit` until tests pass

**What:** Use Cursor’s `beforeShellExecution` with a matcher for `git commit`. A script runs the test suite; if tests fail, the hook returns deny (exit 2) and the commit never runs.

**How:** `.cursor/hooks.json` + a script (e.g. `.cursor/hooks/require-tests-before-commit.sh`) that runs `make test` (or equivalent) and exits 2 on failure, 0 on success. Cursor runs this before any `git commit`; only on success does the shell command proceed.

**Pros:** Enforcement inside the agent loop; agent cannot commit without tests having just passed.
**Cons:** Requires Cursor; every commit attempt runs tests (can be slow); need a clear matcher so only `git commit` is gated.
**Bypass risk:** Low unless the agent uses a different path (e.g. external git client). Document "use Cursor / this workflow for commits."

---

### 3. Single path to commit (Makefile / script)

**What:** The only documented and supported way to commit is `make commit` (or `./scripts/commit.sh`), which runs tests, then pre-commit, then `git commit`. AGENTS.md says: "Use `make commit`. Do not use raw `git commit`."

**How:** `make commit` runs tests → pre-commit → git commit. Pre-commit also runs tests so that even a raw `git commit` fails without tests (reinforcement).

**Pros:** One canonical path; easy to document; pre-commit still enforces if someone runs `git commit` anyway.
**Cons:** Agent could still run `git commit`; real enforcement is pre-commit (or Cursor hook) running tests.
**Bypass risk:** Medium for "saying done" (agent could say done without committing); low for "getting a commit through" if pre-commit runs tests.

---

### 4. Verification receipt + gate

**What:** A script runs tests and on success writes a "receipt" (e.g. `.cursor/.verified` with timestamp). A Cursor hook or pre-commit checks for a recent receipt before allowing `git commit`. No receipt or stale receipt → block.

**How:** `make verify` (or `scripts/verify.sh`) runs tests and only on success writes the receipt. Hook or pre-commit: if command is `git commit`, check receipt exists and is recent (e.g. &lt; 5 minutes); else deny or run tests.

**Pros:** Can separate "run tests" from "commit" (e.g. run tests once, then multiple commits); receipt proves verification ran.
**Cons:** More moving parts; receipt can be gamed if the agent can write the file without running tests—so the receipt must be written only by the script that runs tests (script owned by project).
**Bypass risk:** Low if receipt is written only inside the test script on success; medium if anything can write it.

---

### 5. CI as the only "done"

**What:** "Done" is defined as "PR merged." PR cannot merge until CI (including tests) passes. The agent can say "I'm done" but the merge doesn’t happen until tests pass.

**How:** Branch protection requires CI success; no way to merge without green tests.

**Pros:** No way to get code into the main branch without tests passing; editor-agnostic.
**Cons:** Does not stop the agent from claiming "done" before merge; only prevents unverified code from being merged.
**Bypass risk:** None for merge; high for "declare done without verification" (behavioral only).

---

### 6. Task/plan system requires verification step

**What:** In Task Master (or similar), a task cannot be marked complete until a verification step has run—e.g. a script that runs tests and only then marks the task done via the tool’s API.

**How:** "Mark complete" is only possible through a script that (1) runs tests, (2) on success calls the API to mark complete. Agent or user runs that script instead of marking complete in the UI.

**Pros:** In that system, "done" is by definition verified.
**Cons:** Depends on that tooling; agent might still say "task complete" in chat.
**Bypass risk:** Low inside the system; medium for natural-language "I'm done."

---

## Recommended combination

- **Pre-commit runs tests** (option 1): commit cannot succeed without tests. Pair with a project rule: never use `--no-verify`.
- **Cursor hook for `git commit`** (option 2): optional extra layer so that in Cursor, every commit attempt runs tests first; agent cannot skip by not running tests before committing.
- **Verify-Before-Done rule** (behavioral): still state that the agent must run verification and report the result before declaring done; the hard enforcement makes it difficult to skip in practice.

## Relation to this repo

This repo (`.cursor` config) is mostly markdown and config; it may not have a test suite. These options apply to **downstream projects** that use these rules and have tests. Document in those projects’ AGENTS.md or contributing guide which enforcement is in place (e.g. "Pre-commit runs tests; never use `--no-verify`").

## Related Artifacts

- [Verify-Before-Done Rule](../../.cursor/rules/meta/verify-before-done.mdc)
- [Cursor Hooks](cursor-hooks.md) – for `beforeShellExecution` and matchers
- [PRE_COMMIT_SETUP](../../.github/PRE_COMMIT_SETUP.md) – git pre-commit (separate from Cursor hooks)
