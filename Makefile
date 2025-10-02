.PHONY: help build start stop clean logs shell ssh status rm install uninstall

BLUE := \033[0;34m
GREEN := \033[0;32m
YELLOW := \033[1;33m
RED := \033[0;31m
NC := \033[0m # No Color

.DEFAULT_GOAL := help

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
	@echo ""
	@printf "\033[1;33mAccess:\033[0m\n"
	@printf "  \033[0;34mshell\033[0m      Open tmux session with zsh in container\n"
	@printf "  \033[0;34minstall\033[0m    Install auto-shell to host shell config\n"
	@printf "  \033[0;34muninstall\033[0m  Remove auto-shell from host shell config\n"
	@printf "  \033[0;34mssh\033[0m        Connect via SSH (for VS Code)\n"
	@printf "  \033[0;34mlogs\033[0m       Show container logs\n"
	@printf "  \033[0;34mstatus\033[0m     Show container status\n"
	@echo ""

build:
	@echo "$(BLUE)[BUILD]$(NC) Building development environment..."
	@export DOCKER_BUILDKIT=1 && export COMPOSE_DOCKER_CLI_BUILD=1 && docker-compose build
	@$(MAKE) start
	@echo "$(GREEN)[SUCCESS]$(NC) Environment ready!"
	@echo "SSH: ssh dev@localhost -p 2222 (password: dev)"

start:
	@echo "$(BLUE)[START]$(NC) Starting containers..."
	@docker-compose up -d

stop:
	@echo "$(BLUE)[STOP]$(NC) Stopping containers..."
	@docker-compose down

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
	@echo "$(BLUE)[SHELL]$(NC) Opening tmux session with zsh in container..."
	@echo "$(YELLOW)[TIP]$(NC) Use 'exit' to return to host terminal"
	@docker exec -it dev-environment tmux new-session

install:
	@echo "$(BLUE)[INSTALL]$(NC) Setting up auto-shell..."
	@SHELL_CONFIG=""; \
	if [ -f ~/.zshrc ]; then SHELL_CONFIG=~/.zshrc; \
	elif [ -f ~/.bash_profile ]; then SHELL_CONFIG=~/.bash_profile; \
	elif [ -f ~/.bashrc ]; then SHELL_CONFIG=~/.bashrc; \
	else echo "$(RED)[ERROR]$(NC) No shell config file found" && exit 1; fi; \
	\
	if grep -q "DOTFILES_AUTO_SHELL_DONE" "$$SHELL_CONFIG"; then \
		echo "$(YELLOW)[SKIP]$(NC) Already installed in $$SHELL_CONFIG"; \
	else \
		echo "" >> "$$SHELL_CONFIG"; \
		echo "# Auto-enter dotfiles development container" >> "$$SHELL_CONFIG"; \
		echo "if [[ -z \"\$$DOTFILES_AUTO_SHELL_DONE\" ]]; then" >> "$$SHELL_CONFIG"; \
		echo "  export DOTFILES_AUTO_SHELL_DONE=1" >> "$$SHELL_CONFIG"; \
		echo "  if docker ps | grep -q dev-environment; then" >> "$$SHELL_CONFIG"; \
		echo "    echo \"🐳 Auto-entering development container...\"" >> "$$SHELL_CONFIG"; \
		echo "    cd $(shell pwd) && make shell" >> "$$SHELL_CONFIG"; \
		echo "  fi" >> "$$SHELL_CONFIG"; \
		echo "fi" >> "$$SHELL_CONFIG"; \
		echo "$(GREEN)[INSTALLED]$(NC) Added to $$SHELL_CONFIG"; \
	fi
	@echo "$(YELLOW)[NOTE]$(NC) Open a new terminal to auto-enter the container"

uninstall:
	@echo "$(BLUE)[UNINSTALL]$(NC) Removing auto-shell..."
	@SHELL_CONFIG=""; \
	if [ -f ~/.zshrc ]; then SHELL_CONFIG=~/.zshrc; \
	elif [ -f ~/.bash_profile ]; then SHELL_CONFIG=~/.bash_profile; \
	elif [ -f ~/.bashrc ]; then SHELL_CONFIG=~/.bashrc; \
	else echo "$(RED)[ERROR]$(NC) No shell config file found" && exit 1; fi; \
	\
	if grep -q "DOTFILES_AUTO_SHELL_DONE" "$$SHELL_CONFIG"; then \
		echo "$(YELLOW)[REMOVING]$(NC) Removing from $$SHELL_CONFIG"; \
		sed -i.bak '/# Auto-enter dotfiles development container/,/^fi$$/d' "$$SHELL_CONFIG"; \
		echo "$(GREEN)[REMOVED]$(NC) Auto-shell removed from $$SHELL_CONFIG"; \
	else \
		echo "$(YELLOW)[SKIP]$(NC) Auto-shell not found in $$SHELL_CONFIG"; \
	fi
	@echo "$(YELLOW)[NOTE]$(NC) Open a new terminal for normal behavior"

ssh:
	@echo "$(BLUE)[SSH]$(NC) Connecting via SSH (password: dev)..."
	@ssh -o StrictHostKeyChecking=no dev@localhost -p 2222 || true

logs:
	@docker-compose logs -f

status:
	@echo "$(BLUE)[STATUS]$(NC) Container status:"
	@docker-compose ps
	@echo ""
	@echo "$(BLUE)[VOLUMES]$(NC) Persistent volumes:"
	@docker volume ls | grep dotfiles || echo "No dotfiles volumes found"
