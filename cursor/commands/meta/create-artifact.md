# Create Artifact

## Overview

Interactively create an artifact (rule, skill, command, or subagent) from a pattern. This command guides you through the artifact creation process with proper structure and cross-referencing.

## When to Use

- Use when you have a pattern to convert to an artifact
- Use when creating artifacts based on analysis
- Use when setting up new artifacts with proper structure
- Use when ensuring artifacts follow standards

## Steps

1. **Identify pattern**: Clearly describe the pattern to convert to an artifact

2. **Select artifact type**: Determine if pattern should be:
   - **Rule**: Persistent guidance, domain knowledge, standards
   - **Skill**: Domain knowledge with scripts, automation
   - **Command**: Manual workflows, checklists
   - **Subagent**: Complex tasks, context isolation

3. **Choose template**: Select appropriate template:
   - `cursor/templates/rule-template.md`
   - `cursor/templates/skill-template.md`
   - `cursor/templates/command-template.md`
   - `cursor/templates/subagent-template.md`

4. **Create structure**: Use template to create artifact with:
   - Proper frontmatter/metadata
   - Clear structure and sections
   - Pattern-specific content
   - Examples where helpful

5. **Organize**: Place artifact in appropriate location:
   - Follow naming conventions
   - Use appropriate category
   - Follow directory structure

6. **Add cross-references**: Include references to:
   - Related artifacts
   - Relevant documentation
   - Related templates

7. **Update documentation**: Add to:
   - Category documentation
   - Master index
   - Usage guides
   - Example sections

8. **Validate**: Verify artifact:
   - Structure is correct
   - References are valid
   - Documentation is updated
   - Follows standards

## Checklist

- [ ] Pattern clearly identified
- [ ] Artifact type selected
- [ ] Template chosen and used
- [ ] Structure created properly
- [ ] Content added
- [ ] Artifact organized correctly
- [ ] Cross-references added
- [ ] Documentation updated
- [ ] Artifact validated

## Examples

### Example 1: Creating a Rule

**Pattern**: Always use async/await instead of promises

**Creation**:
1. Type: Rule
2. Template: rule-template.md
3. Name: `async-await-preference`
4. Location: `cursor/rules/organization/async-await-preference.mdc`
5. Content: Guidelines for async/await usage
6. Cross-refs: JavaScript/TypeScript rules

### Example 2: Creating a Command

**Pattern**: Standard code review process

**Creation**:
1. Type: Command
2. Template: command-template.md
3. Name: `code-review-checklist`
4. Location: `cursor/commands/meta/code-review-checklist.md`
5. Content: Step-by-step review checklist
6. Cross-refs: Review-related artifacts

## Parameters

You can specify artifact type when invoking:

```
/create-artifact create a rule for TypeScript strict mode
/create-artifact create a command for code review
/create-artifact create a skill for pattern extraction
```

## Related Artifacts

- [Artifact Creation Rule](.cursor/rules/meta/artifact-creation.mdc)
- [Artifact Creation Skill](.cursor/skills/meta/artifact-creation/SKILL.md)
- [Artifact Creator Subagent](.cursor/agents/meta/artifact-creator.md)
- [Templates](cursor/templates/)
- [Organization Guide](docs/organization.md)

## Notes

- Always use templates for consistency
- Follow naming and organization standards
- Add cross-references from the start
- Update documentation immediately
