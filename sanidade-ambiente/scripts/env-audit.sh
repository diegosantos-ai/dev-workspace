#!/usr/bin/env bash
set -euo pipefail

# ==============================================================================
# Script: env-audit.sh
# Propósito: Auditoria estendida do ambiente (Ferramentas, Versões e Segurança).
# Status: Implementação V2 (Checks Operacionais)
# ==============================================================================

export PATH="$HOME/.local/bin:$PATH"

CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
# RED='\033[0;31m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPORT_DIR="${SCRIPT_DIR}/../reports"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
REPORT_FILE="${REPORT_DIR}/audit-${TIMESTAMP}.log"

mkdir -p "$REPORT_DIR"

echo -e "${CYAN}======================================================================${NC}"
echo -e "${CYAN}                AUDITORIA ESTENDIDA DE AMBIENTE (v2)                  ${NC}"
echo -e "${CYAN}======================================================================${NC}"
echo "Iniciando varredura detalhada e operacional..."

{
    echo "========================================="
    echo " Relatório de Auditoria: $TIMESTAMP"
    echo "========================================="

    echo -e "\n[ 1. Ferramentas Core e Operação Real ]"
    echo "-----------------------------------------"
    if docker ps >/dev/null 2>&1; then
        echo "[ OK ] Docker CLI: $(docker --version)"
        echo "[ OK ] Docker Daemon: Respondendo (Socket OK)"
    else
        echo "[ FAIL ] Docker Daemon não responde ou CLI ausente"
    fi

    if command -v python3 >/dev/null 2>&1 && python3 -c 'print("OK")' >/dev/null 2>&1; then
        echo "[ OK ] Python3: $(python3 --version) (Executável)"
    else
        echo "[ FAIL ] Python3 com problemas ou ausente"
    fi

    if command -v terraform >/dev/null 2>&1; then
        echo "[ OK ] Terraform: $(terraform --version | head -n 1)"
    else
        echo "[ WARN ] Terraform não encontrado"
    fi

    echo -e "\n[ 2. Estado de Conectividade e Redes ]"
    echo "-----------------------------------------"
    if ping -c 1 github.com >/dev/null 2>&1 || curl -s -m 3 https://github.com >/dev/null; then
        echo "[ OK ] Conectividade com github.com"
    else
        echo "[ FAIL ] Sem acesso aos servidores do GitHub"
    fi
    ssh_out=$(ssh -T git@github.com 2>&1 || true)
    if echo "$ssh_out" | grep -q "successfully authenticated"; then
        echo "[ OK ] SSH Auth: GitHub conectado com sucesso"
    else
        echo "[ WARN ] SSH Auth: Sem acesso configurado de SSH ao GitHub"
    fi

    echo -e "\n[ 3. CI/CD Local (Shift-Left) ]"
    echo "-----------------------------------------"
    if pre-commit --version >/dev/null 2>&1; then
        echo "[ OK ] Pre-commit Binary: $(pre-commit --version)"
    else
        echo "[ FAIL ] Pre-commit CLI não encontrado no PATH"
    fi

    if [ -f "${SCRIPT_DIR}/../../.git/hooks/pre-commit" ]; then
        echo "[ OK ] Pre-commit Hooks: Ativos no repositório local"
    else
        echo "[ FAIL ] Pre-commit Hooks inativos (Rode 'pre-commit install')"
    fi

    if shellcheck --version >/dev/null 2>&1; then
        echo "[ OK ] Shellcheck: $(shellcheck --version | grep version: | awk '{print $2}')"
    else
        echo "[ WARN ] Shellcheck não está no PATH local."
    fi

    echo -e "\n========================================="
    echo " Fim da Auditoria."
    echo "========================================="

} | tee "$REPORT_FILE"

echo -e "\n${GREEN}[ CONCLUÍDO ]${NC} Auditoria finalizada!"
echo -e "📄 O relatório foi salvo isoladamente em: ${YELLOW}${REPORT_FILE}${NC}"
