# Skill Template

This template provides a starting point for creating Cursor Skills. Copy this template and customize it for your specific skill.

## Directory Structure

```
.cursor/skills/
└── your-skill-name/
    ├── SKILL.md          # Required: Main skill file
    ├── scripts/          # Optional: Executable scripts
    │   └── script.sh
    ├── references/       # Optional: Additional documentation
    │   └── REFERENCE.md
    └── assets/           # Optional: Static resources
        └── template.json
```

## SKILL.md Template

```markdown
---
name: your-skill-name
description: "Clear description of what this skill does and when to use it. Include keywords that help the agent determine relevance."
license: MIT  # Optional
compatibility: "Requires Node.js 18+"  # Optional
disable-model-invocation: false  # Set to true for manual-only skills
---

# Skill Name

Detailed instructions for the agent on how to use this skill.

## When to Use

- Use this skill when...
- This skill is helpful for...
- Context where this skill applies...

## Instructions

### Overview

Brief overview of what the skill does and how it works.

### Step-by-Step Guidance

1. First step or instruction
2. Second step or instruction
3. Third step or instruction

### Domain-Specific Conventions

- Convention 1: Description
- Convention 2: Description
- Convention 3: Description

### Best Practices

- Best practice 1
- Best practice 2
- Best practice 3

## Scripts

If this skill includes scripts, document them here:

### scripts/script-name.sh

Description of what this script does and when to use it.

Usage: `scripts/script-name.sh <arguments>`

## Examples

### Example 1: Basic Usage

Description of example scenario.

### Example 2: Advanced Usage

Description of advanced scenario.

## Related Artifacts

- [Related Rule](.cursor/rules/category/related-rule.mdc)
- [Related Skill](.cursor/skills/category/related-skill/SKILL.md)
- [Related Command](.cursor/commands/category/related-command.md)
- [Related Subagent](.cursor/agents/category/related-subagent.md)
- [Documentation](docs/cursor-skills.md)

## Notes

- Additional context or considerations
- Edge cases or exceptions
- Future improvements
```

## Best Practices

1. **Clear description**: Help agent determine when skill is relevant
2. **Progressive loading**: Keep SKILL.md focused, move details to references/
3. **Self-contained scripts**: Include error handling and helpful messages
4. **Use relative paths**: Reference scripts from skill root
5. **Add cross-references**: Link to related artifacts
6. **Test scripts**: Ensure scripts work before including

## See Also

- [Cursor Skills Documentation](docs/cursor-skills.md)
- [Cursor Best Practices](docs/research/cursor-best-practices.md)
- [Organization Guide](docs/organization.md)
