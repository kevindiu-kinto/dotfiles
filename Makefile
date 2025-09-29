# Development Environment Makefile
# Essential Docker management commands

.PHONY: help build start stop restart clean rebuild update logs shell ssh status down info

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
	@printf "  \033[0;34mstart\033[0m      Start containers\n"
	@printf "  \033[0;34mstop\033[0m       Stop containers\n"
	@printf "  \033[0;34mrestart\033[0m    Restart containers\n"
	@printf "  \033[0;34mdown\033[0m       Stop and remove containers\n"
	@echo ""
	@printf "\033[1;33mMaintenance:\033[0m\n"
	@printf "  \033[0;34mrebuild\033[0m    Force rebuild without cache\n"
	@printf "  \033[0;34mupdate\033[0m     Update all packages and rebuild\n"
	@printf "  \033[0;34mclean\033[0m      Clean up everything (containers, images, volumes)\n"
	@echo ""
	@printf "\033[1;33mAccess:\033[0m\n"
	@printf "  \033[0;34mshell\033[0m      Open shell in container\n"
	@printf "  \033[0;34mssh\033[0m        Connect via SSH (for VS Code)\n"
	@printf "  \033[0;34mlogs\033[0m       Show container logs\n"
	@printf "  \033[0;34mstatus\033[0m     Show container status\n"
	@echo ""

# Build and start the development environment
build: 
	@echo "$(BLUE)[BUILD]$(NC) Building development environment..."
	@docker-compose build
	@$(MAKE) start
	@echo "$(GREEN)[SUCCESS]$(NC) Environment ready!"
	@echo "SSH: ssh dev@localhost -p 2222 (password: dev)"

# Start containers (without building)
start:
	@echo "$(BLUE)[START]$(NC) Starting containers..."
	@docker-compose up -d

# Stop containers
stop:
	@echo "$(BLUE)[STOP]$(NC) Stopping containers..."
	@docker-compose stop

# Stop and remove containers
down:
	@echo "$(BLUE)[DOWN]$(NC) Stopping and removing containers..."
	@docker-compose down

# Restart containers
restart: stop start

# Force rebuild without cache
rebuild:
	@echo "$(BLUE)[REBUILD]$(NC) Force rebuilding without cache..."
	@docker-compose build --no-cache
	@$(MAKE) start
	@echo "$(GREEN)[SUCCESS]$(NC) Complete rebuild finished!"

# Update all packages and rebuild
update:
	@echo "$(BLUE)[UPDATE]$(NC) Updating packages..."
	@BUILD_DATE=$$(date +%s) docker-compose build
	@$(MAKE) start
	@echo "$(GREEN)[SUCCESS]$(NC) Packages updated!"

# Clean up containers, images, and volumes
clean:
	@echo "$(YELLOW)[CLEAN]$(NC) Cleaning up everything..."
	@docker-compose down -v --remove-orphans
	@docker system prune -f
	@echo "$(GREEN)[SUCCESS]$(NC) Cleanup complete!"

# Open shell in the container
shell:
	@echo "$(BLUE)[SHELL]$(NC) Opening shell in container..."
	@docker exec -it dev-environment zsh

# Connect via SSH (interactive)
ssh:
	@echo "$(BLUE)[SSH]$(NC) Connecting via SSH (password: dev)..."
	@ssh -o StrictHostKeyChecking=no dev@localhost -p 2222

# Show container logs
logs:
	@docker-compose logs -f

# Show container status
status:
	@echo "$(BLUE)[STATUS]$(NC) Container status:"
	@docker-compose ps
	@echo ""
	@echo "$(BLUE)[VOLUMES]$(NC) Persistent volumes:"
	@docker volume ls | grep dotfiles || echo "No dotfiles volumes found"