# Running Agents in Parallel

Many agent harnesses support running multiple agents in parallel without them interfering with one another. Running multiple models on the same problem and picking the best result significantly improves the final output, especially for harder tasks.

## Worktree Support

Some agent harnesses automatically create and manage git worktrees for parallel agents. Each agent runs in its own worktree with isolated files and changes, so agents can edit, build, and test code without stepping on each other.

To run agents in parallel:
1. Use the parallel execution features in your agent harness
2. When agents finish, review and merge the best changes

## Run Multiple Models at Once

A powerful pattern is running the same prompt across multiple models simultaneously. Compare the results side by side and select the best solution.

This is especially useful for:
- Hard problems where different models might take different approaches
- Comparing code quality across model families
- Finding edge cases one model might miss

## Best Practices

- Configure notifications and sounds so you know when agents finish
- Review all solutions before choosing
- Consider combining best parts from different solutions
- Use for complex problems where multiple approaches are valuable

## When to Use Parallel Agents

- Complex refactorings
- Architectural decisions
- Difficult bugs
- Performance optimizations
- When you want to compare approaches

## When to Use Single Agent

- Simple, straightforward tasks
- Quick fixes
- When you know the approach
- Time-sensitive work
