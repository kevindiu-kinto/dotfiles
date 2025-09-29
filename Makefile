# Development Environment Makefile
# Essential Docker management commands

.PHONY: help build start stop clean rebuild logs shell ssh status rm

# Colors for output
BLUE := \033[0;34m
GREEN := \033[0;32m
YELLOW := \033[1;33m
RED := \033[0;31m
NC := \033[0m # No Color

# Default target
.DEFAULT_GOAL := help

# Show this help message
help:
	@echo ""
	@echo "🐳 Development Environment Commands"
	@echo "=================================="
	@echo ""
	@printf "\033[1;33mBasic Commands:\033[0m\n"
	@printf "  \033[0;34mbuild\033[0m      Build and start the development environment\n"
	@printf "  \033[0;34mstart\033[0m      Start existing containers\n"
	@printf "  \033[0;34mstop\033[0m       Stop containers\n"
	@echo ""
	@printf "\033[1;33mMaintenance:\033[0m\n"
	@printf "  \033[0;34mclean\033[0m          Clean cache and temporary data\n"
	@printf "  \033[0;34mrm\033[0m             Remove everything including volumes\n"
	@printf "  \033[0;34mrebuild\033[0m        Full rebuild without cache\n"
	@echo ""
	@printf "\033[1;33mAccess:\033[0m\n"
	@printf "  \033[0;34mshell\033[0m      Open shell in container\n"
	@printf "  \033[0;34mssh\033[0m        Connect via SSH (for VS Code)\n"
	@printf "  \033[0;34mlogs\033[0m       Show container logs\n"
	@printf "  \033[0;34mstatus\033[0m     Show container status\n"
	@echo ""

build:
	@echo "$(BLUE)[BUILD]$(NC) Building development environment..."
	@docker-compose build
	@$(MAKE) start
	@echo "$(GREEN)[SUCCESS]$(NC) Environment ready!"
	@echo "SSH: ssh dev@localhost -p 2222 (password: dev)"

start:
	@echo "$(BLUE)[START]$(NC) Starting containers..."
	@docker-compose up -d

# Stop containers
stop:
	@echo "$(BLUE)[STOP]$(NC) Stopping containers..."
	@docker-compose down

rebuild:
	@echo "$(BLUE)[REBUILD]$(NC) Force rebuilding without cache..."
	@docker-compose build --no-cache
	@$(MAKE) start
	@echo "$(GREEN)[SUCCESS]$(NC) Complete rebuild finished!"

clean:
	@echo "$(YELLOW)[CLEAN]$(NC) Cleaning cache and temporary data..."
	@docker-compose down --remove-orphans
	@docker system prune -f
	@docker builder prune -f
	@echo "$(GREEN)[SUCCESS]$(NC) Cache cleanup complete!"

rm:
	@echo "$(RED)[WARNING]$(NC) This will remove ALL data including Git credentials, GPG keys, etc."
	@read -p "Are you sure? [y/N] " -n 1 -r; echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		echo "$(YELLOW)[RM]$(NC) Removing everything..."; \
		docker-compose down -v --remove-orphans; \
		docker system prune -af; \
		docker builder prune -af; \
		docker volume prune -f; \
		echo "$(GREEN)[SUCCESS]$(NC) Everything removed!"; \
	else \
		echo "$(BLUE)[CANCELLED]$(NC) Operation cancelled."; \
	fi

shell:
	@echo "$(BLUE)[SHELL]$(NC) Opening shell in container..."
	@docker exec -it dev-environment zsh

ssh:
	@echo "$(BLUE)[SSH]$(NC) Connecting via SSH (password: dev)..."
	@ssh -o StrictHostKeyChecking=no dev@localhost -p 2222

logs:
	@docker-compose logs -f

status:
	@echo "$(BLUE)[STATUS]$(NC) Container status:"
	@docker-compose ps
	@echo ""
	@echo "$(BLUE)[VOLUMES]$(NC) Persistent volumes:"
	@docker volume ls | grep dotfiles || echo "No dotfiles volumes found"
