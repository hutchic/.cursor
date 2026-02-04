# Skills and Commands Organization Patterns Research

This document compiles best practices for organizing and structuring skills and commands, including categorization schemes, naming conventions, and cross-referencing patterns.

## Categorization Schemes

### Hierarchical Organization

**Recommended Structure:**
```
.cursor/
├── skills/
│   ├── meta/              # Meta skills for system management
│   ├── analysis/          # Analysis and pattern extraction
│   ├── deployment/        # Deployment and operations
│   ├── development/       # Development workflows
│   └── testing/           # Testing and quality assurance
├── commands/
│   ├── meta/              # Meta commands for system management
│   ├── review/            # Code review workflows
│   ├── setup/             # Setup and initialization
│   └── maintenance/       # Maintenance tasks
```

### Categorization Principles

1. **Functional Grouping**: Group by what the artifact does
2. **Domain Grouping**: Group by domain (frontend, backend, DevOps)
3. **Workflow Grouping**: Group by workflow stage (setup, development, testing, deployment)
4. **Meta Category**: Separate meta/system artifacts from domain artifacts

### When to Create Categories

- **3+ related artifacts**: Create category when you have 3 or more related items
- **Clear domain boundary**: When artifacts belong to distinct domains
- **Team structure**: Align with team organization if applicable
- **Growth potential**: When category is likely to grow

### Category Naming

- Use lowercase with hyphens: `code-review`, `deployment`
- Be descriptive: `frontend-components` not `frontend`
- Keep it short: `testing` not `testing-and-quality-assurance`
- Use plural for collections: `commands/` not `command/`

## Naming Conventions

### General Naming Rules

1. **Use kebab-case**: `my-skill`, `code-review-command`
2. **Be descriptive**: `deploy-to-staging` not `deploy`
3. **Keep it short**: Under 30 characters when possible
4. **Avoid abbreviations**: `code-review` not `cr`
5. **Use verbs for actions**: `analyze-code`, `deploy-app`

### Skills Naming

- **Format**: `kebab-case/` folder with `SKILL.md`
- **Pattern**: `action-object` or `domain-action`
- **Examples**: 
  - `analyze-conversations/`
  - `deploy-application/`
  - `extract-patterns/`

### Commands Naming

- **Format**: `kebab-case.md`
- **Pattern**: `action-workflow` or `workflow-type`
- **Examples**:
  - `code-review-checklist.md`
  - `setup-project.md`
  - `process-chat.md`

### Rules Naming

- **Format**: `kebab-case.mdc` or `kebab-case.md`
- **Pattern**: `domain-topic` or `topic-type`
- **Examples**:
  - `frontend-components.mdc`
  - `api-standards.mdc`
  - `organization.mdc`

### Subagents Naming

- **Format**: `kebab-case.md`
- **Pattern**: `role` or `action-specialist`
- **Examples**:
  - `conversation-analyzer.md`
  - `security-auditor.md`
  - `test-runner.md`

## Cross-Referencing Patterns

### Reference Types

1. **Artifact-to-Artifact**: Rule references skill, skill references command
2. **Artifact-to-Documentation**: Artifacts link to relevant docs
3. **Documentation-to-Artifact**: Docs link to artifacts
4. **Related Concepts**: Link to related patterns and concepts

### Reference Format

**Markdown Links:**
```markdown
See [Related Skill](.cursor/skills/meta/pattern-extraction/SKILL.md)
See [Documentation](docs/cursor-skills.md)
```

**File References (in Rules):**
```markdown
@example-file.ts
@cursor/rules/organization.mdc
```

### Reference Sections

**Standard Reference Section:**
```markdown
## Related Artifacts

- [Related Rule](.cursor/rules/meta/organization.mdc)
- [Related Skill](.cursor/skills/meta/artifact-creation/SKILL.md)
- [Related Command](.cursor/commands/meta/create-artifact.md)
- [Documentation](docs/meta-processes.md)
```

### Reference Maintenance

1. **Add references when creating**: Include related artifacts
2. **Update when moving**: Update references when files move
3. **Validate periodically**: Check for broken references
4. **Document relationships**: Explain why artifacts are related

## Organization Best Practices

### Directory Structure

**Flat vs Categorized:**
- **Flat**: Good for small collections (<10 items)
- **Categorized**: Better for larger collections (>10 items)
- **Hybrid**: Flat root with categories for specific domains

### File Organization

1. **Group related files**: Keep related artifacts together
2. **Use consistent structure**: Same structure across categories
3. **Document organization**: README in each category explaining purpose
4. **Maintain hierarchy**: Clear parent-child relationships

### Metadata Organization

**Frontmatter Organization:**
```yaml
---
# Identity
name: artifact-name
description: Clear description

# Configuration
model: inherit
alwaysApply: false

# Organization
category: meta
tags: [analysis, patterns]

# References
related:
  - rules/meta/organization.mdc
  - skills/meta/pattern-extraction/SKILL.md
---
```

## Cross-Reference Patterns

### Bidirectional References

- **Forward**: Artifact A references Artifact B
- **Backward**: Artifact B references Artifact A (when relevant)
- **Documentation**: Both link to relevant documentation

### Reference Chains

- **Rule → Skill → Command**: Rule uses skill, skill uses command
- **Documentation → Artifacts**: Docs link to all related artifacts
- **Index → All**: Master index links to everything

### Reference Validation

1. **Check existence**: Verify referenced files exist
2. **Check paths**: Verify paths are correct
3. **Check context**: Verify references make sense
4. **Update on move**: Update when files are moved

## Documentation Patterns

### Artifact Documentation

Each artifact should include:
- **Overview**: What it does
- **When to Use**: When it applies
- **How to Use**: Usage instructions
- **Related**: Links to related artifacts
- **Examples**: Usage examples

### Category Documentation

Each category should have:
- **Purpose**: What the category is for
- **Contents**: List of artifacts in category
- **Usage**: How to use artifacts in category
- **Related Categories**: Links to related categories

### Master Documentation

- **Index**: Complete list of all artifacts
- **Organization Guide**: How artifacts are organized
- **Cross-Reference Map**: Map of relationships
- **Usage Guide**: How to use the system

## Examples from Successful Repositories

### Pattern: Meta Category

Many repositories use a `meta/` category for system management:
- `skills/meta/` - Meta skills
- `commands/meta/` - Meta commands
- `rules/meta/` - Meta rules
- `agents/meta/` - Meta subagents

### Pattern: Domain Categories

Organize by domain when applicable:
- `frontend/` - Frontend-specific artifacts
- `backend/` - Backend-specific artifacts
- `devops/` - DevOps artifacts
- `testing/` - Testing artifacts

### Pattern: Workflow Categories

Organize by workflow stage:
- `setup/` - Initial setup
- `development/` - Development workflows
- `testing/` - Testing workflows
- `deployment/` - Deployment workflows

## Maintenance Patterns

### Regular Maintenance

1. **Review organization**: Periodically review structure
2. **Consolidate duplicates**: Merge similar artifacts
3. **Update references**: Keep references current
4. **Validate structure**: Ensure compliance with standards

### Growth Management

1. **Monitor growth**: Track artifact count per category
2. **Split categories**: Split when category gets too large (>20 items)
3. **Merge categories**: Merge when categories are too small (<3 items)
4. **Refactor structure**: Adjust as needs evolve

## Best Practices Summary

### Organization

- Use categories for 10+ artifacts
- Group by function, domain, or workflow
- Keep categories focused and meaningful
- Document category purpose

### Naming

- Use kebab-case consistently
- Be descriptive but concise
- Follow naming patterns
- Avoid abbreviations

### Cross-Referencing

- Add references when creating artifacts
- Maintain bidirectional links when relevant
- Validate references regularly
- Update on file moves

### Documentation

- Document each artifact
- Document each category
- Maintain master index
- Keep docs in sync

## References

- Repository organization patterns
- Naming convention standards
- Cross-referencing best practices
- Documentation structure patterns
- Maintenance workflows
