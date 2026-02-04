# Self-Improvement Prompt Template

This template provides a structured prompt for analyzing AI chat conversations and extracting patterns for self-improvement.

## How to Use This Template

1. Copy the prompt template below
2. Paste your AI chat conversation
3. Submit to Cursor Agent
4. Review the analysis and suggestions
5. Create artifacts as recommended

## Prompt Template

```
I'm working on a self-improving meta-repository for managing Cursor rules, skills, commands, and subagents. I've pasted an AI chat conversation below. Please analyze it and help me improve the system.

## Analysis Request

Please analyze the following conversation and:

1. **Extract Patterns**: Identify recurring instructions, corrections, or workflows
2. **Categorize Findings**: Group patterns by type (rule, skill, command, subagent)
3. **Suggest Artifacts**: Recommend specific artifacts to create
4. **Provide Organization**: Suggest where artifacts should be placed
5. **Identify Cross-References**: Note relationships between potential artifacts

## Conversation

[PASTE YOUR AI CHAT CONVERSATION HERE]

## Expected Output

For each pattern identified, provide:

- **Pattern Description**: What the pattern is
- **Frequency**: How often it appears
- **Artifact Type**: Rule, Skill, Command, or Subagent
- **Suggested Name**: Descriptive name following naming conventions
- **Suggested Location**: Category and path
- **Content Outline**: Key points to include
- **Related Artifacts**: Links to existing or suggested artifacts

## Additional Context

- This is a meta-repository focused on organization and self-improvement
- All artifacts should be implementation-agnostic
- Focus on maintaining clean, organized structure
- Ensure proper cross-referencing
- Update documentation as needed

Please analyze the conversation and provide your recommendations.
```

## Alternative: Step-by-Step Analysis

If you prefer a more structured approach, use this version:

```
Analyze this AI chat conversation for self-improvement opportunities:

[PASTE CONVERSATION]

For each identified pattern, provide:

1. **Pattern Summary**: One-sentence description
2. **Artifact Recommendation**: Rule/Skill/Command/Subagent
3. **Rationale**: Why this artifact type
4. **Suggested Implementation**: Key content to include
5. **Organization**: Where to place it
6. **Dependencies**: Related artifacts needed

Focus on:
- Repeated instructions or corrections
- Workflow patterns
- Domain-specific knowledge
- Team standards or conventions
- Processes that could be automated
```

## Follow-Up Prompts

After receiving analysis, use these follow-up prompts:

### Create Artifacts

```
Based on the analysis, create the following artifacts:

[List of artifacts from analysis]

Use the appropriate templates from cursor/templates/ and ensure:
- Proper structure and formatting
- Cross-references to related artifacts
- Documentation updates
- Organization in correct categories
```

### Update Documentation

```
Update the documentation to reflect the new artifacts:

- Add to relevant documentation files
- Update cross-reference sections
- Add to indexes if applicable
- Ensure all links are valid
```

### Validate Organization

```
Validate the repository organization:

- Check that all artifacts are in correct locations
- Verify naming conventions are followed
- Check cross-references are valid
- Ensure documentation is up to date
```

## Best Practices

1. **Be specific**: Include full conversation context
2. **Review analysis**: Check recommendations before creating artifacts
3. **Use templates**: Always use templates for consistency
4. **Add cross-references**: Link related artifacts
5. **Update docs**: Keep documentation in sync
6. **Validate**: Test artifacts after creation

## See Also

- [Self-Improvement Workflow](docs/self-improvement-workflow.md)
- [Meta Processes Guide](docs/meta-processes.md)
- [Organization Guide](docs/organization.md)
- [Cursor Best Practices](docs/research/cursor-best-practices.md)
