---
name: pattern-extraction
description: "Extract reusable patterns from conversations and code. Identify patterns, determine artifact type, and suggest organization location. Use when analyzing content to find patterns for artifact creation."
---

# Pattern Extraction Skill

Extract reusable patterns from conversations and code, determine appropriate artifact types, and suggest organization locations.

## When to Use

- Use when extracting patterns from conversations
- Use when identifying reusable patterns in code
- Use when determining what artifacts to create
- Use when organizing patterns into categories

## Instructions

### Pattern Extraction Process

1. **Identify patterns**: Find recurring themes, instructions, or workflows
2. **Abstract patterns**: Extract generalizable patterns from specific instances
3. **Determine type**: Decide if pattern should be rule, skill, command, or subagent
4. **Suggest location**: Recommend where artifact should be placed
5. **Document pattern**: Document the pattern clearly

### Pattern Types

#### Instruction Patterns

- Repeated instructions or corrections
- User preferences and style choices
- Domain-specific conventions
- Team standards

#### Workflow Patterns

- Common sequences of actions
- Standardized processes
- Multi-step procedures
- Recurring task flows

#### Error Patterns

- Systematic errors and corrections
- Common mistakes and fixes
- Prevention strategies
- Error handling approaches

#### Context Patterns

- Context-specific behaviors
- File-type specific patterns
- Domain-specific knowledge
- Environment-specific configurations

#### Hook Patterns (Cursor agent loop)

- **Gating**: What the agent is allowed or forbidden to do (shell commands, file reads, MCP calls) → `beforeShellExecution`, `beforeReadFile`, `beforeMCPExecution`, etc.
- **Post-edit automation**: Run something after every file edit (format, lint) → `afterFileEdit`, `afterTabFileEdit`
- **Auditing**: Log or observe agent actions → `postToolUse`, `afterShellExecution`, `afterMCPExecution`
- **Session context**: Inject env or context at conversation start → `sessionStart`
- **Tab vs Agent policy**: Different rules for inline Tab vs Agent → Tab-specific hooks (`beforeTabFileRead`, `afterTabFileEdit`)

When a pattern fits hook behavior, suggest **hooks** as the outcome (with event(s) and command-based vs prompt-based). See [Cursor Hooks](docs/research/cursor-hooks.md).

### Artifact Type Determination

Use decision framework:
- **Rule**: Persistent guidance, domain knowledge, standards
- **Skill**: Domain knowledge with scripts, automation needs
- **Command**: Manual workflows, checklists, step-by-step
- **Subagent**: Complex tasks, context isolation, parallel work
- **Hooks**: Behavior that must run automatically in the agent loop (gate, format after edit, audit, inject context)—configure via `.cursor/hooks.json` and scripts

### Organization Suggestions

- **Category selection**: Choose appropriate category (meta, organization, etc.)
- **Naming**: Suggest name following conventions
- **Location**: Recommend full path for artifact
- **Relationships**: Identify related artifacts

## Examples

### Example 1: Instruction Pattern

**Pattern**: "Always use async/await instead of promises"

**Extraction**:
- Type: Rule
- Location: `cursor/rules/organization/async-await.mdc`
- Content: Rule enforcing async/await usage
- Related: JavaScript/TypeScript rules

### Example 2: Workflow Pattern

**Pattern**: Standard code review process with checklist

**Extraction**:
- Type: Command
- Location: `cursor/commands/meta/code-review-checklist.md`
- Content: Step-by-step review checklist
- Related: Review-related artifacts

## Best Practices

- Extract generalizable patterns, not one-off instances
- Consider frequency and significance
- Validate pattern worth creating artifact
- Document pattern clearly
- Suggest appropriate organization

## Related Artifacts

- [Conversation Analysis Skill](.cursor/skills/meta/conversation-analysis/SKILL.md)
- [Artifact Creation Skill](.cursor/skills/meta/artifact-creation/SKILL.md)
- [Artifact Creation Rule](.cursor/rules/meta/artifact-creation.mdc)
- [Cursor Hooks](docs/research/cursor-hooks.md) – When to recommend hooks (agent-loop automation, gating, auditing)
- [Pattern Extraction Research](docs/research/ai-agent-patterns.md)
