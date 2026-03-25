# Makefile para DevOps Workspace Central

# ==============================================================================
# Variável Global de Plataforma (Platform Engineering)
# Permite que este Makefile seja copiado via 'adopt-governance' para qualquer
# outro repositório cliente e continue ativando as automações centrais.
# ==============================================================================
# Verifica se estamos rodando de dentro do próprio diretório clonado para adotar raiz atual
# Preferência: usar a raiz do repositório Git quando disponível, caso contrário
# mantém o comportamento anterior (se estiver dentro de 'dev-workspace' usa $(CURDIR),
# senão usa $(HOME)/dev-workspace).
GIT_ROOT := $(shell git rev-parse --show-toplevel 2>/dev/null || true)
ifeq ($(GIT_ROOT),)
ifeq ($(shell basename $(CURDIR)),dev-workspace)
	DEV_WORKSPACE_DEFAULT := $(CURDIR)
else
	DEV_WORKSPACE_DEFAULT := $(HOME)/dev-workspace
endif
else
	DEV_WORKSPACE_DEFAULT := $(GIT_ROOT)
endif

DEV_WORKSPACE ?= $(DEV_WORKSPACE_DEFAULT)

.PHONY: help setup bootstrap asdf-install setup-agents lint update env-check morning audit test-skills day-start log day-close week-close infra-up infra-down adopt

# Cores para output
CYAN := \033[36m
RESET := \033[0m
GREEN := \033[32m
YELLOW := \033[33m

help: ## Mostra esta mensagem de ajuda
	@echo "$(YELLOW)========================================================$(RESET)"
	@echo "$(GREEN) Workspace DevOps Central -- Comandos Disponiveis$(RESET)"
	@echo "$(YELLOW)========================================================$(RESET)"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "$(CYAN)%-20s$(RESET) %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""

# ==========================================
# SETUP & BOOTSTRAP
# ==========================================
setup: ## Provisiona OS packages, dotfiles e toolchain via Ansible
	@echo "Iniciando setup da maquina..."
	@bash $(DEV_WORKSPACE)/ansible/scripts/setup-machine.sh

asdf-install: ## Instala as versoes de runtime fixadas no .tool-versions (Node.js e Python)
	@echo "Instalando runtimes via ASDF (.tool-versions)..."
	@bash -c 'source $$HOME/.asdf/asdf.sh && cd $(DEV_WORKSPACE) && asdf install'

bootstrap: ## Sequencia completa de onboarding: setup + runtimes + pre-commit + agentes
	@echo "=== [1/4] Provisionando OS, dotfiles e toolchain ==="
	@bash $(DEV_WORKSPACE)/ansible/scripts/setup-machine.sh
	@echo "=== [2/4] Instalando runtimes (.tool-versions) ==="
	@bash -c 'source $$HOME/.asdf/asdf.sh && cd $(DEV_WORKSPACE) && asdf install' || true
	@echo "=== [3/4] Ativando pre-commit hooks ==="
	@bash -c 'export PATH="$$HOME/.local/bin:$$PATH" && cd $(DEV_WORKSPACE) && pre-commit install'
	@echo "=== [4/4] Provisionando motor de agentes ==="
	@$(MAKE) -C $(DEV_WORKSPACE) setup-agents
	@echo "Bootstrap concluido. Rode 'make morning' para iniciar o dia."

# ==========================================
# INFRAESTRUTURA CORE (DOCKER Shared)
# ==========================================
infra-up: ## Inicia servicos da infraestrutura unificada (Traefik, Postgres, Redis, Chroma, MLFlow)
	@echo "Subindo Infraestrutura Core..."
	@docker network create dev-workspace-net || true
	@cd $(DEV_WORKSPACE)/infra-core && docker compose up -d
	@echo "Infraestrutura base disponivel na rede 'dev-workspace-net'."

infra-down: ## Desliga os servicos da infraestrutura unificada
	@echo "Desligando a infraestrutura core..."
	@cd $(DEV_WORKSPACE)/infra-core && docker compose down

# ==========================================
# QUALIDADE & AUDITORIA
# ==========================================
lint: ## Executa linters e verificacao estatica pre-commit em todo repositorio
	@echo "Executando pre-commit hooks..."
	PATH="$$HOME/.local/bin:$$PATH" pre-commit run --all-files

env-check: ## Roda verificacao rapida da sanidade das ferramentas nativas locais
	@bash $(DEV_WORKSPACE)/sanidade-ambiente/scripts/daily-check.sh

audit: ## Auditoria profunda de sistema mapeando versoes e servicos instalados
	@bash $(DEV_WORKSPACE)/sanidade-ambiente/scripts/env-audit.sh

# ==========================================
# GESTAO DE AGENTES & IA
# ==========================================
setup-agents: ## Instala gerenciador de bibliotecas (pipx) e provisiona subagentes
	@echo "Iniciando setup do motor de Agentes IA..."
	@DEV_CANDIDATES="$(DEV_WORKSPACE) $(DEV_WORKSPACE_DEFAULT) $(HOME)/dev-workspace $(HOME)/labs/dev-workspace"; \
	FOUND=$$(find $(HOME) -maxdepth 3 -type d -name gestao-centralizada-agents 2>/dev/null | head -n1); \
	if [ -n "$$FOUND" ]; then DEV_CANDIDATES="$$DEV_CANDIDATES $$(dirname $$FOUND)"; fi; \
	for d in $$DEV_CANDIDATES; do \
		if [ -f "$$d/gestao-centralizada-agents/scripts/setup-agents.sh" ]; then \
			echo "Usando $$d/gestao-centralizada-agents/scripts/setup-agents.sh"; \
			bash "$$d/gestao-centralizada-agents/scripts/setup-agents.sh"; \
			exit 0; \
		fi; \
	done; \
	echo "Arquivo setup-agents.sh nao encontrado em: $$DEV_CANDIDATES"; exit 1

test-skills: ## Confirma se o Servidor Node MCP compila e integra as Skills de IA
	@echo "Testando build do servidor MCP de Skills..."
	@DEV_CANDIDATES="$(DEV_WORKSPACE) $(DEV_WORKSPACE_DEFAULT) $(HOME)/dev-workspace $(HOME)/labs/dev-workspace"; \
	FOUND=$$(find $(HOME) -maxdepth 3 -type d -name gestao-centralizada-agents 2>/dev/null | head -n1); \
	if [ -n "$$FOUND" ]; then DEV_CANDIDATES="$$DEV_CANDIDATES $$(dirname $$FOUND)"; fi; \
	for d in $$DEV_CANDIDATES; do \
		if [ -d "$$d/gestao-centralizada-agents/skills-mcp" ]; then \
			echo "Usando $$d/gestao-centralizada-agents/skills-mcp"; \
			cd "$$d/gestao-centralizada-agents/skills-mcp" && npm install && npm run build; \
			exit 0; \
		fi; \
	done; \
	echo "Diretorio skills-mcp nao encontrado em: $$DEV_CANDIDATES"; exit 2
	@echo "Servidor MCP validado."

adopt: ## Enquadra um repositorio externo nas regras da plataforma (uso: make adopt TARGET=/caminho/do/projeto)
	@if [ -z "$(TARGET)" ]; then \
		echo "Uso correto: make adopt TARGET=/caminho/do/projeto-legado"; \
		exit 1; \
	fi
	@bash $(DEV_WORKSPACE)/gestao-centralizada-agents/scripts/adopt-governance.sh $(TARGET)

# ==========================================
# ROTINA DE DEVOPS (WORKLOG)
# ==========================================
morning: ## Inicia processo matinal completo (sanidade + worklog do dia)
	@bash $(DEV_WORKSPACE)/rotina-devops/scripts/open-devops-routine.sh

day-start: ## Inicia o worklog do dia e abre no VS Code
	@bash $(DEV_WORKSPACE)/rotina-devops/scripts/worklog-start.sh

log: ## Adiciona registro no log do dia (sem args = interativo)
	@bash $(DEV_WORKSPACE)/rotina-devops/scripts/worklog-add.sh $(ARGS)

day-close: ## Consolida, encerra e faz push do worklog diario
	@bash $(DEV_WORKSPACE)/rotina-devops/scripts/worklog-close.sh

week-close: ## Compila o sumario executivo da semana DevOps
	@bash $(DEV_WORKSPACE)/rotina-devops/scripts/worklog-weekly.sh

# ==========================================
# MANUTENCAO CONTINUA
# ==========================================
update: ## Sincroniza local com repositorio remoto Git
	@echo "Atualizando ambiente local..."
	@git pull origin main
