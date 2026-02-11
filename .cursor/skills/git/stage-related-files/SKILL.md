---
name: stage-related-files
description: "Group and stage related changes for git commit. Use when staging files for commit, grouping related changes, or deciding what to include in each commit. Implements how to group changes and when to split commits."
---

# Stage Related Files Skill

Group changes logically for `git add` and decide when to split into one or more commits.

## When to Use

- Use when staging files for commit or when grouping related changes into logical commits
- Use when deciding whether to make one commit or several
- Use in any workflow that requires staging (e.g. commit workflows, hooks, commands)

## Instructions

### Grouping Criteria

Group by **logical change**: one feature/fix/docs refactor per commit when possible.

- **Same type of change**: Same scope (e.g. one area of codebase), no unrelated edits in one commit
- **When to split**: Separate commits for distinct features, fixes, or doc-only vs code

### Steps

1. Run `git status` to see modified, added, and deleted files
2. **Exclude research documents and plan files** from staging:
   - Files matching `*research*.md` (e.g. `docs/cloud-build-cache-research.md`)
   - Files matching `plan*.txt` or `*.plan.md`
   - These are one-off documents created during tasks and should not be committed
3. Propose groupings (paths or patterns) based on the criteria above, excluding the research/plan files
4. For each group, run `git add <paths>`. Avoid staging everything in one blob unless it truly is one logical change
5. Run `git status` again to verify what is staged (confirm research/plan files are not included)

### Single vs Multiple Commits

- **Single**: All changes are one logical unit — use one `git add` for the full set
- **Multiple**: If the working tree has clearly separate logical changes, do multiple `git add` + commit cycles (group 1 → add → commit, then group 2 → add → commit)

## Related Artifacts

- [Terse Semantic Commits Skill](.cursor/skills/git/terse-semantic-commits/SKILL.md)
- [Shipit Command](.cursor/commands/shipit.md)
- [Automation Decomposition Rule](.cursor/rules/meta/automation-decomposition.mdc)
