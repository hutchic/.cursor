---
name: conversation-analysis
description: "Analyze AI chat conversations to extract patterns, identify repeated instructions, and categorize potential artifacts. Use when processing past conversations for self-improvement or when user provides conversation content for analysis."
---

# Conversation Analysis Skill

Analyze AI chat conversations to extract patterns, identify repeated instructions, and categorize potential artifacts for self-improvement.

## When to Use

- Use this skill when analyzing past AI chat conversations
- Use when user provides conversation content for analysis
- Use when identifying patterns for artifact creation
- Use when extracting reusable knowledge from conversations

## Instructions

### Analysis Process

1. **Read the conversation**: Understand the full context of the conversation
2. **Identify patterns**: Look for recurring instructions, corrections, or workflows
3. **Categorize findings**: Group patterns by type (rule, skill, command, subagent)
4. **Extract key information**: Identify specific patterns and their contexts
5. **Suggest artifacts**: Recommend artifacts to create based on patterns

### Pattern Identification

Look for:
- **Repeated instructions**: Instructions that appear multiple times
- **Correction patterns**: When user corrects AI behavior
- **Workflow patterns**: Sequences of actions that recur
- **Context patterns**: Contexts where certain patterns apply

### Categorization

For each pattern identified:
- **Determine artifact type**: Rule, Skill, Command, Subagent, or **Cursor hooks** (when behavior should run in the agent loop)
- **Assess frequency**: How often the pattern appears
- **Evaluate significance**: Is it worth creating an artifact (or hook config)?
- **Suggest organization**: Where should the artifact be placed? For hooks: `.cursor/hooks.json` and `.cursor/hooks/` scripts (project) or user config

**Consider Cursor hooks** when the pattern involves:
- Gating or allowing specific agent actions (e.g. blocking shell commands, file reads, or MCP calls)
- Running something automatically after every file edit (e.g. format, lint)
- Auditing or logging agent behavior (shell, MCP, tool use)
- Injecting context or env at session start
- Different policy for Tab vs Agent (e.g. redact secrets for Tab only)

When hooks might apply, note the relevant hook event(s) (e.g. `beforeShellExecution`, `afterFileEdit`) and suggest command-based vs prompt-based. See [Cursor Hooks](docs/research/cursor-hooks.md) for when to use hooks and which events exist.

### Output Format

For each pattern, provide:
- **Pattern description**: What the pattern is
- **Frequency**: How often it appears
- **Artifact type**: Recommended type (rule/skill/command/subagent) or **hooks** (with suggested hook event(s))
- **Suggested name**: Following naming conventions (for hooks: script name or hook event name)
- **Suggested location**: Category and path (for hooks: `.cursor/hooks.json` and e.g. `.cursor/hooks/script.sh`)
- **Content outline**: Key points to include (for hooks: which event, command vs prompt, matcher if applicable)

## Examples

### Example 1: Repeated Instruction Pattern

**Conversation excerpt**: User repeatedly asks to "always use TypeScript strict mode"

**Analysis**:
- Pattern: TypeScript strict mode preference
- Frequency: Appears 5+ times
- Artifact type: Rule
- Suggested name: `typescript-strict-mode`
- Suggested location: `cursor/rules/organization/typescript-strict-mode.mdc`
- Content: Rule enforcing TypeScript strict mode usage

### Example 2: Workflow Pattern

**Conversation excerpt**: User repeatedly follows same steps for code review

**Analysis**:
- Pattern: Code review workflow
- Frequency: Appears 3+ times
- Artifact type: Command
- Suggested name: `code-review-checklist`
- Suggested location: `cursor/commands/meta/code-review-checklist.md`
- Content: Step-by-step code review checklist

## Best Practices

- Focus on high-frequency patterns
- Validate pattern significance
- Consider context and conditions
- Document pattern rationale
- Suggest appropriate artifact type

## Related Artifacts

- [Pattern Extraction Skill](.cursor/skills/meta/pattern-extraction/SKILL.md)
- [Artifact Creation Skill](.cursor/skills/meta/artifact-creation/SKILL.md)
- [Process Chat Command](.cursor/commands/meta/process-chat.md)
- [Conversation Analyzer Subagent](.cursor/agents/meta/conversation-analyzer.md)
- [Cursor Hooks](docs/research/cursor-hooks.md) – When to recommend hooks when processing transcripts
- [AI Agent Patterns](docs/research/ai-agent-patterns.md)
