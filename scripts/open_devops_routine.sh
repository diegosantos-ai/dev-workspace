#!/usr/bin/env bash

set -u -o pipefail

CHECKLIST="/home/diegosantos/docs/rotina-devops/checklist-manha.md"
MANUAL="/home/diegosantos/docs/rotina-devops/rotina-devops.md"
LINKS="/home/diegosantos/docs/rotina-devops/links-uteis.md"
MORNING_SCRIPT="/home/diegosantos/scripts/morning_check.sh"

notify-send "Rotina DevOps" "Abra o checklist, leia o estado do ambiente e defina sua entrega do dia."

xdg-open "$CHECKLIST" >/dev/null 2>&1 &
sleep 1
xdg-open "$MANUAL" >/dev/null 2>&1 &
sleep 1

# Descomente a linha abaixo se quiser abrir também os links úteis
# xdg-open "$LINKS" >/dev/null 2>&1 &

# Descomente uma das opções abaixo se quiser abrir o terminal automaticamente

# gnome-terminal -- bash -lc "$MORNING_SCRIPT; exec bash"
# x-terminal-emulator -e bash -lc "$MORNING_SCRIPT; exec bash"
