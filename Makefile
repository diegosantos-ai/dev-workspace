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

.PHONY: help setup setup-agents lint update env-check morning audit test-skills day-start log day-close week-close infra-up infra-down

# Cores para output
CYAN := \033[36m
RESET := \033[0m
GREEN := \033[32m
YELLOW := \033[33m

help: ## Mostra esta mensagem de ajuda
	@echo "$(YELLOW)========================================================$(RESET)"
	@echo "$(GREEN) Workspace DevOps Central — Comandos Disponíveis$(RESET)"
	@echo "$(YELLOW)========================================================$(RESET)"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "$(CYAN)%-20s$(RESET) %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""

# ==========================================
# 🚀 SETUP & BOOTSTRAP
# ==========================================
setup: ## Bootstrapping inicial da máquina (instala OS packages e aplica dotfiles via stow)
	@echo "Iniciando setup da máquina..."
	@bash $(DEV_WORKSPACE)/ansible/scripts/setup-machine.sh

# ==========================================
# � INFRAESTRUTURA CORE (DOCKER Shared)
# ==========================================
infra-up: ## Inicia e orquestra todos os servicos da infraestrutura unificada no host
	@echo "Subindo Infraestrutura Core (Traefik, Postgres, Redis, Chroma, MLFlow)..."
	@docker network create dev-workspace-net || true
	@cd $(DEV_WORKSPACE)/infra-core && docker compose up -d
	@echo "✅ Infraestrutura base disponível na rede 'dev-workspace-net'."

infra-down: ## Desliga os servicos da infraestrutura unificada
	@echo "Desligando a infraestrutura core..."
	@cd $(DEV_WORKSPACE)/infra-core && docker compose down

# ==========================================
# �🛡️ QUALIDADE & AUDITORIA
# ==========================================
lint: ## Executa linters e verificação estática pré-commit em todo repositório
	@echo "Executando pre-commit hooks..."
	PATH="$$HOME/.local/bin:$$PATH" pre-commit run --all-files

env-check: ## Roda verificação rápida e isolada da sanidade das ferramentas nativas locais
	@bash $(DEV_WORKSPACE)/sanidade-ambiente/scripts/daily-check.sh

audit: ## Dispara auditoria profunda de sistema mapeando versões e serviços instalados
	@bash $(DEV_WORKSPACE)/sanidade-ambiente/scripts/env-audit.sh

# ==========================================
# 🤖 GESTÃO DE AGENTES & IA
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
	echo "Arquivo setup-agents.sh não encontrado em: $$DEV_CANDIDATES"; exit 1

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
	echo "Diretório skills-mcp não encontrado em: $$DEV_CANDIDATES"; exit 2
	@echo "✅ Servidor MCP validado e pronto para consumo!"

adopt: ## Enquadra um repositório externo nas regras da plataforma (uso: make adopt TARGET=/caminho/do/projeto)
	@if [ -z "$(TARGET)" ]; then \
		echo "Uso correto: make adopt TARGET=/caminho/do/projeto-legado"; \
		exit 1; \
	fi
	@bash $(DEV_WORKSPACE)/gestao-centralizada-agents/scripts/adopt-governance.sh $(TARGET)

# ==========================================
# 📅 ROTINA DE DEVOPS (WORKLOG)
# ==========================================
morning: ## Inicia processo matinal completo (checklist e bootstrap de worklog)
	@bash $(DEV_WORKSPACE)/rotina-devops/scripts/open-devops-routine.sh

day-start: ## Inicia o worklog do dia e abre no VS Code
	@bash $(DEV_WORKSPACE)/rotina-devops/scripts/worklog-start.sh

log: ## Adiciona registro no log. (Sem args = interativo)
	@bash $(DEV_WORKSPACE)/rotina-devops/scripts/worklog-add.sh $(ARGS)

day-close: ## Realiza consolidação, encerramento de relatórios e push diário
	@bash $(DEV_WORKSPACE)/rotina-devops/scripts/worklog-close.sh

week-close: ## Compila o sumário executivo da semana DevOps
	@bash $(DEV_WORKSPACE)/rotina-devops/scripts/worklog-weekly.sh

# ==========================================
# 🔄 MANUTENÇÃO CONTÍNUA
# ==========================================
update: ## Sincroniza local com repositório remoto Git
	@echo "Atualizando ambiente local..."
	@git pull origin main
