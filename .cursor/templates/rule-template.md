# Rule Template

This template provides a starting point for creating Cursor Rules. Copy this template and customize it for your specific rule.

## Frontmatter Structure

```yaml
---
description: "Clear, specific description of when this rule applies and what it does"
alwaysApply: false  # Set to true if rule should always be included
globs:
  - "**/*.tsx"  # Optional: file patterns when rule should apply
  - "**/*.jsx"
---
```

## Rule Content Template

```markdown
---
description: "Your rule description here"
alwaysApply: false
globs:
  - "**/*.pattern"  # Optional: file patterns
---

# Rule Name

Brief overview of what this rule provides guidance on.

## When to Use

- Use this rule when...
- This rule applies to...
- Context where this rule is relevant...

## Guidelines

### Primary Guidelines

- First guideline or pattern
- Second guideline or pattern
- Third guideline or pattern

### Specific Patterns

- Pattern 1: Description
- Pattern 2: Description
- Pattern 3: Description

## Examples

### Good Example

```language
// Example of correct usage
code example here
```

### Bad Example

```language
// Example of incorrect usage
code example here
```

## Related Artifacts

- [Related Rule](.cursor/rules/category/related-rule.mdc)
- [Related Skill](.cursor/skills/category/related-skill/SKILL.md)
- [Related Command](.cursor/commands/category/related-command.md)
- [Documentation](docs/cursor-rules.md)

## Notes

- Additional context or considerations
- Edge cases or exceptions
- Future improvements or considerations
```

## Best Practices

1. **Keep it focused**: Each rule should address one concern
2. **Be specific**: Provide concrete guidance, not vague advice
3. **Use examples**: Show correct and incorrect patterns
4. **Reference files**: Use `@filename.ts` instead of copying code
5. **Add cross-references**: Link to related artifacts and documentation
6. **Keep under 500 lines**: Split large rules into multiple, composable rules

## See Also

- [Cursor Rules Documentation](docs/cursor-rules.md)
- [Cursor Best Practices](docs/research/cursor-best-practices.md)
- [Organization Guide](docs/organization.md)
