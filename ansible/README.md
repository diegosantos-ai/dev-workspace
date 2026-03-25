# Módulo: Ansible (Automação de Máquina)

Este diretório contém a inteligência de provisionamento e configuração de estado (Configuration Management) da workstation. Utilizamos Ansible para garantir idempotência e reprodutibilidade do ambiente.

## 📂 Estrutura

- `local-setup.yml`: Playbook principal de provisionamento (Apto/Snap/Stow).
- `scripts/setup-machine.sh`: Script de bootstrap (Instala Ansible e inicia o playbook).
- `vars/`: (Opcional) Variáveis de customização por perfil.

## 🚀 Uso Manual

Geralmente acionado via root `Makefile`:
```bash
make setup-workstation
```

Para rodar o playbook isoladamente (usuários avançados):
```bash
ansible-playbook local-setup.yml --ask-become-pass
```

## ⚠️ Regras de Ouro
1. **Idempotência:** Toda nova task deve poder ser executada 1000x sem erro.
2. **Shift-Left:** Não hardcode senhas. Use variáveis de ambiente.
3. **SO Suportado:** Primariamente distribuições baseadas em Debian/Ubuntu.
