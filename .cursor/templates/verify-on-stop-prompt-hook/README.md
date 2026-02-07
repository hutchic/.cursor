# Verify-on-stop (done) hook — prompt-based

A **done** hook that runs when the agent loop ends (**stop** event). It uses a **prompt** (no script): an LLM evaluates whether the agent ran verification (e.g. `make clean && make test`) and passed. If not, the hook returns a follow-up message so the agent continues; Cursor caps auto follow-ups (e.g. 5) to avoid infinite loops.

## Why prompt instead of script

- **No script to maintain** — policy is expressed in natural language in `hooks.json`.
- **No shell or timeout for `make test`** — the LLM infers from conversation context whether verification was run and passed.
- **Tradeoff:** Evaluation is inferential (based on context), not a direct run of `make clean && make test`. For a **hard guarantee** that tests actually ran, you would need a command-based hook (script that runs verification); no such template is provided in this repo at this time.

## Behavior

| LLM decision | Hook output | Effect |
|--------------|-------------|--------|
| Verification ran and passed | `{"ok": true}` | No follow-up; agent is done. |
| Verification not run or failed | `{"ok": false, "reason": "..."}` | Cursor sends `reason` as follow-up user message; agent continues (up to `loop_limit`). |

## Install into a project

1. **Add or merge hooks.json** — Copy the `stop` entry from `hooks.json.snippet` into your project’s `.cursor/hooks.json` (create the file if needed). Merge into existing `hooks` if you already have other hooks.
2. **No script** — Nothing to copy or make executable; the prompt lives in the snippet.
3. **Optional:** Adjust the prompt text in the snippet to match your project’s verification command or wording (e.g. `make test` only, or “run the test suite and fix failures”).

## Configuration

- **prompt** — Edit the prompt in the snippet to change the policy (e.g. different verification command or criteria).
- **timeout** — Seconds for the LLM evaluation (default 30 in the snippet).
- **loop_limit** — Max auto follow-ups for this hook (default 5 in the snippet). Prevents infinite retry loops.

## Related

- [Verify-before-done rule](../../rules/meta/verify-before-done.mdc)
- [Verify-before-done enforcement](../../../docs/research/verify-before-done-enforcement.md) — option 2a (stop hook)
- [Cursor hooks — which hook event?](../../../docs/research/cursor-hooks.md)
