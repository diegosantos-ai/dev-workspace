#!/usr/bin/env bash

set -u

# ==========================================
# Auditoria básica de ambiente Linux DevOps
# ==========================================

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

print_header() {
  echo -e "\n${BLUE}========================================${NC}"
  echo -e "${BLUE}$1${NC}"
  echo -e "${BLUE}========================================${NC}"
}

check_cmd() {
  local cmd="$1"
  local label="${2:-$1}"
  local version_cmd="${3:-}"

  if command -v "$cmd" >/dev/null 2>&1; then
    echo -e "${GREEN}[OK]${NC} $label"
    if [[ -n "$version_cmd" ]]; then
      local version_output
      if command -v timeout >/dev/null 2>&1; then
        version_output=$(timeout 3 bash -lc "$version_cmd" 2>/dev/null | head -n 1 || true)
      else
        version_output=$(bash -lc "$version_cmd" 2>/dev/null | head -n 1 || true)
      fi
      if [[ -n "$version_output" ]]; then
        echo "     $version_output"
      fi
    fi
  else
    echo -e "${RED}[MISSING]${NC} $label"
  fi
}

check_file() {
  local path="$1"
  local label="$2"

  if [[ -e "$path" ]]; then
    echo -e "${GREEN}[OK]${NC} $label -> $path"
  else
    echo -e "${RED}[MISSING]${NC} $label -> $path"
  fi
}

check_docker_access() {
  if command -v docker >/dev/null 2>&1; then
    if docker info >/dev/null 2>&1; then
      echo -e "${GREEN}[OK]${NC} Docker acessível para o usuário atual"
    else
      echo -e "${YELLOW}[WARN]${NC} Docker instalado, mas sem acesso direto ou daemon parado"
      echo "     Dica: verifique se o serviço está rodando e se seu usuário está no grupo docker"
    fi
  fi
}

check_docker_compose_plugin() {
  if ! command -v docker >/dev/null 2>&1; then
    return
  fi

  # Detecta o subcomando sem depender do daemon.
  if docker --help 2>/dev/null | grep -qE '^[[:space:]]+compose[[:space:]]'; then
    local compose_ver
    compose_ver=$(docker compose version 2>/dev/null | head -n1 || true)
    if [[ -n "$compose_ver" ]]; then
      echo -e "${GREEN}[OK]${NC} Docker Compose plugin"
      echo "     $compose_ver"
    else
      echo -e "${GREEN}[OK]${NC} Docker Compose plugin (subcomando disponível)"
    fi
  else
    echo -e "${RED}[MISSING]${NC} Docker Compose plugin"
  fi
}

# Detecta DBeaver (CLI, processo em execução ou entrada .desktop)
check_dbeaver() {
  if command -v dbeaver >/dev/null 2>&1 || command -v dbeaver-ce >/dev/null 2>&1; then
    echo -e "${GREEN}[OK]${NC} DBeaver (CLI disponível)"
    local ver
    ver=$(bash -lc "dbeaver --version 2>/dev/null || dbeaver-ce --version 2>/dev/null" | head -n 1)
    [[ -n "$ver" ]] && echo "     $ver"
    return
  fi

  if pgrep -f '[d]beaver' >/dev/null 2>&1; then
    echo -e "${GREEN}[OK]${NC} DBeaver (processo em execução)"
    return
  fi

  if ls /usr/share/applications/*dbeaver*.desktop >/dev/null 2>&1 || ls ~/.local/share/applications/*dbeaver*.desktop >/dev/null 2>&1; then
    echo -e "${GREEN}[OK]${NC} DBeaver (desktop entry encontrado)"
    return
  fi

  echo -e "${RED}[MISSING]${NC} DBeaver"
}

# Detecta Docker Desktop especificamente, ou indicação de Docker Engine/CLI
check_docker_desktop() {
  # Se existir o CLI do docker, verifica se parece ser Docker Desktop
  if command -v docker >/dev/null 2>&1; then
    if systemctl list-units --type=service --no-legend | grep -qi 'docker-desktop'; then
      echo -e "${GREEN}[OK]${NC} Docker Desktop (service docker-desktop encontrado)"
      return
    fi

    if pgrep -f 'com.docker' >/dev/null 2>&1 || pgrep -f 'Docker Desktop' >/dev/null 2>&1; then
      echo -e "${GREEN}[OK]${NC} Docker Desktop (processo em execução)"
      return
    fi

    if [[ -f /usr/share/applications/com.docker.docker.desktop ]] || [[ -f ~/.local/share/applications/com.docker.docker.desktop ]]; then
      echo -e "${GREEN}[OK]${NC} Docker Desktop (desktop entry encontrado)"
      return
    fi

    # Se nada indicar Desktop, mas docker existe, sinaliza ausência do Desktop.
    echo -e "${RED}[MISSING]${NC} Docker Desktop"
    echo "     Docker Engine/CLI detectado no sistema"
    local v
    v=$(docker --version 2>/dev/null || true)
    [[ -n "$v" ]] && echo "     $v"
  else
    # Tenta detectar Docker Desktop sem o CLI (casos raros)
    if systemctl list-units --type=service --no-legend | grep -qi 'docker-desktop' || pgrep -f 'com.docker' >/dev/null 2>&1 || [[ -f /usr/share/applications/com.docker.docker.desktop ]] || [[ -f ~/.local/share/applications/com.docker.docker.desktop ]]; then
      echo -e "${GREEN}[OK]${NC} Docker Desktop (instalado, docker CLI não encontrado)"
      return
    fi

    echo -e "${RED}[MISSING]${NC} Docker Desktop / Docker CLI"
  fi
}

check_github_ssh() {
  if [[ -f "$HOME/.ssh/id_ed25519.pub" || -f "$HOME/.ssh/id_rsa.pub" ]]; then
    echo -e "${GREEN}[OK]${NC} Chave SSH encontrada"
  else
    echo -e "${YELLOW}[WARN]${NC} Nenhuma chave SSH comum encontrada em ~/.ssh"
  fi
}

check_venv_support() {
  if python3 -m venv --help >/dev/null 2>&1; then
    echo -e "${GREEN}[OK]${NC} python3 venv funcional"
  else
    echo -e "${RED}[MISSING]${NC} python3 venv não funcional"
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

print_header "SISTEMA"
echo "Usuário: $(whoami)"
echo "Host: $(hostname)"
echo "Kernel: $(uname -srmo)"
if [[ -f /etc/os-release ]]; then
  . /etc/os-release
  echo "Distribuição: ${PRETTY_NAME:-desconhecida}"
fi

print_header "BASE"
check_cmd curl "curl"
check_cmd wget "wget"
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
check_dbeaver

print_header "DOCKER"
check_docker_desktop
if command -v docker >/dev/null 2>&1; then
  check_cmd docker "Docker" "docker --version"
  check_docker_compose_plugin
  check_docker_access
fi

print_header "GITHUB / SSH"
check_cmd ssh "OpenSSH client" "ssh -V"
check_cmd ssh-keygen "ssh-keygen"
check_cmd gh "GitHub CLI" "gh --version"
check_github_ssh
check_file "$HOME/.gitconfig" "Arquivo ~/.gitconfig"

print_header "APIS"
check_cmd curl "curl"
check_cmd http "HTTPie" "http --version"
check_cmd insomnia "Insomnia" "insomnia --version"

print_header "REDE / DIAGNÓSTICO"
check_cmd ss "ss" "ss --version"
check_cmd lsof "lsof" "lsof -v"
check_cmd nc "netcat" "nc -h"
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
echo -e "${GREEN}OK${NC} = instalado"
echo -e "${RED}MISSING${NC} = não encontrado"
echo -e "${YELLOW}WARN${NC} = encontrado, mas merece validação"
