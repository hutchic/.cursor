# Command Template

This template provides a starting point for creating Cursor Commands. Copy this template and customize it for your specific command.

## File Location

Commands are stored as Markdown files in `.cursor/commands/` or subdirectories:
- `.cursor/commands/your-command.md`
- `.cursor/commands/category/your-command.md`

## Command Template

```markdown
# Command Name

## Overview

Brief description of what this command does and when to use it.

## When to Use

- Use this command when...
- This command is helpful for...
- Context where this command applies...

## Steps

1. **First Step**: Description of first step
   - Sub-step or detail
   - Another detail

2. **Second Step**: Description of second step
   - Sub-step or detail

3. **Third Step**: Description of third step

## Checklist

- [ ] First item to check or verify
- [ ] Second item to check or verify
- [ ] Third item to check or verify

## Examples

### Example 1: Basic Usage

Description of basic usage scenario.

### Example 2: Advanced Usage

Description of advanced usage scenario.

## Parameters

This command accepts parameters. Anything typed after the command name is included in the prompt:

```
/command-name with these parameters
```

## Related Artifacts

- [Related Rule](.cursor/rules/category/related-rule.mdc)
- [Related Skill](.cursor/skills/category/related-skill/SKILL.md)
- [Related Command](.cursor/commands/category/related-command.md)
- [Related Subagent](.cursor/agents/category/related-subagent.md)
- [Documentation](docs/cursor-commands.md)

## Notes

- Additional context or considerations
- Edge cases or exceptions
- Future improvements
```

## Best Practices

1. **Descriptive name**: Use kebab-case, be specific
2. **Clear structure**: Overview, Steps, Checklist sections
3. **Be actionable**: Provide concrete steps, not vague guidance
4. **Use markdown**: Headers, lists, formatting for readability
5. **Add cross-references**: Link to related artifacts
6. **Test the command**: Verify it works as expected

## See Also

- [Cursor Commands Documentation](docs/cursor-commands.md)
- [Cursor Best Practices](docs/research/cursor-best-practices.md)
- [Organization Guide](docs/organization.md)
