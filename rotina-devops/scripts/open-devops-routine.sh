#!/usr/bin/env bash
set -euo pipefail

WORKSPACE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
MORNING_SCRIPT="$WORKSPACE_DIR/sanidade-ambiente/scripts/daily-check.sh"
STORAGE_SCRIPT="$WORKSPACE_DIR/sanidade-ambiente/scripts/storage-check.sh"
MAKE_BIN="${MAKE:-make}"

REPORT_NAME="morning-report-$(date +%Y%m%d)"
REPORT_DIR="$HOME/.cache/devops-reports/$REPORT_NAME"
mkdir -p "$REPORT_DIR"
REPORT_FILE="$REPORT_DIR/session.log"

for required_file in "$MORNING_SCRIPT" "$STORAGE_SCRIPT"; do
    if [ ! -f "$required_file" ]; then
        echo "Erro: arquivo obrigatorio nao encontrado: $required_file" >&2
        exit 1
    fi
done

if ! command -v "$MAKE_BIN" >/dev/null 2>&1; then
    echo "Erro: comando make nao encontrado no PATH." >&2
    exit 1
fi

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
"$MAKE_BIN" -C "$WORKSPACE_DIR" day-start
