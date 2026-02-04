#!/usr/bin/env bash
# -*- coding: utf-8 -*-
# vim: set ft=bash:
#
# setup.sh - Interactive Cursor Commands & Skills Installer
#
# Description:
#   Installs Cursor commands and skills globally to ~/.cursor/
#   Provides interactive guidance and dependency checking
#
# Usage:
#   ./scripts/setup.sh                    # Interactive mode
#   ./scripts/setup.sh --non-interactive  # Skip all prompts
#   ./scripts/setup.sh --install-deps     # Auto-install dependencies
#   ./scripts/setup.sh --help             # Show help

set -euo pipefail

# Script directory and repository root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Configuration
NON_INTERACTIVE=false
INSTALL_DEPS=false
CURSOR_DIR="${HOME}/.cursor"
COMMANDS_DIR="${CURSOR_DIR}/commands"
SKILLS_DIR="${CURSOR_DIR}/skills"

# Counters
WARNINGS=0
ERRORS=0

# Helper functions
print_header() {
    echo -e "\n${BOLD}${BLUE}===================================================================${NC}"
    echo -e "${BOLD}${BLUE}$1${NC}"
    echo -e "${BOLD}${BLUE}===================================================================${NC}\n"
}

print_section() {
    echo -e "\n${BOLD}${CYAN}>>> $1${NC}\n"
}

log_info() {
    echo -e "${BLUE}[INFO]${NC} $*"
}

log_success() {
    echo -e "${GREEN}[✓]${NC} $*"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $*"
    WARNINGS=$((WARNINGS + 1))
}

log_error() {
    echo -e "${RED}[✗ ERROR]${NC} $*"
    ERRORS=$((ERRORS + 1))
}

log_step() {
    echo -e "${CYAN}  →${NC} $*"
}

# Prompt for yes/no with default
prompt_yn() {
    local prompt="$1"
    local default="${2:-y}"

    if [ "$NON_INTERACTIVE" = true ]; then
        echo "$default"
        return 0
    fi

    local yn
    if [ "$default" = "y" ]; then
        read -r -p "$(echo -e "${prompt} ${GREEN}[Y/n]${NC}: ")" yn
        yn=${yn:-y}
    else
        read -r -p "$(echo -e "${prompt} ${RED}[y/N]${NC}: ")" yn
        yn=${yn:-n}
    fi

    echo "$yn"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Usage information
usage() {
    cat <<EOF
${BOLD}Cursor Commands & Skills Installer${NC}

Interactive script to install Cursor automation globally.

${BOLD}Usage:${NC}
  $0 [OPTIONS]

${BOLD}Options:${NC}
  --non-interactive    Skip all prompts, assume defaults
  --install-deps       Automatically install missing dependencies
  --help              Show this help message

${BOLD}Examples:${NC}
  $0                              # Interactive installation
  $0 --non-interactive            # Automated installation
  $0 --install-deps               # Auto-install dependencies
  $0 --non-interactive --install-deps  # Fully automated

${BOLD}What this script does:${NC}
  1. Checks system requirements
  2. Verifies dependencies (git, gh, etc.)
  3. Creates ~/.cursor/ directories
  4. Symlinks commands to ~/.cursor/commands/
  5. Symlinks skills to ~/.cursor/skills/
  6. Verifies installation
  7. Provides next steps

EOF
}

# Parse command-line arguments
parse_args() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --non-interactive)
                NON_INTERACTIVE=true
                shift
                ;;
            --install-deps)
                INSTALL_DEPS=true
                shift
                ;;
            -h|--help)
                usage
                exit 0
                ;;
            *)
                log_error "Unknown option: $1"
                usage
                exit 1
                ;;
        esac
    done
}

# Check system requirements
check_requirements() {
    print_section "Checking System Requirements"

    local all_ok=true

    # Check Git
    if command_exists git; then
        local git_version=$(git --version | awk '{print $3}')
        log_success "Git installed: v${git_version}"
    else
        log_error "Git is not installed"
        log_step "Install from: https://git-scm.com/downloads"
        all_ok=false
    fi

    # Check Bash version
    if [ -n "${BASH_VERSION}" ]; then
        log_success "Bash installed: v${BASH_VERSION}"
    else
        log_error "Bash is not available"
        all_ok=false
    fi

    # Check platform
    local platform=$(uname -s)
    case "$platform" in
        Linux*)
            log_success "Platform: Linux"
            ;;
        Darwin*)
            log_success "Platform: macOS"
            ;;
        MINGW*|MSYS*|CYGWIN*)
            log_success "Platform: Windows (Git Bash/MSYS)"
            log_warning "Windows may require Developer Mode for symlinks"
            log_step "See: INSTALL.md#windows for details"
            ;;
        *)
            log_warning "Unknown platform: $platform"
            ;;
    esac

    if [ "$all_ok" = false ]; then
        log_error "Required tools are missing. Please install them and try again."
        return 1
    fi

    return 0
}

# Check optional dependencies
check_dependencies() {
    print_section "Checking Optional Dependencies"

    # GitHub CLI
    if command_exists gh; then
        local gh_version=$(gh --version | head -n1 | awk '{print $3}')
        log_success "GitHub CLI installed: v${gh_version}"

        # Check auth status
        if gh auth status &>/dev/null; then
            log_success "GitHub CLI authenticated"
        else
            log_warning "GitHub CLI not authenticated"
            log_step "Run: gh auth login"
        fi
    else
        log_warning "GitHub CLI (gh) not installed"
        log_step "Required for /gpr command"
        log_step "Install from: https://cli.github.com/"

        if [ "$INSTALL_DEPS" = true ]; then
            install_gh_cli
        elif [ "$NON_INTERACTIVE" = false ]; then
            local response=$(prompt_yn "Would you like installation instructions for GitHub CLI?" "y")
            if [[ "$response" =~ ^[Yy] ]]; then
                show_gh_install_instructions
            fi
        fi
    fi

    # Python
    if command_exists python3; then
        local py_version=$(python3 --version | awk '{print $2}')
        log_success "Python 3 installed: v${py_version}"
    else
        log_warning "Python 3 not installed"
        log_step "Recommended for pre-commit hooks (if contributing)"
    fi

    # pre-commit
    if command_exists pre-commit; then
        local pc_version=$(pre-commit --version | awk '{print $2}')
        log_success "pre-commit installed: v${pc_version}"
    else
        log_warning "pre-commit not installed"
        log_step "Recommended if contributing to this repository"
        log_step "Install with: pip3 install pre-commit"
    fi

    echo ""
}

# Show GitHub CLI installation instructions
show_gh_install_instructions() {
    echo ""
    log_info "GitHub CLI Installation Instructions:"
    echo ""

    case "$(uname -s)" in
        Darwin*)
            echo "  macOS (Homebrew):"
            echo "    brew install gh"
            ;;
        Linux*)
            if [ -f /etc/debian_version ]; then
                echo "  Ubuntu/Debian:"
                echo "    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg"
                echo "    echo \"deb [arch=\$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main\" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null"
                echo "    sudo apt update && sudo apt install gh"
            elif [ -f /etc/redhat-release ]; then
                echo "  Fedora/RHEL/CentOS:"
                echo "    sudo dnf install gh"
            else
                echo "  Linux:"
                echo "    See: https://github.com/cli/cli/blob/trunk/docs/install_linux.md"
            fi
            ;;
        MINGW*|MSYS*|CYGWIN*)
            echo "  Windows:"
            echo "    winget install GitHub.cli"
            echo "    # Or with scoop: scoop install gh"
            echo "    # Or with chocolatey: choco install gh"
            ;;
        *)
            echo "  See: https://cli.github.com/"
            ;;
    esac

    echo ""
    echo "  After installation, authenticate with:"
    echo "    gh auth login"
    echo ""
}

# Install GitHub CLI (basic attempt)
install_gh_cli() {
    print_section "Installing GitHub CLI"

    case "$(uname -s)" in
        Darwin*)
            if command_exists brew; then
                log_info "Installing via Homebrew..."
                brew install gh
                log_success "GitHub CLI installed"
            else
                log_warning "Homebrew not found. Please install manually."
                show_gh_install_instructions
            fi
            ;;
        Linux*)
            if command_exists apt-get; then
                log_info "Installing via apt..."
                curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
                echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
                sudo apt update && sudo apt install -y gh
                log_success "GitHub CLI installed"
            elif command_exists dnf; then
                log_info "Installing via dnf..."
                sudo dnf install -y gh
                log_success "GitHub CLI installed"
            else
                log_warning "Package manager not recognized. Please install manually."
                show_gh_install_instructions
            fi
            ;;
        *)
            log_warning "Automatic installation not supported on this platform"
            show_gh_install_instructions
            ;;
    esac
}

# Create directories
create_directories() {
    print_section "Creating Cursor Directories"

    # Create main directory
    if [ -d "$CURSOR_DIR" ]; then
        log_info "Directory exists: $CURSOR_DIR"
    else
        log_step "Creating: $CURSOR_DIR"
        mkdir -p "$CURSOR_DIR"
        log_success "Created: $CURSOR_DIR"
    fi

    # Create commands directory
    if [ -d "$COMMANDS_DIR" ]; then
        log_info "Directory exists: $COMMANDS_DIR"
    else
        log_step "Creating: $COMMANDS_DIR"
        mkdir -p "$COMMANDS_DIR"
        log_success "Created: $COMMANDS_DIR"
    fi

    # Create skills directory
    if [ -d "$SKILLS_DIR" ]; then
        log_info "Directory exists: $SKILLS_DIR"
    else
        log_step "Creating: $SKILLS_DIR"
        mkdir -p "$SKILLS_DIR"
        log_success "Created: $SKILLS_DIR"
    fi

    echo ""
}

# Install commands
install_commands() {
    print_section "Installing Commands"

    local source_dir="${REPO_ROOT}/cursor/commands"

    if [ ! -d "$source_dir" ]; then
        log_error "Source directory not found: $source_dir"
        return 1
    fi

    local count=0
    for cmd in "$source_dir"/*; do
        if [ -f "$cmd" ]; then
            local cmd_name=$(basename "$cmd")
            local target="${COMMANDS_DIR}/${cmd_name}"

            # Create or update symlink
            ln -sf "$cmd" "$target"
            log_step "Linked: $cmd_name"
            count=$((count + 1))
        fi
    done

    if [ $count -eq 0 ]; then
        log_warning "No commands found in $source_dir"
    else
        log_success "Installed $count command(s)"
    fi

    echo ""
}

# Install skills
install_skills() {
    print_section "Installing Skills"

    local source_dir="${REPO_ROOT}/cursor/skills"

    if [ ! -d "$source_dir" ]; then
        log_error "Source directory not found: $source_dir"
        return 1
    fi

    local count=0
    for skill in "$source_dir"/*; do
        if [ -f "$skill" ] || [ -d "$skill" ]; then
            local skill_name=$(basename "$skill")

            # Skip README files in root
            if [[ "$skill_name" == "README.md" ]]; then
                continue
            fi

            local target="${SKILLS_DIR}/${skill_name}"

            # Create or update symlink
            ln -sf "$skill" "$target"
            log_step "Linked: $skill_name"
            count=$((count + 1))
        fi
    done

    if [ $count -eq 0 ]; then
        log_info "No skills found (this is normal if none are defined yet)"
    else
        log_success "Installed $count skill(s)"
    fi

    echo ""
}

# Verify installation
verify_installation() {
    print_section "Verifying Installation"

    local verification_passed=true

    # Check commands directory
    if [ -d "$COMMANDS_DIR" ] && [ "$(ls -A "$COMMANDS_DIR" 2>/dev/null)" ]; then
        log_success "Commands directory populated"
        log_step "Location: $COMMANDS_DIR"
        log_step "Commands: $(ls -1 "$COMMANDS_DIR" | wc -l)"
    else
        log_error "Commands directory is empty"
        verification_passed=false
    fi

    # Check skills directory
    if [ -d "$SKILLS_DIR" ]; then
        log_success "Skills directory exists"
        log_step "Location: $SKILLS_DIR"
        local skill_count=$(ls -1 "$SKILLS_DIR" 2>/dev/null | wc -l)
        log_step "Skills: $skill_count"
    else
        log_error "Skills directory missing"
        verification_passed=false
    fi

    # Check symlinks are valid
    local broken_links=0
    for link in "$COMMANDS_DIR"/* "$SKILLS_DIR"/*; do
        if [ -L "$link" ] && [ ! -e "$link" ]; then
            log_warning "Broken symlink: $link"
            broken_links=$((broken_links + 1))
        fi
    done

    if [ $broken_links -eq 0 ]; then
        log_success "All symlinks valid"
    else
        log_warning "$broken_links broken symlink(s) found"
        verification_passed=false
    fi

    # Run test script if available
    local test_script="${REPO_ROOT}/scripts/test_cursor_config.sh"
    if [ -f "$test_script" ] && [ -x "$test_script" ]; then
        echo ""
        log_info "Running verification tests..."
        if bash "$test_script"; then
            log_success "All verification tests passed"
        else
            log_warning "Some verification tests failed"
            verification_passed=false
        fi
    fi

    echo ""

    if [ "$verification_passed" = true ]; then
        return 0
    else
        return 1
    fi
}

# Show next steps
show_next_steps() {
    print_header "Installation Complete!"

    echo -e "${BOLD}Next Steps:${NC}\n"

    echo "1. ${BOLD}Test in Cursor IDE:${NC}"
    echo "   - Open Cursor IDE"
    echo "   - Open any project"
    echo "   - Type '/' in chat or command input"
    echo "   - You should see: /gadd, /gship, /gpr"
    echo ""

    echo "2. ${BOLD}Authenticate GitHub CLI (if not done):${NC}"
    echo "   gh auth login"
    echo ""

    echo "3. ${BOLD}Read Command Documentation:${NC}"
    echo "   - See: ${REPO_ROOT}/cursor/commands/"
    echo "   - /gadd - Smart git staging"
    echo "   - /gship - Branch + commit + PR workflow"
    echo "   - /gpr - Create/update pull requests"
    echo ""

    echo "4. ${BOLD}Stay Updated:${NC}"
    echo "   cd ${REPO_ROOT}"
    echo "   git pull origin main"
    echo "   # Symlinks automatically use updated commands"
    echo ""

    if [ $WARNINGS -gt 0 ]; then
        echo -e "${YELLOW}⚠ Installation completed with $WARNINGS warning(s)${NC}"
        echo "  Review warnings above for potential issues"
        echo ""
    fi

    echo -e "${BOLD}Documentation:${NC}"
    echo "  - Full guide: ${REPO_ROOT}/INSTALL.md"
    echo "  - Troubleshooting: ${REPO_ROOT}/README.md#troubleshooting"
    echo "  - Contributing: ${REPO_ROOT}/CONTRIBUTING.md"
    echo ""

    echo -e "${GREEN}${BOLD}Happy coding with Cursor! 🚀${NC}\n"
}

# Show error summary
show_error_summary() {
    print_header "Installation Failed"

    echo -e "${RED}Installation completed with $ERRORS error(s)${NC}\n"
    echo "Please review the errors above and:"
    echo "  1. Fix the issues mentioned"
    echo "  2. Run this script again"
    echo "  3. Or try manual installation: ${REPO_ROOT}/INSTALL.md"
    echo ""
    echo "For help, see:"
    echo "  - ${REPO_ROOT}/README.md#troubleshooting"
    echo "  - ${REPO_ROOT}/INSTALL.md#troubleshooting"
    echo "  - https://github.com/hutchic/.cursor/issues"
    echo ""
}

# Main installation flow
main() {
    parse_args "$@"

    print_header "Cursor Commands & Skills Installer"

    log_info "Repository: $REPO_ROOT"
    log_info "Install target: $CURSOR_DIR"

    if [ "$NON_INTERACTIVE" = true ]; then
        log_info "Mode: Non-interactive"
    fi

    if [ "$INSTALL_DEPS" = true ]; then
        log_info "Auto-install dependencies: Enabled"
    fi

    echo ""

    # Pre-installation checks
    if ! check_requirements; then
        show_error_summary
        exit 1
    fi

    check_dependencies

    # Confirm installation
    if [ "$NON_INTERACTIVE" = false ]; then
        local response=$(prompt_yn "Proceed with installation to $CURSOR_DIR?" "y")
        if [[ ! "$response" =~ ^[Yy] ]]; then
            log_info "Installation cancelled by user"
            exit 0
        fi
    fi

    # Perform installation
    create_directories
    install_commands
    install_skills

    # Verify
    if verify_installation; then
        show_next_steps
        exit 0
    else
        show_error_summary
        exit 1
    fi
}

# Run main function
main "$@"
