# Deslop

## Overview

Check the diff against main and remove AI-generated slop introduced in this branch. Targets comments, defensive code, type escapes, and style inconsistencies that a human wouldn't add.

## When to Use

- Use when a branch has AI-generated changes and you want to clean them up before review or merge
- Use when diff noise (extra comments, defensive checks, `any` casts) should match the rest of the codebase

## Steps

1. **Get the diff**: Compare the current branch to main (e.g. `git diff main...HEAD` or `git diff origin/main...HEAD`) to see what changed.

2. **Remove AI slop** in the changed files. Slop includes:
   - **Extra comments** that a human wouldn't add or that are inconsistent with the rest of the file
   - **Extra defensive checks or try/catch blocks** that are abnormal for that area of the codebase (especially if the codepath is already trusted or validated)
   - **Casts to `any`** (or equivalent) used to work around type issues
   - **Any other style** that is inconsistent with the file or project

3. **Report**: At the end, provide only a 1–3 sentence summary of what you changed. No long narrative.

## Checklist

- [ ] Diff against main inspected
- [ ] Unnecessary comments removed or aligned with file style
- [ ] Abnormal defensive checks or try/catch removed where inappropriate
- [ ] `any` (or equivalent) casts removed and types fixed properly where possible
- [ ] Style aligned with the rest of the file
- [ ] 1–3 sentence summary reported

## Related Artifacts

- [Self-Improvement Rule](.cursor/rules/self-improvement.mdc) – Code quality and learning from mistakes
- [Cursor Commands Documentation](docs/cursor-commands.md)
