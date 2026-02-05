# Subagent Orchestration: Dev Pipeline (ADR → Test Plan → Code → Review → QA)

Research on setting up Cursor subagents for a chunked development flow: orchestrator distributes work, architect writes ADR, tester defines and runs test plan, coder implements, reviewer refactors, tester runs manual then automated tests with “send back” on failure.

## Summary

- **Orchestrator** = the main Cursor agent (or the user). Cursor does **not** support nested subagents; only the main agent can invoke subagents. So the “orchestrator” is the agent that runs when you use a command or prompt.
- **Flow** is implemented as a **command** (e.g. `/dev-pipeline` or `/feature-flow`) that describes the sequence. The main agent follows the command and invokes specialist **subagents** in order, passing context via **handoff artifacts** (files: ADR, test plan).
- **Send-back on failure**: When tester (manual or automated) fails, the orchestrator re-invokes the coder (or tester for test authoring) with the failure report; no special API—just “invoke subagent again with this context.”

## How Cursor Subagents Work (Relevant Bits)

- **Single-level only**: Subagents cannot launch other subagents. The **parent (main) agent** must coordinate.
- **Context isolation**: Each subagent has its own context window. The parent must pass everything the subagent needs in the prompt (or via files the subagent can read).
- **Invocation**: Automatic (agent decides from descriptions) or explicit: `/architect`, `/tester`, `/coder`, etc.
- **Foreground vs background**: Foreground = wait for result (default for this pipeline). Background = fire-and-forget.
- **Handoffs**: Use **files** (e.g. ADR, test plan) so the next subagent can read them. The parent includes paths and a short summary in the next subagent’s prompt.

References: [Cursor Subagents](https://cursor.com/docs/context/subagents), [Cursor Subagents Documentation](docs/cursor-subagents.md).

## Mapping Your Flow to Cursor

| Step | Role | Who does it in Cursor | Handoff / “send back” |
|------|------|------------------------|------------------------|
| 1 | Orchestrator | Main agent (user runs a command or prompt) | N/A |
| 2 | Architect | Subagent `architect` | Writes **ADR** to a file (e.g. `docs/adr/YYYY-MM-DD-title.md`) |
| 3 | Tester (plan) | Subagent `tester` | Writes **test plan** to a file (e.g. `docs/test-plans/feature-name.md`) |
| 4 | Coder | Subagent `coder` | Reads ADR + test plan; implements |
| 5 | Code reviewer | Subagent `code-reviewer` | Reads diff/code; suggests DRY/YAGNI/refactors; can apply or report |
| 6 | Tester (manual QA) | Subagent `tester` | Runs manual checks (browser MCP, curl, CLI); writes result; **if fail → orchestrator re-invokes coder** with failure report |
| 7 | Tester (automated) | Subagent `tester` | Develops/adapts automated tests, runs them; **if fail → orchestrator re-invokes coder** (or tester to fix tests) |

“Send back” = orchestrator (main agent) sees the subagent’s result (e.g. “Manual QA failed: …” or “Automated tests failed: …”) and invokes the appropriate subagent again with that result in the prompt.

## Setup Overview

1. **One command** that defines the pipeline and tells the main agent to run subagents in sequence and handle failures.
2. **Several subagents** (architect, tester, coder, code-reviewer), each with a clear description and instructions.
3. **Conventions for handoff artifacts**: where ADRs and test plans live, and how the orchestrator passes their paths into each subagent.

### 1. Pipeline Command (Orchestrator Instructions)

Create a command file, e.g. `.cursor/commands/meta/dev-pipeline.md` (or `.cursor/commands/feature-flow.md`), that the main agent follows. It should:

- Define the **sequence**: architect → tester (plan) → coder → code-reviewer → tester (manual QA) → tester (automated).
- Specify **handoff artifacts**:
  - Architect writes ADR to `docs/adr/<date>-<slug>.md` (or project convention).
  - Tester writes test plan to `docs/test-plans/<feature-slug>.md`.
- For **coder**: “Use the architect and tester subagents’ outputs: read the ADR at … and the test plan at … (or ask user if not specified), then implement.”
- For **code-reviewer**: “Review the changes since the last commit (or since branch point). Apply or suggest DRY / YAGNI / refactors.”
- For **tester (manual)**: “Run the test plan manually (browser, curl, CLI). If any step fails, report clearly and stop; the orchestrator will send this back to coder.”
- For **tester (automated)**: “Implement or adapt automated tests per test plan, run them. If they fail, report; orchestrator will send back to coder (or to you to fix tests).”
- **Conditional “send back”**: “If tester (manual or automated) reports failure, re-invoke the coder subagent with the failure report and ask for fixes; then re-run the relevant tester step. Repeat until manual and automated tests pass or user stops.”

The main agent does not need a separate “orchestrator subagent”; it **is** the orchestrator when executing this command.

### 2. Subagent Definitions (Sketch)

- **architect**
  - **Description**: “Writes Architecture Decision Records (ADRs). Use when a feature or change needs an ADR before implementation.”
  - **Instructions**: Given a feature/change request, write an ADR (context, decision, consequences) and save to `docs/adr/YYYY-MM-DD-<slug>.md`. Return the path.

- **tester**
  - **Description**: “Defines test plans, runs manual QA (browser, curl, CLI), and develops/adapts automated tests. Use for test planning, manual verification, and test automation.”
  - **Instructions**:
    - **Test plan mode**: From ADR/requirements, write a test plan (scenarios, manual steps, desired automated coverage) and save to `docs/test-plans/<slug>.md`.
    - **Manual QA mode**: Run the test plan manually (use browser MCP, terminal for curl/CLI). Report pass/fail per scenario; if fail, report clearly so coder can fix.
    - **Automated mode**: Add or adapt automated tests from the test plan, run the test suite. Report results; if fail, report so coder or tester can fix.

- **coder**
  - **Description**: “Implements features from an ADR and test plan. Use when implementation is ready and ADR + test plan exist.”
  - **Instructions**: Read the given ADR and test plan paths. Implement to satisfy both. Do not change the test plan or ADR unless asked.

- **code-reviewer**
  - **Description**: “Reviews new code for DRY, YAGNI, and refactoring. Use after implementation, before QA.”
  - **Instructions**: Review the current changes (diff). Suggest or apply refactors for DRY/YAGNI and clarity. Report what was changed.

### 3. Handoff Artifacts

- **ADR**: e.g. `docs/adr/YYYY-MM-DD-feature-name.md`. Architect creates it; coder (and optionally tester) read it.
- **Test plan**: e.g. `docs/test-plans/feature-name.md`. Tester creates it; coder and tester use it. Include:
  - Manual QA: steps, expected results, how to run (browser, curl, CLI).
  - Automated: which tests to add/run (e.g. “run `pytest tests/…`”).

Orchestrator prompt for each step should include: “ADR path: …”, “Test plan path: …”, “Last failure report (if any): …”.

### 4. Manual QA (Browser, curl, CLI)

- **Browser**: Cursor’s built-in **Browser** subagent (MCP) is for browser automation; your **tester** subagent can ask the user to “run manual QA in browser” or use the same MCP tools (if available in your setup) to drive the browser.
- **curl / CLI**: Tester subagent runs in the same environment as the main agent and can run terminal commands (e.g. `curl`, project CLI). So “run test plan manually” can include: “Run these curl commands and these CLI commands; record outcomes in the result file.”

So: manual QA is either the tester subagent running commands and reporting, or the user doing steps and pasting results; the command can say “tester subagent runs manual steps where possible (curl, CLI) and uses browser MCP if available; otherwise report manual steps for the user.”

### 5. “Send Back” Semantics

- Tester (manual or automated) **returns a clear result**: “PASS” or “FAIL: `&lt;description&gt;`”.
- Main agent (orchestrator), when following the pipeline command, **interprets FAIL** and:
  - Re-invokes **coder** with: “Tester reported: FAIL: … Fix the implementation and tell me when done.”
  - Or re-invokes **tester** with: “Automated tests failed: … Fix the tests or the test run and re-run.”
- Then re-runs the relevant tester step. No special Cursor API—just “invoke subagent again with the failure in the prompt.”

## Optional: Hooks for “Run Until Tests Pass”

Cursor’s [Agent Workflows](https://cursor.com/docs/cookbook/agent-workflows) describe **hooks** (e.g. `.cursor/hooks.json` + a script) that can return a `followup_message` to keep the agent looping (e.g. “run tests; if fail, continue”). You could:

- After coder + reviewer, run a hook that: runs automated tests, and if they fail, returns a followup like “Tests failed. Fix and re-run tests.”
- That gives you an “iterate until tests pass” loop without manually re-invoking; the pipeline command can reference this hook for the automated-test step.

## File Layout Suggestion

```
.cursor/
  commands/
    meta/
      dev-pipeline.md       # Orchestrator steps + when to send back
  agents/
    architect.md            # Writes ADR
    tester.md              # Test plan, manual QA, automated tests
    coder.md                # Implements from ADR + test plan
    code-reviewer.md        # DRY / YAGNI / refactor
docs/
  adr/                     # ADRs (e.g. YYYY-MM-DD-title.md)
  test-plans/              # Test plans (e.g. feature-name.md)
```

## Constraints and Caveats

- **No nested subagents**: Only the main agent can call subagents. The “orchestrator” is the main agent following the command.
- **Token cost**: Each subagent has its own context. Running architect → tester → coder → reviewer → tester (x2) is several context windows; use for substantial features.
- **Max Mode**: On legacy request-based plans, subagents require [Max Mode](https://cursor.com/docs/context/max-mode).
- **Resume**: If a subagent is long-running, you can resume it by agent ID (see [Cursor Subagents Documentation](docs/cursor-subagents.md)) to continue with the same context.

## References

- [Cursor Subagents](https://cursor.com/docs/context/subagents) — official docs
- [Cursor Subagents Documentation](docs/cursor-subagents.md) — this repo’s guide
- [Common Agent Workflows](https://cursor.com/docs/cookbook/agent-workflows) — TDD, commands, hooks
- [Cursor Commands Documentation](docs/cursor-commands.md) — command format and locations
- [Automation Decomposition Rule](.cursor/rules/meta/automation-decomposition.mdc) — decompose into skills/commands; here the pipeline is a command that invokes subagents

## Related Artifacts

- [Cursor Subagents Documentation](../cursor-subagents.md)
- [Cursor Commands Documentation](../cursor-commands.md)
- [Subagent Template](../../.cursor/templates/subagent-template.md) — for creating architect, tester, coder, code-reviewer
- [Meta subagents](../../.cursor/agents/meta/) — examples: artifact-creator, conversation-analyzer
