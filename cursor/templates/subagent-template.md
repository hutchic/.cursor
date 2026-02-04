# Subagent Template

This template provides a starting point for creating Cursor Subagents. Copy this template and customize it for your specific subagent.

## File Location

Subagents are stored as Markdown files in `.cursor/agents/` or subdirectories:
- `.cursor/agents/your-subagent.md`
- `.cursor/agents/category/your-subagent.md`

## Subagent Template

```markdown
---
name: your-subagent-name  # Optional: defaults to filename without extension
description: "Specific description of when to use this subagent. Include keywords and context that help the agent decide when to delegate."
model: inherit  # Options: "inherit", "fast", or specific model ID
readonly: false  # Set to true for read-only operations
is_background: false  # Set to true for long-running tasks
---

# Subagent Name

You are a [role/specialist] specializing in [domain/task].

## When Invoked

When this subagent is invoked, you should:

1. **First Action**: Description of first action
   - Detail or sub-action
   - Another detail

2. **Second Action**: Description of second action
   - Detail or sub-action

3. **Third Action**: Description of third action

## Approach

### Primary Approach

- Approach element 1
- Approach element 2
- Approach element 3

### Specific Guidelines

- Guideline 1: Description
- Guideline 2: Description
- Guideline 3: Description

## Expected Output

For each task, provide:

- Output element 1: Description
- Output element 2: Description
- Output element 3: Description

## Examples

### Example Scenario 1

Description of example scenario and expected behavior.

### Example Scenario 2

Description of another example scenario.

## Related Artifacts

- [Related Rule](.cursor/rules/category/related-rule.mdc)
- [Related Skill](.cursor/skills/category/related-skill/SKILL.md)
- [Related Command](.cursor/commands/category/related-command.md)
- [Related Subagent](.cursor/agents/category/related-subagent.md)
- [Documentation](docs/cursor-subagents.md)

## Notes

- Additional context or considerations
- Edge cases or exceptions
- Future improvements
```

## Best Practices

1. **Focused subagent**: Single, clear responsibility
2. **Invest in description**: Determines when agent delegates
3. **Concise prompt**: Be specific and direct, avoid rambling
4. **Clear instructions**: Provide concrete steps and expected outputs
5. **Add cross-references**: Link to related artifacts
6. **Test the subagent**: Verify it works as expected

## Configuration Options

- **model**: `inherit` (use parent model), `fast` (use faster model), or specific model ID
- **readonly**: `true` for read-only operations, `false` for operations that can modify files
- **is_background**: `true` for long-running tasks, `false` for tasks that need immediate results

## See Also

- [Cursor Subagents Documentation](docs/cursor-subagents.md)
- [Cursor Best Practices](docs/research/cursor-best-practices.md)
- [Organization Guide](docs/organization.md)
