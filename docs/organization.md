# Organization Structure Guide

This guide explains how artifacts are organized in this repository and how to maintain clean, organized structure.

## Directory Structure

### Current Structure

```
cursor/
├── rules/
│   ├── meta/              # Meta rules for system management
│   ├── organization/      # Organization-specific rules
│   └── hello-world.mdc    # Example rule
├── skills/
│   ├── meta/              # Meta skills for system management
│   ├── analysis/          # Analysis and pattern extraction
│   └── hello-world/       # Example skill
├── commands/
│   ├── meta/              # Meta commands for system management
│   └── hello-world.md    # Example command
├── agents/
│   ├── meta/              # Meta subagents for system management
│   └── hello-world.md    # Example subagent
└── templates/            # Reusable templates
```

## Categorization Scheme

### Meta Category

The `meta/` category contains artifacts for system management:
- Self-improvement processes
- Organization and structure
- Cross-referencing
- Documentation maintenance

### When to Create Categories

Create a category when:
- You have 3+ related artifacts
- Artifacts belong to a distinct domain
- Category is likely to grow
- Clear functional boundary exists

### Category Naming

- Use lowercase with hyphens: `code-review`, `deployment`
- Be descriptive: `frontend-components` not `frontend`
- Keep it short: `testing` not `testing-and-quality-assurance`
- Use plural for collections: `commands/` not `command/`

## Naming Conventions

### Rules

- Format: `kebab-case.mdc` or `kebab-case.md`
- Pattern: `domain-topic` or `topic-type`
- Examples: `frontend-components.mdc`, `api-standards.mdc`

### Skills

- Format: `kebab-case/` folder with `SKILL.md`
- Pattern: `action-object` or `domain-action`
- Examples: `analyze-conversations/`, `deploy-application/`
- Name must match folder name in frontmatter

### Commands

- Format: `kebab-case.md`
- Pattern: `action-workflow` or `workflow-type`
- Examples: `code-review-checklist.md`, `setup-project.md`

### Subagents

- Format: `kebab-case.md`
- Pattern: `role` or `action-specialist`
- Examples: `conversation-analyzer.md`, `security-auditor.md`

## File Organization

### Flat vs Categorized

- **Flat**: Good for small collections (<10 items)
- **Categorized**: Better for larger collections (>10 items)
- **Hybrid**: Flat root with categories for specific domains

### Organization Principles

1. **Functional Grouping**: Group by what the artifact does
2. **Domain Grouping**: Group by domain (frontend, backend, DevOps)
3. **Workflow Grouping**: Group by workflow stage (setup, development, testing, deployment)
4. **Meta Category**: Separate meta/system artifacts from domain artifacts

## Maintaining Organization

### Regular Maintenance

- Review structure periodically
- Consolidate duplicates
- Update organization as needed
- Validate structure compliance

### Validation

Use the Validate Organization command:
```
/validate-organization
```

This checks:
- Directory structure compliance
- Naming conventions
- File locations
- Category usage

## Best Practices

1. **Start simple**: Begin with flat structure, add categories as needed
2. **Be consistent**: Use consistent naming and organization
3. **Document structure**: Explain organization in README files
4. **Validate regularly**: Check structure compliance periodically
5. **Refactor when needed**: Adjust structure as repository grows

## Related Artifacts

- [Organization Rule](.cursor/rules/meta/organization.mdc)
- [Validate Organization Command](.cursor/commands/meta/validate-organization.md)
- [Skills/Commands Patterns](docs/research/skills-commands-patterns.md)
