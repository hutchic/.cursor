# Generate Documentation Index

## Overview

Generate a comprehensive index of all artifacts and create cross-reference maps. Update documentation structure and create navigation aids for the repository.

## When to Use

- Use after adding multiple artifacts
- Use for periodic documentation updates
- Use when reorganizing structure
- Use to create navigation aids
- Use before major documentation updates

## Steps

1. **Scan artifacts**: Collect all artifacts:
   - Rules in all categories
   - Skills in all categories
   - Commands in all categories
   - Subagents in all categories

2. **Categorize artifacts**: Group by:
   - Type (rule, skill, command, subagent)
   - Category (meta, organization, etc.)
   - Purpose or domain

3. **Generate index**: Create index with:
   - Complete list of artifacts
   - Organized by type and category
   - Links to each artifact
   - Brief descriptions

4. **Create cross-reference map**: Map relationships:
   - Artifact-to-artifact relationships
   - Documentation-to-artifact links
   - Category relationships
   - Dependency chains

5. **Update documentation**: Add to:
   - Master index file
   - Category documentation
   - Navigation aids
   - Cross-reference sections

6. **Validate links**: Ensure:
   - All links are valid
   - Paths are correct
   - References work

## Checklist

- [ ] All artifacts scanned
- [ ] Artifacts categorized
- [ ] Index generated
- [ ] Cross-reference map created
- [ ] Documentation updated
- [ ] Links validated
- [ ] Navigation aids created

## Index Structure

### By Type

- **Rules**: List all rules by category
- **Skills**: List all skills by category
- **Commands**: List all commands by category
- **Subagents**: List all subagents by category

### By Category

- **Meta**: System management artifacts
- **Organization**: Organization and structure artifacts
- **Analysis**: Analysis and pattern extraction artifacts
- **Other categories**: As they exist

## Cross-Reference Map

Map showing:
- Which artifacts reference which
- Documentation links to artifacts
- Category relationships
- Dependency flows

## Examples

### Example Index Entry

```markdown
### Rules

#### Meta Rules
- [Organization](.cursor/rules/meta/organization.mdc) - Rules for maintaining clean structure
- [Cross-Referencing](.cursor/rules/meta/cross-referencing.mdc) - Rules for maintaining references
```

## Related Artifacts

- [Documentation Rule](.cursor/rules/meta/documentation.mdc)
- [Documentation Updater Subagent](.cursor/agents/meta/documentation-updater.md)
- [Organization Documentation](docs/organization.md)

## Notes

- Generate index regularly
- Keep cross-reference map current
- Update navigation aids
- Validate all links
