#!/usr/bin/env bash

set -u -o pipefail

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

CHECKLIST_PATH="/home/diegosantos/docs/rotina-devops/checklist-manha.md"
MANUAL_PATH="/home/diegosantos/docs/rotina-devops/rotina-devops.md"
LINKS_PATH="/home/diegosantos/docs/rotina-devops/links-uteis.md"
AUDIT_SCRIPT="/home/diegosantos/scripts/check_devops_env.sh"

TOOLS_OK=0
TOOLS_MISSING=0
DOCKER_STATUS="não verificado"
CONTAINERS_RUNNING=0
UPDATES_COUNT=0
REBOOT_STATUS="não"
IMMEDIATE_ACTION="não necessária"
SENSITIVE_UPDATE_FOUND=0

print_header() {
  echo -e "\n${BLUE}========================================${NC}"
  echo -e "${BLUE}$1${NC}"
  echo -e "${BLUE}========================================${NC}"
}

check_simple() {
  local cmd="$1"
  local label="${2:-$1}"

  if command -v "$cmd" >/dev/null 2>&1; then
    echo -e "${GREEN}[OK]${NC} $label"
    TOOLS_OK=$((TOOLS_OK + 1))
  else
    echo -e "${RED}[MISSING]${NC} $label"
    TOOLS_MISSING=$((TOOLS_MISSING + 1))
    IMMEDIATE_ACTION="avaliar pendência crítica"
  fi
}

check_docker() {
  print_header "DOCKER"

  if command -v docker >/dev/null 2>&1; then
    if docker info >/dev/null 2>&1; then
      DOCKER_STATUS="acessível"
      echo -e "${GREEN}[OK]${NC} Docker acessível"
      echo
      echo "Containers em execução:"
      docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

      CONTAINERS_RUNNING="$(docker ps -q | wc -l)"
    else
      DOCKER_STATUS="instalado, mas inacessível"
      echo -e "${YELLOW}[WARN]${NC} Docker instalado, mas inacessível nesta sessão"
      IMMEDIATE_ACTION="avaliar se isso bloqueia o trabalho do dia"
    fi
  else
    DOCKER_STATUS="não encontrado"
    echo -e "${RED}[MISSING]${NC} Docker não encontrado"
  fi
}

print_tool_versions() {
  print_header "GIT"
  if command -v git >/dev/null 2>&1; then
    echo "Versão: $(git --version)"
  fi

  print_header "TERRAFORM"
  if command -v terraform >/dev/null 2>&1; then
    echo "Versão: $(terraform version | head -n 1)"
  fi

  print_header "KUBECTL"
  if command -v kubectl >/dev/null 2>&1; then
    echo "Versão: $(kubectl version --client=true 2>/dev/null | head -n 1)"
  fi
}

check_updates() {
  print_header "MANUTENÇÃO / UPDATES"

  if command -v apt >/dev/null 2>&1; then
    local upgradable_list
    local sensitive_patterns

    upgradable_list="$(apt list --upgradable 2>/dev/null | tail -n +2)"
    UPDATES_COUNT="$(printf '%s\n' "$upgradable_list" | sed '/^$/d' | wc -l)"

    if [[ "$UPDATES_COUNT" -eq 0 ]]; then
      echo -e "${GREEN}[OK]${NC} Sem pacotes pendentes de atualização"
    else
      echo -e "${YELLOW}[WARN]${NC} $UPDATES_COUNT pacote(s) podem ser atualizados"
      echo "Pacotes:"
      printf '%s\n' "$upgradable_list" | cut -d/ -f1 | head -n 10 | sed 's/^/ - /'
      echo "Sugestão: revisar em janela de manutenção, não no impulso."

      sensitive_patterns='docker|containerd|terraform|kubectl|linux-image|linux-headers|openssl|systemd|coreutils'

      if printf '%s\n' "$upgradable_list" | cut -d/ -f1 | grep -Eqi "$sensitive_patterns"; then
        SENSITIVE_UPDATE_FOUND=1
        echo -e "${YELLOW}[WARN]${NC} Há update em componente sensível do ambiente"
      fi
    fi
  else
    echo -e "${YELLOW}[WARN]${NC} apt não disponível para checagem de updates"
  fi

  if [[ -f /var/run/reboot-required ]]; then
    REBOOT_STATUS="sim"
    echo -e "${YELLOW}[WARN]${NC} Reinicialização recomendada pelo sistema"
    IMMEDIATE_ACTION="avaliar janela de reinicialização"
  else
    REBOOT_STATUS="não"
    echo -e "${GREEN}[OK]${NC} Nenhuma reinicialização pendente"
  fi
}

print_documents() {
  print_header "DOCUMENTOS DE ROTINA"
  echo "Checklist : $CHECKLIST_PATH"
  echo "Manual    : $MANUAL_PATH"
  echo "Links     : $LINKS_PATH"
}

print_next_steps() {
  print_header "PRÓXIMOS PASSOS"
  echo "1. Abrir o checklist da manhã"
  echo "2. Revisar o projeto principal do dia"
  echo "3. Validar o estado atual antes de editar qualquer coisa"
  echo "4. Definir uma entrega principal"
  echo "5. Registrar o próximo passo antes de trocar de contexto"
}

print_useful_commands() {
  print_header "COMANDOS ÚTEIS"
  echo "Abrir checklist : xdg-open \"$CHECKLIST_PATH\""
  echo "Abrir manual    : xdg-open \"$MANUAL_PATH\""
  echo "Auditar máquina : $AUDIT_SCRIPT"
}

print_summary() {
  local environment_status

  if [[ "$TOOLS_MISSING" -eq 0 ]]; then
    environment_status="pronto para trabalho"
  else
    environment_status="atenção necessária"
  fi

  print_header "RESUMO FINAL"
  echo "Ambiente           : $environment_status"
  echo "Ferramentas OK     : $TOOLS_OK"
  echo "Ferramentas faltando: $TOOLS_MISSING"
  echo "Docker             : $DOCKER_STATUS"
  echo "Containers ativos  : $CONTAINERS_RUNNING"
  echo "Updates pendentes  : $UPDATES_COUNT"
  echo "Reboot pendente    : $REBOOT_STATUS"

  if [[ "$SENSITIVE_UPDATE_FOUND" -eq 1 ]]; then
    echo "Componente sensível: sim"
  else
    echo "Componente sensível: não"
  fi

  echo "Ação imediata      : $IMMEDIATE_ACTION"
}

print_header "ROTINA DEVOPS — INÍCIO DO DIA"

echo "Data/Hora : $(date)"
echo "Usuário   : $(whoami)"
echo "Host      : $(hostname)"
echo "Diretório : $(pwd)"

print_header "FERRAMENTAS PRINCIPAIS"
check_simple git "Git"
check_simple docker "Docker"
check_simple terraform "Terraform"
check_simple kubectl "kubectl"
check_simple python3 "Python 3"

check_docker
print_tool_versions
check_updates
print_documents
print_next_steps
print_useful_commands
print_summary

echo
echo -e "${GREEN}Rotina da manhã carregada.${NC}"
echo -e "${YELLOW}Comece entendendo o estado atual. Não comece no impulso.${NC}"
