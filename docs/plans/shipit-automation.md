# Shipit Automation: Skills and Command Design (Adapted Plan)

This plan adapts the shipit automation to **use existing skills and commands** when creating the new git skills and the shipit command. Implementers must use the skill-creator skill for each new skill and the command-creator skill for the new command, with Cursor-specific paths and formats.

## Approach

Follow the [Automation Decomposition](.cursor/rules/meta/automation-decomposition.mdc) rule: implement **discrete skills** (the "how") and **one command** that orchestrates them (the "when" and order). When creating those artifacts, use:

- **[Skill-creator skill](.cursor/skills/meta/skill-creator/SKILL.md)** for each of the three git skills
- **[Command-creator skill](.cursor/skills/meta/command-creator/SKILL.md)** for the shipit command
- **[Create-artifact command](.cursor/commands/meta/create-artifact.md)** optionally for the overall flow (identify pattern, select type, then apply skill-creator or command-creator as below)

## Architecture

- **Skills**: stage-related-files, terse-semantic-commits, open-pr (one skill per capability). Push remains a step in the command.
- **Command**: shipit — stage → pre-commit → commit → push → create or update PR.

## 1. Creating the Three Git Skills

**Location**: `.cursor/skills/git/<skill-name>/` (e.g. `.cursor/skills/git/stage-related-files/`, etc.)

**Process for each skill**:

1. **Use the [skill-creator](.cursor/skills/meta/skill-creator/SKILL.md) skill.** Follow its guidance before and while authoring each skill:
   - **Frontmatter**: `name` and `description`. Put "when to use" and trigger conditions in the description so the skill is discoverable; the skill-creator emphasizes that description is the primary trigger.
   - **Body**: Concise instructions only. Prefer short examples over long prose; avoid duplicating what the agent already knows.
   - **Progressive disclosure**: Keep SKILL.md lean. Move long reference material (e.g. full CONTRIBUTING/AGENTS snippets) to `references/` and reference them from SKILL.md if needed.
   - **No extra docs**: Do not add README, INSTALLATION_GUIDE, CHANGELOG, etc., per skill-creator.
   - **Degree of freedom**: Match to the task (e.g. staging = medium freedom; commit format = more prescriptive).

2. **Use [artifact-creation skill](.cursor/skills/meta/artifact-creation/SKILL.md) and [create-artifact command](.cursor/commands/meta/create-artifact.md) for structure.** Align with this repo’s conventions: use `.cursor/templates/skill-template.md` for structure and cross-references, place under `.cursor/skills/git/`, add Related Artifacts and cross-references.

3. **Skill-specific content** (what each skill must cover; author using skill-creator style):

### 1.1 stage-related-files

- **Purpose**: How to group changes for `git add` and when to split commits.
- **Content**: Grouping criteria (same type/scope, no unrelated edits), when to split (distinct features/fixes/docs), steps (git status → propose groups → git add per group). Avoid staging everything in one blob unless one logical change. Keep SKILL.md short; put detailed examples in `references/` if needed.

### 1.2 terse-semantic-commits

- **Purpose**: Format and rules for commit messages (Conventional Commits, terse, imperative).
- **Content**: Format `<type>(<scope>): <description>`, types (feat, fix, docs, style, refactor, perf, test, chore, ci, build, revert), rules (imperative, lowercase, no period, terse ~50 chars). Reference CONTRIBUTING.md and AGENTS.md; consider `references/` for long type/scope lists. One message per staged group.

### 1.3 open-pr

- **Purpose**: Create a PR with terse semantic title and template body, or update an existing PR’s description (and title if needed).
- **Content**: Title = same as commit convention. Body = project’s [.github/pull_request_template.md](.github/pull_request_template.md). Create flow: check for existing PR (e.g. `gh pr view` / `gh pr list --head <branch>`), compose title/body, `gh pr create`. Update flow: if PR exists, compare current body to desired body from commits/diff, `gh pr edit` when outdated. Prefer `gh` CLI; note that `gh` must be installed and authenticated.

## 2. Creating the Shipit Command

**Location**: `.cursor/commands/shipit.md` (project-level; this repo uses `.cursor/commands/`, not `.claude/commands/`).

**Process**:

1. **Use the [command-creator](.cursor/skills/meta/command-creator/SKILL.md) skill.** Adapt its workflow for Cursor:
   - **Location**: Use **project-level** `.cursor/commands/` (Cursor’s project commands path). Ignore command-creator’s `.claude/commands/` and `~/.claude/commands/`; follow existing Cursor commands (e.g. [process-chat](.cursor/commands/meta/process-chat.md), [create-artifact](.cursor/commands/meta/create-artifact.md)).
   - **Pattern**: Use the **Workflow Automation** pattern (Analyze → Act → Report). Load [command-creator references/patterns.md](.cursor/skills/meta/command-creator/references/patterns.md) for the workflow pattern; shipit is multi-step with a clear sequence and specific outputs (commit, PR).
   - **Structure**: Follow command-creator’s command structure (title, description, steps). Load [command-creator references/best-practices.md](.cursor/skills/meta/command-creator/references/best-practices.md) for writing style: imperative/infinitive form, specific instructions, expected outcomes, concrete examples.
   - **Content**: Name `shipit`, kebab-case. Steps: (1) Stage using stage-related-files skill, (2) Commit using terse-semantic-commits skill + run pre-commit + commit, (3) Push, (4) PR using open-pr skill. Include checklist and Related Artifacts. Optional parameters: e.g. `/shipit single commit` vs `/shipit split by feature` to guide staging.

2. **Align with existing Cursor commands.** Match the structure of [process-chat](.cursor/commands/meta/process-chat.md) and [create-artifact](.cursor/commands/meta/create-artifact.md): Overview, When to Use, Steps, Checklist, Related Artifacts. Reference the three git skills by path (e.g. [stage-related-files](.cursor/skills/git/stage-related-files/SKILL.md)), and link to Automation Decomposition, CONTRIBUTING.md, AGENTS.md, .github/PRE_COMMIT_SETUP.md.

## 3. Cross-References and Docs

- **Automation Decomposition rule**: Add the shipit command as the implemented example (e.g. link to shipit and list the three skills).
- **README / AGENTS.md**: Optional one-line under Commands (e.g. `/shipit` – stage, commit, push, open or update PR).
- **docs**: Optional short note in [docs/cursor-commands.md](docs/cursor-commands.md) or [docs/meta-processes.md](docs/meta-processes.md) that shipit is an example of a multi-step workflow composed from git skills.

## 4. Implementation Order

1. **Create the three skills** using the skill-creator skill (and artifact-creation/create-artifact for structure and placement): stage-related-files, terse-semantic-commits, open-pr under `.cursor/skills/git/`.
2. **Create the shipit command** using the command-creator skill (Workflow Automation pattern, Cursor paths and format).
3. **Update** the Automation Decomposition rule with the shipit example.
4. **Optionally update** README, AGENTS.md, and docs for discoverability.

## 5. Key References

| Purpose | Artifact |
|--------|----------|
| How to create each skill | [Skill-creator](.cursor/skills/meta/skill-creator/SKILL.md) |
| How to create the command | [Command-creator](.cursor/skills/meta/command-creator/SKILL.md) |
| Command patterns (Workflow Automation) | [command-creator references/patterns.md](.cursor/skills/meta/command-creator/references/patterns.md) |
| Command writing style | [command-creator references/best-practices.md](.cursor/skills/meta/command-creator/references/best-practices.md) |
| Repo artifact flow | [Create-artifact command](.cursor/commands/meta/create-artifact.md), [Artifact-creation skill](.cursor/skills/meta/artifact-creation/SKILL.md) |
| Decomposition rule | [Automation Decomposition](.cursor/rules/meta/automation-decomposition.mdc) |
| Commit/PR format | [CONTRIBUTING.md](CONTRIBUTING.md), [AGENTS.md](AGENTS.md) |
| Pre-commit | [AGENTS.md](AGENTS.md), [.github/PRE_COMMIT_SETUP.md](.github/PRE_COMMIT_SETUP.md) |
| PR body template | [.github/pull_request_template.md](.github/pull_request_template.md) |
| Existing command shape | [process-chat](.cursor/commands/meta/process-chat.md), [create-artifact](.cursor/commands/meta/create-artifact.md) |

## 6. What Not to Add

- No new rule for shipit (CONTRIBUTING/AGENTS and decomposition rule suffice).
- No push skill (push stays a step in the command).
- No scripts in skills unless skill-creator guidance justifies them (agent runs `git`/`gh` from instructions).
