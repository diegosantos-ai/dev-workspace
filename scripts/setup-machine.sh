#!/usr/bin/env bash
# Script de Bootstrap para nova maquina.

set -e

echo "🚀 Iniciando Bootstrap do Workspace DevOps..."

# PRE-CACHE DO SUDO (Resolve o bug de Timeout do Ansible)
echo "🔑 Precisamos de permissão administrativa para instalar os pacotes."
echo "Por favor, digite sua senha caso seja solicitada pelo Terminal:"
sudo -v

# Mantem o sudo vivo enquanto o script roda
(while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null) &

# 1. Verifica se Ansible está instalado
if ! command -v ansible &> /dev/null; then
    echo "📦 Instalando Ansible..."
    if [ -f /etc/debian_version ]; then
        sudo apt-get update
        sudo apt-get install -y software-properties-common
        sudo apt-add-repository --yes --update ppa:ansible/ansible
        sudo apt-get install -y ansible
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

# EXECUTA SEM -K (pois o sudo já está ativo no cache da máquina)
ANSIBLE_HOST_KEY_CHECKING=False LC_ALL=C.UTF-8 ansible-playbook ansible/local-setup.yml

echo "✨ Setup concluído com sucesso!"
