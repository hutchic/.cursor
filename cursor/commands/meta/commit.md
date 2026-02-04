# Commit

## Overview

Run the terse semantic commit workflow: determine what to stage, summarize the change, compose a Conventional Commits message (using the terse-semantic-commits skill), run pre-commit if applicable, then commit.

## When to Use

- When the user wants to commit with a proper semantic message (e.g. "commit this", "git add and semantic commit")
- When you need to stage and commit changes with a terse, semantic message

## Steps

1. **Determine what to stage**: Run `git status`. Stage files as requested (e.g. `git add <paths>`, `git add .`, or ask the user what to include).

2. **Summarize the change**: In one line, state what was done (e.g. "add terse semantic commit skill and command", "refactor install to two symlinks only").

3. **Compose the message**: Using the [terse-semantic-commits skill](.cursor/skills/meta/terse-semantic-commits/SKILL.md):
   - Pick the correct **type** (feat, fix, docs, refactor, chore, etc.)
   - Add **scope** if helpful (e.g. rules, docs, meta)
   - Write an **imperative, terse** description (no trailing period, under ~50 chars when possible)

4. **Run pre-commit (if applicable)**: If the repo has pre-commit, run `pre-commit run --all-files` (or on staged files). Fix any issues, then re-stage if needed.

5. **Commit**: Run `git add` (if not already staged) and `git commit -m "<message>"` with the composed message.

## Checklist

- [ ] Staging is correct (intended files only)
- [ ] Message follows Conventional Commits: `type(scope): description`
- [ ] Message is terse and imperative
- [ ] Pre-commit was run if the repo uses it
- [ ] Commit completed successfully

## Examples

### Example 1: Simple commit

User: "commit the new skill and command"

1. `git status` → new skill and commit.md
2. Summarize: add terse semantic commit skill and command
3. Message: `feat(meta): add terse semantic commit skill and command`
4. `pre-commit run --all-files` (if present)
5. `git add ... && git commit -m "feat(meta): add terse semantic commit skill and command"`

### Example 2: Refactor

User: "add everything and commit"

1. Stage as requested (e.g. `git add .`)
2. Summarize: refactor standalone project, two symlinks only
3. Message: `refactor: standalone project, two symlinks only`
4. Pre-commit, then commit

## Related Artifacts

- [Terse Semantic Commits Skill](.cursor/skills/meta/terse-semantic-commits/SKILL.md) – Format and rules for the message
- [CONTRIBUTING.md](CONTRIBUTING.md) – Full PR/commit title guidelines
- [AGENTS.md](AGENTS.md) – PR Instructions and commit format for agents
