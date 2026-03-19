#!/usr/bin/env bash
set -euo pipefail

# ==============================================================================
# Script: daily-check.sh
# Propósito: Verificação rápida e não invasiva do ambiente para o dia a dia.
# ==============================================================================

# Cores para saída
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m'

# Contadores de status
COUNT_OK=0
COUNT_WARN=0
COUNT_FAIL=0

# Funções de auxílio visual e contagem
report_ok() { echo -e "${GREEN}[OK]${NC} $1"; COUNT_OK=$((COUNT_OK + 1)); }
report_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; COUNT_WARN=$((COUNT_WARN + 1)); }
report_fail() { echo -e "${RED}[FAIL]${NC} $1"; COUNT_FAIL=$((COUNT_FAIL + 1)); }

echo "Iniciando checagem diária de sanidade do ambiente..."
echo "----------------------------------------------------"

# ------------------------------------------------------------------------------
echo -e "\nCategoria 1 — Base de Shell e Operação"
# ------------------------------------------------------------------------------
if command -v bash >/dev/null 2>&1; then report_ok "Interpretador bash presente"; else report_fail "Interpretador bash ausente"; fi
if command -v git >/dev/null 2>&1; then report_ok "Git instalado"; else report_fail "Git não encontrado no PATH"; fi
if command -v make >/dev/null 2>&1; then report_ok "Make instalado"; else report_fail "Make não encontrado no PATH"; fi

# ------------------------------------------------------------------------------
echo -e "\nCategoria 2 — Ferramentas Principais de Trabalho"
# ------------------------------------------------------------------------------
if command -v docker >/dev/null 2>&1; then 
    report_ok "Docker CLI instalado"
else 
    report_fail "Docker CLI ausente"
fi

if docker compose version >/dev/null 2>&1 || command -v docker-compose >/dev/null 2>&1; then 
    report_ok "Docker Compose disponível"
else 
    report_fail "Docker Compose ausente"
fi

if command -v python3 >/dev/null 2>&1; then 
    report_ok "Python3 encontrado"
else 
    report_fail "Python3 ausente"
fi

if command -v pipx >/dev/null 2>&1; then 
    report_ok "Pipx encontrado (Gestão de Agentes)"
else 
    report_warn "Pipx ausente - Ferramentas de Python (CrewAI) podem não estar disponíveis"
fi

# ------------------------------------------------------------------------------
echo -e "\nCategoria 3 — Status Operacional"
# ------------------------------------------------------------------------------
if docker info >/dev/null 2>&1; then 
    report_ok "Docker Daemon está respondendo"
else 
    report_fail "Docker Daemon offline ou restrito (Acesso negado)"
fi

if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then 
    report_ok "Acesso validado ao repositório Git atual"
else 
    report_fail "O diretório atual não é um repositório Git válido"
fi

if [ -d "rotina-devops" ]; then 
    report_ok "Diretório rotina-devops/ existe"
else 
    report_warn "Diretório rotina-devops/ ausente (Você está rodando da raiz?)"
fi

if [ -d "sanidade-ambiente" ]; then 
    report_ok "Diretório sanidade-ambiente/ existe"
else 
    report_fail "Diretório sanidade-ambiente/ ausente (Estrutura quebrada ou fora da raiz)"
fi

# ------------------------------------------------------------------------------
echo -e "\n===================================================="
echo "          RESUMO DA CHECAGEM"
echo "===================================================="
echo -e " ✅ OK:   ${GREEN}${COUNT_OK}${NC}"
echo -e " ⚠️ WARN: ${YELLOW}${COUNT_WARN}${NC}"
echo -e " ❌ FAIL: ${RED}${COUNT_FAIL}${NC}"
echo "----------------------------------------------------"

if [ "$COUNT_FAIL" -gt 0 ]; then
    echo -e "Status Geral: ${RED}BLOQUEADO${NC} - Falhas críticas detectadas. Corrija-as antes de trabalhar."
    exit 1
elif [ "$COUNT_WARN" -gt 0 ]; then
    echo -e "Status Geral: ${YELLOW}ATENÇÃO${NC} - Ambiente operacional, mas com pendências opcionais."
    exit 0
else
    echo -e "Status Geral: ${GREEN}SAUDÁVEL${NC} - Ambiente 100% pronto para decolar! 🚀"
    exit 0
fi
