# DX Mechanisms Report: Pre-commit, Cursor Hooks, Rules, Skills, Commands, and Subagents

This report helps you choose and combine **pre-commit**, **Cursor hooks**, **rules**, **skills**, **commands**, and **subagents** to improve developer experience (including for AI agents). For each mechanism it documents options, pros/cons/costs/risks, and guidance. It ends with a **recommended sweet spot** (default subset) and **ROI (return on effort)** so you can adopt a baseline and add more only when justified.

**How to read:** Use the table of contents to jump to a specific mechanism, or go straight to [Sweet spot](#9-sweet-spot-recommended-subset-overall-guidance) and [ROI](#10-roi-return-on-effort) for overall guidance.

## Table of contents

1. [Introduction](#1-introduction)
2. [Pre-commit](#2-pre-commit)
3. [Cursor hooks](#3-cursor-hooks)
4. [Cursor rules](#4-cursor-rules)
5. [Skills](#5-skills)
6. [Commands](#6-commands)
7. [Subagents](#7-subagents)
8. [Choosing and combining mechanisms](#8-choosing-and-combining-mechanisms)
9. [Sweet spot: recommended subset (overall guidance)](#9-sweet-spot-recommended-subset-overall-guidance)
10. [ROI (return on effort)](#10-roi-return-on-effort)
11. [Related artifacts](#11-related-artifacts)

---

## 1. Introduction

**Purpose:** Improve DX by using the right mix of:

- **Pre-commit** — Git hooks run at commit time (lint, format, optionally tests).
- **Cursor hooks** — Scripts in the agent loop that run before/after agent or Tab actions (gate, format, audit).
- **Cursor rules** — Persistent guidance (project/user/team) included in context.
- **Skills** — Reusable “how” (instructions and optional scripts) that agents discover or you invoke.
- **Commands** — Manual workflows (e.g. `/shipit`) that orchestrate steps and often reference skills.
- **Subagents** — Isolated contexts for research, planning, or specialized work; main agent does implementation.

**Scope:** Options, pros/cons/costs/risks, and guidance for each mechanism; how to combine them; a recommended sweet spot and ROI so effort stays justified.

**Out of scope:** Step-by-step implementation of specific hooks or scripts; Cursor product roadmap.

---

## 2. Pre-commit

**What it is:** Git hooks configured via [pre-commit](https://pre-commit.com/) (`.pre-commit-config.yaml`). They run when you (or an agent) run `git commit`. CI can run the same checks so PRs fail if hooks would fail.

### Options

- **Lint/format only** — End-of-file, whitespace, YAML/JSON, markdownlint, Black, shellcheck, bandit, etc. Fast; no test run.
- **Include tests** — Add a local hook that runs `make test` or `npm test` / `pytest`. Commit fails if tests fail; slower commits.
- **Local vs CI** — Hooks run locally after `pre-commit install`; CI runs `pre-commit run --all-files` so PRs are gated even if someone skips local run.
- **`--no-verify` policy** — Document “never use `--no-verify`” and enforce in CI (CI does not use `--no-verify`).

### Pros

- Editor-agnostic; works with any git client.
- Version-controlled config; team shares the same checks.
- CI alignment: same checks locally and in PRs.
- Hard gate: commit cannot succeed if a hook fails (unless bypassed).

### Cons

- Enforcement is at **commit time** only; agent can still *say* “done” before committing.
- Agents that commit via tools may bypass local hooks unless they explicitly run `pre-commit run --all-files` first.
- If tests run in pre-commit, every commit is slower.

### Costs

- Initial setup: `pre-commit install`, document in AGENTS.md/PRE_COMMIT_SETUP.
- Maintaining hook revs (e.g. `pre-commit autoupdate`) and CI workflow.
- CI runtime for every PR.

### Risks

- **Bypass:** `git commit --no-verify` skips hooks. Mitigate with project rule + CI (CI does not use `--no-verify`).
- **Flaky hooks:** Intermittent failures block all commits until fixed or relaxed.

### Guidance

- Start with **lint/format** in pre-commit; add **tests** when you want commit-time test enforcement (see [Verify-Before-Done: Hard Enforcement](verify-before-done-enforcement.md)).
- Document that agents must run `pre-commit run --all-files` before committing and never use `--no-verify`.
- Keep CI in sync (e.g. `.github/workflows/pre-commit.yml` runs the same hooks).

---

## 3. Cursor hooks

**What it is:** Scripts (or prompt-based checks) configured in `.cursor/hooks.json` that run **inside the Cursor agent loop** — before or after shell commands, file reads/edits, MCP calls, subagent start/stop, etc. Distinct from git pre-commit.

### Options

- **Command-based vs prompt-based** — Command: your script, JSON in/out, exit 2 to block. Prompt: LLM evaluates natural language (e.g. “Is this command safe?”).
- **Events** — e.g. `beforeShellExecution`, `afterFileEdit`, `sessionStart`, `beforeReadFile`, `subagentStart`, `subagentStop`. See [Cursor Hooks](cursor-hooks.md) for full list.
- **Matchers** — e.g. restrict `beforeShellExecution` to commands matching `git commit|rm -rf`.
- **Project vs user vs team** — Project: `.cursor/hooks.json` (version-controlled). User: `~/.cursor/hooks.json`. Team/Enterprise: dashboard.

### Pros

- **In-agent-loop enforcement:** Gate or run something automatically when the agent does X (e.g. block `rm -rf`, run formatter after edit).
- Gating (block/allow shell, file read, MCP) without relying on the agent to “remember” a rule.
- Post-edit automation (format/lint after every file edit).
- Auditing (log shell runs, MCP use).
- Session context injection (`sessionStart`).

### Cons

- **Cursor-only;** no effect in other editors or CLI git.
- Script maintenance and debugging (stdio JSON, exit codes).
- Fail-open vs fail-closed depends on event (e.g. `beforeMCPExecution` is fail-closed).

### Costs

- Writing and maintaining scripts (and optional `hooks/` directory).
- Debugging hook failures (Cursor Hooks tab / output channel).
- Timeouts: long-running hooks can slow or block the agent.

### Risks

- Blocking **legitimate** actions if matcher or logic is too broad.
- Performance: hooks run on every matching event; heavy hooks can slow the loop.
- Hook errors: some events proceed on script failure (fail-open), so broken hooks can be silent.

### Guidance

- Use hooks when behavior must run **automatically** in the agent loop (gate, format after edit, audit), not when the user or context can invoke a skill/command. See [Artifact Creation rule](../../.cursor/rules/meta/artifact-creation.mdc) (“Consider Cursor Hooks When”).
- Prefer **command-based** when you need deterministic logic, file I/O, or exit code 2 to block; **prompt-based** for simple natural-language allow/deny.
- For events and config details, see [Cursor Hooks](cursor-hooks.md).

---

## 4. Cursor rules

**What it is:** Persistent instructions (project, user, or team) that Cursor includes in the model context. Project rules live in `.cursor/rules/` (`.md` or `.mdc`); AGENTS.md is a simpler alternative at project root.

### Options

- **Application:** Always apply; apply intelligently (description-based); apply to specific files (globs); apply manually (@-mention).
- **Scope:** Project (`.cursor/rules/`), user (Cursor Settings), team (dashboard).
- **Format:** `.mdc` with frontmatter (description, alwaysApply, globs) or plain `.md`; AGENTS.md for simple, readable instructions.

### Pros

- Persistent context: standards and patterns available every session.
- Team sharing via version-controlled project rules.
- File-scoped guidance (globs) to keep rules relevant.
- No scripts; just markdown.

### Cons

- **Context budget:** Rules consume tokens; too many or too long dilutes focus.
- Conflicting guidance when multiple rules apply; precedence is team → project → user.
- “Apply intelligently” depends on description quality; vague descriptions → wrong application.

### Costs

- Context tokens for always-on or frequently applied rules.
- Maintenance: keeping rules current and removing duplicates.
- Writing clear descriptions so “apply intelligently” works.

### Risks

- **Too many always-on rules:** Important guidance gets lost in noise.
- **Rules ahead of behavior:** Documenting “we do X” in a rule when the codebase does not yet do X can mask gaps; prefer at least one real example or an explicit “not yet implemented” note.

### Guidance

- Create a rule when you need **persistent guidance** or **domain/architecture standards** (see [Artifact Creation rule](../../.cursor/rules/meta/artifact-creation.mdc)).
- Keep rules focused (under ~500 lines); use globs for file-specific rules; reference files with `@filename` instead of inlining large blocks.
- Don’t use rules for formatting (use linters/formatters) or for common tool docs the model already knows.

---

## 5. Skills

**What it is:** Reusable “how” packaged in a folder with `SKILL.md` (and optional `scripts/`, `references/`). Agents discover skills from `.cursor/skills/` (and user/team locations) and use them when relevant; you can also invoke via `/skill-name`.

### Options

- **Instructions-only vs with scripts** — SKILL.md only, or SKILL.md plus executable scripts the agent runs.
- **Project vs user** — Project: `.cursor/skills/` (version-controlled). User: `~/.cursor/skills/` (global).
- **Progressive loading** — Keep SKILL.md concise; put detail in `references/` so context stays small until needed.

### Pros

- Reusable “how” across conversations and projects.
- Portable (same skill can be used in multiple repos).
- Can include automation (scripts); agent runs them when following the skill.
- Automatic discovery + manual invocation.

### Cons

- Agent must **choose** to use the skill; not automatic like hooks.
- Skill may not be invoked when relevant if description is weak.
- Scripts assume environment (runtime, deps); can fail if env differs.

### Costs

- Authoring SKILL.md and optional scripts/references.
- Keeping skills in sync with codebase and tooling.
- Good descriptions so the agent selects the skill when appropriate.

### Risks

- **Skill not invoked:** User expects the skill to apply but agent doesn’t use it; improve description or invoke explicitly.
- **Script assumptions:** Scripts that assume paths, env vars, or tools can fail; document compatibility and error handling.

### Guidance

- Create a skill when you have **domain knowledge with procedures** (and optionally scripts) that should be reusable (see [Artifact Creation rule](../../.cursor/rules/meta/artifact-creation.mdc)).
- Decompose automations into **discrete skills**, then **compose them in commands** (see [Automation Decomposition rule](../../.cursor/rules/meta/automation-decomposition.mdc)).
- Use progressive loading (references/) and clear “When to use” in SKILL.md.

---

## 6. Commands

**What it is:** Markdown files in `.cursor/commands/` (or user/team) that define workflows. Triggered with `/command-name`; Cursor shows them when you type `/`. Commands are checklists and steps; they often **orchestrate skills** (e.g. “use skill A, then skill B”).

### Options

- **Project vs global vs team** — Project: `.cursor/commands/` (version-controlled). Global: `~/.cursor/commands/`. Team: Cursor Dashboard.
- **Structure** — Overview, steps, checklist; reference skills by path or name.
- **Parameters** — Text after the command name is passed to the agent (e.g. `/shipit single commit`).

### Pros

- Manual trigger: standardized workflow when you (or the agent) run the command.
- Discoverable via `/` in chat.
- Good for multi-step flows (stage → commit → push → PR) that compose skills.
- No automatic context cost (only when invoked).

### Cons

- **No automatic invocation;** agent or user must remember to use the command.
- Command is guidance only; agent can still skip steps unless enforced elsewhere (e.g. pre-commit).

### Costs

- Writing and updating command markdown.
- Keeping steps aligned with actual skills and tooling (e.g. pre-commit in the flow).

### Risks

- **Command ignored:** Workflow not followed because command wasn’t run; combine with rules or pre-commit where you need hard guarantees.
- **Drift:** Command says “run X” but X moved or was renamed; update commands when scripts/skills change.

### Guidance

- Create a command for **manual workflows** and checklists that benefit from structured steps (see [Artifact Creation rule](../../.cursor/rules/meta/artifact-creation.mdc)).
- Use commands to **orchestrate skills** (e.g. shipit: stage-related-files → terse-semantic-commits + pre-commit → push → open-pr). Include pre-commit in any commit/ship flow so the command encodes the full path.
- Keep steps concrete and actionable; add a checklist section for verification.

---

## 7. Subagents

**What it is:** Specialized agents with their **own context window**, invoked by the main agent (or by you). Good for research, planning, audits, and parallel workstreams; **not** for parallel implementation on the same repo (main agent does edits and integration).

### Options

- **Project vs user** — Project: `.cursor/agents/`. User: `~/.cursor/agents/`.
- **When to spawn** — Planning, research, verification, test planning; automatic (agent decides from description) or explicit (e.g. `/architect`).
- **Hooks** — `subagentStart` / `subagentStop` can allow/deny or send follow-up messages.
- **Foreground vs background** — Foreground: wait for result. Background: fire-and-forget.

### Pros

- **Context isolation:** Long research or exploration doesn’t bloat the main conversation.
- **Parallel work:** Multiple subagents (e.g. plan task A, design task B) producing mergeable, read-only outputs (docs, recommendations).
- Specialized prompts and (where supported) model choice per subagent.
- Main agent uses subagent outputs and does implementation/integration.

### Cons

- **Not for parallel implementation:** Multiple subagents editing the same repo causes merge conflicts; implementation stays in the main agent.
- Subagents don’t see prior conversation; parent must pass context (or file paths) in the prompt.
- Coordination overhead: handoffs (e.g. ADR, test plan) and “send back on failure” are orchestrated by the main agent.

### Costs

- Defining and maintaining subagent prompts and descriptions.
- Coordinating with main flow (handoff artifacts, re-invocation on failure).
- Token cost: each subagent has its own context window.

### Risks

- **Overuse:** Using subagents for simple, single-purpose tasks (prefer skill or command).
- **Parallel edits:** Subagents that edit the same codebase in parallel; use subagents for planning/research/audit, main agent for code changes.

### Guidance

- Create a subagent when you need **context isolation** or **parallel research/planning** (see [Artifact Creation rule](../../.cursor/rules/meta/artifact-creation.mdc)).
- Use subagents for **plans, test strategies, audits**; use the **main agent** for implementation and integration. See [Subagent orchestration](subagent-orchestration-dev-pipeline.md) for pipeline patterns.
- For gating or observing subagent use, see [Cursor Hooks](cursor-hooks.md) (subagentStart, subagentStop).

---

## 8. Choosing and combining mechanisms

**Decision flow (when to use which):**

| Need | Mechanism |
|------|------------|
| **Automatic** behavior in the agent loop (gate, format after edit, audit) | **Cursor hooks** |
| **Commit-time** gate (lint, format, tests) | **Pre-commit** (+ CI) |
| **Persistent** guidance (standards, patterns) | **Rules** |
| **Reusable how-to** (with or without scripts) | **Skill** |
| **Manual workflow** (checklist, ordered steps) | **Command** (often composing skills) |
| **Context isolation** or **parallel research/planning** | **Subagent** |

**Combinations that work well:**

- **Rule + pre-commit + command:** e.g. verify-before-done rule (behavioral) + pre-commit (run tests) + shipit command (runs pre-commit in its steps). Rule states the principle; pre-commit enforces at commit; command encodes the workflow.
- **Hooks + pre-commit:** e.g. Cursor hook that gates `git commit` until tests pass, plus pre-commit for lint/format. In-loop gate + commit-time checks.
- **Subagents + main agent:** Subagents produce plans, test strategies, or audits; main agent implements and integrates. One command can define the sequence (e.g. “invoke architect, then tester (plan), then implement using coder subagent or main agent”).
- **Command + skills:** Command defines steps; each step references a skill (e.g. shipit → stage-related-files, terse-semantic-commits, open-pr). Pre-commit is run inside the command’s commit step.

---

## 9. Sweet spot: recommended subset (overall guidance)

**Start here.** For most codebases, this subset gives strong DX for reasonable effort:

1. **Pre-commit** — Lint and format (and optionally tests). Version-controlled, CI-aligned. Document “run pre-commit before commit; never use `--no-verify`.”
2. **Rules** — A small set of always-on or intelligently applied rules (e.g. coding standards, verify-before-done, artifact-creation). Keep the set focused so context stays useful.
3. **One ship-style command** — A single workflow (e.g. `/shipit`) that composes **skills** for stage → commit (with pre-commit) → push → PR. The command is the canonical “how we ship.”
4. **Skills** — The “how” for each step (staging, commit message, open PR). Skills are referenced by the command and can be discovered by the agent for other tasks.

**Add more only when the decision flow justifies it:**

- **Cursor hooks** — When you repeatedly need to **gate** (e.g. block dangerous shell commands) or **run something automatically** in the loop (e.g. format after every file edit). Don’t add hooks “because we can”; add when you have a concrete in-loop need.
- **Subagents** — When you need **isolated research**, **parallel planning**, or **specialized audits** (e.g. architect, tester, conversation-analyzer). Keep implementation in the main agent.

Adopt the sweet spot first; then add hooks or subagents only when a clear need appears (see [ROI](#10-roi-return-on-effort)).

---

## 10. ROI (return on effort)

**Best ROI (adopt first):**

- **Pre-commit** — High payoff for low effort: one config file, CI workflow, and short doc. Catches format/lint (and optionally test) failures before commit/merge.
- **A few rules** — High payoff if they encode standards you otherwise repeat (e.g. verify-before-done, artifact-creation, project style). Cost: context tokens and keeping them current.
- **One command + skills** — One ship-style command that composes 2–4 skills gives a single, discoverable path for “how we ship.” Skills are reusable elsewhere. Cost: writing and maintaining the command and skills.

**When to add more:**

- **Cursor hooks:** When you have a **repeated** need to block or run something in the agent loop (e.g. “we keep having to tell the agent not to run X” or “we want every edit auto-formatted”). One-off needs can be handled by a rule or skill.
- **Subagents:** When you have **complex, isolated** work (research, multi-step planning, independent verification) that would otherwise clutter the main context or that benefits from parallel runs (e.g. plan task 5 and task 6 in parallel, then implement sequentially).
- **More rules:** When a **new** pattern appears repeatedly (conversation analysis → artifact creation). Avoid stacking many always-on rules; prefer “apply intelligently” and good descriptions.

**When to stop:**

- Don’t add every mechanism “because we can.” The sweet spot (pre-commit + rules + one command + skills) is enough for many projects.
- Add **hooks** only when the decision flow says “automatic in-loop behavior” and you have a concrete use case.
- Add **subagents** only when you need context isolation or parallel planning, and keep implementation in the main agent.
- Prefer **fewer, focused** rules over many overlapping ones; prune or merge when rules grow without clear benefit.

---

## 11. Related artifacts

- [Cursor Hooks](cursor-hooks.md) — Events, config, when to use hooks vs rules/skills/commands
- [Cursor Best Practices](cursor-best-practices.md) — Rules, skills, commands, subagents
- [Verify-Before-Done: Hard Enforcement](verify-before-done-enforcement.md) — Pre-commit and Cursor hooks for verification
- [Artifact Creation rule](../../.cursor/rules/meta/artifact-creation.mdc) — When to create a rule, skill, command, subagent, or recommend hooks
- [Automation Decomposition rule](../../.cursor/rules/meta/automation-decomposition.mdc) — Decompose into skills, compose in commands
- [PRE_COMMIT_SETUP](../../.github/PRE_COMMIT_SETUP.md) — Git pre-commit setup (this repo)
- [Cursor Rules](../cursor-rules.md), [Cursor Skills](../cursor-skills.md), [Cursor Commands](../cursor-commands.md), [Cursor Subagents](../cursor-subagents.md) — Main docs
- [Shipit command](../../.cursor/commands/shipit.md) — Example: command composing skills and pre-commit
- [Subagent orchestration](subagent-orchestration-dev-pipeline.md) — Pipeline patterns with subagents
