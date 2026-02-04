.PHONY: help install uninstall verify test clean

# Default target
.DEFAULT_GOAL := help

# Repository paths
REPO_ROOT := $(shell pwd)
CURSOR_DIR := $(HOME)/.cursor
COMMANDS_DIR := $(CURSOR_DIR)/commands
SKILLS_DIR := $(CURSOR_DIR)/skills

# Colors for output
GREEN := \033[0;32m
YELLOW := \033[1;33m
BLUE := \033[0;34m
NC := \033[0m

help: ## Show this help message
	@echo "$(BLUE)Cursor Commands & Skills - Makefile$(NC)"
	@echo ""
	@echo "$(GREEN)Available targets:$(NC)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(YELLOW)%-15s$(NC) %s\n", $$1, $$2}'
	@echo ""
	@echo "$(GREEN)Examples:$(NC)"
	@echo "  make install    # Install commands and skills globally"
	@echo "  make verify     # Verify installation"
	@echo "  make uninstall  # Remove global installation"
	@echo ""

install: ## Install commands and skills globally to ~/.cursor/
	@echo "$(BLUE)Installing Cursor commands and skills...$(NC)"
	@bash scripts/setup.sh --non-interactive
	@echo "$(GREEN)Installation complete!$(NC)"

install-interactive: ## Run interactive installation with prompts
	@bash scripts/setup.sh

install-deps: ## Install with automatic dependency installation
	@bash scripts/setup.sh --non-interactive --install-deps

uninstall: ## Remove commands and skills from ~/.cursor/
	@echo "$(YELLOW)Uninstalling Cursor commands and skills...$(NC)"
	@if [ -d "$(COMMANDS_DIR)" ]; then \
		echo "Removing: $(COMMANDS_DIR)/*"; \
		rm -f $(COMMANDS_DIR)/*; \
		echo "$(GREEN)Commands removed$(NC)"; \
	else \
		echo "$(YELLOW)Commands directory not found$(NC)"; \
	fi
	@if [ -d "$(SKILLS_DIR)" ]; then \
		echo "Removing: $(SKILLS_DIR)/*"; \
		rm -f $(SKILLS_DIR)/*; \
		echo "$(GREEN)Skills removed$(NC)"; \
	else \
		echo "$(YELLOW)Skills directory not found$(NC)"; \
	fi
	@echo "$(GREEN)Uninstallation complete!$(NC)"

verify: ## Verify installation is correct
	@echo "$(BLUE)Verifying installation...$(NC)"
	@bash scripts/test_cursor_config.sh || true
	@echo ""
	@if [ -d "$(COMMANDS_DIR)" ]; then \
		echo "$(GREEN)Commands directory:$(NC) $(COMMANDS_DIR)"; \
		ls -la $(COMMANDS_DIR); \
	else \
		echo "$(YELLOW)Commands directory not found$(NC)"; \
	fi
	@echo ""
	@if [ -d "$(SKILLS_DIR)" ]; then \
		echo "$(GREEN)Skills directory:$(NC) $(SKILLS_DIR)"; \
		ls -la $(SKILLS_DIR); \
	else \
		echo "$(YELLOW)Skills directory not found$(NC)"; \
	fi

test: verify ## Alias for verify

status: ## Show installation status
	@echo "$(BLUE)Installation Status:$(NC)"
	@echo ""
	@echo "Repository: $(REPO_ROOT)"
	@echo "Target:     $(CURSOR_DIR)"
	@echo ""
	@if [ -d "$(CURSOR_DIR)" ]; then \
		echo "$(GREEN)✓$(NC) ~/.cursor/ exists"; \
	else \
		echo "$(YELLOW)✗$(NC) ~/.cursor/ not found"; \
	fi
	@if [ -d "$(COMMANDS_DIR)" ] && [ "$$(ls -A $(COMMANDS_DIR) 2>/dev/null)" ]; then \
		echo "$(GREEN)✓$(NC) Commands installed: $$(ls -1 $(COMMANDS_DIR) | wc -l)"; \
	else \
		echo "$(YELLOW)✗$(NC) No commands installed"; \
	fi
	@if [ -d "$(SKILLS_DIR)" ]; then \
		echo "$(GREEN)✓$(NC) Skills directory exists: $$(ls -1 $(SKILLS_DIR) 2>/dev/null | wc -l) item(s)"; \
	else \
		echo "$(YELLOW)✗$(NC) Skills directory not found"; \
	fi
	@echo ""
	@if command -v gh >/dev/null 2>&1; then \
		echo "$(GREEN)✓$(NC) GitHub CLI installed: $$(gh --version | head -n1)"; \
	else \
		echo "$(YELLOW)✗$(NC) GitHub CLI not installed"; \
	fi

clean: ## Remove build artifacts and temporary files
	@echo "$(BLUE)Cleaning temporary files...$(NC)"
	@find . -type f -name "*.pyc" -delete
	@find . -type d -name "__pycache__" -delete
	@find . -type f -name ".DS_Store" -delete
	@echo "$(GREEN)Clean complete!$(NC)"

update: ## Update commands from repository (pull latest changes)
	@echo "$(BLUE)Updating from repository...$(NC)"
	@git pull origin main
	@echo "$(GREEN)Update complete! Symlinks automatically use updated commands.$(NC)"

docs: ## Open documentation in browser
	@echo "$(BLUE)Opening documentation...$(NC)"
	@if command -v open >/dev/null 2>&1; then \
		open README.md; \
	elif command -v xdg-open >/dev/null 2>&1; then \
		xdg-open README.md; \
	else \
		echo "$(YELLOW)Please manually open: $(REPO_ROOT)/README.md$(NC)"; \
	fi

check-deps: ## Check for required dependencies
	@echo "$(BLUE)Checking dependencies...$(NC)"
	@echo ""
	@if command -v git >/dev/null 2>&1; then \
		echo "$(GREEN)✓$(NC) git: $$(git --version)"; \
	else \
		echo "$(YELLOW)✗$(NC) git: not found"; \
	fi
	@if command -v gh >/dev/null 2>&1; then \
		echo "$(GREEN)✓$(NC) gh:  $$(gh --version | head -n1)"; \
		if gh auth status >/dev/null 2>&1; then \
			echo "  $(GREEN)✓$(NC) Authenticated"; \
		else \
			echo "  $(YELLOW)✗$(NC) Not authenticated - run: gh auth login"; \
		fi; \
	else \
		echo "$(YELLOW)✗$(NC) gh:  not found (required for /gpr command)"; \
	fi
	@if command -v python3 >/dev/null 2>&1; then \
		echo "$(GREEN)✓$(NC) python3: $$(python3 --version)"; \
	else \
		echo "$(YELLOW)✗$(NC) python3: not found (optional)"; \
	fi
	@if command -v pre-commit >/dev/null 2>&1; then \
		echo "$(GREEN)✓$(NC) pre-commit: $$(pre-commit --version)"; \
	else \
		echo "$(YELLOW)✗$(NC) pre-commit: not found (optional, for contributors)"; \
	fi
	@echo ""

reinstall: uninstall install ## Uninstall and reinstall everything

.PHONY: install-interactive install-deps status update docs check-deps reinstall
