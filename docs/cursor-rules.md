# Cursor Rules Documentation

This document explains how Cursor Rules work, what they're good for, and what they're not good for.

## What Are Cursor Rules?

Cursor Rules provide persistent, system-level instructions to the AI Agent. They bundle prompts, scripts, and guidelines together, making it easy to manage and share workflows across your team.

Since large language models don't retain memory between completions, rules provide persistent, reusable context at the prompt level. When applied, rule contents are included at the start of the model context, giving the AI consistent guidance for generating code, interpreting edits, or helping with workflows.

## Types of Rules

Cursor supports four types of rules:

### 1. Project Rules
- **Location**: `.cursor/rules` directory
- **Format**: Markdown files (`.md` or `.mdc`)
- **Scope**: Version-controlled and scoped to your codebase
- **Use case**: Domain-specific knowledge, project workflows, style conventions

### 2. User Rules
- **Location**: Cursor Settings → Rules
- **Scope**: Global to your Cursor environment
- **Use case**: Personal preferences, communication style, coding conventions

### 3. Team Rules
- **Location**: Cursor Dashboard (Team/Enterprise plans)
- **Scope**: Team-wide, enforced across all projects
- **Use case**: Organizational standards, compliance workflows

### 4. AGENTS.md
- **Location**: Project root or subdirectories
- **Format**: Simple markdown file
- **Use case**: Straightforward instructions without structured metadata
- **Standard**: Follows the [AGENTS.md format](https://agents.md/) - an open format used by 60k+ projects
- **Relationship to Cursor Rules**: AGENTS.md is a simpler alternative to Project Rules. It's a plain markdown file without metadata, perfect for projects that need simple, readable instructions. Cursor automatically reads AGENTS.md files in the project root and subdirectories.

## How Rules Work

Rules are applied in this order of precedence:
1. **Team Rules** (highest priority)
2. **Project Rules**
3. **User Rules** (lowest priority)

All applicable rules are merged, with earlier sources taking precedence when guidance conflicts.

### Rule Application Types

Rules can be configured to apply in different ways:

- **Always Apply**: Included in every chat session
- **Apply Intelligently**: Agent decides when it's relevant based on description
- **Apply to Specific Files**: When file matches a specified pattern
- **Apply Manually**: When @-mentioned in chat (e.g., `@my-rule`)

## What Rules Are Good For

### ✅ Domain-Specific Knowledge
Rules excel at encoding knowledge specific to your codebase:
- Business logic patterns
- Domain terminology and concepts
- Architecture decisions and rationale
- Internal APIs and conventions

### ✅ Project-Specific Workflows
Use rules to automate and standardize workflows:
- Code generation templates
- Testing patterns
- Deployment procedures
- Documentation generation

### ✅ Style and Architecture Standards
Rules help maintain consistency:
- Component structure patterns
- API design conventions
- Naming conventions
- File organization standards

### ✅ Team Collaboration
Rules facilitate team alignment:
- Shared coding standards
- Common patterns and practices
- Onboarding new team members
- Reducing repetitive explanations

### ✅ Contextual Guidance
Rules provide context-aware help:
- Framework-specific patterns
- Library usage conventions
- Integration patterns
- Best practices for your stack

## What Rules Are NOT Good For

### ❌ Replacing Linters
**Don't use rules for:**
- Code formatting (use formatters like Prettier, Black)
- Syntax validation (use linters like ESLint, Pylint)
- Style enforcement (use style guides and linters)

**Why:** Linters are more reliable, faster, and catch issues earlier in the development cycle.

### ❌ Documenting Common Tools
**Don't use rules for:**
- Basic command documentation (npm, git, pytest)
- General tool usage
- Standard library documentation

**Why:** The AI already knows common tools. Focus on project-specific knowledge instead.

### ❌ Edge Cases That Rarely Apply
**Don't use rules for:**
- One-off scenarios
- Rare edge cases
- Situations that come up infrequently

**Why:** Rules should focus on patterns you use frequently. Keep them focused and actionable.

### ❌ Copying Entire Codebases
**Don't use rules for:**
- Copying large code blocks
- Duplicating entire files
- Including full implementations

**Why:** Rules should reference files (`@filename.ts`) rather than copying content. This keeps rules short and prevents them from becoming stale as code changes.

### ❌ Overly Vague Guidance
**Don't use rules for:**
- Generic advice without examples
- Abstract principles without concrete application
- Unclear or ambiguous instructions

**Why:** Rules should be specific, actionable, and include concrete examples or file references.

### ❌ Replacing Code Comments
**Don't use rules for:**
- Explaining what code does (use inline comments)
- API documentation (use proper docstrings)
- Function-level documentation

**Why:** Code should be self-documenting. Rules are for higher-level patterns and conventions.

## Best Practices

### Keep Rules Focused
- **Under 500 lines**: Split large rules into multiple, composable rules
- **Single responsibility**: Each rule should address one concern
- **Clear purpose**: The rule's purpose should be obvious from its name and description

### Provide Concrete Examples
- **Reference files**: Use `@filename.ts` to include files in context
- **Show patterns**: Include examples of correct usage
- **Link to examples**: Point to canonical examples in your codebase

### Write Clear Descriptions
- **For "Apply Intelligently"**: Write clear descriptions so the AI can determine relevance
- **Be specific**: Vague descriptions lead to incorrect application
- **Update descriptions**: Keep them current as your codebase evolves

### Organize Rules Logically
- **Use folders**: Group related rules (e.g., `frontend/`, `backend/`)
- **Naming conventions**: Use descriptive, consistent names
- **Document structure**: Consider a README in `.cursor/rules/` explaining the organization

### Version Control Rules
- **Commit to git**: Share rules with your team
- **Review changes**: Treat rule changes like code changes
- **Document updates**: Explain why rules were added or modified

## When to Create a Rule

Create a rule when:
- ✅ You find yourself repeating the same instructions in chat
- ✅ The AI consistently makes the same type of mistake
- ✅ You have project-specific patterns that aren't obvious from code
- ✅ You want to standardize workflows across your team
- ✅ You need to encode domain knowledge that's not in the codebase

**Don't create a rule when:**
- ❌ The guidance is already clear from your code
- ❌ It's a one-time instruction
- ❌ A linter or formatter would be more appropriate
- ❌ The pattern is too vague or abstract

## Rule File Format

### Simple Markdown Rule (`.md`)
```markdown
# My Rule

This rule provides guidance on...

- Use pattern X when doing Y
- Always check Z before W
```

### Rule with Frontmatter (`.mdc`)
```markdown
---
description: "This rule provides standards for frontend components"
alwaysApply: false
globs:
  - "**/*.tsx"
  - "**/*.jsx"
---

# Frontend Component Standards

When working in components directory:
- Always use Tailwind for styling
- Use Framer Motion for animations
- Follow component naming conventions
```

## Examples

### Good Rule: API Validation Standards
```markdown
---
description: "Validation standards for API endpoints"
globs:
  - "**/api/**/*.ts"
---

# API Validation

In API directory:
- Use zod for all validation
- Define return types with zod schemas
- Export types generated from schemas

@api-validation-example.ts
```

### Good Rule: Component Template
```markdown
---
description: "React component structure template"
globs:
  - "**/components/**/*.tsx"
---

# React Component Structure

React components should follow this layout:
- Props interface at top
- Component as named export
- Styles at bottom

@component-template.tsx
```

### Bad Rule: Too Generic
```markdown
# Programming Best Practices

- Write good code
- Use best practices
- Follow conventions
```

**Why it's bad:** Too vague, no concrete guidance, no examples, no file references.

## Summary

**Use Rules For:**
- Project-specific knowledge and patterns
- Team standards and conventions
- Workflow automation and templates
- Domain-specific guidance

**Don't Use Rules For:**
- Code formatting (use linters/formatters)
- Common tool documentation
- Edge cases that rarely apply
- Copying large code blocks
- Vague or abstract guidance

**Remember:** Start simple. Add rules only when you notice the AI making the same mistake repeatedly. Don't over-optimize before you understand your patterns.

## References

- [Official Cursor Rules Documentation](https://cursor.com/docs/context/rules)
- [Cursor Commands Documentation](docs/cursor-commands.md) - Related feature for reusable workflows
- [Cursor Skills Documentation](docs/cursor-skills.md) - Related feature for extending AI agents
- [Cursor Subagents Documentation](docs/cursor-subagents.md) - Related feature for specialized AI assistants
- [Meta Processes Guide](docs/meta-processes.md) - Self-improvement processes for managing rules
- [Organization Guide](docs/organization.md) - How rules are organized in this repository
- [AGENTS.md Format](https://agents.md/) - Open format for agent instructions
- [AGENTS.md in this project](AGENTS.md) - Agent instructions for this repository
- [Cursor Rules in this project](.cursor/rules/)
