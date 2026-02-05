# Common Workflows

## Test-Driven Development

Agent can write code, run tests, and iterate automatically:

1. **Ask agent to write tests** based on expected input/output pairs. Be explicit that you're doing TDD so it avoids creating mock implementations for functionality that doesn't exist yet.
2. **Tell agent to run the tests and confirm they fail.** Explicitly say not to write implementation code at this stage.
3. **Commit the tests** when you're satisfied with them.
4. **Ask agent to write code that passes the tests**, instructing it not to modify the tests. Tell it to keep iterating until all tests pass.
5. **Commit the implementation** once you're satisfied with the changes.

Agents perform best when they have a clear target to iterate against. Tests allow agent to make changes, evaluate results, and incrementally improve until it succeeds.

## Codebase Understanding

When onboarding to a new codebase, use agent for learning and exploration. Ask the same questions you would ask a teammate:

- "How does logging work in this project?"
- "How do I add a new API endpoint?"
- "What edge cases does `CustomerOnboardingFlow` handle?"
- "Why are we calling `setUser()` instead of `createUser()` on line 1738?"

Agent uses both `grep` and semantic search to look through codebase and find answers. This is one of the fastest ways to ramp up on unfamiliar code.

## Git Workflows

Agents can search git history, resolve merge conflicts, and automate your git workflow.

### Creating Commands

Commands are ideal for workflows you run many times per day. Store them as Markdown files in the appropriate commands directory (e.g., `.cursor/commands/`, `.claude/commands/`) and check them into git so your whole team can use them.

### Example: Create PR Command

```markdown
Create a pull request for the current changes.

1. Look at the staged and unstaged changes with `git diff`
2. Write a clear commit message based on what changed
3. Commit and push to the current branch
4. Use `gh pr create` to open a pull request with title/description
5. Return the PR URL when done
```

### Other Command Examples

- `/fix-issue [number]`: Fetch issue details with `gh issue view`, find relevant code, implement a fix, and open a PR
- `/review`: Run linters, check for common issues, and summarize what might need attention
- `/update-deps`: Check for outdated dependencies and update them one by one, running tests after each

Agent can use these commands autonomously, so you can delegate multi-step workflows with a single `/` invocation.
