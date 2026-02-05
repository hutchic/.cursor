# Cursor Skills Documentation

This document explains how Cursor Skills work, how to create them, and best practices for using them.

## What Are Cursor Skills?

Cursor Skills (Agent Skills) are an open standard for extending AI agents with specialized capabilities. Skills package domain-specific knowledge and workflows that agents can use to perform specific tasks.

Skills are portable, version-controlled packages that teach agents how to perform domain-specific tasks. They can include both instructions and executable scripts or code that agents can run.

### Key Features

- **Portable**: Skills work across any agent that supports the Agent Skills standard
- **Version-controlled**: Skills are stored as files and can be tracked in your repository, or installed via GitHub repository links
- **Executable**: Skills can include scripts and code that agents execute to perform tasks
- **Progressive**: Skills load resources on demand, keeping context usage efficient

## How Skills Work

### Automatic Discovery

When Cursor starts, it automatically discovers skills from skill directories and makes them available to Agent. The agent is presented with available skills and decides when they are relevant based on context.

### Manual Invocation

Skills can also be manually invoked by typing `/` in Agent chat and searching for the skill name.

### Skill Directories

Skills are automatically loaded from these locations (in order of priority):

| Location | Scope | Description |
|----------|-------|-------------|
| `.cursor/skills/` | Project-level | Project-specific skills, version-controlled |
| `.claude/skills/` | Project-level | Claude compatibility (legacy) |
| `.codex/skills/` | Project-level | Codex compatibility (legacy) |
| `~/.cursor/skills/` | User-level (global) | Personal skills, available across all projects |
| `~/.claude/skills/` | User-level (global) | Claude compatibility (legacy) |
| `~/.codex/skills/` | User-level (global) | Codex compatibility (legacy) |

## Creating Skills

### Basic Skill Structure

Each skill should be a folder containing a `SKILL.md` file:

```text
.cursor/
└── skills/
    └── my-skill/
        └── SKILL.md
```

### SKILL.md File Format

Each skill is defined in a `SKILL.md` file with YAML frontmatter:

```markdown
---
name: my-skill
description: Short description of what this skill does and when to use it.
---

# My Skill

Detailed instructions for the agent.

## When to Use

- Use this skill when...
- This skill is helpful for...

## Instructions

- Step-by-step guidance for the agent
- Domain-specific conventions
- Best practices and patterns
- Use the ask questions tool if you need to clarify requirements with the user
```

### Frontmatter Fields

| Field | Required | Description |
|-------|----------|-------------|
| `name` | Yes | Skill identifier. Lowercase letters, numbers, and hyphens only. Must match the parent folder name. |
| `description` | Yes | Describes what the skill does and when to use it. Used by the agent to determine relevance. |
| `license` | No | License name or reference to a bundled license file. |
| `compatibility` | No | Environment requirements (system packages, network access, etc.). |
| `metadata` | No | Arbitrary key-value mapping for additional metadata. |
| `disable-model-invocation` | No | When `true`, the skill is only included when explicitly invoked via `/skill-name`. The agent will not automatically apply it based on context. |

### Decomposability: Skills as Standalone Capabilities

Skills should be **decomposable**: usable on their own and when composed in commands, hooks, or other automations. Avoid coupling a skill to a single command or workflow.

- **Do**: Describe "When to Use" in terms of the capability (e.g. "use when you need to ensure a feature branch before committing" or "use when staging files for commit").
- **Don't**: Tie the skill to one command (e.g. "use at the start of shipit" or "run in step 2 of the deploy command"). That prevents the skill from being reused in other flows or invoked independently.

This keeps skills portable and reusable across projects and workflows. Commands and automations then orchestrate skills in order without the skills depending on those orchestrators.

### Complete Skill Example

Here's a complete example of a skill structure:

```text
.cursor/
└── skills/
    └── deploy-app/
        ├── SKILL.md
        ├── scripts/
        │   ├── deploy.sh
        │   └── validate.py
        ├── references/
        │   └── REFERENCE.md
        └── assets/
            └── config-template.json
```

**SKILL.md:**
```markdown
---
name: deploy-app
description: Deploy the application to staging or production environments. Use when deploying code or when the user mentions deployment, releases, or environments.
---

# Deploy App

Deploy the application using the provided scripts.

## Usage

Run the deployment script: `scripts/deploy.sh <environment>`

Where `<environment>` is either `staging` or `production`.

## Pre-deployment Validation

Before deploying, run the validation script: `python scripts/validate.py`
```

## Skill Directories

Skills support these optional directories:

| Directory | Purpose | When to Use |
|-----------|---------|-------------|
| `scripts/` | Executable code that agents can run | When the skill needs to perform actions (deploy, test, build, etc.) |
| `references/` | Additional documentation loaded on demand | For detailed reference material that's not needed in every context |
| `assets/` | Static resources like templates, images, or data files | For configuration templates, example files, or other static resources |

### Including Scripts in Skills

Skills can include a `scripts/` directory containing executable code that agents can run. Reference scripts in your `SKILL.md` using relative paths from the skill root.

**Example:**
```markdown
---
name: deploy-app
description: Deploy the application to staging or production environments.
---

# Deploy App

Deploy the application using the provided scripts.

## Usage

Run the deployment script: `scripts/deploy.sh <environment>`

Where `<environment>` is either `staging` or `production`.

## Pre-deployment Validation

Before deploying, run the validation script: `python scripts/validate.py`
```

The agent reads these instructions and executes the referenced scripts when the skill is invoked. Scripts can be written in any language—Bash, Python, JavaScript, or any other executable format supported by the agent implementation.

> **Info:** Scripts should be self-contained, include helpful error messages, and handle edge cases gracefully.

### Progressive Loading

Keep your main `SKILL.md` focused and move detailed reference material to separate files. This keeps context usage efficient since agents load resources progressively—only when needed.

**Best Practice:**
- Put essential instructions in `SKILL.md`
- Move detailed documentation to `references/`
- Store templates and examples in `assets/`

## Disabling Automatic Invocation

By default, skills are automatically applied when the agent determines they are relevant. Set `disable-model-invocation: true` to make a skill behave like a traditional slash command, where it is only included in context when you explicitly type `/skill-name` in chat.

**Example:**
```markdown
---
name: my-skill
description: A skill that only runs when explicitly invoked.
disable-model-invocation: true
---

# My Skill

This skill will only be included when you type `/my-skill` in chat.
```

## Viewing Skills

To view discovered skills:

1. Open **Cursor Settings** (Cmd+Shift+J on Mac, Ctrl+Shift+J on Windows/Linux)
2. Navigate to **Rules**
3. Skills appear in the **Agent Decides** section

## Installing Skills from GitHub

You can import skills from GitHub repositories:

1. Open **Cursor Settings → Rules**
2. In the **Project Rules** section, click **Add Rule**
3. Select **Remote Rule (Github)**
4. Enter the GitHub repository URL

Skills installed from GitHub are automatically synced with their source repository, so updates are reflected automatically.

## Skills.sh Integration

This repository integrates with [skills.sh](https://skills.sh/), the open agent skills directory and CLI. Skills from the skills.sh ecosystem are included under `.cursor/skills/skills-sh/` so they work with this repo's structure and are available alongside project skills.

### Skills CLI

The Skills CLI (`npx skills`) is the package manager for the ecosystem. No global install is required:

- **Search**: `npx skills find [query]` — discover skills by keyword
- **Install**: `npx skills add <owner/repo@skill>` — install a skill (e.g. globally with `-g`)
- **Updates**: `npx skills check` and `npx skills update` — check and update installed skills

Browse all skills at [https://skills.sh/](https://skills.sh/).

### find-skills (included)

The **find-skills** skill from [Vercel Labs](https://skills.sh/vercel-labs/skills/find-skills) is included at `.cursor/skills/skills-sh/find-skills/`. It teaches the agent to:

- Recognize when the user is looking for installable skills ("find a skill for X", "how do I do X")
- Search via `npx skills find [query]`
- Present options with install commands and links to skills.sh
- Install skills for the user with `npx skills add ...` when they want to proceed

Use it when users ask for capabilities that might exist as skills (testing, deployment, docs, design, etc.). Additional skills from skills.sh can be added under `.cursor/skills/skills-sh/` or installed globally with `npx skills add <package> -g`.

## Migrating Rules and Commands to Skills

Cursor includes a built-in `/migrate-to-skills` skill (available in Cursor 2.4+) that helps you convert existing dynamic rules and slash commands to skills.

### What Gets Migrated

The migration skill converts:

- **Dynamic rules**: Rules that use the "Apply Intelligently" configuration—rules with `alwaysApply: false` (or undefined) and no `globs` patterns defined. These are converted to standard skills.
- **Slash commands**: Both user-level and workspace-level commands are converted to skills with `disable-model-invocation: true`, preserving their explicit invocation behavior.

### What Doesn't Get Migrated

- **Always-apply rules**: Rules with `alwaysApply: true` are not migrated, as they have explicit triggering conditions that differ from skill behavior.
- **File-specific rules**: Rules with specific `globs` patterns are not migrated, as they have explicit triggering conditions.
- **User rules**: User rules are not migrated since they are not stored on the file system.

### How to Migrate

1. Type `/migrate-to-skills` in Agent chat
2. The agent will identify eligible rules and commands and convert them to skills
3. Review the generated skills in `.cursor/skills/`

## Best Practices

### Skill Naming

- **Use lowercase with hyphens**: `my-skill` not `MySkill` or `my_skill`
- **Be descriptive**: `deploy-to-staging` not `deploy`
- **Match folder name**: The `name` field must match the parent folder name
- **Keep it short**: Easy to type and remember

### Skill Descriptions

- **Be specific**: Clearly describe what the skill does and when to use it
- **Include context**: Help the agent determine relevance
- **Use keywords**: Include terms users might use when they need this skill

**Good example:**
```markdown
description: Deploy the application to staging or production environments. Use when deploying code or when the user mentions deployment, releases, or environments.
```

**Bad example:**
```markdown
description: Deploy stuff
```

### Skill Content

- **Be clear and actionable**: Provide concrete steps, not vague guidance
- **Include examples**: Show how to use scripts and tools
- **Handle errors**: Document what to do when things go wrong
- **Keep it focused**: One skill should do one thing well
- **Use progressive loading**: Put detailed info in `references/` directory

### Scripts in Skills

- **Make scripts executable**: Ensure scripts have proper permissions
- **Include error handling**: Scripts should fail gracefully with helpful messages
- **Document dependencies**: Use `compatibility` field to specify requirements
- **Test scripts**: Ensure scripts work before including them in skills
- **Use relative paths**: Reference scripts from skill root directory

### When to Create a Skill

Create a skill when:
- ✅ You have domain-specific knowledge that agents need
- ✅ You have reusable workflows that benefit from automatic detection
- ✅ You want to package instructions with executable scripts
- ✅ You need to share knowledge across projects or teams
- ✅ You have complex procedures that benefit from structured guidance

**Don't create a skill when:**
- ❌ The knowledge is already clear from your code
- ❌ It's a one-time procedure
- ❌ A simple command would be more appropriate
- ❌ The instructions are too vague or context-dependent

## Skills vs Commands vs Rules vs Subagents

Understanding when to use each:

| Feature | Skills | Commands | Rules | Subagents |
|---------|--------|----------|-------|-----------|
| **Purpose** | Domain-specific knowledge + scripts | Reusable workflows | Persistent AI instructions | Specialized AI assistants |
| **Trigger** | Automatic (context-based) or manual (`/skill-name`) | Manual (`/command`) | Automatic (based on context/metadata) | Automatic (context-based) or manual (`/name`) |
| **Format** | Folder with `SKILL.md` + optional scripts | Markdown file | Markdown with metadata | Markdown with YAML frontmatter |
| **Location** | `.cursor/skills/` | `.cursor/commands/` | `.cursor/rules/` | `.cursor/agents/` |
| **Context** | Shared context | Shared context | Shared context | Own context window |
| **Scripts** | ✅ Can include executable scripts | ❌ Instructions only | ❌ Instructions only | ❌ Instructions only |
| **Parallel** | ❌ No | ❌ No | ❌ No | ✅ Yes |
| **Use case** | Domain knowledge + automation | Checklists, workflows | Code patterns, conventions | Complex tasks needing isolation |

See [Cursor Subagents Documentation](docs/cursor-subagents.md) for more details on subagents.

**Use Skills for:**
- Domain-specific knowledge that benefits from automatic detection
- Workflows that include executable scripts
- Complex procedures that need structured guidance
- Knowledge that should be available across projects

**Use Commands for:**
- Checklists and step-by-step workflows
- Processes that need to be triggered manually
- Tasks that benefit from structured guidance without scripts

**Use Rules for:**
- Code generation patterns
- Style and architecture standards
- Persistent AI guidance that should always apply

## Example Skills

### Example 1: Deployment Skill

```markdown
---
name: deploy-app
description: Deploy the application to staging or production environments. Use when deploying code or when the user mentions deployment, releases, or environments.
compatibility: Requires Docker and kubectl installed
---

# Deploy App

Deploy the application using the provided scripts.

## Usage

Run the deployment script: `scripts/deploy.sh <environment>`

Where `<environment>` is either `staging` or `production`.

## Pre-deployment Validation

Before deploying, run the validation script: `python scripts/validate.py`

## Post-deployment

After deployment, verify the deployment: `scripts/verify.sh <environment>`
```

### Example 2: Testing Skill

```markdown
---
name: run-tests
description: Run the test suite and fix any failures. Use when the user asks to test, run tests, or fix test failures.
---

# Run Tests

Execute the full test suite and systematically fix any failures.

## Steps

1. Run the test suite: `npm test`
2. Analyze failures and categorize by type
3. Fix issues systematically, starting with the most critical
4. Re-run tests after each fix
```

### Example 3: Code Review Skill

```markdown
---
name: code-review
description: Comprehensive code review checklist. Use when reviewing code, conducting code reviews, or when the user asks for review guidance.
---

# Code Review

Comprehensive checklist for conducting thorough code reviews.

## Review Categories

### Functionality
- Code does what it's supposed to do
- Edge cases are handled
- Error handling is appropriate

### Code Quality
- Code is readable and well-structured
- Follows project conventions
- No code duplication
```

## Troubleshooting

### Skills Not Appearing

1. **Check directory structure**: Ensure `.cursor/skills/` exists and contains skill folders
2. **Verify SKILL.md exists**: Each skill folder must contain a `SKILL.md` file
3. **Check frontmatter**: Ensure `name` matches folder name and `description` is present
4. **Restart Cursor**: Sometimes a restart is needed to discover new skills
5. **Check location**: Verify skills are in the correct directory

### Skill Not Being Applied

1. **Check description**: Ensure description clearly indicates when the skill should be used
2. **Review context**: The agent decides relevance based on context and description
3. **Try manual invocation**: Type `/skill-name` to explicitly invoke the skill
4. **Check disable-model-invocation**: If set to `true`, skill only runs when explicitly invoked

### Scripts Not Working

1. **Check permissions**: Ensure scripts are executable (`chmod +x script.sh`)
2. **Verify paths**: Use relative paths from skill root directory
3. **Test scripts manually**: Run scripts outside of Cursor to verify they work
4. **Check dependencies**: Use `compatibility` field to document requirements
5. **Review error messages**: Scripts should provide helpful error messages

### Importing Skills from GitHub

1. **Verify repository access**: Ensure you have access to the repository
2. **Check repository structure**: Skills should be in a `skills/` directory in the repo
3. **Verify SKILL.md format**: Imported skills must follow the standard format
4. **Check sync status**: Skills should sync automatically with source repository

## References

- [Official Cursor Skills Documentation](https://cursor.com/docs/context/skills)
- [Agent Skills Standard](https://agentskills.io) - Open standard for Agent Skills
- [Cursor Commands Documentation](docs/cursor-commands.md) - Related feature for reusable workflows
- [Cursor Rules Documentation](docs/cursor-rules.md) - Related feature for persistent AI instructions
- [Cursor Subagents Documentation](docs/cursor-subagents.md) - Related feature for specialized AI assistants
- [Meta Processes Guide](docs/meta-processes.md) - Self-improvement processes including meta skills
- [Organization Guide](docs/organization.md) - How skills are organized in this repository
- [AGENTS.md](AGENTS.md) - Agent instructions for this repository
- [Skills in this project](.cursor/skills/) - Project-specific skills
