# Cursor Commands Documentation

This document explains how Cursor Commands work, how to create them, and best practices for using them.

## What Are Cursor Commands?

Cursor Commands are custom workflows that can be triggered with a simple `/` prefix in the chat input box. They allow you to create reusable, standardized processes that make common tasks more efficient and help standardize workflows across your team.

Commands are defined as plain Markdown files that describe what the command should do. When you type `/` in the chat input, Cursor automatically detects and displays available commands, making them instantly accessible.

<Info>
Commands are currently in beta. The feature and syntax may change as we continue to improve it.
</Info>

## How Commands Work

### Command Locations

Commands can be stored in three locations, with the following priority order:

1. **Project commands**: Stored in `.cursor/commands` directory of your project
   - Version-controlled with your codebase
   - Shared with all team members
   - Project-specific workflows

2. **Global commands**: Stored in `~/.cursor/commands` directory in your home directory
   - Available across all projects
   - Personal to your machine
   - Useful for general-purpose workflows

3. **Team commands**: Created by team admins in the [Cursor Dashboard](https://cursor.com/dashboard?tab=team-content&section=commands)
   - Automatically available to all team members
   - Server-enforced and synchronized
   - Requires Team or Enterprise plan
   - Centralized management by admins

### Command Detection

When you type `/` in the chat input box, Cursor automatically:
- Scans all three command locations
- Displays available commands in a dropdown
- Makes them instantly accessible across your workflow
- Shows commands from all locations together

## Creating Commands

### Basic Setup

1. **Create the commands directory** (if it doesn't exist):
   ```bash
   mkdir -p .cursor/commands
   ```

2. **Add a Markdown file** with a descriptive name:
   ```bash
   touch .cursor/commands/my-command.md
   ```

3. **Write plain Markdown content** describing what the command should do

4. **Commands automatically appear** when you type `/` in chat

### Command File Structure

Commands are simple Markdown files. Here's the basic structure:

```markdown
# Command Name

## Overview
Brief description of what this command does.

## Steps
1. First step or instruction
2. Second step or instruction
3. Third step or instruction

## Checklist
- [ ] Item to check
- [ ] Another item to check
```

### Example Command

Here's an example of a code review checklist command:

```markdown
# Code Review Checklist

## Overview
Comprehensive checklist for conducting thorough code reviews to ensure quality, security, and maintainability.

## Review Categories

### Functionality
- [ ] Code does what it's supposed to do
- [ ] Edge cases are handled
- [ ] Error handling is appropriate
- [ ] No obvious bugs or logic errors

### Code Quality
- [ ] Code is readable and well-structured
- [ ] Functions are small and focused
- [ ] Variable names are descriptive
- [ ] No code duplication
- [ ] Follows project conventions

### Security
- [ ] No obvious security vulnerabilities
- [ ] Input validation is present
- [ ] Sensitive data is handled properly
- [ ] No hardcoded secrets
```

## Command Parameters

You can provide additional context to a command in the Agent chat input. Anything you type after the command name is included in the model prompt alongside your provided input.

**Example:**
```
/commit and /pr these changes to address DX-523
```

The text "these changes to address DX-523" will be passed as context to the command, allowing the AI to understand the specific task you want to accomplish.

## Team Commands

<Info>
Team commands are available on Team and Enterprise plans.
</Info>

Team admins can create server-enforced custom commands that are automatically available to all team members. This makes it easy to share standardized prompts and workflows across your entire organization.

### Creating Team Commands

1. Navigate to the [Team Content dashboard](https://cursor.com/dashboard?tab=team-content&section=commands)
2. Click to create a new command
3. Provide:
   - **Name**: The command name that will appear after the `/` prefix
   - **Description** (optional): Helpful context about what the command does
   - **Content**: The Markdown content that defines the command's behavior
4. Save the command

Once created, team commands are immediately available to all team members when they type `/` in the chat input box. Team members don't need to manually sync or download anything - the commands are automatically synchronized.

### Benefits of Team Commands

- **Centralized management**: Update commands once and changes are instantly available to all team members
- **Standardization**: Ensure everyone uses consistent workflows and best practices
- **Easy sharing**: No need to distribute files or coordinate updates across the team
- **Access control**: Only team admins can create and modify team commands

## Common Command Patterns

### Code Review Commands

Commands for standardizing code review processes:

```markdown
# Code Review Checklist

## Overview
Comprehensive checklist for conducting thorough code reviews.

## Review Categories
### Functionality
- [ ] Code does what it's supposed to do
- [ ] Edge cases are handled
- [ ] Error handling is appropriate

### Code Quality
- [ ] Code is readable and well-structured
- [ ] Follows project conventions
```

### Security Audit Commands

Commands for security reviews:

```markdown
# Security Audit

## Overview
Comprehensive security review to identify and fix vulnerabilities.

## Steps
1. **Dependency audit**
   - Check for known vulnerabilities
   - Update outdated packages

2. **Code security review**
   - Check for common vulnerabilities
   - Review authentication/authorization

## Security Checklist
- [ ] Dependencies updated and secure
- [ ] No hardcoded secrets
- [ ] Input validation implemented
```

### Feature Setup Commands

Commands for setting up new features:

```markdown
# Setup New Feature

## Overview
Systematically set up a new feature from initial planning through to implementation.

## Steps
1. **Define requirements**
   - Clarify feature scope and goals
   - Identify user stories

2. **Create feature branch**
   - Branch from main/develop
   - Set up local development environment
```

### Testing Commands

Commands for running and fixing tests:

```markdown
# Run All Tests and Fix Failures

## Overview
Execute the full test suite and systematically fix any failures.

## Steps
1. **Run test suite**
   - Execute all tests in the project
   - Capture output and identify failures

2. **Analyze failures**
   - Categorize by type
   - Prioritize fixes based on impact
```

## Best Practices

### Naming Commands

- **Use descriptive names**: `code-review-checklist.md` not `review.md`
- **Use kebab-case**: Consistent with file naming conventions
- **Be specific**: `security-audit.md` not `audit.md`
- **Keep names short**: Easy to type and remember

### Command Content

- **Be clear and specific**: Provide concrete steps, not vague guidance
- **Use checklists**: Help users track progress
- **Include context**: Explain why steps are important
- **Keep it focused**: One command should do one thing well
- **Use markdown formatting**: Headers, lists, and formatting make commands readable

### Organization

- **Group related commands**: Use consistent naming patterns
- **Document complex commands**: Add comments or explanations
- **Version control commands**: Commit project commands to git
- **Share with team**: Project commands are automatically shared

### When to Create a Command

Create a command when:
- ✅ You find yourself repeating the same instructions in chat
- ✅ You have a standardized workflow that multiple people use
- ✅ You want to ensure consistent processes across the team
- ✅ You have a checklist or procedure that's used frequently

**Don't create a command when:**
- ❌ The task is a one-time thing
- ❌ The instructions are too vague or context-dependent
- ❌ A script or tool would be more appropriate

## Command Examples

### Example 1: Pull Request Creation

```markdown
# Create PR

## Overview
Create a well-structured pull request with proper description, labels, and reviewers.

## Steps
1. **Prepare branch**
   - Ensure all changes are committed
   - Push branch to remote
   - Verify branch is up to date with main

2. **Write PR description**
   - Summarize changes clearly
   - Include context and motivation
   - List any breaking changes

3. **Set up PR**
   - Create PR with descriptive title
   - Add appropriate labels
   - Assign reviewers
```

### Example 2: Developer Onboarding

```markdown
# Onboard New Developer

## Overview
Comprehensive onboarding process to get a new developer up and running quickly.

## Steps
1. **Environment setup**
   - Install required tools
   - Set up development environment
   - Configure editor and extensions

2. **Project familiarization**
   - Review project structure
   - Understand architecture
   - Read key documentation

## Onboarding Checklist
- [ ] Development environment ready
- [ ] All tests passing
- [ ] Can run application locally
- [ ] First PR submitted
```

## Commands vs Rules vs Skills vs Subagents

Understanding when to use each:

| Feature | Commands | Rules | Skills | Subagents |
|---------|----------|-------|--------|-----------|
| **Purpose** | Reusable workflows | Persistent AI instructions | Domain-specific knowledge + scripts | Specialized AI assistants |
| **Trigger** | Manual (`/command`) | Automatic (based on context/metadata) | Automatic (context-based) or manual (`/skill-name`) | Automatic (context-based) or manual (`/name`) |
| **Format** | Markdown files | Markdown with metadata | Folder with `SKILL.md` + optional scripts | Markdown with YAML frontmatter |
| **Location** | `.cursor/commands/` | `.cursor/rules/` | `.cursor/skills/` | `.cursor/agents/` |
| **Context** | Shared context | Shared context | Shared context | Own context window |
| **Scripts** | ❌ Instructions only | ❌ Instructions only | ✅ Can include executable scripts | ❌ Instructions only |
| **Parallel** | ❌ No | ❌ No | ❌ No | ✅ Yes |
| **Use case** | Checklists, workflows | Code patterns, conventions | Domain knowledge + automation | Complex tasks needing isolation |

See [Cursor Skills Documentation](docs/cursor-skills.md) and [Cursor Subagents Documentation](docs/cursor-subagents.md) for more details.

**Use Commands for:**
- Checklists and step-by-step workflows
- Processes that need to be triggered manually
- Tasks that benefit from structured guidance

**Use Rules for:**
- Code generation patterns
- Style and architecture standards
- Persistent AI guidance

**Use Skills for:**
- Domain-specific knowledge
- Reusable patterns and examples
- Context that should be available automatically

## Troubleshooting

### Commands Not Appearing

1. **Check directory structure**: Ensure `.cursor/commands/` exists
2. **Verify file format**: Commands must be `.md` files
3. **Check file permissions**: Ensure files are readable
4. **Restart Cursor**: Sometimes a restart is needed to detect new commands
5. **Check location**: Verify commands are in the correct directory

### Command Not Working as Expected

1. **Review command content**: Ensure Markdown is properly formatted
2. **Check for typos**: Verify command name matches filename
3. **Test with simple command**: Start with a basic example
4. **Check Cursor version**: Ensure you're using a version that supports commands

### Team Commands Not Syncing

1. **Verify plan**: Team commands require Team or Enterprise plan
2. **Check admin access**: Only admins can create team commands
3. **Verify dashboard**: Commands should appear in Team Content dashboard
4. **Contact support**: If issues persist, contact Cursor support

## References

- [Official Cursor Commands Documentation](https://cursor.com/docs/context/commands)
- [Cursor Rules Documentation](docs/cursor-rules.md) - Related feature for persistent AI instructions
- [Cursor Skills Documentation](docs/cursor-skills.md) - Related feature for domain-specific knowledge
- [Cursor Subagents Documentation](docs/cursor-subagents.md) - Related feature for specialized AI assistants
- [Meta Processes Guide](docs/meta-processes.md) - Self-improvement processes including meta commands
- [Organization Guide](docs/organization.md) - How commands are organized in this repository
- [AGENTS.md](AGENTS.md) - Agent instructions for this repository
- [Commands in this project](.cursor/commands/) - Project-specific commands
