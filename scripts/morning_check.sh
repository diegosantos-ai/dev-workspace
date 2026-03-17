#!/usr/bin/env bash
# shellcheck disable=SC2034,SC2154,SC1090
# shellcheck disable=SC2034,SC2154


set -euo pipefail

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

# Resolvendo os caminhos via Git (dinamicamente baseado no root do projeto)
WORKSPACE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

export CHECKLIST_PATH="$WORKSPACE_DIR/playbooks/checklist-manha.md"
MANUAL_PATH="$WORKSPACE_DIR/rotina-devops.md"
export LINKS_PATH="$WORKSPACE_DIR/docs-referencia/links-uteis.md"
export AUDIT_SCRIPT="$WORKSPACE_DIR/scripts/check_devops_env.sh"

export TOOLS_OK=0
export TOOLS_MISSING=0
DOCKER_STATUS="não verificado"
CONTAINERS_RUNNING=0
UPDATES_COUNT=0
REBOOT_STATUS="não"

print_header() {
  echo -e "\n${BLUE}========================================${NC}"
  echo -e "${BLUE}$1${NC}"
  echo -e "${BLUE}========================================${NC}"
}

check_docker() {
  print_header "DOCKER"
  if command -v docker >/dev/null 2>&1; then
    if docker info >/dev/null 2>&1; then
      echo -e "${GREEN}[OK]${NC} Docker acessível"
      CONTAINERS_RUNNING="$(docker ps -q | wc -l)"
      echo "Containers em execução: $CONTAINERS_RUNNING"
    else
      echo -e "${YELLOW}[WARN]${NC} Docker instalado, mas daemon bloqueado ou offline"
    fi
  else
    echo -e "${RED}[MISSING]${NC} Docker não encontrado"
  fi
}

check_updates_ubuntu() {
  print_header "SISTEMA NATIVO (Ubuntu/Apt)"
  if command -v apt >/dev/null 2>&1; then
    local upgradable_list
    # Atualiza lista em dev/null caso esteja desatualizada e pega a lista
    upgradable_list="$(apt list --upgradable 2>/dev/null | tail -n +2)"
    UPDATES_COUNT="$(printf '%s\n' "$upgradable_list" | sed '/^$/d' | wc -l)"

    if [[ "$UPDATES_COUNT" -eq 0 ]]; then
      echo -e "${GREEN}[OK]${NC} Sem pacotes APT pendentes"
    else
      echo -e "${YELLOW}[WARN]${NC} $UPDATES_COUNT pacote(s) nativos pendentes. (Dica de make: use 'sudo apt upgrade')"
    fi
  fi
}

check_updates_non_native() {
  print_header "ATUALIZAÇÕES NÃO-NATIVAS (Ambiente DevOps)"

  # Checagem de Pre-Commit Hooks
  echo -e "--- Pre-Commit ---"
  if command -v pre-commit >/dev/null 2>&1; then
    echo -e "${YELLOW}[INFO]${NC} Verificando dependências de infra/código..."
    if cd "$WORKSPACE_DIR" && pre-commit autoupdate --dry-run 2>&1 | grep -q 'updates available'; then
       echo -e "${YELLOW}[WARN]${NC} Hooks do pre-commit defasados! (Rode: 'pre-commit autoupdate')"
    else
       echo -e "${GREEN}[OK]${NC} Pre-commit hooks em dia."
    fi
  else
    echo -e "${RED}[MISSING]${NC} Pre-commit não encontrado."
  fi

  # Checagem de ferramentas Python independentes via pipx (geralmente usado pro Ansible e utilitários)
  echo -e "--- Python/Pipx ---"
  if command -v pipx >/dev/null 2>&1; then
    if pipx list --short | grep -q '.'; then
      echo -e "${YELLOW}[INFO]${NC} Você gerencia pacotes no pipx. (Considere rodar: 'pipx upgrade-all' preventivamente)."
    fi
  fi

  # Checagem de Snaps (ferramentas como Terraform/AWS CLI às vezes são enfiadas aqui em Linux Desktop)
  echo -e "--- Snap Packages ---"
  if command -v snap >/dev/null 2>&1; then
    local snap_updates
    snap_updates="$(snap refresh --list 2>/dev/null || true)"
    if [[ -z "$snap_updates" || "$snap_updates" == *"All snaps up to date"* ]]; then
      echo -e "${GREEN}[OK]${NC} Snaps em dia."
    else
      echo -e "${YELLOW}[WARN]${NC} Updates disponíveis no Snap. (Rode: 'sudo snap refresh')"
    fi
  fi

  # Checagem de Flatpak
  echo -e "--- Flatpak ---"
  if command -v flatpak >/dev/null 2>&1; then
    if flatpak remote-ls --updates 2>/dev/null | grep -q '.'; then
      echo -e "${YELLOW}[WARN]${NC} Updates de GUI (Flatpak) pendentes. (Rode: 'flatpak update')"
    else
      echo -e "${GREEN}[OK]${NC} Flatpaks em dia."
    fi
  fi
}

print_next_steps() {
  print_header "ROTEIRO DO DIA"
  echo "1. Olhe os cards/issues e defina a entrega de valor real."
  echo "2. Validar o estado atual (make audit) antes de quebrar qualquer coisa."
  echo "3. Registrar progresso em $MANUAL_PATH"
}

# --- EXECUÇÃO: ---
check_docker
check_updates_ubuntu
check_updates_non_native
print_next_steps
echo ""
