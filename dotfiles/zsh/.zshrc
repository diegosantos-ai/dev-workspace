#!/usr/bin/env zsh
# shellcheck shell=zsh
# ~/.zshrc (Gerenciado via GNU Stow)

# Habilitar autocompletar
autoload -Uz compinit
compinit

# Configurações de Histórico
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory
setopt sharehistory
setopt incappendhistory

# Cores no ls
alias ls='ls --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Prompt simples
PROMPT='%F{green}%n@%m%f:%F{blue}%~%f$ '

# Inicializa o agente SSH, caso ele ainda não esteja rodando
if [ -z "$SSH_AUTH_SOCK" ] ; then
  eval "$(ssh-agent -s)" > /dev/null
fi

# Adiciona a chave SSH automaticamente (se não tiver sido adicionada ainda)
ssh-add ~/.ssh/id_ed25519 2>/dev/null
