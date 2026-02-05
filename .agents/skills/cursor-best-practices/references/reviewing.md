# Reviewing Code

AI-generated code needs review, and agent harnesses provide multiple review options.

## During Generation

Watch the agent work. The diff view shows changes as they happen. If you see agent heading in the wrong direction, press **Escape** to interrupt and redirect.

## Agent Review

After agent finishes, use the review features available in your agent harness. Many provide dedicated review passes where the agent analyzes proposed edits line-by-line and flags potential problems.

For all local changes, compare against your main branch using available review tools.

## Bugbot for Pull Requests

Push to source control to get automated reviews on pull requests. Many platforms provide automated analysis to catch issues early and suggest improvements.

## Architecture Diagrams

For significant changes, ask agent to generate architecture diagrams. Try prompting: "Create a Mermaid diagram showing the data flow for our authentication system, including OAuth providers, session management, and token refresh."

These diagrams are useful for documentation and can reveal architectural issues before code review.

## Review Best Practices

- **Review carefully**: AI-generated code can look right while being subtly wrong
- **Read the diffs**: Don't just trust that it works
- **Test the changes**: Run tests and verify functionality
- **Check edge cases**: Agent might miss edge cases
- **Verify security**: Check for security issues, especially with user input

The faster the agent works, the more important your review process becomes.
