# Cursor Meta-Repository

This repository is a **self-improving meta-system** for managing Cursor rules, skills, commands, and subagents. It can analyze AI chat conversations, extract patterns, create appropriate artifacts, maintain cross-references, and keep documentation updated.

## Purpose

This repository serves as a **Cursor configuration meta-repository** where you can:

- **Store rules, skills, commands, and subagents** for use in this project (and copy or reference them in others)
- **Self-improve** by analyzing AI conversations and extracting patterns
- **Maintain organization** through meta-processes that keep everything clean and cross-referenced
- **Learn by example** through hello world artifacts that demonstrate how rules, skills, and commands work together

## Quick Start

### Self-Configuring Structure

This repository is **self-configuring** when opened in Cursor IDE:

1. Clone or open this repository in Cursor
2. The `.cursor/` directory contains all artifacts and is used directly by Cursor IDE
3. Use commands by typing `/` followed by the command name
4. Rules, skills, and subagents are automatically detected

**No manual installation required!** Everything works immediately when you open this repository in Cursor.

### Using in Other Projects

Artifacts are project-local (no global install). To use them elsewhere:

1. **Reference this repository** in the other project's docs or AGENTS.md
2. **Copy** the rules, skills, commands, or subagents you need into that project's `.cursor/` (or equivalent)
3. **Use as template** — fork or copy this repo and trim to your needs

See [INSTALL.md](INSTALL.md).

## Available Artifacts

### Hello World Examples

Start with the hello world examples to understand how rules, skills, and commands work together:

- **[Hello World Rule](.cursor/rules/hello-world.mdc)** - Establishes standards and guidelines
- **[Hello World Skill](.cursor/skills/hello-world/SKILL.md)** - Provides actionable instructions that implement the rule
- **[Hello World Command](.cursor/commands/hello-world.md)** - Creates a workflow using both rule and skill
- **[Hello World Subagent](.cursor/agents/hello-world.md)** - Demonstrates subagent structure

These examples demonstrate the **rule → skill → command** relationship:
- **Rules** set persistent standards (the "what" and "why")
- **Skills** provide actionable instructions (the "how")
- **Commands** create workflows that orchestrate both (the "when" and "in what order")

### Meta Commands

Commands for self-improvement workflows (use with `/command-name`):

- `/process-chat` - Analyze AI chat conversations and extract patterns
- `/create-artifact` - Interactively create rules, skills, commands, or subagents
- `/shipit` - Stage, commit (with pre-commit), push, and open or update PR (workflow from git skills)
- `/update-cross-references` - Maintain cross-references between artifacts
- `/validate-organization` - Validate repository organization structure
- `/generate-docs-index` - Generate documentation indexes

### Meta Skills

Skills that help analyze and create (automatically detected or use `/skill-name`):

- `conversation-analysis` - Analyze AI chat conversations
- `pattern-extraction` - Extract reusable patterns
- `artifact-creation` - Guide artifact creation
- `cross-reference-maintenance` - Maintain cross-references

### Skills.sh Integration

- **find-skills** (`.cursor/skills/skills-sh/find-skills/`) - Discover and install agent skills from [skills.sh](https://skills.sh/). Use when the user asks "find a skill for X", "how do I do X", or wants to extend capabilities. Uses `npx skills find` and `npx skills add`.

### Meta Rules

Rules that guide the self-improvement process (always applied):

- `organization` - Categorization, naming, and structure standards
- `cross-referencing` - Reference standards and maintenance
- `documentation` - Documentation standards
- `artifact-creation` - Decision framework for creating artifacts
- `automation-decomposition` - Decompose automations into discrete skills, then package into commands

### Meta Subagents

Subagents for complex meta operations:

- `conversation-analyzer` - Analyze conversations in isolation
- `artifact-creator` - Create artifacts from patterns
- `cross-reference-maintainer` - Maintain cross-references
- `documentation-updater` - Update documentation

See [docs/cursor-commands.md](docs/cursor-commands.md), [docs/cursor-skills.md](docs/cursor-skills.md), [docs/cursor-rules.md](docs/cursor-rules.md), and [docs/cursor-subagents.md](docs/cursor-subagents.md) for details on each artifact type.

## Self-Improvement System

This repository includes a self-improving meta-system for managing Cursor configuration. You can:

- **Analyze conversations**: Use `/process-chat` to analyze AI chat conversations and extract patterns
- **Create artifacts**: Use `/create-artifact` to create rules, skills, commands, or subagents from patterns
- **Maintain organization**: Use meta processes to keep the repository clean and organized
- **Iterate on processes**: The system can improve itself through the same processes it manages

See [Self-Improvement Workflow](docs/self-improvement-workflow.md) for the complete process, [Meta Processes Guide](docs/meta-processes.md) for using meta artifacts, and [Organization Guide](docs/organization.md) for structure details.

## Repository Structure

This repository uses a self-improving meta-system:

- **Meta artifacts** manage the system itself (rules, skills, commands, subagents)
- **Hello world examples** demonstrate how artifacts work together
- **Templates** provide starting points for creating new artifacts
- **Documentation** explains concepts, workflows, and best practices
- **Research** documents patterns and best practices

The system can analyze conversations, extract patterns, and create new artifacts automatically.

## Directory Structure

- `.cursor/` - All Cursor artifacts (used directly by Cursor IDE)
  - `rules/` - Cursor rules (see [docs/cursor-rules.md](docs/cursor-rules.md))
    - `meta/` - Meta rules for self-improvement (organization, cross-referencing, documentation, artifact-creation, automation-decomposition)
    - `organization/` - Organization-specific rules
    - `hello-world.mdc` - Example rule demonstrating rule structure
    - `self-improvement.mdc` - Self-improvement guidance
  - `skills/` - Cursor skills (see [docs/cursor-skills.md](docs/cursor-skills.md))
    - `meta/` - Meta skills (conversation-analysis, pattern-extraction, artifact-creation, cross-reference-maintenance; skill-creator and command-creator are symlinked from `.agents/skills/`)
    - `analysis/` - Analysis and pattern extraction skills
    - `hello-world/` - Example skill demonstrating skill structure
  - `commands/` - Cursor commands (see [docs/cursor-commands.md](docs/cursor-commands.md))
    - `meta/` - Meta commands (process-chat, create-artifact, update-cross-references, validate-organization, generate-docs-index)
    - `shipit.md` - Stage, commit, push, open or update PR
    - `hello-world.md` - Example command demonstrating command structure
  - `agents/` - Cursor subagents (see [docs/cursor-subagents.md](docs/cursor-subagents.md))
    - `meta/` - Meta subagents (conversation-analyzer, artifact-creator, cross-reference-maintainer, documentation-updater)
    - `hello-world.md` - Example subagent demonstrating subagent structure
  - `templates/` - Reusable templates for creating artifacts
    - `rule-template.md`, `skill-template.md`, `command-template.md`, `subagent-template.md`
    - `self-improvement-prompt.md` - Template for analyzing conversations
- `docs/` - Comprehensive documentation
  - `cursor-rules.md` - Guide to Cursor Rules
  - `cursor-commands.md` - Guide to Cursor Commands
  - `cursor-skills.md` - Guide to Cursor Skills
  - `cursor-subagents.md` - Guide to Cursor Subagents
  - `meta-processes.md` - Guide to meta processes for self-improvement
  - `organization.md` - Organization structure guide
  - `self-improvement-workflow.md` - Step-by-step self-improvement workflow
  - `research/` - Research documentation
    - `cursor-best-practices.md` - Cursor IDE best practices
    - `cursor-hooks.md` - Cursor agent hooks (observe/control agent loop)
    - `ai-agent-patterns.md` - AI agent patterns and self-improving systems
    - `skills-commands-patterns.md` - Organization and structure patterns
  - `automation-agents.md` - GitHub Actions and automation workflows
- `AGENTS.md` - Instructions for AI coding agents (follows [AGENTS.md format](https://agents.md/))

## Getting Started

### Understanding the System

1. **Start with Hello World**: Review the [hello world examples](.cursor/rules/hello-world.mdc) to see how rules, skills, and commands work together
2. **Explore Meta Processes**: Read [Meta Processes Guide](docs/meta-processes.md) to understand self-improvement workflows
3. **Try Self-Improvement**: Use `/process-chat` to analyze a conversation and see how the system extracts patterns

### Using the Self-Improvement System

1. **Analyze a conversation**: Use `/process-chat` with an AI chat conversation
2. **Review suggestions**: The system will suggest artifacts to create
3. **Create artifacts**: Use `/create-artifact` to create rules, skills, commands, or subagents
4. **Maintain organization**: Use meta commands to keep everything organized

See [Self-Improvement Workflow](docs/self-improvement-workflow.md) for the complete process.

### Creating Your Own Artifacts

1. **Use templates**: Start with templates in `.cursor/templates/`
2. **Follow standards**: Use the meta rules as guidance (organization, naming, structure)
3. **Add cross-references**: Link to related artifacts
4. **Update documentation**: Keep docs in sync

See [Organization Guide](docs/organization.md) for structure details.

## Troubleshooting & FAQ

### General Issues

#### Q: Artifacts not showing up in Cursor IDE?

**A:** Check the following:

1. **Verify repository location**: Is this repository opened as the root folder in Cursor IDE?
2. **Check structure**: Run `ls -la .cursor` to verify `.cursor/` exists and contains `rules/`, `skills/`, `commands/`, `agents/`
3. **Cursor IDE version**: Ensure you're using a recent version of Cursor IDE that supports `.cursor/` directories
4. **Restart Cursor**: Sometimes Cursor needs a restart to detect new artifacts

#### Q: How do I verify the setup is working?

**A:** Check the structure:

```bash
# Verify .cursor directory
ls -la .cursor

# Check artifacts exist
ls -la .cursor/rules/
ls -la .cursor/skills/
ls -la .cursor/commands/
ls -la .cursor/agents/

# Try a hello world example
# Type /hello-world in Cursor chat
```

#### Q: Can I use these artifacts in other projects?

**A:** Yes! You can:

1. **Reference this repository**: Point other projects to artifacts in this repository
2. **Copy specific artifacts**: Copy rules, skills, commands, or subagents you need
3. **Use as template**: Use this repository as a template for project-specific configurations

See [INSTALL.md](INSTALL.md) for more details.

### Platform-Specific Issues

#### Q: .cursor not detected on Windows?

**A:** Ensure the repository is cloned with the `.cursor` directory present (it is a normal directory in this repo). If you use symlinks for global sharing, see [INSTALL.md](INSTALL.md) for optional setup.

### Dependency Issues

#### Q: What dependencies are required?

**A:** Core dependencies:

- **Git**: For version control operations
- **Bash**: Shell environment (4.0+ recommended)
- **GitHub CLI (gh)** OR **GitHub MCP**: For GitHub operations

Optional dependencies:

- **pre-commit**: For code quality hooks (`pip install pre-commit`)
- **Python 3.x**: For pre-commit hooks
- **Docker**: If using containerized workflows

#### Q: How do I install GitHub CLI?

**A:** Installation varies by platform:

**macOS:**
```bash
brew install gh
gh auth login
```

**Ubuntu/Debian:**
```bash
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update
sudo apt install gh
gh auth login
```

**Windows:**
```powershell
winget install GitHub.cli
gh auth login
```

#### Q: How do I set up pre-commit hooks?

**A:** Install and configure pre-commit:

```bash
# Install pre-commit
pip install pre-commit

# Install git hooks
pre-commit install

# Run on all files (optional, to test)
pre-commit run --all-files
```

See [.github/PRE_COMMIT_SETUP.md](.github/PRE_COMMIT_SETUP.md) for detailed setup instructions.

### Self-Improvement Issues

#### Q: How do I analyze a conversation?

**A:** Use the process-chat command:

1. Type `/process-chat` in Cursor chat
2. Paste your AI chat conversation
3. Review the analysis and artifact suggestions
4. Create suggested artifacts using `/create-artifact`

#### Q: How do I know which artifact type to create?

**A:** Use the artifact-creation rule as guidance:

- **Rule**: Persistent guidance, domain knowledge, standards
- **Skill**: Domain knowledge with scripts, automation
- **Command**: Manual workflows, checklists
- **Subagent**: Complex tasks, context isolation

See [Artifact Creation Rule](.cursor/rules/meta/artifact-creation.mdc) for the complete decision framework.

#### Q: How do I maintain cross-references?

**A:** Use the update-cross-references command:

1. Type `/update-cross-references` in Cursor chat
2. The system will scan for missing or broken references
3. Review and apply suggested fixes

Or use the cross-reference-maintainer subagent for comprehensive maintenance.

### Artifact Creation Issues

#### Q: How do I create a new artifact?

**A:** Use the create-artifact command:

1. Type `/create-artifact` in Cursor chat
2. Describe the pattern or need
3. Follow the guided process to create the artifact
4. The system will use appropriate templates and add cross-references

#### Q: Can I customize existing artifacts?

**A:** Yes! All artifacts are in the `.cursor/` directory:

1. **Rules**: Edit `.mdc` files in `.cursor/rules/`
2. **Skills**: Edit `SKILL.md` files in `.cursor/skills/`
3. **Commands**: Edit `.md` files in `.cursor/commands/`
4. **Subagents**: Edit `.md` files in `.cursor/agents/`

Remember to update cross-references and documentation when modifying artifacts.

#### Q: Where are artifacts stored?

**A:** Artifact locations:

- **Artifacts**: `.cursor/` directory (rules, skills, commands, agents)
- **Templates**: `.cursor/templates/` for creating new artifacts
- **Documentation**: `docs/` for guides and references

### Getting Help

#### Q: Where can I find more documentation?

**A:** Documentation is organized as follows:

- **[README.md](README.md)** - Quick start and overview
- **[AGENTS.md](AGENTS.md)** - Instructions for AI coding agents (follows [AGENTS.md format](https://agents.md/))
- **[INSTALL.md](INSTALL.md)** - Detailed installation instructions
- **[CONTRIBUTING.md](CONTRIBUTING.md)** - Contribution guidelines and PR title format
- **[docs/cursor-rules.md](docs/cursor-rules.md)** - Guide to Cursor Rules: what they're good for and best practices
- **[docs/cursor-commands.md](docs/cursor-commands.md)** - Guide to Cursor Commands: creating reusable workflows
- **[docs/cursor-skills.md](docs/cursor-skills.md)** - Guide to Cursor Skills: extending AI agents with specialized capabilities
- **[docs/cursor-subagents.md](docs/cursor-subagents.md)** - Guide to Cursor Subagents: specialized AI assistants for complex tasks
- **[docs/meta-processes.md](docs/meta-processes.md)** - Guide to meta processes for self-improvement
- **[docs/organization.md](docs/organization.md)** - Organization structure guide
- **[docs/self-improvement-workflow.md](docs/self-improvement-workflow.md)** - Step-by-step self-improvement workflow
- **[docs/automation-agents.md](docs/automation-agents.md)** - GitHub Actions and automation workflows
- **[.cursor/commands/](.cursor/commands/)** - Individual command documentation
- **[.github/copilot-instructions.md](.github/copilot-instructions.md)** - Project standards and guidelines

#### Q: I found a bug or have a feature request?

**A:** Please [open an issue](https://github.com/hutchic/.cursor/issues/new) with:

- Clear description of the problem or feature
- Steps to reproduce (for bugs)
- Your environment (OS, Cursor IDE version, etc.)
- Expected vs actual behavior

#### Q: How do I contribute?

**A:** Contributions are welcome!

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request with a [semantic title](CONTRIBUTING.md#pull-request-titles)

See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed guidelines.

### Advanced Topics

#### Q: Can I use this as a template for my own projects?

**A:** Yes! This repository is designed to be used as a template:

1. Click "Use this template" on GitHub
2. Clone your new repository
3. The `.cursor/` directory will automatically work
4. Customize commands in `.cursor/commands/` to your needs

#### Q: How do I add new commands?

**A:**

1. Create a new executable file in `.cursor/commands/`:
   ```bash
   touch .cursor/commands/mycommand
   chmod +x .cursor/commands/mycommand
   ```

2. Add a shebang and implementation:
   ```bash
   #!/usr/bin/env bash
   # Your command implementation
   ```

3. Document it with a `.md` file:
   ```bash
   # .cursor/commands/mycommand.md
   # Your command documentation
   ```

4. Test the command:
   ```bash
   bash .cursor/commands/mycommand
   ```

#### Q: What's the difference between rules, skills, commands, and subagents?

**A:** See the hello world examples for a complete demonstration:

- **Rules**: Persistent guidance and standards (the "what" and "why")
  - Example: [Hello World Rule](.cursor/rules/hello-world.mdc) establishes standards
- **Skills**: Actionable instructions that implement rules (the "how")
  - Example: [Hello World Skill](.cursor/skills/hello-world/SKILL.md) provides steps
- **Commands**: Workflows that orchestrate rules and skills (the "when" and "in what order")
  - Example: [Hello World Command](.cursor/commands/hello-world.md) creates a workflow
- **Subagents**: Specialized AI assistants for complex tasks (context isolation)
  - Example: [Hello World Subagent](.cursor/agents/hello-world.md) demonstrates structure

The hello world examples show how they work together: **Rule → Skill → Command**
