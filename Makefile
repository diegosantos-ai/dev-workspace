# Makefile para DevOps Workspace Central

.PHONY: help setup lint test update dbg

# Cores para output
CYAN := \033[36m
RESET := \033[0m

help: ## Mostra esta mensagem de ajuda
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "$(CYAN)%-20s$(RESET) %s\n", $$1, $$2}' $(MAKEFILE_LIST)

setup: ## Bootstrapping inicial da nova máquina (instala pacotes, links de dotfiles)
	@echo "Iniciando setup da máquina..."
	@bash scripts/setup-machine.sh

setup-agents: ## Provisiona orquestradores e IAs centralizadas via pipx
	@echo "Iniciando setup do motor de Agentes IA..."
	@bash scripts/setup-agents.sh

lint: ## Roda linters em todo o repositório (Shell, Terraform, Python, Markdown)
	@echo "Executando pre-commit hooks..."
	PATH="$$HOME/.local/bin:$$PATH" pre-commit run --all-files

update: ## Atualiza repositórios, dotfiles e pacotes locais
	@echo "Atualizando ambiente local..."
	@git pull origin main
	# Adicionar comandos de update do sistema operacional aqui

morning: ## Roda a rotina matinal (abre arquivos de playbook e executa o check)
	@bash scripts/open_devops_routine.sh

audit: ## Dispara script completo de auditoria do sistema operacional e CLI libs
	@bash scripts/check_devops_env.sh

test-skills: ## Confirma se o Servidor MCP das Skills compila sem erros
	@echo "Testando build do servidor MCP de Skills..."
	@cd gestao-centralizada-agents/skills-mcp && npm install && npm run build
	@echo "✅ Servidor MCP validado e pronto para consumo!"

# --- Rotina DevOps (Worklog) ---
.PHONY: day-start log day-close week-close

day-start: ## Inicia o worklog do dia e abre no VS Code
	@bash rotina-devops/scripts/worklog-start.sh

log: ## Adiciona registro no log. (Sem args = interativo. Ex args: make log ARGS="proj tipo acao res imp")
	@bash rotina-devops/scripts/worklog-add.sh $(ARGS)

day-close: ## Faz o fechamento e resumo do dia atual
	@bash rotina-devops/scripts/worklog-close.sh

week-close: ## Gera relatório consolidado da semana
	@bash rotina-devops/scripts/worklog-weekly.sh
