#!/usr/bin/env bash
#
# Install the self-improvement bundle from this repo into a target project by
# copying files (no symlinks). The target stays self-contained and portable.
# Run from this repo: ./scripts/install-self-improvement.sh [TARGET_DIR]
# Use --dry-run to print what would be installed without writing files.
#
set -euo pipefail

# Resolve script dir and repo root (parent of scripts/)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

DRY_RUN=0
if [[ "${1:-}" == "--dry-run" ]]; then
  DRY_RUN=1
  shift
fi

# Expand leading ~ to HOME (bash does not expand ~ when it's in a variable)
expand_tilde() {
  local path="$1"
  if [[ "$path" == '~'* ]]; then
    printf '%s%s' "$HOME" "${path:1}"
  else
    printf '%s' "$path"
  fi
}

# Resolve absolute path for target (realpath when available, else cd+pwd)
abs_path() {
  local path
  path="$(expand_tilde "$1")"
  if command -v realpath &>/dev/null; then
    realpath "$path"
  else
    (cd "$path" && pwd)
  fi
}

# Required bundle paths under repo (relative to REPO_ROOT) - must exist for check_repo
REQUIRED_CURSOR_DIRS=(
  ".cursor/rules/meta"
  ".cursor/skills/meta"
  ".cursor/commands/meta"
  ".cursor/agents/meta"
  ".cursor/templates"
)
# Optional: hooks (if present in repo)
CURSOR_HOOKS=".cursor/hooks"
CURSOR_HOOKS_JSON=".cursor/hooks.json"
REQUIRED_DOCS=(
  "docs/self-improvement-workflow.md"
  "docs/meta-processes.md"
  "docs/organization.md"
  "docs/research/cursor-hooks.md"
  "docs/cursor-rules.md"
  "docs/cursor-commands.md"
  "docs/cursor-skills.md"
  "docs/cursor-subagents.md"
)
OPTIONAL_DOCS=(
  "docs/research/cursor-best-practices.md"
  "docs/research/ai-agent-patterns.md"
  "docs/research/skills-commands-patterns.md"
)

# Prompt for yes/no; default_no: 1 = default N, 0 = default Y
prompt_yn() {
  local prompt="$1"
  local default_no="${2:-0}"
  local reply
  if [[ "$default_no" -eq 1 ]]; then
    read -r -p "${prompt} [y/N]: " reply
  else
    read -r -p "${prompt} [Y/n]: " reply
  fi
  reply="${reply:- }"
  if [[ "$default_no" -eq 1 ]]; then
    [[ "${reply^^}" == "Y" || "${reply^^}" == "YES" ]]
  else
    [[ "${reply^^}" != "N" && "${reply^^}" != "NO" ]]
  fi
}

# Check repo has bundle
check_repo() {
  local missing=()
  for d in "${REQUIRED_CURSOR_DIRS[@]}"; do
    [[ -d "$REPO_ROOT/$d" ]] || missing+=("$d")
  done
  for f in "${REQUIRED_DOCS[@]}"; do
    [[ -f "$REPO_ROOT/$f" ]] || missing+=("$f")
  done
  if [[ ${#missing[@]} -gt 0 ]]; then
    echo "Error: This repository is missing required bundle paths:" >&2
    printf '  %s\n' "${missing[@]}" >&2
    exit 1
  fi
}

# Check target is valid and not this repo
check_target() {
  local target="$1"
  if [[ ! -d "$target" ]]; then
    echo "Error: Target is not a directory: $target" >&2
    exit 1
  fi
  local target_abs
  target_abs="$(abs_path "$target")"
  local repo_abs
  repo_abs="$(abs_path "$REPO_ROOT")"
  if [[ "$target_abs" == "$repo_abs" ]]; then
    echo "Error: Target cannot be this repository." >&2
    exit 1
  fi
  # Target inside repo (e.g. repo/some/subdir)
  if [[ "$target_abs" == "$repo_abs"* ]]; then
    echo "Error: Target cannot be inside this repository." >&2
    exit 1
  fi
}

# Return 0 if any of the given paths exist in target
any_exist_in_target() {
  local target="$1"
  shift
  local paths=("$@")
  for p in "${paths[@]}"; do
    [[ -e "$target/$p" ]] && return 0
  done
  return 1
}

# Copy directory: remove existing dest if present, then cp -r (no-op if DRY_RUN)
copy_dir() {
  local src="$1"
  local dest="$2"
  if [[ "$DRY_RUN" -eq 1 ]]; then
    echo "Would copy dir: $src -> $dest"
    return
  fi
  if [[ -e "$dest" ]]; then
    rm -rf "$dest"
  fi
  mkdir -p "$(dirname "$dest")"
  cp -r "$src" "$dest"
}

# Copy file: mkdir -p parent, cp (no-op if DRY_RUN)
copy_file() {
  local src="$1"
  local dest="$2"
  if [[ "$DRY_RUN" -eq 1 ]]; then
    echo "Would copy file: $src -> $dest"
    return
  fi
  mkdir -p "$(dirname "$dest")"
  cp "$src" "$dest"
}

main() {
  local target_raw="${1:-}"
  local target_path
  local include_optional_docs=false
  local install_rules=true
  local install_hooks=false
  local install_subagents=true

  echo "Self-improvement bundle installer"
  echo "  Repo: $REPO_ROOT"
  if [[ "$DRY_RUN" -eq 1 ]]; then
    echo "  Mode: --dry-run (no files will be written)"
  fi
  echo ""

  check_repo

  if [[ -z "$target_raw" ]]; then
    read -r -p "Path to project to install the bundle into (default: current directory): " target_raw
    target_raw="${target_raw:-.}"
  fi

  target_path="$(abs_path "$target_raw")"
  check_target "$target_path"

  echo "  Target: $target_path"
  echo ""

  if prompt_yn "Install rules from this repo into target's .cursor/rules/?" 0; then
    install_rules=true
  else
    install_rules=false
  fi
  if [[ -d "$REPO_ROOT/$CURSOR_HOOKS" || -f "$REPO_ROOT/$CURSOR_HOOKS_JSON" ]]; then
    if prompt_yn "Install hooks (e.g. .cursor/hooks, hooks.json) into target?" 1; then
      install_hooks=true
    fi
  fi
  if prompt_yn "Install subagents (agents) into target's .cursor/agents/?" 0; then
    install_subagents=true
  else
    install_subagents=false
  fi
  if ! prompt_yn "Include optional docs (cursor-best-practices, ai-agent-patterns, skills-commands-patterns)?" 1; then
    include_optional_docs=false
  else
    include_optional_docs=true
  fi

  # Build list of paths we will copy
  local all_cursor_dirs=()
  all_cursor_dirs+=(".cursor/skills/meta" ".cursor/commands/meta" ".cursor/templates")
  [[ "$install_rules" == true ]] && all_cursor_dirs+=(".cursor/rules/meta")
  [[ "$install_subagents" == true ]] && all_cursor_dirs+=(".cursor/agents/meta")
  [[ "$install_hooks" == true && -d "$REPO_ROOT/$CURSOR_HOOKS" ]] && all_cursor_dirs+=("$CURSOR_HOOKS")
  [[ "$install_hooks" == true && -f "$REPO_ROOT/$CURSOR_HOOKS_JSON" ]] && all_cursor_dirs+=("$CURSOR_HOOKS_JSON")

  local all_docs=("${REQUIRED_DOCS[@]}")
  if [[ "$include_optional_docs" == true ]]; then
    all_docs+=("${OPTIONAL_DOCS[@]}")
  fi

  # Check for existing paths (only among paths we will copy)
  local existing_cursor=()
  local existing_docs=()
  for d in "${all_cursor_dirs[@]}"; do
    [[ -e "$target_path/$d" ]] && existing_cursor+=("$d")
  done
  for f in "${all_docs[@]}"; do
    [[ -e "$target_path/$f" ]] && existing_docs+=("$f")
  done

  if [[ ${#existing_cursor[@]} -gt 0 || ${#existing_docs[@]} -gt 0 ]]; then
    echo ""
    echo "Existing bundle paths found in target:"
    printf '  %s\n' "${existing_cursor[@]}" "${existing_docs[@]}"
    if ! prompt_yn "Overwrite all?" 1; then
      echo "Aborted."
      exit 0
    fi
    echo ""
  fi

  echo "Will copy:"
  echo "  .cursor/skills/meta, commands/meta, templates"
  [[ "$install_rules" == true ]] && echo "  .cursor/rules/meta"
  [[ "$install_subagents" == true ]] && echo "  .cursor/agents/meta"
  [[ "$install_hooks" == true ]] && echo "  .cursor/hooks (and/or hooks.json if present)"
  echo "  Required docs (8 files)"
  if [[ "$include_optional_docs" == true ]]; then
    echo "  Optional docs (3 files)"
  fi
  echo ""
  if ! prompt_yn "Continue?" 0; then
    echo "Aborted."
    exit 0
  fi

  # Copy .cursor dirs and files
  for d in "${all_cursor_dirs[@]}"; do
    if [[ "$d" == ".cursor/templates" ]]; then
      if [[ "$DRY_RUN" -eq 1 ]]; then
        echo "Would copy dir: $REPO_ROOT/.cursor/templates/* -> $target_path/.cursor/templates/"
      else
        mkdir -p "$target_path/.cursor/templates"
        cp -r "$REPO_ROOT/.cursor/templates"/* "$target_path/.cursor/templates/"
      fi
    elif [[ -f "$REPO_ROOT/$d" ]]; then
      copy_file "$REPO_ROOT/$d" "$target_path/$d"
    else
      copy_dir "$REPO_ROOT/$d" "$target_path/$d"
    fi
  done

  # Copy docs
  for f in "${all_docs[@]}"; do
    copy_file "$REPO_ROOT/$f" "$target_path/$f"
  done

  echo ""
  if [[ "$DRY_RUN" -eq 1 ]]; then
    echo "Dry run complete. No files were written."
  else
    echo "Done. Bundle installed into: $target_path"
    echo "The target project is self-contained and safe to clone elsewhere."
    echo ""
    echo "Commands available: /process-chat, /create-artifact, /update-cross-references, /validate-organization, /generate-docs-index"
    echo "See docs/self-improvement-workflow.md and docs/meta-processes.md in the target project."
  fi
}

main "$@"
