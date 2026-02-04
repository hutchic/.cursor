# Meta Processes Guide

This guide explains the meta processes for self-improvement in this repository. Learn how to use rules, skills, commands, and subagents to maintain and improve the system.

## Overview

This repository uses meta processes to analyze AI conversations, extract patterns, create artifacts, and maintain organization. The system can improve itself by learning from interactions and creating appropriate artifacts.

## Meta Artifacts

### Meta Rules

Rules that guide the self-improvement process:

- **[Organization Rule](.cursor/rules/meta/organization.mdc)**: Categorization, naming, and structure standards
- **[Cross-Referencing Rule](.cursor/rules/meta/cross-referencing.mdc)**: Reference standards and maintenance
- **[Documentation Rule](.cursor/rules/meta/documentation.mdc)**: Documentation standards
- **[Artifact Creation Rule](.cursor/rules/meta/artifact-creation.mdc)**: Decision framework for creating artifacts
- **[Automation Decomposition Rule](.cursor/rules/meta/automation-decomposition.mdc)**: Decompose automations into discrete skills, then package into commands

### Meta Skills

Skills that help analyze and create:

- **[Conversation Analysis](.cursor/skills/meta/conversation-analysis/SKILL.md)**: Analyze AI chat conversations
- **[Pattern Extraction](.cursor/skills/meta/pattern-extraction/SKILL.md)**: Extract reusable patterns
- **[Artifact Creation](.cursor/skills/meta/artifact-creation/SKILL.md)**: Guide artifact creation
- **[Cross-Reference Maintenance](.cursor/skills/meta/cross-reference-maintenance/SKILL.md)**: Maintain cross-references

### Meta Commands

Commands for self-improvement workflows:

- **[Process Chat](.cursor/commands/meta/process-chat.md)**: Analyze conversations for patterns
- **[Create Artifact](.cursor/commands/meta/create-artifact.md)**: Interactively create artifacts
- **[Update Cross-References](.cursor/commands/meta/update-cross-references.md)**: Maintain references
- **[Validate Organization](.cursor/commands/meta/validate-organization.md)**: Check structure
- **[Generate Docs Index](.cursor/commands/meta/generate-docs-index.md)**: Create documentation indexes

### Meta Subagents

Subagents for complex meta operations:

- **[Conversation Analyzer](.cursor/agents/meta/conversation-analyzer.md)**: Analyze conversations in isolation
- **[Artifact Creator](.cursor/agents/meta/artifact-creator.md)**: Create artifacts from patterns
- **[Cross-Reference Maintainer](.cursor/agents/meta/cross-reference-maintainer.md)**: Maintain references
- **[Documentation Updater](.cursor/agents/meta/documentation-updater.md)**: Update documentation

## How to Use Meta Processes

### Analyzing Conversations

1. **Use Process Chat command**: `/process-chat` with conversation content
2. **Or use Conversation Analyzer subagent**: `/conversation-analyzer` for isolated analysis
3. **Review suggestions**: Check artifact recommendations
4. **Create artifacts**: Use suggested artifacts or create manually

### Creating Artifacts

1. **Use Create Artifact command**: `/create-artifact` with pattern description
2. **Or use Artifact Creator subagent**: `/artifact-creator` for guided creation
3. **Follow templates**: Use appropriate template for artifact type
4. **Add cross-references**: Link to related artifacts
5. **Update documentation**: Add to relevant docs

### Maintaining References

1. **Use Update Cross-References command**: `/update-cross-references` to scan and fix
2. **Or use Cross-Reference Maintainer subagent**: `/cross-reference-maintainer` for comprehensive maintenance
3. **Validate regularly**: Check reference integrity periodically

### Updating Documentation

1. **Use Generate Docs Index command**: `/generate-docs-index` to create/update indexes
2. **Or use Documentation Updater subagent**: `/documentation-updater` for comprehensive updates
3. **Keep in sync**: Update docs when artifacts change

## Self-Improvement Workflow

See [Self-Improvement Workflow](docs/self-improvement-workflow.md) for detailed step-by-step process.

## Best Practices

1. **Use templates**: Always use templates for consistency
2. **Follow standards**: Adhere to naming and organization standards
3. **Add cross-references**: Include references from the start
4. **Update documentation**: Keep docs in sync with artifacts
5. **Validate regularly**: Check structure and references periodically

## Examples

### Example 1: Processing a Conversation

```
/process-chat

[Paste conversation here]

The system will:
1. Analyze the conversation
2. Identify patterns
3. Suggest artifacts to create
4. Guide through creation process
```

### Example 2: Creating an Artifact

```
/create-artifact create a rule for TypeScript strict mode

The system will:
1. Use rule template
2. Guide through structure
3. Help add content
4. Add cross-references
5. Update documentation
```

## Related Documentation

- [Self-Improvement Workflow](docs/self-improvement-workflow.md)
- [Organization Guide](docs/organization.md)
- [Cursor Best Practices](docs/research/cursor-best-practices.md)
- [AI Agent Patterns](docs/research/ai-agent-patterns.md)
- [Skills/Commands Patterns](docs/research/skills-commands-patterns.md)
