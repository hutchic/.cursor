#!/usr/bin/env bash
#
# Install the self-improvement bundle from this repo into a target project by
# copying files (no symlinks). The target stays self-contained and portable.
# Run from this repo: ./scripts/install-self-improvement.sh [TARGET_DIR]
#
set -euo pipefail

# Resolve script dir and repo root (parent of scripts/)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

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

# Required bundle paths under repo (relative to REPO_ROOT)
REQUIRED_CURSOR_DIRS=(
  ".cursor/rules/meta"
  ".cursor/skills/meta"
  ".cursor/commands/meta"
  ".cursor/agents/meta"
  ".cursor/templates"
)
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

# Copy directory: remove existing dest if present, then cp -r
copy_dir() {
  local src="$1"
  local dest="$2"
  if [[ -e "$dest" ]]; then
    rm -rf "$dest"
  fi
  mkdir -p "$(dirname "$dest")"
  cp -r "$src" "$dest"
}

# Copy file: mkdir -p parent, cp
copy_file() {
  local src="$1"
  local dest="$2"
  mkdir -p "$(dirname "$dest")"
  cp "$src" "$dest"
}

main() {
  local target_raw="${1:-}"
  local target_path
  local include_optional_docs=false

  echo "Self-improvement bundle installer"
  echo "  Repo: $REPO_ROOT"
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

  if ! prompt_yn "Include optional docs (cursor-best-practices, ai-agent-patterns, skills-commands-patterns)?" 1; then
    include_optional_docs=false
  else
    include_optional_docs=true
  fi

  # Build list of paths we will copy
  local all_cursor_dirs=("${REQUIRED_CURSOR_DIRS[@]}")
  local all_docs=("${REQUIRED_DOCS[@]}")
  if [[ "$include_optional_docs" == true ]]; then
    all_docs+=("${OPTIONAL_DOCS[@]}")
  fi

  # Check for existing paths
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
  echo "  .cursor/rules/meta, skills/meta, commands/meta, agents/meta, templates"
  echo "  Required docs (8 files)"
  if [[ "$include_optional_docs" == true ]]; then
    echo "  Optional docs (3 files)"
  fi
  echo ""
  if ! prompt_yn "Continue?" 0; then
    echo "Aborted."
    exit 0
  fi

  # Copy .cursor dirs
  for d in "${all_cursor_dirs[@]}"; do
    if [[ "$d" == ".cursor/templates" ]]; then
      mkdir -p "$target_path/.cursor/templates"
      cp -r "$REPO_ROOT/.cursor/templates"/* "$target_path/.cursor/templates/"
    else
      copy_dir "$REPO_ROOT/$d" "$target_path/$d"
    fi
  done

  # Copy docs
  for f in "${all_docs[@]}"; do
    copy_file "$REPO_ROOT/$f" "$target_path/$f"
  done

  echo ""
  echo "Done. Bundle installed into: $target_path"
  echo "The target project is self-contained and safe to clone elsewhere."
  echo ""
  echo "Commands available: /process-chat, /create-artifact, /update-cross-references, /validate-organization, /generate-docs-index"
  echo "See docs/self-improvement-workflow.md and docs/meta-processes.md in the target project."
}

main "$@"
