---
name: cross-reference-maintenance
description: "Maintain cross-references between artifacts and documentation. Identify missing references, update existing references, validate reference integrity, and ensure all links are current. Use when maintaining reference integrity or updating references after changes."
---

# Cross-Reference Maintenance Skill

Maintain cross-references between artifacts and documentation, ensuring reference integrity and completeness.

## When to Use

- Use when maintaining reference integrity
- Use when updating references after file moves
- Use when validating cross-references
- Use when identifying missing references

## Instructions

### Maintenance Process

1. **Scan artifacts**: Review all artifacts for references
2. **Identify missing**: Find artifacts that should have references but don't
3. **Validate existing**: Check that existing references are valid
4. **Update broken**: Fix broken or outdated references
5. **Add missing**: Add missing references where appropriate

### Reference Identification

#### Missing References

Look for:
- Related artifacts without cross-references
- Documentation without artifact links
- Artifacts without documentation links
- Broken reference chains

#### Invalid References

Check for:
- Broken file paths
- References to non-existent files
- Incorrect relative paths
- Outdated references after moves

### Reference Updates

#### When Files Move

1. **Find all references**: Search for references to moved file
2. **Update paths**: Update all reference paths
3. **Verify links**: Ensure links work after update
4. **Check documentation**: Update documentation references

#### When Files Are Added

1. **Identify related**: Find artifacts related to new file
2. **Add forward refs**: Add references in new file
3. **Add backward refs**: Add references in related files
4. **Update docs**: Add to documentation

#### When Files Are Removed

1. **Find all references**: Search for references to removed file
2. **Remove references**: Remove from all artifacts
3. **Update documentation**: Remove from docs
4. **Verify cleanup**: Ensure no broken references

### Validation Checklist

For each artifact:
- [ ] Has "Related Artifacts" section
- [ ] References are to existing files
- [ ] Paths are correct
- [ ] Bidirectional references where appropriate
- [ ] Documentation links are current

## Examples

### Example 1: Adding Missing References

**Scenario**: New rule created, but related skill doesn't reference it

**Action**:
1. Identify related skill
2. Add reference to new rule in skill's "Related Artifacts" section
3. Add reference to skill in rule's "Related Artifacts" section
4. Update documentation if needed

### Example 2: Fixing Broken References

**Scenario**: File moved, but references still point to old location

**Action**:
1. Find all references to old path
2. Update all references to new path
3. Verify links work
4. Check documentation references

## Best Practices

- Validate references regularly
- Update immediately when files change
- Maintain bidirectional references when relevant
- Document reference relationships
- Use relative paths consistently

## Related Artifacts

- [Cross-Referencing Rule](.cursor/rules/meta/cross-referencing.mdc)
- [Update Cross-References Command](.cursor/commands/meta/update-cross-references.md)
- [Cross-Reference Maintainer Subagent](.cursor/agents/meta/cross-reference-maintainer.md)
- [Skills/Commands Patterns](docs/research/skills-commands-patterns.md)
