#!/usr/bin/env bash
# shellcheck disable=SC2034


set -euo pipefail

WORKSPACE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

CHECKLIST="$WORKSPACE_DIR/playbooks/checklist-manha.md"
MANUAL="$WORKSPACE_DIR/rotina-devops.md"
LINKS="$WORKSPACE_DIR/docs-referencia/links-uteis.md"
MORNING_SCRIPT="$WORKSPACE_DIR/sanidade-ambiente/scripts/daily-check.sh"
STORAGE_SCRIPT="$WORKSPACE_DIR/sanidade-ambiente/scripts/storage-check.sh"

REPORT_NAME="relatorio-morning$(date +%d%m%y)"
REPORT_DIR="$HOME/$REPORT_NAME"
mkdir -p "$REPORT_DIR"
REPORT_FILE="$REPORT_DIR/morning-report.log"

echo "🚀 Iniciando rotina matinal unificada..." | tee "$REPORT_FILE"
echo "Gerando relatórios e alertas gerenciais na pasta: $REPORT_DIR"

echo -e "\n[ 1. SANIDADE DE GOVERNANÇA E TOOLCHAIN ]" | tee -a "$REPORT_FILE"
bash "$MORNING_SCRIPT" 2>&1 | tee -a "$REPORT_FILE"

echo -e "\n[ 2. TELEMETRIA DE DISCO E STORAGE ]" | tee -a "$REPORT_FILE"
bash "$STORAGE_SCRIPT" 2>&1 | tee -a "$REPORT_FILE"

echo -e "\n🔔 Verificação matinal compilada! Revise os alertas e siga a governança."
echo "📍 Relatório técnico arquivado em: $REPORT_FILE"

echo -e "\n--------------------------------------------------------"
echo "Invocando o Worklog Diário (Planejamento)..."
make -C "$WORKSPACE_DIR" day-start
