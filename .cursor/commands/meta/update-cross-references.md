# Update Cross-References

## Overview

Update all cross-references between artifacts and documentation. Scan for missing references, update existing references, validate reference integrity, and report broken links.

## When to Use

- Use when maintaining reference integrity
- Use after moving or renaming artifacts
- Use when adding new artifacts
- Use for periodic reference validation
- Use when fixing broken references

## Steps

1. **Scan artifacts**: Review all artifacts for cross-references:
   - Check "Related Artifacts" sections
   - Identify missing references
   - Find broken or outdated references

2. **Scan documentation**: Review documentation for references:
   - Check links to artifacts
   - Verify documentation cross-references
   - Identify missing documentation links

3. **Validate references**: For each reference:
   - Verify referenced file exists
   - Check path is correct
   - Ensure reference makes sense contextually

4. **Update references**: Fix issues found:
   - Add missing references
   - Update broken paths
   - Remove invalid references
   - Add bidirectional references where appropriate

5. **Report findings**: Document:
   - Missing references found
   - Broken references fixed
   - References added
   - Validation results

## Checklist

- [ ] All artifacts scanned for references
- [ ] Documentation scanned for references
- [ ] References validated
- [ ] Missing references added
- [ ] Broken references fixed
- [ ] Invalid references removed
- [ ] Bidirectional references added where appropriate
- [ ] Findings reported

## Examples

### Example 1: Adding Missing References

**Scenario**: New rule created, but related skill doesn't reference it

**Action**:
1. Identify related skill
2. Add reference to new rule in skill
3. Add reference to skill in rule
4. Update documentation

### Example 2: Fixing Broken References

**Scenario**: File moved from `rules/` to `rules/meta/`

**Action**:
1. Find all references to old path
2. Update all references to new path
3. Verify links work
4. Check documentation

## Validation Rules

For each reference, verify:
- File exists at referenced path
- Path is correct (relative or absolute)
- Reference makes contextual sense
- Bidirectional reference exists if appropriate

## Related Artifacts

- [Cross-Referencing Rule](.cursor/rules/meta/cross-referencing.mdc)
- [Cross-Reference Maintenance Skill](.cursor/skills/meta/cross-reference-maintenance/SKILL.md)
- [Cross-Reference Maintainer Subagent](.cursor/agents/meta/cross-reference-maintainer.md)
- [Skills/Commands Patterns](docs/research/skills-commands-patterns.md)

## Notes

- Validate references regularly
- Update immediately when files change
- Maintain bidirectional references when relevant
- Document reference relationships
