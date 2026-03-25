#!/usr/bin/env bash
# shellcheck disable=SC2034


set -euo pipefail

WORKSPACE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

CHECKLIST="$WORKSPACE_DIR/playbooks/checklist-manha.md"
MORNING_SCRIPT="$WORKSPACE_DIR/sanidade-ambiente/scripts/daily-check.sh"
STORAGE_SCRIPT="$WORKSPACE_DIR/sanidade-ambiente/scripts/storage-check.sh"

REPORT_NAME="morning-report-$(date +%Y%m%d)"
REPORT_DIR="$HOME/.cache/devops-reports/$REPORT_NAME"
mkdir -p "$REPORT_DIR"
REPORT_FILE="$REPORT_DIR/session.log"

echo "Iniciando rotina matinal unificada..." | tee "$REPORT_FILE"
echo "Relatorio gerado em: $REPORT_DIR"

echo -e "\n[ 1. SANIDADE DE TOOLCHAIN ]" | tee -a "$REPORT_FILE"
bash "$MORNING_SCRIPT" 2>&1 | tee -a "$REPORT_FILE"

echo -e "\n[ 2. TELEMETRIA DE DISCO ]" | tee -a "$REPORT_FILE"
bash "$STORAGE_SCRIPT" 2>&1 | tee -a "$REPORT_FILE"

echo -e "\nVerificacao matinal compilada. Revise os alertas."
echo "Log arquivado em: $REPORT_FILE"

echo -e "\n--------------------------------------------------------"
echo "Abrindo Worklog Diario..."
make -C "$WORKSPACE_DIR" day-start
