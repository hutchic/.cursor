# Self-Improvement Bundle for Other Projects

This document lists the **minimal set of artifacts** to copy (or symlink) into another Cursor project so that project can **retrospect on conversations and self-improve** its own rules, hooks, skills, commands, subagents, and docs.

## What This Enables

- **Analyze** AI chat conversations for patterns
- **Extract** reusable patterns and suggest artifact types (rule, skill, command, subagent, or Cursor hooks)
- **Create** artifacts using templates and standards
- **Maintain** cross-references and documentation
- **Validate** organization and structure

## Bundle Contents

Copy the following into the target project, preserving paths under `.cursor/` and `docs/` so that relative links in the artifacts keep working.

### 1. Meta rules (required)

These rules define how to organize, reference, document, and create artifacts (and when to recommend Cursor hooks).

| File | Purpose |
|------|---------|
| `.cursor/rules/meta/organization.mdc` | Categorization, naming, structure |
| `.cursor/rules/meta/cross-referencing.mdc` | Reference standards and maintenance |
| `.cursor/rules/meta/documentation.mdc` | Documentation standards |
| `.cursor/rules/meta/artifact-creation.mdc` | When to create rule/skill/command/subagent/hooks |
| `.cursor/rules/meta/automation-decomposition.mdc` | Decompose automations into skills, then commands |

**Optional** (product/design guidance, not required for self-improvement):

- `.cursor/rules/meta/mvp-first.mdc`
- `.cursor/rules/meta/yagni.mdc`

### 2. Meta skills (required)

Skills implement the “how” for analysis, pattern extraction, artifact creation, and cross-reference maintenance.

| Path | Purpose |
|------|---------|
| `.cursor/skills/meta/conversation-analysis/` | Analyze conversations for patterns |
| `.cursor/skills/meta/pattern-extraction/` | Extract patterns and suggest artifact types (including hooks) |
| `.cursor/skills/meta/artifact-creation/` | Guide creation of artifacts from patterns |
| `.cursor/skills/meta/cross-reference-maintenance/` | Maintain cross-references |

### 3. Meta commands (required)

Commands define the workflows users (or the agent) invoke.

| File | Purpose |
|------|---------|
| `.cursor/commands/meta/process-chat.md` | Analyze a conversation and get suggestions |
| `.cursor/commands/meta/create-artifact.md` | Create rule/skill/command/subagent from a pattern |
| `.cursor/commands/meta/update-cross-references.md` | Fix and add cross-references |
| `.cursor/commands/meta/validate-organization.md` | Validate structure and naming |
| `.cursor/commands/meta/generate-docs-index.md` | Update documentation indexes |

### 4. Meta subagents (optional but recommended)

Subagents run analysis or creation in isolation.

| File | Purpose |
|------|---------|
| `.cursor/agents/meta/conversation-analyzer.md` | Analyze conversations in isolation |
| `.cursor/agents/meta/artifact-creator.md` | Create artifacts from patterns |
| `.cursor/agents/meta/cross-reference-maintainer.md` | Maintain cross-references |
| `.cursor/agents/meta/documentation-updater.md` | Update documentation |

### 5. Templates (required)

Templates are referenced by the create-artifact flow.

| File | Purpose |
|------|---------|
| `.cursor/templates/rule-template.md` | Rule structure |
| `.cursor/templates/skill-template.md` | Skill structure |
| `.cursor/templates/command-template.md` | Command structure |
| `.cursor/templates/subagent-template.md` | Subagent structure |
| `.cursor/templates/self-improvement-prompt.md` | Structured self-improvement prompt |

### 6. Documentation (required for links)

Meta artifacts link to these docs. Include at least the following so links resolve and the agent has context.

| File | Purpose |
|------|---------|
| `docs/self-improvement-workflow.md` | Step-by-step self-improvement workflow |
| `docs/meta-processes.md` | Overview of meta rules, skills, commands, subagents |
| `docs/organization.md` | Organization and structure |
| `docs/cursor-rules.md` | Cursor rules (referenced in templates) |
| `docs/cursor-commands.md` | Cursor commands (referenced in templates) |
| `docs/cursor-skills.md` | Cursor skills (referenced in templates) |
| `docs/cursor-subagents.md` | Cursor subagents (referenced in templates) |

**Optional** (referenced by some meta artifacts):

- `docs/research/cursor-best-practices.md`
- `docs/research/ai-agent-patterns.md`
- `docs/research/skills-commands-patterns.md`

### 7. Hooks

This repository **does not ship** any Cursor hooks (no `.cursor/hooks.json` or `.cursor/hooks/` scripts). The [artifact-creation rule](.cursor/rules/meta/artifact-creation.mdc) describes **when to recommend** hooks (e.g. gating shell, post-edit formatting, auditing); for events and config see [Cursor Hooks](https://cursor.com/docs/agent/hooks). The target project can add its own `.cursor/hooks.json` and scripts when it chooses.

### 8. Optional: skill-creator and command-creator

This repo keeps skill-creator and command-creator under `.agents/skills/`. The [artifact-creation](.cursor/skills/meta/artifact-creation/SKILL.md) skill and [artifact-creation rule](.cursor/rules/meta/artifact-creation.mdc) reference a “skill-creator” skill for creating new skills and a “command-creator” skill for new commands. To use that flow in another project you can:

- Copy `.agents/skills/skill-creator/` to `.cursor/skills/meta/skill-creator/` (or `.cursor/skills/skill-creator/` if you keep the references as-is), and
- Copy `.agents/skills/command-creator/` to `.cursor/skills/meta/command-creator/` (or `.cursor/skills/command-creator/`).

If you don’t include them, create-artifact and artifact-creation still work for rules, commands, and subagents; for skills you can rely on the skill template and artifact-creation skill without the dedicated skill-creator.

## How to Install in Another Project

**Easiest:** From this repo, run `./scripts/install-self-improvement.sh [TARGET_DIR]` for an interactive copy install. The target project remains self-contained and cloneable. If you omit `TARGET_DIR`, the script will prompt for the path.

**Manual:**

1. **Create directories** in the target project (if missing):
   - `.cursor/rules/meta/`
   - `.cursor/skills/meta/`
   - `.cursor/commands/meta/`
   - `.cursor/agents/meta/`
   - `.cursor/templates/`
   - `docs/research/`

2. **Copy** the files listed above from this repo into the target, preserving paths (e.g. meta rules into `.cursor/rules/meta/`, meta skills into `.cursor/skills/meta/`, etc.).

3. **Optional**: In the target’s `AGENTS.md` or README, add a short note that self-improvement is available via `/process-chat`, `/create-artifact`, `/update-cross-references`, `/validate-organization`, and `/generate-docs-index`, and point to `docs/self-improvement-workflow.md` and `docs/meta-processes.md`.

4. **Paths**: All references in the copied artifacts use paths like `.cursor/...` and `docs/...`. As long as the target project uses the same `.cursor/` and `docs/` layout, links will work. If the target uses a different docs location, add a `docs/` directory with the required files or update the links in the copied artifacts.

## Minimal vs full bundle

- **Minimal (core self-improvement):** Meta rules (1), meta skills (2), meta commands (3), templates (5), and the required docs (6). That’s enough to analyze conversations, get suggestions, create artifacts with templates, and maintain references.
- **Recommended:** Add meta subagents (4) and the optional docs so the agent can use subagents and all references resolve.
- **Optional:** Add skill-creator and command-creator (8) if you want the full skill/command creation workflow; add mvp-first and yagni rules if you want that product guidance.

## Related

- [INSTALL.md](../INSTALL.md) – Project-local usage and copying into other projects
- [Self-Improvement Workflow](self-improvement-workflow.md)
- [Meta Processes Guide](meta-processes.md)
