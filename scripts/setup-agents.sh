#!/usr/bin/env bash

# Cores
GREEN="\033[0;32m"
BLUE="\033[0;34m"
RED="\033[0;31m"
RESET="\033[0m"

echo -e "${BLUE}=================================================${RESET}"
echo -e "${BLUE}[ INIT ] Instalando Fundação Centralizada de Agentes${RESET}"
echo -e "${BLUE}=================================================${RESET}"

# 1. Checa pipx
if ! command -v pipx &> /dev/null; then
    echo -e "${RED}[ ERRO ] pipx não encontrado. Rode 'make setup' primeiro para o Ansible instalar as dependências do SO.${RESET}"
    exit 1
fi

export PATH="$HOME/.local/bin:$PATH"
pipx ensurepath > /dev/null 2>&1

# 2. Instalação do Motor de Agentes
echo -e "${GREEN}[ STEP 1/2 ] Instalando ferramentas CLI globais via pipx...${RESET}"
pipx install crewai 2>/dev/null || echo -e "   [ INFO ] CrewAI já instalado ou atualizado."

# 3. Configuração do Ambiente (.agents-env)
AGENTS_ENV_FILE="$HOME/.agents-env"
echo -e "${GREEN}[ STEP 2/2 ] Configurando arquivo central de credenciais em ${AGENTS_ENV_FILE}...${RESET}"

if [ ! -f "$AGENTS_ENV_FILE" ]; then
    cat << 'ENVEOF' > "$AGENTS_ENV_FILE"
# =======================================================
# COCKPIT DE AGENTES - VARIÁVEIS EXTERNAS DE AMBIENTE
# =======================================================

# [ LLM APIs ]
OPENAI_API_KEY="sk-proj-xxxxxxxx"
ANTHROPIC_API_KEY="sk-ant-xxxxxxxx"

# [ Observabilidade - Langfuse/Phoenix ]
LANGFUSE_PUBLIC_KEY=""
LANGFUSE_SECRET_KEY=""
LANGFUSE_HOST="http://localhost:3000"

# [ MCP Skills Path ]
MCP_SKILLS_PATH="$HOME/dev-workspace/skills-mcp"
ENVEOF
    echo -e "   [ OK ] Arquivo base .agents-env gerado com sucesso."
else
    echo -e "   [ INFO ] Arquivo .agents-env já existe. Mantendo configurações atuais da sua máquina."
fi

echo ""
echo -e "${BLUE}=================================================${RESET}"
echo -e "${GREEN}[ DONE ] Instalação Global concluída!${RESET}"
echo -e "         Lembre-se de preencher suas chaves em: ${AGENTS_ENV_FILE}"
echo -e "${BLUE}=================================================${RESET}"
