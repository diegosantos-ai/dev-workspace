# Makefile — DevOps Workspace Central
#
# Entrypoint operacional do workspace. Todos os fluxos de setup, rotina
# diária e manutenção devem passar por targets definidos aqui.
#
# Uso: make <target>
# Ajuda: make help

# ==============================================================================
# Resolucao de DEV_WORKSPACE
# Prioridade: variavel de ambiente > raiz Git > CURDIR se basename == dev-workspace
# > fallback para $HOME/labs/dev-workspace
# ==============================================================================
GIT_ROOT := $(shell git rev-parse --show-toplevel 2>/dev/null || true)
ifeq ($(GIT_ROOT),)
  ifeq ($(shell basename $(CURDIR)),dev-workspace)
    DEV_WORKSPACE_DEFAULT := $(CURDIR)
  else
    DEV_WORKSPACE_DEFAULT := $(HOME)/labs/dev-workspace
  endif
else
  DEV_WORKSPACE_DEFAULT := $(GIT_ROOT)
endif

# ==============================================================================
# Variaveis internas e ambiente
# ==============================================================================
export PATH := $(HOME)/.local/bin:$(PATH)

ANSIBLE_SCRIPT  := "$(DEV_WORKSPACE)/ansible/scripts/setup-machine.sh"
SANIDADE_DIR    := "$(DEV_WORKSPACE)/sanidade-ambiente/scripts"
ROTINA_DIR      := "$(DEV_WORKSPACE)/rotina-devops/scripts"
AGENTS_DIR      := "$(DEV_WORKSPACE)/gestao-centralizada-agents"
INFRA_DIR       := "$(DEV_WORKSPACE)/infra-core"

CYAN   := \033[36m
RESET  := \033[0m
GREEN  := \033[32m
YELLOW := \033[33m
RED    := \033[31m
BOLD   := \033[1m

# ==============================================================================
# Declaracao de targets sem arquivos
# ==============================================================================
.PHONY: help \
        setup-workstation setup asdf-install bootstrap \
        doctor env-check audit lint \
        infra-up infra-down \
        setup-agents test-skills adopt \
        morning day-start log day-close week-close \
        update

# ==============================================================================
# HELP
# ==============================================================================
help: ## Exibe targets disponiveis e suas descricoes
	@printf "$(YELLOW)%-60s$(RESET)\n" "============================================================"
	@printf "$(GREEN)  Workspace DevOps Central$(RESET)\n"
	@printf "$(YELLOW)%-60s$(RESET)\n" "============================================================"
	@awk 'BEGIN {FS = ":.*?## "} \
	     /^[a-zA-Z_-]+:.*?## / { \
	       printf "  $(CYAN)%-22s$(RESET) %s\n", $$1, $$2 \
	     }' $(MAKEFILE_LIST)
	@printf "\n"

# ==============================================================================
# SETUP & BOOTSTRAP
# ==============================================================================

setup-workstation: ## [CANONICO] Provisiona OS, dotfiles e toolchain via Ansible
	@bash $(ANSIBLE_SCRIPT)

setup: setup-workstation ## Alias de compatibilidade para setup-workstation

asdf-install: ## Instala runtimes fixados em .tool-versions via ASDF
	@if [ ! -f "$(DEV_WORKSPACE)/.tool-versions" ]; then \
	  printf "$(RED)[ERRO]$(RESET) .tool-versions nao encontrado em %s\n" "$(DEV_WORKSPACE)"; \
	  exit 1; \
	fi
	@bash -c 'source "$$HOME/.asdf/asdf.sh" && cd "$(DEV_WORKSPACE)" && asdf install'

bootstrap: ## Onboarding completo: setup-workstation + runtimes + pre-commit + agentes
	@printf "$(BOLD)=== [1/4] Provisionando OS, dotfiles e toolchain ===$(RESET)\n"
	@bash $(ANSIBLE_SCRIPT)
	@printf "$(BOLD)=== [2/4] Instalando runtimes (.tool-versions) ===$(RESET)\n"
	@bash -c 'source "$$HOME/.asdf/asdf.sh" && cd "$(DEV_WORKSPACE)" && asdf install' || \
	  printf "$(YELLOW)[AVISO]$(RESET) asdf install falhou — verifique .tool-versions e rode 'make asdf-install'\n"
	@printf "$(BOLD)=== [3/4] Ativando pre-commit hooks ===$(RESET)\n"
	@bash -c 'export PATH="$$HOME/.local/bin:$$PATH" && cd "$(DEV_WORKSPACE)" && pre-commit install'
	@printf "$(BOLD)=== [4/4] Provisionando motor de agentes ===$(RESET)\n"
	@$(MAKE) -C "$(DEV_WORKSPACE)" setup-agents
	@printf "$(GREEN)Bootstrap concluido. Rode 'make morning' para iniciar o dia.$(RESET)\n"

# ==============================================================================
# DIAGNOSTICO
# ==============================================================================

doctor: ## Diagnostico completo do ambiente (ferramentas, hooks, repos)
	@printf "$(BOLD)Diagnostico do ambiente DevOps...$(RESET)\n"
	@printf "\n$(CYAN)-- Ferramentas essenciais --$(RESET)\n"
	@for cmd in bash git make docker terraform aws gh pre-commit; do \
	  if command -v $$cmd >/dev/null 2>&1; then \
	    printf "  $(GREEN)[OK]$(RESET)   %-20s %s\n" "$$cmd" "$$($$cmd --version 2>&1 | head -1)"; \
	  else \
	    printf "  $(RED)[FAIL]$(RESET) %-20s nao encontrado\n" "$$cmd"; \
	  fi; \
	done
	@printf "\n$(CYAN)-- Ferramentas opcionais --$(RESET)\n"
	@for cmd in uv ollama lazygit pipx asdf node python3; do \
	  IF_FOUND=0; \
	  if command -v $$cmd >/dev/null 2>&1; then IF_FOUND=1; \
	  elif [ "$$cmd" = "asdf" ] && [ -f "$$HOME/.asdf/asdf.sh" ]; then IF_FOUND=1; fi; \
	  if [ $$IF_FOUND -eq 1 ]; then \
	    printf "  $(GREEN)[OK]$(RESET)   %-20s funcional\n" "$$cmd"; \
	  else \
	    printf "  $(YELLOW)[WARN]$(RESET) %-20s nao encontrado\n" "$$cmd"; \
	  fi; \
	done
	@printf "\n$(CYAN)-- Repositorio e hooks --$(RESET)\n"
	@git rev-parse --is-inside-work-tree >/dev/null 2>&1 && \
	  printf "  $(GREEN)[OK]$(RESET)   repositorio Git detectado\n" || \
	  printf "  $(RED)[FAIL]$(RESET) nao esta dentro de um repositorio Git\n"
	@git config user.name >/dev/null 2>&1 && \
	  printf "  $(GREEN)[OK]$(RESET)   git user.name configurado (%s)\n" "$$(git config user.name)" || \
	  printf "  $(RED)[FAIL]$(RESET) git user.name nao configurado\n"
	@git config user.email >/dev/null 2>&1 && \
	  printf "  $(GREEN)[OK]$(RESET)   git user.email configurado (%s)\n" "$$(git config user.email)" || \
	  printf "  $(RED)[FAIL]$(RESET) git user.email nao configurado\n"
	@[ -f "$(DEV_WORKSPACE)/.git/hooks/pre-commit" ] && \
	  printf "  $(GREEN)[OK]$(RESET)   pre-commit hook instalado\n" || \
	  printf "  $(YELLOW)[WARN]$(RESET) pre-commit hook ausente — rode: pre-commit install\n"
	@printf "\n$(CYAN)-- SSH --$(RESET)\n"
	@ssh -T git@github.com 2>&1 | grep -q "successfully authenticated" && \
	  printf "  $(GREEN)[OK]$(RESET)   SSH GitHub autenticado\n" || \
	  printf "  $(YELLOW)[WARN]$(RESET) SSH GitHub nao autenticado\n"
	@printf "\n"

env-check: ## Verificacao rapida de sanidade das ferramentas locais
	@bash $(SANIDADE_DIR)/daily-check.sh

audit: ## Auditoria profunda de versoes e servicos instalados
	@bash $(SANIDADE_DIR)/env-audit.sh

lint: ## Executa pre-commit em todos os arquivos do repositorio
	@if ! command -v pre-commit >/dev/null 2>&1; then \
	  printf "$(RED)[ERRO]$(RESET) pre-commit nao encontrado. Rode: make bootstrap\n"; \
	  exit 1; \
	fi
	@pre-commit run --all-files

# ==============================================================================
# INFRAESTRUTURA CORE (Docker compartilhado)
# ==============================================================================

infra-up: ## Sobe servicos compartilhados (Postgres, Redis, ChromaDB, MLFlow, Traefik)
	@if ! command -v docker >/dev/null 2>&1; then \
	  printf "$(RED)[ERRO]$(RESET) Docker nao encontrado. Instale Docker e tente novamente.\n"; \
	  exit 1; \
	fi
	@docker network create dev-workspace-net 2>/dev/null || true
	@docker compose -f "$(INFRA_DIR)/docker-compose.yml" up -d
	@printf "$(GREEN)Infraestrutura disponivel na rede 'dev-workspace-net'.$(RESET)\n"

infra-down: ## Encerra os servicos compartilhados
	@docker compose -f "$(INFRA_DIR)/docker-compose.yml" down

# ==============================================================================
# GESTAO DE AGENTES & IA
# ==============================================================================

setup-agents: ## Instala CrewAI via pipx e gera template de credenciais (.agents-env)
	@if ! command -v pipx >/dev/null 2>&1; then \
	  printf "$(RED)[ERRO]$(RESET) pipx nao encontrado. Rode 'make setup-workstation' primeiro.\n"; \
	  exit 1; \
	fi
	@SCRIPT="$(AGENTS_DIR)/scripts/setup-agents.sh"; \
	if [ ! -f "$$SCRIPT" ]; then \
	  printf "$(RED)[ERRO]$(RESET) setup-agents.sh nao encontrado em %s\n" "$(AGENTS_DIR)/scripts"; \
	  exit 1; \
	fi; \
	bash "$$SCRIPT"

test-skills: ## Compila o servidor MCP Node (requer Node.js via ASDF)
	@SKILLS_DIR="$(AGENTS_DIR)/skills-mcp"; \
	if [ ! -d "$$SKILLS_DIR" ]; then \
	  printf "$(RED)[ERRO]$(RESET) Diretorio skills-mcp nao encontrado em %s\n" "$(AGENTS_DIR)"; \
	  exit 1; \
	fi; \
	if ! command -v node >/dev/null 2>&1; then \
	  printf "$(RED)[ERRO]$(RESET) Node.js nao encontrado. Rode 'make asdf-install' primeiro.\n"; \
	  exit 1; \
	fi; \
	LOCKFILE="$$SKILLS_DIR/package-lock.json"; \
	if [ -f "$$LOCKFILE" ]; then \
	  cd "$$SKILLS_DIR" && npm ci && npm run build; \
	else \
	  cd "$$SKILLS_DIR" && npm install && npm run build; \
	fi
	@printf "$(GREEN)Servidor MCP compilado com sucesso.$(RESET)\n"

adopt: ## Aplica governanca do workspace em repositorio externo (uso: make adopt TARGET=/caminho)
	@if [ -z "$(TARGET)" ]; then \
	  printf "$(RED)[ERRO]$(RESET) TARGET nao definido.\n"; \
	  printf "Uso: make adopt TARGET=/caminho/do/projeto\n"; \
	  exit 1; \
	fi
	@if [ ! -d "$(TARGET)" ]; then \
	  printf "$(RED)[ERRO]$(RESET) Diretorio TARGET nao existe: %s\n" "$(TARGET)"; \
	  exit 1; \
	fi
	@bash "$(AGENTS_DIR)/scripts/adopt-governance.sh" "$(TARGET)"

# ==============================================================================
# ROTINA DE DEVOPS (WORKLOG)
# ==============================================================================

morning: ## Rotina matinal: sanidade do ambiente + abertura do worklog do dia
	@bash "$(ROTINA_DIR)/open-devops-routine.sh"

day-start: ## Cria worklog do dia e abre no VS Code
	@bash "$(ROTINA_DIR)/worklog-start.sh"

log: ## Adiciona entrada no worklog do dia (interativo se sem ARGS)
	@bash "$(ROTINA_DIR)/worklog-add.sh" $(ARGS)

day-close: ## Consolida e faz push do worklog diario
	@bash "$(ROTINA_DIR)/worklog-close.sh"

week-close: ## Gera sumario executivo semanal
	@bash "$(ROTINA_DIR)/worklog-weekly.sh"

# ==============================================================================
# MANUTENCAO CONTINUA
# ==============================================================================

update: ## Sincroniza com repositorio remoto (git pull origin main)
	@git pull origin main
