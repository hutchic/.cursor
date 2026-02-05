# Cursor Subagents Documentation

This document explains how Cursor Subagents work, how to create them, and best practices for using them.

## What Are Cursor Subagents?

Subagents are specialized AI assistants that Cursor's agent can delegate tasks to. Each subagent operates in its own context window, handles specific types of work, and returns its result to the parent agent. Use subagents to break down complex tasks, do work in parallel, and preserve context in the main conversation.

### Key Features

- **Context isolation**: Each subagent has its own context window. Long research or exploration tasks don't consume space in your main conversation.
- **Parallel execution**: Launch multiple subagents simultaneously. Work on different parts of your codebase without waiting for sequential completion.
- **Specialized expertise**: Configure subagents with custom prompts, tool access, and models for domain-specific tasks.
- **Reusability**: Define custom subagents and use them across projects.

> **Note:** If you're on a legacy request-based plan, you must enable [Max Mode](https://cursor.com/docs/context/max-mode) to use subagents. Usage-based plans have subagents enabled by default.

## How Subagents Work

When Agent encounters a complex task, it can launch a subagent automatically. The subagent receives a prompt with all necessary context, works autonomously, and returns a final message with its results.

Subagents start with a clean context. The parent agent includes relevant information in the prompt since subagents don't have access to prior conversation history.

### Foreground vs Background

Subagents run in one of two modes:

| Mode | Behavior | Best for |
|------|----------|----------|
| **Foreground** | Blocks until the subagent completes. Returns the result immediately. | Sequential tasks where you need the output. |
| **Background** | Returns immediately. The subagent works independently. | Long-running tasks or parallel workstreams. |

## Built-in Subagents

Cursor includes three built-in subagents that handle context-heavy operations automatically:

| Subagent | Purpose | Why it's a subagent |
|----------|---------|---------------------|
| **Explore** | Searches and analyzes codebases | Codebase exploration generates large intermediate output that would bloat the main context. Uses a faster model to run many parallel searches. |
| **Bash** | Runs series of shell commands | Command output is often verbose. Isolating it keeps the parent focused on decisions, not logs. |
| **Browser** | Controls browser via MCP tools | Browser interactions produce noisy DOM snapshots and screenshots. The subagent filters this down to relevant results. |

### Why These Subagents Exist

These three operations share common traits:
- They generate noisy intermediate output
- They benefit from specialized prompts and tools
- They can consume significant context

Running them as subagents solves several problems:
- **Context isolation**: Intermediate output stays in the subagent. The parent only sees the final summary.
- **Model flexibility**: The explore subagent uses a faster model by default. This enables running 10 parallel searches in the time a single main-agent search would take.
- **Specialized configuration**: Each subagent has prompts and tool access tuned for its specific task.
- **Cost efficiency**: Faster models cost less. Isolating token-heavy work in subagents with appropriate model choices reduces overall cost.

You don't need to configure these subagents. Agent uses them automatically when appropriate.

## When to Use Subagents

| Use subagents when... | Use skills when... |
|----------------------|-------------------|
| You need context isolation for long research tasks | The task is single-purpose (generate changelog, format) |
| Running multiple workstreams in parallel | You want a quick, repeatable action |
| The task requires specialized expertise across many steps | The task completes in one shot |
| You want an independent verification of work | You don't need a separate context window |

> **Tip:** If you find yourself creating a subagent for a simple, single-purpose task like "generate a changelog" or "format imports," consider using a [skill](docs/cursor-skills.md) instead.

## Creating Custom Subagents

### File Locations

Subagents can be stored in multiple locations:

| Type | Location | Scope |
|------|----------|-------|
| **Project subagents** | `.cursor/agents/` | Current project only |
| | `.claude/agents/` | Current project only (Claude compatibility) |
| | `.codex/agents/` | Current project only (Codex compatibility) |
| **User subagents** | `~/.cursor/agents/` | All projects for current user |
| | `~/.claude/agents/` | All projects for current user (Claude compatibility) |
| | `~/.codex/agents/` | All projects for current user (Codex compatibility) |

Project subagents take precedence when names conflict. When multiple locations contain subagents with the same name, `.cursor/` takes precedence over `.claude/` or `.codex/`.

### File Format

Each subagent is a markdown file with YAML frontmatter:

```markdown
---
name: security-auditor
description: Security specialist. Use when implementing auth, payments, or handling sensitive data.
model: inherit
---

You are a security expert auditing code for vulnerabilities.

When invoked:
1. Identify security-sensitive code paths
2. Check for common vulnerabilities (injection, XSS, auth bypass)
3. Verify secrets are not hardcoded
4. Review input validation and sanitization

Report findings by severity:
- Critical (must fix before deploy)
- High (fix soon)
- Medium (address when possible)
```

### Configuration Fields

| Field | Required | Description |
|-------|----------|-------------|
| `name` | No | Unique identifier. Use lowercase letters and hyphens. Defaults to filename without extension. |
| `description` | No | When to use this subagent. Agent reads this to decide delegation. |
| `model` | No | Model to use: `fast`, `inherit`, or a specific model ID. Defaults to `inherit`. |
| `readonly` | No | If `true`, the subagent runs with restricted write permissions. |
| `is_background` | No | If `true`, the subagent runs in the background without waiting for completion. |

### Quick Start

The easiest way to create a subagent is to ask Agent to create one for you:

```
Create a subagent file at .cursor/agents/verifier.md with YAML frontmatter (name, description) followed by the prompt. The verifier subagent should validate completed work, check that implementations are functional, run tests, and report what passed vs what's incomplete.
```

You can also create subagents manually by adding markdown files to `.cursor/agents/` (project) or `~/.cursor/agents/` (user).

## Using Subagents

### Automatic Delegation

Agent proactively delegates tasks based on:
- The task complexity and scope
- Custom subagent descriptions in your project
- Current context and available tools

Include phrases like "use proactively" or "always use for" in your description field to encourage automatic delegation.

### Explicit Invocation

Request a specific subagent by using the `/name` syntax in your prompt:

```
> /verifier confirm the auth flow is complete
> /debugger investigate this error
> /security-auditor review the payment module
```

You can also invoke subagents by mentioning them naturally:

```
> Use the verifier subagent to confirm the auth flow is complete
> Have the debugger subagent investigate this error
> Run the security-auditor subagent on the payment module
```

### Parallel Execution

Launch multiple subagents concurrently for maximum throughput:

```
> Review the API changes and update the documentation in parallel
```

Agent sends multiple Task tool calls in a single message, so subagents run simultaneously.

## Resuming Subagents

Subagents can be resumed to continue previous conversations. This is useful for long-running tasks that span multiple invocations.

Each subagent execution returns an agent ID. Pass this ID to resume the subagent with full context preserved:

```
> Resume agent abc123 and analyze the remaining test failures
```

> **Note:** Background subagents write their state as they run. You can resume a subagent after it completes to continue the conversation with preserved context.

## Common Patterns

### Verification Agent

A verification agent independently validates whether claimed work was actually completed. This addresses a common issue where AI marks tasks as done but implementations are incomplete or broken.

```markdown
---
name: verifier
description: Validates completed work. Use after tasks are marked done to confirm implementations are functional.
model: fast
---

You are a skeptical validator. Your job is to verify that work claimed as complete actually works.

When invoked:
1. Identify what was claimed to be completed
2. Check that the implementation exists and is functional
3. Run relevant tests or verification steps
4. Look for edge cases that may have been missed

Be thorough and skeptical. Report:
- What was verified and passed
- What was claimed but incomplete or broken
- Specific issues that need to be addressed

Do not accept claims at face value. Test everything.
```

This pattern is useful for:
- Validating that features work end-to-end before marking tickets complete
- Catching partially implemented functionality
- Ensuring tests actually pass (not just that test files exist)

### Orchestrator Pattern

For complex workflows, a parent agent can coordinate multiple specialist subagents in sequence:

1. **Planner** analyzes requirements and creates a technical plan
2. **Implementer** builds the feature based on the plan
3. **Verifier** confirms the implementation matches requirements

Each handoff includes structured output so the next agent has clear context.

## Example Subagents

### Debugger

```markdown
---
name: debugger
description: Debugging specialist for errors and test failures. Use when encountering issues.
---

You are an expert debugger specializing in root cause analysis.

When invoked:
1. Capture error message and stack trace
2. Identify reproduction steps
3. Isolate the failure location
4. Implement minimal fix
5. Verify solution works

For each issue, provide:
- Root cause explanation
- Evidence supporting the diagnosis
- Specific code fix
- Testing approach

Focus on fixing the underlying issue, not symptoms.
```

### Test Runner

```markdown
---
name: test-runner
description: Test automation expert. Use proactively to run tests and fix failures.
---

You are a test automation expert.

When you see code changes, proactively run appropriate tests.

If tests fail:
1. Analyze the failure output
2. Identify the root cause
3. Fix the issue while preserving test intent
4. Re-run to verify

Report test results with:
- Number of tests passed/failed
- Summary of any failures
- Changes made to fix issues
```

### Security Auditor

```markdown
---
name: security-auditor
description: Security specialist. Use when implementing auth, payments, or handling sensitive data.
model: inherit
---

You are a security expert auditing code for vulnerabilities.

When invoked:
1. Identify security-sensitive code paths
2. Check for common vulnerabilities (injection, XSS, auth bypass)
3. Verify secrets are not hardcoded
4. Review input validation and sanitization

Report findings by severity:
- Critical (must fix before deploy)
- High (fix soon)
- Medium (address when possible)
```

## Best Practices

### Write Focused Subagents

- **Single responsibility**: Each subagent should have a single, clear responsibility. Avoid generic "helper" agents.
- **Be specific**: "Security auditor for authentication flows" is better than "helps with security"

### Invest in Descriptions

- **The `description` field determines when Agent delegates** to your subagent. Spend time refining it.
- **Test by making prompts** and checking if the right subagent gets triggered.
- **Use keywords**: Include terms that indicate when the subagent should be used.
- **Include trigger phrases**: Phrases like "use proactively" or "always use for" encourage automatic delegation.

### Keep Prompts Concise

- **Long, rambling prompts dilute focus**. Be specific and direct.
- **Focus on what the subagent should do**, not how it should think.
- **Include concrete steps** and expected outputs.

### Version Control

- **Add subagents to version control**: Check `.cursor/agents/` into your repository so the team benefits.
- **Document subagent purpose**: Include clear descriptions of when and why to use each subagent.

### Start with Agent-Generated Agents

- **Let Agent help you draft** the initial configuration, then customize.
- **Iterate based on usage**: Refine descriptions and prompts based on how well they work in practice.

### Anti-patterns to Avoid

> **Warning:** **Don't create dozens of generic subagents.** Having 50+ subagents with vague instructions like "helps with coding" is ineffective. Agent won't know when to use them, and you'll waste time maintaining them.

- **Vague descriptions**: "Use for general tasks" gives Agent no signal about when to delegate. Be specific: "Use when implementing authentication flows with OAuth providers."
- **Overly long prompts**: A 2,000-word prompt doesn't make a subagent smarter. It makes it slower and harder to maintain.
- **Duplicating slash commands**: If a task is single-purpose and doesn't need context isolation, use a [command](docs/cursor-commands.md) instead.
- **Too many subagents**: Start with 2-3 focused subagents. Add more only when you have clear, distinct use cases.

## Managing Subagents

### Creating Subagents

1. **Ask Agent to create one**: The easiest way is to ask Agent to create a subagent file for you.
2. **Create manually**: Add markdown files to `.cursor/agents/` (project) or `~/.cursor/agents/` (user).
3. **Use templates**: Start with example subagents and customize for your needs.

### Viewing Subagents

Agent includes all custom subagents in its available tools. You can see which subagents are configured by checking the `.cursor/agents/` directory in your project.

### Background Subagents

Background subagents write output to `~/.cursor/subagents/`. The parent agent can read these files to check progress.

## Performance and Cost

Subagents have trade-offs. Understanding them helps you decide when to use them.

| Benefit | Trade-off |
|---------|-----------|
| Context isolation | Startup overhead (each subagent gathers its own context) |
| Parallel execution | Higher token usage (multiple contexts running simultaneously) |
| Specialized focus | Latency (may be slower than main agent for simple tasks) |

### Token and Cost Considerations

- **Subagents consume tokens independently**: Each subagent has its own context window and token usage. Running five subagents in parallel uses roughly five times the tokens of a single agent.
- **Evaluate the overhead**: For quick, simple tasks, the main agent is often faster. Subagents shine for complex, long-running, or parallel work.
- **Subagents can be slower**: The benefit is context isolation, not speed. A subagent doing a simple task may be slower than the main agent because it starts fresh.

## Subagents vs Skills vs Commands vs Rules

Understanding when to use each:

| Feature | Subagents | Skills | Commands | Rules |
|---------|-----------|--------|----------|-------|
| **Purpose** | Specialized AI assistants with context isolation | Domain-specific knowledge + scripts | Reusable workflows | Persistent AI instructions |
| **Trigger** | Automatic (context-based) or manual (`/name`) | Automatic (context-based) or manual (`/skill-name`) | Manual (`/command`) | Automatic (based on context/metadata) |
| **Format** | Markdown with YAML frontmatter | Folder with `SKILL.md` + optional scripts | Markdown file | Markdown with metadata |
| **Location** | `.cursor/agents/` | `.cursor/skills/` | `.cursor/commands/` | `.cursor/rules/` |
| **Context** | Own context window | Shared context | Shared context | Shared context |
| **Scripts** | ❌ Instructions only | ✅ Can include executable scripts | ❌ Instructions only | ❌ Instructions only |
| **Parallel** | ✅ Yes | ❌ No | ❌ No | ❌ No |
| **Use case** | Complex tasks needing isolation | Domain knowledge + automation | Checklists, workflows | Code patterns, conventions |

**Use Subagents for:**
- Complex tasks that need context isolation
- Long-running research or exploration
- Parallel workstreams
- Independent verification of work
- Tasks requiring specialized expertise across many steps

**Use Skills for:**
- Domain-specific knowledge that benefits from automatic detection
- Workflows that include executable scripts
- Knowledge that should be available across projects

**Use Commands for:**
- Checklists and step-by-step workflows
- Processes that need to be triggered manually
- Tasks that benefit from structured guidance without scripts

**Use Rules for:**
- Code generation patterns
- Style and architecture standards
- Persistent AI guidance that should always apply

## Troubleshooting

### Subagents Not Being Invoked

1. **Check description**: Ensure description clearly indicates when the subagent should be used
2. **Review context**: The agent decides relevance based on context and description
3. **Try explicit invocation**: Type `/subagent-name` to explicitly invoke the subagent
4. **Test with simple task**: Verify the subagent works with a straightforward request

### Subagents Not Working as Expected

1. **Review prompt**: Ensure instructions are specific and unambiguous
2. **Check configuration**: Verify frontmatter fields are correct
3. **Test manually**: Invoke the subagent explicitly with a simple task
4. **Check model setting**: Ensure the model configuration is appropriate

### Performance Issues

1. **Evaluate overhead**: For simple tasks, the main agent may be faster
2. **Check token usage**: Running multiple subagents in parallel increases token usage
3. **Consider background mode**: Use `is_background: true` for long-running tasks

### Plan Limitations

1. **Check plan type**: Legacy request-based plans require Max Mode to use subagents
2. **Enable Max Mode**: If on a legacy plan, enable Max Mode from the model picker
3. **Usage-based plans**: Subagents are enabled by default

## FAQ

### What are the built-in subagents?

Cursor includes three built-in subagents: `explore` for codebase search, `bash` for running shell commands, and `browser` for browser automation via MCP. These handle context-heavy operations automatically. You don't need to configure them.

### Can subagents launch other subagents?

Subagents run as single-level helpers. Nested subagents are unsupported today.

### How do I see what a subagent is doing?

Background subagents write output to `~/.cursor/subagents/`. The parent agent can read these files to check progress.

### What happens if a subagent fails?

The subagent returns an error status to the parent agent. The parent can retry, resume with additional context, or handle the failure differently.

### Can I use MCP tools in subagents?

Yes. Subagents inherit all tools from the parent, including MCP tools from configured servers.

### How do I debug a misbehaving subagent?

Check the subagent's description and prompt. Ensure the instructions are specific and unambiguous. You can also test the subagent by invoking it explicitly with a simple task.

### Why can't I use subagents on my plan?

If you're on a legacy request-based plan, you must enable [Max Mode](https://cursor.com/docs/context/max-mode) to use subagents. Enable Max Mode from the model picker, then try again. Usage-based plans have subagents enabled by default.

## References

- [Official Cursor Subagents Documentation](https://cursor.com/docs/context/subagents)
- [Cursor Skills Documentation](docs/cursor-skills.md) - Related feature for domain-specific knowledge
- [Cursor Commands Documentation](docs/cursor-commands.md) - Related feature for reusable workflows
- [Cursor Rules Documentation](docs/cursor-rules.md) - Related feature for persistent AI instructions
- [Meta Processes Guide](docs/meta-processes.md) - Self-improvement processes including meta subagents
- [Organization Guide](docs/organization.md) - How subagents are organized in this repository
- [AGENTS.md](AGENTS.md) - Agent instructions for this repository
- [Subagents in this project](.cursor/agents/) - Project-specific subagents
