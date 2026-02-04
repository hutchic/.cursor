# Cursor Documentation Cache

This directory contains cached copies of Cursor IDE documentation to prevent issues when external URLs are blocked by firewall rules.

## Purpose

When AI agents or CI systems work on this repository, they may need to reference Cursor IDE documentation. However, firewall rules can block access to cursor.com. This cache provides local copies as a fallback.

## Cached Resources

### Commands Documentation

- **Source**: <https://cursor.com/docs/context/commands>
- **Local**: Available at `/tmp/cursor-docs/commands.html` (fetched during setup steps)
- **Content**: Documentation about Cursor IDE command structure and usage

### Agent Best Practices

- **Source**: <https://cursor.com/blog/agent-best-practices>
- **Local**: Available at `/tmp/cursor-docs/agent-best-practices.html` (fetched during setup steps)
- **Content**: Best practices for developing with Cursor AI agents

## Setup

The `.github/workflows/copilot-setup-steps.yml` workflow automatically fetches these documents before the firewall is enabled, making them available to AI agents during their execution.

## Fallback Strategy

1. **Primary**: Use internal repository documentation in `.cursor/COMMAND_DEVELOPMENT_GUIDE.md`
2. **Secondary**: Check `/tmp/cursor-docs/` for cached external documentation
3. **Tertiary**: Reference external URLs directly (may be blocked)

## Internal Documentation

This repository maintains comprehensive internal documentation that covers Cursor IDE command development:

- `.cursor/COMMAND_DEVELOPMENT_GUIDE.md` - Complete guide for command development
- `.cursor/skills/command-development.md` - AI context for command development
- `.cursor/commands/README.md` - Overview of available commands
- `AGENTS.md` - Automation agents and workflows

These internal docs are preferred over external resources as they are always available and specific to this repository's conventions.
