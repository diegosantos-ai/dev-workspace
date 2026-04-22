# Makefile — DevOps Workspace Central
#
# Entrypoint operacional do workspace. Todos os fluxos de setup, rotina
# diária e manutenção devem passar por targets definidos aqui.
#
# Uso: make <target>
# Ajuda: make help

# ==============================================================================
# Resolucao da raiz do workspace
# Fonte unica de verdade: o diretorio onde este Makefile reside.
# ==============================================================================
MAKEFILE_PATH       := $(abspath $(lastword $(MAKEFILE_LIST)))
DEV_WORKSPACE_ROOT  := $(patsubst %/,%,$(dir $(MAKEFILE_PATH)))

export DEV_WORKSPACE := $(DEV_WORKSPACE_ROOT)
export DEV_WORKSPACE_ROOT

# ==============================================================================
# Variaveis internas e ambiente
# ==============================================================================
export PATH := $(HOME)/.local/bin:$(PATH)

ANSIBLE_SCRIPT  := $(DEV_WORKSPACE_ROOT)/ansible/scripts/setup-machine.sh
SANIDADE_DIR    := $(DEV_WORKSPACE_ROOT)/sanidade-ambiente/scripts
ROTINA_DIR      := $(DEV_WORKSPACE_ROOT)/rotina-devops/scripts
AGENTS_DIR      := $(DEV_WORKSPACE_ROOT)/gestao-centralizada-agents
INFRA_DIR       := $(DEV_WORKSPACE_ROOT)/infra-core
SCRIPTS_DIR     := $(DEV_WORKSPACE_ROOT)/scripts

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
        assert-git-context \
        setup-workstation setup asdf-install setup-agent-clis bootstrap \
        doctor env-check audit lint \
        infra-up infra-down \
        setup-agents test-skills start-skills-mcp adopt \
        morning day-start log day-close week-close \
        update-repo update-report update-tools update \
        release-pr

# ==============================================================================
# HELP
# ==============================================================================
help: ## Exibe targets disponiveis e suas descricoes
	@printf "$(YELLOW)%-60s$(RESET)\n" "============================================================"
	@printf "$(GREEN)  Workspace DevOps Central$(RESET)\n"
	@printf "$(YELLOW)%-60s$(RESET)\n" "============================================================"
	@printf "  $(CYAN)%-22s$(RESET) %s\n" "workspace-root" "$(DEV_WORKSPACE_ROOT)"
	@awk 'BEGIN {FS = ":.*?## "} \
	     /^[a-zA-Z_-]+:.*?## / { \
	       printf "  $(CYAN)%-22s$(RESET) %s\n", $$1, $$2 \
	     }' $(MAKEFILE_LIST)
	@printf "\n"

# ==============================================================================
# SETUP & BOOTSTRAP
# ==============================================================================

assert-git-context: ## Valida que a raiz do workspace pertence a um repositorio Git
	@if ! git -C "$(DEV_WORKSPACE_ROOT)" rev-parse --is-inside-work-tree >/dev/null 2>&1; then \
	  printf "$(RED)[ERRO]$(RESET) A raiz calculada pelo Makefile nao e um repositorio Git valido: %s\n" "$(DEV_WORKSPACE_ROOT)"; \
	  printf "Execute os comandos a partir do clone real do workspace ou use o Makefile localizado nesse clone.\n"; \
	  exit 1; \
	fi

setup-workstation: ## Provisiona OS, dotfiles e toolchain via Ansible
	@if [ ! -f "$(ANSIBLE_SCRIPT)" ]; then \
	  printf "$(RED)[ERRO]$(RESET) Script de setup nao encontrado: %s\n" "$(ANSIBLE_SCRIPT)"; \
	  exit 1; \
	fi
	@bash "$(ANSIBLE_SCRIPT)"

setup: setup-workstation ## Alias de compatibilidade para setup-workstation

asdf-install: ## Instala runtimes fixados em .tool-versions via ASDF
	@if [ ! -f "$(DEV_WORKSPACE_ROOT)/.tool-versions" ]; then \
	  printf "$(RED)[ERRO]$(RESET) .tool-versions nao encontrado em %s\n" "$(DEV_WORKSPACE_ROOT)"; \
	  exit 1; \
	fi
	@if [ ! -f "$$HOME/.asdf/asdf.sh" ]; then \
	  printf "$(RED)[ERRO]$(RESET) ASDF nao encontrado em %s\n" "$$HOME/.asdf/asdf.sh"; \
	  printf "Rode 'make setup-workstation' primeiro.\n"; \
	  exit 1; \
	fi
	@bash -c 'source "$$HOME/.asdf/asdf.sh" && cd "$(DEV_WORKSPACE_ROOT)" && asdf install'

setup-agent-clis: assert-git-context ## Garante instalacao inicial das CLIs e extensoes de agentes do workspace
	@if ! command -v ansible-playbook >/dev/null 2>&1; then \
	  printf "$(RED)[ERRO]$(RESET) ansible-playbook nao encontrado. Rode 'make setup-workstation' primeiro.\n"; \
	  exit 1; \
	fi
	@if [ ! -f "$$HOME/.asdf/asdf.sh" ]; then \
	  printf "$(RED)[ERRO]$(RESET) ASDF nao encontrado em %s\n" "$$HOME/.asdf/asdf.sh"; \
	  printf "Rode 'make setup-workstation' e 'make asdf-install' primeiro.\n"; \
	  exit 1; \
	fi
	@bash -c 'source "$$HOME/.asdf/asdf.sh" && cd "$(DEV_WORKSPACE_ROOT)" && command -v npm >/dev/null 2>&1' || { \
	  printf "$(RED)[ERRO]$(RESET) npm nao encontrado no ambiente ASDF. Rode 'make asdf-install' primeiro.\n"; \
	  exit 1; \
	}
	@ANSIBLE_HOST_KEY_CHECKING=False LC_ALL=C.UTF-8 ansible-playbook "$(DEV_WORKSPACE_ROOT)/ansible/local-setup.yml" --tags agent-clis --extra-vars "user=$$USER"

bootstrap: assert-git-context ## [ONBOARDING] Onboarding completo: setup-workstation + runtimes + CLIs de agentes + pre-commit + agentes
	@printf "$(BOLD)=== [1/5] Provisionando OS, dotfiles e toolchain ===$(RESET)\n"
	@$(MAKE) -C "$(DEV_WORKSPACE_ROOT)" setup-workstation
	@printf "$(BOLD)=== [2/5] Instalando runtimes (.tool-versions) ===$(RESET)\n"
	@$(MAKE) -C "$(DEV_WORKSPACE_ROOT)" asdf-install || \
	  printf "$(YELLOW)[AVISO]$(RESET) asdf install falhou — verifique .tool-versions e rode 'make asdf-install'\n"
	@printf "$(BOLD)=== [3/5] Garantindo CLIs de agentes do workspace ===$(RESET)\n"
	@$(MAKE) -C "$(DEV_WORKSPACE_ROOT)" setup-agent-clis
	@printf "$(BOLD)=== [4/5] Ativando pre-commit hooks ===$(RESET)\n"
	@if ! command -v pre-commit >/dev/null 2>&1; then \
	  printf "$(RED)[ERRO]$(RESET) pre-commit nao encontrado. Rode 'make setup-workstation' e tente novamente.\n"; \
	  exit 1; \
	fi
	@bash -c 'export PATH="$$HOME/.local/bin:$$PATH" && cd "$(DEV_WORKSPACE_ROOT)" && pre-commit install'
	@printf "$(BOLD)=== [5/5] Provisionando motor de agentes ===$(RESET)\n"
	@$(MAKE) -C "$(DEV_WORKSPACE_ROOT)" setup-agents
	@printf "$(GREEN)Bootstrap concluido. Rode 'make morning' para iniciar o dia.$(RESET)\n"

# ==============================================================================
# DIAGNOSTICO
# ==============================================================================

doctor: ## Diagnostico completo do ambiente (ferramentas, hooks, repos)
	@printf "$(BOLD)Diagnostico do ambiente DevOps...$(RESET)\n"
	@printf "Workspace root: %s\n" "$(DEV_WORKSPACE_ROOT)"
	@printf "\n$(CYAN)-- Ferramentas essenciais --$(RESET)\n"
	@for cmd in bash git make docker terraform openstack gh pre-commit; do \
	  if command -v $$cmd >/dev/null 2>&1; then \
	    printf "  $(GREEN)[OK]$(RESET)   %-20s %s\n" "$$cmd" "$$($$cmd --version 2>&1 | head -1)"; \
	  else \
	    printf "  $(RED)[FAIL]$(RESET) %-20s nao encontrado\n" "$$cmd"; \
	  fi; \
	done
	@printf "\n$(CYAN)-- Ferramentas opcionais --$(RESET)\n"
	@for cmd in uv ollama lazygit pipx asdf node python3 cursor idea eclipse; do \
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
	@if git -C "$(DEV_WORKSPACE_ROOT)" rev-parse --is-inside-work-tree >/dev/null 2>&1; then \
	  printf "  $(GREEN)[OK]$(RESET)   repositorio Git detectado em %s\n" "$(DEV_WORKSPACE_ROOT)"; \
	else \
	  printf "  $(RED)[FAIL]$(RESET) a raiz calculada nao pertence a um repositorio Git: %s\n" "$(DEV_WORKSPACE_ROOT)"; \
	fi
	@git config user.name >/dev/null 2>&1 && \
	  printf "  $(GREEN)[OK]$(RESET)   git user.name configurado (%s)\n" "$$(git config user.name)" || \
	  printf "  $(RED)[FAIL]$(RESET) git user.name nao configurado\n"
	@git config user.email >/dev/null 2>&1 && \
	  printf "  $(GREEN)[OK]$(RESET)   git user.email configurado (%s)\n" "$$(git config user.email)" || \
	  printf "  $(RED)[FAIL]$(RESET) git user.email nao configurado\n"
	@HOOK_PATH="$$(git -C "$(DEV_WORKSPACE_ROOT)" rev-parse --git-path hooks/pre-commit 2>/dev/null || true)"; \
	if [ -n "$$HOOK_PATH" ] && [ -f "$$HOOK_PATH" ]; then \
	  printf "  $(GREEN)[OK]$(RESET)   pre-commit hook instalado (%s)\n" "$$HOOK_PATH"; \
	else \
	  printf "  $(YELLOW)[WARN]$(RESET) pre-commit hook ausente — rode: make bootstrap\n"; \
	fi
	@printf "\n$(CYAN)-- SSH --$(RESET)\n"
	@ssh -T git@github.com 2>&1 | grep -q "successfully authenticated" && \
	  printf "  $(GREEN)[OK]$(RESET)   SSH GitHub autenticado\n" || \
	  printf "  $(YELLOW)[WARN]$(RESET) SSH GitHub nao autenticado\n"
	@printf "\n"

env-check: ## Verificacao rapida de sanidade das ferramentas locais
	@if [ ! -f "$(SANIDADE_DIR)/daily-check.sh" ]; then \
	  printf "$(RED)[ERRO]$(RESET) Script nao encontrado: %s\n" "$(SANIDADE_DIR)/daily-check.sh"; \
	  exit 1; \
	fi
	@bash "$(SANIDADE_DIR)/daily-check.sh"

audit: ## Auditoria profunda de versoes e servicos instalados
	@if [ ! -f "$(SANIDADE_DIR)/env-audit.sh" ]; then \
	  printf "$(RED)[ERRO]$(RESET) Script nao encontrado: %s\n" "$(SANIDADE_DIR)/env-audit.sh"; \
	  exit 1; \
	fi
	@bash "$(SANIDADE_DIR)/env-audit.sh"

lint: assert-git-context ## Executa pre-commit em todos os arquivos do repositorio
	@if ! command -v pre-commit >/dev/null 2>&1; then \
	  printf "$(RED)[ERRO]$(RESET) pre-commit nao encontrado. Rode: make bootstrap\n"; \
	  exit 1; \
	fi
	@cd "$(DEV_WORKSPACE_ROOT)" && pre-commit run --all-files

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

start-skills-mcp: ## Inicia o servidor MCP local do workspace via STDIO
	@SCRIPT="$(AGENTS_DIR)/scripts/start-skills-mcp.sh"; \
	if [ ! -f "$$SCRIPT" ]; then \
	  printf "$(RED)[ERRO]$(RESET) Script nao encontrado: %s\n" "$$SCRIPT"; \
	  exit 1; \
	fi; \
	bash "$$SCRIPT"

start-orquestrador: ## Sobe o Cockpit de Agentes (observabilidade, bases vetoriais e n8n)
	@COCKPIT_DIR="$(AGENTS_DIR)/infra/agents-cockpit"; \
	if [ ! -d "$$COCKPIT_DIR" ]; then \
	  printf "$(RED)[ERRO]$(RESET) Diretorio agents-cockpit nao encontrado em %s\n" "$$COCKPIT_DIR"; \
	  exit 1; \
	fi; \
	docker network create dev-workspace-net 2>/dev/null || true; \
	docker compose -f "$$COCKPIT_DIR/docker-compose.yml" up -d; \
	printf "$(GREEN)Cockpit de Agentes em execucao.$(RESET)\n"

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
	@if [ ! -f "$(ROTINA_DIR)/open-devops-routine.sh" ]; then \
	  printf "$(RED)[ERRO]$(RESET) Script nao encontrado: %s\n" "$(ROTINA_DIR)/open-devops-routine.sh"; \
	  exit 1; \
	fi
	@bash "$(ROTINA_DIR)/open-devops-routine.sh"

day-start: ## Cria worklog do dia e abre no VS Code
	@if [ ! -f "$(ROTINA_DIR)/worklog-start.sh" ]; then \
	  printf "$(RED)[ERRO]$(RESET) Script nao encontrado: %s\n" "$(ROTINA_DIR)/worklog-start.sh"; \
	  exit 1; \
	fi
	@bash "$(ROTINA_DIR)/worklog-start.sh"

log: ## Adiciona entrada no worklog do dia (interativo se sem ARGS)
	@if [ ! -f "$(ROTINA_DIR)/worklog-add.sh" ]; then \
	  printf "$(RED)[ERRO]$(RESET) Script nao encontrado: %s\n" "$(ROTINA_DIR)/worklog-add.sh"; \
	  exit 1; \
	fi
	@bash "$(ROTINA_DIR)/worklog-add.sh" $(ARGS)

day-close: ## Consolida e faz push do worklog diario
	@if [ ! -f "$(ROTINA_DIR)/worklog-close.sh" ]; then \
	  printf "$(RED)[ERRO]$(RESET) Script nao encontrado: %s\n" "$(ROTINA_DIR)/worklog-close.sh"; \
	  exit 1; \
	fi
	@bash "$(ROTINA_DIR)/worklog-close.sh"

week-close: ## Gera sumario executivo semanal
	@if [ ! -f "$(ROTINA_DIR)/worklog-weekly.sh" ]; then \
	  printf "$(RED)[ERRO]$(RESET) Script nao encontrado: %s\n" "$(ROTINA_DIR)/worklog-weekly.sh"; \
	  exit 1; \
	fi
	@bash "$(ROTINA_DIR)/worklog-weekly.sh"

# ==============================================================================
# MANUTENCAO CONTINUA
# ==============================================================================

update-repo: assert-git-context ## Sincroniza o clone local com o repositorio remoto (git pull origin main)
	@git pull origin main

update-report: ## Gera relatorio das atualizacoes disponiveis sem aplicar alteracoes
	@if [ ! -f "$(SCRIPTS_DIR)/update-tools.sh" ]; then \
	  printf "$(RED)[ERRO]$(RESET) Script nao encontrado: %s\n" "$(SCRIPTS_DIR)/update-tools.sh"; \
	  exit 1; \
	fi
	@bash "$(SCRIPTS_DIR)/update-tools.sh" --report

update-tools: ## Atualiza ferramentas gerenciadas do workspace e gera relatorio
	@if [ ! -f "$(SCRIPTS_DIR)/update-tools.sh" ]; then \
	  printf "$(RED)[ERRO]$(RESET) Script nao encontrado: %s\n" "$(SCRIPTS_DIR)/update-tools.sh"; \
	  exit 1; \
	fi
	@bash "$(SCRIPTS_DIR)/update-tools.sh" --apply

update: update-repo update-tools ## Sincroniza repositorio e aplica atualizacoes automatizadas

test-e2e: ## Executa suite de testes de idempotencia e baseline (E2E)
	@bash scripts/test-e2e.sh

release-pr: assert-git-context ## Abre PR de promocao develop -> main com descricao gerada por Git
	@if [ ! -f "$(SCRIPTS_DIR)/create-release-pr.sh" ]; then \
	  printf "$(RED)[ERRO]$(RESET) Script nao encontrado: %s\n" "$(SCRIPTS_DIR)/create-release-pr.sh"; \
	  exit 1; \
	fi
	@TITLE="$(TITLE)" BASE_BRANCH="$(BASE_BRANCH)" HEAD_BRANCH="$(HEAD_BRANCH)" bash "$(SCRIPTS_DIR)/create-release-pr.sh"
