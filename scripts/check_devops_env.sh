#!/usr/bin/env bash

set -u -o pipefail

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

OK_COUNT=0
WARN_COUNT=0
MISSING_COUNT=0

print_header() {
  echo -e "\n${BLUE}========================================${NC}"
  echo -e "${BLUE}$1${NC}"
  echo -e "${BLUE}========================================${NC}"
}

mark_ok() {
  OK_COUNT=$((OK_COUNT + 1))
}

mark_warn() {
  WARN_COUNT=$((WARN_COUNT + 1))
}

mark_missing() {
  MISSING_COUNT=$((MISSING_COUNT + 1))
}

check_cmd() {
  local cmd="$1"
  local label="${2:-$1}"
  local version_cmd="${3:-}"

  if command -v "$cmd" >/dev/null 2>&1; then
    echo -e "${GREEN}[OK]${NC} $label"
    mark_ok
    if [[ -n "$version_cmd" ]]; then
      local version_output
      version_output=$(bash -lc "$version_cmd" 2>/dev/null | head -n 1 || true)
      if [[ -n "$version_output" ]]; then
        echo "     $version_output"
      fi
    fi
  else
    echo -e "${RED}[MISSING]${NC} $label"
    mark_missing
  fi
}

check_file() {
  local path="$1"
  local label="$2"

  if [[ -e "$path" ]]; then
    echo -e "${GREEN}[OK]${NC} $label -> $path"
    mark_ok
  else
    echo -e "${RED}[MISSING]${NC} $label -> $path"
    mark_missing
  fi
}

check_warn() {
  local message="$1"
  echo -e "${YELLOW}[WARN]${NC} $message"
  mark_warn
}

check_venv_support() {
  if python3 -m venv --help >/dev/null 2>&1; then
    echo -e "${GREEN}[OK]${NC} python3 venv funcional"
    mark_ok
  else
    echo -e "${RED}[MISSING]${NC} python3 venv não funcional"
    mark_missing
  fi
}

check_python_path() {
  if command -v python3 >/dev/null 2>&1; then
    echo "     python3 -> $(command -v python3)"
  fi
  if command -v pip3 >/dev/null 2>&1; then
    echo "     pip3    -> $(command -v pip3)"
  fi
  if command -v pipx >/dev/null 2>&1; then
    echo "     pipx    -> $(command -v pipx)"
  fi
}

check_github_ssh() {
  if [[ -f "$HOME/.ssh/id_ed25519.pub" || -f "$HOME/.ssh/id_rsa.pub" ]]; then
    echo -e "${GREEN}[OK]${NC} Chave SSH encontrada"
    mark_ok
  else
    echo -e "${YELLOW}[WARN]${NC} Nenhuma chave SSH comum encontrada em ~/.ssh"
    mark_warn
  fi
}

check_docker_access() {
  if ! command -v docker >/dev/null 2>&1; then
    return
  fi

  local in_group="no"
  local docker_status="unknown"
  local docker_error=""

  if id -nG "$USER" 2>/dev/null | tr ' ' '\n' | grep -qx docker; then
    in_group="yes"
  fi

  docker_error=$(docker info >/dev/null 2>&1; echo $?)
  docker_status="$docker_error"

  if [[ "$docker_status" == "0" ]]; then
    echo -e "${GREEN}[OK]${NC} Docker acessível para o usuário atual"
    mark_ok
    if [[ "$in_group" == "yes" ]]; then
      echo "     Usuário no grupo docker: sim"
    else
      echo "     Usuário no grupo docker: não"
      echo "     Observação: acesso funcionando por outro contexto/sessão"
    fi
    return
  fi

  echo -e "${YELLOW}[WARN]${NC} Docker instalado, mas inacessível nesta sessão"
  mark_warn

  if [[ "$in_group" == "yes" ]]; then
    echo "     Usuário no grupo docker: sim"
    echo "     Provável causa: sessão não recarregada corretamente ou daemon com problema"
  else
    echo "     Usuário no grupo docker: não"
    echo "     Ação: sudo usermod -aG docker \$USER"
    echo "     Depois faça logout/login completo"
  fi

  local err_text
  err_text=$(docker info 2>&1 >/dev/null || true)
  if [[ -n "$err_text" ]]; then
    echo "     Erro: $err_text"
  fi
}

print_header "SISTEMA"
echo "Usuário: $(whoami)"
echo "Host: $(hostname)"
echo "Kernel: $(uname -srmo)"
if [[ -f /etc/os-release ]]; then
  # shellcheck disable=SC1091
  . /etc/os-release
  echo "Distribuição: ${PRETTY_NAME:-desconhecida}"
fi

print_header "BASE"
check_cmd curl "curl" "curl --version"
check_cmd wget "wget" "wget --version"
check_cmd git "git" "git --version"
check_cmd vim "vim" "vim --version"
check_cmd nano "nano" "nano --version"
check_cmd htop "htop" "htop --version"
check_cmd tree "tree" "tree --version"
check_cmd jq "jq" "jq --version"
check_cmd zip "zip" "zip -v"
check_cmd unzip "unzip" "unzip -v"
check_cmd make "make" "make --version"

print_header "PYTHON"
check_cmd python3 "python3" "python3 --version"
check_cmd pip3 "pip3" "pip3 --version"
check_cmd pipx "pipx" "pipx --version"
check_venv_support
check_python_path

print_header "NODE"
check_cmd node "node" "node --version"
check_cmd npm "npm" "npm --version"

print_header "BANCO / DADOS"
check_cmd psql "PostgreSQL client" "psql --version"
check_cmd dbeaver "DBeaver" "dbeaver --version"

print_header "DOCKER"
check_cmd docker "Docker" "docker --version"
check_cmd docker "Docker Compose plugin" "docker compose version"
check_docker_access

print_header "GITHUB / SSH"
check_cmd ssh "OpenSSH client" "ssh -V 2>&1"
check_cmd ssh-keygen "ssh-keygen"
check_cmd gh "GitHub CLI" "gh --version"
check_github_ssh
check_file "$HOME/.gitconfig" "Arquivo ~/.gitconfig"

print_header "APIS"
check_cmd http "HTTPie" "http --version"
check_cmd insomnia "Insomnia" "insomnia --version"

print_header "REDE / DIAGNÓSTICO"
check_cmd ss "ss" "ss --version"
check_cmd lsof "lsof"
check_cmd nc "netcat"
check_cmd dig "dig" "dig -v"
check_cmd ping "ping" "ping -V"
check_cmd traceroute "traceroute" "traceroute --version"

print_header "INFRA / CLOUD"
check_cmd terraform "Terraform" "terraform version"
check_cmd aws "AWS CLI" "aws --version"
check_cmd kubectl "kubectl" "kubectl version --client=true"

print_header "QUALIDADE DE VIDA"
check_cmd tmux "tmux" "tmux -V"
check_cmd rg "ripgrep" "rg --version"
check_cmd fzf "fzf" "fzf --version"
check_cmd batcat "batcat" "batcat --version"
check_cmd bat "bat" "bat --version"

print_header "RESUMO"
echo -e "${GREEN}OK:${NC} $OK_COUNT"
echo -e "${YELLOW}WARN:${NC} $WARN_COUNT"
echo -e "${RED}MISSING:${NC} $MISSING_COUNT"
