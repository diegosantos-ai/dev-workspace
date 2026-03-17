# 💻 Spec do Novo Setup (Inventário de Máquina)

> **Aviso:** O "setup visual manual" está obsoleto. A infraestrutura do seu notebook local agora é declarativa (Software-Defined Workstation). Apenas acompanhe a máquina fazendo o trabalho.

## 🚀 Como Provisionar uma Máquina Nova

1. Instale requerimentos mínimos (Git).
2. Clone este repositório base (`dev-workspace`)
3. E rode o inicializador universal:
   ```bash
   make setup
   ```

## 📦 O que o "make setup" (Ansible + Stow) entrega automaticamente:
- **Core OS & Utilitários:** Ferramentas de terminal e manipulação (`curl`, `jq`, `unzip`, `tmux`).
- **Automação & Infra:** CLI de controle de nuvem, ecossistema Python (venv) ativo.
- **Dotfiles & Produtividade:** Configurações de seu Shell (Zsh) e do VS Code (Snippets, Settings, atalhos) lincadas simbolicamente. Modificou num lugar? Versiona automaticamente.

## 🔐 Pós-Setup (Ações Manuais Seguras)
*Aqui reside o que você não pôs na automação pública por segurança:*
- [ ] Geração de Chaves SSH (`ssh-keygen -t ed25519 -C "seu@email.com"`).
- [ ] Recuperar cópia dos secrets de ambiente (Vault, 1Password) injetados restritamente no profile local.
- [ ] Assinar/Autenticar nas CLIs que cobram sessão browser (AWS SSO, Docker Login).
