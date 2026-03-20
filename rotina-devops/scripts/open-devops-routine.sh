#!/usr/bin/env bash
# shellcheck disable=SC2034


set -euo pipefail

WORKSPACE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

CHECKLIST="$WORKSPACE_DIR/playbooks/checklist-manha.md"
MANUAL="$WORKSPACE_DIR/rotina-devops.md"
LINKS="$WORKSPACE_DIR/docs-referencia/links-uteis.md"
MORNING_SCRIPT="$WORKSPACE_DIR/sanidade-ambiente/scripts/daily-check.sh"

echo "🚀 Rodando auditoria passiva matinal..."
bash "$MORNING_SCRIPT"

echo "🔔 Abrindo documentações na interface..."
# Evita quebrar se o notify-send/xdg não existir num server headless
if command -v notify-send >/dev/null; then
    notify-send "Rotina DevOps" "Abra o checklist, leia o estado do ambiente e defina sua entrega."
fi

if command -v xdg-open >/dev/null; then
    xdg-open "$CHECKLIST" >/dev/null 2>&1 &
    sleep 1
    xdg-open "$MANUAL" >/dev/null 2>&1 &
else
    echo "[!] Interface gráfica inativa. Os arquivos para leitura são:"
    echo "- $CHECKLIST"
    echo "- $MANUAL"
fi
