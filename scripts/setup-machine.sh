#!/usr/bin/env bash
# Script de Bootstrap para nova maquina.

set -e

# ==============================================================================
# AUTO-ELEVAÇÃO DE PRIVILÉGIO (SUDO) DE FORMA NATIVA E À PROVA DE FALHAS
# ==============================================================================
if [ "$EUID" -ne 0 ]; then
    echo "🔑 Precisamos de permissão administrativa para instalar os componentes base."
    echo "Por favor, insira sua senha se o sistema solicitar:"
    exec sudo -E bash "$0" "$@"
    exit 0
fi

echo "🚀 Iniciando Bootstrap do Workspace DevOps como ROOT..."

# Captura quem é o usuário real para o Ansible poder linkar os dotfiles na pasta correta
REAL_USER="${SUDO_USER:-$USER}"

# 1. Verifica se Ansible está instalado
if ! command -v ansible &> /dev/null; then
    echo "📦 Instalando Ansible..."
    if [ -f /etc/debian_version ]; then
        apt-get update
        apt-get install -y software-properties-common
        apt-add-repository --yes --update ppa:ansible/ansible
        apt-get install -y ansible
    else
        echo "❌ Sistema não suportado automaticamente pelo script."
        exit 1
    fi
else
    echo "✅ Ansible já está instalado."
fi

# 2. Executa o Playbook principal
echo "🛠️ Executando Playbook Ansible para provisionamento da máquina..."
WORKSPACE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$WORKSPACE_DIR"

# Como já somos ROOT, o Ansible tentará rodar o 'become' (sudo) sem precisar de senhas
# O sistema operacional libera acessos de sudo para o ROOT instantaneamente.
ANSIBLE_HOST_KEY_CHECKING=False LC_ALL=C.UTF-8 ansible-playbook ansible/local-setup.yml --extra-vars "user=$REAL_USER"

echo "✨ Setup concluído com sucesso!"
