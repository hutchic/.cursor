# Planning with Agents

## Plan Mode

Many agent harnesses support Plan Mode (often activated with `Shift+Tab` or similar). Instead of immediately writing code, the agent will:

1. Research your codebase to find relevant files
2. Ask clarifying questions about your requirements
3. Create a detailed implementation plan with file paths and code references
4. Wait for your approval before building

## Benefits

- Forces clear thinking about what you're building
- Gives agent concrete goals to work toward
- Creates reviewable documentation
- Makes it easy to resume interrupted work

## Using Plans

- Plans open as Markdown files you can edit directly
- Remove unnecessary steps, adjust approach, add context
- Save plans to workspace (e.g., `.cursor/plans/`, `.claude/plans/`)
- Creates documentation for your team

## When to Use Plan Mode

- Complex features requiring multiple files
- Architectural changes
- Large refactorings
- When you want to review approach before implementation

## When to Skip

- Quick changes or fixes
- Tasks you've done many times before
- Simple, single-file changes

## Starting Over from a Plan

If agent builds something that doesn't match what you wanted:

1. Revert the changes
2. Refine the plan to be more specific
3. Run it again

This is often faster than fixing an in-progress agent and produces cleaner results.
