#!/usr/bin/env bash
# Bootstrap script for local machine.

set -e

echo "Starting Workspace DevOps bootstrap..."

if [ "$EUID" -ne 0 ]; then
    echo "Administrative privileges required to install base components."
    REAL_SCRIPT="$(realpath "${BASH_SOURCE[0]}")"
    exec sudo -E bash "$REAL_SCRIPT" "$@"
    exit 0
fi

REAL_USER="${SUDO_USER:-$USER}"

if ! command -v ansible &> /dev/null; then
    echo "Installing Ansible..."
    if [ -f /etc/debian_version ]; then
        apt-get update
        apt-get install -y software-properties-common
        apt-add-repository --yes --update ppa:ansible/ansible
        apt-get install -y ansible
    else
        echo "Error: System not supported automatically."
        exit 1
    fi
else
    echo "Ansible is already installed."
fi

echo "Executing Ansible Playbook..."
WORKSPACE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$WORKSPACE_DIR"

ANSIBLE_HOST_KEY_CHECKING=False LC_ALL=C.UTF-8 ansible-playbook ansible/local-setup.yml --extra-vars "user=$REAL_USER"

echo "Setup concluido."
