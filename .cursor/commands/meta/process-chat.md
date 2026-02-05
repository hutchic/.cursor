# Process Chat Conversation

## Overview

Process an AI chat conversation to analyze patterns, extract reusable knowledge, and suggest artifacts to create. This command guides you through analyzing conversations for self-improvement.

## When to Use

- Use when you have an AI chat conversation to analyze
- Use when extracting patterns from past conversations
- Use when identifying opportunities for artifact creation
- Use when improving the system based on conversation history

## Steps

1. **Provide conversation**: Paste or provide the AI chat conversation to analyze

2. **Analyze patterns**: The system will identify:
   - Repeated instructions or corrections
   - Workflow patterns
   - Domain-specific knowledge
   - Opportunities for standardization
   - **Candidate Cursor hooks**: Behavior that should run in the agent loop (e.g. gate shell/MCP/file reads, run formatters after edits, audit agent actions, inject session context). When applicable, suggest hook event(s) and whether command-based or prompt-based—see [Cursor Hooks](docs/research/cursor-hooks.md).

3. **Review suggestions**: Review the analysis and artifact suggestions:
   - Pattern descriptions
   - Recommended artifact types (rule, skill, command, subagent, or **hooks**)
   - Suggested names and locations (for hooks: `.cursor/hooks.json` and scripts in `.cursor/hooks/`)
   - Content outlines (for hooks: which events, command vs prompt, matchers)

4. **Create artifacts**: For each suggested artifact:
   - Use appropriate template
   - Create artifact with proper structure
   - Add cross-references
   - Update documentation

5. **Validate**: Verify created artifacts:
   - Check structure and formatting
   - Verify cross-references
   - Test artifacts if applicable
   - Ensure documentation is updated

## Checklist

- [ ] Conversation provided and analyzed
- [ ] Patterns identified and categorized
- [ ] Artifact suggestions reviewed
- [ ] Artifacts created using templates
- [ ] Cross-references added
- [ ] Documentation updated
- [ ] Artifacts validated

## Examples

### Example 1: Analyzing Code Review Conversation

**Conversation**: Multiple exchanges about code review process

**Analysis Result**:
- Pattern: Standardized code review checklist
- Artifact: Command
- Name: `code-review-checklist`
- Location: `cursor/commands/meta/code-review-checklist.md`

### Example 2: Analyzing TypeScript Preferences

**Conversation**: Repeated requests for TypeScript strict mode

**Analysis Result**:
- Pattern: TypeScript strict mode enforcement
- Artifact: Rule
- Name: `typescript-strict-mode`
- Location: `cursor/rules/organization/typescript-strict-mode.mdc`

## Parameters

You can provide additional context when invoking this command:

```
/process-chat focus on rules and skills
/process-chat analyze for commands only
/process-chat extract workflow patterns
```

## Related Artifacts

- [Conversation Analysis Skill](.cursor/skills/meta/conversation-analysis/SKILL.md)
- [Pattern Extraction Skill](.cursor/skills/meta/pattern-extraction/SKILL.md)
- [Create Artifact Command](.cursor/commands/meta/create-artifact.md)
- [Conversation Analyzer Subagent](.cursor/agents/meta/conversation-analyzer.md)
- [Cursor Hooks](docs/research/cursor-hooks.md) – When to recommend hooks when processing transcripts
- [Self-Improvement Prompt Template](cursor/templates/self-improvement-prompt.md)
- [Self-Improvement Workflow](docs/self-improvement-workflow.md)

## Notes

- Use the self-improvement prompt template for structured analysis
- Review suggestions before creating artifacts
- **Consider hooks** when patterns involve gating agent actions, post-edit automation, auditing, or session context—see [Cursor Hooks](docs/research/cursor-hooks.md) for when and why to use hooks and prompt-based vs command-based.
- Always use templates for consistency (rules, skills, commands, subagents); hooks are configured via `.cursor/hooks.json` and scripts.
- Update documentation as you create artifacts
- Optional export format for conversation transcripts: `chats/yyyy-mm-dd-description.md`
