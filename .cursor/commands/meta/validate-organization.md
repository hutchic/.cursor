# Validate Organization

## Overview

Validate repository organization structure. Check structure compliance, verify naming conventions, identify misplaced files, and suggest improvements.

## When to Use

- Use for periodic organization validation
- Use after adding multiple artifacts
- Use when reorganizing structure
- Use to identify organization issues
- Use before major changes

## Steps

1. **Check directory structure**: Verify:
   - Categories exist as expected
   - Directory structure follows standards
   - No orphaned files or directories

2. **Verify naming conventions**: Check:
   - Rules use `.mdc` or `.md` extension
   - Skills use folder structure with `SKILL.md`
   - Commands use `.md` extension
   - Subagents use `.md` extension
   - All use kebab-case naming

3. **Check organization**: Validate:
   - Artifacts are in correct categories
   - No misplaced files
   - Categories are appropriately used
   - Structure makes sense

4. **Identify issues**: Find:
   - Files in wrong locations
   - Naming convention violations
   - Missing categories
   - Structure inconsistencies

5. **Suggest improvements**: Recommend:
   - Files that should be moved
   - Categories that should be created
   - Naming fixes needed
   - Structure improvements

## Checklist

- [ ] Directory structure validated
- [ ] Naming conventions checked
- [ ] File locations verified
- [ ] Categories validated
- [ ] Issues identified
- [ ] Improvements suggested
- [ ] Report generated

## Validation Rules

### Directory Structure

- Categories should have 3+ artifacts (or clear growth potential)
- Meta category for system management artifacts
- Clear functional or domain grouping
- Consistent structure across categories

### Naming Conventions

- All names use kebab-case
- Rules: `kebab-case.mdc` or `kebab-case.md`
- Skills: `kebab-case/` folder with `SKILL.md`
- Commands: `kebab-case.md`
- Subagents: `kebab-case.md`

### File Organization

- Artifacts in appropriate categories
- No files in root directories (use categories)
- Consistent structure within categories
- Clear hierarchy maintained

## Examples

### Example 1: Misplaced File

**Issue**: Rule file in commands directory

**Fix**: Move to appropriate rules category

### Example 2: Naming Violation

**Issue**: File named `MyRule.mdc` (should be kebab-case)

**Fix**: Rename to `my-rule.mdc`

## Related Artifacts

- [Organization Rule](.cursor/rules/meta/organization.mdc)
- [Organization Documentation](docs/organization.md)
- [Skills/Commands Patterns](docs/research/skills-commands-patterns.md)

## Notes

- Run validation regularly
- Fix issues as they're found
- Document structure decisions
- Keep organization clean
