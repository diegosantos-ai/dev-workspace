#!/usr/bin/env bash
set -euo pipefail

# ==============================================================================
# Script: env-audit.sh
# Propósito: Auditoria estendida do ambiente (Ferramentas, Versões e Segurança).
# Status: Implementação Base Inicial (V1)
# ==============================================================================

# Cores e Formatação
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
# RED='\033[0;31m'
NC='\033[0m'

# Diretório base para relatórios (resolve em relação a posição do script)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPORT_DIR="${SCRIPT_DIR}/../reports"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
REPORT_FILE="${REPORT_DIR}/audit-${TIMESTAMP}.log"

echo -e "${CYAN}======================================================================${NC}"
echo -e "${CYAN}                AUDITORIA EXTENDIDA DE AMBIENTE (v1)                  ${NC}"
echo -e "${CYAN}======================================================================${NC}"
echo "Iniciando varredura detalhada de componentes e versões..."

# Redirecionando a saída padrão para terminal E para arquivo de log simultaneamente usando tee
{
    echo "========================================="
    echo " Relatório de Auditoria: $TIMESTAMP"
    echo "========================================="

    echo -e "\n[ 1. Ferramentas Core e Versões ]"
    echo "-----------------------------------------"
    if command -v docker >/dev/null 2>&1; then
        echo "[ OK ] Docker: $(docker --version)"
    else
        echo "[ FAIL ] Docker CLI não instalado"
    fi

    if command -v python3 >/dev/null 2>&1; then
        echo "[ OK ] Python: $(python3 --version)"
    else
        echo "[ FAIL ] Python3 não instalado"
    fi

    if command -v terraform >/dev/null 2>&1; then
        echo "[ OK ] Terraform: $(terraform --version | head -n 1)"
    else
        echo "[ WARN ] Terraform não encontrado. (Ignorar se não atuar com IaC)"
    fi

    echo -e "\n[ 2. CI/CD Local (Shift-Left) ]"
    echo "-----------------------------------------"
    if command -v pre-commit >/dev/null 2>&1; then
        echo "[ OK ] Pre-commit: Instalado e ativo no path"
    else
        echo "[ FAIL ] Pre-commit não encontrado. Risco em pipelines!"
    fi

    if command -v shellcheck >/dev/null 2>&1; then
        echo "[ OK ] Shellcheck: Presente para linting de scripts bash"
    else
        echo "[ WARN ] Shellcheck não instalado. Qualidade de scripts comprometida."
    fi

    echo -e "\n========================================="
    echo " Fim da Auditoria."
    echo "========================================="

} | tee "$REPORT_FILE"

echo -e "\n${GREEN}[ CONCLUÍDO ]${NC} Auditoria finalizada!"
echo -e "📄 O relatório foi salvo isoladamente em: ${YELLOW}${REPORT_FILE}${NC}"
