#!/usr/bin/env bash
# Script de Bootstrap para nova maquina.
# Objetivo: Apenas preparar o terreno para o Ansible assumir o controle.

set -e

echo "🚀 Iniciando Bootstrap do Workspace DevOps..."

# 1. Verifica se Ansible está instalado
if ! command -v ansible &> /dev/null; then
    echo "📦 Instalando Ansible..."
    if [ -f /etc/debian_version ]; then
        sudo apt-get update
        sudo apt-get install -y software-properties-common
        sudo apt-add-repository --yes --update ppa:ansible/ansible
        sudo apt-get install -y ansible
    else
        echo "❌ Sistema não suportado automaticamente pelo script. Por favor adicione suporte."
        exit 1
    fi
else
    echo "✅ Ansible já está instalado."
fi

# 2. Executa o Playbook principal
echo "🛠️ Executando Playbook Ansible para provisionamento da máquina..."
WORKSPACE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$WORKSPACE_DIR"

ANSIBLE_HOST_KEY_CHECKING=False LC_ALL=C.UTF-8 ansible-playbook ansible/local-setup.yml -K

echo "✨ Setup concluído com sucesso!"
