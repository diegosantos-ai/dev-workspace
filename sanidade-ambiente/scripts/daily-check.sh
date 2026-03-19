#!/usr/bin/env bash
set -euo pipefail

# ==============================================================================
# Script: daily-check.sh
# Propósito: Verificação rápida e não invasiva do ambiente para o dia a dia.
# ==============================================================================

# Força path para raiz do repositório garantindo execução independente do ponto de origem
cd "$(dirname "${BASH_SOURCE[0]}")/../.." || exit 1

# Export global do ~/.local/bin para evitar falsos negativos (pipx/pre-commit)
export PATH="$HOME/.local/bin:$PATH"

# Cores Seguras (Fallback elegante se o terminal não renderizar)
if [ -t 1 ]; then
    GREEN='\033[0;32m'
    YELLOW='\033[0;33m'
    RED='\033[0;31m'
    BOLD='\033[1m'
    NC='\033[0m'
else
    GREEN='' YELLOW='' RED='' BOLD='' NC=''
fi

# Arrays de Status (Em vez de printar tudo na hora, armazenamos para o resumo)
declare -a FAILS=()
declare -a WARNS=()
COUNT_OK=0

# ==============================================================================
# Funções de Verificação e Registro
# ==============================================================================
check_cmd() {
    local cmd=$1
    local name=$2
    local sev=${3:-FAIL} # Nível de severidade padrão: FAIL

    if command -v "$cmd" >/dev/null 2>&1; then
        COUNT_OK=$((COUNT_OK + 1))
    else
        if [ "$sev" == "FAIL" ]; then
            FAILS+=("Comando essencial ausente: $name ($cmd)")
        else
            WARNS+=("Ferramenta opcional ausente: $name ($cmd)")
        fi
    fi
}

check_dir() {
    local dir=$1
    local name=$2
    local sev=${3:-FAIL}

    if [ -d "$dir" ]; then
        COUNT_OK=$((COUNT_OK + 1))
    else
         if [ "$sev" == "FAIL" ]; then
            FAILS+=("Estrutura vital ausente: $name (./$dir)")
        else
            WARNS+=("Estrutura secundária ausente: $name (./$dir)")
        fi
    fi
}

check_docker_daemon() {
    if docker info >/dev/null 2>&1; then 
        COUNT_OK=$((COUNT_OK + 1))
    else 
        FAILS+=("Docker Daemon offline ou sem permissão. (Dica: systemctl start docker)")
    fi
}

check_git_repo() {
    if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then 
        COUNT_OK=$((COUNT_OK + 1))
    else 
        FAILS+=("O diretório atual não é ou não está mapeado em um repositório Git")
    fi
}

# ==============================================================================
# Execução Simplificada
# ==============================================================================
echo -e "${BOLD}Iniciando Checagem Diária...${NC}"

# Core
check_cmd "bash" "Interpretador Bash"
check_cmd "git" "Git"
check_cmd "make" "Make"

# Ferramentas
check_cmd "docker" "Docker CLI"
check_cmd "docker-compose" "Docker Compose" "WARN" # Fallback, a v2 usa plugin
if ! docker compose version >/dev/null 2>&1; then
     WARNS+=("Docker Compose V2 (plugin) ausente ou desatualizado.")
fi
check_cmd "python3" "Python 3"
check_cmd "pipx" "Gestor de Agentes (PIPX)" "WARN"

# Operação
check_docker_daemon
check_git_repo
check_dir "rotina-devops" "Módulo de Worklogs" "WARN"
check_dir "sanidade-ambiente" "Módulo de Saúde (atual)" "FAIL"

# ==============================================================================
# Saída Desidratada (DX Elegante)
# ==============================================================================
echo -e "Verificados: ${BOLD}${COUNT_OK} itens OK${NC}.\n"

if [ ${#FAILS[@]} -eq 0 ] && [ ${#WARNS[@]} -eq 0 ]; then
    echo -e "${GREEN}✅ TUDO VERDE. Ambiente pronto para o trabalho!${NC}"
    exit 0
fi

# Se houverem avisos (Não bloqueantes)
if [ ${#WARNS[@]} -gt 0 ]; then
    echo -e "${YELLOW}⚠️  Atenção (Opcionais faltantes):${NC}"
    for w in "${WARNS[@]}"; do echo -e "  - $w"; done
    echo ""
fi

# Se houverem falhas (Bloqueantes)
if [ ${#FAILS[@]} -gt 0 ]; then
    echo -e "${RED}❌ FALHA ESTRUTURAL (Correção Necessária):${NC}"
    for f in "${FAILS[@]}"; do echo -e "  - $f"; done
    echo -e "\n${BOLD}${RED}>>> AMBIENTE BLOQUEADO. RODE OS FIXES ANTES DE INICIAR. <<<${NC}"
    exit 1
fi

# Retorna 0 mesmo com Warns, pois Warn não bloqueia pipeline.
echo -e "${YELLOW}Ambiente liberado com restrições.${NC}"
exit 0
