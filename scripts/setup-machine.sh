#!/usr/bin/env bash
# Script de Bootstrap para nova maquina.

set -e

echo "🚀 Iniciando Bootstrap do Workspace DevOps..."

# LÊ A SENHA VIA BASH PARA BYPASS NO BUG DE PROMPT DO ANSIBLE
echo "🔑 Precisamos de permissão administrativa para instalar os pacotes vitais."
read -r -s -p "Digite a senha do sudo (ela ficará invisível na tela): " SUDO_PWD
echo ""

# 1. Verifica se Ansible está instalado
if ! command -v ansible &> /dev/null; then
    echo "📦 Instalando Ansible..."
    if [ -f /etc/debian_version ]; then
        # Usa a senha lida para instalar o ansible caso não exista
        echo "$SUDO_PWD" | sudo -S apt-get update
        echo "$SUDO_PWD" | sudo -S apt-get install -y software-properties-common
        echo "$SUDO_PWD" | sudo -S apt-add-repository --yes --update ppa:ansible/ansible
        echo "$SUDO_PWD" | sudo -S apt-get install -y ansible
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

# INJETA A SENHA DIRETAMENTE NAS VARIÁVEIS, ZERO PROMPTS DEPOIS DAQUI
ANSIBLE_HOST_KEY_CHECKING=False LC_ALL=C.UTF-8 ansible-playbook ansible/local-setup.yml --extra-vars "ansible_become_pass=$SUDO_PWD"

echo "✨ Setup concluído com sucesso!"
