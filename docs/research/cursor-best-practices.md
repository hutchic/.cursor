# Cursor IDE Best Practices Research

This document compiles best practices for using Cursor Rules, Skills, Commands, and Subagents based on official documentation and community patterns.

## Rules Best Practices

### When to Use Rules

**Use Rules For:**
- Domain-specific knowledge that should persist across sessions
- Project-specific workflows and patterns
- Style and architecture standards
- Team collaboration and shared conventions
- Contextual guidance based on file patterns

**Don't Use Rules For:**
- Code formatting (use linters/formatters)
- Common tool documentation (AI already knows)
- Edge cases that rarely apply
- Copying entire codebases (reference files instead)
- Vague or abstract guidance

### Rule Structure Best Practices

1. **Keep rules focused**: Under 500 lines, split large rules into composable pieces
2. **Use clear descriptions**: For "Apply Intelligently", descriptions determine relevance
3. **Reference files**: Use `@filename.ts` instead of copying code
4. **Organize logically**: Use folders for related rules (e.g., `frontend/`, `backend/`)
5. **Version control**: Commit rules to git for team sharing

### Rule Application Types

- **Always Apply**: For fundamental standards that should always be present
- **Apply Intelligently**: For context-aware rules (requires good description)
- **Apply to Specific Files**: Use `globs` patterns for file-specific rules
- **Apply Manually**: For rules invoked with `@rule-name`

### Frontmatter Best Practices

```yaml
---
description: "Clear, specific description of when this rule applies"
alwaysApply: false  # or true
globs:
  - "**/*.tsx"
  - "**/*.jsx"
---
```

## Skills Best Practices

### When to Use Skills

**Use Skills For:**
- Domain-specific knowledge with executable scripts
- Workflows that include automation
- Complex procedures needing structured guidance
- Knowledge that should be available across projects
- Tasks that benefit from automatic detection

**Don't Use Skills For:**
- Simple one-time procedures
- Tasks that don't need scripts
- Knowledge already clear from code
- Vague or context-dependent instructions

### Skill Structure Best Practices

1. **Progressive loading**: Keep `SKILL.md` focused, move details to `references/`
2. **Clear descriptions**: Help agent determine relevance
3. **Use scripts directory**: For executable code that agents can run
4. **Self-contained scripts**: Include error handling and helpful messages
5. **Naming**: Use lowercase with hyphens, match folder name

### Skill Frontmatter Best Practices

```yaml
---
name: my-skill  # Must match folder name
description: "Specific description of what this skill does and when to use it"
license: MIT  # Optional
compatibility: "Requires Node.js 18+"  # Optional
disable-model-invocation: false  # Set to true for manual-only skills
---
```

### Skill Organization

- Use folders for each skill: `.cursor/skills/my-skill/SKILL.md`
- Optional directories: `scripts/`, `references/`, `assets/`
- Keep main `SKILL.md` concise, move details to `references/`

## Commands Best Practices

### When to Use Commands

**Use Commands For:**
- Checklists and step-by-step workflows
- Processes that need manual triggering
- Tasks that benefit from structured guidance
- Standardized workflows across team

**Don't Use Commands For:**
- One-time tasks
- Tasks that need context isolation (use subagents)
- Tasks that need scripts (use skills)
- Vague or context-dependent instructions

### Command Structure Best Practices

1. **Descriptive names**: Use kebab-case, be specific
2. **Clear structure**: Overview, Steps, Checklist sections
3. **Be actionable**: Provide concrete steps, not vague guidance
4. **Use markdown**: Headers, lists, formatting for readability
5. **Version control**: Commit commands to git

### Command Content Best Practices

```markdown
# Command Name

## Overview
Brief description of what this command does.

## Steps
1. First actionable step
2. Second actionable step
3. Third actionable step

## Checklist
- [ ] Item to verify
- [ ] Another item to verify
```

### Command Parameters

Commands can accept parameters - anything typed after the command name is included in the prompt:
```
/process-chat analyze this conversation for patterns
```

## Subagents Best Practices

### When to Use Subagents

**Use Subagents For:**
- Complex tasks needing context isolation
- Long-running research or exploration
- Parallel workstreams
- Independent verification of work
- Tasks requiring specialized expertise across many steps

**Don't Use Subagents For:**
- Simple, single-purpose tasks (use skills/commands)
- Quick, repeatable actions
- Tasks that complete in one shot
- Tasks that don't need separate context window

### Subagent Structure Best Practices

1. **Focused subagents**: Single, clear responsibility
2. **Invest in descriptions**: Determines when agent delegates
3. **Concise prompts**: Be specific and direct
4. **Version control**: Commit to git for team sharing
5. **Start simple**: 2-3 focused subagents, add more as needed

### Subagent Frontmatter Best Practices

```yaml
---
name: my-subagent  # Optional, defaults to filename
description: "Specific description of when to use this subagent"
model: inherit  # or "fast" or specific model ID
readonly: false  # Set to true for read-only operations
is_background: false  # Set to true for long-running tasks
---
```

### Subagent Prompt Best Practices

- Be specific about what the subagent should do
- Include concrete steps and expected outputs
- Focus on actions, not philosophy
- Keep prompts concise (avoid 2000+ word prompts)

### Anti-patterns to Avoid

- **Vague descriptions**: "Use for general tasks" gives no signal
- **Overly long prompts**: Doesn't make subagent smarter, makes it slower
- **Too many subagents**: Start with 2-3, add only when needed
- **Duplicating commands**: If single-purpose, use command instead

## Organization Best Practices

### Directory Structure

**Recommended structure:**
```
.cursor/
├── rules/
│   ├── meta/           # Meta rules
│   ├── frontend/       # Frontend-specific
│   └── backend/        # Backend-specific
├── skills/
│   ├── meta/           # Meta skills
│   └── deployment/     # Deployment skills
├── commands/
│   ├── meta/           # Meta commands
│   └── review/         # Review commands
└── agents/
    └── meta/           # Meta subagents
```

### Naming Conventions

- **Rules**: `kebab-case.mdc` or `kebab-case.md`
- **Skills**: `kebab-case/` folder with `SKILL.md`
- **Commands**: `kebab-case.md`
- **Subagents**: `kebab-case.md`
- Use descriptive names, avoid abbreviations

### Categorization

- Group related artifacts in subdirectories
- Use consistent naming patterns
- Document structure in README
- Keep categories focused and meaningful

## Cross-Referencing Best Practices

### When to Cross-Reference

- Related artifacts (rule references skill, skill references command)
- Documentation links (artifacts link to docs, docs link to artifacts)
- Examples and templates
- Related concepts and patterns

### How to Cross-Reference

- Use relative paths: `[Link Text](docs/cursor-rules.md)`
- Use file references: `@filename.ts` in rules
- Maintain reference integrity
- Update references when files move

## Documentation Best Practices

### Keep Documentation in Sync

- Update docs when artifacts change
- Document new artifacts immediately
- Keep examples current
- Maintain cross-references

### Documentation Structure

- Clear headings and hierarchy
- Examples for each artifact type
- Best practices sections
- Troubleshooting guides

## Performance and Cost Considerations

### Rules
- Rules are included in context, keep them focused
- Split large rules to reduce token usage
- Use "Apply Intelligently" to reduce unnecessary context

### Skills
- Progressive loading reduces context usage
- Keep `SKILL.md` focused, move details to `references/`
- Scripts run independently, don't consume context

### Commands
- Commands are invoked manually, no automatic context cost
- Keep commands concise and actionable

### Subagents
- Each subagent has its own context window
- Running multiple subagents in parallel increases token usage
- Use `model: fast` for cost efficiency when appropriate
- Background subagents don't block main conversation

## Team Collaboration Best Practices

### Version Control

- Commit all artifacts to git
- Review changes like code changes
- Document why artifacts were added/modified

### Sharing

- Project-level artifacts are automatically shared
- Use team commands for organization-wide sharing
- Document artifacts for team understanding

### Maintenance

- Regularly review and update artifacts
- Remove obsolete artifacts
- Consolidate duplicate artifacts
- Keep artifacts focused and useful

## References

- [Official Cursor Rules Documentation](https://cursor.com/docs/context/rules)
- [Official Cursor Commands Documentation](https://cursor.com/docs/context/commands)
- [Official Cursor Skills Documentation](https://cursor.com/docs/context/skills)
- [Official Cursor Subagents Documentation](https://cursor.com/docs/context/subagents)
- [AGENTS.md Format](https://agents.md/)
