# Extending the Agent

Agent harnesses typically provide two main ways to customize agent behavior: **Rules** for static context and **Skills** for dynamic capabilities.

## Rules: Static Context

Rules provide persistent instructions that shape how agent works with your code. Think of them as always-on context that agent sees at the start of every conversation.

### Creating Rules

Create rules as markdown files in the appropriate rules directory (e.g., `.cursor/rules/`, `.claude/rules/`, `.codex/rules/`):

```markdown
# Commands

- `npm run build`: Build the project
- `npm run typecheck`: Run the typechecker
- `npm run test`: Run tests (prefer single test files for speed)

# Code style

- Use ES modules (import/export), not CommonJS (require)
- Destructure imports when possible: `import { foo } from 'bar'`
- See `components/Button.tsx` for canonical component structure

# Workflow

- Always typecheck after making a series of code changes
- API routes go in `app/api/` following existing patterns
```

### Best Practices for Rules

- Keep rules focused on essentials
- Reference files instead of copying contents
- Keep rules short to prevent them from becoming stale
- Start simple, add rules only when agent makes same mistake repeatedly

### What to Avoid in Rules

- Copying entire style guides (use a linter instead)
- Documenting every possible command (agent knows common tools)
- Adding instructions for edge cases that rarely apply

## Skills: Dynamic Capabilities

Agent Skills extend what agents can do. Skills package domain-specific knowledge, workflows, and scripts that agents can invoke when relevant.

### Skills Include

- **Custom commands**: Reusable workflows triggered with `/` in agent input
- **Hooks**: Scripts that run before or after agent actions
- **Domain knowledge**: Instructions for specific tasks agent can pull in on demand

### Skills vs Rules

- **Rules**: Always included, static context
- **Skills**: Loaded dynamically when agent decides they're relevant
- Skills keep context window clean while giving agent access to specialized capabilities

## AGENTS.md

Simple markdown file for defining agent instructions. Place in project root or subdirectories as alternative to rules directories for straightforward use cases.

- Plain markdown without metadata
- Perfect for simple, readable instructions
- Supports nested AGENTS.md files in subdirectories
