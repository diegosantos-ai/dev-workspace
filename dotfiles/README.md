# Módulo: Dotfiles (Configuração de Perfil)

Gestão de arquivos de configuração (dotfiles) utilizando **GNU Stow**. Este método permite que arquivos na home do usuário (`~/.zshrc`, `~/.gitconfig`, etc.) sejam links simbólicos apontando para este repositório.

## 📂 Estrutura

Espelhamos a hierarquia da home do usuário:
- `bash/`: Configurações de shell Bash.
- `git/`: Configurações globais de Git.
- `vscode/`: Extensões e settings do VS Code.
- `zsh/`: Configurações e plugins do Zsh (Oh-My-Zsh).

## 🚀 Como Aplicar

Automático via Ansible:
```bash
make setup-workstation
```

Manual via Stow (Isolado):
```bash
stow --adopt -v -t $HOME bash git zsh
```

## ⚠️ Atenção
O uso da flag `--adopt` pelo Ansible fará com que arquivos locais pré-existentes sejam incorporados ao git se não houver conflito. Sempre revise seu `git status` após um setup.
