# Cursor Hooks Research

This document summarizes Cursor's **agent hooks** system from official documentation. Hooks are distinct from **git pre-commit hooks** (which this repo uses for lint/format); Cursor hooks observe and control the **agent loop** (Cmd+K / Agent Chat and Tab completions).

**Sources:** [Cursor Hooks](https://cursor.com/docs/agent/hooks), [Third Party Hooks](https://cursor.com/docs/agent/third-party-hooks).

## What Are Cursor Hooks?

Hooks let you **observe, control, and extend the agent loop** using custom scripts. They are:

- **Spawned processes** that communicate over **stdio using JSON** (input from Cursor, output from script)
- Run **before or after** defined stages of the agent loop
- Can **observe, block, or modify** behavior (depending on hook type)

### Key Capabilities

With hooks you can:

- Run formatters after edits
- Add analytics for events
- Scan for PII or secrets
- Gate risky operations (e.g., SQL writes, shell commands)
- Control subagent (Task tool) execution
- Inject context at session start
- Block or allow file reads, MCP tool calls, or shell commands

## When to Use Hooks (and Why)

Use **Cursor hooks** when the desired behavior must run **inside the agent loop**—before or after specific agent/Tab actions—rather than as guidance (rules), reusable procedures (skills/commands), or isolated tasks (subagents).

### When Hooks Are a Good Fit

| Need | Why hooks | Example |
|------|------------|--------|
| **Run something after every file edit** | Hooks fire at `afterFileEdit` / `afterTabFileEdit`; rules/skills don’t run automatically on edit | Format or lint agent-written code immediately |
| **Gate or allow risky actions** | Hooks can block before execution (`beforeShellExecution`, `beforeMCPExecution`, `beforeReadFile`) | Block `rm -rf`, allow only read-only shell commands, block reading secrets |
| **Audit or log agent behavior** | Hooks receive full context (command, tool name, file path) at execution time | Log every shell run, audit MCP tool usage, track which files were read |
| **Inject context at session start** | `sessionStart` can add env vars or `additional_context` for the whole conversation | Per-session API keys, project-specific instructions |
| **Control subagent use** | `subagentStart` / `subagentStop` can allow/deny or trigger follow-ups | Limit which subagents run; auto-continue after subagent completes |
| **Validate prompts before send** | `beforeSubmitPrompt` can block or allow submission | Block prompts that contain sensitive data or violate policy |
| **Different policy for Tab vs Agent** | Tab has its own hooks (`beforeTabFileRead`, `afterTabFileEdit`) | Stricter redaction for autonomous Tab than for user-directed Agent |

### When to Prefer Rules, Skills, or Commands Instead

- **Persistent guidance** (e.g. “always use TypeScript strict mode”) → **Rule**
- **Reusable how-to** (e.g. “how to write commit messages”) → **Skill**
- **Manual workflow** (e.g. “steps for code review”) → **Command**
- **Complex, isolated analysis** (e.g. “analyze this conversation”) → **Subagent**

Use hooks when the behavior is **triggered by an agent/Tab event** and must run **automatically** at that moment (or block it). Use rules/skills/commands when the behavior is **invoked by context or user request**.

### When Processing Transcripts: Consider Hooks When You See

- Repeated corrections about **what the agent is allowed to do** (e.g. “don’t run that command”, “don’t read that file”) → possible **beforeShellExecution** / **beforeReadFile** hook
- Repeated requests to **format or fix code after edits** → possible **afterFileEdit** / **afterTabFileEdit** hook
- Concerns about **secrets, PII, or sensitive files** in agent context → possible **beforeReadFile** / **beforeTabFileRead** or redaction hook
- Desire to **audit or log** agent actions → **postToolUse** / **afterShellExecution** / **afterMCPExecution** hooks
- Need to **inject project or session context** at conversation start → **sessionStart** hook

If transcript analysis finds such patterns, recommend considering a hook (and which event) in addition to or instead of a rule/skill/command. See [Process Chat command](../../.cursor/commands/meta/process-chat.md) and [Conversation Analysis skill](../../.cursor/skills/meta/conversation-analysis/SKILL.md).

## Agent vs Tab Hooks

Hooks apply to two surfaces; each has its own events:

| Surface | Description | Example events |
|--------|-------------|----------------|
| **Agent** (Cmd+K / Agent Chat) | User-directed agent operations | `sessionStart`, `beforeShellExecution`, `afterFileEdit`, `beforeMCPExecution`, etc. |
| **Tab** (inline completions) | Autonomous Tab completions | `beforeTabFileRead`, `afterTabFileEdit` |

Different policies can be applied to Tab (e.g., stricter redaction) vs Agent.

## Configuration

### File and Locations

- **Config file:** `hooks.json`
- **Priority** (highest to lowest): Enterprise → Team → Project → User

| Level | Location |
|-------|----------|
| **Enterprise** | macOS: `/Library/Application Support/Cursor/hooks.json`; Linux/WSL: `/etc/cursor/hooks.json`; Windows: `C:\ProgramData\Cursor\hooks.json` |
| **Project** | `<project-root>/.cursor/hooks.json` (runs from project root; use paths like `.cursor/hooks/script.sh`) |
| **User** | `~/.cursor/hooks.json` (runs from `~/.cursor/`; use paths like `./hooks/script.sh`) |

Project hooks are the normal way to share hooks via version control.

### Basic Structure

```json
{
  "version": 1,
  "hooks": {
    "afterFileEdit": [{"command": ".cursor/hooks/format.sh"}],
    "beforeShellExecution": [{"command": ".cursor/hooks/approve-network.sh", "timeout": 30, "matcher": "curl|wget|nc"}]
  }
}
```

- **Project hooks:** paths relative to **project root** (e.g. `.cursor/hooks/script.sh`).
- **User hooks:** paths relative to `~/.cursor/` (e.g. `./hooks/script.sh`).

### Per-Script Options

| Option | Type | Description |
|--------|------|-------------|
| `command` | string | Script path or command (required for command hooks) |
| `type` | `"command"` \| `"prompt"` | Default `"command"`; `"prompt"` uses LLM to evaluate |
| `timeout` | number | Timeout in seconds |
| `loop_limit` | number \| null | For `stop` / `subagentStop`; max auto follow-ups (default 5; `null` = no limit) |
| `matcher` | string | When to run (depends on hook: tool type, subagent type, or shell command text) |

## Hook Execution Types

### Command-Based (default)

- Shell (or other) script receives JSON on stdin, returns JSON on stdout.
- **Exit code 0:** success; Cursor uses script’s JSON output.
- **Exit code 2:** block the action (same as returning `permission: "deny"` / `decision: "deny"`).
- **Other exit codes:** hook failed; action proceeds (fail-open), except where docs say fail-closed.

### Prompt-Based

- Uses an LLM to evaluate a natural-language condition (no custom script).
- Returns `{ "ok": boolean, "reason?": string }`.
- `$ARGUMENTS` in the prompt is replaced with the hook input JSON.
- Optional `model` to override the default model.

**When to use prompt-based vs command-based:**

| Use **prompt-based** when | Use **command-based** when |
|---------------------------|----------------------------|
| Policy is easy to state in natural language (“Is this command safe?”) | You need parsing, external APIs, or file I/O |
| You want to avoid writing and maintaining a script | You need deterministic logic, regex, or tooling (e.g. linter) |
| Quick to try out; no script path or exit codes | You need to block with exit code 2 or return structured JSON |
| One-off or simple allow/deny | Audit logs, formatters, or integration with other systems |

Example (prompt-based):

```json
{
  "hooks": {
    "beforeShellExecution": [{
      "type": "prompt",
      "prompt": "Does this command look safe to execute? Only allow read-only operations.",
      "timeout": 10
    }]
  }
}
```

## Hook Events (Summary)

### Session

- **sessionStart** – New composer conversation; can inject `env`, `additional_context`, or block with `continue: false`.
- **sessionEnd** – Conversation ended; fire-and-forget (logging/analytics).

### Tool use (Agent)

- **preToolUse** – Before any tool run; can `allow` / `deny` and optionally `updated_input`. Matcher: tool type (Shell, Read, Write, MCP, Task, etc.).
- **postToolUse** – After successful tool run; e.g. audit; can modify MCP output via `updated_mcp_tool_output`.
- **postToolUseFailure** – After tool fails/times out/denied; observational.

### Subagent (Task tool)

- **subagentStart** – Before subagent spawn; `decision: "allow"` | `"deny"`.
- **subagentStop** – When subagent finishes; can send `followup_message` to auto-continue.

### Shell and MCP

- **beforeShellExecution** – Before shell command; return `permission: "allow"` | `"deny"` | `"ask"`. Matcher: command text.
- **afterShellExecution** – After shell run; receives command and output.
- **beforeMCPExecution** – Before MCP tool run; **fail-closed** (hook failure = block). Return permission.
- **afterMCPExecution** – After MCP tool run; receives tool name, input, result JSON.

### File access and edits

- **beforeReadFile** – Before Agent reads a file; **fail-closed**. Return `permission: "allow"` | `"deny"`.
- **afterFileEdit** – After Agent edits a file (e.g. formatters).
- **beforeTabFileRead** – Before Tab reads a file (Tab only).
- **afterTabFileEdit** – After Tab edits a file (Tab only).

### Prompt and context

- **beforeSubmitPrompt** – Right after user sends prompt; can block with `continue: false`.
- **preCompact** – Before context compaction; observational; can set `user_message`.
- **afterAgentResponse** – After assistant message.
- **afterAgentThought** – After a thinking block.

### Agent lifecycle

- **stop** – When agent loop ends; can return `followup_message` to auto-submit next user message (subject to `loop_limit`).

## Matchers

- **preToolUse (and other tool hooks):** filter by tool type — `Shell`, `Read`, `Write`, `Grep`, `MCP`, `Task`, etc.
- **subagentStart:** filter by subagent type — e.g. `generalPurpose`, `explore`, `shell`.
- **beforeShellExecution:** filter by full shell command string (e.g. regex for `curl|wget|nc`).

## Environment Variables (in hook scripts)

| Variable | Description |
|----------|-------------|
| `CURSOR_PROJECT_DIR` | Workspace root |
| `CURSOR_VERSION` | Cursor version |
| `CURSOR_USER_EMAIL` | Authenticated user (if logged in) |
| `CURSOR_CODE_REMOTE` | Remote-aware project path (remote workspaces) |
| `CLAUDE_PROJECT_DIR` | Alias for project dir (Claude compatibility) |

Session-scoped env from `sessionStart` is passed to later hooks in that session.

## Third-Party Hooks (Claude Code)

Cursor can load hooks from **Claude Code** so the same scripts work in both:

1. Enable **Third-party skills** in Cursor Settings → Features.
2. Claude hooks are read from (in order): `.claude/settings.local.json`, `.claude/settings.json`, `~/.claude/settings.json`.
3. Cursor merges with its own priority: Enterprise → Team → Cursor project → Cursor user → Claude project local → Claude project → Claude user.

Claude event names are mapped to Cursor (e.g. `PreToolUse` → `preToolUse`, `UserPromptSubmit` → `beforeSubmitPrompt`). Exit code 2 blocks in both. Some Cursor-only features (e.g. `subagentStart`, `loop_limit`, team/enterprise distribution) are not available when using only Claude config.

## Partner Integrations

Cursor lists ecosystem partners that provide hooks-based integrations:

- **MCP governance:** MintMCP, Oasis Security, Runlayer  
- **Code security:** Corridor, Semgrep  
- **Dependency security:** Endor Labs  
- **Agent safety:** Snyk  
- **Secrets:** 1Password  

See [Hooks for security and platform teams](https://cursor.com/blog/hooks-partners) and the [Hooks docs](https://cursor.com/docs/agent/hooks#partner-integrations) for details.

## Team Distribution

- **Project (version control):** Commit `.cursor/hooks.json` and scripts; applies in trusted workspaces.
- **MDM:** Deploy `hooks.json` and scripts to user home or global config paths.
- **Cloud (Enterprise):** Configure in Cursor dashboard; syncs to team (e.g. every 30 minutes), with OS targeting.

## Troubleshooting

- **Hooks tab:** Cursor Settings has a Hooks tab and Hooks output channel for debug and errors.
- **Restart Cursor** after changing hooks.
- **Paths:** Project hooks run from project root (`.cursor/hooks/...`); user hooks from `~/.cursor/` (`./hooks/...`).
- **Blocking:** Use exit code **2** to block (or return `permission: "deny"` / `decision: "deny"` where applicable).

## Relation to This Repo

This repository uses **git pre-commit hooks** (via `pre-commit`) for linting and formatting before commits. Those are **separate** from Cursor hooks:

| | Git pre-commit | Cursor hooks |
|---|----------------|--------------|
| **What** | Scripts run before/after git commit | Scripts in the Cursor agent loop |
| **When** | On `git commit` | On agent/Tab actions (tool use, file read/edit, etc.) |
| **Config** | `.pre-commit-config.yaml` | `.cursor/hooks.json` |
| **Scope** | Commit-time quality | Agent behavior, security, formatting in-IDE |

Cursor hooks could, for example, run a formatter **after** the agent edits a file (`afterFileEdit`), while pre-commit runs checks **before** the commit is created. Both can coexist.

## Related Artifacts

- [Cursor Best Practices](cursor-best-practices.md) – Rules, skills, commands, subagents
- [PRE_COMMIT_SETUP](../../.github/PRE_COMMIT_SETUP.md) – Git pre-commit setup (different from Cursor hooks)
- [Cursor Hooks (official)](https://cursor.com/docs/agent/hooks)
- [Third Party Hooks](https://cursor.com/docs/agent/third-party-hooks)
