# Contributing Guidelines

Thank you for contributing to this project! This document outlines the standards and conventions we follow.

## Pull Request Titles

### Requirements

All pull request titles **MUST** be:

1. **Semantic**: Follow [Conventional Commits](https://www.conventionalcommits.org/) format
2. **Terse**: Minimal and direct (ideally under 50 characters)
3. **Descriptive**: Clearly summarize the essence of the change

### Format

```
<type>(<scope>): <description>
```

- **type**: The kind of change (required)
- **scope**: The area affected (optional but recommended)
- **description**: Brief summary in imperative mood (required)

### Types

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style/formatting (not CSS)
- `refactor`: Code refactoring without functional changes
- `perf`: Performance improvements
- `test`: Adding or modifying tests
- `chore`: Maintenance tasks, dependency updates
- `ci`: CI/CD configuration changes
- `build`: Build system or dependencies
- `revert`: Reverting previous changes

### Examples

#### ✅ Good Titles (Terse and Semantic)

```
feat(api): add user search endpoint
fix(auth): resolve token expiry bug
docs(readme): update installation steps
refactor(parser): simplify token handling
chore(deps): update dependencies
ci(workflow): add caching for builds
test(api): add search endpoint tests
perf(query): optimize database indexes
style: enforce consistent indentation
build(docker): update base image to alpine
```

#### ❌ Bad Titles (Non-semantic, Verbose, or Vague)

```
Added new feature                          # Not semantic, vague
Update files                               # Too vague
Fixed a bug in the authentication module   # Too verbose
WIP: Working on search functionality       # Not descriptive of final state
Updated the README.md file with new installation instructions and troubleshooting steps  # Too verbose
Changes                                    # Meaningless
Improvements                               # Too vague
```

### Best Practices

1. **Be specific**: `fix(auth): resolve token expiry` not `fix: bug fix`
2. **Use imperative mood**: `add` not `added` or `adds`
3. **Keep it short**: Aim for under 50 characters
4. **Skip periods**: No period at the end
5. **Use lowercase**: Start description with lowercase
6. **Add scope when helpful**: Helps identify affected areas

### Scope Guidelines

Scopes help identify which part of the codebase is affected:

- `api`: API endpoints and handlers
- `auth`: Authentication/authorization
- `db`: Database schema or queries
- `ui`: User interface components
- `cli`: Command-line interface
- `deps`: Dependencies
- `docker`: Docker configuration
- `docs`: Documentation
- `config`: Configuration files
- `workflow`: GitHub Actions workflows

Scopes are optional but highly recommended for clarity.

### For AI Agents

**CRITICAL**: AI agents creating pull requests MUST follow these title requirements:

1. **Always use Conventional Commits format**
2. **Keep titles terse** (under 50 characters when possible)
3. **Use descriptive, specific language**
4. **Avoid generic titles** like "Update files" or "Changes"
5. **Choose the correct type** based on the nature of the change

#### AI Agent Examples

When an AI agent makes changes to:

- Add a new feature → `feat(component): add error handling`
- Fix a bug → `fix(parser): resolve off-by-one error`
- Update documentation → `docs(api): clarify authentication flow`
- Refactor code → `refactor(utils): simplify date formatting`
- Update dependencies → `chore(deps): update lodash to 4.17.21`

### Rationale

**Why semantic titles matter:**

- **Automation**: Tools can parse and categorize changes
- **Changelog generation**: Automatic release notes
- **Quick understanding**: Reviewers immediately know the change type
- **Searchability**: Easy to find specific types of changes
- **Consistency**: Uniform format across all contributors

**Why terse titles matter:**

- **Readability**: Easier to scan PR lists
- **Git log clarity**: Better commit history
- **GitHub UI**: Fits better in limited UI space
- **Focus**: Forces clear, concise communication

### Validation

Pull request titles are validated automatically by GitHub Actions using the `amannn/action-semantic-pull-request` action. PRs with non-compliant titles will fail the `lint-pr-title` check.

## Code Style

See [.github/copilot-instructions.md](.github/copilot-instructions.md) for detailed coding standards.

## Pre-commit Hooks

All changes must pass pre-commit hooks before committing. See [.github/PRE_COMMIT_SETUP.md](.github/PRE_COMMIT_SETUP.md) for setup instructions.

## Testing

- Run tests before submitting PRs
- Add tests for new features
- Update tests when modifying behavior

## Documentation

- Update relevant documentation for code changes
- Keep README.md and other docs in sync with code
- Use clear, concise language

## Questions?

If you're unsure about anything, feel free to ask in the issue or pull request.
