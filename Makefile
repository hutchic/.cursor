.PHONY: help verify test clean check-deps docs

# Default target
.DEFAULT_GOAL := help

# Repository paths
REPO_ROOT := $(shell pwd)

# Colors for output
GREEN := \033[0;32m
YELLOW := \033[1;33m
BLUE := \033[0;34m
NC := \033[0m

help: ## Show this help message
	@echo "$(BLUE)Cursor meta-repository - Makefile$(NC)"
	@echo ""
	@echo "$(GREEN)Available targets:$(NC)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(YELLOW)%-15s$(NC) %s\n", $$1, $$2}'
	@echo ""

verify: ## Verify project structure (.cursor/ artifacts)
	@echo "$(BLUE)Verifying project structure...$(NC)"
	@test -d "$(REPO_ROOT)/.cursor" || (echo "$(YELLOW)✗$(NC) .cursor/ not found"; exit 1)
	@test -d "$(REPO_ROOT)/.cursor/commands" || (echo "$(YELLOW)✗$(NC) .cursor/commands/ not found"; exit 1)
	@test -d "$(REPO_ROOT)/.cursor/skills" || (echo "$(YELLOW)✗$(NC) .cursor/skills/ not found"; exit 1)
	@test -d "$(REPO_ROOT)/.cursor/agents" || (echo "$(YELLOW)✗$(NC) .cursor/agents/ not found"; exit 1)
	@echo "$(GREEN)✓$(NC) Project structure OK"

test: verify ## Alias for verify

clean: ## Remove build artifacts and temporary files
	@echo "$(BLUE)Cleaning temporary files...$(NC)"
	@find . -type f -name "*.pyc" -delete
	@find . -type d -name "__pycache__" -delete
	@find . -type f -name ".DS_Store" -delete
	@echo "$(GREEN)Clean complete!$(NC)"

update: ## Pull latest changes from repository
	@echo "$(BLUE)Updating from repository...$(NC)"
	@git pull origin main
	@echo "$(GREEN)Update complete!$(NC)"

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
		echo "$(YELLOW)✗$(NC) gh:  not found (optional)"; \
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
